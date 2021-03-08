function [source_signal_cut,target_cut]=windows_cutting_G(source_signal,target,winlen,slidelen)

numTrials = length(target);
source_signal_cut = [];
target_cut = [];
for i = 1 : numTrials
    numWin = floor((size(squeeze(source_signal(:,:,i)),2) - winlen)/slidelen)+1;
    source_temp = [];
    target_temp = [];
    for j = 1 : numWin
        source_temp{j,1} = squeeze(source_signal(:,(j-1)*slidelen+1:(j-1)*slidelen+winlen,i));
        target_temp(j,1) = target(i);
    end
    source_signal_cut = [source_signal_cut; source_temp];
    target_cut = [target_cut;target_temp];
end