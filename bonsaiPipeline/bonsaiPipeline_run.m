% This is my run file!

% These are my global variables
all_possible_subs = {'S020_SA','S021_SA_0001','S023_SA','S024_SA',...
    'S025_SA_0001','S026_SA_0002','S027_SA','S028_SA_0004','S029_SA_0002',...
    'S030_SA','S031_SA_0002','S032_SA','S033_SA','S034_SA','S034_SA',...
    'S035_SA','S036_SA','S037_SA','S038_SA','S039_SA','S040_SA'};

% subs = all_possible_subs;
subs = {'S026_SA_0002'}; % just the sub(s) that you want to run


% Run Part 1
run(bonsaiPipeline_5_5_21_stroop)