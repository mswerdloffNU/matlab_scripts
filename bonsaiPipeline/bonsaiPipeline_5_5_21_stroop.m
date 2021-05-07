subs = {'S026_SA_0002'};
% subs = {'S020_SA','S021_SA_0001','S023_SA','S024_SA','S025_SA_0001','S026_SA_0002','S027_SA','S028_SA_0004','S029_SA_0002','S030_SA','S031_SA_0002',...
% 'S032_SA','S033_SA','S034_SA','S034_SA','S035_SA','S036_SA','S037_SA','S038_SA','S039_SA','S040_SA'};
filename_location = 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\DSI_data\StroopAudio\study1\';
addpath('C:\Users\mswerdloff\Documents\GitHub\matlab_scripts\StroopTest')

for i = 1:numel(subs)
% clearvars -except subs i
sub = subs{i}
    loc_sub = strcat('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\study1\',sub);
    
    %% arduino generator
    filename = 'Sub.dsi';
    filename_only = strrep(filename,'Sub',sub);
    filename_duration1 = strrep(filename_only,'.dsi','_duration_raw.csv');
    filename_duration = strcat(filename_location,filename_duration1);
    location = strrep(filename_only,'.dsi','_raw.csv');
    filename_tones = strrep(filename_only,'.dsi','.txt');
    filename_info = strrep(filename_only,'.dsi','_info_pt1.mat');
    setNameShort= strrep(filename_only,'_stroopStimuli.dsi',''); %'Maggie_stroopStimuli_v2_unRand_adj_allEasy_v3_AB02_raw';
    fnameEq =strrep(filename_only,'.dsi', '_v10_ToneLabel.txt');
    fnameLoc = 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\study1\';
    fnameEqLoc=strcat(fnameLoc,fnameEq);
    
    %% Initialize Matrices and Strings
%     ToneLabelCatEq = [];
%     Time_duration = []; LE = []; F4 = []; C4 = []; P4 = []; P3 = []; C3 = []; ...
%         F3 = []; Trigger = []; Time_Offset = []; ADC_Status = []; ADC_Sequence = []; ...
%         Event = []; Comments = [];
%     clear str_mat str_events str_events_csv
%     Pz_LE = []; F4_LE = []; C4_LE = []; P4_LE = []; P3_LE = []; C3_LE = []; F3_LE = [];
%     tbl_raw = [];
%     stim = [];
%     tbl_raw_stim = [];
%     tbl_detrend = [];
%     a1 = []; b1 = [];
%     tbl_filt_a_b_1 = []; tbl_filt_a_b_2 = []; tbl_filt_a_b_4 = [];
%     tbl_filt_a_b_1r = []; tbl_filt_a_b_2r = []; tbl_filt_a_b_4r = [];
%     tbl_filt_a_b_1_tr = []; tbl_filt_a_b_2_tr = []; tbl_filt_a_b_4_tr = [];
%     tbl_filt_a_b_1_tr_r = []; tbl_filt_a_b_2_tr_r = []; tbl_filt_a_b_4_tr_r = [];
%     X = [];

    %% import ToneLabelCat
    startRow = 1;
    endRow = inf;
    cd(loc_sub)
    ToneLabelCatEq = importToneLabelCat(fnameEqLoc, startRow, endRow);
    
    %% import file
    % % specify times and channels
    startRow = 17; % time = 0
    endRow = inf; % time = end of trial   
    [Time_duration,LE,F4,C4,P4,P3,C3,F3,Trigger,Time_Offset,ADC_Status,ADC_Sequence,Event,Comments] = importRaw(filename_duration, startRow, endRow); % import
    
%     vars = {'LE','F4','C4','P4','P3','C3','F3','Time_Offset','ADC_Status','ADC_Sequence','Event','Comments'};
%     clear(vars{:})
    
    %% import non-duration file
    Fsp = 300; % sampling rate in Hz
    Fn = Fsp/2; % Nyquist frequency
    %cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting3_05Hz_30Hz'
    cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\DSI_data\StroopAudio\study1'
    
    % Outline:
    %% Import DSI data
    % specify filenames
    % specify times and channels
    %% Re-reference channels
    %% Save raw EEG data
    %% Import and separate Arduino SD tones
    % import arduino SD tones
    % separate out the tones from the times
    % detect indices of stimuli (ie. nonzero values)
    % % check to make sure the tones and times arent too off (*needs work)
    % re-write stimulus labels at each index
    %% Filter data
    % create butterworth bandpass filters
    % % visualize butterworth filters
    % % other methods of creating filters (not necessary)
    % apply filtfilt to all data except the events
    % transpose back to OG form, and add events back in
    % plot filtered data and raw on same axes
    %% Save filtered EEG data
    
    %% import file
    % % specify filenames
    str_mat = strrep(location,'.csv','.mat'); % table of EEG data (.mat)
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
%     save(str_mat,'tbl_raw'); % save tbl of EEG data
    
    %% set initial Triggers to 240
    Trigger_duration(1) = 240;
    Trigger(1) = 240;
    
    %%
    stim = ToneLabelCatEq';
    tbl_raw_stim = [tbl_raw(1:7,:); stim];
    cd(loc_sub)
    str_mat = strrep(location,'_raw.csv','_raw.mat'); % table of EEG data (.mat)
%     save(str_mat,'tbl_raw_stim'); % re-save raw table with updated event values
    
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
    cd(loc_sub)
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
%     savefig(fnm)
    
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
%     savefig(fnm)
    
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
%     savefig(fnm)
    
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
%     savefig(fnm)
    
    %% save filtered EEG data
    cd(loc_sub)
    % cd 'D:\Other\transfer\data'
    %cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting3_05Hz_30Hz'
    str_mat = strrep(location,'_raw.csv','_filt_a_b_1_allTrials.mat'); % table of EEG data (.mat)
%     save(str_mat,'tbl_filt_a_b_1_tr'); % save b,a butter -> filtfilt filtered data
    str_mat = strrep(location,'_raw.csv','_filt_a_b_2_allTrials.mat'); % table of EEG data (.mat)
%     save(str_mat,'tbl_filt_a_b_2_tr'); % save b,a butter -> filtfilt filtered data
    str_mat = strrep(location,'_raw.csv','_filt_a_b_4_allTrials.mat'); % table of EEG data (.mat)
%     save(str_mat,'tbl_filt_a_b_4_tr'); % save b,a butter -> filtfilt filtered data
    
    %%
end
sprintf('Make sure files are saved in the correct folder')
