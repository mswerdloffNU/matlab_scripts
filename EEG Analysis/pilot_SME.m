%% move to EEGLAB folder
cd 'C:\Users\mswerdloff\eeglab14_1_2b'

% open new set
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% [ERP ALLERP] = pop_loaderp( 'filename', {'erpset_S014_sit_walk_stand_B_0001_filt_a_b_2_allTrials_eq9_ICA_Num.erp',...
%  'erpset_S014_sit_walk_stand_B_0002_filt_a_b_2_allTrials_eq9_ICA_Num.erp', 'erpset_S014_sit_walk_stand_B_filt_a_b_2_allTrials_eq9_ICA_Num.erp',...
%  'erpset_S014_stand_sit_walk_A_0001_filt_a_b_2_allTrials_eq9_ICA_Num.erp', 'erpset_S014_stand_sit_walk_A_0002_filt_a_b_2_allTrials_eq9_ICA_Num.erp',...
%  'erpset_S014_stand_sit_walk_A_filt_a_b_2_allTrials_eq9_ICA_Num.erp', 'erpset_S014_walk_stand_sit_C_0001_filt_a_b_2_allTrials_eq9_ICA_Num.erp',...
%  'erpset_S014_walk_stand_sit_C_0002_filt_a_b_2_allTrials_eq9_ICA_Num.erp', 'erpset_S014_walk_stand_sit_C_filt_a_b_2_allTrials_eq9_ICA_Num.erp'}, 'filepath',...
%  'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S014\redoEq9_avg\' );

EEG = pop_loadset('filename','S007_walk_stand_sit_A_0002_filt_a_b_2_allTrials_eq9_ICA_elist_bins_be.set','filepath','Z:\\Lab Member folders\\Margaret Swerdloff\\EEG_gait\\EEG\\Matlab_data\\Pilot2\\S007\\sit\\');
[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );