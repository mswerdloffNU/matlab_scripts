% Program to create a warbling wave file with variable amplitude and pitch.
function nextTone = make_wav_file(number,tone)
% Initialization / clean-up code.
% clc;    % Clear the command window.
% close all;  % Close all figures (except those of imtool.)
% clearvars -except y;  % Erase all existing variables. Or clearvars if you want.
% workspace;  % Make sure the workspace panel is showing.
format long g;
format compact;
fontSize = 20;

% Create the filename where we will save the waveform.
folder = pwd;
baseFileName1 = 'Test_Wave1.wav';
fullFileName1 = fullfile(folder, baseFileName1);
baseFileName2 = 'Test_Wave2.wav';
fullFileName2 = fullfile(folder, baseFileName2);
% fprintf('Full File Name = %s\n', fullFileName);

% Set up the time axis:
t = 1:1000;

% Set up the period (pitch, frequency):
T = 13;
T1 = linspace(3, 3, length(t)); % Pitch changes.
T2 = linspace(5, 5, length(t)); % Pitch changes.

% Create the maximum amplitude:
% Amplitude = 32767;
Amplitude1 = 32658;
Amplitude2 = 32658;

% Construct the waveform:
y1 = int16(Amplitude1 .* sin(2.*pi.*t./T1));
y2 = int16(Amplitude2 .* sin(2.*pi.*t./T2));

% Write the waveform to a file:
wavwrite(y1, fullFileName1);
wavwrite(y2, fullFileName2);

b = tone;
clear nextTone
if b == 1
    for i = 1:number
        PlaySoundFile(folder, baseFileName1);
    end
elseif b == 2
    for i = 1:number
        PlaySoundFile(folder, baseFileName2);
        nextTone(i) = 0.5+(randi([625 1376])*.001);
        pause(nextTone(i))
    end
elseif b == 3
    for i = 1:number
        a = rand(1);
        if a > .2
            PlaySoundFile(folder, baseFileName2);
            nextTone(i) = 0.5+(randi([625 1376])*.001);
            pause(nextTone(i))
        else
            PlaySoundFile(folder, baseFileName1);
            nextTone(i) = 0.5+(randi([625 1376])*.001);
            pause(nextTone(i))
        end
    end
    elseif b == 4
    for i = 1:number
        a = rand(1);
        if a > .05
            PlaySoundFile(folder, baseFileName2);
        else
            PlaySoundFile(folder, baseFileName1);
        end
        nextTone(i) = (randi([125 476])*.001);
        pause(nextTone(i))
    end
end


%================================================================================================
% Play a wav file.  You can pass in 'random' and it will pick one at random from the folder to play.
% PlaySoundFile(handles.soundFolder, 'chime.wav');
% PlaySoundFile(handles.soundFolder, 'random');
    function PlaySoundFile(soundFolder, baseWavFileName)
        global waveFileData;
        global Fs;	% Wave file information.
        try				% Read the sound file into MATLAB, and play the audio.
            % 		soundFolder = fullfile(soundFolder, 'Sound Files');
            if ~exist(soundFolder, 'dir')
                warningMessage = sprintf('Warning: sound folder not found:\n%s', soundFolder);
                WarnUser(warningMessage);
                return;
            end
            if strcmpi(baseWavFileName, 'random')
                itWorked = false;
                tryCount = 1;
                while itWorked == false
                    % Pick a file at random.
                    filePattern = fullfile(soundFolder, '*.wav');
                    waveFiles = dir(filePattern);
                    numberOfFiles = length(waveFiles);
                    % Get a random number
                    fileToPlay = randi(numberOfFiles, 1);
                    baseWavFileName = waveFiles(fileToPlay).name;
                    fullWavFileName = fullfile(soundFolder, baseWavFileName);
                    waveFileData = -1;
                    try
                        if exist(fullWavFileName, 'file')
                            [waveFileData, Fs, nbits, readinfo] = wavread(fullWavFileName);
                            sound(waveFileData, Fs);
                            % 		soundsc(y,Fs,bits,range);
                        else
                            warningMessage = sprintf('Warning: sound file not found:\n%s', fullWavFileName);
                            WarnUser(warningMessage);
                        end
                        % It worked.  It played because the audio format was OK.
                        itWorked = true;
                    catch
                        % Increment the try count and try again to find a file that plays.
                        tryCount = tryCount + 1;
                        if tryCount >= numberOfFiles
                            break;
                        end
                    end
                end % of while()
            else
                % 		baseWavFileName = 'Chime.wav';
                fullWavFileName = fullfile(soundFolder, baseWavFileName);
                waveFileData = -1;
                if exist(fullWavFileName, 'file')
                    [waveFileData, Fs, nbits, readinfo] = wavread(fullWavFileName);
                    sound(waveFileData, Fs);
                    % 		soundsc(y,Fs,bits,range);
                else
                    warningMessage = sprintf('Warning: sound file not found:\n%s', fullWavFileName);
                    WarnUser(warningMessage);
                end
            end
        catch ME
            if strfind(ME.message, '#85')
                % Unrecognized format.  Play chime instead.
                fprintf('Error in PlaySoundFile(): %s.\nUnrecognized sound format in file:\n\n%s\n', ME.message, fullWavFileName);
                baseWavFileName = 'Chime.wav';
                fullWavFileName = fullfile(soundFolder, baseWavFileName);
                waveFileData = -1;
                if exist(fullWavFileName, 'file')
                    [waveFileData, Fs, nbits, readinfo] = wavread(fullWavFileName);
                    sound(waveFileData, Fs);
                    % 		soundsc(y,Fs,bits,range);
                end
            end
            errorMessage = sprintf('Error in PlaySoundFile().\nThe error reported by MATLAB is:\n\n%s', ME.message);
            fprintf('%s\n', errorMessage);
            WarnUser(errorMessage);
        end
        return; % from PlaySoundFile
    end
end