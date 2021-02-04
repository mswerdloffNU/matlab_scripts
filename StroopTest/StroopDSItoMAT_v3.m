%% load files

clearvars
numEasy=7;
% load dsi csv file
% cd('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\DSI_data\StroopAudio')
folder = 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\DSI_data\StroopAudio\';
filename_alone = 'Maggie_stroopStimuli_v2_unRand_adj_allEasy_v5_S015_duration_raw.csv'; %'Maggie_stroopStimuli_v2_unRand_adj_allEasy_v4_AB00_raw.csv' %'MaggieStroopAudio1_0001_duration_raw.csv';
filename_duration = strcat(folder,filename_alone);
folder = 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\Pilot';
folder_save = 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\Pilot\troubleshooting_mean20';

% specify times and channels
startRow = 17; % time = 0
endRow = inf; % time = end of trial
[Time_duration,LE,F4,C4,P4,P3,C3,F3,Trigger_duration,Time_Offset,ADC_Status,ADC_Sequence,Event,Comments] = importRaw(filename_duration, startRow, endRow); % import

% load stroop test results
stroop_data = 'S015_Test3unRand_adj_Easy_v5.mat'; %'AB00_Test1 - MMS data.mat';
data_loc = strcat('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\StroopTestResults\Troubleshooting\',stroop_data);
data = load('-mat', data_loc);

folder = folder_save;

% % plot stimuli
% 
% figure()
% plot(Trigger_duration)

%% label stimuli: 
% Trigger_duration(1) = 0;

for ii = 1:length(Trigger_duration);
    if Trigger_duration(ii) == 1 % no word, no sound
        word(ii,1) = 0;
        tone(ii,1) = 0;
    elseif Trigger_duration(ii) == 8 % sound and word
        word(ii,1) = 1;
        tone(ii,1) = 1;
    elseif Trigger_duration(ii) == 9 % sound only
        word(ii,1) = 0;
        tone(ii,1) = 1;
    elseif Trigger_duration(ii) == 0 % word only
        word(ii,1) = 1;
        tone(ii,1) = 0;
    else
        disp(ii)
        sprintf('what is happening here?')
    end
end


%%
figure
subplot(211)
plot(word)
ylabel('word')
subplot(212)
plot(tone)
ylabel('tone')

%% determine when prov tones occur

clear td out datecell stroopDurations

% plot stroop words
for jj = 1:2
    for ii = 1:length(data.Prov)
        datecell(ii,:,1) = data.Prov{1,ii}.timeStart; % Prov stroop start time
        datecell(ii,:,2) = data.Prov{1,ii}.timeEnd; % Prov stroop end time
        td(ii,1,jj) = duration(datecell(ii,4:6,jj)); %,'inputformat','[yyyy-MM-dd HH:mm:ss.SSS');
        % time lapse between prov stroop starts and stops
    end
end

stroopDurations = milliseconds(td(:,:,2)-td(:,:,1)); % time lapse between prov stroop starts and stops, in ms
stroopStarts(:,1) = milliseconds(td(:,:,2)-(duration(data.Easy{1,1}.timeStart(4:6)))); %time stroop ended minus time first stroop started
stroopStarts2(:,1) = milliseconds(td(:,:,1)-(duration(data.Easy{1,1}.timeStart(4:6)))); %time each stroop started minus time first stroop started
%%
% plot nonProvstroop words
for kk = 1:numEasy
    for jj = 1:2
        for ii = 1:length(data.Easy)
            clear datecell_Easy1
            datecell_Easy1(ii,:,1) = data.Easy{kk,ii}.timeStart; % stroop start time
            datecell_Easy1(ii,:,2) = data.Easy{kk,ii}.timeEnd; % stroop end time
            td_Easy1(ii,jj,kk) = duration(datecell_Easy1(ii,4:6,jj)); %,'inputformat','[yyyy-MM-dd HH:mm:ss.SSS');
            % time lapse between nonprov stroop starts and stops
        end
    end
end
stroopDurations_Easy1 = milliseconds(td_Easy1(:,2,:)-td_Easy1(:,1,:)); % time lapse between prov stroop starts and stops, in ms
clear datecell_Easy2
for kk = 1:numEasy-1
    for jj = 1:2
        for ii = 1:length(data.Easy)
            clear datecell_Easy2
            datecell_Easy2(ii,:,1) = data.Easy{kk,ii}.timeEnd; % stroop start time
            datecell_Easy2(ii,:,2) = data.Easy{kk+1,ii}.timeStart; % stroop end time
            td_Easy2(ii,jj,kk) = duration(datecell_Easy2(ii,4:6,jj)); %,'inputformat','[yyyy-MM-dd HH:mm:ss.SSS');
            % time lapse between nonprov stroop starts and stops
        end
    end
