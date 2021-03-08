% function  diff_entropy  = extract_DE_new(epoch_std,Fs)
% %      extract_ED_feature
% %   compute ES of every 1s data,and then compute DE
% %         HHY. 2016.
% NFFT=512;
% f = Fs/2*linspace(0,1,NFFT/2); 
% 
% for channel =1:size(epoch_std,1)
%     for section =1:floor( length(epoch_std)/(5*Fs) )%round( length(epoch_std)/Fs )%每秒作为一段 计算psd
%       
%         section_data = epoch_std(channel,(section-1)*Fs+1:section*Fs );
%         window =hanning(length(section_data))';
%         Pxx = abs (fft(section_data .* window,NFFT));
%         section_de(section,:) = band_DE(Pxx,f);
%     end
%     de_mean = mean(section_de,1);
%     de(channel,:) = de_mean;
% end
% 
%    diff_entropy =reshape(de',1,size(de,1)*size(de,2));%% de' feature rank through channels
%    
% end
function  [diff_entropy rasm_feature] = extract_DE_new(epoch_std,Fs)
%      extract_ED_feature
time_sec =  1*Fs ; %length(epoch_std);%  %以多长数据为一个窗口

NFFT=2^nextpow2(time_sec);
f = Fs/2*linspace(0,1,NFFT/2);
%window = hanning(time_sec);
section_de = cell(size(epoch_std,1),1);
for channel =1:size(epoch_std,1)
    
    for section =1:floor( size(epoch_std,2)/time_sec )%每多少秒作为一段 计算psd
    %%%%%%%%%% design hanning window :   
        window =hanning(time_sec)';
   %%%%%%%%%%%%% 
        section_data = epoch_std(channel,(section-1)*time_sec+1:section*time_sec );
        Pxx = abs (fft(section_data .*window,NFFT));
        section_de{channel}(section,:) = band_DE(Pxx,f);
    end
    de_mean = mean(section_de{channel},1);
    de(channel,:) = de_mean;
end
%%%=======DE Feature
   diff_entropy =reshape(de',1,size(de,1)*size(de,2));%% de' feature rank through channels
%%%======= RASM = DE_left / DE_ right;
rasm_feature=[];
%      rasm_channel = RASM(de);
%    rasm_feature =reshape( rasm_channel' , 1,size(rasm_channel,1)*size(rasm_channel,2));
   
end
function band_DE = band_DE(Pxx,f)
    band(1, :) = [1 3];%[2 3.8];% delta band
    band(2, :) = [4 7];% theta band
    band(3, :) = [8 13];% alpha band
    band(4, :) = [14 30];% beta band
    band(5, :) = [31 48];% gamma band
    for i = 1:size(band,1)
        idx = find( f>=band(i, 1) & f<=band(i, 2) );
       % psd(1, i) = mean( Pxx(idx) );
        psd(1,i) =mean( Pxx(idx).*Pxx(idx) );% ES band MEAN energy spectral
    end
    band_DE = log10(psd);
end
function RASM_feature = RASM(de)
    RASM_feature(1,:) = de(1,:)./de(2,:);% [FP1 FP2]
    
    RASM_feature(2,:) = de(3,:)./de(7,:);% [F7 F8]
    RASM_feature(3,:) = de(4,:)./de(6,:);% [F3 F4]
    
    RASM_feature(4,:) = de(8,:)./de(12,:);% [FT7 FT8]
    RASM_feature(5,:) = de(9,:)./de(11,:);% [FC3 FC4]
    
    RASM_feature(6,:) = de(13,:)./de(17,:);% [T7 T8]
  %  RASM_feature(7,:) = de(14,:)./de(16,:);% [C3 C4]
    
%     RASM_feature(8,:) = de(18,:)./de(22,:);% [TP7 TP8]
%     RASM_feature(9,:) = de(19,:)./de(21,:);% [CP3 CP4]
%     
%     RASM_feature(10,:) = de(23,:)./de(27,:);% [P7 P8]
%     RASM_feature(11,:) = de(24,:)./de(26,:);% [P3 P4]
%     
%     RASM_feature(12,:) = de(28,:)./de(30,:);% [O1 O2]
end