%% mix DATA
d1=load('G:\Dataset-DEAP\code\data_DEAP5.mat')
d2=load('G:\Dataset-MAHNOB\code_MA\data_MAHNOB.mat')
d3=load('G:\Dataset-seed\code_SEEDI\data_SEED.mat')
d4=load('G:\Dataset-seed\SEED_IV\eeg_raw_data\data_seedIV.mat')
d5=load('G:\Dataset-DEAP\情绪数据集整理\daraset-SCUT\data_SCUT.mat')
% d1=load('F:\Dataset-DEAP\code\data_DEAP5.mat')
% d2=load('F:\Dataset-MAHNOB\code_MA\data_MAHNOB.mat')
% d3=load('F:\Dataset-seed\code_SEEDI\data_SEED.mat')
% d4=load('F:\Dataset-seed\SEED_IV\eeg_raw_data\data_seedIV.mat')
% d5=load('F:\Dataset-DEAP\情绪数据集整理\daraset-SCUT\data_SCUT.mat')
% Train_Data=[d1.data(1:1000,:);d2.data(1:1000,:);d3.data(1:1000,:);d4.data(1:1000,:);d5.ALL_data(1:1000,:)];
% % Test_Data=[d1.data(2000:3000,:);d2.data(1279:2279,:);d3.data(3000:5000,:);d4.data(2000:5000,:);d5.ALL_data_test(466:1466,:)];
% Test_Data=[d1.data(2000:5:4000,:);d2.data(1200:2279,:);d3.data(3000:5:5000,:);d4.data(2000:5:5000,:);...
%     d5.ALL_data_test(466:1466,:);d5.ALL_data(2500:4000,:)];
%%
numFolds = 4;
d1.numTotal = (length(d1.data));
d1.numTest = floor(d1.numTotal/numFolds);
d1.numTrain = d1.numTotal - d1.numTest;
d2.numTotal = (length(d2.data));
d2.numTest = floor(d2.numTotal/numFolds);
d2.numTrain = d2.numTotal - d2.numTest;
d3.numTotal = (length(d3.data));
d3.numTest = floor(d3.numTotal/numFolds);
d3.numTrain = d3.numTotal - d3.numTest;
d4.numTotal = (length(d4.data));
d4.numTest = floor(d4.numTotal/numFolds);
d4.numTrain = d4.numTotal - d4.numTest;
d5.numTotal = (length(d5.ALL_data));
d5.numTest = floor(d5.numTotal/numFolds);
d5.numTrain = d5.numTotal - d5.numTest;

%  indexTotal = randperm(numTotal); %乱序 
   d1.indexTotal = 1:d1.numTotal; %正序 
   d2.indexTotal = 1:d2.numTotal; %正序 
   d3.indexTotal = 1:d3.numTotal; %正序 
   d4.indexTotal = 1:d4.numTotal; %正序 
   d5.indexTotal = 1:d5.numTotal; %正序 
   
    for fold = 1:4
   d1.indexTest = d1.indexTotal((fold-1)*d1.numTest+1:fold*d1.numTest);
   d1.indexTrain = setdiff(d1.indexTotal,d1.indexTest);
   d1.indexTrain =  d1.indexTrain((30:end-30));
   d2.indexTest = d2.indexTotal((fold-1)*d2.numTest+1:fold*d2.numTest);
   d2.indexTrain = setdiff(d2.indexTotal,d2.indexTest);
   d2.indexTrain =  d2.indexTrain((100:end-100));
   d3.indexTest = d3.indexTotal((fold-1)*d3.numTest+1:fold*d3.numTest);
   d3.indexTrain = setdiff(d3.indexTotal,d3.indexTest);
   d3.indexTrain =  d3.indexTrain((710:end-710));
   d4.indexTest = d4.indexTotal((fold-1)*d4.numTest+1:fold*d4.numTest);
   d4.indexTrain = setdiff(d4.indexTotal,d4.indexTest);
   d4.indexTrain =  d4.indexTrain((350:end-350));
   d5.indexTest = d5.indexTotal((fold-1)*d5.numTest+1:fold*d5.numTest);
   d5.indexTrain = setdiff(d5.indexTotal,d5.indexTest);
   d5.indexTrain =  d5.indexTrain((400:end-400));
   
  %%%FP1,FP2对应通道1,17
   Train_Data=[d1.data(d1.indexTrain,:);d2.data(d2.indexTrain,:);d3.data(d3.indexTrain,:);d4.data(d4.indexTrain,:);d5.ALL_data(d5.indexTrain,:)];
   Train_Data_2C=Train_Data(:,[1:5,81:85]);
   Train_Data_label=Train_Data(:,[161]);
   Train_Data_label_D=[Train_Data(:,[161]),(1-Train_Data(:,[161]))];
   Test_Data=[d1.data(d1.indexTest,:);d2.data(d2.indexTest,:);d3.data(d3.indexTest,:);d4.data(d4.indexTest,:);d5.ALL_data(d5.indexTest,:)];
   Test_Data_2C=Test_Data(:,[1:5,81:85]);
   Test_Data_label=Test_Data(:,[161]);
   Test_Data_label_D=[Test_Data(:,[161]),(1-Test_Data(:,[161]))];%独热表示