end
stroopDurations_Easy2 = milliseconds(td_Easy2(:,2,:)-td_Easy2(:,1,:)); % time lapse between prov stroop starts and stops, in ms

stroopDurations_Easy = squeeze(stroopDurations_Easy1(:,:,1:end-1) + stroopDurations_Easy2);

sD_Easy = stroopDurations_Easy(:);

for ii = 1:numel(sD_Easy)
    if sD_Easy(ii) > 3700
        sD_Easy_2(ii) = 0;
    else
        sD_Easy_2(ii) = sD_Easy(ii);
    end
end
[mean(nonzeros(sD_Easy_2)) std(nonzeros(sD_Easy_2))]
figure; histogram(nonzeros(sD_Easy_2))
pd = fitdist(nonzeros(sD_Easy_2),'Normal')

%% find index of strooop starts and stops

wordOn = find(word==1);
for ii = 1:length(stroopDurations)
%     idxSStart(ii) = wordOn(2)+(300*stroopStarts(ii)/1000)-450; % idx of prov stroop start
    idxSStart2(ii) = wordOn(1) + (300*stroopStarts2(ii)/1000);
    idxSEnd(ii) = idxSStart2(ii)+(300*stroopDurations(ii)/1000); % idx of prov stroop end
    idxTStart(ii) = idxSStart2(ii)+(300*data.timingError{ii,1}); % idx of prov tone start
end

for ii = 1:length(tone)-1
    if tone(ii) == 0 && tone(ii+1) == 1
        toneOn(ii+1) = ii+1;
    end
end
idxTonesOn = find(toneOn);

% toneOnMAT(1) = idxTonesOn(1);
% for ii = 2:length(idxTonesOn)
%     toneOnMAT(ii) = toneOnMAT(ii-1) + 'sensor time duration'; 
% end

for ii = 1:length(word)-1
    if word(ii) == 0 && word(ii+1) == 1
        wordOnset(ii+1) = ii+1;
    end
end
idxWordsOn = find(wordOnset);
    
for ii = 1:length(word)-1
    if word(ii) == 1 && word(ii+1) == 0
        wordOffset(ii+1) = ii+1;
    end
end
idxWordsOff = find(wordOffset);

