%%
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
namelist = dir([datapath '*.mat']);%按照顺序读取文件名1010,1011,1012,1013,...101,102,...
All_name={namelist.name};
f_d=zeros(62,1,5);%zeros(5,1,5);
label=[];
sqe=[];
for jj = 2:3:length(All_name)-1
    source_signal=load(['G:\Dataset-seed\ExtractedFeatures\',All_name{jj}]);
for ii=1:15
%     if lab(ii)~=1 %%排除平静
    ff=eval(['source_signal.de_LDS', num2str(ii)]);
%      imagesc(squeeze(ff(3,:,:)))
%     ff = zscore(ff,1); %???????????
%     figure
%     imagesc(squeeze(ff(3,:,:)))
    f_d=cat(2,f_d,ff([1:62],:,:));%[8,12,38,24,1]
    label=[label;lab(ii)*ones(size(ff,2),1)];
    sqe=[sqe;size(ff,2)];
%     end
end
end
% Train_Data_label_D=[label,(1-label)];%独热表示
% Train_Data_5C=f_d;
% n = length(unique(label));
% % fprintf('将标签转换成热编码\n')
% Train_Data_label_D = full(ind2vec(label'+1,n))'; % ind2vec(): 将ind标签转换成vec稀疏编码，再由full()转换成OneHotEncoding

%% for style transfer mapping code
f_d_true=f_d(:,2:end,:);
Source_Data=permute(f_d_true,[2,1,3]);
Source_Data_A=reshape(Source_Data,3394,[],310);

% 
% 
% %% 五折交叉验证取出测试集
% 
% %45人
% f_d_true=f_d(:,2:end,:);
% fold =5;
% sqe=reshape(sqe,15,[]);%15行45列，每列一个session
% 
% 
% for kkk=1:fold
% 
% people = reshape(1:45,[],fold);
% po_test=people(:,kkk);
% po=setdiff(people,people(:,kkk));
% po_train=reshape(po,size(people,1),[]);
% 
% 
% test_sqe=sqe(:,po_test);
% test_flag=sum(sum(sqe(:,1:po_test(1))))-sum(sqe(:,po_test(1)))+1:sum(sum(sqe(:,1:po_test(length(po_test)))));
% test_data=f_d_true(:,test_flag,:);
% % size(test_data)
% train_flag = setdiff(1:size(f_d_true,2),test_flag);
% train_data=f_d_true(:,train_flag,:);
% Test_Data_label=label(test_flag,:);
% Target_Data=permute(test_data,[2,1,3]);%原始三维：5个电极通道 # 30546(9人次*sum(15个trail数据长度) # 5 DE特征
% 
% Train_Data_label=label(train_flag,:);
% Source_Data=permute(train_data,[2,1,3]);
% % test_flag(1)
% % test_flag(end)
% %乱序
% n = length(unique(Train_Data_label));
% % fprintf('将Train标签转换成热编码\n')
% Source_Data_label_D = full(ind2vec(Train_Data_label'+1,n))'; % ind2vec(): 将ind标签转换成vec稀疏编码，再由full()转换成OneHotEncoding
% nn = length(unique(Test_Data_label));
% % fprintf('将Test标签转换成热编码\n')
% Target_Data_label_D = full(ind2vec(Test_Data_label'+1,nn))'; % ind2vec(): 将ind标签转换成vec稀疏编码，再由full()转换成OneHotEncoding
% 
% fflg=0:sum(test_sqe(:,1)):size(Source_Data);% seed集中每个session sqe长度相同，和为3394
% SourceTest_Data=Source_Data([fflg(1)+1:fflg(3)],:,:);
% SourceTest_Data_label_D=Source_Data_label_D([fflg(1)+1:fflg(3)],:);
% TargetTest_Data=Target_Data([fflg(1)+1:fflg(3)],:,:);
% TargetTest_Data_label_D=Target_Data_label_D([fflg(1)+1:fflg(3)],:);
% 
% SourceTrain_Data=Source_Data([fflg(3)+1:fflg(37)],:,:);
% SourceTrain_Data_label_D=Source_Data_label_D([fflg(3)+1:fflg(37)],:);
% TargetTrain_Data=Target_Data([fflg(3)+1:fflg(10)],:,:);
% TargetTrain_Data_label_D=Target_Data_label_D([fflg(3)+1:fflg(10)],:);
% 
% TestCombin_Data=cat(1,SourceTest_Data,TargetTest_Data);
% TestCombin_DomainLabel=[0.*ones(size(SourceTest_Data_label_D,1),1);ones(size(TargetTest_Data_label_D,1),1)];
% Dom = length(unique(TestCombin_DomainLabel));
% % fprintf('将标签转换成热编码\n')
% TestCombin_DomainLabel_D = full(ind2vec(TestCombin_DomainLabel'+1,Dom))'; % ind2vec(): 将ind标签转换成vec稀疏编码，再由full()转换成OneHotEncoding
% % 
% 
% save(['seed_data/seed_625_de_LDS_fold',num2str(kkk),'py.mat',],...
%     'SourceTrain_Data','SourceTrain_Data_label_D','TargetTrain_Data','TargetTrain_Data_label_D'...
%     ,'SourceTest_Data','SourceTest_Data_label_D','TargetTest_Data','TargetTest_Data_label_D',...
%     'TestCombin_Data','TestCombin_DomainLabel_D')
% end
% 
% %% 绘制5*5动图
% num_data =500;
% 
% imagesc(squeeze(Train_Data(3,:,:)))
% theAxes=axis;
% fmat=moviein(num_data);
% speed =10;
% for cont = 1:num_data
%     imagesc(squeeze(Train_Data(cont*speed,:,:)))
% %     title(num2str(Train_Data_label(cont*10)))
%     hold on
%     plot(Train_Data_label(cont*speed:cont*speed+5)+1,'P-r')
%     axis(theAxes)
%     fmat(:,cont)=getframe;
% end
% movie(fmat,1)