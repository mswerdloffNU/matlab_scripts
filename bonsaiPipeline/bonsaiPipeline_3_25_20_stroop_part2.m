subs = {'S015','S016','S017','S018'};
for i = 1:numel(subs)
    clearvars -except subs i
    sub = subs{i}
    loc_sub = strcat('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\Pilot2\',sub);
    filePath=loc_sub;
    %% select file
    cd(loc_sub)
    Files_sub = dir('*2_allTrials.mat');
    for k=1:length(Files_sub)
        filename=Files_sub(k).name % file to be converted
        if strfind(filename, 'v5')
            Files_sub(k).session = 'v5';
        elseif strfind(filename, 'v6')
            Files_sub(k).session = 'v6';
        end
    end
    T = struct2table(Files_sub); % convert the struct array to a table
    aa_t = sortrows(T, 'session'); % sort the table by session

    % Convert table to structure
    Files = table2struct(aa_t);
    for k=1:length(Files)
        close all
        filename=Files(k).name; % file to be converted
        setNum = k;
        %%
        location = strcat(loc_sub,'\',filename);
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
        cd 'C:\Users\mswerdloff\eeglab14_1_2b'
        eeglab
        
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
        [ALLEEG, EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet+2,'savenew',setICA,'gui','off');
        EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist', eventlistA ); % GUI: 28-May-2019 11:10:03
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet+3,'gui','off');
        EEG  = pop_binlister( EEG , 'BDF', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\EEG_data_withTriggers\binlist9.txt', 'ExportEL', eventlistB, 'IndexEL',  1, 'SendEL2', 'All', 'UpdateEEG', 'on', 'Voutput', 'EEG' ); % GUI: 28-May-2019 11:12:06
        [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
        EEG = pop_epochbin( EEG , [-200.0  800.0],  'pre'); % GUI: 28-May-2019 11:14:08
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet+4,'savenew',setBinned,'gui','off');
        % perform artifact rejection
        EEG = eeg_checkset( EEG );
        EEG = pop_eegthresh(EEG,0,[1:7] ,[-75 -25] ,[75 25] ,[-0.2 -0.1] ,[0.79667 0] ,2,0);
        EEG = pop_rejtrend(EEG,0,[1:7] ,300,50,0.3,2,0);
        EEG = pop_jointprob(EEG,0,[1:7] ,5,5,0,0,0,[],0);
        EEG = pop_rejkurt(EEG,0,[1:7] ,5,5,0,0,0,[],0);
        EEG = pop_rejspec( EEG, 0,'elecrange',[1:7] ,'method','multitaper','threshold',[-50 50;-100 25],'freqlimits',[0 2;20 40],'eegplotcom','set(findobj(''parent'', findobj(''tag'', ''rejtrialica''), ''tag'', ''mantrial''), ''string'', num2str(sum(EEG.reject.icarejmanual)));set(findobj(''parent'', findobj(''tag'', ''rejtrialica''), ''tag'', ''threshtrial''), ''string'', num2str(sum(EEG.reject.icarejthresh)));set(findobj(''parent'', findobj(''tag'', ''rejtrialica''), ''tag'', ''freqtrial''), ''string'', num2str(sum(EEG.reject.icarejfreq)));set(findobj(''parent'', findobj(''tag'', ''rejtrialica''), ''tag'', ''consttrial''), ''string'', num2str(sum(EEG.reject.icarejconst)));set(findobj(''parent'', findobj(''tag'', ''rejtrialica''), ''tag'', ''enttrial''), ''string'', num2str(sum(EEG.reject.icarejjp)));set(findobj(''parent'', findobj(''tag'', ''rejtrialica''), ''tag'', ''kurttrial''), ''string'', num2str(sum(EEG.reject.icarejkurt)));','eegplotplotallrej',1,'eegplotreject',0);         
        pop_rejmenu(EEG,0)
        pause
%         EEG = eeg_rejsuperpose( EEG, 0, 1, 1, 1, 1, 1, 1, 1);
        icarejthresh=ALLEEG(5).reject.icarejthresh;
        icarejconst=ALLEEG(5).reject.icarejconst;
        icarejjp=ALLEEG(5).reject.icarejjp;
        icarejkurt=ALLEEG(5).reject.icarejkurt;
        icarejfreq=ALLEEG(5).reject.icarejfreq;
        icarej=[icarejthresh;icarejconst;icarejjp;icarejkurt;icarejfreq];
        icarej_all=zeros(size(icarej(1,:)));
        for ii = 1:numel(icarej(1,:))
            icarej_all(1,ii)=max(icarej(1:5,ii));
        end
        icarej_all(2,:)=zeros(size(icarej_all(1,:)));
        for ii = 1:numel(icarej_all(1,:))
            icarej_all(2,ii)=ALLEEG(5).event(ii).bini;
        end

        [numel(find(icarej_all(2,:)==1)) numel(find(icarej_all(2,:)==2)) numel(find(icarej_all(2,:)==3)) numel(find(icarej_all(2,:)==4)) numel(find(icarej_all(2,:)==5)) numel(find(icarej_all(2,:)==6)) numel(find(icarej_all(2,:)==7)) numel(find(icarej_all(2,:)==8))]
        idx1=zeros(size(icarej_all(1,:)));
        idx2=zeros(size(icarej_all(1,:)));
        idx3=zeros(size(icarej_all(1,:)));
        idx4=zeros(size(icarej_all(1,:)));
        idx5=zeros(size(icarej_all(1,:)));
        idx6=zeros(size(icarej_all(1,:)));
        idx7=zeros(size(icarej_all(1,:)));
        idx8=zeros(size(icarej_all(1,:)));
        
        for ii  = 1:numel(icarej_all(1,:))
            if icarej_all(1,ii)==0;
                if icarej_all(2,ii)==1
                    idx1(ii)=ii;
                elseif icarej_all(2,ii)==2
                    idx2(ii)=ii;
                elseif icarej_all(2,ii)==3
                    idx3(ii)=ii;
                elseif icarej_all(2,ii)==4
                    idx4(ii)=ii;
                elseif icarej_all(2,ii)==5
                    idx5(ii)=ii;
                elseif icarej_all(2,ii)==6
                    idx6(ii)=ii;
                elseif icarej_all(2,ii)==7
                    idx7(ii)=ii;
                elseif icarej_all(2,ii)==8
                    idx8(ii)=ii;
                end
            elseif icarej_all(1,ii)==1
                if icarej_all(2,ii)==1
                    idx1(ii)=0;
                elseif icarej_all(2,ii)==2
                    idx2(ii)=0;
                elseif icarej_all(2,ii)==3
                    idx3(ii)=0;
                elseif icarej_all(2,ii)==4
                    idx4(ii)=0;
                elseif icarej_all(2,ii)==5
                    idx5(ii)=0;
                elseif icarej_all(2,ii)==6
                    idx6(ii)=0;
                elseif icarej_all(2,ii)==7
                    idx7(ii)=0;
                elseif icarej_all(2,ii)==8
                    idx8(ii)=0;
                end
            end
        end
        idx1=nonzeros(idx1);idx2=nonzeros(idx2);idx3=nonzeros(idx3);idx4=nonzeros(idx4);idx5=nonzeros(idx5);idx6=nonzeros(idx6);idx7=nonzeros(idx7);idx8=nonzeros(idx8);
        [numel(find(idx1)) numel(find(idx2)) numel(find(idx3)) numel(find(idx4)) numel(find(idx5)) numel(find(idx6)) numel(find(idx7)) numel(find(idx8))]
 
%% equalize number of trials
    
        % for n = 5 (assuming no artifact detection will be done)
        numelements = 5;
        % get the randomly-selected indices
        if numel(find(idx1)) >= 5
            clear indices
            indices = randperm(length(idx1));
            indices = indices(1:numelements);
            % choose the subset of a you want
            idx1_5 = idx1(indices);
        else
            idx1_5=idx1;
        end
        
        if numel(find(idx2)) >= 5
        clear indices
        indices = randperm(length(idx2));
        indices = indices(1:numelements);
        % choose the subset of a you want
        idx2_5 = idx2(indices);
        else
            idx2_5=idx2;
        end
        
        if numel(find(idx3)) >= 5
        clear indices
        indices = randperm(length(idx3));
        indices = indices(1:numelements);
        % choose the subset of a you want
        idx3_5 = idx3(indices);
        else
            idx3_5=idx3;
        end
        
        if numel(find(idx4)) >= 5
        clear indices
        indices = randperm(length(idx4));
        indices = indices(1:numelements);
        % choose the subset of a you want
        idx4_5 = idx4(indices);
        else
            idx4_5=idx4;
        end
        
        clear indices
        indices = randperm(length(idx5));
        indices = indices(1:numelements);
        % choose the subset of a you want
        idx5_5 = idx5(indices);
        
        clear indices
        indices = randperm(length(idx6));
        indices = indices(1:numelements);
        % choose the subset of a you want
        idx6_5 = idx6(indices);
        
        clear indices
        indices = randperm(length(idx7));
        indices = indices(1:numelements);
        % choose the subset of a you want
        idx7_5 = idx7(indices);
        
        if strcmp(sub,'S015')==0;
            clear indices
            indices = randperm(length(idx8));
            indices = indices(1:numelements);
            % choose the subset of a you want
            idx8_5 = idx8(indices);
        end
    rand5check = [0 0 0 0 0 0 0 0];
        if strcmp(sub,'S015')==0;
            rand5check_goal = [5 5 5 5 5 5 5 5];
        else
            rand5check_goal = [5 5 5 5 5 5 5 0];
        end
    maxIter=100;

    for iter=1:maxIter
        icarej_eq = zeros(length(icarej_all(1,:)),1);
        for ii = 1:length(idx1_5)
            icarej_eq(idx1_5(ii)) = 1; % non-stroop non-target (blue star)
        end
        for ii = 1:length(idx2_5)
            icarej_eq(idx2_5(ii)) = 2; % non-stroop non-target (blue star)
        end
        for ii = 1:length(idx3_5)
            icarej_eq(idx3_5(ii)) = 3; % non-stroop non-target (blue star)
        end
        for ii = 1:length(idx4_5)
            icarej_eq(idx4_5(ii)) = 4; % non-stroop non-target (blue star)
        end
        for ii = 1:length(idx5_5)
            icarej_eq(idx5_5(ii)) = 5; % non-stroop non-target (blue star)
        end
        for ii = 1:length(idx6_5)
            icarej_eq(idx6_5(ii)) = 6; % stroop non-target (cyan star)
        end
        for ii = 1:length(idx7_5)
            icarej_eq(idx7_5(ii)) = 7; % non-stroop target (magenta circle)
        end
        if strcmp(sub,'S015')==0 
            for ii = 1:length(idx8_5)
                icarej_eq(idx8_5(ii)) = 8; % non-stroop target (black star)
            end
        end
        rand5check = [numel(find(icarej_eq==1)) numel(find(icarej_eq==2)) numel(find(icarej_eq==3)) numel(find(icarej_eq==4)) numel(find(icarej_eq==5)) numel(find(icarej_eq==6)) numel(find(icarej_eq==7)) numel(find(icarej_eq==8))];
        
        if rand5check==rand5check_goal
            break
        elseif iter == maxIter
            warning('Max Iterations reached')
            break
        end
    end
    disp(rand5check)
  
    %%
    icarej_eq(:,2)=zeros(numel(icarej_eq(:,1)),1);
    for ii=1:numel(icarej_eq(:,1))
        if icarej_eq(ii,1)==0
            icarej_eq(ii,2)=1;
        end
    end
    %%
     EEG = pop_rejepoch( EEG, [icarej_eq(:,2)] ,0);
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
        if strcmp(sub,'S015')==0;
            pop_export2text( ERP, erpText,...
                [ 1 2 3 4 5 6 7 8], 'electrodes', 'on', 'precision',  10, 'time', 'on', 'timeunit',  0.001 );
        else
            pop_export2text( ERP, erpText,...
                [ 1 2 3 4 5 6 7], 'electrodes', 'on', 'precision',  10, 'time', 'on', 'timeunit',  0.001 );    
        end
        fnm = sprintf('erp_%s.fig',setName);
        cd(filePath)
%         savefig(fnm)
        
        % save stuff
        naccepted = ERP.ntrials;
        ntotal = ERP.EVENTLIST.trialsperbin;
        info = ERP.history;
        fnm = sprintf('info_part2_%s.mat',setName);
        cd(filePath)
%         save(fnm,'naccepted','ntotal','info','icarej_eq','-mat');
    end
end
% ERP_S016_v5 = pop_loaderp('filename', 'erpset_S016_v5_stroopStimuli_filt_a_b_2_allTrials_eq10_ICA_Num.erp',...
%     'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\Pilot2\noAR');
% 
% codes = zeros(301,1);
% for i = 1:numel(codes)
%     codes(i) = ERP.EVENTLIST.eventinfo(erpFilenamei).code;
% end
% codes_S016_v5 = codes;

