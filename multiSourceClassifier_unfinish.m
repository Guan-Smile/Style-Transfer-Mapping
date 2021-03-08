function [acc, acc_transfered_LVQ, acc_transfered_QDF] = multiSourceClassifier_guan(subjectIndex, nb_senator)
% this function conducts classifier adaptation based on the selected 3394 samples from one best subject
%% --load and preprocess data-- %%
kl=load( 'L.mat');%��ǩ
%����3ƽ��2����1
% load( 'L_nozscore.mat');%data��һ��sessionû��zscore
% load('data2.mat');%data�ڶ���sessionû��zscore
load('Feature1s1.mat');
Source_Data_All=Feature_sb;


% data=zscore(Source_Data_A);


%  L = fix(L*0.5);
%% --train 14 SVMs--%%
SVMs=[];
for sv=1:20
    
    Source_Data_An =cat(1,Source_Data_All{1,:});  %ȡ��һ�����Ե��������ݵĻ�ϼ�
    Label_A = cat(1,Source_Data_All{1,1}*0+1,Source_Data_All{1,2}*0+2,Source_Data_All{1,3}*0+3);
    
SVM = [svmtrain(Label_A,Source_Data_An)];
SVMs = [SVMs;SVM];
%     svmtrain(L,zscore(jj_3));svmtrain(L,zscore(lqj_1));
%     svmtrain(L,zscore(ly_2));svmtrain(L,zscore(mhw_1));svmtrain(L,zscore(phl_1));
%     svmtrain(L,zscore(sxy_3));svmtrain(L,zscore(wk_1));svmtrain(L,zscore(wsf_1));
%     svmtrain(L,zscore(ww_1));svmtrain(L,zscore(wyw_3));svmtrain(L,zscore(xyl_3));
%     svmtrain(L,zscore(ys_1));svmtrain(L,zscore(zjy_2))];
end
%% --(1)select S, (2)divide S to S_A, S_B, (3)estimate weights of 13 SVMs on S_A-- %%
S =zscore(squeeze(data(:,subjectIndex,:)));  % S is the data of the selected subject
stimuli_1 = S(1:235,:);
stimuli_2 = S(236:468,:);
stimuli_3 = S(469:674,:); % the first 3 stimulus
S_A = [stimuli_1(randperm(235, 20),:);stimuli_2(randperm(233, 20),:);stimuli_3(randperm(206, 20),:)];
L_A = [repmat(3,[20,1]);repmat(2,[20,1]);repmat(1,[20,1])];

nb_B = 2720;
S_B = S(675:3394,:); % the last 12 stimulus
L_B = label(675:3394,:);

randIndex = randperm(2720);
S_B = S_B(randIndex,:);      
L_B = L_B(randIndex,:);

SVMs(subjectIndex) = []; % delete the subject's own SVM among the 14 SVMs
candidateSVMs = SVMs;    % 13 SVMs forms a cell
weights = zeros(13,1);   % 13 SVMs' weights
for i = 1:1:13
    [~, Acc, ~] = svmpredict(L_A, S_A, candidateSVMs(i));  % 13 SVMs perform on S_A, performance determines weights
    weights(i) = ceil(Acc(1));                             % up to nearest integer
end
%% --select senator SVMs-- %%
%nb_senator = 1;                                % only the top candidate SVMs are selected as senator for the final voting
[~, b] = sort(weights,'descend');               % sort the weights
senatorIndex = b(1:nb_senator);                 % senator index
senatorSVMs = candidateSVMs(senatorIndex);      % senator SVMs
weights = weights(b(1:nb_senator));             % senators' weights
%% --senator SVMs vote together-- %%
Y = zeros(nb_B,nb_senator);                     % every column is one senator's results on all S_B data
for i = 1:1:nb_senator
    v = svmpredict(L_B, S_B, senatorSVMs(i));
    Y(:,i) = v;
