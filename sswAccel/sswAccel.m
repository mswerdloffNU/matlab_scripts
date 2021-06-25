sprintf('hi!')

%% specify source files
sub = 'S014';
loc_sub = strcat('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\',sub);

loc_sit = strcat(loc_sub,'\sit'); % source folder
loc_stand = strrep(loc_sit,'sit','stand');
loc_walk = strrep(loc_sit,'sit','walk');

cd(loc_sit)
files_all = strcat(sub,'*filt_a_b_2_allTrials.mat');
Files_sit = dir(files_all);
for k=1:length(Files_sit)
    Files_sit(k).condition = 'sit';
end
files_sit = struct2table(Files_sit);

cd(loc_stand)
files_all = strcat(sub,'*filt_a_b_2_allTrials.mat');
Files_stand = dir(files_all);
for k=1:length(Files_stand)
    Files_stand(k).condition = 'stand';
end
files_stand = struct2table(Files_stand);

cd(loc_walk)
files_all = strcat(sub,'*filt_a_b_2_allTrials.mat');
Files_walk = dir(files_all);
for k=1:length(Files_walk)
    Files_walk(k).condition = 'walk';
end
files_walk = struct2table(Files_walk);

Files_all = table2struct([files_sit; files_stand; files_walk]);
if length(Files_all) > 9
    pause
end

for k = 1:length(Files_all)
    filename = Files_all(k).name;
    if strfind(filename,'A')
        Files_all(k).session = 'A';
    elseif strfind(filename,'B')
        Files_all(k).session = 'B';
    elseif strfind(filename,'C')
        Files_all(k).session = 'C';
    end
end

T = struct2table(Files_all);
T2 = sortrows(T,'condition');
aa_t(1:3,:) = sortrows(T2(1:3,:),'session');
bb_t(1:3,:) = sortrows(T2(4:6,:),'session');
cc_t(1:3,:) = sortrows(T2(7:9,:),'session');

merge_t = [aa_t;bb_t;cc_t];
Files = table2struct(merge_t);

%% specify destination folders
loc_dest = strrep(loc_sub,'Pilot2','Pilot2_Accel');

loc_sit_dest = strcat(loc_dest,'\sit'); % source folder
loc_stand_dest = strrep(loc_dest,'sit','stand');
loc_walk_dest = strrep(loc_dest,'sit','walk');

%% import files
for k=1:length(Files)
    filename = Files(k).name % file to be converted
    if k == 1 || k == 2 || k ==3
        location2 = loc_sit_dest;
    elseif k == 4 || k == 5 || k == 6
        location2 = loc_stand_dest;
    elseif k == 7 || k == 8 || k == 9
        location2 = loc_walk_dest;
    end
    
    setNum = k;
    setNameShort= strrep(filename,'_filt_a_b_2_allTrials.mat','_accel'); %'Maggie_stroopStimuli_v2_unRand_adj_allEasy_v3_AB02_raw';
    
    %% import eeg time from dsi
    addpath('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\DSI_data\All')
    filename_csv = strrep(filename,'filt_a_b_2_allTrials.mat','raw.csv');
    
    startRow = 17; % time = 0
    endRow = inf; % time = end of trial
    [Time_csv] = importRaw(filename_csv, startRow, endRow); % import
    
    %% import eeg table
    addpath(loc_sit)
    eeg_struct = open(filename);
    eeg_table = [Time_dsi, eeg_struct.tbl_filt_a_b_2_tr(8,:)'];
    
    %% import accel
    dataLines = [9, Inf]; % specify times and channels
    [Time_accel, Ax, Ay, Az, Seq] = importRawAccel(accelfile,dataLines); % import
    Fsp = 30; % sampling rate in Hz
    Fn = Fsp/2; % Nyquist frequency
    
    %% combined table
    trigs = find(eeg_table(:,2));
    
    % try to find matching times
    for ii = 1:numel(trigs)
        trigTime(ii) = find(Time_accel==Time_dsi(trigs(ii),1))
    end
    
    % resample
    Ax_300 = resample(Ax(1:end),10,1);
    figure
    hold on
    plot([1:10:length(Ax_300)],Ax,'o')
    plot([1:length(Ax_300)],Ax_300(1:end),'.')
    % how do I know that that's good? ^
    
    accel_table = [Time_accel,zeros(length(Time_accel),1)];
    Trigger_accel = zeros(length(Time_accel),1);
    % choose nearest value
    for ii = 1:length(trigs)
        n=Time_dsi(trigs(ii));
        idx=abs(Time_accel-n);
        [~,minidx] = min(idx);
        minVal(ii)=Time_accel(minidx);
        if eeg_table(trigs(ii),2) == 0
            pause
        else
            Trigger_accel(minidx) = eeg_table(trigs(ii),2);
            accel_table(minidx,2) = eeg_table(trigs(ii),2);
        end
    end
    %% create table
    tbl_raw = [Ax,Ay,Az]'; % create tbl
    stim = Trigger_accel';
    tbl_raw_stim = [Ax,Ay,Az,Trigger_accel]'; % create tbl
    
    for i = 1:size(tbl_raw_stim,1)-1
        tbl_detrend(i,:) = tbl_raw(i,:)-mean(tbl_raw(i,:));
    end
    
    [b_accel,a_accel] = butter(2,.5/Fn,'high');
    tbl_filt_a_b_2 = filtfilt(b_accel,a_accel,tbl_detrend(1:3,:)');
    tbl_filt_a_b_2r = filtfilt(b_accel,a_accel,tbl_raw(1:3,:)'); % r = raw
    tbl_filt_a_b_2_tr = [tbl_filt_a_b_2'; stim];
    tbl_filt_a_b_2_tr_r = [tbl_filt_a_b_2r'; stim];
    
    %% Plot data
    cd(loc_sub)
    % Plot the Frequency spectrum of each channel
    N = length(tbl_raw); % number of points in the signal
    X(i,:)=fftshift(fft(tbl_raw(1,:)));
    % Plot all raw unfiltered data
    figure()
    hold on
    for i = 1:3
        plot(tbl_raw(i,:)+200*(1-i))
    end
    hold off
    grid on
    legend('Ax','Ay','Az')
    title('Raw data, stacked')
    fnm = sprintf('Raw data_stacked_%s.fig',setNameShort);
    %     savefig(fnm)
    
    % Plot all detrended data
    figure()
    hold on
    for i = 1:3
        plot(tbl_detrend(i,:)+200*(1-i))
    end
    hold off
    grid on
    legend('Ax','Ay','Az')
    title('Detrended data, stacked')
    fnm = sprintf('Detrended data_stacked_%s.fig',setNameShort);
    %     savefig(fnm)
    
    % Plot all filtered data
    figure()
    hold on
    for i = 1:3
        plot(tbl_filt_a_b_2_tr(i,:)+200*(1-i))
    end
    hold off
    grid on
    legend('Ax','Ay','Az')
    title('Filtered data, stacked')
    fnm = sprintf('Filtered data_stacked_%s.fig',setNameShort);
    %     savefig(fnm)
    
    % Plot filtered data and raw on same axes
    figure()
    r = plot([tbl_raw(1,4000:6000)' tbl_detrend(1,4000:6000)']);
    legend('raw data','detrended data')
    
    figure()
    %     f = plot([tbl_filt_a_b_2r(4000:6000,1) tbl_filt_a_b_2(4000:6000,1) ]);
    hold on
    plot(tbl_filt_a_b_2r(4000:6000,1),'o')
    plot(tbl_filt_a_b_2(4000:6000,1),'.')
    title('Butterworth highpass filtered data (0.5 Hz) implemented using filtfilt')
    legend('8th order','8th order detrended')
    xlabel('Samples')
    ylabel('Potential (uV)')
    fnm = sprintf('Butterworth highpass filtered data_%s.fig',setNameShort);
    %     savefig(fnm)
        
    %% save filtered accel table
    tbl_filt_a_b_2_tr_accel =  tbl_filt_a_b_2_tr_r; % with stim!
    if savefiles == 1
        str_mat = strcat(loc_dest,'\',filename); % table of EEG data (.mat)
        str_mat_accel = strrep(str_mat,'.mat','_accel.mat');
        save(str_mat_accel,'tbl_filt_a_b_2_tr_accel'); % save b,a butter -> filtfilt filtered data
    end
    
    %%
    location_pre = strcat(loc_dest,'\',filename);
    location = strrep(location_pre,'.mat','_accel.mat');
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
    
    %% move to EEGLAB
    cd(loc_eeglab)
    eeglab
    
    %% open new set
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',location,'setname',setName,'srate',300,'pnts',0,'xmin',0);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet,'gui','off');
    EEG = eeg_checkset( EEG );
    EEG = pop_chanevent(EEG, 4,'edge','leading','edgelen',0);
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = eeg_checkset( EEG );
%     EEG = pop_editset(EEG, 'chanlocs', loc_ced);
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet+1,'savenew',setpreICA,'gui','off');
    %     EEG = pop_runica(EEG, 'extended',startSet,'interupt','on');
    [ALLEEG, EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet+2,'savenew',setICA,'gui','off');
    EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist', eventlistA ); % GUI: 28-May-2019 11:10:03
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet+3,'gui','off');
    EEG  = pop_binlister( EEG , 'BDF', loc_binlist, 'ExportEL', eventlistB, 'IndexEL',  1, 'SendEL2', 'All', 'UpdateEEG', 'on', 'Voutput', 'EEG' ); % GUI: 28-May-2019 11:12:06
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = pop_epochbin( EEG , [-200.0  800.0],  'pre'); % GUI: 28-May-2019 11:14:08
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet+4,'savenew',setBinned,'gui','off');
    % perform artifact rejection
    EEG = eeg_checkset( EEG );
    
    %%
    figure();erpimage( mean(EEG.data([1], :),1), eeg_getepochevent( EEG, {'B1(71)'},[],'type'), linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts), 'pz', 10, 1 ,'yerplabel','\muV','erp','on','cbar','on','topo', { [1] EEG.chanlocs EEG.chaninfo } );
    figure();erpimage( mean(EEG.data([1], :),1), eeg_getepochevent( EEG, {'B2(72)'},[],'type'), linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts), 'pz', 10, 1 ,'yerplabel','\muV','erp','on','cbar','on','topo', { [1] EEG.chanlocs EEG.chaninfo } );
    figure();erpimage( mean(EEG.data([1], :),1), eeg_getepochevent( EEG, {'B3(73)'},[],'type'), linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts), 'pz', 10, 1 ,'yerplabel','\muV','erp','on','cbar','on','topo', { [1] EEG.chanlocs EEG.chaninfo } );
    figure();erpimage( mean(EEG.data([1], :),1), eeg_getepochevent( EEG, {'B4(74)'},[],'type'), linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts), 'pz', 10, 1 ,'yerplabel','\muV','erp','on','cbar','on','topo', { [1] EEG.chanlocs EEG.chaninfo } );
    figure();erpimage( mean(EEG.data([1], :),1), eeg_getepochevent( EEG, {'B5(65)'},[],'type'), linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts), 'pz', 10, 1 ,'yerplabel','\muV','erp','on','cbar','on','topo', { [1] EEG.chanlocs EEG.chaninfo } );
    figure();erpimage( mean(EEG.data([1], :),1), eeg_getepochevent( EEG, {'B6(66)'},[],'type'), linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts), 'pz', 10, 1 ,'yerplabel','\muV','erp','on','cbar','on','topo', { [1] EEG.chanlocs EEG.chaninfo } );
    figure();erpimage( mean(EEG.data([1], :),1), eeg_getepochevent( EEG, {'B7(67)'},[],'type'), linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts), 'pz', 10, 1 ,'yerplabel','\muV','erp','on','cbar','on','topo', { [1] EEG.chanlocs EEG.chaninfo } );
    figure();erpimage( mean(EEG.data([1], :),1), eeg_getepochevent( EEG, {'B8(68)'},[],'type'), linspace(EEG.xmin*1000, EEG.xmax*1000, EEG.pnts), 'pz', 10, 1 ,'yerplabel','\muV','erp','on','cbar','on','topo', { [1] EEG.chanlocs EEG.chaninfo } );
    
    %% save & epoch bins
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet+5,'savenew',setRejected,'gui','off');
    ERP = pop_averager( ALLEEG , 'Criterion', trialsTxt,...
        'DSindex',  startSet+6, 'ExcludeBoundary', 'on', 'SEM', 'on' );
    ERP = pop_savemyerp(ERP, 'erpname',...
        erpName, 'filename', erpFilename,...
        'filepath', filePath, 'Warning', 'on');
    if strcmp(sub,'S015')==0;
        ERP = pop_ploterps( ERP, [ 1 2 3 4 5 6 7 8],  1:7 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 3 3], 'ChLabel',...
            'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'r-' , 'g--' ,'b-.', 'c:', 'k-', 'k--','k:','k-.'}, ...
            'LineWidth',  1, 'Maximize',...
            'on', 'Position', [ 103.714 17.7059 106.857 32], 'SEM', 'off', 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0.75, 'xscale',...
            [ -200.0 796.0   -200:200:600 ], 'YDir', 'normal' );
    else
        ERP = pop_ploterps( ERP, [ 1 2 3 4 5 6 7],  1:7 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 3 3], 'ChLabel',...
            'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'r-' , 'g--' ,'b-.', 'c:', 'k-', 'k--','k:'}, ...
            'LineWidth',  1, 'Maximize',...
            'on', 'Position', [ 103.714 17.7059 106.857 32], 'SEM', 'off', 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0.75, 'xscale',...
            [ -200.0 796.0   -200:200:600 ], 'YDir', 'normal' );
        
    end
    if savefiles == 1
        if strcmp(sub,'S015')==0;
            pop_export2text( ERP, erpText,...
                [ 1 2 3 4 5 6 7 8], 'electrodes', 'on', 'precision',  10, 'time', 'on', 'timeunit',  0.001 );
        else
            pop_export2text( ERP, erpText,...
                [ 1 2 3 4 5 6 7], 'electrodes', 'on', 'precision',  10, 'time', 'on', 'timeunit',  0.001 );
        end
        fnm = sprintf('erp_%s.fig',setName);
        cd(filePath)
        savefig(fnm)
    end
    
    % save stuff
    naccepted = ERP.ntrials;
    ntotal = ERP.EVENTLIST.trialsperbin;
    info = ERP.history;
    fnm = sprintf('info_part2_%s.mat',setName);
    cd(filePath)
    if savefiles == 1
        %             save(fnm,'naccepted','ntotal','info','icarej_eq','-mat');
        save(fnm,'naccepted','ntotal','info','-mat');
    end
end

