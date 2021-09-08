clear
%% this loads all subs
load('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\Pilot2_rejectedAcceptedTrials_allSubs_eq.mat')
load('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\codes_allSubs.mat') %codes

%%
all_possible_subs = {'S003','S006','S007','S008','S009','S010','S012','S013','S014'};

subs =  {'S003','S007','S010','S012','S013','S014'}; %these have the right amounts (37 targets)
 % run all subs
% subs = {'S014','S003'}; % stim conversion
% subs = {'S026_SA_0002'}; % pt 1
loc_user = 'C:\Users\mswerdloff\';
loc_data = 'Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\';
loc_eeglab = [loc_user 'eeglab\eeglab2021_0'];
loc_source = [loc_data 'EEG\Matlab_data\Pilot2\'];
loc_save = [loc_data 'EEG\Matlab_data\Pilot2_Accel\'];
RejectedTrials_sub_eq = [];
savefiles = 1;

for mm = 1:length(subs)
    sub = subs{mm};

    if strcmp(sub,'S003')==1
        RejectedTrials_sub_eq = RejectedTrials_S003_eq;
    elseif strcmp(sub,'S006')==1
        RejectedTrials_sub_eq = RejectedTrials_S006_eq;
    elseif strcmp(sub,'S007')==1
        RejectedTrials_sub_eq = RejectedTrials_S007_eq;
    elseif strcmp(sub,'S008')==1
        RejectedTrials_sub_eq = RejectedTrials_S008_eq;
    elseif strcmp(sub,'S009')==1
        RejectedTrials_sub_eq = RejectedTrials_S009_eq;
    elseif strcmp(sub,'S010')==1
        RejectedTrials_sub_eq = RejectedTrials_S010_eq;
    elseif strcmp(sub,'S012')==1
        RejectedTrials_sub_eq = RejectedTrials_S012_eq;
    elseif strcmp(sub,'S013')==1
        RejectedTrials_sub_eq = RejectedTrials_S013_eq;
    elseif strcmp(sub,'S014')==1
        RejectedTrials_sub_eq = RejectedTrials_S014_eq;
    else
        pause
    end
    
       
    cond = {'sit' 'stand' 'walk'};
    filepaths = {};
    for ii = 1:numel(cond)
        filepaths{ii} =  [loc_source sub '\' cond{ii}];
    end

    sitABC_acc = []; standABC_acc = []; walkABC_acc = [];
    
    for nn = 1:numel(filepaths)
        
        % find filename for each session A, B, and C
        cd(filepaths{nn})
        file_A = strcat(sub,'*_A','*_filt_a_b_2_allTrials_eq9_ICA_elist_bins_be.set');
        file_B = strcat(sub,'*_B','*_filt_a_b_2_allTrials_eq9_ICA_elist_bins_be.set');
        file_C = strcat(sub,'*_C','*_filt_a_b_2_allTrials_eq9_ICA_elist_bins_be.set');
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
        
        %% create new variables for rejected trials:
        
        typeA = [ALLEEG(1).urevent.type].';
        latencyA = [ALLEEG(1).urevent.latency].';
        sessionA_rej = [latencyA, typeA, table2array(RejectedTrials_sub_eq(1:301,nn))];
        
        typeB = [ALLEEG(2).urevent.type].';
        latencyB = [ALLEEG(2).urevent.latency].';
        sessionB_rej = [latencyB, typeB, table2array(RejectedTrials_sub_eq(302:602,nn))];
        
        typeC = [ALLEEG(3).urevent.type].';
        latencyC = [ALLEEG(3).urevent.latency].';
        sessionC_rej = [latencyC, typeC, table2array(RejectedTrials_sub_eq(603:903,nn))];
        
        %%  for each session A, B, and C, count up the number of targets (1) and nontargets (2) that were included (and excluded targets (4))
        session_rej = sessionA_rej;
        session_acc = zeros(length(session_rej),1);
        for ii = 1:length(session_rej)
            if session_rej(ii,2) == 1 && session_rej(ii,3) == 0
                session_acc(ii) = 1; % these are the accepted targets that were included
            elseif session_rej(ii,2) == 1 && session_rej(ii,3) == 4
                session_acc(ii) = 4; % these are the accepted targets that were extra and thus excluded
            elseif session_rej(ii,2) == 2 && session_rej(ii,3) == 0
                session_acc(ii) = 2; % these are the accepted nontargets
            end
        end
        sessionA_acc = session_acc;
        [numel(find(session_acc == 1)) numel(find(session_acc == 4)) numel(find(session_acc == 2))]
        
        session_rej = sessionB_rej;
        session_acc = zeros(length(session_rej),1);
        for ii = 1:length(session_rej)
            if session_rej(ii,2) == 1 && session_rej(ii,3) == 0
                session_acc(ii) = 1; % these are the accepted targets that were included
            elseif session_rej(ii,2) == 1 && session_rej(ii,3) == 4
                session_acc(ii) = 4; % these are the accepted targets that were extra and thus excluded
            elseif session_rej(ii,2) == 2 && session_rej(ii,3) == 0
                session_acc(ii) = 2; % these are the accepted nontargets
            end
        end
        sessionB_acc = session_acc;
        [numel(find(session_acc == 1)) numel(find(session_acc == 4)) numel(find(session_acc == 2))]
        
        session_rej = sessionC_rej;
        session_acc = zeros(length(session_rej),1);
        for ii = 1:length(session_rej)
            if session_rej(ii,2) == 1 && session_rej(ii,3) == 0
                session_acc(ii) = 1; % these are the accepted targets that were included
            elseif session_rej(ii,2) == 1 && session_rej(ii,3) == 4
                session_acc(ii) = 4; % these are the accepted targets that were extra and thus excluded
            elseif session_rej(ii,2) == 2 && session_rej(ii,3) == 0
                session_acc(ii) = 2; % these are the accepted nontargets
            end
        end
        sessionC_acc = session_acc;
        [numel(find(session_acc == 1)) numel(find(session_acc == 4)) numel(find(session_acc == 2))]
        
        % pause if there aren't the right number of accepter targets included
        num_acc_targets = numel(find(sessionA_acc==1))+numel(find(sessionB_acc==1))+numel(find(sessionC_acc==1))
        if num_acc_targets ~= 37
            pause
        end
              
        
        %save sessionA_acc etc. and rename as necessary
        sessionsABC_acc = array2table([sessionA_acc;sessionB_acc;sessionC_acc]);
        sessionsABC_latency = array2table([latencyA;latencyB;latencyC]);
        if nn == 1 && strcmp('sit',cond{nn})==1
            sitABC_acc = sessionsABC_acc;
            sitABC_latency = sessionsABC_latency;
        elseif nn == 2 && strcmp('stand',cond{nn})==1
            standABC_acc = sessionsABC_acc;
            standABC_latency = sessionsABC_latency;
        elseif nn == 3 && strcmp('walk',cond{nn})==1
            walkABC_acc = sessionsABC_acc;
            walkABC_latency = sessionsABC_latency;
        else
            pause
        end
       
        
%         % save each session in a new format
%         SessionsABC_acc{nn,1} = sessionA_acc;
%         SessionsABC_acc{nn,2} = cond{nn};
%         SessionsABC_acc{nn,3} = 'A';
%         SessionsABC_acc{nn+1,1} = sessionB_acc;
%         SessionsABC_acc{nn+1,2} = cond{nn};
%         SessionsABC_acc{nn+1,3} = 'B';
%         SessionsABC_acc{nn+2,1} = sessionC_acc;
%         SessionsABC_acc{nn+2,2} = cond{nn};
%         SessionsABC_acc{nn+2,3} = 'C';
        
    end
    
    % for accepted trials: combine acc for all conditions into one table in old format
    condsABC_acc = [];
    condsABC_acc = [table2array(sitABC_acc),table2array(standABC_acc),table2array(walkABC_acc)];
    allcondsABC_acc = [];
    allcondsABC_acc = array2table(condsABC_acc);
    allcondsABC_acc.Properties.VariableNames{1} = 'sit';
    allcondsABC_acc.Properties.VariableNames{2} = 'stand';
    allcondsABC_acc.Properties.VariableNames{3} = 'walk';
    
    % for latency: combine latency for all conditions into one table in old format
    condsABC_latency = [];
    condsABC_latency = [table2array(sitABC_latency),table2array(standABC_latency),table2array(walkABC_latency)];
    allcondsABC_latency = [];
    allcondsABC_latency = array2table(condsABC_latency);
    allcondsABC_latency.Properties.VariableNames{1} = 'sit';
    allcondsABC_latency.Properties.VariableNames{2} = 'stand';
    allcondsABC_acc.Properties.VariableNames{3} = 'walk';
    
    % save acc tables
    fnm = sprintf('%s_acceptedTrials_allconds.mat',sub);
    cd(loc_save)
    if savefiles == 1
        save(fnm,'allcondsABC_acc','-mat');
    end    

    % save latency tables
    fnm = sprintf('%s_latency_allconds.mat',sub);
    cd(loc_save)
    if savefiles == 1
        save(fnm,'allcondsABC_latency','-mat');
    end
end
%% failed attempts:
% load('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S014\redoEq9_avg\eq_info_part2_S014_stand_sit_walk_A_0001_filt_a_b_2_allTrials_eq9.mat')
% load('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S014\redoEq9_avg\eq_info_part2_S014_sit_walk_stand_B_filt_a_b_2_allTrials_eq9.mat')
% load('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S014\redoEq9_avg\eq_info_part2_S014_walk_stand_sit_C_0002_filt_a_b_2_allTrials_eq9.mat')

%%
% [301-numel(find(table2array(RejectedTrials_S014_eq(1:301,1)))) 301-numel(find(table2array(RejectedTrials_S014_eq(302:602,1)))) 301-numel(find(table2array(RejectedTrials_S014_eq(603:end,1))))]
% [length(ALLEEG(1).epoch) length(ALLEEG(2).epoch) length(ALLEEG(3).epoch)]

% % [# of targets (1's)        # of nontargets (2's)] ????????
% [numel(find(typeA == 1)) numel(find(typeA == 2))]
% [numel(find(sit_rej(:,3) == 1)) numel(find(sit_rej(:,3) == 2)) numel(find(sit_rej(:,3) == 4))]
%
% % for targets:  [# of rejected 1's    # of rejected 4's      # of rejected 2's]
% [numel(find(gotem == 1)) numel(find(gotem == 4)) numel(find(gotem == 2)) numel(find(gotem == 0))]
%
% numel(find(gotem_new))
% %% ^^these are all targets but not sure what's the difference between the 1's and 4's
% [13 13 0]
% [11 6 0]
% [13 16 0]
%
% [17 13 0 271]
% [24 6 0 271]
% [14 16 0 271]
%
% %these are all the 1's 2's and 4's from sitA_rej, sitB_rej, and sitC_rej
% [ 4    58    14]
% [13    94     7]
% [ 1    24    17]


% not sure what this is, or if it's used...
%         EEG = pop_rejepoch( EEG, [ 1 3 4 6 9 11 14 16 22 24 25 26 27 32 33 34 35 38 39 51 52 53 54 59 60 63 66 67 69 70 73 84 86 87 96 102 105 107 114 119 120 121 123 124 125 128 129 130 131 132 133 134 135 136 137 138 139 140 142 143 145 146 147 151 152 153 154 155 156 157 158 159 160 162 163 164 165 166 167 168 169 171 172 176 180 183 184 185 195 198 206 208 222 226 236 238 239 240 242 247 248 250 252 256 268 271 290] ,0);

% reject find(x_new) trials (903 by 3) which are RejectedTrials_S014_eq

% so i'm sure now that I know which ones are rejected. but i'm not entirely
% sure that I have the list of accepted trials. I think they could be in
% the accepted bin, but then from there are they all accepted or are some
% of them randomly chosen for the bins, and if so, which ones?
