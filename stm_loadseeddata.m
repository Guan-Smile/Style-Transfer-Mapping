lab=[2
1
0
0
1
2
0
1
2
2
1
0
1
2
0
];
datapath = 'G:\Dataset-seed\ExtractedFeatures\';
%%%%original data
namelist = dir([datapath '*.mat']);%����˳���ȡ�ļ���1010,1011,1012,1013,...101,102,...
All_name={namelist.name};
f_d=zeros(62,1,5);%zeros(5,1,5);
label=[];
sqe=[];
for jj = 3 :3:length(All_name)-1%1:length(All_name)-1  %% ����STMʱ������һ��session��15�ˣ� 1/2/3 :3:length(All_name)-1�������⿪����for STM����ڵ�ע��
    source_signal=load(['G:\Dataset-seed\ExtractedFeatures\',All_name{jj}]);
for ii=1:15
%     if lab(ii)~=1 %%�ų�ƽ��
    ff=eval(['source_signal.de_LDS', num2str(ii)]);
%      imagesc(squeeze(ff(3,:,:)))
%     ff = zscore(ff,1); %????
%     figure
%     imagesc(squeeze(ff(3,:,:)))
    f_d=cat(2,f_d,ff([1:62],:,:));%[8,12,38,24,1]
    label=[label;lab(ii)*ones(size(ff,2),1)];
    sqe=[sqe;size(ff,2)];
%     end
end
end
% Train_Data_label_D=[label,(1-label)];%���ȱ�ʾ
% Train_Data_5C=f_d;
% n = length(unique(label));
% % fprintf('����ǩת�����ȱ���\n')
% Train_Data_label_D = full(ind2vec(label'+1,n))'; % ind2vec(): ��ind��ǩת����vecϡ����룬����full()ת����OneHotEncoding

%% for style transfer mapping(STM) code
f_d_true=f_d(:,2:end,:);
Source_Data=permute(f_d_true,[2,1,3]);
Source_Data_A=reshape(Source_Data,3394,[],310);
save('data3.mat','Source_Data_A')