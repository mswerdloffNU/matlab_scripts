%% load files

clearvars
numEasy=7;
% load dsi csv file
% cd('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\DSI_data\StroopAudio')
folder = 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\DSI_data\All\';
filename_alone = 'S015_v6_hard_stroopStimuli_duration_raw.csv'; %'Maggie_stroopStimuli_v2_unRand_adj_allEasy_v4_AB00_raw.csv' %'MaggieStroopAudio1_0001_duration_raw.csv';
filename_duration = strcat(folder,filename_alone);
folder = 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\Pilot2';
folder_save = 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\Pilot2';

% specify times and channels
startRow = 17; % time = 0
endRow = inf; % time = end of trial
[Time_duration,LE,F4,C4,P4,P3,C3,F3,Trigger_duration,Time_Offset,ADC_Status,ADC_Sequence,Event,Comments] = importRaw(filename_duration, startRow, endRow); % import

% load stroop test results
stroop_data = 'S015_v6_hard.mat'; %'AB00_Test1 - MMS data.mat';
data_loc = strcat('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\StroopTestResults\Pilot2\',stroop_data);
data = load('-mat', data_loc);

folder = folder_save;

%% label stimuli: 

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
[mean(nonzeros(sD_Easy_2)) std(nonzeros(sD_Easy_2))];
% figure; histogram(nonzeros(sD_Easy_2))
pd = fitdist(nonzeros(sD_Easy_2),'Normal');

%% find index of strooop starts and stops

wordOn = find(word==1);
for ii = 1:length(stroopDurations)
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
try
    for ii = 1:numel(idxTonesOn)
        audioTarget(ii+1) = idxTonesOn(8+(ii*31));
    end
catch
    warning('Attempted to access idxTonesOn(628); index out of bounds because numel(idxTonesOn)=620.')
end
%%
clear stroopTarget
stroopTarget(1) = idxTonesOn(24);
try
    for ii = 1:numel(idxTonesOn)
        stroopTarget(ii+1) = idxTonesOn(24+(ii*31));
    end
catch
    warning('Attempted to access idxTonesOn(628); index out of bounds because numel(idxTonesOn)=620.')
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
numel(find(nonStroopTarget(1:300)==0)); % there should be 20 since the 0s are are just the stroop targets
%
clear nonStroopTarget_only
nonStroopTarget_only = nonzeros(nonStroopTarget);
% combine all indices lists
clear listComb
listComb = union(nonStroopTarget_only,(union(stroopTarget, audioTarget)));
% find audioNonTargets
clear audioNonTargets
audioNonTargets = setdiff(idxTonesOn,listComb);
numel(audioNonTargets) ;% this should be 300
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
numel(find(ToneLabel));
%%
idxWordsOn_only = nonzeros(idxWordsOn);
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
%% for S015 ONLY
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
%% for S015 ONLY equalize number of trials
rand5check = [5 5 5 5 0 0 0 0];
rand5check_goal = [5 5 5 5 5 5 5 0];
maxIter=100;

for iter=1:maxIter
    % for n = 5 (assuming no artifact detection will be done)
    numelements = 5;
    
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
    
    clear indices
    indices = randperm(length(audioTarget));
    indices = indices(1:numelements);
    % choose the subset of a you want
    audioTarget_5 = audioTarget(indices);
    
    ToneLabelCatEq = zeros(length(Event),1);
    
    clear idxTonesOn_lbl_5 ToneLabel
    % idxTonesOn_lbl_5 = zeros(1,numel(Event));
    for ii = 1:numel(audioNonTargets_5)
        ToneLabelCatEq(audioNonTargets_5(ii))=5;
    end
    for ii = 1:numel(nonStroopTarget_only_5)
        ToneLabelCatEq(nonStroopTarget_only_5(ii))=6; % (Stroop non-targets)
    end
    for ii = 1:numelements
        ToneLabelCatEq(audioTarget_5(ii))=7;
    end
    for ii = 1:length(stroopTarget)
        ToneLabelCatEq(stroopTarget(ii)) = toneCategory(ii);
    end
    rand5check = [numel(find(ToneLabelCatEq==1)) numel(find(ToneLabelCatEq==2)) numel(find(ToneLabelCatEq==3)) numel(find(ToneLabelCatEq==4)) numel(find(ToneLabelCatEq==5)) numel(find(ToneLabelCatEq==6)) numel(find(ToneLabelCatEq==7)) numel(find(ToneLabelCatEq==8))];
    
    if rand5check==rand5check_goal
        break
    elseif iter == maxIter
        warning('Max Iterations reached')
        disp(rand5check)
        pause
        break
    end
end
disp(rand5check)
%% toneLabelName = strrep(filename_alone,'.csv','_ToneLabel.txt');
cd(folder)
toneLabelCatEq = strrep(stroop_data,'.mat','_ToneLabelCatEq.txt');
dlmwrite(toneLabelCatEq,ToneLabelCatEq,'delimiter','\t','newline','pc');
mat_toneLabelCatEq = strrep('toneLabelCatEq','.txt','.mat');
save(mat_toneLabelCatEq,'ToneLabelCatEq')
%% for S015 only
% See if the graphs look the same as for the others (eg. S016)
figure
plot(tone)
ylabel('tone')
hold on 
plot(idxSStart2,ones(1,20),'m+') % when the Prov word should have started
plot(idxSEnd,ones(1,20),'k+') % approx when the Prov word should have started ended
plot(idxTonesOn_only,ones(1,numel(idxTonesOn_only)),'b*') % tone detected by Trigger Hub
plot(audioTarget,ones(1,20),'mo')
plot(stroopTarget,ones(1,20),'bo')
plot(nonStroopTarget_only,ones(1,280),'go')
plot(audioNonTargets,ones(1,300),'ko')
ylim([-.15 1.15])

%%
figure
plot(tone)
ylabel('tone')
hold on 
plot(idxSStart2,ones(1,20),'k+') % approx when the Prov word should have started ended
% plot(idxTonesOn_only,ones(1,numel(idxTonesOn_only)),'b*') % tone detected by Trigger Hub
plot(audioTarget_5,ones(1,numelements),'mo')
plot(stroopTarget,ones(1,numel(stroopTarget)),'bo')
plot(nonStroopTarget_only_5,ones(1,numelements),'go')
plot(audioNonTargets_5,ones(1,numelements),'ko')
ylim([-.15 1.15])
