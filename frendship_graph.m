%% С��33%
for i=1:15*15
    if Weights(i)<38
        %% С��33%����������׼ȷ�ʻ���
        Weights(i)=0
    end
end
%% digraph��������ͼ
GG = digraph(100-Weights);
plot(GG)

%% �����·��
[path,distance]=shortestpath(GG,8,2)

%%
% dddd=ones(15,15)-eye(15,15)
% dddd(3,6)=0;
% dddd(3,9)=34;
% dataa = graph(dddd);
% plot(dataa)