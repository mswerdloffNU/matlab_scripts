%% description of selfP3.m
% building P3 on my own
% Makes p3_rms.mat struct
% doesn’t make any figs

%% gather P3 data

clear
%% this loads all subs
load('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\Pilot2_rejectedAcceptedTrials_allSubs_eq.mat')
load('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\codes_allSubs.mat') %codes

%%
all_possible_subs = {'S003','S006','S007','S008','S009','S010','S012','S013','S014'};
% had problems with: 'S006','S008','S009'
% subs =  {'S003','S007','S010','S012','S013','S014'};
% run all subs
subs = all_possible_subs;
% subs = {'S006'}; % stim conversion
% subs = {'S026_SA_0002'}; % pt 1
loc_user = 'C:\Users\mswerdloff\';
loc_data = 'Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\';
loc_eeglab = [loc_user 'eeglab\eeglab2021_0'];
loc_source = [loc_data 'EEG\Matlab_data\Pilot2\'];
loc_save = [loc_data 'EEG\Matlab_data\Pilot2_Accel\12_21_21\'];
savefiles = 2; % 0 is off; 1 is on; 2 is troubleshooting on

for mm = 1:length(subs)
    sub = subs{mm};
    
    clearvars x_all_combined x_all codes_all
    
    if strcmp(sub,'S003')==1
        code_rejected = table2array(RejectedTrials_S003_eq);
        codesAll = codes_all_S003;
    elseif strcmp(sub,'S006')==1
        code_rejected = table2array(RejectedTrials_S006_eq);
        codesAll = codes_all_S006;
    elseif strcmp(sub,'S007')==1
        code_rejected = table2array(RejectedTrials_S007_eq);
        codesAll = codes_all_S007;
    elseif strcmp(sub,'S008')==1
        code_rejected = table2array(RejectedTrials_S008_eq);
        codesAll = codes_all_S008;
    elseif strcmp(sub,'S009')==1
        code_rejected = table2array(RejectedTrials_S009_eq);
        codesAll = codes_all_S009;
    elseif strcmp(sub,'S010')==1
        code_rejected = table2array(RejectedTrials_S010_eq);
        codesAll = codes_all_S010;
    elseif strcmp(sub,'S012')==1
        code_rejected = table2array(RejectedTrials_S012_eq);
        codesAll = codes_all_S012;
    elseif strcmp(sub,'S013')==1
        code_rejected = table2array(RejectedTrials_S013_eq);
        codesAll = codes_all_S013;
    elseif strcmp(sub,'S014')==1
        code_rejected = table2array(RejectedTrials_S014_eq);
        codesAll = codes_all_S014;
    else
        pause
    end
    
    codes_rejected_sit = [code_rejected(1:301,1); code_rejected(302:602,1); code_rejected(603:903,1)]; % sit A, B, C
    codes_rejected_stand = [code_rejected(1:301,2); code_rejected(302:602,2); code_rejected(603:903,2)]; % stand A, B, C
    codes_rejected_walk = [code_rejected(1:301,3); code_rejected(302:602,3); code_rejected(603:903,3)]; % walk A, B, C
    codes_rejected = [codes_rejected_sit, codes_rejected_stand, codes_rejected_walk];
    
    codes_sit = [codesAll(:,1);codesAll(:,2);codesAll(:,3)];
    codes_stand = [codesAll(:,4);codesAll(:,5);codesAll(:,6)];
    codes_walk = [codesAll(:,7);codesAll(:,8);codesAll(:,9)];
    codes_types = [codes_sit,codes_stand,codes_walk];
    
    sessions = {'A' 'B' 'C'};
    cond = {'sit' 'stand' 'walk'};
    filepaths = {};
    for ii = 1:numel(cond)
        filepaths{ii} =  [loc_source sub '\' cond{ii}];
    end
    
    targets_accepted = zeros(size(codes_types));
    nontargets_accepted = zeros(size(codes_types));
    codes_accepted = zeros(size(codes_types));
    
    for nn = 1:numel(cond)
        for ii = 1:size(codes_types,1)
            if codes_rejected(ii,nn) == 0 && codes_types(ii,nn) == 1
                targets_accepted(ii,nn) = 1;
                codes_accepted(ii,nn) = 1;
            elseif codes_rejected(ii,nn) == 0 && codes_types(ii,nn) == 2
                nontargets_accepted(ii,nn) = 2;
                codes_accepted(ii,nn) = 2;
            end
        end
    end
    
    % [numel(find(targets_accepted(1:301,1)==1)) numel(find(targets_accepted(302:602,1)==1)) numel(find(targets_accepted(603:903,1)==1))]
    
    [numel(find(targets_accepted(:,1)==1)) numel(find(targets_accepted(:,2)==1)) numel(find(targets_accepted(:,3)==1))]
    
    %%
    sessions = {'A' 'B' 'C'};
    cond = {'sit' 'stand' 'walk'};
    filepaths = {};
    for ii = 1:numel(cond)
        filepaths{ii} =  [loc_source sub '\' cond{ii}];
    end
    
    sitABC_acc = []; standABC_acc = []; walkABC_acc = [];
    
    for nn = 1:numel(cond)
        
        % find filename for each session A, B, and C
        cd(filepaths{nn})
        file_A = strcat(sub,'*_A','*_filt_a_b_2_allTrials_eq9_ICA_elist_bins.set');
        file_B = strcat(sub,'*_B','*_filt_a_b_2_allTrials_eq9_ICA_elist_bins.set');
        file_C = strcat(sub,'*_C','*_filt_a_b_2_allTrials_eq9_ICA_elist_bins.set');
        File_A = dir(file_A);
        File_B = dir(file_B);
        File_C = dir(file_C);
        filename_sesssionA = File_A.name;
        filename_sesssionB = File_B.name;
        filename_sesssionC = File_C.name;
        
        %% move to EEGLAB
        cd(loc_eeglab)
        eeglab
        
        % load datasets for A, B, and C
        EEG = pop_loadset( 'filename', filename_sesssionA, 'filepath', filepaths{nn});
        [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
        EEG = eeg_checkset( EEG );%
        EEG = pop_loadset( 'filename', filename_sesssionB, 'filepath', filepaths{nn});
        [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
        EEG = eeg_checkset( EEG );
        EEG = pop_loadset( 'filename', filename_sesssionC, 'filepath', filepaths{nn});
        [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
        EEG = eeg_checkset( EEG );
        eeglab redraw
        
        %%
        labelz = []; target_alt = [];
        for ii = 1:length(ALLEEG(1).epoch)
            labelz{ii} = ALLEEG(1).epoch(ii).eventbinlabel;
            if strcmp(labelz{ii}{1},'B2(2)')==1
                target_alt(ii) = 0;
            elseif strcmp(labelz{ii}{1},'B1(1)')==1
                target_alt(ii) = 1;
            else
                pause
            end
        end
        
        kk = 1;
        for ii = 1:length(target_alt)
            if target_alt(ii) == 1
                data_accA_pz_target_alt(:,kk) = ALLEEG(1).data(1,:,ii);
                kk = kk + 1;
            end
        end
        
        labelz = []; target_alt = [];
        for ii = 1:length(ALLEEG(2).epoch)
            labelz{ii} = ALLEEG(2).epoch(ii).eventbinlabel;
            if strcmp(labelz{ii}{1},'B2(2)')==1
                target_alt(ii) = 0;
            elseif strcmp(labelz{ii}{1},'B1(1)')==1
                target_alt(ii) = 1;
            else
                pause
            end
        end
        
        kk = 1;
        for ii = 1:length(target_alt)
            if target_alt(ii) == 1
                data_accB_pz_target_alt(:,kk) = ALLEEG(2).data(1,:,ii);
                kk = kk + 1;
            end
        end
        
        labelz = []; target_alt = [];
        for ii = 1:length(ALLEEG(3).epoch)
            labelz{ii} = ALLEEG(3).epoch(ii).eventbinlabel;
            if strcmp(labelz{ii}{1},'B2(2)')==1
                target_alt(ii) = 0;
            elseif strcmp(labelz{ii}{1},'B1(1)')==1
                target_alt(ii) = 1;
            else
                pause
            end
        end
        
        kk = 1;
        for ii = 1:length(target_alt)
            if target_alt(ii) == 1
                data_accC_pz_target_alt(:,kk) = ALLEEG(3).data(1,:,ii);
                kk = kk + 1;
            end
        end
        %%
        data_accA_pz = squeeze(ALLEEG(1).data(1,:,:));
        typeA = [ALLEEG(1).urevent.type].';
        latencyA = [ALLEEG(1).urevent.latency].';
        if strcmp('sit',cond{nn})==1 && strcmp(sub,'S008')==1
            latencyA_new = latencyA(1:end-1);
            typeA_new = typeA(1:end-1);
            latencyA = latencyA_new;
            typeA = typeA_new;
        end
        sessionA_rej = [latencyA, typeA, code_rejected(1:301,nn)];
        
        data_accB_pz = squeeze(ALLEEG(2).data(1,:,:));
        typeB = [ALLEEG(2).urevent.type].';
        latencyB = [ALLEEG(2).urevent.latency].';
        if strcmp(sub,'S009') == 1 && strcmp('sit',cond{nn})==1 %% S009 sit B
            latencyB_new = [latencyB;zeros(301-length(latencyB),1)];
            typeB_new = [typeB;zeros(301-length(latencyB),1)];
            %   sessionB_rej = [latencyB_new, typeB_new, zeros(301,1)];
            latencyB = latencyB_new;
            typeB = typeB_new;
        elseif strcmp(sub,'S006') == 1 && strcmp('stand',cond{nn})==1 %% S006 stand B
            latencyB_new = [latencyB;zeros(301-length(latencyB),1)];
            typeB_new = [typeB;zeros(301-length(latencyB),1)];
            latencyB = latencyB_new;
            typeB = typeB_new;
        end
        sessionB_rej = [latencyB, typeB, code_rejected(302:602,nn)];
        
        data_accC_pz = squeeze(ALLEEG(3).data(1,:,:));
        typeC = [ALLEEG(3).urevent.type].';
        latencyC = [ALLEEG(3).urevent.latency].';
        sessionC_rej = [latencyC, typeC, code_rejected(603:903,nn)];
        
        typesABC = [typeA;typeB;typeC];
        
        session_num = zeros(length(typeA),2);
        %         kk = 1;
        for ii = 1:length(typeA)
            if sessionA_rej(ii,3) == 0
                session_num(ii,1) = ii;
                %                 kk = kk + 1;
                session_num(ii,2) = sessionA_rej(ii,2);
            elseif sessionA_rej(ii,3) ~= 0
                session_num(ii,1) = 0;
                session_num(ii,2) = 0;
            else
                pause
            end
        end
        
        sessionA_epoch_acc_targets = find(session_num(:,2) == 1);
        kk=[]; jj = []; data_accA_pz_target = zeros(300,length(sessionA_epoch_acc_targets));
        for ii = 1:numel(sessionA_epoch_acc_targets)
            kk = sessionA_epoch_acc_targets(ii);
            jj = session_num(kk,1)-1;
%             if strcmp(sub,'S008')==1 && strcmp('sit',cond{nn})==1 % sit A S008
%                 sprintf('Warning: S008 sit A contains no accepted targets')
% %                 data_accA_pz_target(:,ii) = [];
%             else
            if jj <= size(data_accC_pz,2)
                data_accA_pz_target(:,ii) = data_accA_pz(:,jj);
            else
                sub
                nn
                sprintf('Warning: session A contains an error in number of targets')
                pause
            end
%             end
        end
        
        sessionA_epoch_acc_nontargets = find(session_num(:,2) == 2);
        kk=[]; jj = []; data_accA_pz_nontarget = zeros(300,length(sessionA_epoch_acc_nontargets));
        for ii = 1:numel(sessionA_epoch_acc_nontargets)
            kk = sessionA_epoch_acc_nontargets(ii);
            jj = session_num(kk,1)-1;
            if jj <= size(data_accA_pz,2)
                data_accA_pz_nontarget(:,ii) = data_accA_pz(:,jj);
            else
                sub
                nn
                sprintf('Warning: session A contains an error in number of nontargets')
                pause
            end
        end
        
        session_num = zeros(length(typeB),2);
        %         kk = 1;
        for ii = 1:length(typeB)
            if sessionB_rej(ii,3) == 0
                session_num(ii,1) = ii;
                %                 kk = kk + 1;
                session_num(ii,2) = sessionB_rej(ii,2);
            elseif sessionB_rej(ii,3) ~= 0
                session_num(ii,1) = 0;
                session_num(ii,2) = 0;
            else
                pause
            end
        end
        
        sessionB_epoch_acc_targets = find(session_num(:,2) == 1);
        kk=[]; jj = []; data_accB_pz_target = zeros(300,length(sessionB_epoch_acc_targets));
        for ii = 1:numel(sessionB_epoch_acc_targets)
            kk = sessionB_epoch_acc_targets(ii);
            jj = session_num(kk,1)-1;
%             if strcmp(sub,'S006')==1 && strcmp('stand',cond{nn})==1 % stand B S006
%                 sprintf('Warning: S006 stand B contains no accepted targets')
% %                 data_accB_pz_target(:,ii) = [];  
%             elseif strcmp(sub,'S009')==1 && strcmp('sit',cond{nn})==1 % sit B S009
%                 sprintf('Warning: S009 sit B contains no accepted targets')
% %                 data_accB_pz_target(:,ii) = [];            
%             else
            if jj <= size(data_accB_pz,2)
                data_accB_pz_target(:,ii) = data_accB_pz(:,jj);
            else
                sub
                nn
                sprintf('Warning: session B contains an error in number of targets')
                pause
            end
%             end
        end
        
        sessionB_epoch_acc_nontargets = find(session_num(:,2) == 2);
        kk=[]; jj = []; data_accB_pz_nontarget = zeros(300,length(sessionB_epoch_acc_nontargets));
        for ii = 1:numel(sessionB_epoch_acc_nontargets)
            kk = sessionB_epoch_acc_nontargets(ii);
            jj = session_num(kk,1)-1;
            if jj <= size(data_accB_pz,2)
                data_accB_pz_nontarget(:,ii) = data_accB_pz(:,jj);
            else
                sub
                nn
                sprintf('Warning: session B contains an error in number of nontargets')
%                 pause
            end
        end
        
        session_num = zeros(length(typeC),2);
        %         kk = 0;
        for ii = 1:length(typeC)
            %             kk = kk + 1;
            if sessionC_rej(ii,3) == 0
                session_num(ii,1) = ii;
                session_num(ii,2) = sessionC_rej(ii,2);
            elseif sessionC_rej(ii,3) ~= 0
                session_num(ii,1) = 0;
                session_num(ii,2) = 0;
            else
                pause
            end
        end
        
        sessionC_epoch_acc_targets = find(session_num(:,2) == 1);
        kk=[]; jj = []; data_accC_pz_target = zeros(300,length(sessionC_epoch_acc_targets));
        for ii = 1:numel(sessionC_epoch_acc_targets)
            kk = sessionC_epoch_acc_targets(ii)
            jj = session_num(kk,1)-1
            if jj <= size(data_accC_pz,2)
                data_accC_pz_target(:,ii) = data_accC_pz(:,jj);
            else
                sub
                nn
                sprintf('Warning: session C contains an error in number of targets')
                pause
            end
        end
        
        sessionC_epoch_acc_nontargets = find(session_num(:,2) == 2);
        kk=[]; jj = []; data_accC_pz_nontarget = zeros(300,length(sessionC_epoch_acc_nontargets));
        for ii = 1:numel(sessionC_epoch_acc_nontargets)
            kk = sessionC_epoch_acc_nontargets(ii)
            jj = session_num(kk,1)-1
            if jj <= size(data_accC_pz,2)
                data_accC_pz_nontarget(:,ii) = data_accC_pz(:,jj);
            else
                sub
                nn
                sprintf('Warning: session C contains an error in number of nontargetssss')
                pause
            end
        end
        %% next steps:
        % does average of data_accA_pz_target match ERP for sessionA?
        data_accA_pz_target_mean = mean(data_accA_pz_target,2);
        data_accB_pz_target_mean = mean(data_accB_pz_target,2);
        data_accC_pz_target_mean = mean(data_accC_pz_target,2);
                
        data_accA_pz_nontarget_mean = mean(data_accA_pz_nontarget,2);
        data_accB_pz_nontarget_mean = mean(data_accB_pz_nontarget,2);
        data_accC_pz_nontarget_mean = mean(data_accC_pz_nontarget,2);
        
        data_accA_pz_target_mean_alt = mean(data_accA_pz_target_alt,2);
        data_accB_pz_target_mean_alt = mean(data_accB_pz_target_alt,2);
        data_accC_pz_target_mean_alt = mean(data_accC_pz_target_alt,2);
        
        %%
%         figure
%         plot(data_accA_pz_target_mean)
%         hold on
%         plot(data_accB_pz_target_mean)
%         plot(data_accC_pz_target_mean)
        %
        %%
        data_accABC_pz_target_mean(:,nn,mm) = mean([data_accA_pz_target ...
            data_accB_pz_target data_accC_pz_target],2);
                
        data_accABC_pz_nontarget_mean(:,nn,mm) = mean([data_accA_pz_nontarget ...
            data_accB_pz_nontarget data_accC_pz_nontarget],2);
        
        data_accABC_pz_target_mean_alt(:,nn,mm) = mean([data_accA_pz_target_alt ...
            data_accB_pz_target_alt data_accC_pz_target_alt],2);
        %         figure
        %         plot(data_accABC_pz_target_mean(:,nn,mm))
        
        if nn == 1 %sit
            p3_rms(1,mm).erp_pz = data_accA_pz;
            p3_rms(2,mm).erp_pz = data_accB_pz;
            p3_rms(3,mm).erp_pz = data_accC_pz;
            p3_rms(1,mm).erp_pz_target = data_accA_pz_target;
            p3_rms(2,mm).erp_pz_target = data_accB_pz_target;
            p3_rms(3,mm).erp_pz_target = data_accC_pz_target;            
            p3_rms(1,mm).erp_pz_nontarget = data_accA_pz_nontarget;
            p3_rms(2,mm).erp_pz_nontarget = data_accB_pz_nontarget;
            p3_rms(3,mm).erp_pz_nontarget = data_accC_pz_nontarget;
            p3_rms(1,mm).type = typeA;
            p3_rms(2,mm).type = typeB;
            p3_rms(3,mm).type = typeC;
        elseif nn == 2 %stand
            p3_rms(4,mm).erp_pz = data_accA_pz;
            p3_rms(5,mm).erp_pz = data_accB_pz;
            p3_rms(6,mm).erp_pz = data_accC_pz;
            p3_rms(4,mm).erp_pz_target = data_accA_pz_target;
            p3_rms(5,mm).erp_pz_target = data_accB_pz_target;
            p3_rms(6,mm).erp_pz_target = data_accC_pz_target;
            p3_rms(4,mm).erp_pz_nontarget = data_accA_pz_nontarget;
            p3_rms(5,mm).erp_pz_nontarget = data_accB_pz_nontarget;
            p3_rms(6,mm).erp_pz_nontarget = data_accC_pz_nontarget;
            p3_rms(4,mm).type = typeA;
            p3_rms(5,mm).type = typeB;
            p3_rms(6,mm).type = typeC;
        elseif nn == 3 %walk
            p3_rms(7,mm).erp_pz = data_accA_pz;
            p3_rms(8,mm).erp_pz = data_accB_pz;
            p3_rms(9,mm).erp_pz = data_accC_pz;
            p3_rms(7,mm).erp_pz_target = data_accA_pz_target;
            p3_rms(8,mm).erp_pz_target = data_accB_pz_target;
            p3_rms(9,mm).erp_pz_target = data_accC_pz_target;
            p3_rms(7,mm).erp_pz_nontarget = data_accA_pz_nontarget;
            p3_rms(8,mm).erp_pz_nontarget = data_accB_pz_nontarget;
            p3_rms(9,mm).erp_pz_nontarget = data_accC_pz_nontarget;
            p3_rms(7,mm).type = typeA;
            p3_rms(8,mm).type = typeB;
            p3_rms(9,mm).type = typeC;
        end
        
        if savefiles == 1
            fnm = sprintf('p3_rms.mat');
            cd(loc_save)
            save(fnm,'p3_rms')
        end
    end
    
            figure
            plot(data_accABC_pz_target_mean(:,1,mm))
            hold on
            plot(data_accABC_pz_target_mean(:,2,mm))
            plot(data_accABC_pz_target_mean(:,3,mm))
            plot(data_accABC_pz_nontarget_mean(:,1,mm))
            plot(data_accABC_pz_nontarget_mean(:,2,mm))
            plot(data_accABC_pz_nontarget_mean(:,3,mm))
            legend('sit','stand','walk')
    
    
end

for nn = 1:numel(cond)
    data_accABC_pz_target_mean_allsubs(:,nn) = mean(data_accABC_pz_target_mean(:,nn,:),3);
end

for nn = 1:numel(cond)
    data_accABC_pz_nontarget_mean_allsubs(:,nn) = mean(data_accABC_pz_nontarget_mean(:,nn,:),3);
end

for nn = 1:numel(cond)
    data_accABC_pz_target_mean_allsubs_alt(:,nn) = mean(data_accABC_pz_target_mean_alt(:,nn,:),3);
end

% %
% % figure
% % plot(ALLERP(10).bindata(1,:,1))
% % hold on
% % plot(ALLERP(20).bindata(1,:,1))
% % plot(ALLERP(32).bindata(1,:,1))
% % % legend('sit','stand','walk')
% % legend('sit','stand','walk')
% %
% % figure
% % plot(ALLERP(32).bindata(1,:,1)-ALLERP(31).bindata(1,:,1))
% %
% % figure
% % plot(ALLERP(8).bindata(1,:,1))
% % hold on
% % plot(ALLERP(9).bindata(1,:,1))
% % plot(ALLERP(11).bindata(1,:,1))
% % legend('sit','stand','walk_29')
%
figure
hold on
plot(data_accABC_pz_target_mean_allsubs(:,1))
plot(data_accABC_pz_target_mean_allsubs(:,2))
plot(data_accABC_pz_target_mean_allsubs(:,3))
legend('sit','stand','walk')

figure
hold on
plot(data_accABC_pz_target_mean_allsubs_alt(:,1))
plot(data_accABC_pz_target_mean_allsubs_alt(:,2))
plot(data_accABC_pz_target_mean_allsubs_alt(:,3))
legend('sit','stand','walk')

times = -200:3.33:796;
%%
figure
hold on
plot(times,data_accABC_pz_target_mean_allsubs(:,1),'k-','LineWidth',2)
plot(times,data_accABC_pz_nontarget_mean_allsubs(:,1),'k:','LineWidth',2)
set(gca,'FontSize',12)
ylim([-5.5 10.5])
xlim([-200 800]);
% grid minor
xline(0)
yline(0)
xlabel('Time (ms)')
ylabel('Pz (μV)','rotation',90,'HorizontalAlignment','right')
set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin')

figure
hold on
plot(times,data_accABC_pz_target_mean_allsubs(:,2),'k-','LineWidth',2)
plot(times,data_accABC_pz_nontarget_mean_allsubs(:,2),'k:','LineWidth',2)
set(gca,'FontSize',12)
ylim([-5.5 10.5])
xlim([-200 800]);
% grid minor
xline(0)
yline(0)
% xlabel('Time (ms)')
% ylabel('Pz (μV)')
set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin')

figure
hold on
plot(times,data_accABC_pz_target_mean_allsubs(:,3),'k-','LineWidth',2)
plot(times,data_accABC_pz_nontarget_mean_allsubs(:,3),'k:','LineWidth',2)
legend('Target','Non-Target')
set(gca,'FontSize',12)
ylim([-5.5 10.5])
xlim([-200 800]);
% grid minor
xline(0)
yline(0)
% xlabel('Time (ms)')
% ylabel('Pz (μV)')
set(gca, 'XAxisLocation', 'origin', 'YAxisLocation', 'origin')
% hYLabel = get(gca,'YLabel');
% set(hYLabel,'rotation',0,'VerticalAlignment','middle')
% set(get(gca,'ylabel'),'Rotation',90)
% ylabel('Pz (μV)','rotation',90,'HorizontalAlignment','right')
%%

% figure
% plot(ALLERP(1).bindata(1,:,1)-data_accABC_pz_target_mean_allsubs(:,1)')
% hold on
% plot(ALLERP(2).bindata(1,:,1)-data_accABC_pz_target_mean_allsubs(:,2)')
% plot(ALLERP(3).bindata(1,:,1)-data_accABC_pz_target_mean_allsubs(:,3)')
% legend('sit','stand','walk')
%
% figure
% plot(ALLERP(1).bindata(1,:,1)-data_accABC_pz_target_mean_allsubs_alt(:,1)')
% hold on
% plot(ALLERP(2).bindata(1,:,1)-data_accABC_pz_target_mean_allsubs_alt(:,2)')
% plot(ALLERP(3).bindata(1,:,1)-data_accABC_pz_target_mean_allsubs_alt(:,3)')
% legend('sit','stand','walk')
%% now do i make ERP using the accel? i think i started doing that...
% and should i actually verify ERP? might as well since i'll need to plot
% everything anyway.

%%fails
%%  for each session A, B, and C, count up the number of targets (1) and nontargets (2) that were included (and excluded targets (4))
%         session_rej = sessionA_rej;
%         session_type = codes_all(1:301,1);
%         session_acc = zeros(length(session_rej),1);
%         for ii = 1:length(session_rej)
%             if session_type(ii) == 1 && session_rej(ii,3) == 0
%                 session_acc(ii) = 1; % these are the accepted targets that were included
%             elseif session_type(ii) == 1 && session_rej(ii,3) == 4
%                 session_acc(ii) = 4; % these are the accepted targets that were extra and thus excluded
%             elseif session_type(ii) == 2 && session_rej(ii,3) == 0
%                 session_acc(ii) = 2; % these are the accepted nontargets
%             end
%         end
%         sessionA_acc = session_acc;
%         [numel(find(session_acc == 1)) numel(find(session_acc == 4)) numel(find(session_acc == 2))]
%
%         session_rej = sessionB_rej;
%         session_type = codes_all(302:602,1);
%         session_acc = zeros(length(session_rej),1);
%         for ii = 1:length(session_rej)
%             if session_type(ii) == 1 && session_rej(ii,3) == 0
%                 session_acc(ii) = 1; % these are the accepted targets that were included
%             elseif session_type(ii) == 1 && session_rej(ii,3) == 4
%                 session_acc(ii) = 4; % these are the accepted targets that were extra and thus excluded
%             elseif session_type(ii) == 2 && session_rej(ii,3) == 0
%                 session_acc(ii) = 2; % these are the accepted nontargets
%             end
%         end
%         sessionB_acc = session_acc;
%         [numel(find(session_acc == 1)) numel(find(session_acc == 4)) numel(find(session_acc == 2))]
%
%         session_rej = sessionC_rej;
%         session_type = codes_all(603:903,1);
%         session_acc = zeros(length(session_rej),1);
%         for ii = 1:length(session_rej)
%             if session_type(ii) == 1 && session_rej(ii,3) == 0
%                 session_acc(ii) = 1; % these are the accepted targets that were included
%             elseif session_type(ii) == 1 && session_rej(ii,3) == 4
%                 session_acc(ii) = 4; % these are the accepted targets that were extra and thus excluded
%             elseif session_type(ii) == 2 && session_rej(ii,3) == 0
%                 session_acc(ii) = 2; % these are the accepted nontargets
%             end
%         end
%         sessionC_acc = session_acc;
%         [numel(find(session_acc == 1)) numel(find(session_acc == 4)) numel(find(session_acc == 2))]
%
%         % pause if there aren't the right number of accepter targets included
%         num_acc_targets = numel(find(sessionA_acc==1))+numel(find(sessionB_acc==1))+numel(find(sessionC_acc==1));
%         if num_acc_targets ~= 37
%             pause
%         end