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
loc_user = 'C:\Users\mswerdloff\';
loc_data = 'Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\';
loc_eeglab = [loc_user 'eeglab\eeglab2021_0'];
loc_source = [loc_data 'EEG\Matlab_data\Pilot2\'];
loc_save = [loc_data 'EEG\Matlab_data\Pilot2_Accel\'];

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
      
%     check37 = [numel(find(targets_accepted(:,1)==1)) numel(find(targets_accepted(:,2)==1)) numel(find(targets_accepted(:,3)==1))];
    check37 = zeros(1,3);
    check37 = [numel(find(codes_accepted(:,1)==1)) numel(find(codes_accepted(:,2)==2)) numel(find(codes_accepted(:,3)==1))];
    if check37(1) == 37 && check37(2) == 37 && check37(3) == 37
        sprintf('we good!')
    else
        pause
    end
    
    % for accepted trials: combine acc for all conditions into one table in old format
    codesAccepted = [];
    codesAccepted = array2table(codes_accepted);
    codesAccepted.Properties.VariableNames{1} = 'sit';
    codesAccepted.Properties.VariableNames{2} = 'stand';
    codesAccepted.Properties.VariableNames{3} = 'walk';
    
    % save acc tables
    fnm = sprintf('%s_codesAccepted.mat',sub);
    cd(loc_save)
    save(fnm,'codesAccepted','-mat');

end