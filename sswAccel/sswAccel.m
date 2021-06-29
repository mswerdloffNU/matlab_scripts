sprintf('hi!')
addpath('C:\Users\mswerdloff\Documents\GitHub\matlab_scripts\StroopTest')
%% specify source files
for mm = 1:length(subs)
    sub = subs{mm};
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
    
    %%
    rms_avg = zeros(length(Files),300);
    
    %% import files
    for k=1:length(Files)
        filename = Files(k).name % file to be converted
        if k == 1 || k == 2 || k ==3
            location2 = loc_sit_dest;
            loc_source = loc_sit;
        elseif k == 4 || k == 5 || k == 6
            location2 = loc_stand_dest;
            loc_source = loc_stand;
        elseif k == 7 || k == 8 || k == 9
            location2 = loc_walk_dest;
            loc_source = loc_walk;
        end
        
        setNum = k;
        setNameShort= strrep(filename,'_filt_a_b_2_allTrials.mat','_accel'); %'Maggie_stroopStimuli_v2_unRand_adj_allEasy_v3_AB02_raw';
        
        %% import eeg time from dsi
        addpath('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\DSI_data\All')
        filename_csv = strrep(filename,'filt_a_b_2_allTrials.mat','raw.csv');
        
        startRow = 17; % time = 0
        endRow = inf; % time = end of trial
        [Time_dsi] = importRaw(filename_csv, startRow, endRow); % import
        
        %% import eeg table
        addpath(loc_source)
        eeg_struct = open(filename);
        eeg_table = [Time_dsi, eeg_struct.tbl_filt_a_b_2_tr(8,:)'];
        
        %% import accel
        dataLines = [9, Inf]; % specify times and channels
        [Time_accel, Ax, Ay, Az, Seq] = importRawAccel(accelfile,dataLines); % import
        Fsp = 30; % sampling rate in Hz
        Fn = Fsp/2; % Nyquist frequency
        
        %% combined table
        trigs = find(eeg_table(:,2));
        trigTime = zeros(length(trigs),1);
        %     % try to find matching times
        %     for ii = 1:1%numel(trigs)
        %         trigTime(ii) = find(Time_accel==Time_dsi(trigs(ii),1));
        %     end
        
        %     % resample
        %     Ax_300 = resample(Ax(1:end),10,1);
        %     figure
        %     hold on
        %     plot([1:10:length(Ax_300)],Ax,'o')
        %     plot([1:length(Ax_300)],Ax_300(1:end),'.')
        %     % how do I know that that's good? ^
        
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
        EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',location,'setname',setName,'srate',30,'pnts',0,'xmin',0);
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
        trials_Ax = squeeze(ALLEEG(end).data(1,:,:));
        trials_Ay = squeeze(ALLEEG(end).data(2,:,:));
        trials_Az = squeeze(ALLEEG(end).data(3,:,:));
        
        rms_Ax = rms(trials_Ax);
        rms_Ay = rms(trials_Ay);
        rms_Az = rms(trials_Az);
        
        rms_avg = mean([rms_Ax;rms_Ay;rms_Az]);
        datastruct(k).avg = rms_avg;
        
        figure
        histogram(rms_avg)
        
        %% save
        
        % save fig
        if savefiles == 1
            fnm = sprintf('rms_%s.fig',setName);
            cd(location2)
            savefig(fnm)
        end
        
        % save data
        alltrials = ALLEEG(end).data;
        rms_all = [rms_Ax;rms_Ay;rms_Az];
        fnm = sprintf('rms_%s.mat',setName);
        cd(location2)
        if savefiles == 1
            save(fnm,'rms_avg','rms_all','alltrials','-mat');
        end
    end
    
    for k = 1:length(Files)
        ntrials_accel(k) = length(datastruct(k).avg);
    end
    
    rms_sit = [datastruct(1).avg,datastruct(2).avg,datastruct(3).avg];
    rms_stand = [datastruct(4).avg,datastruct(5).avg,datastruct(6).avg];
    rms_walk = [datastruct(7).avg,datastruct(8).avg,datastruct(9).avg];
    
    rms_allsubs(mm).rmssit = rms_sit;
    rms_allsubs(mm).rmsstand = rms_stand;
    rms_allsubs(mm).rmswalk = rms_walk;
 
    rms_A = [datastruct(1).avg,datastruct(4).avg,datastruct(7).avg];
    rms_B = [datastruct(2).avg,datastruct(5).avg,datastruct(8).avg];
    rms_C = [datastruct(3).avg,datastruct(6).avg,datastruct(9).avg];
    
    rms_allsubs(mm).rmsA = rms_A;
    rms_allsubs(mm).rmsB = rms_B;
    rms_allsubs(mm).rmsC = rms_C;
    
    figure
    subplot(1,3,1)
    histogram(rms_sit)
    subplot(1,3,2)
    histogram(rms_stand)
    subplot(1,3,3)
    histogram(rms_walk)
    
    % save fig
    if savefiles == 1
        fnm = sprintf('rms_ssw_%s.fig',setName);
        cd(loc_dest)
        savefig(fnm)
    end
    
    figure
    subplot(1,3,1)
    histogram(rms_A)
    subplot(1,3,2)
    histogram(rms_B)
    subplot(1,3,3)
    histogram(rms_C)
    
    % save fig
    if savefiles == 1
        fnm = sprintf('rms_ABC_%s.fig',setName);
        cd(loc_dest)
        savefig(fnm)
    end
    
    % save data
    fnm = sprintf('rms_all_%s.mat',setName);
    cd(loc_dest)
    if savefiles == 1
        save(fnm,'ntrials_accel','rms_sit','rms_stand','rms_walk','rms_A','rms_B','rms_C','-mat');
    end
end

rms_sit_allsubs = [rms_allsubs(1).rmssit,rms_allsubs(2).rmssit,rms_allsubs(3).rmssit,rms_allsubs(4).rmssit,rms_allsubs(5).rmssit,rms_allsubs(6).rmssit,rms_allsubs(7).rmssit,rms_allsubs(8).rmssit,rms_allsubs(9).rmssit];
rms_stand_allsubs = [rms_allsubs(1).rmsstand,rms_allsubs(2).rmsstand,rms_allsubs(3).rmsstand,rms_allsubs(4).rmsstand,rms_allsubs(5).rmsstand,rms_allsubs(6).rmsstand,rms_allsubs(7).rmsstand,rms_allsubs(8).rmsstand,rms_allsubs(9).rmsstand];
rms_walk_allsubs = [rms_allsubs(1).rmswalk,rms_allsubs(2).rmswalk,rms_allsubs(3).rmswalk,rms_allsubs(4).rmswalk,rms_allsubs(5).rmswalk,rms_allsubs(6).rmswalk,rms_allsubs(7).rmswalk,rms_allsubs(8).rmswalk,rms_allsubs(9).rmswalk];

rms_A_allsubs = [rms_allsubs(1).rmsA,rms_allsubs(2).rmsA,rms_allsubs(3).rmsA,rms_allsubs(4).rmsA,rms_allsubs(5).rmsA,rms_allsubs(6).rmsA,rms_allsubs(7).rmsA,rms_allsubs(8).rmsA,rms_allsubs(9).rmsA];
rms_B_allsubs = [rms_allsubs(1).rmsB,rms_allsubs(2).rmsB,rms_allsubs(3).rmsB,rms_allsubs(4).rmsB,rms_allsubs(5).rmsB,rms_allsubs(6).rmsB,rms_allsubs(7).rmsB,rms_allsubs(8).rmsB,rms_allsubs(9).rmsB];
rms_C_allsubs = [rms_allsubs(1).rmsC,rms_allsubs(2).rmsC,rms_allsubs(3).rmsC,rms_allsubs(4).rmsC,rms_allsubs(5).rmsC,rms_allsubs(6).rmsC,rms_allsubs(7).rmsC,rms_allsubs(8).rmsC,rms_allsubs(9).rmsC];

figure
subplot(1,3,1)
histogram(rms_sit_allsubs,6)
xlim([0 .08])
subplot(1,3,2)
histogram(rms_stand_allsubs,6)
xlim([0 .08])
subplot(1,3,3)
histogram(rms_walk_allsubs,6)
xlim([0 .08])

axisHandle = gca;                         %handle to the axis that contains the histogram
histHandle = axisHandle.Children;         %handle to the histogram
histData = histHandle.Data;               %The first input to histogram()
binEdges = histHandle.BinEdges;           %The second input to histogram() (bin edges)
barHeight = histHandle.Values; 

for ii = 1:6
binsWalk(ii) = round((ii-1)*numel(rms_walk_allsubs)/6);
end

rms_walk_allsubs_sort = sort(rms_walk_allsubs);

rms_walk_allsubs_bin1 = rms_walk_allsubs_sort(1:binsWalk(2));
rms_walk_allsubs_bin2 = rms_walk_allsubs_sort(binsWalk(2)+1:binsWalk(3));
rms_walk_allsubs_bin3 = rms_walk_allsubs_sort(binsWalk(3)+1:binsWalk(4));
rms_walk_allsubs_bin4 = rms_walk_allsubs_sort(binsWalk(4)+1:binsWalk(5));
rms_walk_allsubs_bin5 = rms_walk_allsubs_sort(binsWalk(5)+1:binsWalk(6));
rms_walk_allsubs_bin6 = rms_walk_allsubs_sort(binsWalk(6)+1:end);

% save fig
if savefiles == 1
    fnm = sprintf('rms_ssw_%s.fig',setName);
    cd(loc_save)
    savefig(fnm)
end

figure
subplot(1,3,1)
histogram(rms_A_allsubs)
xlim([0 .08])
subplot(1,3,2)
histogram(rms_B_allsubs)
xlim([0 .08])
subplot(1,3,3)
histogram(rms_C_allsubs)
xlim([0 .08])

% save fig
if savefiles == 1
    fnm = sprintf('rms_ABC_%s.fig',setName);
    cd(loc_save)
    savefig(fnm)
end

% save data
fnm = sprintf('rms_all_%s.mat',setName);
cd(loc_save)
if savefiles == 1
    save(fnm,'rms_allsubs','rms_sit_allsubs','rms_stand_allsubs','rms_walk_allsubs','rms_A_allsubs','rms_B_allsubs','rms_C_allsubs','-mat');
end