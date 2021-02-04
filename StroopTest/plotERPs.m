cd('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\Matlab scripts\StroopTest')

preStroop = importERP('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\Pilot2\Maggie_stroopStimuli_v2_unRand_adj_allEasy_v2_filt_a_b_2_allTrials_CatEq_ICA_Num_Target Non-Stroop .txt', 2, 301);

onsetStroop = importERP('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\Pilot2\Maggie_stroopStimuli_v2_unRand_adj_allEasy_v2_filt_a_b_2_allTrials_CatEq_ICA_Num_At Stroop Onset .txt', 2, 301);

postOnset1Stroop = importERP('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\Pilot\Maggie_stroopStimuli_v2_unRand_adj_allEasy_v2_filt_a_b_2_allTrials_CatEq_ICA_Num_After Stroop Onset.txt', 2, 301);

postOnset2Stroop = importERP('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\Pilot\Maggie_stroopStimuli_v2_unRand_adj_allEasy_v2_filt_a_b_2_allTrials_CatEq_ICA_Num_After Stroop Onset x 2.txt', 2, 301);

nonTargetStroop = importERP('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\Pilot\Maggie_stroopStimuli_v2_unRand_adj_allEasy_v2_filt_a_b_2_allTrials_CatEq_ICA_Num_Non-Target Stroop .txt', 2, 301);

nonTargetNonStroop = importERP('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\Pilot\Maggie_stroopStimuli_v2_unRand_adj_allEasy_v2_filt_a_b_2_allTrials_CatEq_ICA_Num_Non-Target Non-Stroop .txt', 2, 301);

targetNonStroop = importERP('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\Pilot\Maggie_stroopStimuli_v2_unRand_adj_allEasy_v2_filt_a_b_2_allTrials_CatEq_ICA_Num_Target Non-Stroop .txt', 2, 301);

congruentStroop = importERP('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\Pilot\Maggie_stroopStimuli_v2_unRand_adj_allEasy_v2_filt_a_b_2_allTrials_ICA_Num_Stroop Congruent.txt', 2, 301);

targetStroops = [table2array(preStroop(:,2)) table2array(onsetStroop(:,2)) table2array(postOnset1Stroop(:,2)) table2array(postOnset2Stroop(:,2))];

time = table2array(onsetStroop(:,1));
%%
figure
plot(time,mean(targetStroops,2),'r-')
hold on
plot(time,table2array(targetNonStroop(:,2)),'r:')
plot(time,table2array(nonTargetStroop(:,2)),'k-')
plot(time,table2array(nonTargetNonStroop(:,2)),'k:')
plot(time,table2array(congruentStroop(:,2)),'k-.')
line([0 0], [-15 20]);
line([-200 800], [0 0]);
xlabel('Time relative to stimuli (ms)')
ylabel('Potential (µV)')
xlim([-200 800])
legend('targetStroops', 'targetNonStroop', 'nonTargetStroop','nonTargetNonStroop','congruentStroop');
