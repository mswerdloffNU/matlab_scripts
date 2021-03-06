%% Bundling
%% Align Recordings
% % Recordings aligned by the following:
%(1) Convert the x-axis to time
%(2) Find peaks
%(3) Calculate the average difference between pairs of positive peaks and 
% pairs of negative peaks for the first 5 pairs of peaks, and 
%(4) Subtract that time difference from the lagging signal
%% IMPORT FILES
clearvars
% subs = {'S020_SA','S021_SA_0001','S023_SA','S024_SA','S025_SA_0001','S026_SA_0002','S027_SA','S028_SA_0004','S029_SA_0002','S030_SA','S031_SA_0002',...
% 'S032_SA','S033_SA','S034_SA','S034_SA','S035_SA','S036_SA','S037_SA','S038_SA','S039_SA','S040_SA'};
%%
cd('Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\matlab_scripts\StroopTest\AudioSynching')
addpath('Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\EEG\audio_data\StroopAudio_Pilot2')
% importAudio('S020.m4a')
s1 = 1*12.5; % number of seconds you want to read in
s0 = s1; % change here if need to crop initial audio
fs = 44100;
audio = audioread('S021.m4a',[s1*fs-(s0*fs)+1 s1*fs]);
figure
plot(audio)
%%
addpath('Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\EEG\DSI_data\StroopAudio\study1')
csvAccel = importAccel('S021_SA_0001_Accel.csv');
accel_all = csvAccel{:,4}+1.02;
figure
plot(accel_all)
%% SPECIFY START TIMES
cursor_info_sub = cursor_info1;
firsta = {cursor_info_sub(1).Position}.';
first_acc = firsta{1,1}(1,1);
lasta = {cursor_info_sub(2).Position}.';
last_acc = lasta{1,1}(1,1);
if last_acc < first_acc
    last_acc_old = last_acc;
    last_acc = first_acc;
    first_acc = last_acc_old;
end
accel = accel_all(first_acc:last_acc);

% Plot just the knocks for accel and audio
figure
subplot(2,1,1)
plot(audio)
subplot(2,1,2)
plot(accel)
%% FIND PEAKS
% % play around with settings to make sure correct peaks are found
figure
subplot(4,1,1)
plot(audio,'-')
findpeaks(audio,'MinPeakDistance',10000,'SortStr','descend','MinPeakHeight',.15)
subplot(4,1,2)
plot(-audio,'-')
findpeaks(-audio,'MinPeakDistance',10000,'SortStr','descend','MinPeakHeight',.15)
subplot(4,1,3)
plot(accel,'-')
findpeaks(accel,'MinPeakDistance',2,'SortStr','descend','MinPeakHeight',.020);
subplot(4,1,4)
plot(-accel,'-')
findpeaks(-accel,'MinPeakDistance',2,'SortStr','descend','MinPeakHeight',.020);
% PLOT PEAKS

[pks_audp,locs_audp]=findpeaks(audio,'MinPeakDistance',10000,'SortStr','descend','MinPeakHeight',.15);
[pks_audn,locs_audn]=findpeaks(-audio,'MinPeakDistance',10000,'SortStr','descend','MinPeakHeight',.15);
[pks_accp,locs_accp]=findpeaks(accel,'MinPeakDistance',2,'SortStr','descend','MinPeakHeight',.025);
[pks_accn,locs_accn]=findpeaks(-accel,'MinPeakDistance',2,'SortStr','descend','MinPeakHeight',.025);
% [pks_aud_rsp,locs_aud_rsp]=findpeaks(audio_rs,'MinPeakDistance',200,'SortStr','descend','MinPeakHeight',.05)
% [pks_aud_rsn,locs_aud_rsn]=findpeaks(-audio_rs,'MinPeakDistance',200,'SortStr','descend','MinPeakHeight',.05)
locs_audp_sort = sort(locs_audp);
locs_audn_sort = sort(locs_audn);
locs_accp_sort = sort(locs_accp);
locs_accn_sort = sort(locs_accn);

