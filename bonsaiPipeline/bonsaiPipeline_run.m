clearvars
close all
%% Global variables
% all_possible_subs = {'S020_SA','S021_SA_0001','S023_SA','S024_SA',...
%     'S025_SA_0001','S026_SA_0002','S027_SA','S028_SA_0004','S029_SA_0002',...
%     'S030_SA','S031_SA_0002','S032_SA','S033_SA','S034_SA','S034_SA',...
%     'S035_SA','S036_SA','S037_SA','S038_SA','S039_SA','S040_SA'};
all_possible_subs = {'S003','S006','S007','S008','S009','S010','S012','S013','S014'};
% subs =  {'S003','S007','S010','S012','S013','S014'};
% subs =  {'S006'};

subs = all_possible_subs; % run all subs
% subs = {'S008'}; % stim conversion
% subs = {'S026_SA_0002'}; % pt 1
loc_user = 'C:\Users\mswerdloff\';
loc_main = [loc_user 'Documents\GitHub\matlab_scripts\'];
loc_scripts = [loc_main 'StroopTest'];
loc_bonsaiPipeline = [loc_main 'bonsaiPipeline\'];
loc_data = 'Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\';
loc_dsi = [loc_data 'EEG\DSI_data\StroopAudio\study1\'];
loc_save = [loc_data 'EEG\Matlab_data\Pilot2_Accel\12_21_21\'];
loc_stroopData = [loc_data 'StroopTestResults\study1\renamed\'];
loc_eeglab = [loc_user 'eeglab\eeglab2021_0'];
% loc_binlist = [loc_save 'binlist11.txt'];
loc_ced = [loc_user 'eeglab\chanlocsDSI7.ced'];
loc_erp = [loc_save 'AR\'];
loc_sswAccel = [loc_main 'sswAccel\'];
loc_dsi_all = [loc_data 'EEG\DSI_data\All\'];

%%
expt = 5;
%expt 1 = sit stand walk pilot
%expt 2 = sit stand walk full
%expt 3 = strooptest pilot
%expt 4 = strooptest full
%expt 5 = sit stand walk full with accel

%% Save results?
savefiles = 2; % 0 is off; 1 is on; 2 is troubleshooting on
figs = 0;
    %%
if expt == 7
    bonsaiPipeline_6_13_2stim_part3_new_redo10eq
elseif expt == 6
    loc_binlist = [loc_save 'binlist12_accel.txt'];
    addpath(loc_sswAccel)
    sswAccel
    selfP3
    p3_rms
elseif expt == 5 % sit stand walk full with accel
    loc_binlist = [loc_save 'binlist12_accel.txt'];
    addpath(loc_sswAccel)
    sswAccel
%     cd(loc_bonsaiPipeline)
%     bonsaiPipeline_6_13_2stim_new
%     bonsaiPipeline_6_13_2stim_part2_new
%     bonsaiPipeline_6_13_2stim_part3_new
elseif expt == 4
    %% which parts to run
    needStimConvert = 1; % change to 1 to make stim
    part1 = 0;
    part2 = 0;
    part3 = 0;

    %% Do you want to check tones and words?
    checktones = 0;
    checkwords = 1;
    
    %% Are you troubleshooting?
    troubleshooting = 1; % 1 if troubleshooting
    
    % if contains(subs,'S025') == 1
    %     troubleshooting = 1; % 1 if troubleshooting
    % else
    %     troubleshooting = 0; % 0 if not troubleshooting
    % end
    
    %% Voice to stim
    % gotta make this one!
    
    %% Stim converstion
    if needStimConvert == 1
        cd(loc_scripts)
        addpath(loc_main)
        if troubleshooting == 0
            StroopDSItoMAT_v10_mix_allSubs % regular file
        elseif troubleshooting == 1
            StroopDSItoMAT_v10_mix_allSubs_trblsht % troubleshooting file
        end
    end
    %% Part 1
    if part1 == 1
        cd(loc_bonsaiPipeline)
        bonsaiPipeline_5_5_21_stroop
    end
    %% Part 2
    if part2 == 1
        cd(loc_bonsaiPipeline)
        bonsaiPipeline_5_12_21_stroop_part2
    end
    %% Part 3
    if part3 == 1
        cd(loc_bonsaiPipeline)
        bonsaiPipeline_5_12_21_stroop_part3
    end
end