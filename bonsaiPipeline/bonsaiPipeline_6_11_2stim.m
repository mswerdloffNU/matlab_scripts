clear
close all
clc
%% arduino generator
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\DSI_data\All'
% cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\2_24_19'
%cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting3_05Hz_30Hz'
%cd 'D:\Other\transfer'
% _manualFix


filename_only = 'S005_v2_stand_walk_sit_C_0001.dsi';
filename_duration = strrep(filename_only,'.dsi','_duration_raw.csv');
location = strrep(filename_only,'.dsi','_raw.csv');
filename_tones = strrep(filename_only,'.dsi','.txt');
%filename_duration = 'Maggie_Treadmill_1sISI_375msjittter_preStandSit_v2_duration_raw.csv';
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
%cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting3_05Hz_30Hz'
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\DSI_data\All'
%cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\2_24_19'
%cd 'D:\Other\transfer'

%filename = 'Maggie_Treadmill_1sISI_375msjittter_preStandSit_v2_raw.csv';
%filename = 'Maggie_Sit_1sISI_375msjittter_preStand_raw.csv';
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
str_mat = strrep(location,'.csv','.mat'); % table of EEG data (.mat)
% str_ascii = strrep(filename,'.csv','.txt'); % table of EEG data (.txt)
str_events = strrep(location,'.csv',''); % table of events
str_events_csv = strrep(location,'.csv','_eventsMatlab.csv'); % table of events (.csv)

% % specify times and channels
startRow = 17; % time = 0
endRow = inf; % time = end of trial
[Time,LE,F4,C4,P4,P3,C3,F3,Trigger,Time_Offset,ADC_Status,ADC_Sequence,Event,Comments] = importRaw(location, startRow, endRow); % import

%% Re-reference channels
Pz_LE = -1*LE; % reference Pz to LE
F4_LE = F4-LE; C4_LE = C4-LE; P4_LE = P4-LE; P3_LE = P3-LE; C3_LE = C3-LE; F3_LE = F3-LE; % reference all other channels to LE

%% save raw EEG data
tbl_raw = [Pz_LE,F4_LE,C4_LE,P4_LE,P3_LE,C3_LE,F3_LE,Trigger]'; % create tbl
% cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting3_05Hz_30Hz'
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2'
%cd 'D:\Other\transfer\data'

save(str_mat,'tbl_raw'); % save tbl of EEG data

%% set initial Triggers to 240
Trigger_duration(1) = 240;
Trigger(1) = 240;

%% prob_checkR
tone_dataU = Trigger_duration;
start_timesU = Trigger;

tone_data = tone_dataU;
start_times = start_timesU;

tone_data(1) = 240;
start_times(1) = 240;
%start_times(xxxx) = 0;
%start_times(xxxx) = 0;

tone_times = linspace(1,numel(tone_data),numel(tone_data))';
figure()
line(tone_times, tone_data, 'LineWidth', 1.2)
ylim([4,12.5])
title('save beginning and end of tones')

pause
%% prob_checkR
tones_start = cursor_info1.DataIndex;
tones_end = cursor_info2.DataIndex;

