subs = {'S015','S016','S017','S018'};
for i = 1:numel(subs)
    clearvars -except subs i
    sub = subs{i}
    loc_sub = strcat('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\Pilot2\',sub);
    
    %% move to EEGLAB
    cd 'C:\Users\mswerdloff\eeglab14_1_2b'
    eeglab
    
    location = strcat(location2,filename);
    setName = strrep(filename,'.mat','_eq');
    erpName = strcat('erpset_',setName,'_ICA_Num');
    filename_info = strrep(location,'.mat','_info_pt2.mat');
    erpFilename = strrep(erpName,'_ICA_Num','_ICA_Num.erp');
    eventlistA = strrep(location,'.mat','_ICA_EventListA.txt');
    eventlistB = strrep(location,'.mat','_ICA_EventListB.txt');
    startSet = 0;
    setpreICA = strrep(location,'.mat','_preICA.set');
    setICA = strrep(location,'.mat','_ICA.set');
    setBinned = strrep(location,'.mat','_ICA_elist_bins.set');
    setEpoched = strrep(location,'.mat','_ICA_elist_bins_be.set');
    setRejected = strrep(location,'.mat','_ICA_elist_bins_be_rejected.set');
    trialsTxt = strrep(location,'.mat','trialsNum.txt');
    erpText = strrep(location,'.mat','_ICA_Num.txt');
end