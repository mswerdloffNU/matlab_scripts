%% arduino generator
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\DSI_data\All'
filename_duration = 'Maggie_Walk_TTHigh_ArduinoRecording_10min_1sISI_v2_duration_manualFix_raw.csv';

%% import file
% % specify times and channels
startRow = 17; % time = 0
endRow = inf; % time = end of trial
[Time_duration,LE,F4,C4,P4,P3,C3,F3,Trigger_duration,Time_Offset,ADC_Status,ADC_Sequence,Event,Comments] = importRaw(filename_duration, startRow, endRow); % import

vars = {'LE','F4','C4','P4','P3','C3','F3','Time_Offset','ADC_Status','ADC_Sequence','Event','Comments'};
clear(vars{:})

Fsp = 300; % sampling rate in Hz
Fn = Fsp/2; % Nyquist frequency
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\DSI_data\All'
filename = 'Maggie_Walk_TTHigh_ArduinoRecording_10min_1sISI_v2_duration_manualFix_raw.csv';

%% import file
% % specify filenames
str_mat = strrep(filename,'.csv','.mat'); % table of EEG data (.mat)
% str_ascii = strrep(filename,'.csv','.txt'); % table of EEG data (.txt)
str_events = strrep(filename,'.csv',''); % table of events
str_events_csv = strrep(filename,'.csv','_eventsMatlab.csv'); % table of events (.csv)

% % specify times and channels
startRow = 17; % time = 0
endRow = inf; % time = end of trial
[Time,LE,F4,C4,P4,P3,C3,F3,Trigger,Time_Offset,ADC_Status,ADC_Sequence,Event,Comments] = importRaw(filename, startRow, endRow); % import

%% Re-reference channels
Pz_LE = -1*LE; % reference Pz to LE
F4_LE = F4-LE; C4_LE = C4-LE; P4_LE = P4-LE; P3_LE = P3-LE; C3_LE = C3-LE; F3_LE = F3-LE; % reference all other channels to LE

%% save raw EEG data
tbl_raw = [Pz_LE,F4_LE,C4_LE,P4_LE,P3_LE,C3_LE,F3_LE,Trigger]'; % create tbl
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting'
save(str_mat,'tbl_raw'); % save tbl of EEG data

%% import and separate Arduino SD tones

% import arduino SD tones
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\Arduino Tone Lists\All\'
%%%%% _tones_and_times
fileID = fopen('Maggie_Walk_TTHigh_ArduinoRecording_10min_1sISI_v2.txt');
SD = textscan(fileID,'%f');
tonesAndTimes = SD{1};

% separate out the tones and times
tones = [240;3;3;3;tonesAndTimes(1:2:end)];
times = [0;0;0;0;tonesAndTimes(2:2:end)];
tttable = [times tones];

%% import and separate Arduino SD tones

% 1. collect ISI's
% 2. create list of 0's lasting the duration of the trial
% 3. add in ramp time to create times
% 4. add each time to the correct timepoint
%
k_k = find(tbl_raw(8,1:end)); % Find indices of nonzero elements
% set the value of each stimulus label at each index

% for i = 1:numel(k_k) % for all k events
%     stimDSI=tbl_raw(8,k_k(i)); % replace the cell with the ith event with the type specified in the arduino list of tones
% end

for i = 1:numel(k_k)
    timeDSI(i,:) = Time(k_k(i));
end

sampDSI = [k_k(1) k_k(2:end) + 16];

for i = 1:numel(k_k)-1
    isiDSI(i,:) = timeDSI(i+1)-timeDSI(i);
end

isiArd = [0;0;0;0;tonesAndTimes(2:2:end-1)]; % subtract from the end however many extra tones did not actually get played (and consequently picked up by the DSI)

for i = 1:numel(isiDSI)
    ramp_jitter(i,:) = (isiDSI(i)*1000)-isiArd(i)-100;
end

mean_ramp_jitter = mean(ramp_jitter(6:end-1));

clear timeArd
timeArd = [timeDSI(1:5);zeros(length(timeDSI)-5,1)];
for i = 5:numel(isiArd)
    timeArd(i+1) = (isiArd(i)*0.001)+0.1+timeArd(i)+mean_ramp_jitter*0.001;
end

% plot DSI tones

% timeline=[1:(numel(Trigger))]';
timeline2=ones(numel(timeDSI),1)*8;

figure(1)
line(Time_duration,Trigger_duration,'LineWidth',1.2)
ylim([-0.5,8.5])
hold on
plot(timeArd,timeline2,'m+')

% figure(11)
% ylim([-0.5,8.5])
% xlim([585,587])