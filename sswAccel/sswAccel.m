sprintf('hi!')

%% specify source files
sub = 'S014';
loc_sub = strcat('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\',sub);

loc_sit = strcat(loc_sub,'\sit'); % source folder
loc_stand = strrep(loc_sit,'sit','stand');
loc_walk = strrep(loc_sit,'sit','walk');

cd(loc_sit)
files_all = strcat(sub,'*filt_a_b_2_allTrials.mat');
Files_sit = dir(files_all); 
for k=1:length(Files_sit) 
    Files_sit(k).condition = 'sit';
end
files_sit = struct2table(Files_sit);

cd(loc_stand)
files_all = strcat(sub,'*filt_a_b_2_allTrials.mat');
Files_stand = dir(files_all); 
for k=1:length(Files_stand) 
    Files_stand(k).condition = 'stand';
end
files_stand = struct2table(Files_stand);

cd(loc_walk)
files_all = strcat(sub,'*filt_a_b_2_allTrials.mat');
Files_walk = dir(files_all);
for k=1:length(Files_walk) 
    Files_walk(k).condition = 'walk';
end
files_walk = struct2table(Files_walk);

Files_all = table2struct([files_sit; files_stand; files_walk]);
if length(Files_all) > 9
    pause
end

for k = 1:length(Files_all)
    filename = Files_all(k).name;
    if strfind(filename,'A')
        Files_all(k).session = 'A';
    elseif strfind(filename,'B')
        Files_all(k).session = 'B';
    elseif strfind(filename,'C')
        Files_all(k).session = 'C';
    end
end

T = struct2table(Files_all);
T2 = sortrows(T,'condition');
aa_t(1:3,:) = sortrows(T2(1:3,:),'session');
bb_t(1:3,:) = sortrows(T2(4:6,:),'session');
cc_t(1:3,:) = sortrows(T2(7:9,:),'session');

merge_t = [aa_t;bb_t;cc_t];
Files = table2struct(merge_t);

%% specify destination folders
loc_dest = strrep(loc_sub,'Pilot2','Pilot2_withAccel');

loc_sit_dest = strcat(loc_dest,'\sit'); % source folder
loc_stand_dest = strrep(loc_dest,'sit','stand');
loc_walk_dest = strrep(loc_dest,'sit','walk');

%% import files
for k=1:length(Files)
    filename=Files(k).name % file to be converted
        if k == 1 || k == 2 || k ==3
        location2 = loc_sit_dest;
    elseif k == 4 || k == 5 || k == 6
        location2 = loc_stand_dest;
    elseif k == 7 || k == 8 || k == 9
        location2 = loc_walk_dest;
    end
    
    setNum = k;
    
%% import eeg time from dsi
addpath('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\DSI_data\All')
filename_csv = strrep(filename,'filt_a_b_2_allTrials.mat','raw.csv');

startRow = 17; % time = 0
endRow = inf; % time = end of trial
[Time_csv] = importRaw(filename_csv, startRow, endRow); % import

%% import eeg table
addpath(loc_sit)
eeg_struct = open(filename);
eeg_table = [Time_dsi, eeg_struct.tbl_filt_a_b_2_tr(8,:)'];

%% import accel
dataLines = [9, Inf]; % specify times and channels
[Time_accel, Ax, Ay, Az, Seq] = importRawAccel(accelfile,dataLines); % import

%% combined table
trigs = find(eeg_table(:,2));

% try to find matching times
for ii = 1:numel(trigs)
    trigTime(ii) = find(Time_accel==Time_dsi(trigs(ii),1))
end

% resample
Ax_300 = resample(Ax(1:end),10,1);
figure
hold on
plot([1:10:length(Ax_300)],Ax,'o')
plot([1:length(Ax_300)],Ax_300(1:end),'.')
% how do I know that that's good? ^

accel_table = [Time_accel,zeros(length(Time_accel),1)];
% choose nearest value
for ii = 1:length(trigs)
    n=Time_dsi(trigs(ii));
    idx=abs(Time_accel-n);
    [~,minidx] = min(idx);
    minVal(ii)=Time_accel(minidx);
    if eeg_table(trigs(ii),2) == 0
        pause
    else
        accel_table(minidx,2) = eeg_table(trigs(ii),2);
    end
end
end
%% create table
tbl_raw_Accel = [Ax,Ay,Az,Trigger]'; % create tbl
%% Re-reference channels
Pz_LE = -1*LE; % reference Pz to LE
F4_LE = F4-LE; C4_LE = C4-LE; P4_LE = P4-LE; P3_LE = P3-LE; C3_LE = C3-LE; F3_LE = F3-LE; % reference all other channels to LE

%% move to EEGLAB
% cd(loc_eeglab)
% eeglab

