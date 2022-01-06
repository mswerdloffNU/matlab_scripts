%% description for sswAccel.m
% use with run->sswAccel
% makes histograms; can change # of bins using ‘edges’ line 441

sprintf('hi!')
addpath('C:\Users\mswerdloff\Documents\GitHub\matlab_scripts\StroopTest')

%% specify source files
for mm = 1:length(subs)
    sub = subs{mm};
    loc_sub = strcat('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\',sub);
    
    %source folders
    loc_sit = strcat(loc_sub,'\sit'); 
    loc_stand = strrep(loc_sit,'sit','stand');
    loc_walk = strrep(loc_sit,'sit','walk');
    
    %sit files
    cd(loc_sit)
    files_all = strcat(sub,'*filt_a_b_2_allTrials.mat');
    Files_sit = dir(files_all);
    for k=1:length(Files_sit)
        Files_sit(k).condition = 'sit';
    end
    files_sit = struct2table(Files_sit);
    
    %stand files
    cd(loc_stand)
    files_all = strcat(sub,'*filt_a_b_2_allTrials.mat');
    Files_stand = dir(files_all);
    for k=1:length(Files_stand)
        Files_stand(k).condition = 'stand';
    end
    files_stand = struct2table(Files_stand);
    
    %walk files
    cd(loc_walk)
    files_all = strcat(sub,'*filt_a_b_2_allTrials.mat');
    Files_walk = dir(files_all);
    for k=1:length(Files_walk)
        Files_walk(k).condition = 'walk';
    end
    files_walk = struct2table(Files_walk);
    
    %concatenate into one variable Files_all
    Files_all = table2struct([files_sit; files_stand; files_walk]);
    if length(Files_all) ~= 9
        pause
    end
    
    %assign session labels
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
    
    %sort by condition, then session
    T = struct2table(Files_all);
    T2 = sortrows(T,'condition');
    aa_t(1:3,:) = sortrows(T2(1:3,:),'session');
    bb_t(1:3,:) = sortrows(T2(4:6,:),'session');
    cc_t(1:3,:) = sortrows(T2(7:9,:),'session');
    
    %congert to struct
    merge_t = [aa_t;bb_t;cc_t];
    Files = table2struct(merge_t);
    
    %% specify destination folders
    loc_dest = strrep(loc_sub,'Pilot2','Pilot2_Accel\12_21_21');
%     cd(loc_dest)
    
    loc_sit_dest = strcat(loc_dest,'\sit'); % source folder
    loc_stand_dest = strrep(loc_dest,'sit','stand');
    loc_walk_dest = strrep(loc_dest,'sit','walk');
    
%     if ~exist('sit', 'dir') % create destination folder if it doesn't already exist
%         mkdir('sit');
%     end    
%     
%     if ~exist('stand', 'dir') % create destination folder if it doesn't already exist
%         mkdir('stand');
%     end   
%     
%     if ~exist('walk', 'dir') % create destination folder if it doesn't already exist
%         mkdir('walk');
%     end
%     
%     cd(loc_sit_dest)
%     if ~exist('A', 'dir') % create destination folder if it doesn't already exist
%         mkdir('A');
%         mkdir('B');
%         mkdir('C');
%     end
%     
%     cd(loc_stand_dest)
%     if ~exist('A', 'dir') % create destination folder if it doesn't already exist
%         mkdir('A');
%         mkdir('B');
%         mkdir('C');
%     end
%     
%     cd(loc_walk_dest)
%     if ~exist('A', 'dir') % create destination folder if it doesn't already exist
%         mkdir('A');
%         mkdir('B');
%         mkdir('C');
%     end
    
    %% initialize variables
    rms_avg = zeros(length(Files),300);
    codesAcceptedS2_all = [];
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
        setNameShort= strrep(filename,'_filt_a_b_2_allTrials.mat','_duration_Accel'); %'Maggie_stroopStimuli_v2_unRand_adj_allEasy_v3_AB02_raw';
        
        %% import eeg time from dsi
        addpath('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\DSI_data\All')
        filename_csv = strrep(filename,'filt_a_b_2_allTrials.mat','raw.csv'); % define csv filename
        
        startRow = 17; % time = 0
        endRow = inf; % time = end of trial
        [Time_dsi] = importRaw(filename_csv, startRow, endRow); % import Time from dsi (csv)
        
        %% import eeg table with triggers
        addpath(loc_source)
        eeg_struct = open(filename);
        eeg_table = [Time_dsi, eeg_struct.tbl_filt_a_b_2_tr(8,:)']; 
        
        %% import list of accepted trials 
        % 1 = targets accepted
        % 2 = nontargets accepted, 
        % 4 = targets that were acceptable but extra and therefore not accepted
        % import allcondsABC_accfrom S2, one sub at a time
        cd(loc_save)
        temp = strcat(subs{mm},'*_acceptedTrials_allconds.mat');
        temp1 = dir(temp);
        filename_acceptedTrials_allconds = temp1.name;
        load(filename_acceptedTrials_allconds)
        
        %% import latencies
        cd(loc_save)
        temp2 = strcat(subs{mm},'*_latency_allconds.mat');
        temp3 = dir(temp2);
        filename_latency_allconds = temp3.name;
        load(filename_latency_allconds)
        %rename allcondsABC_latency and allcondsABC_acc from S2
                if setNum == 1
                    latencyS2 = allcondsABC_latency{1:301,1};
                    codesAcceptedS2 = allcondsABC_acc{1:301,1};
                elseif setNum == 2
                    latencyS2 = allcondsABC_latency{302:602,1};
                    codesAcceptedS2 = allcondsABC_acc{302:602,1};
                elseif setNum == 3
                    latencyS2 = allcondsABC_latency{603:903,1};
                    codesAcceptedS2 = allcondsABC_acc{603:903,1};
                elseif setNum == 4
                    latencyS2 = allcondsABC_latency{1:301,2};
                    codesAcceptedS2 = allcondsABC_acc{1:301,2};
                elseif setNum == 5
                    latencyS2 = allcondsABC_latency{302:602,2};
                    codesAcceptedS2 = allcondsABC_acc{302:602,2};
                elseif setNum == 6
                    latencyS2 = allcondsABC_latency{603:903,2};
                    codesAcceptedS2 = allcondsABC_acc{603:903,2};
                elseif setNum == 7
                    latencyS2 = allcondsABC_latency{1:301,3};
                    codesAcceptedS2 = allcondsABC_acc{1:301,3};
                elseif setNum == 8
                    latencyS2 = allcondsABC_latency{302:602,3};
                    codesAcceptedS2 = allcondsABC_acc{302:602,3};
                elseif setNum == 9
                    latencyS2 = allcondsABC_latency{603:903,3};
                    codesAcceptedS2 = allcondsABC_acc{603:903,3};
                else
                    pause
                end
                
                codesAcceptedS2_all(:,setNum) = codesAcceptedS2;
                for ii = 1:length(codesAcceptedS2)
                    if codesAcceptedS2(ii) == 0
                        codesAcceptedS2_all(ii,setNum) = 9;
                    end
                end
                
        %% import accel
        accelfile = [loc_dsi_all setNameShort '.csv'];
        dataLines = [9, Inf]; % specify times and channels
        [Time_accel, Ax, Ay, Az, Seq] = importRawAccel(accelfile,dataLines); % import
        Fsp = 30; % sampling rate in Hz
        Fn = Fsp/2; % Nyquist frequency
        
        %% combine triggers with accel times
%         trigs = find(eeg_table(:,2));
        trigs = [1; latencyS2+1];
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
        temp4 = zeros(length(trigs)-1,1);
        accel_table = [Time_accel,zeros(length(Time_accel),1)];
        Trigger_accel = zeros(length(Time_accel),1);
        minidx = zeros(length(trigs)-1,1);
        minVal = [];
        % choose nearest value of trigger
        for ii = 1:length(trigs)-1
            n=Time_dsi(trigs(ii+1));
            idx=abs(Time_accel-n);
            [~,minidx(ii)] = min(idx);
            minVal(ii)=Time_accel(minidx(ii));
            if eeg_table(trigs(ii+1),2) == 0
                pause
            else
                Trigger_accel(minidx(ii),setNum) = codesAcceptedS2_all(ii,setNum); %eeg_table(trigs(ii),2);
                temp4(ii) = numel(find(Trigger_accel));
                accel_table(minidx(ii),setNum+1) = codesAcceptedS2_all(ii,setNum); %eeg_table(trigs(ii),2);
            end
        end
        
        targetsAcc = find(codesAcceptedS2_all(:,setNum)==1);
        nonTargetsAcc = find(codesAcceptedS2_all(:,setNum)==2);
        targetsExtraAcc = find(codesAcceptedS2_all(:,setNum)==4);
        trialsRej = find(codesAcceptedS2_all(:,setNum)==9);
        targetLatency = minidx(targetsAcc);
        nonTargetsAccLatency = minidx(nonTargetsAcc);
        targetsExtraAccLatency = minidx(targetsExtraAcc);
        trialsRejLatency = minidx(trialsRej);
        
        accLat(k,mm).targetsAcc = targetsAcc;
        accLat(k,mm).nonTargetsAcc = nonTargetsAcc;
        accLat(k,mm).targetsExtraAcc = targetsExtraAcc;
        accLat(k,mm).trialsRej = trialsRej;
        accLat(k,mm).targetLatency = targetLatency;
        accLat(k,mm).nonTargetsAccLatency = nonTargetsAccLatency;
        accLat(k,mm).targetsExtraAccLatency = targetsExtraAccLatency;
        accLat(k,mm).trialsRejLatency = trialsRejLatency;
        accLat(k,mm).sub = sub;
        accLat(k,mm).loc_source = loc_source;
        accLat(k,mm).setNum = k;
        
        Trigger_accel_targetsAcc = zeros(length(Trigger_accel),1);
        Trigger_accel_nonTargetsAcc = zeros(length(Trigger_accel),1);
        Trigger_accel_targetsExtraAcc = zeros(length(Trigger_accel),1);
        Trigger_accel_trialsRej = zeros(length(Trigger_accel),1);
        
        for ii = 1:length(targetsAcc)
            Trigger_accel_targetsAcc(targetLatency(ii)) = 1;
        end
        for ii = 1:length(nonTargetsAcc)
            Trigger_accel_nonTargetsAcc(nonTargetsAccLatency(ii)) = 2;
        end
        for ii = 1:length(targetsExtraAcc)
            Trigger_accel_targetsExtraAcc(targetsExtraAccLatency(ii)) = 4;
        end
        for ii = 1:length(trialsRej)
            Trigger_accel_trialsRej(trialsRejLatency(ii)) = 9;
        end
        
        %% create table
        tbl_raw = [Ax,Ay,Az]'; % create tbl
        stim = Trigger_accel(:,setNum)';
        tbl_raw_stim = [Ax,Ay,Az,Trigger_accel(:,setNum)]'; % create tbl
        
        tbl_detrend = zeros(size(tbl_raw));
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
%         N = length(tbl_raw); % number of points in the signal
%         X(i,:)=fftshift(fft(tbl_raw(1,:)));
        % Plot all raw unfiltered data
        if figs == 1
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
        end
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
        
        trials_Ax_accepted = trials_Ax(:,accLat(k,mm).targetsAcc);
        trials_Ay_accepted = trials_Ay(:,accLat(k,mm).targetsAcc);
        trials_Az_accepted = trials_Az(:,accLat(k,mm).targetsAcc);
        
        rms_Ax = rms(trials_Ax_accepted);
        rms_Ay = rms(trials_Ay_accepted);
        rms_Az = rms(trials_Az_accepted);
        
        rms_avg = mean([rms_Ax;rms_Ay;rms_Az]);
        rms_mag = sqrt((rms_Ax.*rms_Ax)+(rms_Ay.*rms_Ay)+(rms_Az.*rms_Az));

        datastruct(k).avg = rms_mag; % change this to get mag vs avg
        
        accel_trials(k,mm).rms_mag = rms_mag;
        accel_trials(k,mm).rms_avg = rms_avg;
        accel_trials(k,mm).sub = sub;
        accel_trials(k,mm).loc_source = loc_source;
        accel_trials(k,mm).setNum = k;
        accel_trials(k,mm).trials_Ax = trials_Ax;
        accel_trials(k,mm).trials_Ay = trials_Ay;
        accel_trials(k,mm).trials_Az = trials_Az;        
        accel_trials(k,mm).trials_Ax_accepted = trials_Ax_accepted;
        accel_trials(k,mm).trials_Ay_accepted = trials_Ay_accepted;
        accel_trials(k,mm).trials_Az_accepted = trials_Az_accepted;        
        accel_trials(k,mm).targetsAcc = targetsAcc;
        
        figure
        subplot(1,2,1)
        histogram(rms_mag)
        title('rms mag')
        subplot(1,2,2)
        histogram(rms_avg)
        title('rms avg')
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
    
    rms_sitA = datastruct(1).avg;
    rms_sitB = datastruct(2).avg;
    rms_sitC = datastruct(3).avg;
    rms_standA = datastruct(4).avg;
    rms_standB = datastruct(5).avg;
    rms_standC = datastruct(6).avg;
    rms_walkA = datastruct(7).avg;
    rms_walkB = datastruct(8).avg;
    rms_walkC = datastruct(9).avg;
    
    rms_allsubs(mm).rmssitA = rms_sitA;
    rms_allsubs(mm).rmssitB = rms_sitB;
    rms_allsubs(mm).rmssitC = rms_sitC;
    rms_allsubs(mm).rmsstandA = rms_standA;
    rms_allsubs(mm).rmsstandB = rms_standB;
    rms_allsubs(mm).rmsstandC = rms_standC;
    rms_allsubs(mm).rmswalkA = rms_walkA;
    rms_allsubs(mm).rmswalkB = rms_walkB;
    rms_allsubs(mm).rmswalkC = rms_walkC;
    
    edges = linspace(0, .2, 26); % Create 20 bins.
    
    figure
    subplot(1,3,1)
    histogram(rms_sit, 'BinEdges',edges);
    title('Sit')
    xlabel('Accelerometer RMS Magnitude')
    ylabel('Trials')
    subplot(1,3,2)
    histogram(rms_stand, 'BinEdges',edges);
    title('Stand')
    subplot(1,3,3)
    histogram(rms_walk, 'BinEdges',edges);
    title('Walk')
    
    % save fig
    if savefiles == 1
        fnm = sprintf('rms_ssw_%s.fig',setName);
        cd(loc_dest)
        savefig(fnm)
    end
    
    
    figure
    subplot(1,3,1)
    histogram(rms_A)
    title('A')
    xlabel('Accelerometer RMS Magnitude')
    ylabel('Trials')
    subplot(1,3,2)
    histogram(rms_B)
    title('B')
    subplot(1,3,3)
    histogram(rms_C)
    title('C')
    
    % save fig
    if savefiles == 1
        fnm = sprintf('rms_ABC_%s.fig',setName);
        cd(loc_dest)
        savefig(fnm)
    end
    
    % save rms averages
    fnm = sprintf('rms_all_%s.mat',setName);
    cd(loc_dest)
    if savefiles == 1
        save(fnm,'ntrials_accel','rms_sit','rms_stand','rms_walk','rms_A',...
            'rms_B','rms_C','rms_sitA','rms_sitB','rms_sitC','rms_standA',...
            'rms_standB','rms_standC','rms_walkA','rms_walkB','rms_walkC','-mat');
    end
    
    if figs == 0
        close all
    end
end

% save accel trials
fnm = sprintf('accel_trials_allsubs.mat');
cd(loc_save)
if savefiles == 1
    save(fnm,'accel_trials','-mat');
end
    
% save accelLat
fnm = sprintf('accLat_allsubs.mat');
cd(loc_save)
if savefiles == 1
    save(fnm,'accLat','-mat');
end
    
rms_sit_allsubs = [rms_allsubs(1).rmssit,rms_allsubs(2).rmssit,rms_allsubs(3).rmssit,rms_allsubs(4).rmssit,rms_allsubs(5).rmssit,rms_allsubs(6).rmssit,rms_allsubs(7).rmssit,rms_allsubs(8).rmssit,rms_allsubs(9).rmssit];
rms_stand_allsubs = [rms_allsubs(1).rmsstand,rms_allsubs(2).rmsstand,rms_allsubs(3).rmsstand,rms_allsubs(4).rmsstand,rms_allsubs(5).rmsstand,rms_allsubs(6).rmsstand,rms_allsubs(7).rmsstand,rms_allsubs(8).rmsstand,rms_allsubs(9).rmsstand];
rms_walk_allsubs = [rms_allsubs(1).rmswalk,rms_allsubs(2).rmswalk,rms_allsubs(3).rmswalk,rms_allsubs(4).rmswalk,rms_allsubs(5).rmswalk,rms_allsubs(6).rmswalk,rms_allsubs(7).rmswalk,rms_allsubs(8).rmswalk,rms_allsubs(9).rmswalk];

rms_A_allsubs = [rms_allsubs(1).rmsA,rms_allsubs(2).rmsA,rms_allsubs(3).rmsA,rms_allsubs(4).rmsA,rms_allsubs(5).rmsA,rms_allsubs(6).rmsA,rms_allsubs(7).rmsA,rms_allsubs(8).rmsA,rms_allsubs(9).rmsA];
rms_B_allsubs = [rms_allsubs(1).rmsB,rms_allsubs(2).rmsB,rms_allsubs(3).rmsB,rms_allsubs(4).rmsB,rms_allsubs(5).rmsB,rms_allsubs(6).rmsB,rms_allsubs(7).rmsB,rms_allsubs(8).rmsB,rms_allsubs(9).rmsB];
rms_C_allsubs = [rms_allsubs(1).rmsC,rms_allsubs(2).rmsC,rms_allsubs(3).rmsC,rms_allsubs(4).rmsC,rms_allsubs(5).rmsC,rms_allsubs(6).rmsC,rms_allsubs(7).rmsC,rms_allsubs(8).rmsC,rms_allsubs(9).rmsC];

rms_sitA_allsubs = [rms_allsubs(1).rmssitA,rms_allsubs(2).rmssitA,rms_allsubs(3).rmssitA,rms_allsubs(4).rmssitA,rms_allsubs(5).rmssitA,rms_allsubs(6).rmssitA,rms_allsubs(7).rmssitA,rms_allsubs(8).rmssitA,rms_allsubs(9).rmssitA];
rms_sitB_allsubs = [rms_allsubs(1).rmssitB,rms_allsubs(2).rmssitB,rms_allsubs(3).rmssitB,rms_allsubs(4).rmssitB,rms_allsubs(5).rmssitB,rms_allsubs(6).rmssitB,rms_allsubs(7).rmssitB,rms_allsubs(8).rmssitB,rms_allsubs(9).rmssitB];
rms_sitC_allsubs = [rms_allsubs(1).rmssitC,rms_allsubs(2).rmssitC,rms_allsubs(3).rmssitC,rms_allsubs(4).rmssitC,rms_allsubs(5).rmssitC,rms_allsubs(6).rmssitC,rms_allsubs(7).rmssitC,rms_allsubs(8).rmssitC,rms_allsubs(9).rmssitC];
rms_standA_allsubs = [rms_allsubs(1).rmsstandA,rms_allsubs(2).rmsstandA,rms_allsubs(3).rmsstandA,rms_allsubs(4).rmsstandA,rms_allsubs(5).rmsstandA,rms_allsubs(6).rmsstandA,rms_allsubs(7).rmsstandA,rms_allsubs(8).rmsstandA,rms_allsubs(9).rmsstandA];
rms_standB_allsubs = [rms_allsubs(1).rmsstandB,rms_allsubs(2).rmsstandB,rms_allsubs(3).rmsstandB,rms_allsubs(4).rmsstandB,rms_allsubs(5).rmsstandB,rms_allsubs(6).rmsstandB,rms_allsubs(7).rmsstandB,rms_allsubs(8).rmsstandB,rms_allsubs(9).rmsstandB];
rms_standC_allsubs = [rms_allsubs(1).rmsstandC,rms_allsubs(2).rmsstandC,rms_allsubs(3).rmsstandC,rms_allsubs(4).rmsstandC,rms_allsubs(5).rmsstandC,rms_allsubs(6).rmsstandC,rms_allsubs(7).rmsstandC,rms_allsubs(8).rmsstandC,rms_allsubs(9).rmsstandC];
rms_walkA_allsubs = [rms_allsubs(1).rmswalkA,rms_allsubs(2).rmswalkA,rms_allsubs(3).rmswalkA,rms_allsubs(4).rmswalkA,rms_allsubs(5).rmswalkA,rms_allsubs(6).rmswalkA,rms_allsubs(7).rmswalkA,rms_allsubs(8).rmswalkA,rms_allsubs(9).rmswalkA];
rms_walkB_allsubs = [rms_allsubs(1).rmswalkB,rms_allsubs(2).rmswalkB,rms_allsubs(3).rmswalkB,rms_allsubs(4).rmswalkB,rms_allsubs(5).rmswalkB,rms_allsubs(6).rmswalkB,rms_allsubs(7).rmswalkB,rms_allsubs(8).rmswalkB,rms_allsubs(9).rmswalkB];
rms_walkC_allsubs = [rms_allsubs(1).rmswalkC,rms_allsubs(2).rmswalkC,rms_allsubs(3).rmswalkC,rms_allsubs(4).rmswalkC,rms_allsubs(5).rmswalkC,rms_allsubs(6).rmswalkC,rms_allsubs(7).rmswalkC,rms_allsubs(8).rmswalkC,rms_allsubs(9).rmswalkC];

edges = linspace(0, max(rms_walk_allsubs), 9); % Create 8 bins.
edges_sit = linspace(0, max(rms_sit_allsubs), 9); % Create 8 bins.
edges_stand = linspace(0, max(rms_stand_allsubs), 9); % Create 8 bins.
edges_walk = linspace(0, max(rms_walk_allsubs), 9); % Create 8 bins.

figure
subplot(1,3,1)
histogram(rms_sit_allsubs, 'BinEdges',edges_sit)
set(gca,'FontSize',14)
title('Sit')
ylabel('Trials')
subplot(1,3,2)
histogram(rms_stand_allsubs, 'BinEdges',edges_stand)
set(gca,'FontSize',14)
xlabel('Head Motion RMS')
title('Stand')
subplot(1,3,3)
histogram(rms_walk_allsubs, 'BinEdges',edges_walk)
title('Walk')
set(gca,'FontSize',14)

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
histogram(rms_A_allsubs, 'BinEdges',edges)
title('A')
xlabel('Accelerometer RMS Magnitude')
ylabel('Trials')
subplot(1,3,2)
histogram(rms_B_allsubs, 'BinEdges',edges)
title('B')
subplot(1,3,3)
histogram(rms_C_allsubs, 'BinEdges',edges)
title('C')

% save fig
if savefiles == 1
    fnm = sprintf('rms_ABC_%s.fig',setName);
    cd(loc_save)
    savefig(fnm)
end


figure
subplot(1,3,1)
histogram(rms_sitA_allsubs, 'BinEdges',edges)
title('Sit A')
xlabel('Accelerometer RMS Magnitude')
ylabel('Trials')
subplot(1,3,2)
histogram(rms_sitB_allsubs, 'BinEdges',edges)
title('Sit B')
subplot(1,3,3)
histogram(rms_sitC_allsubs, 'BinEdges',edges)
title('Sit C')

% save fig
if savefiles == 1
    fnm = sprintf('rms_sitABC_%s.fig',setName);
    cd(loc_save)
    savefig(fnm)
end

figure
subplot(1,3,1)
histogram(rms_standA_allsubs, 'BinEdges',edges)
title('Stand A')
xlabel('Accelerometer RMS Magnitude')
ylabel('Trials')
subplot(1,3,2)
histogram(rms_standB_allsubs, 'BinEdges',edges)
title('Stand B')
subplot(1,3,3)
histogram(rms_standC_allsubs, 'BinEdges',edges)
title('Stand C')

% save fig
if savefiles == 1
    fnm = sprintf('rms_standABC_%s.fig',setName);
    cd(loc_save)
    savefig(fnm)
end

figure
subplot(1,3,1)
histogram(rms_walkA_allsubs, 'BinEdges',edges)
title('Walk A')
xlabel('Accelerometer RMS Magnitude')
ylabel('Trials')
subplot(1,3,2)
histogram(rms_walkB_allsubs, 'BinEdges',edges)
title('Walk B')
subplot(1,3,3)
histogram(rms_walkC_allsubs, 'BinEdges',edges)
title('Walk C')

% save fig
if savefiles == 1
    fnm = sprintf('rms_walkABC_%s.fig',setName);
    cd(loc_save)
    savefig(fnm)
end

% save data
fnm = sprintf('rms_all_%s.mat',setName);
cd(loc_save)
if savefiles == 1
    save(fnm,'rms_allsubs','rms_sit_allsubs','rms_stand_allsubs','rms_walk_allsubs','rms_A_allsubs','rms_B_allsubs','rms_C_allsubs','-mat');
end