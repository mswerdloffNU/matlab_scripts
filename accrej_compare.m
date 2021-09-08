all_possible_subs = {'S003','S006','S007','S008','S009','S010','S012','S013','S014'};

subs =  {'S003','S007','S010','S012','S013','S014'}; %these have the right amounts (37 targets)
% subs = all_possible_subs; % run all subs
% subs = {'S014','S003'}; % stim conversion
% subs = {'S026_SA_0002'}; % pt 1
loc_user = 'C:\Users\mswerdloff\';
loc_data = 'Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\';
loc_eeglab = [loc_user 'eeglab\eeglab2021_0'];
loc_source = [loc_data 'EEG\Matlab_data\Pilot2\'];
loc_save = [loc_data 'EEG\Matlab_data\Pilot2_Accel\'];

%import sitABC_acc, standABC_acc, and walkABC from S2

for ii = 1:length(subs) % number of subs

%import codesAccepted from S1
cd(loc_save)
temp = strcat(subs(ii),'*_codesAccepted.mat');
temp1 = dir(temp{ii});
filename = temp1(ii).name;
load(filename)
codesAcceptedS1 = codesAccepted; %rename codesAccepted from S1

%import data from S2:
% import S00X_acceptedTrials_allconds.mat

%trash i think:
% % temp2 = [table2array(sitABC_acc),table2array(standABC_acc),table2array(walkABC_acc)];
% % codesAcceptedS2 = array2table(temp2);
% % codesAcceptedS2.Properties.VariableNames{1} = 'sit';
% % codesAcceptedS2.Properties.VariableNames{2} = 'stand';
% % codesAcceptedS2.Properties.VariableNames{3} = 'walk';

% create new table for comparing
codesCompare = zeros(size(codesAcceptedS1));

% compare the targets that were accepted
for ii = 1:size(codesAcceptedS1,1)
    for jj = 1:size(codesAcceptedS1,2)
        if codesAcceptedS1{ii,jj} == 1 && codesAcceptedS2{ii,jj} == 1
            codesCompare(ii,jj) = 1;
        end
    end
end

% apply check37
check37 = zeros(1,3);
check37 = [numel(find(codesCompare(:,1)==1)) numel(find(codesCompare(:,2)==1)) numel(find(codesCompare(:,3)==1))];
if check37(1) == 37 && check37(2) == 37 && check37(3) == 37
    sprintf('we good!')
else
    pause
end

end