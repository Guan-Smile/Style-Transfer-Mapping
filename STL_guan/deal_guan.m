%% 变为序列长度相同的
clear
datapath = 'E:\data\data2\';
%%%%original data
namelist = dir([datapath '*.mat']);
All_name={namelist.name};%%%所有cnt文件的名字
% f_d=zeros(62,1,5);%zeros(5,1,5);
coon=2;%自己的数据是1，WC的数据coon=2
% channelSelected =[3:4,7:17,19:26,28:29 31:32,34:36];
feature_extract_method = 'DE';
fs = 250;
f1 = 0.1;
f2 = 70;
order = 6;
h  = fdesign.bandpass('N,F3dB1,F3dB2', order, f1, f2, fs);
hdfilter = design(h, 'butter');
winlen=1*fs;
slidelen=1*fs;


for jj = 1:length(All_name)

     source_signal=load([datapath All_name{jj}]);
for  ii= 1:size(source_signal.data,coon)   %ii=trial数，搜索最小的数据长度
%    temp(:,:,ii) = data{ii};
   sqe(ii)=size(source_signal.data{ii},2);     
end
% disp('最短序列长度：')
leng = 15000;%min(sqe)

for  ii= 1:size(source_signal.data,coon)%裁切为15000%min(sqe)一段
   temp(:,:,ii) = source_signal.data{ii}(:,end-leng+1:end);% 30*15672*30  通道，数据长度，trail数。
   detrend_sdata = detrend(source_signal.data{ii}(:,end-leng+1:end));%去趋势是否去？存疑？
   temp2(:,:,ii) = source_signal.data{ii}(:,end-leng+1:end) - detrend_sdata;
   temp=temp;
end
   [source_signal_cut,target_cut]=windows_cutting_G(temp,source_signal.label,winlen,slidelen);
