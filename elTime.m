clearvars
subs = {'S015','S016','S017','S018'};

%% change filename
for i = 1:numel(subs)
    sub = subs{i}
    filename = strcat('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\StroopTestResults\Pilot2\',sub,'_v5.mat');
end

%% load file
load(filename)

%% do stuff
[n m] = size(Easy);
for nn = 1:n
    for mm = 1:m
        rt(nn,mm,1) = Easy{nn,mm}.eltime;
        rt(nn,mm,2) = Hard{nn,mm}.eltime;
        rt(1,mm,3) = Prov{1,mm}.eltime;
    end
end