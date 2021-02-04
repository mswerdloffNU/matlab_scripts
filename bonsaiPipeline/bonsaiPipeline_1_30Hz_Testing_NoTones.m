clear

Fsp = 300; % sampling rate in Hz
Fn = Fsp/2; % Nyquist frequency
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\DSI_data\All'
filename = 'Maggie_Artifact_Test_raw.csv';

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
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\EEG_data_withTriggers\1_30Hz_Testing'
save(str_mat,'tbl_raw'); % save tbl of EEG data

%% import and separate Arduino SD tones

% import arduino SD tones
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\Arduino Tone Lists\All\'
fileID = fopen('empty_tones_and_times.txt');
SD = textscan(fileID,'%f');
tonesAndTimes = SD{1};

% separate out the tones and times
tones = [0];
times = [0];
tttable = [times tones];

% detect indices of stimuli
k = find(tbl_raw(8,2:end)); % Find indices of nonzero elements

% % check to make sure the tones and times arent too off
% k_1 = k(5); % first actual tone
% k_2 = k(6); % 2nd actual tone
% k_2_check = (((k_1*1000/Fsp)+116) + times(5))*Fsp/1000; % in samples
% lag = k_2 - k_2_check;

% set the value of each stimulus label at each index
for i = 1:numel(k) % for all k events
    tbl_raw(8,k(i)+1)=tttable(i,2); % replace the cell with the ith event with the type specified in the arduino list of tones
end
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\EEG_data_withTriggers\1_30Hz_Testing'
str_mat = strrep(filename,'_raw.csv','_raw_1_30Hz_Testing.mat'); % table of EEG data (.mat)
save(str_mat,'tbl_raw'); % re-save raw table with updated event values

% equalize the number of target and nontarget trials
% replace a random subset of nontarget values with 4's
j = sum(tones(:)==2); % j original nontarget tones (192)
m = sum(tones(:)==1); % n targets and n nontargets to be averaged (69)
n = j-m; % number of nontargets that should be replaced with 4's (123)
p = (tones==2); % new tones list with 1 for every nontarget tone, and 0 for everything else (265)
idx = find(p==1); % double check that there are n elements in idx
% % (n=numel(idx))
s = RandStream('mlfg6331_64'); 
samp = datasample(s,idx,n,'Replace',false);
tones_new = tones;
idx1 = find(tones_new==2); % make sure there are j tones in idx1
for ii = 1:numel(samp)
    tones_new(samp(ii)) = 4;
end
idx2 = find(tones_new==2); % make sure there are only m tones in idx2

tttable_new = [times tones_new];
% detect indices of stimuli
k = find(tbl_raw(8,2:end)); % Find indices of nonzero elements

% % check to make sure the tones and times arent too off
% k_1 = k(5); % first actual tone
% k_2 = k(6); % 2nd actual tone
% k_2_check = (((k_1*1000/Fsp)+116) + times(5))*Fsp/1000; % in samples
% lag = k_2 - k_2_check;

% set the value of each stimulus label at each index
for i = 1:numel(k) % for all k events
    tbl_raw(8,k(i)+1)=tttable_new(i,2); % replace the cell with the ith event with the type specified in the arduino list of tones
end

stim = tbl_raw(8,:);
% save raw data with equalized number of trials
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\EEG_data_withTriggers\1_30Hz_Testing'
str_mat = strrep(filename,'_raw.csv','_raw_eqNumTrials_1_30Hz_Testing.mat'); % table of EEG data with equalized number of trials(.mat)
save(str_mat,'tbl_raw'); % save raw data with equalized number of trials

%% remove DC bias
for i = 1:size(tbl_raw,1)-1
tbl_detrend(i,:) = tbl_raw(i,:)-mean(tbl_raw(i,:));
end

%% filter data
% create butterworth bandpass filters
[b1,a1] = butter(1,[1 30]/Fn);
[b2,a2] = butter(2,[1 30]/Fn);
[b4,a4] = butter(4,[1 30]/Fn);
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
title('Butterworth bandpass filtered data (1-30 Hz) implemented using filtfilt')
legend('4th order','8th order','16th order','4th order detrended','8th order detrended','16th order detrended')
xlabel('Samples')
ylabel('Potential (uV)')

%% save filtered EEG data
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\EEG_data_withTriggers\1_30Hz_Testing'
str_mat = strrep(filename,'_raw.csv','_filt_a_b_1_eqNumTrials_1_30Hz_Testing.mat'); % table of EEG data (.mat)
save(str_mat,'tbl_filt_a_b_1_tr'); % save b,a butter -> filtfilt filtered data
str_mat = strrep(filename,'_raw.csv','_filt_a_b_2_eqNumTrials_1_30Hz_Testing.mat'); % table of EEG data (.mat)
save(str_mat,'tbl_filt_a_b_2_tr'); % save b,a butter -> filtfilt filtered data
str_mat = strrep(filename,'_raw.csv','_filt_a_b_4_eqNumTrials_1_30Hz_Testing.mat'); % table of EEG data (.mat)
save(str_mat,'tbl_filt_a_b_4_tr'); % save b,a butter -> filtfilt filtered data