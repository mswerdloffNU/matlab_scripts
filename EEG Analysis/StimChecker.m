% stimuli checker

k_k = find(tbl_raw(8,1:end)); % Find indices of nonzero elements
% set the value of each stimulus label at each index

% for i = 1:numel(k_k) % for all k events
%     stimDSI=tbl_raw(8,k_k(i)); % replace the cell with the ith event with the type specified in the arduino list of tones
% end

for i = 1:numel(k_k)
    timeDSI(i,:) = Time(k_k(i));
end

sampDSI = [k_k(1) k_k(2:end) + 16];

for i = 1:numel(k_k)-1
    jj(i) = timeDSI(i+1)-timeDSI(i);
end

isiDSI = [jj]';

isiArd = [0;0;0;0;tonesAndTimes(2:2:end-1)];

for i = 1:numel(isiDSI)
    ramp_jitter(i,:) = (isiDSI(i)*1000)-isiArd(i)-100;
end

ramp_jitter_old = (isiDSI*1000)-isiArd-100;

isiLarge = find(ramp_jitter > 35.5);
isiLarge_pruned = isiLarge(5:end);

k = find(tbl_raw(8,2:end));

for i = 1:1
    tbl_raw(8,k(isiLarge_pruned(i))+1)=3;
end

tbl_raw(8,isiLarge(1))

zo = numel(isiArd)-5;
timezo = zeros(zo,1);
t1 = timeDSI(5)*1000;
t2 = t1+isiArd(5)+100+ramp_jitter(5);
timeEArd = [0 0 0 0 t1 t2 timezo']';
mean_ramp_jitter = mean(ramp_jitter(6:end-1));
for i = 6:numel(isiArd)-1
    timeEArd(i+1) = [timeEArd(i)+isiArd(i)+100+mean_ramp_jitter];
end
timeEstArd=timeEArd/1000;

timeLag = timeDSI-timeEstArd;

timeline=ones(numel(timeDSI),1);

clf
figure()
plot(timeDSI,timeline,'+','MarkerSize',20)
hold on
plot(timeEstArd,timeline,'+','MarkerSize',20)
xlim([40,100])
ylim([-0.5,0.5])