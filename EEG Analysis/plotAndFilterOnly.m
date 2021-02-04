clear 
close all
%% import non-duration file
Fsp = 300; % sampling rate in Hz
Fn = Fsp/2; % Nyquist frequency
hp = 0.5; lp = 30;
%cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting2'
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\DSI_data\All'
filename = 'Richard_walkingTreadmill_TTHigh_1sISI_raw.csv';
%filename = 'Maggie_Walk_TTHigh_ArduinoRecording_10min_1sISI_manualFixR_raw.csv';

str_mat = strrep(filename,'.csv','.mat'); % table of EEG data (.mat)
% str_ascii = strrep(filename,'.csv','.txt'); % table of EEG data (.txt)
str_events = strrep(filename,'.csv',''); % table of events
str_events_csv = strrep(filename,'.csv','_eventsMatlab.csv'); % table of events (.csv)

% % specify times and channels
startRow = 17; % time = 0
endRow = inf; % time = end of trial
[Time,LE,F4,C4,P4,P3,C3,F3,Trigger,Time_Offset,ADC_Status,ADC_Sequence,Event,Comments] = importRaw(filename, startRow, endRow); % import

Pz_LE = -1*LE; % reference Pz to LE
F4_LE = F4-LE; C4_LE = C4-LE; P4_LE = P4-LE; P3_LE = P3-LE; C3_LE = C3-LE; F3_LE = F3-LE; % reference all other channels to LE

%% save raw EEG data
tbl_raw = [Pz_LE,F4_LE,C4_LE,P4_LE,P3_LE,C3_LE,F3_LE,Trigger]'; % create tbl
% cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting2'
% cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting2'
% save(str_mat,'tbl_raw'); % save tbl of EEG data

stim = tbl_raw(8,:);
%% remove DC bias
for i = 1:size(tbl_raw,1)-1
tbl_detrend(i,:) = tbl_raw(i,:)-mean(tbl_raw(i,:));
end

%% filter data
% create butterworth bandpass filters
[b1,a1] = butter(1,[hp lp]/Fn);
[b2,a2] = butter(2,[hp lp]/Fn);
[b4,a4] = butter(4,[hp lp]/Fn);
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

% Plot filtered data and raw on same axes
figure()
r = plot([tbl_raw(1,4000:6000)' tbl_detrend(1,4000:6000)']);
legend('raw data','detrended data')
figure()
f = plot([tbl_filt_a_b_1r(4000:6000,1) tbl_filt_a_b_2r(4000:6000,1) tbl_filt_a_b_4r(4000:6000,1) tbl_filt_a_b_1(4000:6000,1) tbl_filt_a_b_2(4000:6000,1) tbl_filt_a_b_4(4000:6000,1)]);
title('Butterworth bandpass filtered data (0.1-30 Hz) implemented using filtfilt')
legend('4th order','8th order','16th order','4th order detrended','8th order detrended','16th order detrended')
xlabel('Samples')
ylabel('Potential (uV)')