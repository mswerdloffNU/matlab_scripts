clear
close all
clc
%% arduino generator
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\DSI_data\All'
% cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\2_24_19'
%cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting3_05Hz_30Hz'
% _manualFix
%filename_duration = 'Maggie_Sit_TTHigh_ArduinoRecording_10min_1sISI_postWalk_duration_raw.csv';
%filename_duration = 'Maggie_Walk_TTHigh_ArduinoRecording_10min_1sISI_duration_manualFixR_raw.csv';

%filename_duration = 'Maggie_Walk_TTHigh_ArduinoRecording_10min_1sISI_v2_duration_manualFixR_raw.csv';
filename_duration = 'Maggie_Treadmill_1sISI_375msjittter_preSitStand_duration_raw.csv';
%filename_duration = 'Maggie_Treadmill_TTHigh_ArduinoRecording_10min_1sISI_postWalkSit_duration_manualFixR_raw.csv';
%% import file
% % specify times and channels
startRow = 17; % time = 0
endRow = inf; % time = end of trial
[Time_duration,LE,F4,C4,P4,P3,C3,F3,Trigger_duration,Time_Offset,ADC_Status,ADC_Sequence,Event,Comments] = importRaw(filename_duration, startRow, endRow); % import

vars = {'LE','F4','C4','P4','P3','C3','F3','Time_Offset','ADC_Status','ADC_Sequence','Event','Comments'};
clear(vars{:})

%% import non-duration file
Fsp = 300; % sampling rate in Hz
Fn = Fsp/2; % Nyquist frequency
%cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting3_05Hz_30Hz'
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\DSI_data\All'
%cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\2_24_19'
%filename = 'Maggie_Sit_TTHigh_ArduinoRecording_10min_1sISI_postWalk_raw.csv';
%filename = 'Maggie_Walk_TTHigh_ArduinoRecording_10min_1sISI_manualFixR_raw.csv';

%filename = 'Maggie_Walk_TTHigh_ArduinoRecording_10min_1sISI_v2_manualFixR_raw.csv';
filename = 'Maggie_Treadmill_1sISI_375msjittter_preSitStand_raw.csv';
%filename = 'Maggie_Treadmill_TTHigh_ArduinoRecording_10min_1sISI_postWalkSit_manualFixR_raw.csv';
% Outline:
%% Import DSI data
% specify filenames
% specify times and channels
%% Re-reference channels
%% Save raw EEG data
%% Import and separate Arduino SD tones
% import arduino SD tones
% separate out the tones from the times
% detect indices of stimuli (ie. nonzero values)
% % check to make sure the tones and times arent too off (*needs work)
% re-write stimulus labels at each index
%% Filter data
% create butterworth bandpass filters
% % visualize butterworth filters
% % other methods of creating filters (not necessary)
% apply filtfilt to all data except the events
% transpose back to OG form, and add events back in
% plot filtered data and raw on same axes
%% Save filtered EEG data

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
% cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting3_05Hz_30Hz'
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz'
save(str_mat,'tbl_raw'); % save tbl of EEG data

%% plot DSI tones
 
figure()
line(Time_duration,Trigger_duration,'LineWidth',1.2)
ylim([-0.5,8.5])
pause
close

%%
n = 5; % number of accidental tones picked up by DSI before actual arduino tones started
%% import and separate Arduino SD tones


% import arduino SD tones
% cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\2_24_19\Arduino Tone Lists\All'
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\Arduino Tone Lists\All';
%%%%% _tones_and_times
%fileID = fopen('Maggie_Sit_TTHigh_ArduinoRecording_10min_1sISI_postWalk.txt');
%fileID = fopen('Maggie_Walk_TTHigh_ArduinoRecording_10min_1sISI_tones_and_times.txt');

%fileID = fopen('Maggie_Walk_TTHigh_ArduinoRecording_10min_1sISI_v2_manualFix.txt');
fileID = fopen('Maggie_Treadmill_1sISI_375msjittter_preSitStand.txt');
%fileID = fopen('Maggie_Treadmill_TTHigh_ArduinoRecording_10min_1sISI_postWalkSit.txt');
SD = textscan(fileID,'%f');
tonesAndTimes = SD{1};
%tonesAndTimes = zeros(length(tonesAndTimes),1);
% separate out the tones and times
tones = [240;4;4;4;tonesAndTimes(2:2:end-1)];
times = [0;0;0;0;tonesAndTimes(3:2:end-1)];
tttable = [times tones];