%% PLOT SIGNAL AND PEAKS ON TIME AXIS
% CONVERT X-AXIS TO TIME
t_aud = (1:length(audio))/fs;
t_acc_all = csvAccel{:,1}';
t_acc = t_acc_all(first_acc:last_acc);
% Plot
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
shift = -35.5; %guesstimate

figure %NO SHIFT
hold on
plot(t_aud,audio,'-')
plot(t_aud(locs_audp),pks_audp,'m*','MarkerSize',6)
plot(t_aud(locs_audn),-pks_audn,'k*','MarkerSize',6)
hold on
plot(t_acc+shift,accel+.25,'g-')
plot(t_acc(locs_accp)+shift,pks_accp+.25,'mo','MarkerSize',6)
plot(t_acc(locs_accn)+shift,-pks_accn+.25,'ko','MarkerSize',6)
ylabel('Pre-aligned')
%%
shift = [];
shift(1,1) = abs(t_aud(locs_audp_sort(3))-t_acc(locs_accp_sort(1)));
shift(2,1) = abs(t_aud(locs_audp_sort(4))-t_acc(locs_accp_sort(2)));
shift(3,1) = abs(t_aud(locs_audp_sort(7))-t_acc(locs_accp_sort(3)));
shift(4,1) = abs(t_aud(locs_audp_sort(10))-t_acc(locs_accp_sort(4)));
shift(5,1) = abs(t_aud(locs_audp_sort(11))-t_acc(locs_accp_sort(5)));
shift(1,2) = abs(t_aud(locs_audn_sort(5))-t_acc(locs_accn_sort(1)));
shift(2,2) = abs(t_aud(locs_audn_sort(6))-t_acc(locs_accn_sort(2)));
shift(3,2) = abs(t_aud(locs_audn_sort(8))-t_acc(locs_accn_sort(3)));
shift(4,2) = abs(t_aud(locs_audn_sort(9))-t_acc(locs_accn_sort(4)));
shift(5,2) = abs(t_aud(locs_audn_sort(13))-t_acc(locs_accn_sort(5)));
shift_avg = mean(shift(:));
shift_std = std(shift(:))/numel(shift(:));

%% PLOT ALIGNED SIGNALS
figure % SHIFTED
hold on
plot(t_aud+shift_avg,audio,'m-','LineWidth',1)
plot(t_aud(locs_audp)+shift_avg,pks_audp,'mo','MarkerSize',6)
plot(t_aud(locs_audn)+shift_avg,-pks_audn,'mo','MarkerSize',6)
plot(t_acc,accel,'-','LineWidth',1.5)
plot(t_acc(locs_accp),pks_accp,'bo','MarkerSize',6)
plot(t_acc(locs_accn),-pks_accn,'bo','MarkerSize',6)
ylabel('Aligned')
shift_avg
%%
% to bundle, would need to resample to the same sampling rate as the EEG













%% ALTERNATE METHOD OF ALIGNMENT
A = accel;
B = audio;
% Sampling frequencies
Fs_A = 30; 
Fs_B = 44100; 
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
X2 = [zeros(fs*1.2,1);X];
Y2(Y2<0) = 0;
% X2(X2<0) = 0;

figure()
hold on
plot(X2)
plot(Y2)
legend('accel','audio')
[Xa,Ya,D2] = alignsignals(X2,Y2,[],'truncate');
%%
figure() % plot both signals "aligned"
hold on
plot(Ya,'b-', 'LineWidth',1)
plot(Xa,'m-','LineWidth',1.5)
legend('audio','accel')

%%
figure
hold on
plot(Y,'-')
findpeaks(Y,'MinPeakDistance',10000,'SortStr','descend','MinPeakHeight',.15)
plot(-Y,'-')
findpeaks(-Y,'MinPeakDistance',10000,'SortStr','descend','MinPeakHeight',.15)
plot(Xa,'-')
findpeaks(Xa,'MinPeakDistance',10000,'SortStr','descend','MinPeakHeight',.03);
plot(-Xa,'-')
findpeaks(-Xa,'MinPeakDistance',10000,'SortStr','descend','MinPeakHeight',.03);
% legend('audio','audio_neg','accel','accel_neg')
