% clearvars
% cd('Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\matlab_scripts\StroopTest')
cd(loc_scripts)

% subs = {'S027_SA'};
% subs = {'S020_SA','S021_SA_0001','S023_SA','S024_SA','S025_SA_0001','S026_SA_0002','S027_SA','S028_SA_0004','S029_SA_0002','S030_SA','S031_SA_0002',...
% 'S032_SA','S033_SA','S034_SA','S034_SA','S035_SA','S036_SA','S037_SA','S038_SA','S039_SA','S040_SA'};

%Maggie_stroopStimuli_v2_unRand_adj_allEasy_v6_hard_S005
%Maggie_stroopStimuli_v2_unRand_adj_allEasy_v9_mix_S005_duration_raw
for mm = 1
    if mm == 1
%         level = 'v9_mix_pt1'; %'v5_day5';
        stroop_data_sub = 'Sub_v10.mat'; %'Sub_v5_day5.mat'; %'S018_Test3unRand_adj_Easy_v6_hard.mat'; %'AB00_Test1 - MMS data.mat';
        stroop_data_sub_startStop = 'Sub_v10_startStop.mat';
        filename = 'Sub_duration_raw.csv'; %'Sub_stroopStimuli_v2_unRand_adj_allEasy_v5_S005_day5_duration_raw.csv'; %'Maggie_stroopStimuli_v2_unRand_adj_allEasy_v4_AB00_raw.csv' %'MaggieStroopAudio1_0001_duration_raw.csv';
%     elseif mm==2
%         level = 'v9_mix_pt2'; %'v6_hard_day5';
%         stroop_data_sub = 'Sub_v9_mix_pt2.mat'; %'Sub_v6_hard_day5.mat'; %'S018_Test3unRand_adj_Easy_v6_hard.mat'; %'AB00_Test1 - MMS data.mat';
%         filename = 'Sub_v9_mix_pt2_stroopStimuli_duration_raw.csv'; %'Sub_stroopStimuli_v2_unRand_adj_allEasy_v6_hard_S005_day5_duration_raw.csv'; %'Maggie_stroopStimuli_v2_unRand_adj_allEasy_v4_AB00_raw.csv' %'MaggieStroopAudio1_0001_duration_raw.csv';
    end
    for i = 1:numel(subs)
        %% load files