%% Arduino Stim Generator
% Find indices of nonzero elements
    k_k = find(tbl_raw(8,1:end)); 
% List times of all the DSI tones
    for i = 1:numel(k_k)
        timeDSI(i,:) = Time(k_k(i)); 
    end
% List samples corresponding to timeDSI
    % sampDSI = [k_k(1) k_k(2:end) + 16]; 
% List interstimulus intervals recorded by DSI
    for i = 1:numel(k_k)-1
        isiDSI(i,:) = timeDSI(i+1)-timeDSI(i); 
    end
% List interstimulus intervals recorded by Arduino
% Here you should subtract from the end however many extra tones did not actually get played (and consequently picked up by the DSI)
isiArd = [0;0;0;0;tonesAndTimes(3:2:numel(tonesAndTimes))]; 
% isiArd = [0;0;0;0;tonesAndTimes(2:2:numel(tonesAndTimes)-tonesExtra)]; 

% Calculate the average difference between the time that the DSI picked up
% the tones and when the Arduino actually played them
%mean_ramp_jitter = 19.5846;
mean_ramp_jitter = 18.7;

%% for missing DSI data only
Trigger(find(Time == cursor_info.Position(1))) % check to make sure this is 8
Trigger_est = find(Trigger ~= 0)';

TimeDSI_est = [Trigger_est zeros(1,(numel(tones)-numel(Trigger_est)))]';
TimeDSI_est(n) = TimeDSI_est(n-1)+1462;

for i = n:numel(tones)
    TimeDSI_est(i+1) = TimeDSI_est(i) + mean_ramp_jitter + isiArd(i);
end

%% Estimate the times that Arduino played the tones
% initialize using the first 4 times that the DSI picked up tones and zeros
    clear timeArd_all
%     n=5;
    timeArd_all = [timeDSI(1:n);zeros(length(timeDSI)-n,1)]; 
    %timeArd_all = zeros(numel(isiArd),1);
% starting from the previous tone, add the isi, plus the ramp, plus the average jitter
    for i = n:numel(isiArd)
        timeArd_all(i+1) = timeArd_all(i) + (isiArd(i)*0.001) + 0.1 + (mean_ramp_jitter*0.001); 
    end
    
%% Calculate the number of extra tones that the Arduino played but were not picked up by the DSI, or vice versa

% Find the last time that the DSI picked up a tone
    last_time = Time(k_k(end)); 
% Initialize 
    tonesExtra = 0;
% For every tone played by the Arduino, see if the time it was played is
% more than the last time picked up by the DSI; if it was, then count that
% one as an extra tone.
    for i = 1:numel(timeArd_all)
        if timeArd_all(i) > last_time
            tonesExtra = tonesExtra+1;
        end
    end
    
%% plot DSI tones
%tonesExtra = 0; % uncomment to plot all Arduino tones
% timeline=[1:(numel(Trigger))]';
% timeArd = timeArd_all(1:numel(timeArd_all)-tonesExtra);
% timeline2 = ones(numel(timeArd),1)*8.02;
% 
% % 
% % figure()
% % line(Time_duration,Trigger_duration,'LineWidth',1.2)
% % ylim([-0.5,8.5])
% % hold on
% % plot(timeArd,timeline2,'m+')

%%
%Calculate the differences between times that DSI picked up tones and when Arduino played them
for i = 1:numel(isiArd)
    ramp_jitter(i,:) = (isiDSI(i)*1000)-isiArd(i)-100; 
end
mean_ramp_jitter = mean(ramp_jitter(n+1:end-1));

% Estimate the times that Arduino played the tones

% initialize using the first 5 times that the DSI picked up tones and zeros
    clear timeArd_all
    timeArd_all = [timeDSI(1:n);zeros(length(timeDSI)-n,1)]; 
    %timeArd_all = zeros(numel(isiArd),1);
% starting from the previous tone, add the isi, plus the ramp, plus the average jitter
    for i = n:numel(isiArd)
        timeArd_all(i+1) = timeArd_all(i) + (isiArd(i)*0.001) + 0.1 + (mean_ramp_jitter*0.001); 
    end
    
