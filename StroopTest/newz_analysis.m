% newz analysis
clearvars
load('wkspace_newz.mat')

numEasy=7;
% load dsi csv file
% cd('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\DSI_data\StroopAudio')
folder = 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\DSI_data\StroopAudio\';
filename_alone = 'newz_duration_raw.csv'; %'MaggieStroopAudio1_0001_duration_raw.csv';
filename_duration = strcat(folder,filename_alone);
folder = 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\Pilot';
folder_save = 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\Pilot\troubleshooting_mean20';

% specify times and channels
startRow = 17; % time = 0
endRow = inf; % time = end of trial
[Time_duration,LE,F4,C4,P4,P3,C3,F3,Trigger_duration,Time_Offset,ADC_Status,ADC_Sequence,Event,Comments] = importRaw(filename_duration, startRow, endRow); % import

% load stroop test results
% stroop_data = 'AB00_Test3unRand_adj_Easy_v4.mat'; %'AB00_Test1 - MMS data.mat';
% data_loc = strcat('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\StroopTestResults\Troubleshooting\',stroop_data);
% data = load('-mat', data_loc);

folder = folder_save;

% % plot stimuli
% 
% figure()
% plot(Trigger_duration)

%% label stimuli: 
% Trigger_duration(1) = 0;

for ii = 1:length(Trigger_duration);
    if Trigger_duration(ii) == 1 % no word, no sound
        word(ii,1) = 0;
        tone(ii,1) = 0;
    elseif Trigger_duration(ii) == 8 % sound and word
        word(ii,1) = 1;
        tone(ii,1) = 1;
    elseif Trigger_duration(ii) == 9 % sound only
        word(ii,1) = 0;
        tone(ii,1) = 1;
    elseif Trigger_duration(ii) == 0 % word only
        word(ii,1) = 1;
        tone(ii,1) = 0;
    else
        disp(ii)
        sprintf('what is happening here?')
    end
end

%%
figure
subplot(211)
plot(word)
ylabel('word')
subplot(212)
plot(tone)
ylabel('tone')

%%
for ii = 1:length(tone)-1
    if tone(ii) == 0 && tone(ii+1) == 1
        toneOn(ii) = ii;
    end
end
idxTonesOn = find(toneOn);

for ii = 1:length(tone)-1
    if tone(ii) == 1 && tone(ii+1) == 0
        toneOff(ii+1) = ii+1;
    end
end
idxTonesOff = find(toneOff);
% %%
% a5 = etime(t5_a_separate,startT); % time it took for separate tones
% b5 = etime(t5_b_combined,t5_a_separate); % time it took for combined tones
% ML5_diff = a5-b5; % positive means separated took longer
% % does a = b? what's the difference? does the DSI agree?

% dsi data should show that this difference is equal to :
a5_dsi =  (idxTonesOff(7)-idxTonesOn(1))/300; % the end of the 7th tone minus the beginning of the 1st tone
b5_dsi =  (idxTonesOff(14)-idxTonesOff(7))/300; % the end of the 17th tone minus the end of the 7th tone
dsi5_diff = a5_dsi - b5_dsi; % negative means combined took longer

% %%
% a6 = etime(t6_a_separate,t5_b_combined); % time it took for separate tones
% b6 = etime(t6_b_combined,t6_a_separate); % time it took for combined tones
% ML6_diff = a6-b6; % positive means separated took longer

a6_dsi =  (idxTonesOff(15+7)-idxTonesOn(15))/300;% the end of the 7th tone minus the beginning of the 1st tone
b6_dsi =  (idxTonesOff(15+21)-idxTonesOff(15+14))/300;%the end of the 14th tone minus the end of the 7th tone
dsi6_diff = a6_dsi - b6_dsi;

% %% now compare length it took to run 14 tones combined
% c56 = etime(endT,t6_b_combined); % time it took for combined tones (alternating)
% MLc_sep_diff = c56-(a5+a6); % positive means combined alternating tones took longer than separated tones
% MLc_comb_diff = c56-(b5+b6); % positive means combined alternating tones took longer than adding both rounds of combined tones together

c56_dsi =  (idxTonesOff(42)-idxTonesOn(29))/300;%the end of the 17th tone minus the end of the 7th tone
c56_diff = c56_dsi - c56;