%%
prompt1 = 'enter 1 to do prob_check): ';
go = input(prompt1);
%%
if go == 1
    % prob_checkR
    w_all = find(start_times);
    prob_check = zeros(numel(w_all),1);
    for i = tones_start:tones_end
        if start_times(i) == 8
            if tone_data(i+1) == 0;       prob_check(i) = 1;
            elseif tone_data(i+2) == 0;   prob_check(i) = 1;
            elseif tone_data(i+3) == 0;   prob_check(i) = 1;
            elseif tone_data(i+4) == 0;   prob_check(i) = 1;
            elseif tone_data(i+5) == 0;   prob_check(i) = 1;
            elseif tone_data(i+6) == 0;   prob_check(i) = 1;
            elseif tone_data(i+7) == 0;   prob_check(i) = 1;
            elseif tone_data(i+8) == 0;   prob_check(i) = 1;
            elseif tone_data(i+9) == 0;   prob_check(i) = 1;
            elseif tone_data(i+10) == 0;   prob_check(i) = 1;
            elseif tone_data(i+11) == 0;   prob_check(i) = 1;
            elseif tone_data(i+12) == 0;   prob_check(i) = 1;
            elseif tone_data(i+13) == 0;   prob_check(i) = 1;
            elseif tone_data(i+14) == 0;   prob_check(i) = 1;
            elseif tone_data(i+15) == 0;   prob_check(i) = 1;
            elseif tone_data(i+16) == 0;   prob_check(i) = 1;
            elseif tone_data(i+17) == 0;   prob_check(i) = 1;
            elseif tone_data(i+18) == 0;   prob_check(i) = 1;
            elseif tone_data(i+19) == 0;   prob_check(i) = 1;
            elseif tone_data(i+20) == 0;   prob_check(i) = 1;
            elseif tone_data(i+21) == 0;   prob_check(i) = 1;
            elseif tone_data(i+22) == 0;   prob_check(i) = 1;
            elseif tone_data(i+23) == 0;   prob_check(i) = 1;
            elseif tone_data(i+24) == 0;   prob_check(i) = 1;
            elseif tone_data(i+25) == 0;   prob_check(i) = 1;
                %         elseif tone_data(i+26) == 0;   prob_check(i) = 1;
                %         elseif tone_data(i+27) == 0;   prob_check(i) = 1;
                %         elseif tone_data(i+28) == 0;   prob_check(i) = 1;
                %        elseif tone_data(i+29) == 0;   prob_check(i) = 1;
                %        elseif tone_data(i+30) == 0;   prob_check(i) = 1;
            else
                prob_check(i) = 0;
            end
        end
    end
    w = find(prob_check == 1);
    numel(w)
    prob_check_errors = ones(numel(w),1);
end
go = 0;

%% prob_checkR
prompt1 = 'enter 1 to do prob_check): ';
go = input(prompt1);
if go == 1
    cd 'C:\Users\mswerdloff\Documents\MATLAB'
    for i = 1:numel(w)
        figure_check = line(tone_times, tone_data, 'LineWidth', 1.2);
        ylim([4,12.5])
        xlim_min = w(i)-500;
        xlim_max = w(i)+500;
        xlim([xlim_min,xlim_max])
        makedatatip(figure_check,[w(i) 8])
        prompt = 'Enter 0 to delete or 1 to keep: ';
        i
        prob_check_errors(i) = input(prompt);
        cla
    end
    
    %% prob_checkR
    ers = find(prob_check_errors);
    numel(find(prob_check_errors ~= 1))
    
    Trigger_old = Trigger;
    for i = 1:numel(prob_check_errors)
        if prob_check_errors(i) == 0
            Trigger(w(i)) = 0;
        end
    end
    
    % figure()
    % line(tone_times, tone_data, 'LineWidth', 1.2)
    % ylim([4,12.5])
    % hold on
    % plot(tone_times,Trigger,'k+')
    
    numel(find(Trigger))
end
go = 0;
%% Move up triggers
% Trigger_early = Trigger;
% for i = 3:(numel(w_all))-p
%     Trigger_early((w_all(i))-2) = 8;
%     Trigger_early(w_all(i)) = 0;
% end
% 
% figure()
% line(tone_times, tone_data, 'LineWidth', 1.2)
% ylim([4,12.5])
% hold on
% plot(tone_times,Trigger_early,'+')

%% plot DSI tones to determine # of tones before start (n)
prompt1 = 'enter 1 to continue): ';
go = input(prompt1);

figure()
line(Time_duration,Trigger_duration,'LineWidth',1.2)
ylim([-0.5,8.5])

prompt2 = 'specify n (number of triggers at the beginning + 2): ';
n = input(prompt2);
prompt3 = 'specify m (number of triggers cut off or not picked up entirely by the Hub): ';
m = input(prompt3);
prompt4 = 'specify p (number of triggers at the end): ';
p = input(prompt4);
%% number of accidental tones picked up by DSI before actual arduino tones started (normally n = 4);
% n = 5; % n = 2 + number of tones before start
% m = 0; % number of tones cut off or not picked up entirely by Hub
% p = 27; % number of tones played by arduino after the end of the trial
%% import and separate Arduino SD tones
% import arduino SD tones
% cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\2_24_19\Arduino Tone Lists\All'
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\Arduino Tone Lists\All';
%cd 'D:\Other\transfer'

