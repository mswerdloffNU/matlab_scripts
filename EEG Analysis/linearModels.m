%% create anova

%%
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2'

load('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\mean_amplitude_200_500_3678910121314.mat')

%%
p3 = [frame_avg_all_A(:) frame_avg_all_B(:) frame_avg_all_C(:)]
p3_comb = p3(:)
session = nominal([ones(1,27) ones(1,27)*2 ones(1,27)*3]');
subject = nominal([1:9 1:9 1:9 1:9 1:9 1:9 1:9 1:9 1:9]');
activity = nominal([ones(1,9) ones(1,9)*2 ones(1,9)*3 ones(1,9) ones(1,9)*2 ones(1,9)*3 ones(1,9) ones(1,9)*2 ones(1,9)*3]');

tbl = table(activity,p3_comb,subject,session,'VariableNames',{'Activity','Amplitude','Subject','Session'});
%tbl = table(X(:,12),X(:,14),X(:,24),'VariableNames',{'Horsepower','CityMPG','EngineType'});

lme1 = fitlme(tbl,'Amplitude~Activity*Session+(1|Subject)')
% shows a significant interation term for activity3*session3
anova(lme1)
% BUT interaction terms not significant

lme2 = fitlme(tbl,'Amplitude~Activity+Session+(1|Subject)') % take out interaction since it's not significant
anova(lme2) % shows activity is significant

%now do post-hoc tests to see whether activites are different


lm = fitlm(tbl,'Amplitude~Activity')