% Calculate the number of extra tones that the Arduino played but were not picked up by the DSI, or vice versa

% Find the last time that the DSI picked up a tone
    %last_time = Time(k_k(end)); 
      last_times = find(timeArd_all == 0);
      last_time = timeArd_all(last_times(1)-1);
% Initialize 
    tonesExtra = 0;
% For every tone played by the Arduino, see if the time it was played is
% more than the last time picked up by the DSI; if it was, then count that
% one as an extra tone.
    for i = 1:numel(timeDSI)
        if timeDSI(i) > last_time
            tonesExtra = tonesExtra+1;
        end
    end
    
% plot DSI tones
% tonesExtra = 0; % uncomment to plot all Arduino tones
% timeline=[1:(numel(Trigger))]';
timeArd = timeArd_all(1:numel(timeArd_all)-tonesExtra);
timeline2 = ones(numel(timeArd),1)*8;


figure(1)
line(Time_duration,Trigger_duration,'LineWidth',1.2)
ylim([-0.5,8.5])
hold on
plot(timeArd,timeline2,'m+')

%% decide what to do with tone
%tones_new = [tones;0]; %uncomment if there are less tone labels than tones
%picked up by DSI (this could happen if the Arduino is turned off before it
%records the tone name)
%tonelabels = num2str(tones_new); % uncomment if necessary according to the
%previous comment
tonelabels = num2str(tones);
figure(2)
line(Time_duration,Trigger_duration,'LineWidth',1.2)
ylim([-0.5,8.5])
hold on
plot(timeArd,timeline2,'m+')
text(timeArd,timeline2,tonelabels)

%% Check tones detected by R
% detect = [175282 200542];
% detectR = [detect]/300
% for i = 1:numel(detectR)
%     detectRc = detectR(i)
%     figure(2)
%     xlim([detectRc-0.5,detectRc+0.5])
%     pause
% end
% 
% tones2fix = [detect]+16



%%%%%%%%%%













%% set the value of each stimulus label at each index
tbl_raw_old = tbl_raw;
stim = tbl_raw(8,:);

k_k2 = k_k(1:numel(tones));
k3 = numel(k_k2)+1;
for i = 1:numel(k_k2) % for all k events
    stim(k_k2(i))=tttable(i,2); % replace the cell with the ith event with the type specified in the arduino list of tones
end
for i = k3:numel(k_k)
    stim(k_k(i))=0;
end

% for i = 1:numel(k_k2) % for all k events
%     tbl_raw(8,k_k2(i))=tttable(i,2); % replace the cell with the ith event with the type specified in the arduino list of tones
% end

%% for stimulus splitting only
% stim_Start2back = find(Event(2:end) ~= 0);
% stim_2back = [zeros(1,stim_Start2back-1) stim(stim_Start2back:end)];
% stim_baseline = [stim(1:stim_Start2back-1) zeros(1,numel(stim(stim_Start2back:end)))];

% stim = stim_baseline; 
% stim = stim_2back;

% tbl_raw(8,:) = stim;
% cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz'
% %cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting3_05Hz_30Hz'
% str_mat = strrep(filename,'_raw.csv','_baseline_raw.mat'); % table of EEG data (.mat)
% save(str_mat,'tbl_raw'); % re-save raw table with updated event values
% 

% tbl_raw(8,:) = stim;
% cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz'
% %cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting3_05Hz_30Hz'
% str_mat = strrep(filename,'_raw.csv','_2back_raw.mat'); % table of EEG data (.mat)
% save(str_mat,'tbl_raw'); % re-save raw table with updated event values

%%
tbl_raw(8,:) = stim;
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz'
%cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting3_05Hz_30Hz'
str_mat = strrep(filename,'_raw.csv','_raw.mat'); % table of EEG data (.mat)
save(str_mat,'tbl_raw'); % re-save raw table with updated event values

%% equalize the number of target and nontarget trials
%SECTION ERASED -- DO THIS IN EEGLAB AVERAGER