%    plot(source_signal_cut{88}','DisplayName','ans')
feature_all=[];
for trial =1:length(target_cut)   %裁剪的小段单独处理
    epoch = source_signal_cut{trial};   
%     epoch = epoch(:,channelSelected)'; 
    base_value = mean( epoch ,2);%base_value 
    epoch_std = epoch - repmat(base_value,1,size(epoch,2));   % remove base_value
    %temp_filter = filter(hdfilter, epoch_std');
    epoch_std_filtered = epoch_std;
    % no need to remove the basevalue
        % EMD method to reconstruct the signal
         %     reconstruct_signal = EMD_operate(epoch_std,1);% 2_ FDFF ; 1_EFF;
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
         feature_all =[feature_all;zscore(trial_feature)];  
end

% Source_Data_A(jj,:,:) = feature_all;
[pos1]=find(target_cut==1);
feature_all1=feature_all(pos1,:);
[pos2]=find(target_cut==2);
feature_all2=feature_all(pos2,:);
[pos3]=find(target_cut==3);
feature_all3=feature_all(pos3,:);

train_count=(floor((size(squeeze(temp(:,:,3)),2) - 10*fs)/3/fs)+1)*3;
mix_train_X=[feature_all1(1:train_count,:);feature_all2(1:train_count,:);feature_all3(1:train_count,:)];
mix_train_Y=[feature_all1(1:train_count,1)*0+1*1;feature_all2(1:train_count,1)*0+1*2;feature_all3(1:train_count,1)*0+1*3];
test_count=train_count;
mix_test_X=[feature_all1(test_count+1:end,:);feature_all2(test_count+1:end,:);feature_all3(test_count+1:end,:)]
mix_test_Y=[feature_all1(test_count+1:end,1)*0+1*1;feature_all2(test_count+1:end,1)*0+1*2;feature_all3(test_count+1:end,1)*0+1*3]
svmoption = ['-s 0 -t 0 -c 1 -g 0.001 -b 1'];   
%svmoption = ['-s 0 -t 0 -c 1 -g 0.001'];   
svmmodel = svmtrain(mix_train_Y,(mix_train_X),svmoption);
model = svmmodel;
[predict_label,predict_accuracy,predict_decvalue] = svmpredict(mix_test_Y,(mix_test_X), svmmodel);
Acc(:,jj)=predict_accuracy
Feature_sb{jj,1}=feature_all1;
Feature_sb{jj,2}=feature_all2;
Feature_sb{jj,3}=feature_all3;
end


% %% 作出时频图。
% for trail=1:size(temp,3)
% data_view = squeeze(temp(:,:,trail));
% label(trail) = source_signal.label(trail);
% for channel = 1 :size(temp,1)
%     
% % Parameters
% timeLimits = [0 59.996]; % seconds
% frequencyLimits = [0 50]; % Hz
% voicesPerOctave = 8;
% 
% %%
% % Index into signal time region of interest
% data_view_14_ROI = data_view(channel,:);
% sampleRate = 250; % Hz
% startTime = 0; % seconds
% timeValues = startTime + (0:length(data_view_14_ROI)-1).'/sampleRate;
% minIdx = timeValues >= timeLimits(1);
% maxIdx = timeValues <= timeLimits(2);
% data_view_14_ROI = data_view_14_ROI(minIdx&maxIdx);
% timeValues = timeValues(minIdx&maxIdx);
% 
% 
% 
% %%
% % Limit the cwt frequency limits
% frequencyLimits(1) = max(frequencyLimits(1),...
%     cwtfreqbounds(numel(data_view_14_ROI),sampleRate));
% 
% 
% % Compute cwt
% % Run the function call below without output arguments to plot the results
% [WT,F] = cwt(data_view_14_ROI,sampleRate, ...
%     'VoicesPerOctave',voicesPerOctave, ...
%     'FrequencyLimits',frequencyLimits);
% 
% %     margin{trail}(1,channel,:)=abs(sum(WT(1:5,)));%d单个trail的margin
%     margin{trail}(:,channel,:) =abs(WT);
%     phase{trail}(:,channel,:) =angle(WT);
% 
% % plot(data_view(3,1:10000))
% % hold on
% % plot(data_view2(3,1:10000))
% % legend('ori','new')
% end
%     
%     band(1, :) = [1 3];%[2 3.8];% delta band
%     band(2, :) = [4 7];% theta band
%     band(3, :) = [8 13];% alpha band
%     band(4, :) = [14 30];% beta band
%     band(5, :) = [31 48];% gamma band
% %    band(1, :) = [1 13];%[2 3.8];% delta band
% %     band(2, :) = [14 48];% theta band
% %     band(3, :) = [1 20];% alpha band
% %     band(4, :) = [20 48];% beta band
% %     band(5, :) = [10 20];% gamma band
%     for i = 1:size(band,1)%分段
%         idx{i} = find( F>=band(i, 1) & F<=band(i, 2) );
%        % psd(1, i) = mean( Pxx(idx) );
% %         psd{trail}(i,:,:) =mean( margin{trail}(idx,:,:).*margin{trail}(idx,:,:),1);% ES band MEAN energy spectral
% %         psd_phase{trail}(i,:,:) =mean( phase{trail}(idx,:,:),1);% ES band MEAN energy spectral
%     end
% %     band_DE{trail} = (log10(psd{trail}));
% %     band_phase{trail} = (psd_phase{trail});
%     margin{trail}=zscore(log(margin{trail}(1:50,:,:)));
%     slf3(jj,trail)=margin{trail}(50,1,100);
% %   margin{trail}=zscore(margin{trail},1);
% %   phase{trail}=zscore(phase{trail},1);
% %   Margin_C{trail}= reshape(margin{trail},[],15000);
% %   Phase_C{trail}=reshape(phase{trail},[],15000);
%      
% end
% % Label(jj)=source_signal.label(jj);
%  [margin2,label2 ] = Cell_onLabel(margin,30,label);
% 
% %   save(['F:/data_cwt/solo/SCUT_',All_name{jj+1},'.mat',],...
% %     'label2','margin2')% 按照trial 1，2，3顺序来的,限制margin长度为1：50.
% 
% end
% 
% 
% %% plot
% % 
% % for kkk=1:30
% %     for time = 2500:1250:15000
% %     temp = Phase_C{kkk}(1:260,time-2500+1:time);
% %     imagesc(temp)
% %     drawnow
% %     pause(0.3) 
% %     source_signal.label(kkk)
% %     end
% % end
% 
% %%
% Mean=[];
% Label_M=[];
% for kkk=1:30%每个trail
%     band_DE2{kkk}=zscore(band_DE{kkk});
% mm=reshape(band_DE2{kkk}(:,:,:),150,250,[]);
% % if source_signal.label(kkk)~=3 %排除平静
% Mean = [Mean,squeeze(sum(mm,2))];
% Label_M=[Label_M,ones(1,size(mm,3)).*label(kkk)];
% % end
% end
% % Mean=zscore(Mean,1);
% SVMM=[(Mean(:,1:end-100));Label_M(:,1:end-100)];
% % test = (Mean(:,end-90:end)); 
% % test_label = Label_M(:,end-90:end);
% 
% [data_fea, data_num] = size(Mean);
% %将数据样本随机分割为fold部分
% fold=5;
% indices = crossvalind('Kfold', data_num, fold);
% for i = 1 : fold
%     % 获取第i份测试数据的索引逻辑值
%     test = (indices == i);
%     % 取反，获取第i份训练数据的索引逻辑值
%     train = ~test;
%     %1份测试，9份训练
%     test_data = Mean(:,test);
%     test_label = Label_M(:, test);
%     
%     train_data =  Mean(:,train);
%     train_label =Label_M(:, train);
%     % 使用数据的代码
%     
%     SVM   =svmtrain(train_label',train_data',['-t 0']);
%      [~, Acc, ~] = svmpredict(test_label', test_data', SVM);
%      accc(i,:)=Acc;
% end
% mean(accc(:,1))
% % ssvm=[train_label',train_data'];
% % svmtrain(L,zscore(jj_3))
% % [trainedClassifier, validationAccuracy] = trainClassifier(SVMM)
% % yfit = trainedClassifier.predictFcn(test);
% 
% %%
% % test=Mean(:,end-100+1:end);
% 
% yfit = trainedModel1.predictFcn(test_data');
% length(find(yfit==test_label'))/length(test_label)
% % length(find(yfit==Label_M(:,end-100+1:end)')/length(test_label))
% %% 
% data_view_15_ROI2 = squeeze(temp(13,:,25));
% data_view_16_ROI2 = squeeze(temp(13,:,26));
% data_view_18_ROI2 = squeeze(temp(13,:,28));
% data_view_17_ROI2 = squeeze(temp(13,:,27));
% label([25,26,27,28])