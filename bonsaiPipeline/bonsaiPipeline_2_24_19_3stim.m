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
filename_duration = 'Maggie_Stand_3stim_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_duration_raw.csv';
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
filename = 'Maggie_Stand_3stim_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_raw.csv';
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

%% import and separate Arduino SD tones


% import arduino SD tones
% cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\2_24_19\Arduino Tone Lists\All'
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\Arduino Tone Lists\All';
%%%%% _tones_and_times
%fileID = fopen('Maggie_Sit_TTHigh_ArduinoRecording_10min_1sISI_postWalk.txt');
%fileID = fopen('Maggie_Walk_TTHigh_ArduinoRecording_10min_1sISI_tones_and_times.txt');

%fileID = fopen('Maggie_Walk_TTHigh_ArduinoRecording_10min_1sISI_v2_manualFix.txt');
fileID = fopen('Maggie_Stand_3stim_TTHigh_ArduinoRecording_15min_1sISI_375msjitter.txt');
%fileID = fopen('Maggie_Treadmill_TTHigh_ArduinoRecording_10min_1sISI_postWalkSit.txt');
SD = textscan(fileID,'%f');
tonesAndTimes = SD{1};
%tonesAndTimes = zeros(length(tonesAndTimes),1);
% separate out the tones and times
tones = [240;4;4;tonesAndTimes(2:2:end-1)];
times = [0;0;0;tonesAndTimes(3:2:end-1)];
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
isiArd = [0;0;0;tonesAndTimes(3:2:numel(tonesAndTimes)-2)]; 
% isiArd = [0;0;0;0;tonesAndTimes(2:2:numel(tonesAndTimes)-tonesExtra)]; 

% Calculate the average difference between the time that the DSI picked up
% the tones and when the Arduino actually played them
mean_ramp_jitter = 19.5846;

%% Estimate the times that Arduino played the tones
% initialize using the first 5 times that the DSI picked up tones and zeros
    clear timeArd_all
    timeArd_all = [timeDSI(1:4);zeros(length(timeDSI)-4,1)]; 
    %timeArd_all = zeros(numel(isiArd),1);
% starting from the previous tone, add the isi, plus the ramp, plus the average jitter
    for i = 4:numel(isiArd)
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
timeArd = timeArd_all(1:numel(timeArd_all)-tonesExtra);
timeline2 = ones(numel(timeArd),1)*8.02;

% 
% figure()
% line(Time_duration,Trigger_duration,'LineWidth',1.2)
% ylim([-0.5,8.5])
% hold on
% plot(timeArd,timeline2,'m+')

%%
%Calculate the differences between times that DSI picked up tones and when Arduino played them
for i = 1:numel(isiArd)
    ramp_jitter(i,:) = (isiDSI(i)*1000)-isiArd(i)-100; 
end
mean_ramp_jitter = mean(ramp_jitter(5:end-1));

% Estimate the times that Arduino played the tones

% initialize using the first 5 times that the DSI picked up tones and zeros
    clear timeArd_all
    timeArd_all = [timeDSI(1:4);zeros(length(timeDSI)-4,1)]; 
    %timeArd_all = zeros(numel(isiArd),1);
% starting from the previous tone, add the isi, plus the ramp, plus the average jitter
    for i = 4:numel(isiArd)
        timeArd_all(i+1) = timeArd_all(i) + (isiArd(i)*0.001) + 0.1 + (mean_ramp_jitter*0.001); 
    end
    
% Calculate the number of extra tones that the Arduino played but were not picked up by the DSI, or vice versa

% Find the last time that the DSI picked up a tone
%     last_time = Time(k_k(end)); 
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
tbl_raw(8,:) = stim;
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz'
%cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting3_05Hz_30Hz'
str_mat = strrep(filename,'_raw.csv','_raw.mat'); % table of EEG data (.mat)
save(str_mat,'tbl_raw'); % re-save raw table with updated event values

%% equalize the number of target and nontarget trials
% replace a random subset of nontarget values with 4's
% j = sum(tones(:)==2); % j original nontarget tones (192)
% m = sum(tones(:)==1); % n targets and n nontargets to be averaged (69)
% n = j-m; % number of nontargets that should be replaced with 4's (123)
% p = (tones==2); % new tones list with 1 for every nontarget tone, and 0 for everything else (265)
% idx = find(p==1); % double check that there are n elements in idx
% % % (n=numel(idx))
% s = RandStream('mlfg6331_64'); 
% samp = datasample(s,idx,n,'Replace',false);
% tones_new = tones;
% idx1 = find(tones_new==2); % make sure there are j tones in idx1
% for ii = 1:numel(samp)
%     tones_new(samp(ii)) = 4;
% end
% idx2 = find(tones_new==2); % make sure there are only m tones in idx2
% 
% tttable_new = [times tones_new];
% % detect indices of stimuli
% %k = find(tbl_raw(8,1:end)); % Find indices of nonzero elements
% 
% % % check to make sure the tones and times arent too off
% % k_1 = k(5); % first actual tone
% % k_2 = k(6); % 2nd actual tone
% % k_2_check = (((k_1*1000/Fsp)+116) + times(5))*Fsp/1000; % in samples
% % lag = k_2 - k_2_check;
% 
% % set the value of each stimulus label at each index
 tbl_raw_alltrials = tbl_raw;
% for i = 1:numel(k_k)-1 % for all k events
%     tbl_raw(8,k_k(i))=tttable_new(i,2); % replace the cell with the ith event with the type specified in the arduino list of tones
% end
% %tbl_raw(8,k_k(end))=4;
% % save raw data with equalized number of trials
% cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz'
% %cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting3_05Hz_30Hz'
% str_mat = strrep(filename,'_raw.csv','_raw_eqNumTrials.mat'); % table of EEG data with equalized number of trials(.mat)
% save(str_mat,'tbl_raw'); % save raw data with equalized number of trials
% 


















%% plot to check everything is aligned
tonesDSI = tbl_raw_alltrials(8,k_k)';
% tonesDSI = tonesDSI_all(1:end-tonesExtra);
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
str_mat = strrep(filename,'_raw.csv','_filt_a_b_1_allTrials.mat'); % table of EEG data (.mat)
save(str_mat,'tbl_filt_a_b_1_tr'); % save b,a butter -> filtfilt filtered data
str_mat = strrep(filename,'_raw.csv','_filt_a_b_2_allTrials.mat'); % table of EEG data (.mat)
save(str_mat,'tbl_filt_a_b_2_tr'); % save b,a butter -> filtfilt filtered data
str_mat = strrep(filename,'_raw.csv','_filt_a_b_4_allTrials.mat'); % table of EEG data (.mat)
save(str_mat,'tbl_filt_a_b_4_tr'); % save b,a butter -> filtfilt filtered data
%% move to EEGLAB
close allv
clear
clc
cd 'C:\Users\mswerdloff\eeglab14_1_2b'
eeglab