%% 
[trainedClassifier, validationAccuracy] = trainClassifier(Train_Data)
%%
% yfit2 = trainedClassifier.predictFcn(d1.data(1000:2000,1:160));
% yfit3 = trainedClassifier.predictFcn(d2.data(1:1000,1:160));
% yfit4 = trainedClassifier.predictFcn(d3.data(1000:2000,1:160));
% yfit5 = trainedClassifier.predictFcn(d4.data(1000:2000,1:160));
% yfit6 = trainedClassifier.predictFcn(d5.ALL_data(500:1500,1:160));
% yfit1 = trainedClassifier.predictFcn(Train_Data(:,1:160));%平均准确率
% ACC(1)=length(find(Train_Data(:,161)==yfit1))/length(yfit1)%平均准确率
% ACC(2)=length(find(d1.data(1000:2000,161)==yfit2))/length(yfit2)%
% ACC(3)=length(find(d2.data(1:1000,161)==yfit3))/length(yfit3)%
% ACC(4)=length(find(d3.data(1000:2000,161)==yfit4))/length(yfit4)%
% ACC(5)=length(find(d4.data(1000:2000,161)==yfit5))/length(yfit5)%
% ACC(6)=length(find(d5.ALL_data(500:1500,161)==yfit6))/length(yfit6)%
%%

yfit2 = trainedClassifier.predictFcn(d1.data(d1.indexTest,1:160));
yfit3 = trainedClassifier.predictFcn(d2.data(d2.indexTest,1:160));
yfit4 = trainedClassifier.predictFcn(d3.data(d3.indexTest,1:160));
yfit5 = trainedClassifier.predictFcn(d4.data(d4.indexTest,1:160));
yfit6 = trainedClassifier.predictFcn(d5.ALL_data(d5.indexTest,1:160));
% yfit1 = trainedClassifier.predictFcn(Train_Data(:,1:160));%平均准确率
ACC{fold}(1)=0;%length(find(Train_Data(:,161)==yfit1))/length(yfit1);%平均准确率
ACC{fold}(2)=length(find(d1.data(d1.indexTest,161)==yfit2))/length(yfit2);%
ACC{fold}(3)=length(find(d2.data(d2.indexTest,161)==yfit3))/length(yfit3);%
ACC{fold}(4)=length(find(d3.data(d3.indexTest,161)==yfit4))/length(yfit4);%
ACC{fold}(5)=length(find(d4.data(d4.indexTest,161)==yfit5))/length(yfit5);%
ACC{fold}(6)=length(find(d5.ALL_data(d5.indexTest,161)==yfit6))/length(yfit6)%
   end
%  plot(Test_Data(:,161),'ro')
% yfit2 = trainedClassifier.predictFcn(d1.data(2000:3000,1:160));
% yfit3 = trainedClassifier. predictFcn(d2.data(1279:2279,1:160));
% yfit4 = trainedClassifier.predictFcn(d3.data(3000:4000,1:160));
% yfit5 = trainedClassifier.predictFcn(d4.data(2000:3000,1:160));
% yfit6 = trainedClassifier.predictFcn(d5.ALL_data_test(600:1466,1:160));
% yfit1 = trainedClassifier.predictFcn(Test_Data(:,1:160));%平均准确率
% ACC(1)=length(find(Test_Data(:,161)==yfit1))/length(yfit1)%平均准确率
% ACC(2)=length(find(d1.data(2000:3000,161)==yfit2))/length(yfit2)%
% ACC(3)=length(find(d2.data(1279:2279,161)==yfit3))/length(yfit3)%
% ACC(4)=length(find(d3.data(3000:4000,161)==yfit4))/length(yfit4)%
% ACC(5)=length(find(d4.data(2000:3000,161)==yfit5))/length(yfit5)%
% ACC(6)=length(find(d5.ALL_data_test(600:1466,161)==yfit6))/length(yfit6)%
% %  plot(Test_Data(:,161),'ro')
% hold on
% plot(yfit,'b.')