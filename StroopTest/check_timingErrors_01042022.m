clearvars
cd('Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\matlab_scripts\StroopTest')

%subs = {'S027_SA'};

% subs = {'S020_SA','S021_SA_0001','S023_SA','S024_SA','S025_SA_0001','S026_SA_0002','S027_SA','S028_SA_0004','S029_SA_0002','S030_SA','S031_SA_0002',...
% 'S032_SA','S033_SA','S035_SA','S036_SA','S037_SA','S038_SA','S039_SA','S040_SA'};

%kt is the best
subs = {'AB040821_v1'};

tmEr_data = [];
tmEr_data_means = [];
tmEr_data_rmOut_means = [];

%Maggie_stroopStimuli_v2_unRand_adj_allEasy_v6_hard_S005
%Maggie_stroopStimuli_v2_unRand_adj_allEasy_v9_mix_S005_duration_raw
for mm = 1
    if mm == 1
        %         level = 'v9_mix_pt1'; %'v5_day5';
        stroop_data_sub = 'Sub_v10.mat'; %'Sub_v5_day5.mat'; %'S018_Test3unRand_adj_Easy_v6_hard.mat'; %'AB00_Test1 - MMS data.mat';
        stroop_data_sub_startStop = 'Sub_v10_startStop.mat';
        filename = 'Sub_duration_raw.csv'; %'Sub_stroopStimuli_v2_unRand_adj_allEasy_v5_S005_day5_duration_raw.csv'; %'Maggie_stroopStimuli_v2_unRand_adj_allEasy_v4_AB00_raw.csv' %'MaggieStroopAudio1_0001_duration_raw.csv';
        %     elseif mm==2
        %         level = 'v9_mix_pt2'; %'v6_hard_day5';
        %         stroop_data_sub = 'Sub_v9_mix_pt2.mat'; %'Sub_v6_hard_day5.mat'; %'S018_Test3unRand_adj_Easy_v6_hard.mat'; %'AB00_Test1 - MMS data.mat';
        %         filename = 'Sub_v9_mix_pt2_stroopStimuli_duration_raw.csv'; %'Sub_stroopStimuli_v2_unRand_adj_allEasy_v6_hard_S005_day5_duration_raw.csv'; %'Maggie_stroopStimuli_v2_unRand_adj_allEasy_v4_AB00_raw.csv' %'MaggieStroopAudio1_0001_duration_raw.csv';
    end
    for i = 1:numel(subs)
        %% load files
        clearvars -except subs i mm level stroop_data_sub stroop_data_sub_startStop filename toneCategory_all timingError_all tmEr_data tmEr_data_means tmEr_data_rmOut_means
        sub = subs{i};
        numEasy=5;
        % load dsi csv file
        folder = 'Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\EEG\DSI_data\StroopAudio\study1\';
        filename_alone = strrep(filename,'Sub',sub)
        filename_duration = strcat(folder,filename_alone);
        folder_save = 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\study1_trblsht';
        
        filename_tmEr = 'Sub.dsi';
        filename_only = strrep(filename_tmEr,'Sub',sub);
        str_tmEr = strrep(filename_only,'.dsi','_tmEr.mat');

        % specify times and channels
        addpath('Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\matlab_scripts\StroopTest')
        startRow = 17; % time = 0
        endRow = inf; % time = end of trial
        if exist(filename_duration, 'file')
            [Time_duration,LE,F4,C4,P4,P3,C3,F3,Trigger_duration,Time_Offset,ADC_Status,ADC_Sequence,Event,Comments] = importRaw(filename_duration, startRow, endRow); % import
            %             [Time_xx,LE_xx,F4_xx,C4_xx,P4_xx,P3_xx,C3_xx,F3_xx,Trigger_xx,Time_Offset_xx,ADC_Status_xx,ADC_Sequence_xx,Event_xx,Comments_xx] = importRaw('Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\EEG\DSI_data\StroopAudio\study1\S025_SA_0001_raw.csv', startRow, endRow); % import
            % load stroop test results
            stroop_data = strrep(stroop_data_sub,'Sub',sub)
            startStop_data = strrep(stroop_data_sub_startStop,'Sub',sub)
            %data_loc = strcat('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\StroopTestResults\Pilot2\',stroop_data);
            data_loc = strcat('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\StroopTestResults\study1\renamed\',stroop_data);
            data = load('-mat', data_loc);
        else
            % load stroop test results
            stroop_data = strrep(stroop_data_sub,'Sub',sub)
            startStop_data = strrep(stroop_data_sub_startStop,'Sub',sub)
            %data_loc = strcat('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\StroopTestResults\Pilot2\',stroop_data);
            data_loc = strcat('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\StroopTestResults\study1_trblsht\',stroop_data);
            data = load('-mat', data_loc);
        end
%         cd(loc_sub)
        cd('Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\study1\tmEr_trblsht')
        %%
        clear tmEr tmEr_unsrt tmEr_srt tmEr_means tmEr_rmOut_means
        tmEr_unsrt = data.timingError(:,2:3);
        tmEr_srt = sortrows([tmEr_unsrt(:,2) tmEr_unsrt(:,1)]);
        tmEr = table2array(tmEr_srt);
        
        tmEr1 = tmEr(1:30,1);
        tmEr2 = tmEr(31:60,1);
        tmEr3 = tmEr(61:90,1);
        tmEr4 = tmEr(91:120,1);

        tmEr_trim1 = rmoutliers(tmEr(1:30,1));
        tmEr_trim2 = tmEr2; %rmoutliers(tmEr(31:60,1));
        tmEr_trim3 = rmoutliers(tmEr(61:90,1));
        tmEr_trim4 = rmoutliers(tmEr(91:120,1));
        
        tmEr_means = [mean(tmEr1) mean(tmEr2) mean(tmEr3) mean(tmEr4)];
        tmEr_rmOut_means = [mean(tmEr_trim1) mean(tmEr_trim2) mean(tmEr_trim3) mean(tmEr_trim4)];

        tmEr_stat.tmEr = tmEr;
        tmEr_stat.means = tmEr_means;
        tmEr_stat.rmOut_means = tmEr_rmOut_means;
        
        tmEr_data = [tmEr_data; tmEr];
        tmEr_data_means = [tmEr_data_means; tmEr_means];
        tmEr_data_rmOut_means = [tmEr_data_rmOut_means; tmEr_rmOut_means];
      
        save(str_tmEr,'tmEr_stat'); % save struct of tmEr_stat data
    end
end

tmEr_ALL.tmEr_data = tmEr_data;
tmEr_ALL.tmEr_data_means = tmEr_data_means;
tmEr_ALL.tmEr_data_rmOut_means = tmEr_data_rmOut_means;

% save('tmEr_all','tmEr_ALL');

%         data(ii) = load('-mat', str_tmEr);
%         tmEr_data = [];
%         tmEr_data(ii) = load('-mat', 'S020_SA_tmEr.mat');

tmEr_data = tmEr_ALL.tmEr_data;
tmEr_data_srt = sortrows(tmEr_data);
timepoints = [-.0775 0 .0005 .0775];

xOnes = ones(length(tmEr_data)/length(timepoints),1);
xOnes_all = [xOnes; 2*xOnes; 3*xOnes; 4*xOnes];

[mean(tmEr_data_srt(1:length(xOnes),1))...
    mean(tmEr_data_srt(length(xOnes)+1:2*length(xOnes),1))...
    mean(tmEr_data_srt(2*length(xOnes)+1:3*length(xOnes),1))...
    mean(tmEr_data_srt(3*length(xOnes)+1:4*length(xOnes),1))]

tmEr_data_srt_rmOut1 = rmoutliers(tmEr_data_srt(1:length(xOnes),1));
tmEr_data_srt_rmOut2 = rmoutliers(tmEr_data_srt(length(xOnes)+1:2*length(xOnes),1));
tmEr_data_srt_rmOut3 = rmoutliers(tmEr_data_srt(2*length(xOnes)+1:3*length(xOnes),1));
tmEr_data_srt_rmOut4 = rmoutliers(tmEr_data_srt(3*length(xOnes)+1:4*length(xOnes),1));

[mean(tmEr_data_srt_rmOut1) mean(tmEr_data_srt_rmOut2)...
    mean(tmEr_data_srt_rmOut3) mean(tmEr_data_srt_rmOut4)]

figure
plot(xOnes_all,tmEr_data_srt(:,1),'*')

figure
boxplot([tmEr_data_srt(1:570,1) tmEr_data_srt(571:2*570,1)...
    tmEr_data_srt(2*570+1:3*570,1) tmEr_data_srt(3*570+1:4*570,1)],...
    [-.0775 0 .0005 .0775])

figure
boxplot(tmEr_data_srt(:,1),[1 2 3 4])
