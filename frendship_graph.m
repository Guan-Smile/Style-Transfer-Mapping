%% 小于33%
for i=1:15*15
    if Weights(i)<38
        %% 小于33%比随机分类的准确率还低
        Weights(i)=0
    end
end
%% digraph生成有向图
GG = digraph(100-Weights);
plot(GG)

%% 求最短路径
[path,distance]=shortestpath(GG,8,2)

%%
% dddd=ones(15,15)-eye(15,15)
% dddd(3,6)=0;
% dddd(3,9)=34;
% dataa = graph(dddd);
% plot(dataa)