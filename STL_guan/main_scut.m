clear
clc
semi = zeros(20,3);
fs = 250;
winlen=10*fs;
slidelen=2*fs;
Feature_NoStyle_All=cell(20,1);
for subjectIndex = 1:1:20
    [acc, acc_transfered_LVQ, acc_transfered_QDF,Feature_NoStyle] = multiSourceClassifier_scut(subjectIndex,11,winlen,slidelen,fs);
    semi(subjectIndex,:) = [acc, acc_transfered_LVQ, acc_transfered_QDF];
    disp('finish one');
    Feature_NoStyle_All{subjectIndex}=Feature_NoStyle;
end
