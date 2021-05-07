clearvars

%% Global variables
all_possible_subs = {'S020_SA','S021_SA_0001','S023_SA','S024_SA',...
    'S025_SA_0001','S026_SA_0002','S027_SA','S028_SA_0004','S029_SA_0002',...
    'S030_SA','S031_SA_0002','S032_SA','S033_SA','S034_SA','S034_SA',...
    'S035_SA','S036_SA','S037_SA','S038_SA','S039_SA','S040_SA'};

% subs = all_possible_subs; % run all subs
subs = {'S027_SA'}; % stim conversion
% subs = {'S026_SA_0002'}; % pt 1  
loc_main = 'C:\Users\mswerdloff\Documents\GitHub\matlab_scripts\';
loc_scripts = [loc_main 'StroopTest'];
loc_bonsaiPipeline = [loc_main 'bonsaiPipeline'];

%% Are you troubleshooting?
if contains(subs,'S027') == 1
    troubleshooting = 1; % 1 if troubleshooting
else
    troubleshooting = 0; % 0 if not troubleshooting
end

%% Voice to stim
% gotta make this one!

%% Stim converstion
cd(loc_scripts)
if troubleshooting == 0
    StroopDSItoMAT_v10_mix_allSubs
elseif troubleshooting == 1
    StroopDSItoMAT_v10_mix_allSubs_trblsht
end

%% Part 1
cd(loc_bonsaiPipeline)
% bonsaiPipeline_5_5_21_stroop

%% Part 2
cd(loc_bonsaiPipeline)
% bonsaiPipeline_5_5_21_stroop_part2

%% Part 3
cd(loc_bonsaiPipeline)
% bonsaiPipeline_5_5_21_stroop_part3