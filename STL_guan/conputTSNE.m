%%  原始数据集特征('Feature10s2.mat');tsne降维画二维平面图

% load('Feature10s2.mat');  %2s截取一段的特征
% Source_Data_All =cat(1,Feature_sb{:,:});
% all=repmat(1:20,[780,1]);
% alll=reshape(all,[],1);
% species=cell(780,1)
% for i=1:15600
%     if (rem(i,780)<=260)
%          species{i}=int2str(alll(i)*1+1*0);   
%     else if (rem(i,780)<=520)
%          species{i}=int2str(alll(i)*1+2*0);     
%         else
%          species{i}=int2str(alll(i)*1+3*0); 
%          end
%     end
% end
% figure
% % Yy = tsne(Source_Data_An);   %计算TSNE
% Y=Y_TSNE;
% gscatter(Y(:,1),Y(:,2),species)


%%  迁移后*A0数据集特征('FeatureNoStyleAllNorandom/FeatureNoStyleAll.mat');tsne降维画二维平面图,来源:[Feature_NoStyle] = multiSourceClassifier_scut

load('FeatureNoStyleAllNorandomSame11p.mat')
% for tt=1:11
Source_Data_Allp =cat(1,Feature_NoStyle_All{:,:});
%  Source_Data_All
%  =cat(1,Source_Data_Allp{1:7:140,:});;%取最接近的一组的迁移数据特征求tsne{第几个:nb_senator:nb_senator*20}
 Source_Data_All =cat(1,Source_Data_Allp{tt:11:220,:});%取最接近的一组的迁移数据特征求tsne
% Source_Data_All =cat(1,Source_Data_Allp{:,:});%取最接近的7组的迁移数据特征求tsne
nn=1;   %参数nn:  取最接近的n组的迁移数据特征求tsne(nn=1,2,3,4,5,6,7)
aa=1;bb=0;%图片标签显示20人的分组情况
% aa=0;bb=1;%图片标签显示情绪3分类的分组情况，1=pos，2=neg，3=neu;
% aa=10;bb=1;%图片标签显示情绪3分类的分组情况+20人的分组情况

% Yy = tsne(Source_Data_All);   %计算TSNE
% all=repmat([1,0,0,4,5,6,0,8,9,0,11,0,13,0,15,0,17,18,0,0],[684,1]);
all=repmat(1:20,[684*nn,1]);
alll=reshape(all,[],1);
species=cell(684*nn*20,1)
for i=1:13680*nn
    if (rem(i,684)<=228)
         species{i}=int2str(alll(i)*aa+1*bb);   
    else if (rem(i,684)<=228*2)
         species{i}=int2str(alll(i)*aa+2*bb);     
        else
         species{i}=int2str(alll(i)*aa+3*bb); 
         end
    end
end
figure
gscatter(Yy(:,1),Yy(:,2),species) %画图
% end
% 
% all=repmat(1:20,[684,1]);
% alll=reshape(all,[],1);
% species=cell(684*20,1)
% for i=1:13680
%     if (rem(i,684)<=228)
%          species{i}=int2str(alll(i)*1+1*0);   
%     else if (rem(i,684)<=228*2)
%          species{i}=int2str(alll(i)*1+2*0);     
%         else
%          species{i}=int2str(alll(i)*1+3*0); 
%          end
%     end
% end
% 
% gscatter(Yy(:,1),Yy(:,2),species) %计算TSNE
% 
