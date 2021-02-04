clear

%% import file
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\DSI_data\All'
% filename = 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\DSI_data\All\Maggie2TonesSeatedTTHigh_noButton_filtered.csv';
filename = 'Maggie_Walk_TTHigh_ArduinoRecording_raw.csv';

%%%% assign filenames
str_mat = strrep(filename,'.csv','.mat'); % table of EEG data (.mat)
% str_ascii = strrep(filename,'.csv','.txt'); % table of EEG data (.txt)
str_events = strrep(filename,'.csv',''); % table of events
str_events_csv = strrep(filename,'.csv','_eventsMatlab.csv'); % table of events (.csv)

%%%% specify times and channels
startRow = 17; % time = 0
endRow = inf; % time = end of trial
[Time,LE,F4,C4,P4,P3,C3,F3,Trigger,Time_Offset,ADC_Status,ADC_Sequence,Event,Comments] = importRaw(filename, startRow, endRow); % import

%% Re-reference channels
Pz_LE = -1*LE; % reference Pz to LE
F4_LE = F4-LE; C4_LE = C4-LE; P4_LE = P4-LE; P3_LE = P3-LE; C3_LE = C3-LE; F3_LE = F3-LE; % reference all other channels to LE

%% save raw EEG data
tbl_raw = [Pz_LE,F4_LE,C4_LE,P4_LE,P3_LE,C3_LE,F3_LE,Trigger]'; % create tbl
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\EEG_data_withTriggers'
save(str_mat,'tbl_raw'); % save tbl of EEG data

%% save arduino tones
% tones=randi([1 2],66,1); % tone types
% tones_ascii = strrep(filename,'.csv','_tones.txt'); % name for tone table
% save(tones_ascii,'tones','-ascii','-tabs'); % save the tone table (.txt)

%% save events manually
% events = eeg_eventtable(EEG, 'exportFile', 'test.csv');
% str_events = eeg_eventtable(EEG, 'exportFile', str_events_csv);