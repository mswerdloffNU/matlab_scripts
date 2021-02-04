% load EEGLABS file
% load accelerometer data (Ax, Ay, Az) from excel files


%%
figure;
plot(EEG.times(1,1:5000),EEG.data(:,1:5000))
hold on
plot(EEG.times(1,1:5000),500*Ax(1:5000,1)-1000,EEG.times(1,1:5000),500*Ay(1:5000,1)-1000,EEG.times(1,1:5000),500*Az(1:5000,1)-1000)

%% decimate eeg data to match the sampling rate of the accel data
for i = 1:EEG.nbchan
    data(i,:) = decimate(double(EEG.data(i,:)),10);
end
times = EEG.times(1:10:end);

%% filter accelerometer datafilt
d = designfilt('lowpassfir', ...
    'PassbandFrequency',.05,'StopbandFrequency',.055, ...
    'PassbandRipple',1,'StopbandAttenuation',60, ...
    'DesignMethod','equiripple');
filtAx = filtfilt(d,Ax);
filtAy = filtfilt(d,Ay);
filtAz = filtfilt(d,Az);

%% plot events

% make eventlist into line  plot
events = zeros(1,length(EEG.data));
latency = [EEG.event.latency].';
type = [EEG.event.type].';

for i = 1:length(EEG.event)
    events(latency(i)) = type(i);
end

eventtimes = zeros(1,length(times));
b = 0;
for i = 1:length(EEG.times)
    if events(i) ~= 0 % take all trials
        b = b+1;
        eventtimes(b) = EEG.times(i);
    end
end

eventsDec = ones(1, length(eventtimes));

%% plot accel data with eeg data
figure;
plot(times(1,1:end),data)
hold on
plot(times(1,1:end),500*filtAx(1:end,1)-1000,times(1,1:end),500*filtAy(1:end,1)-1000,times(1,1:end),500*filtAz(1:end,1)-1500)
plot(eventtimes,eventsDec*60,'r+','MarkerSize',6)
