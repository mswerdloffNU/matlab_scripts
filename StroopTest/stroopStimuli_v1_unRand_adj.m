%% Set stimuli to be sent right before, at, after the stroop tests are LAUNCHED

clearvars
close all

startTime_beginning = clock;
ntotal = 4*5; % number of repeats ( = prov times), must be a multiple of 4
sprintf('start')

%% Set stroop tests at these times

% stimuli appear every  1000 +/- 375 ms (random number between 625 and 1376)
clear nextTime actualTime provTimes provTime_prior provTime_after provTime_select
global words;
words = ['YELLOW ';'PINK   ';'GRAY   ';'RED    ';'GREEN  ';'BLUE   ';'BLACK  ']; %1
global colors;
colors = [1 1 0;1 0 1;.66 .66 .66;1 0 0;0 1 0;0 0 1;0 0 0]; %2
yellow = colors(1,:);
pink = colors(2,:);
gray = colors(3,:);
red = colors(4,:);
green = colors(5,:);
blue = colors(6,:);
black = colors(7,:);
FigHdl = 1;
numBase = 10; % number of tones before stroop trials start
numEasy = 7*size(colors,1)*1/7;  % number of easy trials (congruent)
numHard = 7*size(colors,1)*1/7; % number of hard trials (incongruent)
numProv = 1; % number of prov tones in each round
rt = 1.0827; % reaction time (user-specific?)
stroopTimeEasy = 1.3*rt; % how long you get to answer the question
stroopTimeHard = 1.75*rt;
%     stroopTime = stroopTimeEasy;
provTimes = [-.175*rt 0 .175*rt 0.35*rt]; % amount of time between the proverbial tone and the 1st hard stroop test

%% Create initiation box
initiationBox = 1; % set to 1 to turn on

