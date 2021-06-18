sprintf('hi!')

%% import accel
dataLines = [9, Inf]; % specify times and channels
[Time, Ax, Ay, Az, Seq] = importRawAccel(accelfile,dataLines); % import

%% import triggers
% specify times and channels
startRow = 17; % time = 0
endRow = inf; % time = end of trial
[Time_duration,LE,F4,C4,P4,P3,C3,F3,Trigger_duration,Time_Offset,ADC_Status,ADC_Sequence,Event,Comments] = importRaw(filename_duration, startRow, endRow); % import

tbl_raw_Accel = [Ax,Ay,Az,Trigger]'; % create tbl

%% Re-reference channels
    Pz_LE = -1*LE; % reference Pz to LE
    F4_LE = F4-LE; C4_LE = C4-LE; P4_LE = P4-LE; P3_LE = P3-LE; C3_LE = C3-LE; F3_LE = F3-LE; % reference all other channels to LE
    
%% move to EEGLAB
% cd(loc_eeglab)
% eeglab