%% plot to check everything is aligned
stim = tbl_raw(8,:);
tbl_raw_alltrials = tbl_raw;
tonesDSI = tbl_raw_alltrials(8,k_k)';
timeline3 = ones(numel(timeDSI),1)*8.1;
tonelabelsDSI = num2str(tonesDSI);
figure()
line(Time_duration,Trigger_duration,'LineWidth',1.2)
ylim([7.8,8.2])
hold on
grid on
plot(timeArd,timeline2,'m+')
text(timeArd,timeline2,tonelabels)
plot(timeDSI,timeline3,'+')
text(timeDSI,timeline3,tonelabelsDSI)
pause
xlim([155,185])
ylim([7.97,8.1]) 

%% remove DC bias
for i = 1:size(tbl_raw,1)-1
tbl_detrend(i,:) = tbl_raw(i,:)-mean(tbl_raw(i,:));
end

%% filter data
% create butterworth bandpass filters
[b1,a1] = butter(1,[0.5 30]/Fn);
[b2,a2] = butter(2,[0.5 30]/Fn);
[b4,a4] = butter(4,[0.5 30]/Fn);
% % visualize butterworth filters
% h1 = fvtool(b1,a1);
% h2 = fvtool(b2,a2);
% h4 = fvtool(b4,a4);
% figure()
% freqz(b1,a1,256,300)
% figure()
% freqz(b2,a2,256,300)
% figure()
% freqz(b4,a4,256,300)

% % other methods of creating filters
% % % [A,B,C,D] = butter(4,[0.1 30]/Fn); %4th order butterworth ** trouble
% % using with filtfilt
% d = designfilt('bandpassiir','FilterOrder',4, ...
%     'HalfPowerFrequency1',0.1,'HalfPowerFrequency2',30, ...
%     'SampleRate',Fsp); %identical 4th order
% sos = ss2sos(A,B,C,D);
% fvt = fvtool(sos,d,'Fs',Fsp);
% legend(fvt,'butter','designfilt')

