%%  ԭʼ���ݼ�����('Feature10s2.mat');tsne��ά����άƽ��ͼ

% load('Feature10s2.mat');  %2s��ȡһ�ε�����
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
% % Yy = tsne(Source_Data_An);   %����TSNE
% Y=Y_TSNE;
% gscatter(Y(:,1),Y(:,2),species)


%%  Ǩ�ƺ�*A0���ݼ�����('FeatureNoStyleAllNorandom/FeatureNoStyleAll.mat');tsne��ά����άƽ��ͼ,��Դ:[Feature_NoStyle] = multiSourceClassifier_scut

load('FeatureNoStyleAllNorandomSame11p.mat')
% for tt=1:11
Source_Data_Allp =cat(1,Feature_NoStyle_All{:,:});
%  Source_Data_All
%  =cat(1,Source_Data_Allp{1:7:140,:});;%ȡ��ӽ���һ���Ǩ������������tsne{�ڼ���:nb_senator:nb_senator*20}
 Source_Data_All =cat(1,Source_Data_Allp{tt:11:220,:});%ȡ��ӽ���һ���Ǩ������������tsne
% Source_Data_All =cat(1,Source_Data_Allp{:,:});%ȡ��ӽ���7���Ǩ������������tsne
nn=1;   %����nn:  ȡ��ӽ���n���Ǩ������������tsne(nn=1,2,3,4,5,6,7)
aa=1;bb=0;%ͼƬ��ǩ��ʾ20�˵ķ������
% aa=0;bb=1;%ͼƬ��ǩ��ʾ����3����ķ��������1=pos��2=neg��3=neu;
% aa=10;bb=1;%ͼƬ��ǩ��ʾ����3����ķ������+20�˵ķ������

% Yy = tsne(Source_Data_All);   %����TSNE
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
gscatter(Yy(:,1),Yy(:,2),species) %��ͼ
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
% gscatter(Yy(:,1),Yy(:,2),species) %����TSNE
% 
