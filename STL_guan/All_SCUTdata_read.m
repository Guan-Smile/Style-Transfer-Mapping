%%   temp_cross_validation
clear all;clc;
dbstop if error
datapath = 'E:\data\code\SCUTBCI_test\emotion_data\';
%%%%original data
namelist = dir([datapath '*.cnt']);
All_name={namelist.name};%%%所有cnt文件的名字
ALL_data=[];
ALL_data_test=[];
for cont=1:size(All_name,2)
%     foruse=load([datapath All_name(cont,:)]);
% name_chang_part='emotion_60s_chenbinchao_20180808_1';  01/03/05/08/730/726
name_chang=char(All_name(cont));
name_chang_part=name_chang(1:end-4)
dataname = [ name_chang_part '.cnt'];  %or = name_chang
datasource = {  [datapath dataname ]   };

fs = 250;
subject = name_chang_part(13:end-11);
methods = {'svm'};

numMethods = length(methods);
% numWinLen = 6;
std_means = {'zscore_trial' 'svmscale'  'mapminmax' 'zscore' 'none'};
numStd = length(std_means);
numFolds =5;
feature_extract_method = 'DE';


modelfile = ['models/' subject '_emotion_svm_model'];



% order = 10;
% fstop1 = 0;    % First Stopband Frequency
% fpass1 = 0.5;  % First Passband Frequency
% fpass2 = 30;   % Second Passband Frequency
% fstop2 = 30.5;   % Second Stopband Frequency
% wstop1 = 1;    % First Stopband Weight
% wpass  = 1;    % Passband Weight
% wstop2 = 2;    % Second Stopband Weight
% dens  = 20;     % Density Factor
% 
% b  = firpm(order, [0 fstop1 fpass1 fpass2 fstop2 fs/2]/(fs/2), [0 0 1 1 0 ...
%     0], [wstop1 wpass wstop2], {dens});
% hdfilter = dfilt.dffir(b);

% band =[0 0.1 70 71 ];
% [B,A] = Filter_Design(fs,band);

f1 = 0.1;
f2 = 70;
order = 6;
h  = fdesign.bandpass('N,F3dB1,F3dB2', order, f1, f2, fs);
hdfilter = design(h, 'butter');
%%%%%%%%%%%%%%%%%
%S = filter(hdfilter, S);
[source_signal,base_line,target,clab] = readData_G(datasource,60,  hdfilter);
[source_signal,base_line,target]=windows_cutting(source_signal,base_line,target,10*fs,13*fs);%窗长，滑动时长
numTrials = length(target);
numChannels = size(source_signal{1},2);

% channel selection
%for count = 1 :96
%channelSelected =[7,12,17,22,28];
% channelSelected =[3
% 3
% 8
% 7
% 12
% 13
% 18
% 17
% 22
% 23
% 29
% 28
% 29
% 34
% 35
% 30
% 4
% 10
% 9
% 10
% 11
% 16
% 15
% 19
% 20
% 21
% 26
% 25
% 31
% 32
% 31
% 36
% ];
channelSelected =[3:4,7:17,19:26,28:29 31:32,34:36];
numChannels = length(channelSelected);

% accuracyTrain = zeros(numWinLen,numStd, numFolds, numMethods);
% for i =1:15
%    time(i ) = length( source_signal{ i} )/250  
% end
% for window = 1:1%%%%%numWinLen                 %%%%%%%%%%%%%需要加上！！！！
   % for window = 5:6

feature_all=[];

