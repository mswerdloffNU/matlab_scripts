%% prob_check

%% read necessary files
clear
close all
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\DSI_data\All'
%cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting3_05Hz_30Hz'
% _manualFix

% import duration file
filename_duration = 'Maggie_Sit_TTHigh_ArduinoRecording_10min_1sISI_v4_duration_raw.csv';
startRow = 17; % time = 0
endRow = inf; % time = end of trial
[Time_duration,LE,F4,C4,P4,P3,C3,F3,Trigger_duration,Time_Offset,ADC_Status,ADC_Sequence,Event,Comments] = importRaw(filename_duration, startRow, endRow); % import
vars = {'LE','F4','C4','P4','P3','C3','F3','Time_Offset','ADC_Status','ADC_Sequence','Event','Comments'};
clear(vars{:})

% import non-duration file
Fsp = 300; % sampling rate in Hz
Fn = Fsp/2; % Nyquist frequency
%cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting3_05Hz_30Hz'
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\DSI_data\All'

filename = 'Maggie_Sit_TTHigh_ArduinoRecording_10min_1sISI_v4_raw.csv';
startRow = 17; % time = 0
endRow = inf; % time = end of trial
[Time,LE,F4,C4,P4,P3,C3,F3,Trigger,Time_Offset,ADC_Status,ADC_Sequence,Event,Comments] = importRaw(filename, startRow, endRow); % import

tone_data = [Time_duration Trigger_duration];
start_times = [Time Trigger];
%% set the first values to 240
tone_data(1,2) = 240;
start_times(1,2) = 240;

%% set start values to 0
start_times(47329,2) = 0;
start_times(47347,2) = 0;

%% make line plot
plot(tone_data(:,1), tone_data(:,2), '-')

%% 
for i = 1:length(tone_data(:,2))
    if start_times(i,2) == 8
        if tone_data(i+1,2) == 0
            prob_check(i) == 'problem'
        else prob_check(i) == 'no problem'
end
