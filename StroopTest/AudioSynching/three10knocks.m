%% Align Recordings
% % Recordings aligned by the following:
%(1) Convert the x-axis to time
%(2) Find peaks
%(3) Calculate the average difference between pairs of positive peaks and 
% pairs of negative peaks for the first 5 pairs of peaks, and 
%(4) Subtract that time difference from the lagging signal
%% IMPORT FILES
clearvars
cd('Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\Matlab scripts\StroopTest\AudioSynching')
addpath('Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\EEG\audio_data')
importAudio('three10knocks.m4a')

addpath('Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\EEG\DSI_data\StroopAudio\AudioSynching')
threeKnocksAccel = importAccel('threeKnocks_Accel.csv');

audio = data;
accel = threeKnocksAccel{:,4}+1.02;

% SPECIFY START TIMES
first = 1;
last = numel(audio);
%% FIND PEAKS
% % play around with settings to make sure correct peaks are found
close all
figure
subplot(4,1,1)
plot(audio,'-')
findpeaks(audio(first:last),'MinPeakDistance',10000,'SortStr','descend','MinPeakHeight',.15)
subplot(4,1,2)
plot(audio_rs,'-')
findpeaks(audio_rs,'MinPeakDistance',200,'SortStr','descend','MinPeakHeight',.05)
subplot(4,1,3)
plot(accel,'-')
findpeaks(accel,'MinPeakDistance',20,'SortStr','descend','MinPeakHeight',.025);
subplot(4,1,4)
plot(-accel,'-')
findpeaks(-accel,'MinPeakDistance',20,'SortStr','descend','MinPeakHeight',.001);


%% RESAMPLE AUDIO
% audio_old = audio;
% audio_rs = resample(audio_old, 40,fs);
% t2 = (0:(length(audio_rs)-1))*fs/(40*fs);
% t1 = 0:t2(end)/(length(audio_old)):t2(end)-(1/(length(audio_old)));
% 
% close all
% figure
% hold on
% plot(t1,audio_old,'k-')
% plot(t2,audio_rs,'m-')
% xlabel('Time (s)')
% ylabel('Signal')
% legend('Original','Resampled', ...
%     'Location','NorthWest')
%% PLOT PEAKS

[pks_audp,locs_audp]=findpeaks(audio(first:last),'MinPeakDistance',10000,'SortStr','descend','MinPeakHeight',.15);
[pks_audn,locs_audn]=findpeaks(-audio(first:last),'MinPeakDistance',10000,'SortStr','descend','MinPeakHeight',.15);
[pks_accp,locs_accp]=findpeaks(accel,'MinPeakDistance',20,'SortStr','descend','MinPeakHeight',.025);
[pks_accn,locs_accn]=findpeaks(-accel,'MinPeakDistance',20,'SortStr','descend','MinPeakHeight',.001);
% [pks_aud_rsp,locs_aud_rsp]=findpeaks(audio_rs,'MinPeakDistance',200,'SortStr','descend','MinPeakHeight',.05)
% [pks_aud_rsn,locs_aud_rsn]=findpeaks(-audio_rs,'MinPeakDistance',200,'SortStr','descend','MinPeakHeight',.05)
locs_audp_sort = sort(locs_audp);
locs_audn_sort = sort(locs_audn);
locs_accp_sort = sort(locs_accp);
locs_accn_sort = sort(locs_accn);

%% CONVERT X-AXIS TO TIME
t_aud = (1:length(audio))/fs;
t_acc = threeKnocksAccel{:,1}';

%% PLOT SIGNAL AND PEAKS ON TIME AXIS
figure
subplot(2,1,1)
hold on
plot(t_aud,audio,'-')
plot(t_aud(locs_audp),pks_audp,'mo','MarkerSize',6)
plot(t_aud(locs_audn),-pks_audn,'ko','MarkerSize',6)
ylabel('Audio')
subplot(2,1,2)
hold on
plot(t_acc,accel,'-')
plot(t_acc(locs_accp),pks_accp,'mo','MarkerSize',6)
plot(t_acc(locs_accn),-pks_accn,'ko','MarkerSize',6)
ylabel('Accel')
xlabel('Time (s)')

%% CALCULATE SHIFT NEEDED
shift = [];

% figure %NO SHIFT
% hold on
% plot(t_aud,audio,'-')
% plot(t_aud(locs_audp),pks_audp,'mo','MarkerSize',6)
% plot(t_aud(locs_audn),-pks_audn,'ko','MarkerSize',6)
% hold on
% plot(t_acc+shift,accel+.25,'g-')
% plot(t_acc(locs_accp)+shift,pks_accp+.25,'mo','MarkerSize',6)
% plot(t_acc(locs_accn)+shift,-pks_accn+.25,'ko','MarkerSize',6)
% ylabel('Pre-aligned')

shift(1,1) = abs(t_acc(locs_accp_sort(1))-t_aud(locs_audp_sort(1)));
shift(2,1) = abs(t_acc(locs_accp_sort(2))-t_aud(locs_audp_sort(2)));
shift(3,1) = abs(t_acc(locs_accp_sort(3))-t_aud(locs_audp_sort(3)));
shift(4,1) = abs(t_acc(locs_accp_sort(4))-t_aud(locs_audp_sort(4)));
shift(5,1) = abs(t_acc(locs_accp_sort(5))-t_aud(locs_audp_sort(5)));
shift(1,2) = abs(t_acc(locs_accn_sort(1))-t_aud(locs_audn_sort(1)));
shift(2,2) = abs(t_acc(locs_accn_sort(2))-t_aud(locs_audn_sort(2)));
shift(3,2) = abs(t_acc(locs_accn_sort(3))-t_aud(locs_audn_sort(4)));
shift(4,2) = abs(t_acc(locs_accn_sort(4))-t_aud(locs_audn_sort(5)));
shift(5,2) = abs(t_acc(locs_accn_sort(5))-t_aud(locs_audn_sort(6)));
shift_avg = mean(shift(:));
shift_std = std(shift(:))/numel(shift(:));