%         clearvars -except subs i mm level stroop_data_sub stroop_data_sub_startStop filename toneCategory_all timingError_all
        sub = subs{i};
        numEasy=5;
        % load dsi csv file
        folder = 'Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\EEG\DSI_data\StroopAudio\study1\';
        filename_alone = strrep(filename,'Sub',sub)
        filename_duration = strcat(folder,filename_alone);
        folder_save = 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\study1';
        
        % specify times and channels
        addpath('Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\matlab_scripts\StroopTest')
        startRow = 17; % time = 0
        endRow = inf; % time = end of trial
        [Time_duration,LE,F4,C4,P4,P3,C3,F3,Trigger_duration,Time_Offset,ADC_Status,ADC_Sequence,Event,Comments] = importRaw(filename_duration, startRow, endRow); % import
        [Time_xx,LE_xx,F4_xx,C4_xx,P4_xx,P3_xx,C3_xx,F3_xx,Trigger_xx,Time_Offset_xx,ADC_Status_xx,ADC_Sequence_xx,Event_xx,Comments_xx] = importRaw('Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\EEG\DSI_data\StroopAudio\study1\S025_SA_0001_raw.csv', startRow, endRow); % import

        % load stroop test results
        stroop_data = strrep(stroop_data_sub,'Sub',sub)
        startStop_data = strrep(stroop_data_sub_startStop,'Sub',sub)
        %data_loc = strcat('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\StroopTestResults\Pilot2\',stroop_data);
        data_loc = strcat('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\StroopTestResults\study1\renamed\',stroop_data);
        data = load('-mat', data_loc);
        startStops = strcat('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\study1\',sub,'\',startStop_data);
        loc_sub = strcat('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\study1\',sub);
        cd(loc_sub)
        
        if isfile(startStops)
            startStop = load('-mat',startStops);
        else
            sprintf('you will have to specify cursor_info for startStops')
        end
        cd('Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\matlab_scripts\StroopTest')

        folder = folder_save;
        congruences = data.congruences;
        pretoneson = data.pretoneson;
        pauseTimes = data.pauseTimes;
        startTime = data.startTime;
        endTime = data.endTime;
        %% label stimuli:
        
        for ii = 1:length(Trigger_duration)
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
        
        cd(loc_sub)
        if ~exist('startStop','var')
            pause
            sprintf('select then save cursor_info!')
            save(stroop_data_sub_startStop,'cursor_info'); % save cursor data
        else
            cursor_info = startStop.cursor_info;
        end
        cd('Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\matlab_scripts\StroopTest')

%         figure
%         plot(word+1,'b-')
%         hold on
%         plot(tone,'m-')
%                 %%
%         timingError = table2array(data.timingError(:,2));
%         toneCategory = zeros(length(timingError),1);
%         for ii = 1:length(toneCategory)
%             if timingError(ii) < 0
%                 toneCategory(ii) = 1;
%             elseif timingError(ii) == 0
%                 toneCategory(ii) = 2;
%             elseif timingError(ii) > 0
%                 if timingError(ii) < .1
%                     toneCategory(ii) = 3;
%                 elseif timingError(ii) > .1
%                     toneCategory(ii) = 4;
%                 end
%             end
%         end
%         timingError_all(:,i,mm) = table2array(data.timingError(:,2));
%         toneCategory_all(:,i,mm)=toneCategory;
%     end
% end

        %% calculate durationss
        drtns = [etime(pauseTimes(1,:),startTime)/60 ...
            etime(pauseTimes(2,:),pauseTimes(1,:))/60 ...
            etime(pauseTimes(3,:),pauseTimes(2,:))/60 ...
            etime(pauseTimes(4,:),pauseTimes(3,:))/60 ...
            etime(endTime,pauseTimes(4,:))/60];

        % calculate number of seconds difference between drts and
        % TriggerHub start/stop
        (etime(endTime,startTime))/60
        abs((cursor_info(1).DataIndex-cursor_info(2).DataIndex)/300)/60
        (Time_duration(cursor_info(2).DataIndex)-Time_duration(cursor_info(1).DataIndex))/60
        
        % number of target (incongruent) words in each session
        numel(find(pretoneson(1:40,1)==0))
        numel(find(pretoneson(41:80,1)==0))
        numel(find(pretoneson(81:120,1)==0))
        
        %% create expanded list from pretoneson
        expList = [];
        aa = 1;
        for ii = 1:numel(pretoneson)
            if pretoneson(ii) == 1
                expList(aa) = 1;
                expList(aa+1) = 0;
                aa = aa+2;
            elseif pretoneson(ii) == 0
                expList(aa) = 0;
                aa = aa+1;
            end
        end
        
        %% create fake list of Tones
        fakeTones = [];
        aa = 1;
        bb = 1;
        for ii = 1:numel(expList)
            if expList(ii) == 1
                fakeTones(aa:aa+9) = 1; % Non-target tone-only
                fakeTones(aa+5) = 2; % Target Tone-only
                aa = aa+10;
            elseif expList(ii) == 0
                fakeTones(aa:aa+9) = 3; % Non-target word
                if congruences(bb) == 0 
                    fakeTones(aa+5) = 4; % Target word (Hard)
                elseif congruences(bb) == 1 
                    fakeTones(aa+5) = 5; % Non-Target Target word (Easy)
                end
                aa = aa+10;
                bb = bb+1;
            end
        end
[numel(find(fakeTones==1)) numel(find(fakeTones==2)) numel(find(fakeTones==3)) ...
    numel(find(fakeTones==4)) numel(find(fakeTones==5))]

%%
fakeTones_tto = zeros(1,numel(fakeTones));
fakeTones_easy = zeros(1,numel(fakeTones));
fakeTones_hard = zeros(1,numel(fakeTones));
aa = 1; bb = 1; cc = 1;
for ii = 1:numel(fakeTones)
    if fakeTones(ii) == 2
        fakeTones_tto(ii) = 1;
        fakeTones_hard(ii) = 0;
        fakeTones_easy(ii) = 0;
        aa = aa+1;
    elseif fakeTones(ii) == 4
        fakeTones_easy(ii) = 1;
        fakeTones_hard(ii) = 0;
        fakeTones_tto(ii) = 0;
        bb = bb+1;
    elseif fakeTones(ii) == 5
        fakeTones_hard(ii) = 1;
        fakeTones_easy(ii) = 0;
        fakeTones_tto(ii) = 0;
        cc = cc+1;
    end
end
%%
figure()
hold on
% plot(1:1800,fakeTones,'b*')
plot(1:1800,fakeTones_tto,'b*') % Target Tone-only
plot(1:1800,fakeTones_easy,'m*') % Target word (Hard)
plot(1:1800,fakeTones_hard,'c*') % Non-Target Target word (Easy)

%%
toneOn = [];
for ii = 1:length(tone)-1
    if tone(ii) == 0 && tone(ii+1) == 1
        toneOn(ii+1) = ii+1;
    end
end
idxTonesOn = find(toneOn);

wordOnset = [];
for ii = 1:length(word)-1
    if word(ii) == 0 && word(ii+1) == 1
        wordOnset(ii+1) = ii+1;
    end
end
idxWordsOn = find(wordOnset);

toneOffset = [];
for ii = 1:length(tone)-1
    if tone(ii) == 1 && tone(ii+1) == 0
        toneOffset(ii+1) = ii+1;
    end
end
idxTonesOff = find(toneOffset);

wordOffset = [];
for ii = 1:length(word)-1
    if word(ii) == 1 && word(ii+1) == 0
        wordOffset(ii+1) = ii+1;
    end
end
idxWordsOff = find(wordOffset);
%%
        figure
        plot(word)
        ylabel('word')
        hold on
        plot(idxTonesOn,ones(1,numel(idxTonesOn)),'ko')
        plot(idxTonesOff,ones(1,numel(idxTonesOff)),'k+')
        plot(idxWordsOn,ones(1,numel(idxWordsOn)),'co')
        plot(idxWordsOff,ones(1,numel(idxWordsOff)),'co')
        if strfind(sub,'S024_SA')==1
            plot(idxTonesOn,[1 fakeTones_tto],'b*') % Target Tone-only
            plot(idxTonesOn,[1 fakeTones_easy],'m*') % Target word (Hard)
            plot(idxTonesOn,[1 fakeTones_hard],'c*') % Non-Target Target word (Easy)
        elseif strfind(sub,'S027_SA')==1
            plot(idxTonesOn,[1 1 fakeTones_tto],'b*') % Target Tone-only
            plot(idxTonesOn,[1 1 fakeTones_easy],'m*') % Target word (Hard)
            plot(idxTonesOn,[1 1 fakeTones_hard],'c*') % Non-Target Target word (Easy)
        else
            plot(idxTonesOn,[fakeTones_tto],'b*') % Target Tone-only
            plot(idxTonesOn,[fakeTones_easy],'m*') % Target word (Hard)
            plot(idxTonesOn,[fakeTones_hard],'c*') % Non-Target Target word (Easy)
        end
        %% create major matrix with all stim
        
        % fix fakeTones
        if strfind(sub,'S024_SA')==1
            fakeTones_tto2 = [0 fakeTones_tto];
            fakeTones_easy2 = [0 fakeTones_easy];
            fakeTones_hard2 = [0 fakeTones_hard];        
        elseif strfind(sub,'S027_SA')==1
            fakeTones_tto2 = [0 0 fakeTones_tto];
            fakeTones_easy2 = [0 0 fakeTones_easy];
            fakeTones_hard2 = [0 0 fakeTones_hard];
        else
            fakeTones_tto2 = [fakeTones_tto];
            fakeTones_easy2 = [fakeTones_easy];
            fakeTones_hard2 = [fakeTones_hard];
        end
        
        % initialize
        idxTonesOn_tto = zeros(numel(idxTonesOn),1);
        idxTonesOn_easy = zeros(numel(idxTonesOn),1);
        idxTonesOn_hard = zeros(numel(idxTonesOn),1);
        idxTonesOn_both = zeros(numel(idxTonesOn),2);
        
        % convert farkTones_tto, fakeTones_easy, and fakeTones_hard to idx
        % to match idxTonesOn
        for ii = 1:numel(idxTonesOn)
            if fakeTones_tto2(ii) == 1
                idxTonesOn_tto(ii) = idxTonesOn(ii);
            end
            if fakeTones_easy2(ii) == 1
                idxTonesOn_easy(ii) = idxTonesOn(ii);
                idxTonesOn_both(ii,1) = idxTonesOn(ii);
                idxTonesOn_both(ii,2) = 1;
            end
            if fakeTones_hard2(ii) == 1
                idxTonesOn_hard(ii) = idxTonesOn(ii);
                idxTonesOn_both(ii,1) = idxTonesOn(ii);
                idxTonesOn_both(ii,2) = 2;
            end
        end
        
        [numel(find(idxTonesOn_tto)) numel(find(idxTonesOn_easy)) numel(find(idxTonesOn_hard)) numel(find(idxTonesOn_both(:,1)))]

        %% replot
                
        figure
        plot(word)
        ylabel('word')
        hold on
        plot(idxTonesOn,ones(1,numel(idxTonesOn)),'ko')
        plot(idxTonesOff,ones(1,numel(idxTonesOff)),'k+')
        plot(idxWordsOn,ones(1,numel(idxWordsOn)),'co')
        plot(idxWordsOff,ones(1,numel(idxWordsOff)),'co')
        plot(idxTonesOn_tto,ones(1,numel(idxTonesOn_tto)),'b*')       
        plot(idxTonesOn_easy,ones(1,numel(idxTonesOn_easy)),'m*')
        plot(idxTonesOn_hard,ones(1,numel(idxTonesOn_hard)),'c*')

        %% create toneLabel
        ToneLabel = zeros(numel(Time_duration),1);
        idxTonesOn_nz = nonzeros(idxTonesOn);
        idxTonesOff_nz = nonzeros(idxTonesOff);
        idxWordsOn_nz = nonzeros(idxWordsOn);
        idxWordsOff_nz = nonzeros(idxWordsOff);
        idxTonesOn_tto_nz = nonzeros(idxTonesOn_tto);
        idxTonesOn_easy_nz = nonzeros(idxTonesOn_easy);
        idxTonesOn_hard_nz = nonzeros(idxTonesOn_hard);
        idxTonesOn_both_nz = nonzeros(idxTonesOn_both(:,1));
            
        for ii = 1:numel(idxTonesOn_nz)
            ToneLabel(idxTonesOn_nz(ii)) = 1;
            ToneLabel(idxTonesOff_nz(ii)) = 2;
        end
        fst=numel(find(ToneLabel))
        
        for ii = 1:numel(idxWordsOn_nz)
            ToneLabel(idxWordsOn_nz(ii)) = 3;
            ToneLabel(idxWordsOff_nz(ii)) = 4;
        end
        scnd=numel(find(ToneLabel))
        
        for ii = 1:numel(idxTonesOn_tto_nz)
            ToneLabel(idxTonesOn_tto_nz(ii)) = 5;
            ToneLabel(idxTonesOn_easy_nz(ii)) = 6;
            ToneLabel(idxTonesOn_hard_nz(ii)) = 7;
        end
        thd=numel(find(ToneLabel))
        
        %% label as pre, at, post, or post x2
               
        timingError = table2array(data.timingError(:,2));
        toneCategory = zeros(length(timingError),1);
        for ii = 1:length(timingError)
            if timingError(ii) < 0
                if congruences(ii) == 0 % hard
                    toneCategory(ii) = 71;
                elseif congruences(ii) == 1 % easy
                    toneCategory(ii) = 65;
                end
            elseif timingError(ii) == 0
                if congruences(ii) == 0 % hard
                    toneCategory(ii) = 72;
                elseif congruences(ii) == 1 % easy
                    toneCategory(ii) = 66;
                end
            elseif timingError(ii) > 0
                if timingError(ii) < .07
                    if congruences(ii) == 0 % hard
                        toneCategory(ii) = 73;
                    elseif congruences(ii) == 1 % easy
                        toneCategory(ii) = 67;
                    end
                elseif timingError(ii) > .07
                    if congruences(ii) == 0 % hard
                        toneCategory(ii) = 74;
                    elseif congruences(ii) == 1 % easy
                        toneCategory(ii) = 68;
                    end
                end
            end
        end

        
        for ii = 1:numel(toneCategory)
            ToneLabel(idxTonesOn_both_nz(ii)) = toneCategory(ii);
        end
        
        [numel(find(ToneLabel==65)) numel(find(ToneLabel==66)) numel(find(ToneLabel==67)) ...
            numel(find(ToneLabel==68)) numel(find(ToneLabel==71)) numel(find(ToneLabel==72)) ...
            numel(find(ToneLabel==73)) numel(find(ToneLabel==74))]
        
        % 65: easy pre-
        % 66: easy at-
        % 67: easy post x1
        % 68: easy post x2
        % 71: hard pre-
        % 72: hard at-
        % 73: hard post x1
        % 74: hard post x2
        %%
        cd(folder)
        toneLabel = strrep(stroop_data,'.mat','_ToneLabel.txt');
%         dlmwrite(toneLabel,ToneLabel,'delimiter','\t','newline','pc');
        %%
    end
end

        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
%         %% determine when prov tones occur
%         
%         clear td out datecell stroopDurations
%         
%         % plot stroop words
%         for jj = 1:2
%             for ii = 1:length(data.Prov)
%                 datecell(ii,:,1) = data.Prov{1,ii}.timeStart; % Prov stroop start time
%                 datecell(ii,:,2) = data.Prov{1,ii}.timeEnd; % Prov stroop end time
%                 td(ii,1,jj) = duration(datecell(ii,4:6,jj)); %,'inputformat','[yyyy-MM-dd HH:mm:ss.SSS');
%                 % time lapse between prov stroop starts and stops
%             end
%         end
%         
%         stroopDurations = milliseconds(td(:,:,2)-td(:,:,1)); % time lapse between prov stroop starts and stops, in ms
%         stroopStarts(:,1) = milliseconds(td(:,:,2)-(duration(data.Easy{1,1}.timeStart(4:6)))); %time stroop ended minus time first stroop started
%         stroopStarts2(:,1) = milliseconds(td(:,:,1)-(duration(data.Easy{1,1}.timeStart(4:6)))); %time each stroop started minus time first stroop started
%         %%
%         % plot nonProvstroop words
%         for kk = 1:numEasy
%             for jj = 1:2
%                 for ii = 1:length(data.Easy)
%                     clear datecell_Easy1
%                     datecell_Easy1(ii,:,1) = data.Easy{kk,ii}.timeStart; % stroop start time
%                     datecell_Easy1(ii,:,2) = data.Easy{kk,ii}.timeEnd; % stroop end time
%                     td_Easy1(ii,jj,kk) = duration(datecell_Easy1(ii,4:6,jj)); %,'inputformat','[yyyy-MM-dd HH:mm:ss.SSS');
%                     % time lapse between nonprov stroop starts and stops
%                 end
%             end
%         end
%         stroopDurations_Easy1 = milliseconds(td_Easy1(:,2,:)-td_Easy1(:,1,:)); % time lapse between prov stroop starts and stops, in ms
%         clear datecell_Easy2
%         for kk = 1:numEasy-1
%             for jj = 1:2
%                 for ii = 1:length(data.Easy)
%                     clear datecell_Easy2
%                     datecell_Easy2(ii,:,1) = data.Easy{kk,ii}.timeEnd; % stroop start time
%                     datecell_Easy2(ii,:,2) = data.Easy{kk+1,ii}.timeStart; % stroop end time
%                     td_Easy2(ii,jj,kk) = duration(datecell_Easy2(ii,4:6,jj)); %,'inputformat','[yyyy-MM-dd HH:mm:ss.SSS');
%                     % time lapse between nonprov stroop starts and stops
%                 end
%             end
%         end
%         stroopDurations_Easy2 = milliseconds(td_Easy2(:,2,:)-td_Easy2(:,1,:)); % time lapse between prov stroop starts and stops, in ms
%         
%         stroopDurations_Easy = squeeze(stroopDurations_Easy1(:,:,1:end-1) + stroopDurations_Easy2);
%         
%         sD_Easy = stroopDurations_Easy(:);
%         
%         for ii = 1:numel(sD_Easy)
%             if sD_Easy(ii) > 3700
%                 sD_Easy_2(ii) = 0;
%             else
%                 sD_Easy_2(ii) = sD_Easy(ii);
%             end
%         end
%         [mean(nonzeros(sD_Easy_2)) std(nonzeros(sD_Easy_2))]
%         
%         %% find index of strooop starts and stops
%         
%         wordOn = find(word==1);
%         for ii = 1:length(stroopDurations)
%             idxSStart2(ii) = wordOn(1) + (300*stroopStarts2(ii)/1000);
%             idxSEnd(ii) = idxSStart2(ii)+(300*stroopDurations(ii)/1000); % idx of prov stroop end
%             idxTStart(ii) = idxSStart2(ii)+(300*data.timingError{ii,1}); % idx of prov tone start
%         end
%         
%         for ii = 1:length(tone)-1
%             if tone(ii) == 0 && tone(ii+1) == 1
%                 toneOn(ii+1) = ii+1;
%             end
%         end
%         idxTonesOn = find(toneOn);
%         
%         for ii = 1:length(word)-1
%             if word(ii) == 0 && word(ii+1) == 1
%                 wordOnset(ii+1) = ii+1;
%             end
%         end
%         idxWordsOn = find(wordOnset);
%         
%         for ii = 1:length(word)-1
%             if word(ii) == 1 && word(ii+1) == 0
%                 wordOffset(ii+1) = ii+1;
%             end
%         end
%         idxWordsOff = find(wordOffset);
%         
%         idxTonesOnWordsOn = union(idxWordsOn,idxTonesOn);
%         %%
%         audiomix = zeros(30,1);
%         ii = 1; aa = 1;
%         while ii <= numel(pretoneson)
%             if pretoneson(ii) == 1
%                 audiomix(aa) = 1; % audio-only portion
%                 audiomix(aa+1) = 0; % stroop portion
%                 aa = aa+2;
%                 ii = ii+1;
%             elseif pretoneson(ii) == 0
%                 audiomix(aa) = 0; % stroop portion
%                 ii = ii+1;
%                 aa = aa+1;
%             end
%         end
%         audiomix;
%         numel(find(audiomix));
%         
%         %%
%         audioTargetAll = zeros(30,2);
%         audioTargetStroop = zeros(30,1);
%         audioTargetOnly = zeros(30,1);
%         prev=8;
%         audioTargetAll(1) = idxTonesOn(prev); 
%         if audiomix(1) == 1
%             nums_stroopOnly(1) = prev+15;
%             nums_audioOnly(1) = prev;
%             audioTargetAll(1,2) = 1;
%         elseif audiomix(1) == 0
%             nums_stroopOnly(1) = prev;
%             audioTargetAll(1,2) = 0;
%         end
%         clear nums
%         nums(1) = prev;
%                 for ii = 2:numel(audiomix)
%                     if audiomix(ii-1) == 0 
%                         newnum = prev + 15;
%                         nums(ii,:) = newnum;
% %                         audioTargetAll(ii,1) = idxTonesOn(newnum);
%                         audioTargetAll(ii-1,2) = 0;
%                         prev = newnum;
%                     elseif audiomix(ii-1) == 1 
%                         newnum = prev + 16;
%                         nums(ii,:) = newnum;
% %                         audioTargetAll(ii,1) = idxTonesOn(newnum);
%                         audioTargetAll(ii-1,2) = 1;
%                         prev = newnum;
%                     end
%                     
%                     if audiomix(ii) == 0
%                         nums_stroopOnly(ii) = nums(ii);
%                     elseif audiomix(ii) == 1
%                         nums_audioOnly(ii) = nums(ii);
%                     end
% 
%                 end
%                 %% MANUALL CHANGES ONLY
%                 audioTargetAll_old = audioTargetAll;
%                 if strcmp(sub,'Maggie') == 1 && strcmp(level,'v9_mix_pt2') == 1
%                     clear nums nums_audioOnly nums_stroopOnly
%                     audioTargetAll = zeros(30,2);
%                     audioTargetStroop = zeros(30,1);
%                     audioTargetOnly = zeros(30,1);
%                     prev=8;
%                     nums(1) = prev;
%                     audioTargetAll(1) = idxTonesOn(prev);
%                     if audiomix(1) == 1
%                         %                     nums_stroopOnly(1) = prev+15;
%                         nums_audioOnly(1) = prev;
%                         audioTargetAll(1,2) = 1;
%                     elseif audiomix(1) == 0
%                         nums_stroopOnly(1) = prev;
%                         audioTargetAll(1,2) = 0;
%                     end
%                     
%                     
%                     
%                     errnum = 13;
%                     errfix = 192;
%                     
%                     prev=8;
%                     for ii = 2:numel(audiomix)
%                         
%                         if ii == errnum && audiomix(ii-1) == 0
%                             audioTargetAll(ii-1,2) = 0;
%                             %                             prev = errfix;
%                             newnum = prev + 14;
%                             nums(ii)=newnum;
%                             prev = newnum;
%                         elseif ii == errnum && audiomix(ii-1) == 1
%                             audioTargetAll(ii-1,2) = 1;
%                             %                             prev = errfix;
%                             newnum = prev + 15;
%                             nums(ii)=newnum;
%                             prev = newnum;
%                         else
%                             if audiomix(ii-1) == 0
%                                 newnum = prev + 15;
%                                 nums(ii) = newnum;
%                                 %                         audioTargetAll(ii,1) = idxTonesOn(newnum);
%                                 audioTargetAll(ii-1,2) = 0;
%                                 prev = newnum;
%                             elseif audiomix(ii-1) == 1
%                                 newnum = prev + 16;
%                                 nums(ii) = newnum;
%                                 %                         audioTargetAll(ii,1) = idxTonesOn(newnum);
%                                 audioTargetAll(ii-1,2) = 1;
%                                 prev = newnum;
%                             end
%                         end
%                         
%                         if audiomix(ii) == 0
%                             nums_stroopOnly(ii) = nums(ii);
%                         elseif audiomix(ii) == 1
%                             nums_audioOnly(ii) = nums(ii);
%                         end
%                         
%                     end
%                 end
%                 
%                 %%
%                 for ii = 2:numel(audiomix)
%                     audioTargetAll(ii,1) = idxTonesOn(nums(ii));
%                 end
%                 
%                 %%
%                 nums_stroopOnly = nonzeros(nums_stroopOnly);
%                 nums_audioOnly = nonzeros(nums_audioOnly);
%                 %%
% [numel(find(audioTargetAll(:,1))) numel(find(audioTargetAll(:,2)== 0)) numel(find(audioTargetAll(:,2)) == 1)]
% for ii = 1:numel(audiomix)
%     if audioTargetAll(ii,2) == 0
%         audioTargetStroop(ii) = audioTargetAll(ii,1);
%     elseif audioTargetAll(ii,2) == 1
%         audioTargetOnly(ii) = audioTargetAll(ii,1);
%     end
% end
% % [numel(find(audioTargetStroop)) numel(find(audioTargetOnly))]
% % find([audiomix-audioTargetAll(:,2)])
% 
% [audioTargetAll_old(:,1)-audioTargetAll(:,1)]
% %%
% clear audioTarget
% %         audioTarget(1) = idxTonesOn(8);
% %         try
% for ii = 1:numel(nums_audioOnly)
%     idxAudio = find(nums == nums_audioOnly(ii));
%     audioTarget(ii) = idxTonesOn(nums(idxAudio));
% end
% 
% %         catch
% %             warning('Attempted to access idxTonesOn(628); index out of bounds because numel(idxTonesOn)=620.')
% %         end
%         %%
%         clear stroopTarget
% %         stroopTarget(1) = idxTonesOn(24);
%             for ii = 1:numel(nums_stroopOnly)
%                 idxStroop = find(nums == nums_stroopOnly(ii));
%                 stroopTarget(ii) = idxTonesOn(nums(idxStroop));
%             end
%         
%         %%
%         wordDurations = idxWordsOff-idxWordsOn;
%         figure;plot(wordDurations,'.')
%         wordToWordDelay = idxWordsOn(2:end)-idxWordsOn(1:end-1);
%         figure;plot(wordToWordDelay,'.')
%         
%         %%
%         idxWordsOn_only = nonzeros(idxWordsOn);
%         
%         clear idxWordsOn_easy idxWordsOn_hard
%         idxWordsOn_easy(1) = idxWordsOn_only(1);
%         idxWordsOn_easy(2) = idxWordsOn_only(2);
%         idxWordsOn_easy(3) = idxWordsOn_only(3);
%         idxWordsOn_easy(4) = idxWordsOn_only(4);
%         idxWordsOn_easy(5) = idxWordsOn_only(5);
%         idxWordsOn_easy(6) = idxWordsOn_only(6);
%         idxWordsOn_easy(7) = idxWordsOn_only(7);
%         
%         idxWordsOn_hard(1) = idxWordsOn_only(9);
%         idxWordsOn_hard(2) = idxWordsOn_only(10);
%         idxWordsOn_hard(3) = idxWordsOn_only(11);
%         idxWordsOn_hard(4) = idxWordsOn_only(12);
%         idxWordsOn_hard(5) = idxWordsOn_only(13);
%         idxWordsOn_hard(6) = idxWordsOn_only(14);
%         idxWordsOn_hard(7) = idxWordsOn_only(15);
%         try
%             for ii = 16:15:numel(idxWordsOn_only)
%                 idxWordsOn_easy(ii+7) = idxWordsOn_only(ii);
%                 idxWordsOn_easy(ii+8) = idxWordsOn_only(1+ii);
%                 idxWordsOn_easy(ii+9) = idxWordsOn_only(2+ii);
%                 idxWordsOn_easy(ii+10) = idxWordsOn_only(3+ii);
%                 idxWordsOn_easy(ii+11) = idxWordsOn_only(4+ii);
%                 idxWordsOn_easy(ii+12) = idxWordsOn_only(5+ii);
%                 idxWordsOn_easy(ii+13) = idxWordsOn_only(6+ii);
%                 
%                 idxWordsOn_hard(ii+7) = idxWordsOn_only(8+ii);
%                 idxWordsOn_hard(ii+8) = idxWordsOn_only(9+ii);
%                 idxWordsOn_hard(ii+9) = idxWordsOn_only(10+ii);
%                 idxWordsOn_hard(ii+10) = idxWordsOn_only(11+ii);
%                 idxWordsOn_hard(ii+11) = idxWordsOn_only(12+ii);
%                 idxWordsOn_hard(ii+12) = idxWordsOn_only(13+ii);
%                 idxWordsOn_hard(ii+13) = idxWordsOn_only(14+ii);
%             end
%         catch
%             warning('Attempted to access idxTonesOn(644); index out of bounds because numel(idxTonesOn)=620.')
%         end
%         idxWordsOn_easy=nonzeros(idxWordsOn_easy); idxWordsOn_hard=nonzeros(idxWordsOn_hard);
%         figure;plot(idxWordsOn_easy,ones(length(idxWordsOn_easy)),'.')
%         hold on; plot(idxWordsOn_only,ones(length(idxWordsOn_only))*1.15,'.')
%         plot(idxWordsOn_hard,ones(length(idxWordsOn_hard)),'.')
%         ylim([-1.5 3.5])
%         
% 
%         %%
%         figure
%         plot(word)
%         ylabel('word')
%         hold on
%         plot(idxTonesOn,ones(1,numel(idxTonesOn)),'b*')
%         plot(idxWordsOn_only,ones(1,numel(idxWordsOn_only)),'k*')
%         plot(idxWordsOff,ones(1,numel(idxWordsOff)),'ko')
%         plot(idxSEnd,ones(1,20),'k+')
%         plot(idxTStart,ones(1,20),'g*')
%         plot(idxSStart2,ones(1,20),'m+')
%         plot(audioTarget,ones(1,numel(audioTarget)),'mo')
%         plot(stroopTarget,ones(1,numel(stroopTarget)),'go')
%         plot(audioTargetAll,ones(1,30),'bo')
%         plot(audioTargetOnly,ones(1,30),'bo','MarkerSize',20)
%         plot(audioTargetStroop,ones(1,30),'mo','MarkerSize',20)
%         ylim([.95 1.05])
%         
%         %%
%         figure
%         plot(word)
%         ylabel('word')
%         hold on
%         plot(idxTonesOnWordsOn,ones(1,numel(idxTonesOnWordsOn)),'k*')
%         plot(audioTarget,ones(1,numel(audioTarget)),'mo')
%         plot(stroopTarget,ones(1,numel(stroopTarget)),'go')
%         
%         %% determine difference between blue and black stars and whether they match the expected delays
%         % difference between blue and black
%         % for every black star, find how far the nearest blue one is.
%        clear nearestProvTones idxNearestProvTones nearestProvTone_easy idxNearestProvTone_easy
%         for kk = 1:length(idxSStart2)
%             for ii = 1:length(idxWordsOn_only)
%                 [nearestProvTones(ii,kk), idxNearestProvTones(ii,kk)] = min(abs(idxSStart2(kk)-idxWordsOn_only(ii)));
%             end
%         end
%         
%         [nearestProvTone idxNearestProvTone] = min(nearestProvTones);
%         
%         idxNearestProvTone_old = idxNearestProvTone;
% %         clear idxNearestProvTone
% %         for ii = 1:length(nearestProvTone)
% %             idxNearestProvTone(ii) = 8 + (ii-1)*15; % analogous to nums
% %             except strictly stroop targets (nums includes both stroop
% %             targets and audio targets)
% %         end
% %         
% %         for ii = 1:length(idxSStart2)
% %             valNearestProvTone(ii) = idxWordsOn_only(idxNearestProvTone(ii));
% %         end
% %         
% 
% % %         stroopTarget(1) = idxTonesOn(24);
% %             for ii = 1:numel(nums_stroopOnly)
% %                 [idxStroop ~] = find(nums == nums_stroopOnly(ii));
% %                 stroopTarget(ii) = idxTonesOn(nums(idxStroop));
% %             end
%             
% for ii = 1:length(idxSStart2)
%     valNearestProvTone(ii) = idxTonesOn(nums_stroopOnly(ii));
% end
% 
% clear nearestProvTones idxNearestProvTones nearestProvTone_easy idxNearestProvTone_easy
%         for kk = 1:length(idxSStart2)
%             for ii = 1:length(idxWordsOn_easy)
%                 [nearestProvTones(ii,kk), idxNearestProvTones(ii,kk)] = min(abs(idxSStart2(kk)-idxWordsOn_easy(ii)));
%             end
%         end
%         
%         [nearestProvTone_easy idxNearestProvTone_easy] = min(nearestProvTones);
%         
%         for ii = 1:length(idxSStart2)
%             valNearestProvTone_easy(ii) = idxWordsOn_easy(idxNearestProvTone_easy(ii));
%         end
% 
%         clear nearestProvTones idxNearestProvTones nearestProvTone_hard idxNearestProvTone_hard
%         for kk = 1:length(idxSStart2)
%             for ii = 1:length(idxWordsOn_hard)
%                 [nearestProvTones(ii,kk), idxNearestProvTones(ii,kk)] = min(abs(idxSStart2(kk)-idxWordsOn_hard(ii)));
%             end
%         end
%         
%         [nearestProvTone_hard idxNearestProvTone_hard] = min(nearestProvTones);
%         
%         for ii = 1:length(idxSStart2)
%             valNearestProvTone_hard(ii) = idxWordsOn_hard(idxNearestProvTone_hard(ii));
%         end
% 
%         %%
%         figure
%         plot(word)
%         ylabel('word')
%         hold on
%         plot(idxSStart2,ones(1,20),'m+') % when the Prov word should have started
%         plot(idxSEnd,ones(1,20),'k+') % approx when the Prov word should have started ended
%         plot(idxTStart,ones(1,20),'g*') % when matlab thinks the tone started
%         plot(idxTonesOn,ones(1,numel(idxTonesOn)),'b*') % tone detected by Trigger Hub
%         plot(idxWordsOn_only,ones(1,numel(idxWordsOn_only)),'k*') % word detected by Trigger Hub
%         plot(valNearestProvTone,ones(1,numel(valNearestProvTone)),'m*') % when the prov word started, as detected by the Trigger Hub
%         ylim([-.15 1.15])
%         
%         %% find the difference
%         clear nearestProvToneOn idxNearestProvToneOn nearestProvTonOn idxNearestProvToneOn
%         for kk = 1:length(valNearestProvTone)
%             for ii = 1:length(idxTonesOn)
%                 [nearestProvToneOn(ii,kk)] = abs(valNearestProvTone(kk)-idxTonesOn(ii));
%             end
%         end
%         
%         clear valNearestProvToneOn nearestProvToneOnMin idxNearestProvToneOnMin idxNearestProvToneOnMin_new
%         [nearestProvToneOnMin, idxNearestProvToneOnMin] = min(nearestProvToneOn);
%         idxNearestProvToneOnMin_old = idxNearestProvToneOnMin;
% %         clear idxNearestProvToneOnMin
% %         for ii = 1:20
% %             idxNearestProvToneOnMin(ii) = 24 + 31*(ii-1);
% %         end
% %         for ii = 1:length(idxNearestProvToneOnMin)
% %             valNearestProvToneOn(ii) = idxTonesOn(idxNearestProvToneOnMin(ii));
% %         end
% %         
% 
% for ii = 1:length(nums_stroopOnly)
%     valNearestProvToneOn(ii) = idxTonesOn(nums_stroopOnly(ii));
% end
% 
% % determine whether each tone was before or after prov as expected, in
%         % milliseconds
%         clear diffNearestProvToneOn
%         for ii = 1:length(idxNearestProvToneOnMin)
%             diffNearestProvToneOn(ii,:) = (valNearestProvTone(ii)-idxTonesOn(idxNearestProvToneOnMin(ii))).*-10/3;
%         end
%         x=ones(1,20);
%         figure;plot(valNearestProvTone,x,'k*');hold on; plot(valNearestProvToneOn,x,'b*');
%         c = [(valNearestProvTone') valNearestProvToneOn' (valNearestProvTone'-valNearestProvToneOn')*10/3];
%         % note idxSStart (m+) is based on the Stroop test start time based on the
%         % computer timing; valNearestProvTone (m*) is based on the trigger hub onset of
%         % Stroop
%         x = 70.5:.01:71; clear y_mean
%         for ii = 1:numel(x)
%             y = data.timingError{:,1}*1000-diffNearestProvToneOn+x(ii);
%             y_mean(ii) = mean(y);
%         end
%         
%         compareTHtoML = table(data.timingError{:,2}*1000,(data.timingError{:,1}*1000), diffNearestProvToneOn,(data.timingError{:,1}*1000-diffNearestProvToneOn), data.timingError{:,2}*1000-(data.timingError{:,1}*1000),(data.timingError{:,2}*1000-diffNearestProvToneOn)); % cols: [target matlab TH matlab-TH target-matlab]
%         compareTHtoML.Properties.VariableNames ={'Target','Matlab','TriggerHub','Matlab_minus_TriggerHub','Target_minus_Matlab','Target_minus_TriggerHub'};
%         
%         %% take out black stars if they have pink ones
%         
%         clear stars idxWordsOn_only2
%         idxWordsOn_only2 = idxWordsOn_only;
%         for ii = 1:length(idxWordsOn_only2)
%             for kk = 1:length(valNearestProvTone)
%                 if idxWordsOn(ii) == valNearestProvTone(kk) % if there are no pink stars at that location
%                     idxWordsOn_only2(ii) = 0; % black stars go to 0
%                 end
%             end
%         end
%         idxWordsOn_only2 = nonzeros(idxWordsOn_only2); % new black stars
%         
%         %% find the difference between each black and blue star (words and tones detected by the TH)
%         clear absValnonProv minValnonProv idxMinValnonProv
%         for ii = 1:length(idxWordsOn_only)
%             for kk = 1:length(idxTonesOn)
%                 absValnonProv(ii,kk) = abs(idxTonesOn(kk)-idxWordsOn_only(ii));
%                 [minValnonProv(ii) idxMinValnonProv(ii)] = min(absValnonProv(ii,:));
%             end
%         end
%         
%         clear absValnonProv minValnonProv_easy idxMinValnonProv_easy
%         for ii = 1:length(idxWordsOn_easy)
%             for kk = 1:length(idxTonesOn)
%                 absValnonProv(ii,kk) = abs(idxTonesOn(kk)-idxWordsOn_easy(ii));
%                 [minValnonProv_easy(ii) idxMinValnonProv_easy(ii)] = min(absValnonProv(ii,:));
%             end
%         end
%         
%         clear absValnonProv minValnonProv_hard idxMinValnonProv_hard
%         for ii = 1:length(idxWordsOn_hard)
%             for kk = 1:length(idxTonesOn)
%                 absValnonProv(ii,kk) = abs(idxTonesOn(kk)-idxWordsOn_hard(ii));
%                 [minValnonProv_hard(ii) idxMinValnonProv_hard(ii)] = min(absValnonProv(ii,:));
%             end
%         end
%         clear nearestToneNonProv
%         for ii = 1:length(idxMinValnonProv)
%             nearestToneNonProv(ii) = idxTonesOn(idxMinValnonProv(ii));
%         end
%        
%          clear nearestToneNonProv_easy
%         for ii = 1:length(idxMinValnonProv_easy)
%             nearestToneNonProv_easy(ii) = idxTonesOn(idxMinValnonProv_easy(ii));
%         end
%        
%          clear nearestToneNonProv_hard
%         for ii = 1:length(idxMinValnonProv_hard)
%             nearestToneNonProv_hard(ii) = idxTonesOn(idxMinValnonProv_hard(ii));
%         end
%        
%         %% find the difference between each magenta and blue star (words and tones detected by the TH) and choose the closest blue star
%         
%         clear absValProv minValProv idxMinValProv
%         for ii = 1:length(valNearestProvTone)
%             for kk = 1:length(idxTonesOn)
%                 absValProv(ii,kk) = abs(idxTonesOn(kk)-valNearestProvTone(ii));
%                 [minValProv(ii) idxMinValProv(ii)] = min(absValProv(ii,:));
%             end
%         end
%         
%         clear nearestToneProv
%         for ii = 1:length(idxMinValProv)
%             nearestToneProv(ii) = idxTonesOn(idxMinValProv(ii));
%         end
%         
%         
%         %% take out blue stars if they have magenta circles
%         
%         clear stars idxTonesOn_only
%         idxTonesOn_only = idxTonesOn;
%         for ii = 1:length(idxTonesOn)
%             for kk = 1:length(audioTarget)
%                 if idxTonesOn(ii) == audioTarget(kk) % if there are no pink stars at that location
%                     idxTonesOn_only(ii) = 0; % black stars go to 0
%                 elseif idxTonesOn(ii) == nearestToneNonProv_easy(kk) 
%                     idxTonesOn_only(ii) = 0;
%                 elseif idxTonesOn(ii) == nearestToneNonProv_hard(kk)
%                     idxTonesOn_only(ii) = 0;
%                 elseif idxTonesOn(ii) == stroopTarget(kk)
%                     idxTonesOn_only(ii) = 0;
%                 end
%             end
%         end
%         idxTonesOn_only = nonzeros(idxTonesOn_only); % new black stars
%         
%         %%
%         figure
%         plot(word)
%         ylabel('word')
%         hold on
%         plot(idxSStart2,ones(1,20),'m+') % when the Prov word should have started
%         plot(idxSEnd,ones(1,20),'k+') % approx when the Prov word should have started ended
%         plot(idxTonesOn_only,ones(1,numel(idxTonesOn_only)),'b*') % tone detected by Trigger Hub
%         plot(idxWordsOn_only,ones(1,numel(idxWordsOn_only)),'k*') % word detected by Trigger Hub (idxWordOn but only the nonProv)
%         plot(valNearestProvTone,ones(1,numel(valNearestProvTone)),'m*') % when the prov word started, as detected by the Trigger Hub
%         plot(nearestToneNonProv,ones(1,numel(nearestToneNonProv)),'c*') % nearest nonProv tone
%         plot(nearestToneProv,ones(1,numel(nearestToneProv)),'g*') % nearest Prov tone as detected by the Trigger Hub
%         plot(audioTarget,ones(1,numel(audioTarget)),'mo')
%         plot(stroopTarget,ones(1,numel(stroopTarget)),'bo')
% %         labelpoints(audioTarget,ones(1,numel(audioTarget)),num2str(7),'N')
% %             labelpoints(stroopTarget,ones(1,numel(stroopTarget)),num2str(1),'N',.15)
% %         labelpoints(nearestToneNonProv,ones(1,numel(nearestToneNonProv)),num2str(6),'N')
% %         labelpoints(idxTonesOn_only,ones(1,numel(idxTonesOn_only)),num2str(5),'N')
% %         labelpoints(idxWordsOn_only,ones(1,numel(idxWordsOn_only)),num2str(8),'N')
%         ylim([-.15 1.15])
%         
%         
%         %% find difference
%         clear delayNonProvWordToTone
%         for ii = 1:length(nearestToneNonProv)
%             delayNonProvWordToTone(ii) = (nearestToneNonProv(ii)-idxWordsOn_only(ii)).*1000/300;
%         end
%         
%         %% Label Tones
%         
%         ToneLabel = zeros(length(Event),1);
%         for ii = 1:length(idxTonesOn_only)
%             ToneLabel(idxTonesOn_only(ii)) = 3; % non-stroop non-target (blue star)
%         end
%         for ii = 1:length(nearestToneNonProv)
%             ToneLabel(nearestToneNonProv(ii)) = 2; % stroop non-target (cyan star)
%         end
%         for ii = 1:length(nearestToneProv)
%             ToneLabel(stroopTarget(ii)) = 1; % stroop target (green star) (used to be nearestToneProv)
%         end
%         for ii = 1:length(audioTarget)
%             ToneLabel(audioTarget(ii)) = 4; % non-stroop target (magenta circle)
%         end
%         
%         numel(find(ToneLabel==4));
%         
%         %% check delays
% %         toneToWordDelay = idxWordsOn_only'-nearestToneNonProv(1:end); %cyan star to black star)
% %         toneToWordDelay(8:15:end) = 0;
% %         toneToWordDelay = nonzeros(toneToWordDelay);
% %         figure;plot(toneToWordDelay,'.')
% %         [mean(toneToWordDelay)*1000/300 std(toneToWordDelay)*1000/(300*sqrt(numel(toneToWordDelay)))];
% %         
% %         allDev = abs(toneToWordDelay-mean(toneToWordDelay));
% %         mean(allDev)*1000/300;
% %         % figure;histogram(toneToWordDelay,200)
% %         
% %         for ii = 1:numel(toneToWordDelay)
% %             if toneToWordDelay(ii) < 200
% %                 toneToWordDelay_2(ii) = 0;
% %             else
% %                 toneToWordDelay_2(ii) = toneToWordDelay(ii);
% %             end
% %         end
% %         [mean(nonzeros(toneToWordDelay_2))*10/3 std(nonzeros(toneToWordDelay_2))*10/3];
% %         % figure; histogram(nonzeros(toneToWordDelay_2)*10/3)
% %         toneToWordDelay_2NZ = nonzeros(toneToWordDelay_2)*10/3;pd = fitdist(toneToWordDelay_2NZ ,'Normal');
%         %% check delays pt 2
% %         toneToToneDelay = idxTonesOn_only(2:end)-idxTonesOn_only(1:end-1); %(blue star to blue star) (nonprov tone to nonprovtone)
% %         toneToToneDelay(toneToToneDelay > 600) = 0; %
% %         toneToToneDelay = nonzeros(toneToToneDelay);
% %         % figure;plot(toneToToneDelay,'.-')
% %         % [mean(toneToToneDelay)*1000/300 std(toneToToneDelay)*1000/(300*sqrt(numel(toneToToneDelay)))]
% %         
% %         allDev = abs(toneToToneDelay-mean(toneToToneDelay));
% %         % mean(allDev)*1000/300
% %         % figure;histogram(toneToToneDelay,200)
% %         
% %         for ii = 1:numel(toneToToneDelay)
% %             if toneToToneDelay(ii) < 530
% %                 toneToToneDelay_2(ii) = 0;
% %             else
% %                 toneToToneDelay_2(ii) = toneToToneDelay(ii);
% %             end
% %         end
% %         [mean(nonzeros(toneToToneDelay_2))*10/3 std(nonzeros(toneToToneDelay_2))*10/3];
% %         % figure; histogram(nonzeros(toneToToneDelay_2)*10/3)
% %         toneToToneDelay_2NZ = nonzeros(toneToToneDelay_2)*10/3;pd = fitdist(toneToToneDelay_2NZ ,'Normal');
%         
%         %% check delays pt 3: black star to black star
% %         nonStroopToNonStroop = idxWordsOn_only(2:end)-idxWordsOn_only(1:end-1); %(black star to black star) (nonprov stroop to nonprov stroop)
% %         nonStroopToNonStroop(nonStroopToNonStroop > 1200) = 0; %
% %         nonStroopToNonStroop(nonStroopToNonStroop < 1038) = 0; %
% %         nonStroopToNonStroop = nonzeros(nonStroopToNonStroop);
% %         % figure;plot(nonStroopToNonStroop,'.-')
% %         
% %         % figure; histogram(nonStroopToNonStroop*10/3)
% %         % nonStroopToNonStroop_2NZ = nonStroopToNonStroop*10/3;pd = fitdist(nonStroopToNonStroop_2NZ ,'Normal')
% %         
%         %%
%         cd(folder)
%         toneLabel = strrep(stroop_data,'.mat','_ToneLabel.txt');
%         dlmwrite(toneLabel,ToneLabel,'delimiter','\t','newline','pc');
%         
%         %%
%         toneCategory = zeros(length(nearestToneProv),1);
%         timingError = table2array(data.timingError(:,2));
%         for ii = 1:length(toneCategory)
%             if timingError(ii) < 0
%                 if congruences(ii) == 0
%                     toneCategory(ii) = 1;
%                 elseif congruences(ii) == 1
%                     toneCategory(ii) = 5;
%                 end
%             elseif timingError(ii) == 0
%                 if congruences(ii) == 0
%                     toneCategory(ii) = 2;
%                 elseif congruences(ii) == 1
%                     toneCategory(ii) = 6;
%                 end
%             elseif timingError(ii) > 0
%                 if timingError(ii) < .1
%                     if congruences(ii) == 0
%                         toneCategory(ii) = 3;
%                     elseif congruences(ii) == 1
%                         toneCategory(ii) = 7;
%                     end
%                 elseif timingError(ii) > .1
%                     if congruences(ii) == 0
%                         toneCategory(ii) = 4;
%                     elseif congruences(ii) == 1
%                         toneCategory(ii) = 8;
%                     end
%                 end
%             end
%         end
% %         timingError_all(:,i,mm) = table2array(data.timingError(:,2));
% %         toneCategory_all(:,i,mm)=toneCategory;
%         
%         
%         
%         
%         
%         
%         
%         
%         
%         
%         
%         
%         
%         
%         
%         
%         
%         
%         
%         
%         
%         %%
%         ToneLabelCat = zeros(length(Event),1);
%         for ii = 1:length(idxTonesOn_only)
%             ToneLabelCat(idxTonesOn_only(ii)) = 10; % audio non-targets (blue star)
%         end
% %         for ii = 1:length(nearestToneNonProv_easy)
% %             ToneLabelCat(nearestToneNonProv_easy(ii)) = 6; % stroop non-target (cyan star)
% %         end
%         for ii = 1:length(audioTarget)
%             ToneLabelCat(audioTarget(ii)) = 9; % audio target (magenta circle)
%         end
% %         for ii = 1:length(idxWordsOn_easy)
% %             ToneLabelCat(idxWordsOn_easy(ii)) = 8; % non-stroop target (black star)
% %         end
% %         for ii = 1:length(idxWordsOn_easy)
% %             ToneLabelCat(idxWordsOn_hard(ii)) = 9; % non-stroop target (black star)
% %         end
% %         for ii = 1:length(nearestToneNonProv_hard)
% %             ToneLabelCat(nearestToneNonProv_hard(ii)) = 10; % stroop non-target (cyan star)
% %         end
%         for ii = 1:length(nearestToneProv)
%             ToneLabelCat(stroopTarget(ii)) = toneCategory(ii);
%         end
%         % may also want valNearestProvTone (m*)
% %         [numel(find(ToneLabelCat==1)) numel(find(ToneLabelCat==2)) numel(find(ToneLabelCat==3)) numel(find(ToneLabelCat==4)) numel(find(ToneLabelCat==5)) numel(find(ToneLabelCat==6)) numel(find(ToneLabelCat==7)) numel(find(ToneLabelCat==8)) numel(find(ToneLabelCat==9)) numel(find(ToneLabelCat==10))]
%         [numel(find(ToneLabelCat==1)) numel(find(ToneLabelCat==2)) numel(find(ToneLabelCat==3)) numel(find(ToneLabelCat==4)) numel(find(ToneLabelCat==5)) numel(find(ToneLabelCat==6)) numel(find(ToneLabelCat==7)) numel(find(ToneLabelCat==8)) numel(find(ToneLabelCat==9)) numel(find(ToneLabelCat==10))]
% 
% %%
%         figure
%         plot(tone)
%         ylabel('tone')
%         hold on
%         plot(idxSStart2,ones(1,20),'k+') % approx when the Prov word should have started ended
%         plot(idxTonesOn_only,ones(1,numel(idxTonesOn_only)),'b*') % tone detected by Trigger Hub
%         plot(audioTarget,ones(1,numel(audioTarget)),'mo')
%         plot(stroopTarget,ones(1,numel(stroopTarget)),'bo')
%         plot(nearestToneNonProv,ones(1,numel(nearestToneNonProv)),'go')
% %             plot(idxTonesOn_only,ones(1,numel(idxTonesOn_only)),'ko')
%         plot(idxWordsOn_only,ones(1,numel(idxWordsOn_only)),'m*')
% %         labelpoints(audioTarget,ones(1,numel(audioTarget)),num2str(7),'N')
% %         labelpoints(stroopTarget,ones(1,numel(stroopTarget)),num2str(1),'N')
% %         labelpoints(nearestToneNonProv_easy,ones(1,numel(nearestToneNonProv_easy)),num2str(6),'N')
% %         labelpoints(nearestToneNonProv_hard,ones(1,numel(nearestToneNonProv_hard)),num2str(10),'N')
% %         labelpoints(idxTonesOn_only,ones(1,numel(idxTonesOn_only)),num2str(5),'N')
% %         labelpoints(idxWordsOn_easy,ones(1,numel(idxWordsOn_easy)),num2str(8),'N')
% %         labelpoints(idxWordsOn_hard,ones(1,numel(idxWordsOn_hard)),num2str(9),'N')
%         plot(nearestToneNonProv_easy,ones(1,numel(nearestToneNonProv_easy)),'ro','MarkerSize',20)
%         plot(nearestToneNonProv_hard,ones(1,numel(nearestToneNonProv_hard)),'go','MarkerSize',20)
%         plot(idxTonesOn_only,ones(1,numel(idxTonesOn_only)),'bo','MarkerSize',20)
%         plot(idxWordsOn_easy,ones(1,numel(idxWordsOn_easy)),'co','MarkerSize',20)
%         plot(idxWordsOn_hard,ones(1,numel(idxWordsOn_hard)),'ko','MarkerSize',20)
%         ylim([-.15 1.15])
%         
%         %% plot to check
%         figure
%         plot(word)
%         ylabel('word')
%         hold on
%         plot(idxSStart2,ones(1,20),'k+') % approx when the Prov word should have started ended
%         plot(idxTonesOn_only,ones(1,numel(idxTonesOn_only)),'m*') % tone detected by Trigger Hub
%         plot(audioTarget,ones(1,numel(audioTarget)),'bo')
%         plot(stroopTarget,ones(1,numel(stroopTarget)),'g*')
%         %%
%         pause
%         cd(folder)
%         toneLabelCat = strrep(stroop_data,'.mat','_ToneLabelCat.txt');
%         dlmwrite(toneLabelCat,ToneLabelCat,'delimiter','\t','newline','pc');
%         
%         %% equalize number of trials
% %         rand5check = [5 5 5 5 0 0 0 0];
% %         rand5check_goal = [5 5 5 5 5 5 5 5];
% %         maxIter=100;
% %         
% %         for iter=1:maxIter
% %             % for n = 5 (assuming no artifact detection will be done)
% %             numelements = 5;
% %             % get the randomly-selected indices
% %             clear indices
% %             indices = randperm(length(idxTonesOn_only));
% %             indices = indices(1:numelements);
% %             % choose the subset of a you want
% %             idxTonesOn_only_5 = idxTonesOn_only(indices);
% %             
% %             clear indices
% %             indices = randperm(length(nearestToneNonProv));
% %             indices = indices(1:numelements);
% %             % choose the subset of a you want
% %             nearestToneNonProv_5 = nearestToneNonProv(indices);
% %             
% %             clear indices
% %             indices = randperm(length(audioTarget));
% %             indices = indices(1:numelements);
% %             % choose the subset of a you want
% %             audioTarget_5 = audioTarget(indices);
% %             
% %             clear indices
% %             indices = randperm(length(idxWordsOn_only));
% %             indices = indices(1:numelements);
% %             % choose the subset of a you want
% %             idxWordsOn_only_5 = idxWordsOn_only(indices);
% %             
% %             ToneLabelCatEq = zeros(length(Event),1);
% %             for ii = 1:length(idxTonesOn_only_5)
% %                 ToneLabelCatEq(idxTonesOn_only_5(ii)) = 5; % non-stroop non-target (blue star)
% %             end
% %             for ii = 1:length(nearestToneNonProv_5)
% %                 ToneLabelCatEq(nearestToneNonProv_5(ii)) = 6; % stroop non-target (cyan star)
% %             end
% %             for ii = 1:length(audioTarget_5)
% %                 ToneLabelCatEq(audioTarget_5(ii)) = 7; % non-stroop target (magenta circle)
% %             end
% %             for ii = 1:length(idxWordsOn_only_5)
% %                 ToneLabelCatEq(idxWordsOn_only_5(ii)) = 8; % non-stroop target (black star)
% %             end
% %             for ii = 1:length(nearestToneProv)
% %                 ToneLabelCatEq(stroopTarget(ii)) = toneCategory(ii);
% %             end
% %             
% %             rand5check = [numel(find(ToneLabelCatEq==1)) numel(find(ToneLabelCatEq==2)) numel(find(ToneLabelCatEq==3)) numel(find(ToneLabelCatEq==4)) numel(find(ToneLabelCatEq==5)) numel(find(ToneLabelCatEq==6)) numel(find(ToneLabelCatEq==7)) numel(find(ToneLabelCatEq==8))];
% %             
% %             if rand5check==rand5check_goal
% %                 break
% %             elseif iter == maxIter
% %                 warning('Max Iterations reached')
% %                 break
% %             end
% %         end
% %         disp(rand5check)
% %         
% %         %%
% %         cd('C:\Users\mswerdloff\Documents\MATLAB')
% %         figure
% %         plot(tone)
% %         ylabel('tone')
% %         hold on
% %         plot(idxSStart2,ones(1,20),'k+') % approx when the Prov word should have started ended
% %         % plot(idxTonesOn_only,ones(1,numel(idxTonesOn_only)),'b*') % tone detected by Trigger Hub
% %         plot(audioTarget_5,ones(1,numelements),'mo')
% %         plot(stroopTarget,ones(1,numel(stroopTarget)),'bo')
% %         plot(nearestToneNonProv_5,ones(1,numelements),'go')
% %         plot(idxTonesOn_only_5,ones(1,numelements),'ko')
% %         plot(idxWordsOn_only_5,ones(1,numelements),'k*')
% %         labelpoints(audioTarget_5,ones(1,numelements),num2str(7),'N',.15)
% %         labelpoints(stroopTarget,ones(1,numel(stroopTarget)),num2str(1),'N',.15)
% %         labelpoints(nearestToneNonProv_5,ones(1,numelements),num2str(6),'N',.15)
% %         labelpoints(idxTonesOn_only_5,ones(1,numelements),num2str(5),'N',.15)
% %         labelpoints(idxWordsOn_only_5,ones(1,numelements),num2str(8),'N',.15)
% %         ylim([-.15 1.15])
% %         
% %         %% toneLabelName = strrep(filename_alone,'.csv','_ToneLabel.txt');
% %         cd(folder)
% %         toneLabelCatEq = strrep(stroop_data,'.mat','_ToneLabelCatEq.txt');
% %         %     dlmwrite(toneLabelCatEq,ToneLabelCatEq,'delimiter','\t','newline','pc');
% %         mat_toneLabelCatEq = strrep('toneLabelCatEq','.txt','.mat');
% %         %     save(mat_toneLabelCatEq,'ToneLabelCatEq')
% %         
% toneChecks = stroopTarget-nearestToneProv;
% if sum(toneChecks) ~= 0
%     toneChecks
%     figure;plot(stroopTarget,ones(length(stroopTarget)),'m*');hold on; plot(nearestToneProv,ones(length(nearestToneProv)),'ko');plot(tone);hold off
%     fprintf('something is wrong!')
%     pause
% end
%         %% toneLabelName = strrep(filename_alone,'.csv','_ToneLabel.txt');
%         CompareTHtoML = strrep(stroop_data,'.mat','_CompareTHtoML.txt');
%         dlmwrite(CompareTHtoML,table2array(compareTHtoML),'delimiter','\t','newline','pc');
%         mat_compareTHtoML = strrep(CompareTHtoML,'.txt','.mat');
%         save(mat_compareTHtoML,'compareTHtoML')
%         
%     end
% end