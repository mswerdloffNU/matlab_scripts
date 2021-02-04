clear

%% arduino generator
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\DSI_data\All'
% _manualFix
% filename_duration = 'Maggie_Walk_TTHigh_ArduinoRecording_10min_1sISI_v2_duration_manualFix_raw.csv';
filename_duration = uigetfile('*.csv','Select Duration File')
%% import file
% % specify times and channels
startRow = 17; % time = 0
endRow = inf; % time = end of trial
[Time_duration,LE,F4,C4,P4,P3,C3,F3,Trigger_duration,Time_Offset,ADC_Status,ADC_Sequence,Event,Comments] = importRaw(filename_duration, startRow, endRow); % import

vars = {'LE','F4','C4','P4','P3','C3','F3','Time_Offset','ADC_Status','ADC_Sequence','Event','Comments'};
clear(vars{:})

%% import non-duration file
Fsp = 300; % sampling rate in Hz
Fn = Fsp/2; % Nyquist frequency
% cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles'
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\DSI_data\All'
%filename = 'Maggie_Walk_TTHigh_ArduinoRecording_10min_1sISI_v2_manualFix_raw.csv';
filename = uigetfile('*.csv','Select Non-Duration File')

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
% cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles'
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting'
save(str_mat,'tbl_raw'); % save tbl of EEG data

%% import and separate Arduino SD tones

% import arduino SD tones
% cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles'
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\Arduino Tone Lists\All';
%%%%% _tones_and_times

fileID = fopen('Maggie_Walk_TTHigh_ArduinoRecording_10min_1sISI_tones_and_times.txt');
SD = textscan(fileID,'%f');
tonesAndTimes = SD{1};

% separate out the tones and times
tones = [240;3;3;3;tonesAndTimes(1:2:end)];
times = [0;0;0;0;tonesAndTimes(2:2:end)];
tttable = [times tones];

%% Arduino Stim Generator
% Find indices of nonzero elements
    k_k = find(tbl_raw(8,1:end)); 
% List times of all the DSI tones
    for i = 1:numel(k_k)
        timeDSI(i,:) = Time(k_k(i)); 
    end
% List samples corresponding to timeDSI
    % sampDSI = [k_k(1) k_k(2:end) + 16]; 
% List interstimulus intervals recorded by DSI
    for i = 1:numel(k_k)-1
        isiDSI(i,:) = timeDSI(i+1)-timeDSI(i); 
    end
% List interstimulus intervals recorded by Arduino
% Here you should subtract from the end however many extra tones did not actually get played (and consequently picked up by the DSI)
isiArd = [0;0;0;0;tonesAndTimes(2:2:numel(tonesAndTimes))]; 
% isiArd = [0;0;0;0;tonesAndTimes(2:2:numel(tonesAndTimes)-tonesExtra)]; 

% Calculate the differences between times that DSI picked up tones and when Arduino played them
% for i = 1:numel(isiDSI)
%     ramp_jitter(i,:) = (isiDSI(i)*1000)-isiArd(i)-100; 
% end

% Calculate the average difference between the time that the DSI picked up
% the tones and when the Arduino actually played them
mean_ramp_jitter = 19.5846;
% mean_ramp_jitter = mean(ramp_jitter(6:end-1));

%% Estimate the times that Arduino played the tones
% initialize using the first 5 times that the DSI picked up tones and zeros
    clear timeArd_all
    timeArd_all = [timeDSI(1:5);zeros(length(timeDSI)-6,1)]; 
% starting from the previous tone, add the isi, plus the ramp, plus the average jitter
    for i = 5:numel(isiArd)
        timeArd_all(i+1) = timeArd_all(i) + (isiArd(i)*0.001) + 0.1 + (mean_ramp_jitter*0.001); 
    end
    
%% Calculate the number of extra tones that the Arduino played but were not picked up by the DSI, or vice versa

% Find the last time that the DSI picked up a tone
    last_time = Time(k_k(end)); 
% Initialize 
    tonesExtra = 0;
% For every tone played by the Arduino, see if the time it was played is
% more than the last time picked up by the DSI; if it was, then count that
% one as an extra tone.
    for i = 1:numel(timeArd_all)
        if timeArd_all(i) > last_time
            tonesExtra = tonesExtra+1
        end
    end

