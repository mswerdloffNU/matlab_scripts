%%
tbl_raw = tbl_raw_walk;
% Fn = 300;
% stim = tbl_raw(8,:);
%     for i = 1:size(tbl_raw,1)-1
%         tbl_detrend(i,:) = tbl_raw(i,:)-mean(tbl_raw(i,:));
%     end
% [b2,a2] = butter(2,[0.5 30]/Fn);
% tbl_filt_a_b_2 = filtfilt(b2,a2,tbl_detrend(1:7,:)');
% tbl_filt_a_b_2_tr = [tbl_filt_a_b_2'; stim];
% data = tbl_filt_a_b_2_tr(1,:);
% clear tbl_detrend tbl_filt_a_b_2 tbl_filt_a_b_2_tr data

%%
data = tbl_raw(1,:);

% figure;
% spectrogram(data,256,250,256,300,'yaxis')
% ylim([0 90]);
% colormap(winter);
% brighten(-0.7);
% title('S003-Sit-A')

[d,f,t]=spectrogram(data,256,250,256,300,'yaxis'); % x(data),window(number of windows),noverlap(number of samples of overlab),f(frequencies),fs(sampling rate)
d_real=real(d);

AlphaRange = mean(d_real((7:11),:),1);
Smoothed_AlphaRange=smooth((abs(AlphaRange)),250,'moving');
BetaRange = mean(d_real((12:25),:),1);
Smoothed_BetaRange=smooth((abs(BetaRange)),250,'moving');
UpperBetaRange = mean(d_real((22:35),:),1);
Smoothed_UpperBetaRange=smooth((abs(UpperBetaRange)),250,'moving');
ThetaRange = mean(d_real((4:7),:),1);
Smoothed_ThetaRange = smooth((abs(ThetaRange)),250,'moving');


%%
figure;
subplot(2,2,1)
plot(t/60,Smoothed_AlphaRange,'k:');
hold on
xlim([0 max(t/60)]);
ylim([0 150]);
plot(t/60,Smoothed_BetaRange,'b-');
plot(t/60,Smoothed_UpperBetaRange,'b:');
plot(t/60,Smoothed_ThetaRange,'k-');
legend('alpha power','beta power','upper beta power','theta power');
title('S003-Sit-A')

subplot(2,2,2)
plot(t/60,Smoothed_AlphaRange,'k:');
hold on
xlim([0 max(t/60)]);
ylim([0 150]);
plot(t/60,Smoothed_BetaRange,'b-');
plot(t/60,Smoothed_UpperBetaRange,'b:');
plot(t/60,Smoothed_ThetaRange,'k-');
legend('alpha power','beta power','upper beta power','theta power');