end
tru = 0;                     % nb of right classified samples
voteMatrix = zeros(nb_B,3);  % pos, neu and neg
for i = 1:1:nb_B             % senators vote according to weights
    x = Y(i,:);              % all senators' opinion concerning this sample
    ind_pos = find(x == 3);  % index of "who thinks it's positive"
    ind_neu = find(x == 2);
    ind_neg = find(x == 1);
    pos_votes = sum(weights(ind_pos));  % positive's votes
    neu_votes = sum(weights(ind_neu));
    neg_votes = sum(weights(ind_neg));
    voteMatrix(i,:) = [pos_votes,neu_votes,neg_votes];
    [~,local]=max([neg_votes,neu_votes,pos_votes]);
    if local==L_B(i)
        tru = tru + 1;
    end
end
acc = tru/nb_B;              % accuracy on S_B
%% --now let's do transfer to make S_B more familar to each senator SVMs-- %%
a = 0.8;
beta_coeff = 0.2;
gamma_coeff = 2;
iterNum = 5;
Y_LVQ = zeros(nb_B, nb_senator);
Y_QDF = zeros(nb_B, nb_senator);
for i = 1:1:nb_senator
    p = senatorIndex(i);
    train_x =squeeze(data(:,p,:));
    train_y = label;
    % whether to remove SVs
    sv_indices = SVMs(p).sv_indices;
    train_x(sv_indices(:),:)=[];
    train_y(sv_indices(:))=[];
    [~, L_B_predicted_LVQ, L_B_predicted_QDF] = semiSupervisedSTM(train_x, train_y, S_A, L_A, S_B, L_B, a, beta_coeff, gamma_coeff, iterNum);
    Y_LVQ(:,i) = L_B_predicted_LVQ;
    Y_QDF(:,i) = L_B_predicted_QDF;
end
tru_LVQ = 0;
tru_QDF = 0;
voteMatrix_LVQ = zeros(nb_B,3);  % pos, neu and neg
voteMatrix_QDF = zeros(nb_B,3);  % pos, neu and neg
for i = 1:1:nb_B                 % senators vote according to weights
    x_LVQ = Y_LVQ(i,:);          % all senators' opinion concerning this sample
    x_QDF = Y_QDF(i,:);
    ind_pos_LVQ = find(x_LVQ == 3);      % index of "who thinks it's positive"
    ind_pos_QDF = find(x_QDF == 3);
    ind_neu_LVQ = find(x_LVQ == 2);
    ind_neu_QDF = find(x_QDF == 2);
    ind_neg_LVQ = find(x_LVQ == 1);
    ind_neg_QDF = find(x_QDF == 1);
    pos_votes_LVQ = sum(weights(ind_pos_LVQ));  % positive's votes
    pos_votes_QDF = sum(weights(ind_pos_QDF));
    neu_votes_LVQ = sum(weights(ind_neu_LVQ));
    neu_votes_QDF = sum(weights(ind_neu_QDF));
    neg_votes_LVQ = sum(weights(ind_neg_LVQ));
    neg_votes_QDF = sum(weights(ind_neg_QDF));
    voteMatrix_LVQ(i,:) = [pos_votes_LVQ,neu_votes_LVQ,neg_votes_LVQ];
    voteMatrix_QDF(i,:) = [pos_votes_QDF,neu_votes_QDF,neg_votes_QDF];
    [~,local_LVQ]=max([neg_votes_LVQ,neu_votes_LVQ,pos_votes_LVQ]);
    [~,local_QDF]=max([neg_votes_QDF,neu_votes_QDF,pos_votes_QDF]);
    if local_LVQ==L_B(i)
        tru_LVQ = tru_LVQ + 1;
    end
    if local_QDF==L_B(i)
        tru_QDF = tru_QDF + 1;
    end
end
acc_transfered_LVQ = tru_LVQ/nb_B;              % accuracy on S_B
acc_transfered_QDF = tru_QDF/nb_B;              % accuracy on S_B
end