%%%%% _tones_and_times
fileID = fopen(filename_tones);
%fileID = fopen('Maggie_Treadmill_1sISI_375msjittter_preStandSit_v2.txt');
SD = textscan(fileID,'%f');
tonesAndTimes = SD{1};
%tonesAndTimes = zeros(length(tonesAndTimes),1);
% separate out the tones and times
if n == 2
 tones = [240;tonesAndTimes(560:2:end-1)];
 times = [0;tonesAndTimes(561:2:end-1)];
 isiArd = [0;tonesAndTimes(561:2:numel(tonesAndTimes))];
elseif n == 3
 tones = [240;4;tonesAndTimes(2:2:end-1)];
 times = [0;0;tonesAndTimes(3:2:end-1)];
 isiArd = [0;0;tonesAndTimes(3:2:numel(tonesAndTimes))];
elseif n == 4
 tones = [240;4;4;tonesAndTimes(2:2:end-1)];
 times = [0;0;0;tonesAndTimes(3:2:end-1)];
 isiArd = [0;0;0;tonesAndTimes(3:2:numel(tonesAndTimes))];
elseif n == 5
 tones = [240;4;4;4;tonesAndTimes(2:2:end-1)];
 times = [0;0;0;0;tonesAndTimes(3:2:end-1)];
 isiArd = [0;0;0;0;tonesAndTimes(3:2:numel(tonesAndTimes))];
elseif n == 6
 tones = [240;4;4;4;4;tonesAndTimes(2:2:end-1)];
 times = [0;0;0;0;0;tonesAndTimes(3:2:end-1)];
 isiArd = [0;0;0;0;0;tonesAndTimes(3:2:numel(tonesAndTimes))];
else 
 string4_n = 4*ones(n,1);
 string0_n = zeros(n+1,1);
 tones = [240;string4_n;tonesAndTimes(2:2:end-1)];
 times = [string0_n;tonesAndTimes(3:2:end-1)];
 isiArd = [string0_n;tonesAndTimes(3:2:numel(tonesAndTimes))];
end