for trial =1:numTrials
    epoch = source_signal{trial};   
    epoch = epoch(:,channelSelected)'; 
    base_epoch = base_line{trial}'; 
    base_value = mean( squeeze(base_epoch(channelSelected,:)) ,2);%base_value 
    epoch_std = epoch - repmat(base_value,1,size(epoch,2));   % remove base_value
    %temp_filter = filter(hdfilter, epoch_std');
    epoch_std_filtered = epoch_std;
    % no need to remove the basevalue
        % EMD method to reconstruct the signal
         %     reconstruct_signal = EMD_operate(epoch_std,1);% 2_ FDFF ; 1_EFF;
%********************************************
window_length = [1*fs 2*fs 3*fs 5*fs 10*fs length(epoch_std_filtered) ];

%********************************************
        %% ============extract feature   channel*point
         if strcmp(feature_extract_method, 'DE')
            % trial_feature =   extract_DE_feature(epoch,Fs,selected_band); 
            %[diff_entropy rasm_feature] = extract_DE_CV(epoch_std_filtered,fs,window_length(window));
%             [diff_entropy ] = extract_DE_CV(epoch_std_filtered,fs,window_length(window));
             [diff_entropy,rasm_feature] = extract_DE_new(epoch_std_filtered,fs);
            trial_feature  =    diff_entropy;
         elseif strcmp(feature_extract_method, 'statistic')
             trial_feature =   extract_statistic_feature(epoch); 
         elseif strcmp(feature_extract_method, 'psd')
             trial_feature =   extract_PSD_new(epoch_std, fs);%1 hanning window
         end       
         feature_all =[feature_all;trial_feature];  
end

 label=[];
 for i=1:numTrials  
     if(rem(target(i),3) == 1)%%NEG
         label(i)= 0;
     else if(rem(target(i),3) == 0 ) %%POS
             label(i) =1;
         else if(rem(target(i),3) == 2)%%NEU
                 label(i)=2;%%%平静为2
             end
         end
     end
 end
 
for std_idx = 1:1%numStd                   %%%%%%%%%%%%%需要加上！！！！
    test_index = find(abs(label)<=1);
%for std_idx = 4:4
dataAll = std_feature(feature_all(test_index,:),std_means{std_idx}); 
targetAll = label(test_index)';
  
numTotal = (length(test_index));
numTest = floor(numTotal/numFolds);
numTrain = numTotal - numTest;

%  indexTotal = randperm(numTotal); %乱序 
   indexTotal = 1:numTotal; %正序
    for fold = 1:1%numFolds             %%%%%%%%%%%%%需要加上！！！！
        disp(['fold ' num2str(fold)]);
        
        indexTest = indexTotal((fold-1)*numTest+1:fold*numTest);
        indexTrain = setdiff(indexTotal,indexTest);
                     
        X = dataAll(indexTrain,:);
        Y = targetAll(indexTrain);
        FOR_TRAIN=[X,Y];
      X_test = dataAll(indexTest,:);
      Y_test = targetAll(indexTest);
      FOR_TEST=[X_test,Y_test];
        
      %%  save X,Y
     %  name_chang_part='emotion_60s_chenbinchao_20180801_1';
       mat_name = [name_chang_part '.mat'];
       mat_datapath = '..\mat_data\';
      mat_path = [mat_datapath subject '\' mat_name ];
     %subject=name_chang_part(13:end-11)'文件夹名称'
%       save(mat_path,'FOR_TRAIN','FOR_TEST')%%%%
      
%       mkdir(mat_datapath,subject)
%       save(mat_path,'FOR_TRAIN','FOR_TEST')%%%%%%
      ALL_data =[ALL_data;FOR_TRAIN];
      ALL_data_test=[ALL_data_test;FOR_TEST];

end
    
end
end
% end

      %%
        
%    
%         disp('training models');
%         
%         
%                     svmoption = ['-s 0 -t 0 -c 1 -g 0.001 -b 1'];
%                     svmmodel = svmtrain(Y,X,svmoption);
%                     model = svmmodel;
%                
%             
%      
%         
%                 disp('classifying');
%         
%         targetTrue = targetAll(indexTest);
%         targetPredicted = zeros(numMethods, numTest);         
%                 X = dataAll(indexTest,:);
%                 Y = zeros(numTest,1);    
%                 
%                 [predict_label,predict_accuracy,predict_decvalue] = svmpredict(Y,X, svmmodel,['-b 1']);
%                 targetPredicted = predict_label;
%                            
%                  Y_predict = predict_label;
%                  accuracyTrain(window,std_idx,fold)= length(find(squeeze(targetPredicted) == targetTrue))/numTest;
%          end
%          
%         
%         
%     end
% end
%     accuracyTrain=mean(accuracyTrain,3);
%     
%     
