for i = 1:numel(subs)
    %% load files
    sub = subs{i};
    numEasy=5;
    
    % import filenames
    stroop_data_sub = [sub '_v10.mat'];
    filename = [sub '_duration_raw.csv'] % keep open to show filename
    
    % save filenames
    stroop_data_sub_startStop = [sub '_v10_startStop.mat'];
    
    % specify times and channels then load dsi data
    startRow = 17; % time = 0
    endRow = inf; % time = end of trial
    [Time_duration,LE,F4,C4,P4,P3,C3,F3,Trigger_duration,Time_Offset,ADC_Status,ADC_Sequence,Event,Comments] = importRaw([loc_dsi filename], startRow, endRow); % import
    
    % load stroop test results
    data = load('-mat', [loc_stroopData stroop_data_sub]);
    startStops = [loc_save '\' sub '\' stroop_data_sub_startStop]; % save filename
    loc_sub = [loc_save '\' sub];
%     addpath(loc_sub)
    
    if isfile(startStops)
        startStop = load('-mat',startStops);
    else
        sprintf('you will have to specify cursor_info for startStops')
    end
%     cd(loc_scripts)
    
    congruences = data.congruences;
    pretoneson = data.pretoneson;
    pauseTimes = data.pauseTimes;
    startTime = data.startTime;
    endTime = data.endTime;
    
    %% label word and tone stimuli:
    
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
    
    %% plot word and tone
    figure
    subplot(211)
    plot(word)
    ylabel('word')
    subplot(212)
    plot(tone)
    ylabel('tone')
    
    %% import or save cursor data
    cd(loc_sub)
    if ~exist('startStop','var')
        pause
        sprintf('select then save cursor_info!')
        save(stroop_data_sub_startStop,'cursor_info'); 
    else
        cursor_info = startStop.cursor_info;
    end
    cd(loc_scripts)
    
    %% calculate durations
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
    
    
    for ii = 1:length(tone)-1
        if tone(ii) == 1 && tone(ii+1) == 0
            toneOffset(ii+1) = ii+1;
        end
    end
    idxTonesOff = find(toneOffset);
    
    
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
    else
        plot(idxTonesOn,[fakeTones_tto],'b*') % Target Tone-only
        plot(idxTonesOn,[fakeTones_easy],'m*') % Target word (Hard)
        plot(idxTonesOn,[fakeTones_hard],'c*') % Non-Target Target word (Easy)
    end
    %% specify type of tone and word
    idxTonesOn_only = []; idxTonesOff_only = [];
    idxTonesOn_only_startIdx = [0 find(expList(2:end))*10];
%     idxTonesOn_only_startIdx(1) = 1;
    for ii = 1:numel(idxTonesOn_only_startIdx)
        toneStartIdx = idxTonesOn_only_startIdx(ii);
        idxTonesOn_only(:,ii) = idxTonesOn(toneStartIdx+1:toneStartIdx+10);
        idxTonesOff_only(:,ii) = idxTonesOff(toneStartIdx+1:toneStartIdx+10);
    end
    
    figure
    plot(word)
    ylabel('word')
    hold on
    plot(idxTonesOn,ones(1,numel(idxTonesOn)),'ko')
    plot(idxTonesOff,ones(1,numel(idxTonesOff)),'k+')
    plot(idxTonesOn_only(:),ones(1,numel(idxTonesOn_only)),'ro')
    plot(idxTonesOff_only(:),ones(1,numel(idxTonesOff_only)),'r+')
    plot(idxWordsOn,ones(1,numel(idxWordsOn)),'co')
    plot(idxWordsOff,ones(1,numel(idxWordsOff)),'co')
    plot(idxTonesOn_only(:),ones(1,numel(idxTonesOn_only)),'ro')
    plot(idxTonesOff_only(:),ones(1,numel(idxTonesOff_only)),'r+')
%     plot(idxTonesOn,[fakeTones_tto],'b*') % Target Tone-only
%     plot(idxTonesOn,[fakeTones_easy],'m*') % Target word (Hard)
%     plot(idxTonesOn,[fakeTones_hard],'c*') % Non-Target Target word (Easy)
    %% find intervals
    word_int = [];
    for ii = 1:numel(idxWordsOn)-1
        word_int(ii) = idxWordsOn(ii+1) - idxWordsOff(ii);
    end
    
    tone_int = [];
    for ii = 1:numel(idxTonesOn)-1
        tone_int(ii) = idxTonesOn(ii+1) - idxTonesOff(ii);
    end
    
    tonesOnly_int = [];
    for ii = 1:numel(idxTonesOn)-1
        tonesOnly_int(ii) = idxTonesOn_only(ii+1) - idxTonesOff_only(ii);
    end
    
    figure()
    subplot(2,1,1)
    plot(word_int,'.')
    ylim([0,4000])
    ylabel('word interval')
    subplot(2,1,2)
    plot(tone_int,'.')
    ylim([0,1500])
    ylabel('tone interval')
    xlabel('index')
  
    figure
    plot(tonesOnly_int,'.')
    ylim([0,1500])
    ylabel('tones Only interval')
    xlabel('index')
    %% identify errors
    tone_flag = zeros(numel(tone_int),1);
    for ii = 1:numel(tone_int)
        if tone_int(ii) < 300
            tone_flag(ii) = 1;
        else 
            tone_flag(ii) = 2;
        end
    end
    
    idxtone_flag = find(tone_flag == 1);    

    tonesOnly_flag = zeros(numel(tonesOnly_int),1);
    for ii = 1:numel(tonesOnly_int)
        if tonesOnly_int(ii) > 300
            tonesOnly_flag(ii) = 1;
        else 
            tonesOnly_flag(ii) = 2;
        end
    end
    
    idxtonesOnly_flag = find(tonesOnly_flag == 1);
    
    word_flag = zeros(numel(word_int),1);
    for ii = 1:numel(word_int)
        if word_int(ii) < 450
            word_flag(ii) = 1;
        else 
            word_flag(ii) = 2;
        end
    end
    
    idxword_flag = find(word_flag == 1);

    %
    figure
    plot(word)
    ylabel('word')
    hold on
    plot(idxTonesOn,ones(1,numel(idxTonesOn)),'ko')
    plot(idxTonesOff,ones(1,numel(idxTonesOff)),'k+')
    plot(idxWordsOn,ones(1,numel(idxWordsOn)),'co')
    plot(idxWordsOff,ones(1,numel(idxWordsOff)),'co')
    if isempty(idxtone_flag) == 0
%         for ii = 1:numel(idxtone_flag)
%             plot(idxTonesOff(idxtone_flag(ii)),1,'r*')
%             plot(idxTonesOn(idxtone_flag(ii)),1,'r*')
%         end
        for ii = 1:numel(idxtonesOnly_flag)
            plot(idxTonesOff_only(idxtonesOnly_flag(ii)),1,'ro')
            plot(idxTonesOn_only(idxtonesOnly_flag(ii)),1,'ro')
        end
    end
        if isempty(idxword_flag) == 0
%         for ii = 1:numel(idxword_flag)
%             plot(idxWordsOff(idxword_flag(ii)),1,'r*')
%             plot(idxWordsOn(idxword_flag(ii)),1,'r*')
%         end
    end
%     xlim([idxTonesOff(idxtone_flag(1))-5000 idxTonesOff(idxtone_flag(1))+5000])
    %% fix errors in stimuli
    if strfind(sub,'S027_SA')==1
        idxWordsOn(1) = 0;
        idxWordsOn(2) = 0;
        idxWordsOff(1) = 0;
        idxWordsOff(2) = 0;
    end
    %% create major matrix with all stim
    
    % fix fakeTones
    if strfind(sub,'S024_SA')==1
        fakeTones_tto2 = [0 fakeTones_tto];
        fakeTones_easy2 = [0 fakeTones_easy];
        fakeTones_hard2 = [0 fakeTones_hard];
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
    cd(loc_save)
    toneLabel = strrep(stroop_data_sub,'.mat','_ToneLabel.txt');
    %         dlmwrite(toneLabel,ToneLabel,'delimiter','\t','newline','pc');
    %%
end

sprintf('Troubleshooting complete!')