% reviewer suggestions
comment1 = 'Consider comparing across subjects' ;
% Can't do that since there's only one point per condition per subject.
% Could try to do a single-trial basis but that's beyond the scope of this
% study.

comment2 = 'How did/can you compensate for artifacts due to dry EEG or movement?' ;
% Check to see if they correlate with noisy trials
% Make sure the walking trials are not rife with movement artifacts except
% in isolated cases where trials were rejected.
% -> Plot the acceleromoeter data to see if it correlates to walking and not
% to sitting, and if it correlates to noisy (rejected) trials.

comment3 = 'Time and sweat influences could have affected the results.';
% Check on the correlations of these.
% Time: could not find any literature on the degradation of signal over
% time for dry eeg. For wet eeg, this may occur if the gel dries out. With
% dry eeg, it is not clear how the signal could be affected over time
% except for the occurance of sweat.
% Sweat: normal to light sweat artifacts create a low frequency artifact,
% which is removed by high pass filtering. Sweat artifacts were not seen 
% in the data. Heavy or excessive sweat can
% create cross-bridges between electrodes. Subjects did not have heavy or
% excessive sweat and no cross-bridges were found in the data. 

comment4 = 'The presence of noise from the treadmill may affect the task performance';
% The treadmill was kept on throughout all sessions, even when subjects
% were not walking on it.

comment5 = 'Use a rank test of Wilcoxon (if N >= 20?)'
% This did change the p-value for the only significant difference we found,
% from 0.007 to 0.0117.

%% Answering C2 first
% plot walk and sit Accel
figure;
subplot(2,1,1);
plot(S007_A_Walk_Accel(:,1),S007_A_Walk_Accel(:,2:4));
title('Walk')
subplot(2,1,2);
plot(S007_A_Sit_Accel(:,1),S007_A_Sit_Accel(:,2:4));
title('Sit')
%% plot their frequency specta
walk_z= abs(fft(S007_A_Walk_Accel(:,4)));
sit_z = abs(fft(S007_A_Sit_Accel(:,4)));

figure
% subplot(1,2,1);
plot(walk_z);
% ylim([0 10])
xlabel('DFT Bins')
ylabel('Magnitude')
% subplot(1,2,2);
figure
plot(sit_z);
xlabel('DFT Bins')
ylabel('Magnitude')

%% 
nb_walk_z = length(walk_z);
nb_sit_z = length(sit_z);
figure
plot([0:1/(nb_walk_z/2 -1):1],walk_z(1:nb_walk_z/2))
xlabel('Normalized frequency (\pi rads/sample)')
ylabel('Magnitude')
%% apply 10th order low pass filter at 15 hz
[b a] = butter(4,[1/150 10/150]);
% % plot the frequency response
% figure
% H = freqz(b,a,floor(nb_walk_z/2));
% hold on
% plot([0:1/(nb_walk_z/2 -1):1],abs(H),'r');
% filter the signal using the b and a coefficients obtained from the butter
% filter design function
walk_x_filtered = filter(b,a,S007_A_Walk_Accel(:,2));
sit_x_filtered = filter(b,a,S007_A_Sit_Accel(:,2));

walk_y_filtered = filter(b,a,S007_A_Walk_Accel(:,3));
sit_y_filtered = filter(b,a,S007_A_Sit_Accel(:,3));

walk_z_filtered = filter(b,a,S007_A_Walk_Accel(:,4));
sit_z_filtered = filter(b,a,S007_A_Sit_Accel(:,4));
% plot the filtered signal
figure
subplot(211)
plot(walk_x_filtered)
hold on
plot(walk_y_filtered)
plot(walk_z_filtered)
title('Walking- Filtered Signal Using 10th Order Butterworth')
xlabel('Samples');
ylabel('Amplitude');
legend x y z
subplot(212)
plot(sit_x_filtered)
hold on
plot(sit_y_filtered)
plot(sit_z_filtered)
legend x y z
title('Sitting- Filtered Signal Using 10th Order Butterworth')
xlabel('Samples');
ylabel('Amplitude');
