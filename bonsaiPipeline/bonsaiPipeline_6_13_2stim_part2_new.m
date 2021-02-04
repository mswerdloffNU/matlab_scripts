close all
clear
clc
subs = {'S003','S005','S005','S007','S008','S009','S010','S012','S013','S014'};

for i = 1:numel(subs)
    sub = subs{i};
    loc_sub = strcat('Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\',sub);
    
    %% move to EEGLAB
    cd 'C:\Users\mswerdloff\eeglab14_1_2b'
    %cd 'C:\Users\maggi\Documents\MATLAB\eeglab14_1_2b'
    eeglab
    %% specify filename
    % projectdir = 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S014\sit\C';
    % cd('Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S003\walk')
    %
    % filename = 'S003_v2_stand_walk_sit_C_0002_filt_a_b_2_allTrials.mat';
    % filePath = 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S003'; % destination folder for erpset
    % location2 = strcat(filePath,'\walk'); % source folder
    
    cd(loc_sub)
    loc_sit = strcat(loc_sub,'\sit'); % source folder
    filePath = loc_sub; % destination folder
    
    loc_stand = strrep(loc_sit,'sit','stand');
    loc_walk = strrep(loc_sit,'sit','walk');
    
    cd(loc_sit)
    Files_sit = dir('*2_allTrials.mat'); % choose 1, 2, or 4 for the order of the butterworth filter
    for k=1:length(Files_sit)
        filename=Files_sit(k).name % file to be converted
        if strfind(filename, 'A')
            Files_sit(k).session = 'A';
        elseif strfind(filename, 'B')
            Files_sit(k).session = 'B';
        elseif strfind(filename, 'C')
            Files_sit(k).session = 'C';
        end
    end
    T = struct2table(Files_sit); % convert the struct array to a table
    aa_t = sortrows(T, 'session'); % sort the table by session
    
    cd(loc_stand)
    Files_stand = dir('*2_allTrials.mat');
    for k=1:length(Files_stand)
        filename=Files_stand(k).name % file to be converted
        if strfind(filename, 'A')
            Files_stand(k).session = 'A';
        elseif strfind(filename, 'B')
            Files_stand(k).session = 'B';
        elseif strfind(filename, 'C')
            Files_stand(k).session = 'C';
        end
    end
    T = struct2table(Files_stand); % convert the struct array to a table
    bb_t = sortrows(T, 'session'); % sort the table by session
    
    cd(loc_walk)
    Files_walk = dir('*2_allTrials.mat');
    for k=1:length(Files_stand)
        filename=Files_walk(k).name % file to be converted
        if strfind(filename, 'A')
            Files_walk(k).session = 'A';
        elseif strfind(filename, 'B')
            Files_walk(k).session = 'B';
        elseif strfind(filename, 'C')
            Files_walk(k).session = 'C';
        end
    end
    T = struct2table(Files_walk); % convert the struct array to a table
    cc_t = sortrows(T, 'session'); % sort the table by session
    
    % Concatenate tables
    merge_t = [aa_t;bb_t;cc_t];
    % Convert table to structure
    Files = table2struct(merge_t)
    
    for k=1:length(Files)
        filename=Files(k).name % file to be converted
        % choose source folder
        if k == 1 || k == 2 || k ==3
            location2 = loc_sit;
        elseif k == 4 || k == 5 || k == 6
            location2 = loc_stand;
        elseif k == 7 || k == 8 || k == 9
            location2 = loc_walk;
        end
        
        setNum = k;
%         filename = 'Maggie_stroopStimuli_v2_unRand_adj_allEasy_v2_filt_a_b_2_allTrials_CatEq';
%         location = ('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\Pilot')
%         filePath = location;
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
        %% open new set
        [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
        EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',location,'setname',setName,'srate',300,'pnts',0,'xmin',0);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet,'gui','off');
        EEG = eeg_checkset( EEG );
        EEG = pop_chanevent(EEG, 8,'edge','leading','edgelen',0);
        [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
        EEG = eeg_checkset( EEG );
        EEG = pop_editset(EEG, 'chanlocs', 'C:\Users\mswerdloff\eeglab14_1_2b\chanlocsDSI7.ced');
        [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet+1,'savenew',setpreICA,'gui','off');
        EEG = pop_runica(EEG, 'extended',startSet,'interupt','on');
        [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet+2,'savenew',setICA,'gui','off');
        % open existing set
        %EEG = pop_loadset('filename','S006_stand_walk_sit_C_0001_filt_a_b_2_allTrials_ICA_elist_bins_be.set','filepath','Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S006\walk\');
        %
        EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist', eventlistA ); % GUI: 28-May-2019 11:10:03
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet+3,'gui','off');
        EEG  = pop_binlister( EEG , 'BDF', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\EEG_data_withTriggers\binlist9.txt', 'ExportEL', eventlistB, 'IndexEL',  1, 'SendEL2', 'All', 'UpdateEEG', 'on', 'Voutput', 'EEG' ); % GUI: 28-May-2019 11:12:06
        [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
        EEG = pop_epochbin( EEG , [-200.0  800.0],  'pre'); % GUI: 28-May-2019 11:14:08
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet+4,'savenew',setBinned,'gui','off');
        % perform artifact rejection
        EEG = eeg_checkset( EEG );
        %
        % EEG = eeg_checkset( EEG );
        % EEG = pop_eegthresh(EEG,0,[1:7] ,[-75 -25] ,[75 25] ,[-0.2 -0.1] ,[0.79667 0] ,2,0);
        % EEG = pop_rejtrend(EEG,0,[1:7] ,300,50,0.3,2,0);
        % promptRejNum = 'enter the number of epochs rejected by trend: ';
        % rejTrend_num = input(promptRejNum);
        % promptRej = 'enter the epoch number: ';
        % for i = 1:numel(rejTrend_num)+1
        %     rejTrend(i) = input(promptRej);
        % end
        % EEG = pop_jointprob(EEG,0,[1:7],5,5,0,1,[],0);
        % rejJointProb = find(TMPREJ);
        % EEG = pop_rejkurt(EEG,0,[1:7],5,5,0,1,[],0);
        % rejKurt = find(TMPREJ);
        % % EEG = pop_jointprob(EEG,0,[1:7],5,5,0,0,set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'mantrial'), 'string', num2str(sum(EEG.reject.icarejmanual))); set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'threshtrial'), 'string', num2str(sum(EEG.reject.icarejthresh))) ; set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'freqtrial'), 'string', num2str(sum(EEG.reject.icarejfreq))) ; set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'consttrial'), 'string', num2str(sum(EEG.reject.icarejconst))) ; set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'enttrial'), 'string', num2str(sum(EEG.reject.icarejjp))) ;set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'kurttrial'), 'string', num2str(sum(EEG.reject.icarejkurt))),[],0);
        % % EEG = pop_rejkurt(EEG,0,[1:7] ,5,5,0,0,
        % %     set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'mantrial'), 'string', num2str(sum(EEG.reject.icarejmanual)));
        % %     set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'threshtrial'), 'string', num2str(sum(EEG.reject.icarejthresh)));
        % %     set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'freqtrial'), 'string', num2str(sum(EEG.reject.icarejfreq)));
        % %     set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'consttrial'), 'string', num2str(sum(EEG.reject.icarejconst)));
        % %     set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'enttrial'), 'string', num2str(sum(EEG.reject.icarejjp)));
        % %     set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'kurttrial'), 'string', num2str(sum(EEG.reject.icarejkurt)));
        % %     '',[],0);
        % EEG = pop_rejspec(EEG,0,'elecrange',[1:7] ,'method','multitaper','threshold',[-50 50;-100 25],'freqlimits',[0 2;20 40],'eegplotplotallrej',2,'eegplotreject',0);
        % % EEG = pop_rejspec( EEG, 0,'elecrange',[1:7] ,'method','multitaper','threshold',[-50 50;-100 25],'freqlimits',[0 2;20 40],'eegplotcom','
        % % set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'mantrial'), 'string', num2str(sum(EEG.reject.icarejmanual)));
        % % set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'threshtrial'), 'string', num2str(sum(EEG.reject.icarejthresh)));
        % % set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'freqtrial'), 'string', num2str(sum(EEG.reject.icarejfreq)));
        % % set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'consttrial'), 'string', num2str(sum(EEG.reject.icarejconst)));
        % % set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'enttrial'), 'string', num2str(sum(EEG.reject.icarejjp)));
        % % set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'kurttrial'), 'string', num2str(sum(EEG.reject.icarejkurt)));','eegplotplotallrej',2,'eegplotreject',0);
        % EEG = eeg_rejsuperpose( EEG, 0, 1, 1, 1, 1, 1, 1, 1);
        % EEG = pop_rejepoch( EEG, [5 46 47 134 142 169 193 200 207 225 226 230 258 272 285] ,0);
        % EEG = pop_rejepoch( EEG, [4 11 12 16 24 25 26 30 33 34 36 39 41 42 43 46 47 49 51 52 53 55 56 60 61 62 64 67 69 70 71 73 87 89 90 94 96 98 99 101 105 106 110 113 114 115 116 117 119 124 125 129 130 132 133 135 138 139 140 141 142 146 148 149 150 153 159 160 161 163 165 166 167 168 170 174 176 177 179 184 186 187 189 191 192 196 197 198 199 212 215 218 219 222 229 230 234 237 238 239 240 241 245 251 254 259 260 262 263 264 265 266 267 270 271 274 275 276 280 287 292 293 299 300] ,0;
        %
        %
        EEG = pop_eegthresh(EEG,0,[1:7] ,[-75 -25] ,[75 25] ,[-0.2 -0.1] ,[0.79667 0] ,2,0);
        EEG = pop_rejtrend(EEG,0,[1:7] ,300,50,0.3,2,0);
        EEG = pop_jointprob(EEG,0,[1:7] ,5,5,0,0,0,[],0);
        EEG = pop_rejkurt(EEG,0,[1:7] ,5,5,0,0,0,[],0);
        EEG = pop_rejspec( EEG, 0,'elecrange',[1:7] ,'method','multitaper','threshold',[-50 50;-100 25],'freqlimits',[0 2;20 40],'eegplotcom','set(findobj(''parent'', findobj(''tag'', ''rejtrialica''), ''tag'', ''mantrial''), ''string'', num2str(sum(EEG.reject.icarejmanual)));set(findobj(''parent'', findobj(''tag'', ''rejtrialica''), ''tag'', ''threshtrial''), ''string'', num2str(sum(EEG.reject.icarejthresh)));set(findobj(''parent'', findobj(''tag'', ''rejtrialica''), ''tag'', ''freqtrial''), ''string'', num2str(sum(EEG.reject.icarejfreq)));set(findobj(''parent'', findobj(''tag'', ''rejtrialica''), ''tag'', ''consttrial''), ''string'', num2str(sum(EEG.reject.icarejconst)));set(findobj(''parent'', findobj(''tag'', ''rejtrialica''), ''tag'', ''enttrial''), ''string'', num2str(sum(EEG.reject.icarejjp)));set(findobj(''parent'', findobj(''tag'', ''rejtrialica''), ''tag'', ''kurttrial''), ''string'', num2str(sum(EEG.reject.icarejkurt)));','eegplotplotallrej',2,'eegplotreject',0);
        pop_rejmenu(EEG,0)
        
        
        
        %% save & epoch bins
        pause
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet+5,'savenew',setRejected,'gui','off');
        ERP = pop_averager( ALLEEG , 'Criterion', trialsTxt,...
            'DSindex',  startSet+6, 'ExcludeBoundary', 'on', 'SEM', 'on' );
        ERP = pop_savemyerp(ERP, 'erpname',...
            erpName, 'filename', erpFilename,...
            'filepath', filePath, 'Warning', 'on');
        ERP = pop_ploterps( ERP, [ 1 2 3 4 5 6 7],  1:7 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 3 3], 'ChLabel',...
            'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'r-' , 'g--' ,'b-.', 'c:', 'k-', 'k--','k:'}, ...
            'LineWidth',  1, 'Maximize',...
            'on', 'Position', [ 103.714 17.7059 106.857 32], 'SEM', 'off', 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0.75, 'xscale',...
            [ -200.0 796.0   -200:200:600 ], 'YDir', 'normal' );
        pop_export2text( ERP, erpText,...
            [ 1 2 3 4 5 6 7], 'electrodes', 'on', 'precision',  10, 'time', 'on', 'timeunit',  0.001 );
        fnm = sprintf('erp_%s.fig',setName);
        cd(filePath)
        savefig(fnm)
        
        % save stuff
        naccepted = ERP.ntrials;
        ntotal = ERP.EVENTLIST.trialsperbin;
        info = ERP.history;
        fnm = sprintf('info_part2_%s.mat',setName);
        cd(filePath)
        save(fnm,'naccepted','ntotal','info','-mat');
    end
    %%
    % EEG = pop_importdata('data','tbl_filt_a_b_2_tr','dataformat','array');
    % EEG = pop_editset(EEG);
    % EEG = pop_chanevent(EEG, 8);
    % eeg_checkset
    % pop_editset() % 'C:\Users\mswerdloff\eeglab14_1_2b\chanlocsDSI7.ced'
    % readlocs() % 'chanedit' format assumed from file extension
    % EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist',...
    %  'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T4\Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_EventListA.txt' ); % GUI: 08-Apr-2019 15:02:09
    % EEG  = pop_binlister( EEG , 'BDF', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\EEG_data_withTriggers\binlist6.txt',...
    %  'ExportEL', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T4\Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_EventListB.txt',...
    %  'IndexEL',  1, 'SendEL2', 'All', 'UpdateEEG', 'on', 'Voutput', 'EEG' ); % GUI: 08-Apr-2019 15:02:57
    % EEG = pop_epochbin( EEG , [-200.0  800.0],  'pre'); % GUI: 08-Apr-2019 15:03:20
    % EEG  = pop_artmwppth( EEG , 'Channel',  1:7, 'Flag',  1, 'Threshold',  100, 'Twindow', [ -200 796.7], 'Windowsize',  200, 'Windowstep',...
    %   100 ); % GUI: 08-Apr-2019 15:03:40
    % ERP = pop_averager( ALLEEG , 'Criterion', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T4\trials84.txt',...
    %  'DSindex',  5, 'ExcludeBoundary', 'on', 'SEM', 'on' );
    % ERP = pop_savemyerp(ERP, 'erpname',...
    %  'erpset_Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_84', 'filename',...
    %  'erpset_Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_84.erp', 'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T4',...
    %  'Warning', 'on');
    % ERP = pop_ploterps( ERP, [ 1 2],  1:7 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 3 3], 'ChLabel',...
    %  'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r--' }, 'LineWidth',  1, 'Maximize',...
    %  'on', 'Position', [ 103.714 17.7059 106.857 32], 'SEM', 'on', 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0.5, 'xscale',...
    %  [ -200.0 796.0   -200:200:600 ], 'YDir', 'normal' );
    % pop_export2text( ERP, 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T4\Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials.txt',...
    %  [ 1 2], 'electrodes', 'on', 'precision',  10, 'time', 'on', 'timeunit',  0.001 );
    % %% first 26
    % ERP = pop_averager( ALLEEG , 'Criterion', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T5\trials_first26.txt',...
    %  'DSindex',  5, 'ExcludeBoundary', 'on', 'SEM', 'on' );
    % ERP = pop_savemyerp(ERP, 'erpname',...
    %  'erpset_Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_first26', 'filename',...
    %  'erpset_Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_first26.erp', 'filepath',...
    %  'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T5', 'Warning',...
    %  'on');
    % ERP = pop_ploterps( ERP, [ 1 2],  1:7 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 3 3], 'ChLabel',...
    %  'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r--' }, 'LineWidth',  1, 'Maximize',...
    %  'on', 'Position', [ 103.714 17.7059 106.857 32], 'SEM', 'on', 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0.5, 'xscale',...
    %  [ -200.0 796.0   -200:200:600 ], 'YDir', 'normal' );
    % pop_export2text( ERP, 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T4\Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_first26.txt',...
    %  [ 1 2], 'electrodes', 'on', 'precision',  10, 'time', 'on', 'timeunit',  0.001 );
    % %% last 26
    % ERP = pop_averager( ALLEEG , 'Criterion', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T6\trials_last26.txt',...
    %  'DSindex',  5, 'ExcludeBoundary', 'on', 'SEM', 'on' );
    % ERP = pop_savemyerp(ERP, 'erpname',...
    %  'erpset_Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_last26', 'filename',...
    %  'erpset_Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_last26.erp', 'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T6',...
    %  'Warning', 'on');
    % ERP = pop_ploterps( ERP, [ 1 2],  1:7 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 3 3], 'ChLabel',...
    %  'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r--' }, 'LineWidth',  1, 'Maximize',...
    %  'on', 'Position', [ 103.714 17.7059 106.857 32], 'SEM', 'on', 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0.5, 'xscale',...
    %  [ -200.0 796.0   -200:200:600 ], 'YDir', 'normal' );
    % pop_export2text( ERP, 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T6\Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_last26.txt',...
    %  [ 1 2], 'electrodes', 'on', 'precision',  10, 'time', 'on', 'timeunit',  0.001 );
    % %%
    % ERP = pop_exporterplabfigure( ERP , 'Filepath', 'C:\Users\mswerdloff\eeglab14_1_2b', 'Format', 'pdf', 'Resolution',  1200, 'SaveMode', 'saveas',...
    %  'Tag', {'ERP_figure' } );
    
    %%
    % sprintf('Make sure files are in the correct folder')
end