% apply filtfilt
tbl_filt_a_b_1 = filtfilt(b1,a1,tbl_detrend(1:7,:)');
tbl_filt_a_b_2 = filtfilt(b2,a2,tbl_detrend(1:7,:)');
tbl_filt_a_b_4 = filtfilt(b4,a4,tbl_detrend(1:7,:)');

tbl_filt_a_b_1r = filtfilt(b1,a1,tbl_raw(1:7,:)'); % r = raw
tbl_filt_a_b_2r = filtfilt(b2,a2,tbl_raw(1:7,:)'); % r = raw
tbl_filt_a_b_4r = filtfilt(b4,a4,tbl_raw(1:7,:)'); % r = raw

% transpose back to OG form, and add events back in (tr = transposed)
tbl_filt_a_b_1_tr = [tbl_filt_a_b_1'; stim];
tbl_filt_a_b_2_tr = [tbl_filt_a_b_2'; stim];
tbl_filt_a_b_4_tr = [tbl_filt_a_b_4'; stim];

tbl_filt_a_b_1_tr_r = [tbl_filt_a_b_1r'; stim];
tbl_filt_a_b_2_tr_r = [tbl_filt_a_b_2r'; stim];
tbl_filt_a_b_4_tr_r = [tbl_filt_a_b_4r'; stim];

%% Plot data

% Plot the Frequency spectrum of each channel
N = length(tbl_raw); % number of points in the signal
% Junk:
% % % % for i = 1:size((tbl_raw),1)-1
% % % %     X_raw(i,:)=tbl_raw(i,:);
% % % % end
% % % % X1_mags_raw=X_raw(1,:);X2_mags=X_raw(2,:);X3_mags=X_raw(3,:);X4_mags=X_raw(4,:);X5_mags=X_raw(5,:);X6_mags=X_raw(6,:);X7_mags=X_raw(7,:);
% % % % X1=fftshift(fft(tbl_raw(1,:)));X2=fftshift(fft(tbl_raw(2,:)));X3=fftshift(fft(tbl_raw(3,:)));X4=fftshift(fft(tbl_raw(4,:)));X5=fftshift(fft(tbl_raw(5,:)));X6=fftshift(fft(tbl_raw(6,:)));X7=fftshift(fft(tbl_raw(7,:)));
X(i,:)=fftshift(fft(tbl_raw(1,:)));
% dF = Fsp/N;                      % Hz
% f = -Fsp/2:dF:Fsp/2-dF;           % Hz
% for i = 1:size((tbl_raw),1)-1
%     X(i,:) = fftshift(fft(tbl_filt_a_b_1_tr(i,:)));
%     x(i,:) = abs(X(i,:))/N;
%     figure(i)
%     plot(f,x(i,:),'-');
%     xlim([0 75])
%     ylim([0 1])
%     xlabel('Frequency (Hz)');
%     title('Magnitude Response');
% end

% Plot all raw unfiltered data
figure()
hold on
for i = 1:7
   plot(tbl_raw(i,:)+200*(1-i))
end
hold off
grid on
legend('Pz','F4','C4','P4','P3','C3','F3')
title('Raw data, stacked, referenced to LE')
savefig('Raw data_stacked_referenced to LE.fig')

% Plot all detrended data
figure()
hold on
for i = 1:7
    plot(tbl_detrend(i,:)+200*(1-i))
end
hold off
grid on
legend('Pz','F4','C4','P4','P3','C3','F3')
title('Detrended data, stacked, referenced to LE')
savefig('Detrended data_stacked_referenced to LE.fig')

% Plot all filtered data
figure()
hold on
for i = 1:7
    plot(tbl_filt_a_b_1_tr(i,:)+200*(1-i))
end
hold off
grid on
legend('Pz','F4','C4','P4','P3','C3','F3')
title('Filtered data, stacked, referenced to LE')
savefig('Filtered data_stacked_referenced to LE.fig')

% Plot filtered data and raw on same axes
figure()
r = plot([tbl_raw(1,4000:6000)' tbl_detrend(1,4000:6000)']);
legend('raw data','detrended data')
figure()
f = plot([tbl_filt_a_b_1r(4000:6000,1) tbl_filt_a_b_2r(4000:6000,1) tbl_filt_a_b_4r(4000:6000,1) tbl_filt_a_b_1(4000:6000,1) tbl_filt_a_b_2(4000:6000,1) tbl_filt_a_b_4(4000:6000,1)]);
title('Butterworth bandpass filtered data (0.5-30 Hz) implemented using filtfilt')
legend('4th order','8th order','16th order','4th order detrended','8th order detrended','16th order detrended')
xlabel('Samples')
ylabel('Potential (uV)')
savefig('Butterworth bandpass filtered data.fig')

%% save filtered EEG data
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz'
%cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting3_05Hz_30Hz'
str_mat = strrep(filename,'_raw.csv','_filt_a_b_1_baseline.mat'); % table of EEG data (.mat)
save(str_mat,'tbl_filt_a_b_1_tr'); % save b,a butter -> filtfilt filtered data
str_mat = strrep(filename,'_raw.csv','_filt_a_b_2_baseline.mat'); % table of EEG data (.mat)
save(str_mat,'tbl_filt_a_b_2_tr'); % save b,a butter -> filtfilt filtered data
str_mat = strrep(filename,'_raw.csv','_filt_a_b_4_baseline.mat'); % table of EEG data (.mat)
save(str_mat,'tbl_filt_a_b_4_tr'); % save b,a butter -> filtfilt filtered data

% cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz'
% str_mat = strrep(filename,'_raw.csv','_filt_a_b_1_2back.mat'); % table of EEG data (.mat)
% save(str_mat,'tbl_filt_a_b_1_tr'); % save b,a butter -> filtfilt filtered data
% str_mat = strrep(filename,'_raw.csv','_filt_a_b_2_2back.mat'); % table of EEG data (.mat)
% save(str_mat,'tbl_filt_a_b_2_tr'); % save b,a butter -> filtfilt filtered data
% str_mat = strrep(filename,'_raw.csv','_filt_a_b_4_2back.mat'); % table of EEG data (.mat)
% save(str_mat,'tbl_filt_a_b_4_tr'); % save b,a butter -> filtfilt filtered data
%% move to EEGLAB
close all
clear
clc
cd 'C:\Users\mswerdloff\eeglab14_1_2b'
eeglab
%%
EEG = pop_importdata('data','tbl_filt_a_b_2_tr','dataformat','array');
EEG = pop_editset(EEG);
pop_chanevent
eeg_checkset
pop_editset() % 'C:\Users\mswerdloff\eeglab14_1_2b\chanlocsDSI7.ced'
readlocs() % 'chanedit' format assumed from file extension
EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist',...
 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T4\Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_EventListA.txt' ); % GUI: 08-Apr-2019 15:02:09
EEG  = pop_binlister( EEG , 'BDF', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\EEG_data_withTriggers\binlist6.txt',...
 'ExportEL', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T4\Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_EventListB.txt',...
 'IndexEL',  1, 'SendEL2', 'All', 'UpdateEEG', 'on', 'Voutput', 'EEG' ); % GUI: 08-Apr-2019 15:02:57
EEG = pop_epochbin( EEG , [-200.0  800.0],  'pre'); % GUI: 08-Apr-2019 15:03:20
EEG  = pop_artmwppth( EEG , 'Channel',  1:7, 'Flag',  1, 'Threshold',  100, 'Twindow', [ -200 796.7], 'Windowsize',  200, 'Windowstep',...
  100 ); % GUI: 08-Apr-2019 15:03:40
ERP = pop_averager( ALLEEG , 'Criterion', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T4\trials84.txt',...
 'DSindex',  5, 'ExcludeBoundary', 'on', 'SEM', 'on' );
ERP = pop_savemyerp(ERP, 'erpname',...
 'erpset_Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_84', 'filename',...
 'erpset_Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_84.erp', 'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T4',...
 'Warning', 'on');
ERP = pop_ploterps( ERP, [ 1 2],  1:7 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 3 3], 'ChLabel',...
 'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r--' }, 'LineWidth',  1, 'Maximize',...
 'on', 'Position', [ 103.714 17.7059 106.857 32], 'SEM', 'on', 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0.5, 'xscale',...
 [ -200.0 796.0   -200:200:600 ], 'YDir', 'normal' );
pop_export2text( ERP, 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T4\Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials.txt',...
 [ 1 2], 'electrodes', 'on', 'precision',  10, 'time', 'on', 'timeunit',  0.001 );
%% first 26
ERP = pop_averager( ALLEEG , 'Criterion', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T5\trials_first26.txt',...
 'DSindex',  5, 'ExcludeBoundary', 'on', 'SEM', 'on' );
ERP = pop_savemyerp(ERP, 'erpname',...
 'erpset_Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_first26', 'filename',...
 'erpset_Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_first26.erp', 'filepath',...
 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T5', 'Warning',...
 'on');
ERP = pop_ploterps( ERP, [ 1 2],  1:7 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 3 3], 'ChLabel',...
 'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r--' }, 'LineWidth',  1, 'Maximize',...
 'on', 'Position', [ 103.714 17.7059 106.857 32], 'SEM', 'on', 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0.5, 'xscale',...
 [ -200.0 796.0   -200:200:600 ], 'YDir', 'normal' );
pop_export2text( ERP, 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T4\Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_first26.txt',...
 [ 1 2], 'electrodes', 'on', 'precision',  10, 'time', 'on', 'timeunit',  0.001 );
%% last 26
ERP = pop_averager( ALLEEG , 'Criterion', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T6\trials_last26.txt',...
 'DSindex',  5, 'ExcludeBoundary', 'on', 'SEM', 'on' );
ERP = pop_savemyerp(ERP, 'erpname',...
 'erpset_Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_last26', 'filename',...
 'erpset_Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_last26.erp', 'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T6',...
 'Warning', 'on');
ERP = pop_ploterps( ERP, [ 1 2],  1:7 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 3 3], 'ChLabel',...
 'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r--' }, 'LineWidth',  1, 'Maximize',...
 'on', 'Position', [ 103.714 17.7059 106.857 32], 'SEM', 'on', 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0.5, 'xscale',...
 [ -200.0 796.0   -200:200:600 ], 'YDir', 'normal' );
pop_export2text( ERP, 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T6\Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_last26.txt',...
 [ 1 2], 'electrodes', 'on', 'precision',  10, 'time', 'on', 'timeunit',  0.001 );
%%
ERP = pop_exporterplabfigure( ERP , 'Filepath', 'C:\Users\mswerdloff\eeglab14_1_2b', 'Format', 'pdf', 'Resolution',  1200, 'SaveMode', 'saveas',...
 'Tag', {'ERP_figure' } );