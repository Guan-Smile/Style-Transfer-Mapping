EEG = pop_loadset('filename','zaosheng.set','filepath','F:\\Research\\GZJ的研究\\抑郁症情绪调控数据\\');
load('Feature10s2.mat');  %1s截取一段的特征
Source_Data_All=Feature_sb;



figure();

for kkk=1:2:800
    Source_Data_An =cat(1,Source_Data_All{1,:});
f_cut=2;
maplim=[-1 1];
cc1=reshape(Source_Data_An,[],5,30);
datavector1=squeeze(mean(cc1(1*kkk:1*kkk+2,f_cut-1,:),1));
datavector2=squeeze(mean(cc1(1*kkk:1*kkk+2,f_cut,:),1));
datavector3=squeeze(mean(cc1(1*kkk:1*kkk+2,f_cut+1,:),1));
subplot(1,3,1)
topoplot(datavector1, EEG.chanlocs,'style','map','conv','off', 'emarker2' ,{[5 6],'s','k'}, 'maplimits', maplim)
subplot(1,3,2)
topoplot(datavector2, EEG.chanlocs,'style','map','conv','off', 'emarker2' ,{[5 6],'s','k'}, 'maplimits', maplim)
subplot(1,3,3)
topoplot(datavector3, EEG.chanlocs,'style','map','conv','off', 'emarker2' ,{[5 6],'s','k'}, 'maplimits', maplim)
    drawnow
%     pause(0.1) 

end



