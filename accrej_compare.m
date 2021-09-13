all_possible_subs = {'S003','S006','S007','S008','S009','S010','S012','S013','S014'};

subs =  {'S003','S007','S010','S012','S013','S014'}; %these have the right amounts (37 targets)
loc_user = 'C:\Users\mswerdloff\';
loc_data = 'Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\';
loc_eeglab = [loc_user 'eeglab\eeglab2021_0'];
loc_source = [loc_data 'EEG\Matlab_data\Pilot2\'];
loc_save = [loc_data 'EEG\Matlab_data\Pilot2_Accel\'];

for ii = 1:length(subs) 

%import codesAccepted from S1, one sub at a time
cd(loc_save)
temp = strcat(subs(ii),'*_codesAccepted.mat');
temp1 = dir(temp{1});
filename_codesAccepted = temp1.name;
load(filename_codesAccepted)
codesAcceptedS1 = codesAccepted; %rename codesAccepted from S1

%import allcondsABC_accfrom S2, one sub at a time
temp = strcat(subs(ii),'*_acceptedTrials_allconds.mat');
temp1 = dir(temp{1});
filename_acceptedTrials_allconds = temp1.name;
load(filename_acceptedTrials_allconds)
codesAcceptedS2 = allcondsABC_acc; %rename allcondsABC_acc from S2

% create new table for comparing
codesCompare = zeros(size(codesAcceptedS1));

% compare the targets that were accepted
for ii = 1:size(codesAcceptedS1,1)
    for jj = 1:size(codesAcceptedS1,2)
        if codesAcceptedS1{ii,jj} == 1 && codesAcceptedS2{ii,jj} == 1
            codesCompare(ii,jj) = 1;
        elseif codesAcceptedS1{ii,jj} == 1 && codesAcceptedS2{ii,jj} ~= 1
            codesCompare(ii,jj) = 9;
        elseif codesAcceptedS1{ii,jj} ~= 1 && codesAcceptedS2{ii,jj} == 1
            codesCompare(ii,jj) = 99;
        end
    end
end

check9 = numel(find(codesCompare(:)==9)); % count any other targets in S1
check99 = numel(find(codesCompare(:)==99)); % count any other targets in S2

% apply check37, check9, and check99
check37 = zeros(1,3);
check37 = [numel(find(codesCompare(:,1)==1)) numel(find(codesCompare(:,2)==1)) numel(find(codesCompare(:,3)==1))];

if check37(1) == 37 && check37(2) == 37 && check37(3) == 37 && check9 == 0 && check99 == 0
    sprintf('we good!')
else
    pause
end

end