if initiationBox == 1
    
    FigHandle = figure('Visible','On');                    % Create an invisible figure now to use UserData field
    pause(0.00001)
    frame_h = get(handle(gcf),'JavaFrame');
    set(frame_h,'Maximized',1);
    prompt = {'Enter User ID:','Enter Test Number:','Location to save data:'};
    dlgTitle = 'Test Data';
    numLines = 1;
    defs = {'AB00','Test 2 unRand_adj','Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\StroopTestResults\Troubleshooting\'};
    answers = inputdlg(prompt,dlgTitle,numLines,defs);
    
    if isempty(strcmp(answers,'{}'))
        error('err:testStat','Please input the test statistics');
    else
        % Change directory path if provided by the user
        if (~isempty(answers(3)))
            dataDirPath = char(answers(3));
        end
        set(FigHandle,'UserData',struct('userID',answers(1),...
            'PhaseNum',answers(2),...
            'dataDirPath',dataDirPath,...
            'setFigProps',1));
    end
end

%% Categorize prov times

% create two separate lists: prov times that are before, and prov times
% that are after the stroop tests
nA = 0; nB = 0;
for i = 1:length(provTimes)
    if provTimes(i) > 0
        nA = nA+1;
        provTime_after(nA) = provTimes(i);
    else
        nB = nB+1;
        provTime_prior(nB) = provTimes(i);
    end
end

% create list of prov times in a random order
C = [provTime_prior, provTime_after];
provTime = zeros(1,ntotal);
outx = zeros(numel(C),(ntotal/numel(C)));
for ii = 1:(ntotal/numel(C))
    [~, outidx] = sort(rand(1,numel(C))); % randomize the order here
    outx(:,ii) = outidx;
end
outx = outx(:);

% select the next provTime
for jj = 1:ntotal
    idx = outx(jj);
    checkPrior = find(provTime_prior==C(idx));
    provTime(jj) = C(idx);
end

%% Play all

for n = 1:ntotal % must be a multiple of 4
    % decide whether prov tone should come before or after the prov stroop
    clear provTime_select
    if provTime(n) <= 0
        provTime_select = provTime_prior;
        timing = 1;
    else
        provTime_select = provTime_after;
        timing = 2;
    end
    
    % if prov time is less than or equal to 0, play it here
    if timing == 1 % provTime_prior
        
        nextTone(:,:,n) = make_wav_file_MMS_unRand_adj(numBase,3)
        
        [stroopFigHdl0,box] = StroopTest(words,colors,1,1,1);
        % Figure Modification starts for next cycle
        delete(findobj(stroopFigHdl0,'Tag','StroopString'));                                % Delete the StroopString by finding the text
        set(box,'visible','off')
        btnGrpObj = findobj(stroopFigHdl0,'Tag','existingBtnGrp');                          % Find the buttongroup object
        set(get(btnGrpObj,'Children'),'Enable','Inactive');                                 % Deactivate the buttons until next figures appears
        %         hBtnGrp = findobj(stroopFigHdl0,'Tag','existingBtnGrp');                  % Get the buttongroup handle
        %         set(hBtnGrp,'SelectedObject',[]);                                         % Display No Selection on radio buttons
        dataStroopBL{1,n} = get(stroopFigHdl0,'userdata');
        
        for ii = 1:numEasy
%             nextTime(ii) = (randi([625 1376])*.001);
            nextTime(ii) = (randi([1288 1288])*.001);
            pause(nextTime(ii))
            startTime = tic;
            make_wav_file_MMS_unRand_adj(1,4)
            [stroopFigHdl1,box] = StroopTest(words,colors,1,1,1);
            actualTime(ii) = toc(startTime);
            pause(stroopTimeEasy)
            % Figure Modification starts for next cycle
            delete(findobj(stroopFigHdl1,'Tag','StroopString'));                            % Delete the StroopString by finding the text
            set(box,'visible','off')
            btnGrpObj = findobj(stroopFigHdl1,'Tag','existingBtnGrp');                      % Find the buttongroup object
            set(get(btnGrpObj,'Children'),'Enable','Inactive');                             % Deactivate the buttons until next figures appears
            %             hBtnGrp = findobj(stroopFigHdl1,'Tag','existingBtnGrp');          % Get the buttongroup handle
            %             set(hBtnGrp,'SelectedObject',[]);                                 % Display No Selection on radio buttons
            dataStroopEasy{ii,n} = get(stroopFigHdl1,'userdata');
        end
        pause(1)
        make_wav_file_MMS_unRand_adj(1,1) % proverbial tone
        startProv(n) = tic;
        if provTime(n) ~= 0
            pause(abs(provTime(n)))
        end
        [stroopFigHdl2,actualProv(n),~,box] = StroopTest_withBox(words,colors,0,1,1,startProv(n));
        actualProv(n) = -actualProv(n);
        pause(stroopTimeHard)
        % Figure Modification starts for next cycle
        delete(findobj(stroopFigHdl2,'Tag','StroopString'));                                % Delete the StroopString by finding the text
        set(box,'visible','off')
        btnGrpObj = findobj(stroopFigHdl2,'Tag','existingBtnGrp');                          % Find the buttongroup object
        set(get(btnGrpObj,'Children'),'Enable','Inactive');                                 % Deactivate the buttons until next figures appears
        %         hBtnGrp = findobj(stroopFigHdl2,'Tag','existingBtnGrp');                  % Get the buttongroup handle
        %         set(hBtnGrp,'SelectedObject',[]);                                         % Display No Selection on radio buttons
        dataStroopProv{1,n} = get(stroopFigHdl2,'userdata');
        
        for ii = ii+1:ii+numHard
%             nextTime(ii) = (randi([625 1376])*.001);
            nextTime(ii) = (randi([1288 1288])*.001);
            pause(nextTime(ii))
            startTime = tic;
            make_wav_file_MMS_unRand_adj(1,4)
            [stroopFigHdl3,box] = StroopTest(words,colors,0,1,1);
            actualTime(ii) = toc(startTime);
            pause(stroopTimeHard)
            % Figure Modification starts for next cycle
            delete(findobj(stroopFigHdl3,'Tag','StroopString'));                            % Delete the StroopString by finding the text
            set(box,'visible','off')
            btnGrpObj = findobj(stroopFigHdl3,'Tag','existingBtnGrp');                      % Find the buttongroup object
            set(get(btnGrpObj,'Children'),'Enable','Inactive');                             % Deactivate the buttons until next figures appears
            %             hBtnGrp = findobj(stroopFigHdl3,'Tag','existingBtnGrp');          % Get the buttongroup handle
            %             set(hBtnGrp,'SelectedObject',[]);                                 % Display No Selection on radio buttons
            dataStroopHard{ii-numEasy,n} = get(stroopFigHdl3,'userdata');
        end
        
        % else, if prov time is greater than 0, play it here
    elseif timing == 2 % provTime_after
        
        nextTone(:,:,n) = make_wav_file_MMS_unRand_adj(numBase,3)
        
        [stroopFigHdl0,box] = StroopTest(words,colors,1,1,1);
        % Figure Modification starts for next cycle
        delete(findobj(stroopFigHdl0,'Tag','StroopString'));                                % Delete the StroopString by finding the text
        set(box,'visible','off')
        btnGrpObj = findobj(stroopFigHdl0,'Tag','existingBtnGrp');                          % Find the buttongroup object
        set(get(btnGrpObj,'Children'),'Enable','Inactive');                                 % Deactivate the buttons until next figures appears
        %         hBtnGrp = findobj(stroopFigHdl0,'Tag','existingBtnGrp');                  % Get the buttongroup handle
        %         set(hBtnGrp,'SelectedObject',[]);                                         % Display No Selection on radio buttons
        dataStroopBL{1,n} = get(stroopFigHdl0,'userdata');
        
        for ii = 1:numEasy
%             nextTime(ii) = (randi([625 1376])*.001);
            nextTime(ii) = (randi([1288 1288])*.001);
            pause(nextTime(ii))
            startTime = tic;
            make_wav_file_MMS_unRand_adj(1,4)
            [stroopFigHdl1,box] = StroopTest(words,colors,1,1,1);
            actualTime(ii) = toc(startTime);
            pause(stroopTimeEasy)
            % Figure Modification starts for next cycle
            delete(findobj(stroopFigHdl1,'Tag','StroopString'));                            % Delete the StroopString by finding the text
            set(box,'visible','off')
            btnGrpObj = findobj(stroopFigHdl1,'Tag','existingBtnGrp');                      % Find the buttongroup object
            set(get(btnGrpObj,'Children'),'Enable','Inactive');                             % Deactivate the buttons until next figures appears
            %             hBtnGrp = findobj(stroopFigHdl1,'Tag','existingBtnGrp');          % Get the buttongroup handle
            %             set(hBtnGrp,'SelectedObject',[]);                                 % Display No Selection on radio buttons
            dataStroopEasy{ii,n} = get(stroopFigHdl1,'userdata');
        end
        
        pause(1)
        make_wav_file_MMS_unRand_adj(1,1) % proverbial tone
        startProv(n) = tic;
        [stroopFigHdl2,~,startProv(n),box] = StroopTest_withBox(words,colors,0,1,1,startProv(n));
        pause(provTime(n))
        actualProv(n) = toc(startProv(n));
        pause(stroopTimeHard-provTime(n))
        % Figure Modification starts for next cycle
        delete(findobj(stroopFigHdl2,'Tag','StroopString'));                                % Delete the StroopString by finding the text
        set(box,'visible','off')
        btnGrpObj = findobj(stroopFigHdl2,'Tag','existingBtnGrp');                          % Find the buttongroup object
        set(get(btnGrpObj,'Children'),'Enable','Inactive');                                 % Deactivate the buttons until next figures appears
        %         hBtnGrp = findobj(stroopFigHdl2,'Tag','existingBtnGrp');                  % Get the buttongroup handle
        %         set(hBtnGrp,'SelectedObject',[]);                                         % Display No Selection on radio buttons
        dataStroopProv{1,n} = get(stroopFigHdl2,'userdata');
        
        for ii = ii+1:ii+numHard
%             nextTime(ii) = (randi([625 1376])*.001);
            nextTime(ii) = (randi([1288 1288])*.001);
            pause(nextTime(ii))
            startTime = tic;
            make_wav_file_MMS_unRand_adj(1,4)
            [stroopFigHdl3,box] = StroopTest(words,colors,0,1,1);
            actualTime(ii) = toc(startTime);
            pause(stroopTimeHard)
            % Figure Modification starts for next cycle
            delete(findobj(stroopFigHdl3,'Tag','StroopString'));                            % Delete the StroopString by finding the text
            set(box,'visible','off')
            btnGrpObj = findobj(stroopFigHdl3,'Tag','existingBtnGrp');                      % Find the buttongroup object
            set(get(btnGrpObj,'Children'),'Enable','Inactive');                             % Deactivate the buttons until next figures appears
            %             hBtnGrp = findobj(stroopFigHdl3,'Tag','existingBtnGrp');          % Get the buttongroup handle
            %             set(hBtnGrp,'SelectedObject',[]);                                 % Display No Selection on radio buttons
            dataStroopHard{ii-numEasy,n} = get(stroopFigHdl3,'userdata');
        end
        
    else
        sprintf('error in determining timing of provTime')
    end
    
end

endTime = clock;

%% data analysis
% dataStroopProv = data.Prov;
% dataStroopEasy = data.Easy;
% dataStroopHard = data.Hard;
totalTime = etime(endTime,startTime_beginning);

times = [actualProv',provTime',(actualProv-provTime)'];

inputsEasy = cell(numEasy,ntotal);
for ii = 1:numEasy
    for nn = 1:ntotal
            clear fakeEnd
            fakeEnd = datevec(duration(dataStroopEasy{ii,nn}.timeStart(4:6))+duration([0,0,1]));
            dataStroopEasy{ii,nn}.timeEnd = [dataStroopEasy{ii,nn}.timeStart(1:3) fakeEnd(4:6)];
        if ~dataStroopEasy{ii,nn}.choice
            dataStroopEasy{ii,nn}.guess = 0; % enter 0 if no choice was selected
        elseif strcmp(dataStroopEasy{ii,nn}.choice,dataStroopEasy{ii,nn}.inputWord)==1
            dataStroopEasy{ii,nn}.guess = 1; % enter 1 if the guess was correct; 0 if incorrect
        else dataStroopEasy{ii,nn}.guess = 0;
        end
        % calculate elapsed time (in seconds)
        if isempty(dataStroopEasy{ii,nn}.choice) == 0
            dataStroopEasy{ii,nn}.eltime = etime(dataStroopEasy{ii,nn}.timeEnd,dataStroopEasy{ii,nn}.timeStart);
        else
            dataStroopEasy{ii,nn}.eltime = NaN;
        end
    end
end

% For the Easy trials, calculate scores and skips and then average them
data.scoresEasy = zeros(numEasy,ntotal); data.eltimesEasy = zeros(numEasy,ntotal); data.skippedEasy = zeros(numEasy,ntotal);
for ii = 1:numEasy
    for nn = 1:ntotal
        data.scoresEasy(ii,nn) = dataStroopEasy{ii,nn}.guess;
        data.eltimesEasy(ii,nn) = dataStroopEasy{ii,nn}.eltime;
        if isnan(data.eltimesEasy(ii,nn)) == 1
            data.skippedEasy(ii,nn) = 1;
        end
    end
end
data.scoreEasy = nansum(data.scoresEasy,1)/numEasy;
data.scoreEasyAvg = nanmean(data.scoreEasy);
data.eltimeEasy = nanmean(data.eltimesEasy);
data.eltimeEasyAvg = nanmean(data.eltimeEasy);
data.skipsEasy = sum(data.skippedEasy(:));

% For the Hard trials, first categorize answers as correct/incorrect
inputsHard = cell(numHard,ntotal);
q = char(39);
for ii = 1:numHard
    for nn = 1:ntotal
            clear fakeEnd
            fakeEnd = datevec(duration(dataStroopHard{ii,nn}.timeStart(4:6))+duration([0,0,1]));
            dataStroopHard{ii,nn}.timeEnd = [dataStroopHard{ii,nn}.timeStart(1:3) fakeEnd(4:6)];        
            % first assign what color the answer was
        dataStroopHard{ii,nn}.choice = strrep(dataStroopHard{ii,nn}.choice,q,''); % remove any quotes (just in case)
        dataStroopHard{ii,nn}.ogchoice = dataStroopHard{ii,nn}.choice; % save variables without quotes
        dataStroopHard{ii,nn}.choice = strcat(q,dataStroopHard{ii,nn}.choice,q); % put in quotes
        if strcmp(dataStroopHard{ii,nn}.choice,strcat(q,'YELLOW',q))==1
            dataStroopHard{ii,nn}.colorChoice = yellow;
        elseif strcmp(dataStroopHard{ii,nn}.choice,strcat(q,'GREEN',q))==1
            dataStroopHard{ii,nn}.colorChoice = green;
        elseif strcmp(dataStroopHard{ii,nn}.choice,strcat(q,'RED',q))==1
            dataStroopHard{ii,nn}.colorChoice = red;
        elseif strcmp(dataStroopHard{ii,nn}.choice,strcat(q,'PINK',q))==1
            dataStroopHard{ii,nn}.colorChoice = pink;
        elseif strcmp(dataStroopHard{ii,nn}.choice,strcat(q,'GRAY',q))==1
            dataStroopHard{ii,nn}.colorChoice = gray;
        elseif strcmp(dataStroopHard{ii,nn}.choice,strcat(q,'BLUE',q))==1
            dataStroopHard{ii,nn}.colorChoice = blue;
        elseif strcmp(dataStroopHard{ii,nn}.choice,strcat(q,'BLACK',q))==1
            dataStroopHard{ii,nn}.colorChoice = black;
        else
            dataStroopHard{ii,nn}.colorChoice = [1 1 1]; % this will apply if no choice was selected
        end
        % now decide whether that color was correct
        if ~dataStroopHard{ii,nn}.choice
            dataStroopHard{ii,nn}.guess = 0; % 0 if no choice was selected
        elseif dataStroopHard{ii,nn}.colorChoice == dataStroopHard{ii,nn}.inputColor
            dataStroopHard{ii,nn}.guess = 1; % 1 if guess was correct
        else
            dataStroopHard{ii,nn}.guess = 0; % 0 if incorrect
        end
        % measure elapsed time (in seconds)
        inputsHard{ii,nn} = dataStroopHard{ii,nn}.choice;
        if sum(dataStroopHard{ii,nn}.colorChoice) < 3
            dataStroopHard{ii,nn}.eltime = etime(dataStroopHard{ii,nn}.timeEnd,dataStroopHard{ii,nn}.timeStart);
        else
            dataStroopHard{ii,nn}.eltime = NaN;
        end
    end
end

% For the Hard trials, calculate scores and skips and then average them
data.scoresHard = zeros(numHard,ntotal); data.eltimesHard = zeros(numHard,ntotal); data.skippedHard = zeros(numHard,ntotal);
for ii = 1:numHard
    for nn = 1:ntotal
        data.scoresHard(ii,nn) = dataStroopHard{ii,nn}.guess;
        data.eltimesHard(ii,nn) = dataStroopHard{ii,nn}.eltime;
        if isnan(data.eltimesHard(ii,nn)) == 1
            data.skippedHard(ii,nn) = 1;
        end
    end
end
data.scoreHard = nansum(data.scoresHard,1)/numHard;
data.scoreHardAvg = nanmean(data.scoreHard);
data.eltimeHard = nanmean(data.eltimesHard);
data.eltimeHardAvg = nanmean(data.eltimeHard);
data.skipsHard = sum(data.skippedHard(:));

% For the Prov trials, first categorize answers as correct/incorrect
inputsProv = cell(numProv,ntotal);
q = char(39);
for ii = 1:numProv
    for nn = 1:ntotal
            clear fakeEnd
            fakeEnd = datevec(duration(dataStroopProv{ii,nn}.timeStart(4:6))+duration([0,0,1]));
            dataStroopProv{ii,nn}.timeEnd = [dataStroopProv{ii,nn}.timeStart(1:3) fakeEnd(4:6)];        % first assign what color the answer was
        dataStroopProv{ii,nn}.choice = strrep(dataStroopProv{ii,nn}.choice,q,''); % remove any quotes (just in case)
        dataStroopProv{ii,nn}.ogchoice = dataStroopProv{ii,nn}.choice; % save variables without quotes
        dataStroopProv{ii,nn}.choice = strcat(q,dataStroopProv{ii,nn}.choice,q); % put in quotes
        if strcmp(dataStroopProv{ii,nn}.choice,strcat(q,'YELLOW',q))==1
            dataStroopProv{ii,nn}.colorChoice = yellow;
        elseif strcmp(dataStroopProv{ii,nn}.choice,strcat(q,'GREEN',q))==1
            dataStroopProv{ii,nn}.colorChoice = green;
        elseif strcmp(dataStroopProv{ii,nn}.choice,strcat(q,'RED',q))==1
            dataStroopProv{ii,nn}.colorChoice = red;
        elseif strcmp(dataStroopProv{ii,nn}.choice,strcat(q,'PINK',q))==1
            dataStroopProv{ii,nn}.colorChoice = pink;
        elseif strcmp(dataStroopProv{ii,nn}.choice,strcat(q,'GRAY',q))==1
            dataStroopProv{ii,nn}.colorChoice = gray;
        elseif strcmp(dataStroopProv{ii,nn}.choice,strcat(q,'BLUE',q))==1
            dataStroopProv{ii,nn}.colorChoice = blue;
        elseif strcmp(dataStroopProv{ii,nn}.choice,strcat(q,'BLACK',q))==1
            dataStroopProv{ii,nn}.colorChoice = black;
        else
            dataStroopProv{ii,nn}.colorChoice = [1 1 1]; % this will apply if no choice was selected
        end
        % now decide whether that color was correct
        if ~dataStroopProv{ii,nn}.choice
            dataStroopProv{ii,nn}.guess = 0; % 0 if no choice was selected
        elseif dataStroopProv{ii,nn}.colorChoice == dataStroopProv{ii,nn}.inputColor
            dataStroopProv{ii,nn}.guess = 1; % 1 if guess was correct
        else
            dataStroopProv{ii,nn}.guess = 0; % 0 if incorrect
        end
        % measure elapsed time (in seconds)
        inputsProv{ii,nn} = dataStroopProv{ii,nn}.choice;
        if sum(dataStroopProv{ii,nn}.colorChoice) < 3
            dataStroopProv{ii,nn}.eltime = etime(dataStroopProv{ii,nn}.timeEnd,dataStroopProv{ii,nn}.timeStart);
        else
            dataStroopProv{ii,nn}.eltime = NaN;
        end
    end
end

% For the Prov trials, calculate scores and skips and then average them
data.scoresProv = zeros(numProv,ntotal); data.eltimesProv = zeros(numProv,ntotal); data.skippedProv = zeros(numProv,ntotal);
for ii = 1:numProv
    for nn = 1:ntotal
        data.scoresProv(ii,nn) = dataStroopProv{ii,nn}.guess;
        data.eltimesProv(ii,nn) = dataStroopProv{ii,nn}.eltime;
        if isnan(data.eltimesProv(ii,nn)) == 1
            data.skippedProv(ii,nn) = 1;
        end
    end
end
data.scoreProv = nansum(data.scoresProv,1)/numProv;
data.scoreProvAvg = nanmean(data.scoreProv);
data.eltimeProv = nanmean(data.eltimesProv);
data.eltimeProvAvg = nanmean(data.eltimeProv);
data.skipsProv = sum(data.skippedProv(:));

%% save data

data.Easy = dataStroopEasy;
data.Hard = dataStroopHard;
data.Prov = dataStroopProv;
data.timingError = table(actualProv',provTime',(actualProv-provTime)');
header={'Actual_Prov_Time','Expected_Prov_Time','Error'};
data.times.Properties.VariableNames = header;
data_new = genvarname(sprintf('%s_%s',answers{1},answers{2}));
eval([data_new '= data;']);
cd(answers{3})
save(data_new, '-struct', data_new);
% data = load('AB00_Test1.mat');