%% PLOT ALIGNED SIGNALS
figure % SHIFTED
hold on
plot(t_aud-shift_avg,audio,'m-','LineWidth',1)
plot(t_aud(locs_audp)-shift_avg,pks_audp,'mo','MarkerSize',6)
plot(t_aud(locs_audn)-shift_avg,-pks_audn,'mo','MarkerSize',6)
plot(t_acc,accel,'-','LineWidth',1.5)
plot(t_acc(locs_accp),pks_accp,'bo','MarkerSize',6)
plot(t_acc(locs_accn),-pks_accn,'bo','MarkerSize',6)
ylabel('Aligned')


















%% ALTERNATE METHOD OF ALIGNMENT
A = accel;
B = audio;
% Sampling frequencies
Fs_A = 30; %
Fs_B = 44100; % 1925.93 Hz is the one provided by the device
% Resample signal A
A = resample(A, Fs_B, Fs_A);
% B = resample(B, Fs_A, Fs_B);
%% Plot of the two signals "delayed"
figure()
hold on
plot(A)
plot(B)
legend('accel','audio')
%% Aligning both signals
X = A;
Y = B;
Y2 = Y;
X2 = X;
Y2(Y2<0) = 0;
% X2(X2<0) = 0;
[Xa,Ya,D2] = alignsignals(X2,Y2,[],'truncate');
%%
figure() % plot both signals "aligned"
hold on
plot(Y,'b-', 'LineWidth',1)
plot(Xa,'m-','LineWidth',1.5)
legend('audio','accel')
%%
close all
figure
hold on
plot(Y,'-')
findpeaks(Y(first:last),'MinPeakDistance',10000,'SortStr','descend','MinPeakHeight',.15)
plot(-Y,'-')
findpeaks(-Y,'MinPeakDistance',10000,'SortStr','descend','MinPeakHeight',.15)
plot(Xa,'-')
findpeaks(Xa,'MinPeakDistance',10000,'SortStr','descend','MinPeakHeight',.03);
plot(-Xa,'-')
findpeaks(-Xa,'MinPeakDistance',10000,'SortStr','descend','MinPeakHeight',.03);
% legend('audio','audio_neg','accel','accel_neg')
%%
[pks_audp,locs_audp]=findpeaks(Y(first:last),'MinPeakDistance',10000,'SortStr','descend','MinPeakHeight',.15);
[pks_audn,locs_audn]=findpeaks(-Y,'MinPeakDistance',10000,'SortStr','descend','MinPeakHeight',.15);
[pks_accp,locs_accp]=findpeaks(Xa,'MinPeakDistance',10000,'SortStr','descend','MinPeakHeight',.03);
[pks_accn,locs_accn]=findpeaks(-Xa,'MinPeakDistance',10000,'SortStr','descend','MinPeakHeight',.03);

locs_audp_sort = sort(locs_audp);
locs_audn_sort = sort(locs_audn);
locs_accp_sort = sort(locs_accp);
locs_accn_sort = sort(locs_accn);
%% CONVERT X-AXIS TO TIME
t_aud = (1:length(audio))/fs;
t_acc = threeKnocksAccel{:,1}';

%% CALCULATE SHIFT NEEDED
shift = [];

shift(1,1) = abs(locs_accp_sort(1)-locs_audp_sort(1));
shift(2,1) = abs(locs_accp_sort(2)-locs_audp_sort(2));
shift(3,1) = abs(locs_accp_sort(3)-locs_audp_sort(3));
shift(4,1) = abs(locs_accp_sort(4)-locs_audp_sort(4));
shift(5,1) = abs(locs_accp_sort(5)-locs_audp_sort(5));
shift(1,2) = abs(locs_accn_sort(1)-locs_audn_sort(1));
shift(2,2) = abs(locs_accn_sort(2)-locs_audn_sort(2));
shift(3,2) = abs(locs_accn_sort(3)-locs_audn_sort(4));
shift(4,2) = abs(locs_accn_sort(4)-locs_audn_sort(5));
shift(5,2) = abs(locs_accn_sort(5)-locs_audn_sort(6));
shift_avg = mean(shift(:))/fs;
shift_std = ((std(shift(:))/numel(shift(:))))/fs;

%% PLOT ALIGNED SIGNALS
shift_D2 = D2/fs;
[pks_accp,locs_accp]=findpeaks(accel,'MinPeakDistance',20,'SortStr','descend','MinPeakHeight',.025);
[pks_accn,locs_accn]=findpeaks(-accel,'MinPeakDistance',20,'SortStr','descend','MinPeakHeight',.001);

%%
figure() % SHIFTED
hold on
plot(t_aud-shift_D2,audio,'m-','LineWidth',1)
plot(t_aud(locs_audp)-shift_D2,pks_audp,'mo','MarkerSize',6)
plot(t_aud(locs_audn)-shift_D2,-pks_audn,'mo','MarkerSize',6)
plot(t_acc,accel,'-','LineWidth',1.5)
plot(t_acc(locs_accp),pks_accp,'bo','MarkerSize',6)
plot(t_acc(locs_accn),-pks_accn,'bo','MarkerSize',6)
ylabel('Aligned')