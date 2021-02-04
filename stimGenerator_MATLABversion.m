clearvars

n = 300;

tones = generateTones(n);

for ii = 1:n
    
    if (randSoundUnif == 1) % play Tone 1 with 10% frequency
        sprintf('1');
        midiNoteOn(0, 86, 127);
        pause(.01);
        midiNoteOff(0, 86, 127);
        toneNumber = 1;
        
    else
        
        sprintf('2'); % play Tone 2 with 90% frequency
        midiNoteOn(0, 81, 127);
        pause(.01);
        midiNoteOff(0, 81, 127);
        toneNumber = 2;
    end
    
    % wait time according to poisson process
    double nextTime;
    nextTime = 0.001*randperm(625, 1376); % generate random number between 625 and 1375
    sprintf(nextTime, 4); % show how long until next tone
    % Create/Open file
    myFile = SD.open('test.txt',FILE_WRITE);
    % Write to file
    toneNumbers(ii) = toneNumber;
    nextTimes(ii) = nextTime;
    % wait
    pause(nextTime(1));
end
pause(3);
% delay(600000);