% tones = [240;4;tonesAndTimes(2:2:970);4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;tonesAndTimes(1032:2:end-1)];
% times = [0;0;tonesAndTimes(3:2:971);0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;tonesAndTimes(1033:2:end-1)];
% tones1 = [240;4;tonesAndTimes(2:2:970)];
% tones2 = [tonesAndTimes(1032:2:end-1)];
% times1 = [0;0;tonesAndTimes(3:2:971);
% times2 = [tonesAndTimes(1033:2:end-1)];
tttable = [times tones];
%tttable = [times(2:end) tones(2:end)];

%% Arduino Stim Generator
tbl_raw(8,:) = Trigger';
% Find indices of nonzero elements
    k_k = find(tbl_raw(8,1:end)); 
%      k_ka = k_k(1:485); 
%       k_kb = k_k(487:end); 
% List times of all the DSI tones
    for i = 1:numel(k_k)
        timeDSI(i,:) = Time(k_k(i)); 
    end
%         for i = 1:numel(k_ka)
%         timeDSIa(i,:) = Time(k_ka(i)); 
%         end
%         for i = 1:numel(k_kb)
%         timeDSIb(i,:) = Time(k_kb(i)); 
%         end
%     
% List samples corresponding to timeDSI
    % sampDSI = [k_k(1) k_k(2:end) + 16]; 
% List interstimulus intervals recorded by DSI
    for i = 1:numel(k_k)-1
        isiDSI(i,:) = timeDSI(i+1)-timeDSI(i); 
    end
%         for i = 1:numel(k_ka)-1
%         isiDSIa(i,:) = timeDSIa(i+1)-timeDSIa(i); 
%         end
%         for i = 1:numel(k_kb)-1
%         isiDSIb(i,:) = timeDSIb(i+1)-timeDSIb(i); 
%         end
  
% List interstimulus intervals recorded by Arduino
% Here you should subtract from the end however many extra tones did not
% actually get played (and consequently picked up by the DSI)
%isiArd = [0;0;0;0;tonesAndTimes(3:2:numel(tonesAndTimes))];
%isiArd = [0;0;tonesAndTimes(3:2:971);0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;tonesAndTimes(1033:2:end-1)];
%isiArd1 = [0;0;tonesAndTimes(3:2:971)];
%isiArd2 = [0;tonesAndTimes(1033:2:end-1)];
% isiArd = [0;0;0;0;tonesAndTimes(2:2:numel(tonesAndTimes)-tonesExtra)]; 

% Calculate the average difference between the time that the DSI picked up
% the tones and when the Arduino actually played them
mean_ramp_jitter = 19.5846; 
% mean_ramp_jitter = 17.9678;
%mean_ramp_jitter = 18.7; % in microseconds

%% for missing DSI data only
% Trigger(find(Time == cursor_info.Position(1))) % check to make sure this is 8
% Trigger_est = find(Trigger ~= 0)';
% 
% %TimeDSI_est = [Trigger_est zeros(1,(numel(tones)-numel(Trigger_est)))]';
% TimeDSI_est = [timeDSI' zeros(1,(numel(tones)-numel(timeDSI)))]';
% TimeDSI_est(n) = TimeDSI_est(n-2)+(1462/300);
% 
% for i = n:numel(tones)
%     TimeDSI_est(i+1) = TimeDSI_est(i) + (mean_ramp_jitter*.001) + 0.1 + (isiArd(i)*.001);
% end
% 
% Trigger_est2 = zeros(numel(Trigger),1);
% for i = 1:numel(TimeDSI_est)
%     a = round(TimeDSI_est(i)*300);
%     Trigger_est2(a) = 8; 
% end


%% Estimate the times that Arduino played the tones
% initialize using the first 4 times that the DSI picked up tones and zeros
    clear timeArd_all timeArd_alla timeArd_allb
%     n=5;
    timeArd_all = [timeDSI(1:n);zeros(length(timeDSI)-n,1)]; 
%         timeArd_alla = [timeDSIa(1:n);zeros(length(timeDSIa)-n,1)]; 
%             timeArd_allb = [timeDSIb(2);zeros(length(timeDSIb)-3,1)]; 
    %timeArd_all = zeros(numel(isiArd),1);
% starting from the previous tone, add the isi, plus the ramp, plus the average jitter
    for i = n:numel(isiArd)
        timeArd_all(i+1) = timeArd_all(i) + (isiArd(i)*0.001) + 0.1 + (mean_ramp_jitter*0.001); 
    end
%     for i = n:numel(isiArd1)
%         timeArd_alla(i+1) = timeArd_alla(i) + (isiArd1(i)*0.001) + 0.1 + (mean_ramp_jitter*0.001); 
%     end
%         for i = 1:numel(isiArd2)
%         timeArd_allb(i+1) = timeArd_allb(i) + (isiArd2(i)*0.001) + 0.1 + (mean_ramp_jitter*0.001); 
%     end
%     timeArd_all = [timeArd_alla;timeArd_allb];
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
            tonesExtra = tonesExtra+1;
        end
    end
    
%% plot DSI tones
%tonesExtra = 0; % uncomment to plot all Arduino tones
timeline=[1:(numel(Trigger))]';
timeArd = timeArd_all(1:numel(timeArd_all)-tonesExtra);
timeline2 = ones(numel(timeArd),1)*8.02;

% 
figure()
line(Time_duration,Trigger_duration,'LineWidth',1.2)
ylim([-0.5,8.5])
hold on
plot(timeArd,timeline2,'m+')
title('Times may not align exactly')

prompt1 = 'enter 1 to continue): ';
go = input(prompt1);
%%
%Calculate the differences between times that DSI picked up tones and when Arduino played them
close figure 3
if n == 3 && m == 0 && p == 0
    for i = 1:numel(isiArd)-m-1
    ramp_jitter(i,:) = (isiDSI(i)*1000)-isiArd(i)-100; 
    end
else
    for i = 1:numel(isiArd)-m
    ramp_jitter(i,:) = (isiDSI(i)*1000)-isiArd(i)-100; 
    end
end
%%
 mean_ramp_jitter = mean(ramp_jitter(n+1:end-1));% mean_ramp_jitter = mean(ramp_jitter(n+1:end-1));% mean_ramp_jitter = mean(ramp_jitter(n+1:end-1));% mean_ramp_jitter = mean(ramp_jitter(n+1:end-1));% mean_ramp_jitter = mean(ramp_jitter(n+1:end-1));% mean_ramp_jitter = mean(ramp_jitter(n+1:end-1));

 % clear ramp_jitter_a
% for i = 1:485
%     ramp_jitter_a(i,:) = (isiDSI(i)*1000)-isiArd(i)-100; 
% end
% clear ramp_jitter_b
% for i = 621:901
%     ramp_jitter_b(i,:) = (isiDSI(i-30)*1000)-isiArd(i)-100; 
% end
% mean_ramp_jitter2 = mean([ramp_jitter_a(3:485); ramp_jitter_b(621:end-1)]);

% Estimate the times that Arduino played the tones

% initialize using the first 5 times that the DSI picked up tones and zeros
    clear timeArd_all
    timeArd_all = [timeDSI(1:n);zeros(length(timeDSI)-n,1)]; 
    %timeArd_all = zeros(numel(isiArd),1);
% starting from the previous tone, add the isi, plus the ramp, plus the average jitter
    for i = n:numel(isiArd)
        timeArd_all(i+1) = timeArd_all(i) + (isiArd(i)*0.001) + 0.1 + (mean_ramp_jitter*0.001); 
    end

%%
% Calculate the number of extra tones that the Arduino played but were not picked up by the DSI, or vice versa

% Find the last time that the DSI picked up a tone
    %last_time = Time(k_k(end)); 
      last_times = find(timeArd_all == 0);
      if p > 0
      last_time = timeArd_all(last_times(1)-1); %use if there are extra
%      tones picked up at the end after the actual arduino tones ended
      else
      last_time = timeArd_all(numel(timeArd_all)); %use if there are no tones picked up by the Hub after the actual tones ended
      end
      % Initialize 
    tonesExtra = 0;
% For every tone played by the Arduino, see if the time it was played is
% more than the last time picked up by the DSI; if it was, then count that
% one as an extra tone.
    for i = 1:numel(timeDSI)
        if timeDSI(i) > last_time
            tonesExtra = tonesExtra+1;
        end
    end
    
% plot DSI tones
% tonesExtra = 0; % uncomment to plot all Arduino tones
% timeline=[1:(numel(Trigger))]';
timeArd = timeArd_all(1:numel(timeArd_all)-tonesExtra);
timeline2 = ones(numel(timeArd),1)*8;


figure()
line(Time_duration,Trigger_duration,'LineWidth',1.2)
ylim([-0.5,8.5])
hold on
plot(timeArd,timeline2,'m+')
title('Check to make sure times align exactly')

prompt1 = 'enter 1 to continue): ';
go = input(prompt1);
close figure 1
%% decide what to do with tone
if p > 0
    tonelabels = num2str(tones); % use if there are tones at the end
elseif p == 0
    tones_new = [tones;0]; %uncomment if there are less tone labels than tones
    %picked up by DSI (this could happen if the Arduino is turned off before it
    %records the tone name)
    tonelabels = num2str(tones_new); % uncomment if necessary according to the
    %previous comment
% elseif numel(timeDSI) > numel(tones)
%     q = numel(timeDSI)-numel(tones);
%     string0_q = zeros(q,1);
%     tones_new = [tones;string0_q]; %uncomment if there are less tone labels than tones
%     %picked up by DSI (this could happen if the Arduino is turned off before it
%     %records the tone name)
%     tonelabels = num2str(tones_new); % uncomment if necessary according to the
%     %previous comment
end
% timeline2a = ones(numel(timeArd),1)*8.05;
% tonenumbers = num2str(linspace(1,903,903)');
%
figure()
line(Time_duration,Trigger_duration,'LineWidth',1.2)
ylim([-0.5,8.5])
hold on
plot(timeArd,timeline2,'m+')
text(timeArd,timeline2,tonelabels)
title('check that the tones numbers are correct')
%text(timeArd,timeline2a,tonenumbers)

prompt1 = 'enter 1 to continue): ';
go = input(prompt1);
close figure 1
%% set the value of each stimulus label at each index
% tbl_raw(8,:) = Trigger_early';
tbl_raw_old = tbl_raw;
stim = tbl_raw(8,:);
%stim = Trigger_est2;
%k_k = find(Trigger_est2);
k_k2 = k_k(1:numel(tones)-m);
k3 = numel(k_k2)+1;
% use the one below if there are extra tones at the end
if p > 0
    for i = 1:numel(k_k2) % for all k events
        stim(k_k2(i))=tttable(i,2); % replace the cell with the ith event with the type specified in the arduino list of tones
    end
elseif p == 0
    % use this one below if there are no extra tones at the end
    for i = 1:numel(k_k2) % for all k events
        stim(k_k2(i))=tttable(i,2); % replace the cell with the ith event with the type specified in the arduino list of tones
    end
end
for i = k3:numel(k_k)
    stim(k_k(i))=0;
end
% k_k=find(stim);
% for i = 1:486 % for all k events
%     stim(k_k(i))=tttable(i,2); % replace the cell with the ith event with the type specified in the arduino list of tones
% end
% for i = 487:numel(k_k)
%     stim(k_k(i))=tttable(i+30,2);
% end
% stim(175508)=4;

% for i = 1:numel(k_k2) % for all k events
%     tbl_raw(8,k_k2(i))=tttable(i,2); % replace the cell with the ith event with the type specified in the arduino list of tones
% end

%% for stimulus splitting only
% stim_Start2back = find(Event(2:end) ~= 0);
% stim_2back = [zeros(1,stim_Start2back-1) stim(stim_Start2back:end)];
% stim_baseline = [stim(1:stim_Start2back-1) zeros(1,numel(stim(stim_Start2back:end)))];

% stim = stim_baseline; 
% stim = stim_2back;

% tbl_raw(8,:) = stim;
% cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz'
% %cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting3_05Hz_30Hz'
% str_mat = strrep(filename,'_raw.csv','_baseline_raw.mat'); % table of EEG data (.mat)
% save(str_mat,'tbl_raw'); % re-save raw table with updated event values
% 

% tbl_raw(8,:) = stim;
% cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz'
% %cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting3_05Hz_30Hz'
% str_mat = strrep(filename,'_raw.csv','_2back_raw.mat'); % table of EEG data (.mat)
% save(str_mat,'tbl_raw'); % re-save raw table with updated event values

%%
tbl_raw(8,:) = stim;
 cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2'
%cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting3_05Hz_30Hz'
%cd 'D:\Other\transfer\data'

str_mat = strrep(location,'_raw.csv','_raw.mat'); % table of EEG data (.mat)
save(str_mat,'tbl_raw'); % re-save raw table with updated event values

%% equalize the number of target and nontarget trials
%SECTION ERASED -- DO THIS IN EEGLAB AVERAGER

%% plot to check everything is aligned
tbl_raw_alltrials = tbl_raw;
tonesDSI = tbl_raw_alltrials(8,k_k)';
timeline3 = ones(numel(timeDSI),1)*8.1;
tonelabelsDSI = num2str(tonesDSI);
% timeDSIearly = Time(find(stim));
% timeline4 = ones(numel(timeDSIearly),1)*8.05;
figure()
line(Time_duration,Trigger_duration,'LineWidth',1.2)
ylim([7.8,8.2])
hold on
grid on
plot(timeArd,timeline2,'m+')
text(timeArd,timeline2,tonelabels)
plot(timeDSI,timeline3,'+')
text(timeDSI,timeline3,tonelabelsDSI)
% plot(tone_times/300,Trigger,'g+')
% text(timeDSIearly,timeline4,tonelabelsDSI)
% pause
% xlim([38,48]) % zoom in on random spot on x-axis
% ylim([7.97,8.15]) 
prompt1 = 'enter 1 to continue): ';
go = input(prompt1);
close figure 1

%% remove DC bias
for i = 1:size(tbl_raw,1)-1
tbl_detrend(i,:) = tbl_raw(i,:)-mean(tbl_raw(i,:));
end

%% filter data
% create butterworth bandpass filters
[b1,a1] = butter(1,[0.5 30]/Fn);
[b2,a2] = butter(2,[0.5 30]/Fn);
[b4,a4] = butter(4,[0.5 30]/Fn);
% % visualize butterworth filters
% h1 = fvtool(b1,a1);
% h2 = fvtool(b2,a2);
% h4 = fvtool(b4,a4);
% figure()
% freqz(b1,a1,256,300)
% figure()
% freqz(b2,a2,256,300)
% figure()
% freqz(b4,a4,256,300)

% % other methods of creating filters
% % % [A,B,C,D] = butter(4,[0.1 30]/Fn); %4th order butterworth ** trouble
% % using with filtfilt
% d = designfilt('bandpassiir','FilterOrder',4, ...
%     'HalfPowerFrequency1',0.1,'HalfPowerFrequency2',30, ...
%     'SampleRate',Fsp); %identical 4th order
% sos = ss2sos(A,B,C,D);
% fvt = fvtool(sos,d,'Fs',Fsp);
% legend(fvt,'butter','designfilt')

% apply filtfilt
tbl_filt_a_b_1 = filtfilt(b1,a1,tbl_detrend(1:7,:)');
tbl_filt_a_b_2 = filtfilt(b2,a2,tbl_detrend(1:7,:)');
tbl_filt_a_b_4 = filtfilt(b4,a4,tbl_detrend(1:7,:)');

tbl_filt_a_b_1r = filtfilt(b1,a1,tbl_raw(1:7,:)'); % r = raw
tbl_filt_a_b_2r = filtfilt(b2,a2,tbl_raw(1:7,:)'); % r = raw
tbl_filt_a_b_4r = filtfilt(b4,a4,tbl_raw(1:7,:)'); % r = raw

% transpose back to OG form, and add events back in (tr = transposed)
tbl_filt_a_b_1_tr = [tbl_filt_a_b_1'; stim];
tbl_filt_a_b_2_tr = [tbl_filt_a_b_2'; stim];
tbl_filt_a_b_4_tr = [tbl_filt_a_b_4'; stim];

tbl_filt_a_b_1_tr_r = [tbl_filt_a_b_1r'; stim];
tbl_filt_a_b_2_tr_r = [tbl_filt_a_b_2r'; stim];
tbl_filt_a_b_4_tr_r = [tbl_filt_a_b_4r'; stim];

%% Plot data

% Plot the Frequency spectrum of each channel
N = length(tbl_raw); % number of points in the signal
% Junk:
% % % % for i = 1:size((tbl_raw),1)-1
% % % %     X_raw(i,:)=tbl_raw(i,:);
% % % % end
% % % % X1_mags_raw=X_raw(1,:);X2_mags=X_raw(2,:);X3_mags=X_raw(3,:);X4_mags=X_raw(4,:);X5_mags=X_raw(5,:);X6_mags=X_raw(6,:);X7_mags=X_raw(7,:);
% % % % X1=fftshift(fft(tbl_raw(1,:)));X2=fftshift(fft(tbl_raw(2,:)));X3=fftshift(fft(tbl_raw(3,:)));X4=fftshift(fft(tbl_raw(4,:)));X5=fftshift(fft(tbl_raw(5,:)));X6=fftshift(fft(tbl_raw(6,:)));X7=fftshift(fft(tbl_raw(7,:)));
X(i,:)=fftshift(fft(tbl_raw(1,:)));
% dF = Fsp/N;                      % Hz
% f = -Fsp/2:dF:Fsp/2-dF;           % Hz
% for i = 1:size((tbl_raw),1)-1
%     X(i,:) = fftshift(fft(tbl_filt_a_b_1_tr(i,:)));
%     x(i,:) = abs(X(i,:))/N;
%     figure(i)
%     plot(f,x(i,:),'-');
%     xlim([0 75])
%     ylim([0 1])
%     xlabel('Frequency (Hz)');
%     title('Magnitude Response');
% end

% Plot all raw unfiltered data
figure()
hold on
for i = 1:7
   plot(tbl_raw(i,:)+200*(1-i))
end
hold off
grid on
legend('Pz','F4','C4','P4','P3','C3','F3')
title('Raw data, stacked, referenced to LE')
savefig('Raw data_stacked_referenced to LE.fig')

% Plot all detrended data
figure()
hold on
for i = 1:7
    plot(tbl_detrend(i,:)+200*(1-i))
end
hold off
grid on
legend('Pz','F4','C4','P4','P3','C3','F3')
title('Detrended data, stacked, referenced to LE')
savefig('Detrended data_stacked_referenced to LE.fig')

% Plot all filtered data
figure()
hold on
for i = 1:7
    plot(tbl_filt_a_b_1_tr(i,:)+200*(1-i))
end
hold off
grid on
legend('Pz','F4','C4','P4','P3','C3','F3')
title('Filtered data, stacked, referenced to LE')
savefig('Filtered data_stacked_referenced to LE.fig')

% Plot filtered data and raw on same axes
figure()
r = plot([tbl_raw(1,4000:6000)' tbl_detrend(1,4000:6000)']);
legend('raw data','detrended data')
figure()
f = plot([tbl_filt_a_b_1r(4000:6000,1) tbl_filt_a_b_2r(4000:6000,1) tbl_filt_a_b_4r(4000:6000,1) tbl_filt_a_b_1(4000:6000,1) tbl_filt_a_b_2(4000:6000,1) tbl_filt_a_b_4(4000:6000,1)]);
title('Butterworth bandpass filtered data (0.5-30 Hz) implemented using filtfilt')
legend('4th order','8th order','16th order','4th order detrended','8th order detrended','16th order detrended')
xlabel('Samples')
ylabel('Potential (uV)')
savefig('Butterworth bandpass filtered data.fig')

%% save filtered EEG data
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2'
% cd 'D:\Other\transfer\data'
%cd 'C:\Users\maggi\Google Drive\Shared Drives\Northwestern\LeviHargroveLab\pipelinematlabfiles\Troubleshooting3_05Hz_30Hz'
str_mat = strrep(location,'_raw.csv','_filt_a_b_1_allTrials.mat'); % table of EEG data (.mat)
save(str_mat,'tbl_filt_a_b_1_tr'); % save b,a butter -> filtfilt filtered data
str_mat = strrep(location,'_raw.csv','_filt_a_b_2_allTrials.mat'); % table of EEG data (.mat)
save(str_mat,'tbl_filt_a_b_2_tr'); % save b,a butter -> filtfilt filtered data
str_mat = strrep(location,'_raw.csv','_filt_a_b_4_allTrials.mat'); % table of EEG data (.mat)
save(str_mat,'tbl_filt_a_b_4_tr'); % save b,a butter -> filtfilt filtered data

% str_mat = strrep(filename,'_raw.csv','_filt_a_b_1_baseline.mat'); % table of EEG data (.mat)
% save(str_mat,'tbl_filt_a_b_1_tr'); % save b,a butter -> filtfilt filtered data
% str_mat = strrep(filename,'_raw.csv','_filt_a_b_2_baseline.mat'); % table of EEG data (.mat)
% save(str_mat,'tbl_filt_a_b_2_tr'); % save b,a butter -> filtfilt filtered data
% str_mat = strrep(filename,'_raw.csv','_filt_a_b_4_baseline.mat'); % table of EEG data (.mat)
% save(str_mat,'tbl_filt_a_b_4_tr'); % save b,a butter -> filtfilt filtered data

% cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz'
% str_mat = strrep(filename,'_raw.csv','_filt_a_b_1_2back.mat'); % table of EEG data (.mat)
% save(str_mat,'tbl_filt_a_b_1_tr'); % save b,a butter -> filtfilt filtered data
% str_mat = strrep(filename,'_raw.csv','_filt_a_b_2_2back.mat'); % table of EEG data (.mat)
% save(str_mat,'tbl_filt_a_b_2_tr'); % save b,a butter -> filtfilt filtered data
% str_mat = strrep(filename,'_raw.csv','_filt_a_b_4_2back.mat'); % table of EEG data (.mat)
% save(str_mat,'tbl_filt_a_b_4_tr'); % save b,a butter -> filtfilt filtered data