%%
clear audioTarget
audioTarget(1) = idxTonesOn(8);
for ii = 1:numel(idxTonesOn)
audioTarget(ii+1) = idxTonesOn(8+(ii*31))
end
%%
clear stroopTarget
stroopTarget(1) = idxTonesOn(24);
for ii = 1:numel(idxTonesOn)
stroopTarget(ii+1) = idxTonesOn(24+(ii*31))
end
%% for S015 (no light sensor data at all)
clear nonStroopTarget nonStroopTarget_num nonStroopTarget_numz
for ii = 1:31:620
nonStroopTarget_num(ii,:) = [ii+16:1:ii+16+14];
end
%
nonStroopTarget_numz = nonzeros(nonStroopTarget_num');
for ii = 1:numel(nonStroopTarget_numz)
    nonStroopTarget(ii,1)=idxTonesOn(nonStroopTarget_numz(ii));
end
% 
for ii = 1:20
    nonStroopTarget(8+((ii-1)*15))=0;
end
numel(find(nonStroopTarget(1:300)==0)) % there should be 20 since the 0s are are just the stroop targets
%
clear nonStroopTarget_only
nonStroopTarget_only = nonzeros(nonStroopTarget);
% combine all indices lists
clear listComb
listComb = union(nonStroopTarget_only,(union(stroopTarget, audioTarget)));
% find audioNonTargets
clear audioNonTargets
audioNonTargets = setdiff(idxTonesOn,listComb);
numel(audioNonTargets) % this should be 300
% assign labels
% eg. for each idx found in audioNonTargets, assign a 1 to that column
clear idxTonesOn_lbl ToneLabel
idxTonesOn_lbl = Event;
for ii = 1:numel(audioNonTargets)
    idxTonesOn_lbl(audioNonTargets(ii),2)=5;
end
for ii = 1:numel(nonStroopTarget_only)
    idxTonesOn_lbl(nonStroopTarget_only(ii),2)=6; % (Stroop non-targets)
end
for ii = 1:numel(stroopTarget)
    idxTonesOn_lbl(stroopTarget(ii),2)=1;
    idxTonesOn_lbl(audioTarget(ii),2)=7;
end
ToneLabel = nonzeros(idxTonesOn_lbl(:,2));
numel(find(ToneLabel))
% idxTonesOn_lbl2 = nonzeros(idxTonesOn_lbl(:,2)); % should have 620 nonzero entries
%%
wordDurations = idxWordsOff-idxWordsOn;
figure;plot(wordDurations,'.')
wordToWordDelay = idxWordsOn(2:end)-idxWordsOn(1:end-1);
figure;plot(wordToWordDelay,'.')

%%
% idxWordsOn(1) = 0;
% idxWordsOn(2) = 0;
% idxWordsOn(13) = 0;
% idxWordsOn(28) = 0;

idxWordsOn_only = nonzeros(idxWordsOn);

%%
figure
plot(word)
ylabel('word')
hold on 
plot(idxTonesOn,ones(1,numel(idxTonesOn)),'b*')
plot(idxWordsOn_only,ones(1,numel(idxWordsOn_only)),'k*')
plot(idxWordsOff,ones(1,numel(idxWordsOff)),'ko')
plot(idxSEnd,ones(1,20),'k+')
plot(idxTStart,ones(1,20),'g*')
plot(idxSStart2,ones(1,20),'m+')
plot(audioTarget,ones(1,20),'mo')
plot(stroopTarget,ones(1,20),'go')
ylim([.95 1.05])

%%
% figure
% plot(word)
% ylabel('word')
% hold on 
% plot(idxTonesOn,ones(1,numel(idxTonesOn)),'b*')
% % plot(idxWordsOn_only,ones(1,numel(idxWordsOn_only)),'k*')
% % plot(idxWordsOff,ones(1,numel(idxWordsOff)),'ko')
% % plot(idxSEnd,ones(1,20),'k+')
% % plot(idxTStart,ones(1,20),'g*')
% % plot(idxSStart2,ones(1,20),'m+')
% plot(audioTarget,ones(1,20),'mo')
% plot(stroopTarget,ones(1,20),'go')
% ylim([.95 1.05])

%% determine difference between blue and black stars and whether they match the expected delays
% difference between blue and black
% for every black star, find how far the nearest blue one is.
clear nearestProvTones idxNearestProvTones nearestProvTone idxNearestProvTone
for kk = 1:length(idxSStart2)
    for ii = 1:length(idxWordsOn_only)
        [nearestProvTones(ii,kk), idxNearestProvTones(ii,kk)] = min(abs(idxSStart2(kk)-idxWordsOn_only(ii)));
    end
end

[nearestProvTone idxNearestProvTone] = min(nearestProvTones);

for ii = 1:length(idxSStart2)
    valNearestProvTone(ii) = idxWordsOn_only(idxNearestProvTone(ii));
end

%%
figure
plot(word)
ylabel('word')
hold on 
plot(idxSStart2,ones(1,20),'m+') % when the Prov word should have started
plot(idxSEnd,ones(1,20),'k+') % approx when the Prov word should have started ended
plot(idxTStart,ones(1,20),'g*') % when matlab thinks the tone started
plot(idxTonesOn,ones(1,numel(idxTonesOn)),'b*') % tone detected by Trigger Hub
plot(idxWordsOn_only,ones(1,numel(idxWordsOn_only)),'k*') % word detected by Trigger Hub
plot(valNearestProvTone,ones(1,numel(valNearestProvTone)),'m*') % when the prov word started, as detected by the Trigger Hub
% xlim([1.5E4 3E4])
% xlim([2.195E4 2.26E4])
ylim([-.15 1.15])

%% find the difference
clear nearestProvToneOn idxNearestProvToneOn nearestProvTonOn idxNearestProvToneOn
for kk = 1:length(valNearestProvTone)
    for ii = 1:length(idxTonesOn)
%         [nearestProvToneOn(ii,kk), idxNearestProvToneOn(ii,kk)] = min(abs(valNearestProvTone(kk)-idxTonesOn(ii)));
 [nearestProvToneOn(ii,kk)] = abs(valNearestProvTone(kk)-idxTonesOn(ii));
    end
end

clear valNearestProvToneOn nearestProvToneOnMin idxNearestProvToneOnMin
[nearestProvToneOnMin, idxNearestProvToneOnMin] = min(nearestProvToneOn);
for ii = 1:length(idxNearestProvToneOnMin)
    valNearestProvToneOn(ii) = idxTonesOn(idxNearestProvToneOnMin(ii));
end

% determine whether each tone was before or after prov as expected, in
% milliseconds
clear diffNearestProvToneOn
for ii = 1:length(idxNearestProvToneOnMin)
    diffNearestProvToneOn(ii,:) = (valNearestProvTone(ii)-idxTonesOn(idxNearestProvToneOnMin(ii))).*-10/3;
end
x=ones(1,20);
figure;plot(valNearestProvTone,x,'k*');hold on; plot(valNearestProvToneOn,x,'b*');
c = [(valNearestProvTone') valNearestProvToneOn' (valNearestProvTone'-valNearestProvToneOn')*10/3];
% note idxSStart (m+) is based on the Stroop test start time based on the
% computer timing; valNearestProvTone (m*) is based on the trigger hub onset of
% Stroop
x = 70.5:.01:71; clear y_mean
for ii = 1:numel(x)
    y = data.timingError{:,1}*1000-diffNearestProvToneOn+x(ii);
    y_mean(ii) = mean(y);
end
[idx_x yy] = min(abs(y_mean)  )
xx = x(yy);

% compareTHtoML = table(data.timingError{:,2}*1000,(data.timingError{:,1}*1000), diffNearestProvToneOn,xx+(data.timingError{:,1}*1000-diffNearestProvToneOn), data.timingError{:,2}*1000-(data.timingError{:,1}*1000),(data.timingError{:,2}*1000-diffNearestProvToneOn)); % cols: [target matlab TH matlab-TH target-matlab]
% compareTHtoML = table(data.timingError{:,2}*1000,(data.timingError{:,1}*1000), diffNearestProvToneOn,(data.timingError{:,1}*1000-diffNearestProvToneOn), data.timingError{:,2}*1000-(data.timingError{:,1}*1000),(data.timingError{:,2}*1000-diffNearestProvToneOn)); % cols: [target matlab TH matlab-TH target-matlab]
% compareTHtoML.Properties.VariableNames ={'Target','Matlab','TriggerHub','Matlab_minus_TriggerHub','Target_minus_Matlab','Target_minus_TriggerHub'};

compareTHtoML = table(data.timingError{:,2}*1000,(data.timingError{:,1}*1000), diffNearestProvToneOn,(data.timingError{:,1}*1000-diffNearestProvToneOn), data.timingError{:,2}*1000-(data.timingError{:,1}*1000),(data.timingError{:,2}*1000-diffNearestProvToneOn)); % cols: [target matlab TH matlab-TH target-matlab]
compareTHtoML.Properties.VariableNames ={'Target','Matlab','TriggerHub','Matlab_minus_TriggerHub','Target_minus_Matlab','Target_minus_TriggerHub'};

%% take out black stars if they have pink ones

clear stars idxWordsOn_only2
idxWordsOn_only2 = idxWordsOn_only;
for ii = 1:length(idxWordsOn_only2)
    for kk = 1:length(valNearestProvTone)
        if idxWordsOn(ii) == valNearestProvTone(kk) % if there are no pink stars at that location
            idxWordsOn_only2(ii) = 0; % black stars go to 0
        end
    end
end
idxWordsOn_only2 = nonzeros(idxWordsOn_only2); % new black stars

%% find the difference between each black and blue star (words and tones detected by the TH)
clear absValnonProv minValnonProv idxMinValnonProv
for ii = 1:length(idxWordsOn_only)
    for kk = 1:length(idxTonesOn)
        absValnonProv(ii,kk) = abs(idxTonesOn(kk)-idxWordsOn_only(ii));
        [minValnonProv(ii) idxMinValnonProv(ii)] = min(absValnonProv(ii,:));
    end
end

clear nearestToneNonProv
for ii = 1:length(idxMinValnonProv)
    nearestToneNonProv(ii) = idxTonesOn(idxMinValnonProv(ii));
end

%% find the difference between each magenta and blue star (words and tones detected by the TH) and choose the closest blue star

clear absValProv minValProv idxMinValProv
for ii = 1:length(valNearestProvTone)
    for kk = 1:length(idxTonesOn)
        absValProv(ii,kk) = abs(idxTonesOn(kk)-valNearestProvTone(ii));
        [minValProv(ii) idxMinValProv(ii)] = min(absValProv(ii,:));
    end
end

clear nearestToneProv
for ii = 1:length(idxMinValProv)
    nearestToneProv(ii) = idxTonesOn(idxMinValProv(ii));
end


%% take out blue stars if they have magenta circles

clear stars idxTonesOn_only
idxTonesOn_only = idxTonesOn;
for ii = 1:length(idxTonesOn)
    for kk = 1:length(audioTarget)
        if idxTonesOn(ii) == audioTarget(kk) % if there are no pink stars at that location
            idxTonesOn_only(ii) = 0; % black stars go to 0
        end
    end
end
idxTonesOn_only = nonzeros(idxTonesOn_only); % new black stars

%%
figure
plot(word)
ylabel('word')
hold on 
plot(idxSStart2,ones(1,20),'m+') % when the Prov word should have started
plot(idxSEnd,ones(1,20),'k+') % approx when the Prov word should have started ended
% plot(idxTStart,ones(1,20),'g*') % when matlab thinks the tone started
plot(idxTonesOn_only,ones(1,numel(idxTonesOn_only)),'b*') % tone detected by Trigger Hub
plot(idxWordsOn_only,ones(1,numel(idxWordsOn_only)),'k*') % word detected by Trigger Hub (idxWordOn but only the nonProv)
plot(valNearestProvTone,ones(1,numel(valNearestProvTone)),'m*') % when the prov word started, as detected by the Trigger Hub
plot(nearestToneNonProv,ones(1,numel(nearestToneNonProv)),'c*') % nearest nonProv tone
plot(nearestToneProv,ones(1,numel(nearestToneProv)),'g*') % nearest Prov tone as detected by the Trigger Hub
plot(audioTarget,ones(1,20),'mo')
plot(stroopTarget,ones(1,20),'bo')
% xlim([1.5E4 3E4])
% xlim([2.195E4 2.26E4])
ylim([-.15 1.15])


%% find difference
clear delayNonProvWordToTone
for ii = 1:length(nearestToneNonProv)
    delayNonProvWordToTone(ii) = (nearestToneNonProv(ii)-idxWordsOn_only(ii)).*1000/300;
end
mean(delayNonProvWordToTone)
std(delayNonProvWordToTone)

%% Label Tones

ToneLabel = zeros(length(Event),1);
for ii = 1:length(idxTonesOn_only)
    ToneLabel(idxTonesOn_only(ii)) = 3; % non-stroop non-target (blue star)
end
for ii = 1:length(nearestToneNonProv)
    ToneLabel(nearestToneNonProv(ii)) = 2; % stroop non-target (cyan star)
end
for ii = 1:length(nearestToneProv)
    ToneLabel(nearestToneProv(ii)) = 1; % stroop target (green star)
end
% for ii = 1:length(audioTarget)
%     ToneLabel(audioTarget(ii)) = 4; % non-stroop target (magenta circle)
% end

numel(find(ToneLabel==4))

%%
toneToWordDelay = idxWordsOn_only'-nearestToneNonProv(1:end); %cyan star to black star)
toneToWordDelay(8:15:end) = 0;
toneToWordDelay = nonzeros(toneToWordDelay);
figure;plot(toneToWordDelay,'.')
[mean(toneToWordDelay)*1000/300 std(toneToWordDelay)*1000/(300*sqrt(numel(toneToWordDelay)))]

allDev = abs(toneToWordDelay-mean(toneToWordDelay));
mean(allDev)*1000/300
figure;histogram(toneToWordDelay,200)

for ii = 1:numel(toneToWordDelay)
    if toneToWordDelay(ii) < 200
        toneToWordDelay_2(ii) = 0;
    else
        toneToWordDelay_2(ii) = toneToWordDelay(ii);
    end
end
[mean(nonzeros(toneToWordDelay_2))*10/3 std(nonzeros(toneToWordDelay_2))*10/3]
figure; histogram(nonzeros(toneToWordDelay_2)*10/3)
toneToWordDelay_2NZ = nonzeros(toneToWordDelay_2)*10/3;pd = fitdist(toneToWordDelay_2NZ ,'Normal')
%%
toneToToneDelay = idxTonesOn_only(2:end)-idxTonesOn_only(1:end-1); %(blue star to blue star) (nonprov tone to nonprovtone)
toneToToneDelay(toneToToneDelay > 600) = 0; %
toneToToneDelay = nonzeros(toneToToneDelay);
figure;plot(toneToToneDelay,'.-')
[mean(toneToToneDelay)*1000/300 std(toneToToneDelay)*1000/(300*sqrt(numel(toneToToneDelay)))]

allDev = abs(toneToToneDelay-mean(toneToToneDelay));
mean(allDev)*1000/300
figure;histogram(toneToToneDelay,200)

for ii = 1:numel(toneToToneDelay)
    if toneToToneDelay(ii) < 530
        toneToToneDelay_2(ii) = 0;
    else
        toneToToneDelay_2(ii) = toneToToneDelay(ii);
    end
end
[mean(nonzeros(toneToToneDelay_2))*10/3 std(nonzeros(toneToToneDelay_2))*10/3]
figure; histogram(nonzeros(toneToToneDelay_2)*10/3)
toneToToneDelay_2NZ = nonzeros(toneToToneDelay_2)*10/3;pd = fitdist(toneToToneDelay_2NZ ,'Normal')

%% black star to black star
nonStroopToNonStroop = idxWordsOn_only(2:end)-idxWordsOn_only(1:end-1); %(black star to black star) (nonprov stroop to nonprov stroop)
nonStroopToNonStroop(nonStroopToNonStroop > 1200) = 0; %
nonStroopToNonStroop(nonStroopToNonStroop < 1038) = 0; %
nonStroopToNonStroop = nonzeros(nonStroopToNonStroop);
figure;plot(nonStroopToNonStroop,'.-')

figure; histogram(nonStroopToNonStroop*10/3)
nonStroopToNonStroop_2NZ = nonStroopToNonStroop*10/3;pd = fitdist(nonStroopToNonStroop_2NZ ,'Normal')
%% same as above
% wordToWordDelay_sub = wordToWordDelay;
% wordToWordDelay_sub(wordToWordDelay_sub > 8000) = 0; %
% wordToWordDelay_sub(wordToWordDelay_sub < 700) = 0; %
% wordToWordDelay_sub = nonzeros(wordToWordDelay_sub);
% figure;plot(wordToWordDelay_sub,'.-')
% [mean(wordToWordDelay_sub)*1000/300 std(wordToWordDelay_sub)*1000/(300*sqrt(numel(wordToWordDelay_sub)))]
% 
% allDev = abs(wordToWordDelay_sub-mean(wordToWordDelay_sub));
% mean(allDev)*1000/300
% figure;histogram(wordToWordDelay_sub,200)
% 
% sum(nonStroopToNonStroop-wordToWordDelay_sub)
%%
% toneLabelName = strrep(filename_alone,'.csv','_ToneLabel.txt');
cd(folder)
toneLabel = strrep(stroop_data,'.mat','_ToneLabel.txt');
dlmwrite(toneLabel,ToneLabel,'delimiter','\t','newline','pc');

%%
% toneCategory = zeros(length(nearestToneProv),1);
toneCategory = zeros(length(stroopTarget),1);
timingError = table2array(data.timingError(:,2));
for ii = 1:length(toneCategory)
    if timingError(ii) < 0
        toneCategory(ii) = 1;
    elseif timingError(ii) == 0
        toneCategory(ii) = 2;
    elseif timingError(ii) > 0
        if timingError(ii) < .1
            toneCategory(ii) = 3;
        elseif timingError(ii) > .1
            toneCategory(ii) = 4;
        end
    end
end

%%
ToneLabelCat = zeros(length(Event),1);
for ii = 1:length(idxTonesOn_only)
    ToneLabelCat(idxTonesOn_only(ii)) = 5; % audio non-targets (blue star)
end
for ii = 1:length(nearestToneNonProv)
    ToneLabelCat(nearestToneNonProv(ii)) = 6; % stroop non-target (cyan star)
end
% for ii = 1:length(audioTarget)
%     ToneLabelCat(audioTarget(ii)) = 7; % audio target (magenta circle)
% end
for ii = 1:length(idxWordsOn_only)
    ToneLabelCat(idxWordsOn_only(ii)) = 8; % non-stroop target (black star)
end
for ii = 1:length(nearestToneProv)
    ToneLabelCat(nearestToneProv(ii)) = toneCategory(ii);
end


numel(find(ToneLabelCat==8))
%% for S015 ONLY
pause
ToneLabelCat = zeros(length(Event),1);
for ii = 1:length(idxTonesOn)
    ToneLabelCat(idxTonesOn(ii)) = ToneLabel(ii); % audio non-targets (blue star)
end
for ii = 1:length(stroopTarget)
    ToneLabelCat(stroopTarget(ii)) = toneCategory(ii);
end

[numel(find(ToneLabelCat==1)) numel(find(ToneLabelCat==2)) numel(find(ToneLabelCat==3)) numel(find(ToneLabelCat==4)) numel(find(ToneLabelCat==5)) numel(find(ToneLabelCat==6)) numel(find(ToneLabelCat==7)) numel(find(ToneLabelCat==8))]
%%
% toneLabelName = strrep(filename_alone,'.csv','_ToneLabel.txt');
cd(folder)
toneLabelCat = strrep(stroop_data,'.mat','_ToneLabelCat.txt');
dlmwrite(toneLabelCat,ToneLabelCat,'delimiter','\t','newline','pc');

%% equalize number of trials
% for n = 5 (assuming no artifact detection will be done)
numelements = 20;
% get the randomly-selected indices
clear indices
indices = randperm(length(idxTonesOn_only));
indices = indices(1:numelements);
% choose the subset of a you want
idxTonesOn_only_5 = idxTonesOn_only(indices);

clear indices
indices = randperm(length(nearestToneNonProv));
indices = indices(1:numelements);
% choose the subset of a you want
nearestToneNonProv_5 = nearestToneNonProv(indices);

% clear indices
% indices = randperm(length(audioTarget));
% indices = indices(1:numelements);
% % choose the subset of a you want
% audioTarget_5 = audioTarget(indices);

clear indices
indices = randperm(length(idxWordsOn_only));
indices = indices(1:numelements);
% choose the subset of a you want
idxWordsOn_only_5 = idxWordsOn_only(indices);

ToneLabelCatEq = zeros(length(Event),1);
for ii = 1:length(idxTonesOn_only_5)
    ToneLabelCatEq(idxTonesOn_only_5(ii)) = 5; % non-stroop non-target (blue star)
end
for ii = 1:length(nearestToneNonProv_5)
    ToneLabelCatEq(nearestToneNonProv_5(ii)) = 6; % stroop non-target (cyan star)
end
% for ii = 1:length(audioTarget_5)
%     ToneLabelCatEq(audioTarget_5(ii)) = 7; % non-stroop target (magenta circle)
% end
for ii = 1:length(idxWordsOn_only_5)
    ToneLabelCatEq(idxWordsOn_only_5(ii)) = 8; % non-stroop target (black star)
end
for ii = 1:length(nearestToneProv)
    ToneLabelCatEq(nearestToneProv(ii)) = toneCategory(ii);
end


[numel(find(ToneLabelCatEq==1)) numel(find(ToneLabelCatEq==2)) numel(find(ToneLabelCatEq==3)) numel(find(ToneLabelCatEq==4)) numel(find(ToneLabelCatEq==5)) numel(find(ToneLabelCatEq==6)) numel(find(ToneLabelCatEq==7)) numel(find(ToneLabelCatEq==8))]

%% for S015 ONLY equalize number of trials
pause
numelements = 20;
% get the randomly-selected indices
clear indices
indices = randperm(length(audioNonTargets));
indices = indices(1:numelements);
% choose the subset of a you want
audioNonTargets_5 = audioNonTargets(indices);

% get the randomly-selected indices
clear indices
indices = randperm(length(nonStroopTarget_only));
indices = indices(1:numelements);
% choose the subset of a you want
nonStroopTarget_only_5 = nonStroopTarget_only(indices);

ToneLabelCatEq = zeros(length(Event),1);

clear idxTonesOn_lbl_5 ToneLabel
idxTonesOn_lbl_5 = Event;
for ii = 1:numel(audioNonTargets_5)
    idxTonesOn_lbl_5(audioNonTargets_5(ii),2)=5;
end
for ii = 1:numel(nonStroopTarget_only_5)
    idxTonesOn_lbl_5(nonStroopTarget_only_5(ii),2)=6; % (Stroop non-targets)
end
for ii = 1:numel(stroopTarget)
    idxTonesOn_lbl_5(audioTarget(ii),2)=7;
end
ToneLabelCatEq = nonzeros(idxTonesOn_lbl_5(:,2));

for ii = 1:length(stroopTarget)
    ToneLabelCatEq(stroopTarget(ii)) = toneCategory(ii);
end
[numel(find(ToneLabelCatEq==1)) numel(find(ToneLabelCatEq==2)) numel(find(ToneLabelCatEq==3)) numel(find(ToneLabelCatEq==4)) numel(find(ToneLabelCatEq==5)) numel(find(ToneLabelCatEq==6)) numel(find(ToneLabelCatEq==7)) numel(find(ToneLabelCatEq==8))]
%% toneLabelName = strrep(filename_alone,'.csv','_ToneLabel.txt');
cd(folder)
toneLabelCatEq = strrep(stroop_data,'.mat','_ToneLabelCatEq.txt');
dlmwrite(toneLabelCatEq,ToneLabelCatEq,'delimiter','\t','newline','pc');
mat_toneLabelCatEq = strrep('toneLabelCatEq','.txt','.mat');
save(mat_toneLabelCatEq,'ToneLabelCatEq')

%% toneLabelName = strrep(filename_alone,'.csv','_ToneLabel.txt');
CompareTHtoML = strrep(stroop_data,'.mat','_CompareTHtoML.txt');
dlmwrite(CompareTHtoML,table2array(compareTHtoML),'delimiter','\t','newline','pc');
mat_compareTHtoML = strrep('CompareTHtoML','.txt','.mat');
save(mat_compareTHtoML,'compareTHtoML')

%% for S015 only
% See if the graphs look the same as for the others (eg. S016)
figure
plot(tone)
ylabel('tone')
hold on 
plot(idxSStart2,ones(1,20),'m+') % when the Prov word should have started
plot(idxSEnd,ones(1,20),'k+') % approx when the Prov word should have started ended
% plot(idxTStart,ones(1,20),'g*') % when matlab thinks the tone started
plot(idxTonesOn_only,ones(1,numel(idxTonesOn_only)),'b*') % tone detected by Trigger Hub
% plot(idxWordsOn_only,ones(1,numel(idxWordsOn_only)),'k*') % word detected by Trigger Hub (idxWordOn but only the nonProv)
% plot(valNearestProvTone,ones(1,numel(valNearestProvTone)),'m*') % when the prov word started, as detected by the Trigger Hub
% plot(nearestToneNonProv,ones(1,numel(nearestToneNonProv)),'c*') % nearest nonProv tone
% plot(nearestToneProv,ones(1,numel(nearestToneProv)),'g*') % nearest Prov tone as detected by the Trigger Hub
plot(audioTarget,ones(1,20),'mo')
plot(stroopTarget,ones(1,20),'bo')
plot(nonStroopTarget_only,ones(1,280),'go')
plot(audioNonTargets,ones(1,300),'ko')
% xlim([1.5E4 3E4])
% xlim([2.195E4 2.26E4])
ylim([-.15 1.15])

%% find differences between tones only 

% tones 1-10
% 10+1(15)+1 (15 words)
% tones 26-35
% 10+2(15)+1(10)+1 (15 words)
% tones 51-60..... 61-75
% 10+3(15)+2(10)+1 (15 words)
% tones 76-85....86-100
% 10+4(15)+3(10)+1
% tones 101-110... 111-125

% clear tonesAlone
% tonesAlone = [1:1:10]';
% for kk = 1:19
%     for ii = 1:10
%         tonesAlone((kk*10)+ii) = (kk*10)+(kk*15)+ii;
%     end
% end
% 
% clear idxTonesOn_only
% for ii = 1:length(idxTonesOn)
%     kk = tonesAlone(ii)
%     idxTonesOn_only(ii) = idxTonesOn;
% end


%% decide which times to go off of
% times I want to average to:
% audio tone
% - need to pick out prov tones and label those
% - base it on the audio sensor to keep it consistent with other results
% 1. baseline - use nextTone to label
% 2. stroop - just find the 8th tone in the series
% visual stroop
% - choice a) base it on sensor
% ----------- cons: looks inconsistent, not sure of the delay anyway
% ----------- pros: more straightfoward
% - choice b) base it on matlab data
% ----------- cons: not sure where to start but could figure this out
% ----------- pros: once figured out, might be more accurate than sensor
% due to on/off inconsistencies
% - selection: choice b
% 1. determine start time relative to sample collection
%   - this can be done by aligning tone on (matlab) to stroop on
%   - convert times to # samples difference
%   - determine how tone starts were actually different from when they were
%   set to start
% conundrum 1: don't think should use combination of sensor + matlab data
% since they have different delays
% answer 1: I don't actually care that much about the stroop timing anyway
% course of action: 
% 1. align tone on (matlab) to sensor
% 2. align word on (matlab) to tone on (matlab)
% 3. celebrate
% conundrum 2: don't know how long of a time occurred between tones
% answer 2: use the sensor data from there
% What is going on now?????????????????????????
% - have all the data still
% - have a graph with lines and dots
% - the lines are light sensor data
% - the dots are stars - representing tone on data from matlab (green) and
% audio sensor (blue)
% - what did I choose to use? 
% - need to make sure that the tone onsets are consistent with the previous
% analyses
% next: find avg difference between blue stars and black stars