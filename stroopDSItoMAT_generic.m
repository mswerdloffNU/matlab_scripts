
clearvars
close all
clc
        filename = 'Maggie_Artifact_Test_raw.csv'; %'Maggie_stroopStimuli_v2_unRand_adj_allEasy_v4_AB00_raw.csv' %'MaggieStroopAudio1_0001_duration_raw.csv';

        %% load files
%         clearvars -except subs i mm level stroop_data_sub filename toneCategory_all timingError_all
        % load dsi csv file
        folder_open = 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\DSI_data\All\'; % folder where file is located
        
        
        filename_duration = strcat(folder_open,filename);
%         folder = 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Testing'; % folder where file should be saved
        folder_save = 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Testing';
        
        filename_location = folder_open;
        filename_only = filename;
        filename_duration1 = strrep(filename_only,'.dsi','_duration_raw.csv');
        filename_duration = strcat(filename_location,filename_duration1);
        location = strrep(filename_only,'.dsi','_raw.csv');
        filename_tones = strrep(filename_only,'.dsi','.txt');
        filename_info = strrep(filename_only,'.dsi','_info_pt1.mat');
        setNameShort= strrep(filename_only,'.csv',''); %'Maggie_stroopStimuli_v2_unRand_adj_allEasy_v3_AB02_raw';
        fnameEq =strrep(filename_only,'stroopStimuli.dsi', 'ToneLabelCatEq.txt');
        fnameLoc = folder_save;
        fnameEqLoc=strcat(fnameLoc,'\',fnameEq);
        
        % specify times and channels
        startRow = 17; % time = 0
        endRow = inf; % time = end of trial
        [Time_duration,LE,F4,C4,P4,P3,C3,F3,Trigger_duration,Time_Offset,ADC_Status,ADC_Sequence,Event,Comments] = importRaw(filename_duration, startRow, endRow); % import
                
        folder = folder_save;
        location = folder_open;
        Trigger=Event;
        loc_sub=folder_open;
        
        events = find(Event);
        for i = 1:numel(events)
            comments{i} = Comments{events(i)};
        end
        artifacts = {Event(events) comments'};
     %% import non-duration file
    Fsp = 300; % sampling rate in Hz
    Fn = Fsp/2; % Nyquist frequency
    %cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting3_05Hz_30Hz'
    cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\DSI_data\All'
    
    % Outline:
    %% Import DSI data
    % specify filenames
        % specify times and channels
    % Re-reference channels
    % Save raw EEG data
    % Import and separate Arduino SD tones
        % import arduino SD tones
        % separate out the tones from the times
        % detect indices of stimuli (ie. nonzero values)
        % % check to make sure the tones and times arent too off (*needs work)
        % re-write stimulus labels at each index
    % Filter data
        % create butterworth bandpass filters
        % % visualize butterworth filters
        % % other methods of creating filters (not necessary)
        % apply filtfilt to all data except the events
        % transpose back to OG form, and add events back in
        % plot filtered data and raw on same axes
    % Save filtered EEG data
    
    %% import file
    % % specify filenames
    str_mat_raw = strrep(fnameEqLoc,'.csv','.mat'); % table of EEG data (.mat)
    % str_ascii = strrep(filename,'.csv','.txt'); % table of EEG data (.txt)
    str_events = strrep(location,'.csv',''); % table of events
    str_events_csv = strrep(location,'.csv','_eventsMatlab.csv'); % table of events (.csv)
    
%     % % specify times and channels
%     startRow = 17; % time = 0
%     endRow = inf; % time = end of trial
%     [Time,LE,F4,C4,P4,P3,C3,F3,Trigger,Time_Offset,ADC_Status,ADC_Sequence,Event,Comments] = importRaw(location, startRow, endRow); % import
%     
    %% Re-reference channels
    Pz_LE = -1*LE; % reference Pz to LE
    F4_LE = F4-LE; C4_LE = C4-LE; P4_LE = P4-LE; P3_LE = P3-LE; C3_LE = C3-LE; F3_LE = F3-LE; % reference all other channels to LE
    
    %% save raw EEG data
    tbl_raw = [Pz_LE,F4_LE,C4_LE,P4_LE,P3_LE,C3_LE,F3_LE,Trigger]'; % create tbl
    % cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting3_05Hz_30Hz'
    cd(loc_sub)
    save(str_mat_raw,'tbl_raw'); % save tbl of EEG data
    
    %% set initial Triggers to 240
    % Trigger_duration(1) = 240;
    %Trigger(1) = 240;
%      stim = ToneLabelCatEq';
    stim=Trigger'; % replace with previous line
    cd(loc_sub)
    str_mat = strrep(fnameEqLoc,'_raw.csv','_raw.mat'); % table of EEG data (.mat)
    save(str_mat,'tbl_raw'); % re-save raw table with updated event values
    
     %% plot to check everything is aligned
%     tbl_raw_alltrials = tbl_raw;
%     tonesDSI = tbl_raw_alltrials(8,k_k)';
%     timeline3 = ones(numel(timeDSI),1)*8.1;
%     tonelabelsDSI = num2str(tonesDSI);
    
    %% remove DC bias
    for i = 1:size(tbl_raw,1)-1
        tbl_detrend(i,:) = tbl_raw(i,:)-mean(tbl_raw(i,:));
    end
    
    %% filter data
    % create  worth bandpass filters
    [b1,a1] = butter(1,[0.1 30]/Fn);
    [b2,a2] = butter(2,[0.1 30]/Fn);
    [b4,a4] = butter(4,[0.1 30]/Fn);
    
    % apply filtfilt
    tbl_filt_a_b_1 = filtfilt(b1,a1,tbl_detrend(1:7,:)');
    tbl_filt_a_b_2 = filtfilt(b2,a2,tbl_detrend(1:7,:)');
    tbl_filt_a_b_4 = filtfilt(b4,a4,tbl_detrend(1:7,:)');
    
    tbl_filt_a_b_1r = filtfilt(b1,a1,tbl_raw(1:7,:)'); % r = raw
    tbl_filt_a_b_2r = filtfilt(b2,a2,tbl_raw(1:7,:)'); % r = raw
    tbl_filt_a_b_4r = filtfilt(b4,a4,tbl_raw(1:7,:)'); % r = raw
    
    % transpose back to OG form, and add events back in (tr = transposed)
    tbl_filt_a_b_1_tr = [tbl_filt_a_b_1'; stim];
    tbl_filt_a_b_2_tr = [tbl_filt_a_b_2'; stim];
    tbl_filt_a_b_4_tr = [tbl_filt_a_b_4'; stim];
    
    tbl_filt_a_b_1_tr_r = [tbl_filt_a_b_1r'; stim];
    tbl_filt_a_b_2_tr_r = [tbl_filt_a_b_2r'; stim];
    tbl_filt_a_b_4_tr_r = [tbl_filt_a_b_4r'; stim];
    
    %% Plot data
    cd('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Testing')
    % Plot the Frequency spectrum of each channel
    N = length(tbl_raw); % number of points in the signal
    X(i,:)=fftshift(fft(tbl_raw(1,:)));
    % Plot all raw unfiltered data
    figure()
    hold on
    for i = 1:7
        plot(tbl_raw(i,:)+200*(1-i))
    end
    hold off
    grid on
    legend('Pz','F4','C4','P4','P3','C3','F3')
    title('Raw data, stacked, referenced to LE')
    fnm = sprintf('Raw data_stacked_referenced to LE_%s.fig',setNameShort);
    savefig(fnm)
    
    % Plot all detrended data
    figure()
    hold on
    for i = 1:7
        plot(tbl_detrend(i,:)+200*(1-i))
    end
    hold off
    grid on
    legend('Pz','F4','C4','P4','P3','C3','F3')
    title('Detrended data, stacked, referenced to LE')
    fnm = sprintf('Detrended data_stacked_referenced to LE_%s.fig',setNameShort);
    savefig(fnm)
    
    % Plot all filtered data
    figure()
    hold on
    for i = 1:7
        plot(tbl_filt_a_b_1_tr(i,:)+200*(1-i))
    end
    hold off
    grid on
    legend('Pz','F4','C4','P4','P3','C3','F3')
    title('Filtered data, stacked, referenced to LE')
    fnm = sprintf('Filtered data_stacked_referenced to LE_%s.fig',setNameShort);
    savefig(fnm)
    
    % Plot filtered data and raw on same axes
    figure()
    r = plot([tbl_raw(1,4000:6000)' tbl_detrend(1,4000:6000)']);
    legend('raw data','detrended data')
    figure()
    f = plot([tbl_filt_a_b_1r(4000:6000,1) tbl_filt_a_b_2r(4000:6000,1) tbl_filt_a_b_4r(4000:6000,1) tbl_filt_a_b_1(4000:6000,1) tbl_filt_a_b_2(4000:6000,1) tbl_filt_a_b_4(4000:6000,1)]);
    title('Butterworth bandpass filtered data (0.1-30 Hz) implemented using filtfilt')
    legend('4th order','8th order','16th order','4th order detrended','8th order detrended','16th order detrended')
    xlabel('Samples')
    ylabel('Potential (uV)')
    fnm = sprintf('Butterworth bandpass filtered data_%s.fig',setNameShort);
    savefig(fnm)
    
    %% save filtered EEG data
    cd(loc_sub)
    % cd 'D:\Other\transfer\data'
    %cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting3_05Hz_30Hz'
    str_mat_1 = strrep(fnameEqLoc,'_raw.csv','_filt_a_b_1_allTrials.mat'); % table of EEG data (.mat)
    save(str_mat_1,'tbl_filt_a_b_1_tr'); % save b,a butter -> filtfilt filtered data
    str_mat_2 = strrep(fnameEqLoc,'_raw.csv','_filt_a_b_2_allTrials.mat');  % table of EEG data (.mat)
    save(str_mat_2,'tbl_filt_a_b_2_tr'); % save b,a butter -> filtfilt filtered data
    str_mat_4 = strrep(fnameEqLoc,'_raw.csv','_filt_a_b_4_allTrials.mat'); % table of EEG data (.mat)
    save(str_mat_4,'tbl_filt_a_b_4_tr'); % save b,a butter -> filtfilt filtered data
    
    %%
    clearvars -except setNameShort fnameEqLoc location folder_save
        setNameLong = strrep(setNameShort,'_raw','_filt_a_b_2_allTrials');
        setName = strcat(setNameLong,'_eq');
        erpName = strcat('erpset_',setName,'_ICA_Num');
        filename_info = strrep(fnameEqLoc,'.csv','_info_pt2.mat');
        erpFilename = strrep(erpName,'_ICA_Num','_ICA_Num.erp');
        eventlistA = strcat(folder_save,'\',setName,'_ICA_EventListA.txt');
        eventlistB = strcat(folder_save,'\',setName,'_ICA_EventListB.txt');
        startSet = 0;
        setpreICA = strcat(folder_save,'\',setName,'_preICA.set');
        setICA = strcat(folder_save,'\',setName,'_ICA.set');
        setBinned = strcat(folder_save,'\',setName,'_ICA_elist_bins.set');
        setEpoched = strcat(folder_save,'\',setName,'_ICA_elist_bins_be.set');
        setRejected = strcat(folder_save,'\',setName,'_ICA_elist_bins_be_rejected.set');
        trialsTxt = strcat(folder_save,'\',setName,'trialsNum.txt');
        erpText = strcat(folder_save,'\',setName,'_ICA_Num.txt');
        import_set = strcat(folder_save,'\',setNameLong,'.mat');
        %% move to EEGLAB folder
        cd 'C:\Users\mswerdloff\eeglab14_1_2b'
        
        %% open new set
        [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
        EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',import_set,'setname',setName,'srate',300,'pnts',0,'xmin',0);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet,'gui','off');
        EEG = eeg_checkset( EEG );
        EEG = pop_chanevent(EEG, 8,'edge','leading','edgelen',0);
        [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
        EEG = eeg_checkset( EEG );
        EEG = pop_editset(EEG, 'chanlocs', 'C:\Users\mswerdloff\eeglab14_1_2b\chanlocsDSI7.ced');
        [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet+1,'savenew',setpreICA,'gui','off');
        EEG = pop_runica(EEG, 'extended',startSet,'interupt','on');
        [ALLEEG, EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet+2,'savenew',setICA,'gui','off');
        eeglab redraw