%% plot DSI tones
% tonesExtra = 0; % open comment to plot all Arduino tones
% timeline=[1:(numel(Trigger))]';
clear timeArd
timeArd = timeArd_all(1:numel(timeArd_all)-tonesExtra);
timelineArd = ones(numel(timeArd),1)*8;
T_Ard=num2str(tones);
ToneCellsArd=cellstr(T_Ard);

% Plot what I intend to do
figure(1)
line(Time_duration,Trigger_duration,'LineWidth',1.2) % DSI tone pickups
ylim([-0.5,8.5])
hold on
plot(timeArd,timelineArd,'m+') % Arduino tones
%hold on
%text(timeArd,timelineArd,ToneCellsArd,'VerticalAlignment','bottom','HorizontalAlignment','right')

%% Actually set the stimuli
% Set the value of each stimulus label at each index that was picked up by
% the DSI hub.
tbl_raw(8,1)=240; % make sure the first cell is a 240
for i = 1:numel(k_k) % for all k_k events picked up by the DSI hub
    if i > numel(tttable(:,1))
        i = i+1;
    else
    tbl_raw(8,k_k(i))=tttable(i,2); % replace the cell with the ith event with the type specified in the arduino list of tones
    end
end
% for i = 1:numel(k_k) % for all k_k events picked up by the DSI hub
%    tbl_raw(8,k_k(i)+1)=tttable(i,2); % replace the cell with the ith event with the type specified in the arduino list of tones
% end

% % set the value of each stimulus label at each index
% for i = 1:numel(k) % for all k events
%     tbl_raw(8,k(i)+1)=tttable_new(i,2); % replace the cell with the ith event with the type specified in the arduino list of tones
% end
% Save
%cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting'
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting';
str_mat = strrep(filename,'_raw.csv','_raw.mat'); % table of EEG data (.mat)
save(str_mat,'tbl_raw'); % re-save raw table with updated event values

%% Check to see if I did it right
% % Find indices of nonzero elements
%     k_k = find(tbl_raw(8,1:end)); 
% % List times of all the DSI tones
%     for i = 1:numel(k_k) 
%         timeDSI(i,:) = Time(k_k(i)); 
%     end
% List tones corresponding to each DSItime
for i = 1:numel(k_k)
    toneDSI(i,:) = tbl_raw(8,k_k(i)); 
end

T_DSI=num2str(toneDSI);
ToneCellsDSI=cellstr(T_DSI);
timelineDSI = ones(numel(timeDSI),1)*8.5;

% Plot what I actually did
figure(2)
line(Time_duration,Trigger_duration,'LineWidth',1.2) % DSI tone pickups
ylim([-0.5,9])
hold on
plot(timeArd,timelineArd,'m+') % Arduino tones
hold on
text(timeArd,timelineArd,ToneCellsArd,'VerticalAlignment','bottom','HorizontalAlignment','right')
hold on
plot(timeDSI,timelineDSI,'+') % DSI tones
hold on
text(timeDSI,timelineDSI,ToneCellsDSI,'VerticalAlignment','bottom','HorizontalAlignment','right')

%% Check and plot tones
% tonesAndTimes_est = [timeArd tones];
% % tblArd = [timeArd tones];
% tblDSI = [Time(k_k) tbl_raw(8,k_k)'];
% %tones_tbl = [tonesAndTimes_est(:,2) tblDSI(:,2)];
% 
%     % Check tones for any errors
%     tbl_check = zeros(numel(tblDSI(:,2)),1);
%     for i = 1:numel(tonesAndTimes_est(:,2))
%         if tblDSI(:,2) == 4;
%             tbl_check(i) = 0;
%         elseif tblDSI(i,2) == 1 && tonesAndTimes_est(i,2) == 1
%             tbl_check(i) = 0;
%         elseif tblDSI(i,2) == 2 && tonesAndTimes_est(i,2) == 2
%             tbl_check(i) = 0;
%         elseif tblDSI(i,2) == 3 && tonesAndTimes_est(i,2) == 3
%             tbl_check(i) = 0;
%         elseif tblDSI(i,2) == 240 && tonesAndTimes_est(i,2) == 240;
%             tbl_check(i) = 0;
%         else
%             tbl_check(i) = 1;
%         end
%     end
%     errors = sum(tbl_check(:,1)) %% if there is an error, look at the tones_tbl to see where it is
