clear
close all %% haha blah
%% arduino generator
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\DSI_data\All'
filename_duration = 'Maggie_Sit_Mickey1_leftBox_v2_0001_duration_raw.csv';
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
filename = 'Maggie_Sit_Mickey1_leftBox_v2_0001_raw.csv';
str_mat = strrep(filename,'.csv','.mat'); % table of EEG data (.mat)
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
% figure()
% line(Time_duration,Trigger_duration,'LineWidth',1.2)
%ylim([-0.5,8.5])

samps = [1:numel(Time)]';
mickey = find(Event ~= 0);
mick_labels = ones(numel(mickey),1)*1.02;

figure()
line(samps,Trigger_duration,'LineWidth',1.2)
hold on
plot(mickey,mick_labels,'m+')

%% create stim variable
stim = tbl_raw(8,:)';
stim_all = find(stim ~= 0)';

% c = find(stim_all==cursor_info.DataIndex);
% d = cursor_info.DataIndex;
% stim_odd = stim_all(c:10:end)';

for i = 1:2:d
    if stim(i) == 1
        stim(i) = 3;
    end
end

for i = 2:2:d
    if stim(i) == 1
        stim(i) = 4;
    end
end

for i = d:numel(stim)
    if stim(i) == 1
        stim(i) = 2;
    end
end

stim2 = stim;
for i = 1:numel(stim_odd)
    r = stim_odd(i);
    stim2(r) = 1;
end

% c = find(stim_all==cursor_info.DataIndex);
% d = cursor_info.DataIndex;
% e = find(stim_all==cursor_info2.DataIndex);
% f = cursor_info2.DataIndex;
% stim_odd = stim_all(c:-10:e)';
% 
% for i = 1:f
%     if stim(i) == 1
%         stim(i) = 3;
%     end
% end
% 
% for i = d:numel(stim)
%     if stim(i) == 1
%         stim(i) = 3;
%     end
% end
% 
% for i = f:d
%     if stim(i) == 1
%         stim(i) = 2;
%     end
% end
% 
% stim2 = stim;
% for i = 1:numel(stim_odd)
%     r = stim_odd(i);
%     stim2(r) = 1;
% end

figure()
line(samps,Trigger_duration,'LineWidth',1.2)
hold on
plot(mickey,mick_labels,'m+')
hold on
plot(samps,stim2,'k+')
ylim([-0.5,4.5])

tbl_raw(8,:) = stim2';
str_mat = strrep(filename,'_raw.csv','_photosensor_raw.mat'); % table of EEG data (.mat)
save(str_mat,'tbl_raw'); % save b,a butter -> filtfilt filtered data

%% remove DC bias
for i = 1:size(tbl_raw,1)-1
tbl_detrend(i,:) = tbl_raw(i,:)-mean(tbl_raw(i,:));
end

%% filter data
% create butterworth bandpass filters
[b1,a1] = butter(1,[0.5 30]/Fn);
[b2,a2] = butter(2,[0.5 30]/Fn);
[b4,a4] = butter(4,[0.5 30]/Fn);
% apply filtfilt
tbl_filt_a_b_1 = filtfilt(b1,a1,tbl_detrend(1:7,:)');
tbl_filt_a_b_2 = filtfilt(b2,a2,tbl_detrend(1:7,:)');
tbl_filt_a_b_4 = filtfilt(b4,a4,tbl_detrend(1:7,:)');

tbl_filt_a_b_1r = filtfilt(b1,a1,tbl_raw(1:7,:)'); % r = raw
tbl_filt_a_b_2r = filtfilt(b2,a2,tbl_raw(1:7,:)'); % r = raw
tbl_filt_a_b_4r = filtfilt(b4,a4,tbl_raw(1:7,:)'); % r = raw


%
stim3 = stim2';
% transpose back to OG form, and add events back in (tr = transposed)
tbl_filt_a_b_1_tr = [tbl_filt_a_b_1'; stim3];
tbl_filt_a_b_2_tr = [tbl_filt_a_b_2'; stim3];
tbl_filt_a_b_4_tr = [tbl_filt_a_b_4'; stim3];

tbl_filt_a_b_1_tr_r = [tbl_filt_a_b_1r'; stim3];
tbl_filt_a_b_2_tr_r = [tbl_filt_a_b_2r'; stim3];
tbl_filt_a_b_4_tr_r = [tbl_filt_a_b_4r'; stim3];

%% Plot data

% Plot the Frequency spectrum of each channel
N = length(tbl_raw); % number of points in the signal
X(i,:)=fftshift(fft(tbl_raw(1,:)));
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
close all
clear

cd 'C:\Users\mswerdloff\eeglab14_1_2b'
eeglab