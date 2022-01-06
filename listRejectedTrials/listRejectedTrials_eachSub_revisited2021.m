%% Remove additional targets as needed
% Do this for each subject
location = 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S006';

clear codesAll x_all
codesAll = codes_all_S006;

x_all = table2array(RejectedTrials_S006);
x_all_sit = [x_all(:,1);x_all(:,2);x_all(:,3)];
x_all_stand = [x_all(:,4);x_all(:,5);x_all(:,6)];
x_all_walk = [x_all(:,7);x_all(:,8);x_all(:,9)];
x_all_combined = [x_all_sit,x_all_stand,x_all_walk];

%randomly choose from list of current targets which ones should get removed
% x = number total
% y = number total - 37 % this is how many need to get removed
% choose y random 1's and set them to 4's, 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
codes_sit = [codesAll(:,1);codesAll(:,2);codesAll(:,3)];
codes_stand = [codesAll(:,4);codesAll(:,5);codesAll(:,6)];
codes_walk = [codesAll(:,7);codesAll(:,8);codesAll(:,9)];
codesAll_combined = [codes_sit,codes_stand,codes_walk];

clear rejectedTrials_new
rejectedTrials_new = x_all_combined;
count_sit = 0;
count_stand = 0;
count_walk = 0;

%This makes a list of only the already-accepted TARGET trials
clear list_rej list_accept s reject newlist b 
list_rej=find(x_all_combined(:,1)==1); % list of already rejected target trials
for i = 1:numel(x_all_combined(:,1)) % for any trial that was not rejected and that is a target, put it into the accepted targets list
    if (x_all_combined(i,1)==0) && (codes_sit(i) == 1)
        list_accept(i) = i; % list of already accepted targets      
    else
        list_accept(i) = 0;
    end
end
n_accepted_total = find(list_accept); % list of already accepted target trials

%This section selects a random selection of already-accepted target trials
%and rejects them
s = RandStream('mlfg6331_64');
shouldBeRej_sit = numel(n_accepted_total)-targetsNewNum; % number of targets that need to be rejected
reject = randsample(n_accepted_total,shouldBeRej_sit); % list of target trials that should be rejected
newlist=codes_sit; % prepare a new list of accepted trials
newlist(reject)=0; % set all of the to-be-rejected trials to 0
n_sit = numel(x_all(:,1));
n_stand = 2*n_sit;

% for i = 1:numel(list_accept)
%     if (newlist(i) == 0) && (codes_sit(i) == 1) && (list_accept(i) < (n_sit+1))
%         rejectedTrials_new(i,1)=4;
%     elseif (newlist(i) == 0) && (codes_sit(i) == 1) && (list_accept(i) > n_stand)
%         rejectedTrials_new(i-n_stand,3)=4;
%     elseif (newlist(i) == 0) && (codes_sit(i) == 1) && (list_accept(i) < (n_stand+1)) && (list_accept(i) > (n_sit))
%         rejectedTrials_new(i-n_sit,2)=4;
%     else
%         count_sit = count_sit+1;
%     end
% end

for i = 1:numel(list_accept)
    if (newlist(i) == 0) && (codes_sit(i) == 1)
        rejectedTrials_new(i,1)=4;
    else
        count_sit = count_sit+1;
    end
end

% check that this worked
newlyRej = numel(find(rejectedTrials_new(:,1)==4)) + numel(list_rej) - 3; % minus 3 since there are already three 4's at the beginning
if newlyRej ~= sum([shouldBeRej_sit;numel(list_rej)])
    sprintf('sit: error changing number of rejected trials')
    pause
else 
    sprintf('sit: good!')
end
% double check this worked
if ((numel(find(x_all_combined(:,1))) + shouldBeRej_sit) ~= numel(find(rejectedTrials_new(:,1))))
    sprintf('sit: error changing number of rejected trials')
    pause
else 
    sprintf('sit: good!')
end

clear list_rej list_accept s reject newlist b n_accepted_total
list_rej=find(x_all_combined(:,2)==1); % list of rejected target trials
for i = 1:numel(x_all_combined(:,2))
    if (x_all_combined(i,2)==0) && (codes_stand(i) == 1)
    list_accept(i) = i; % list of accepted trials
    else
        list_accept(i) = 0;
    end
end
n_accepted_total = find(list_accept); % list of already accepted target trials

s = RandStream('mlfg6331_64');
shouldBeRej_stand = numel(n_accepted_total)-targetsNewNum; % number of targets that need to be rejected
reject = randsample(n_accepted_total,shouldBeRej_stand); % list of target trials that should be rejected
newlist=codes_stand; % prepare a new list of accepted trials
newlist(reject)=0; % set all of the to-be-rejected trials to 0
 
% for i = 1:numel(list_accept)
%     if (newlist(i) == 0) && (codes_stand(i) == 1) && (list_accept(i) < (n_sit+1))
%         rejectedTrials_new(i,4)=4;
%     elseif (newlist(i) == 0) && (codes_stand(i) == 1) && (list_accept(i) > n_stand)
%         rejectedTrials_new(i-n_stand,6)=4;
%     elseif (newlist(i) == 0) && (codes_stand(i) == 1) && (list_accept(i) < (n_stand+1)) && (list_accept(i) > (n_sit))
%         rejectedTrials_new(i-n_sit,5)=4;
%     else
%         count_stand = count_stand+1;
%     end
% end

for i = 1:numel(list_accept)
    if (newlist(i) == 0) && (codes_stand(i) == 1)
        rejectedTrials_new(i,2)=4;
    else
        count_stand = count_stand+1;
    end
end

% check that this worked
newlyRej = numel(find(rejectedTrials_new(:,2)==4)) + numel(list_rej) - 3;
if newlyRej ~= sum([shouldBeRej_stand;numel(list_rej)])
    sprintf('stand: error changing number of rejected trials')
    pause
else 
    sprintf('stand: good!')
end
% double check that this worked
if ((numel(find(x_all_combined(:,2))) + shouldBeRej_stand) ~= numel(find(rejectedTrials_new(:,2))))
    sprintf('stand: error changing number of rejected trials')
    pause
else 
    sprintf('stand: good!')
end

clear list_rej list_accept s reject newlist b n_accepted_total 
list_rej=find(x_all_combined(:,3)==1); % list of rejected target trials
for i = 1:numel(x_all_combined(:,3))
    if (x_all_combined(i,3)==0) && (codes_walk(i) == 1)
    list_accept(i) = i; % list of accepted trials
    else
        list_accept(i) = 0;
    end
end
n_accepted_total = find(list_accept); % list of already accepted target trials

s = RandStream('mlfg6331_64');
shouldBeRej_walk = numel(n_accepted_total)-targetsNewNum; % number of targets that need to be rejected
reject = randsample(n_accepted_total,shouldBeRej_walk); % list of target trials that should be rejected
newlist=codes_walk; % prepare a new list of accepted trials
newlist(reject)=0; % set all of the to-be-rejected trials to 0
 
% for i = 1:numel(list_accept)
%     if (newlist(i) == 0) && (codes_walk(i) == 1) && (list_accept(i) < (n_sit+1))
%         rejectedTrials_new(i,7)=4;
%     elseif (newlist(i) == 0) && (codes_walk(i) == 1) && (list_accept(i) > n_stand)
%         rejectedTrials_new(i-n_stand,9)=4;
%     elseif (newlist(i) == 0) && (codes_walk(i) == 1) && (list_accept(i) < (n_stand+1)) && (list_accept(i) > (n_sit))
%         rejectedTrials_new(i-n_sit,8)=4;
%     else
%         count_walk = count_walk+1;
%     end
% end

for i = 1:numel(list_accept)
    if (newlist(i) == 0) && (codes_walk(i) == 1)
        rejectedTrials_new(i,3)=4;
    else
        count_walk = count_walk+1;
    end
end

% check this worked
newlyRej = numel(find(rejectedTrials_new(:,3)==4)) + numel(list_rej) - 3;
if newlyRej ~= sum([shouldBeRej_walk;numel(list_rej)])
    sprintf('walk: error changing number of rejected trials')
    pause
else 
    sprintf('walk: good!')
end
% double check this worked
if ((numel(find(x_all_combined(:,3))) + shouldBeRej_walk) ~= numel(find(rejectedTrials_new(:,3))))
    sprintf('walk: error changing number of rejected trials')
    pause
else 
    sprintf('walk: good!')
end    
% clear RejectedTrials_Sub_new2
% RejectedTrials_S003_new = array2table(rejectedTrials_new,'VariableNames',{'Sit_A','Sit_B','Sit_C','Stand_A','Stand_B','Stand_C','Walk_A','Walk_B','Walk_C'});
% 
rejectedTrials_new_sep = [rejectedTrials_new(1:301,1) rejectedTrials_new(302:602,1) rejectedTrials_new(603:903,1) rejectedTrials_new(1:301,2) rejectedTrials_new(302:602,2) rejectedTrials_new(603:903,2) rejectedTrials_new(1:301,3) rejectedTrials_new(302:602,3) rejectedTrials_new(603:903,3)];
% RejectedTrials_S003_new3 = array2table(rejectedTrials_new_sep,'VariableNames',{'Sit_A','Sit_B','Sit_C','Stand_A','Stand_B','Stand_C','Walk_A','Walk_B','Walk_C'});

% re-count the number of targets are in each category for each subject and save them
clear totalAccepted targetsAccepted

for i = 1:3
    totalAccepted(i) = numel(find(codesAll_combined(:,i)))-numel(find(rejectedTrials_new(:,i)));
    targetsAccepted(i) = numel(find(codesAll_combined(:,i)==1))-numel(find(rejectedTrials_new(:,i)==1))-numel(find(rejectedTrials_new(1:end,i)==4))+3;
end
 
for i = 1:9
    totalAccepted_sep(i) = numel(find(codesAll(:,i)))-numel(find(rejectedTrials_new_sep(:,i)));
    targetsAccepted_sep(i) = numel(find(codesAll(:,i)==1))-numel(find(rejectedTrials_new_sep(:,i)==1))-numel(find(rejectedTrials_new_sep(1:end,i)==4))+3;
end

clear targetsAccepted_sit targetsAccepted_stand targetsAccepted_walk targetsAccepted_all
targetsAccepted_sit = sum(targetsAccepted(1));
targetsAccepted_stand = sum(targetsAccepted(2));
targetsAccepted_walk = sum(targetsAccepted(3));
targetsAccepted_all = [targetsAccepted_sit,targetsAccepted_stand,targetsAccepted_walk];
targetsAccepted_all_S006_eq = [targetsAccepted_sit,targetsAccepted_stand,targetsAccepted_walk,min(targetsAccepted_all)]
% totalAccepted_all_S003_new = [sum(totalAccepted(1:3)),sum(totalAccepted(4:6)),sum(totalAccepted(7:9))];
totalAccepted_all_S006_eq = [sum(totalAccepted(1)),sum(totalAccepted(2)),sum(totalAccepted(3))];
RejectedTrials_S006_eq = array2table(rejectedTrials_new,'VariableNames',{'Sit','Stand','Walk'});
% targetsAccepted_all_S014_eq_sep = [numel(find(codesAll(1:301,1) targetsAccepted_all_S014_eq(302:602,2) 
    
if targetsAccepted_all_S006_eq == ones(1,4)*(targetsNewNum)
    sprintf('good sub!')
    cd(location)
%     save('rejectedAcceptedTrials_S014_eq.mat','RejectedTrials_S014_eq','targetsAccepted_all_S014_eq','totalAccepted_all_S014_eq'); % save list of numbers of targets accepted
else
    sprintf('uh oh, something went wrong')
end


%%
% targetsAccepted_allSubs_new = [targetsAccepted_all_S003_new;targetsAccepted_all_S005_new;targetsAccepted_all_S006_new;targetsAccepted_all_S007_new;targetsAccepted_all_S008_new;targetsAccepted_all_S009_new;targetsAccepted_all_S010_new;targetsAccepted_all_S012_new;targetsAccepted_all_S013_new;targetsAccepted_all_S014_new];
% TargetsAccepted_allSubs_new = array2table(targetsAccepted_allSubs_new,'VariableNames',{'Sit','Stand','Walk','Min'},'RowNames',{'S003','S005','S006','S007','S008','S009','S010','S012','S013','S014'});
% totalAccepted_allSubs_new = [totalAccepted_all_S003_new;totalAccepted_all_S005_new;totalAccepted_all_S006_new;totalAccepted_all_S007_new;totalAccepted_all_S008_new;totalAccepted_all_S009_new;totalAccepted_all_S010_new;totalAccepted_all_S012_new;totalAccepted_all_S013_new;totalAccepted_all_S014_new];
% TotalAccepted_allSubs_new = array2table(totalAccepted_allSubs_new,'VariableNames',{'Sit','Stand','Walk'},'RowNames',{'S003','S005','S006','S007','S008','S009','S010','S012','S013','S014'});
% 
% targetsNewNum_new = min(targetsAccepted_allSubs(:));
% 
% if targetsNewNum_new == targetsNewNum
%     sprintf('all subs good!')
% else
%     sprintf('uh oh, something went wrong')
% end

%%
targetsAccepted_allSubs_eq = [targetsAccepted_all_S003_eq;targetsAccepted_all_S005_eq;targetsAccepted_all_S006_eq;targetsAccepted_all_S007_eq;targetsAccepted_all_S008_eq;targetsAccepted_all_S009_eq;targetsAccepted_all_S010_eq;targetsAccepted_all_S012_eq;targetsAccepted_all_S013_eq;targetsAccepted_all_S014_eq];
TargetsAccepted_allSubs_eq = array2table(targetsAccepted_allSubs_eq,'VariableNames',{'Sit','Stand','Walk','Min'},'RowNames',{'S003','S005','S006','S007','S008','S009','S010','S012','S013','S014'});
totalAccepted_allSubs_eq = [totalAccepted_all_S003_eq;totalAccepted_all_S005_eq;totalAccepted_all_S006_eq;totalAccepted_all_S007_eq;totalAccepted_all_S008_eq;totalAccepted_all_S009_eq;totalAccepted_all_S010_eq;totalAccepted_all_S012_eq;totalAccepted_all_S013_eq;totalAccepted_all_S014_eq];
TotalAccepted_allSubs_eq = array2table(totalAccepted_allSubs_eq,'VariableNames',{'Sit','Stand','Walk'},'RowNames',{'S003','S005','S006','S007','S008','S009','S010','S012','S013','S014'});

targetsNewNum_eq = min(targetsAccepted_allSubs_eq(:));

if targetsNewNum_eq == targetsNewNum
    sprintf('all subs good!')
else
    sprintf('uh oh, something went wrong')
end
%%
% now, put everything into the original format
clear x_all
% x_all_old = table2array(RejectedTrials_S003);
x_all_combined = table2array(RejectedTrials_S006_eq);
x_all = [x_all_combined(1:301,1) x_all_combined(302:602,1) x_all_combined(603:903,1) x_all_combined(1:301,2) x_all_combined(302:602,2) x_all_combined(603:903,2) x_all_combined(1:301,3) x_all_combined(302:602,3) x_all_combined(603:903,3)];

clear x_new x_new_string_pt2
x_new = find(x_all(2:end,1));     x_new_string_pt1 = sprintf('EEG = pop_rejepoch( EEG, [');     x_new_string_pt2 = sprintf(' %d', x_new);    x_new_string_pt3 = sprintf('] ,0);');
x1_new = [x_new_string_pt1 x_new_string_pt2 x_new_string_pt3]

clear x_new x_new_string_pt2
x_new = find(x_all(2:end,2));     x_new_string_pt1 = sprintf('EEG = pop_rejepoch( EEG, [');     x_new_string_pt2 = sprintf(' %d', x_new);    x_new_string_pt3 = sprintf('] ,0);');
x2_new = [x_new_string_pt1 x_new_string_pt2 x_new_string_pt3]

clear x_new x_new_string_pt2
x_new = find(x_all(2:end,3));     x_new_string_pt1 = sprintf('EEG = pop_rejepoch( EEG, [');     x_new_string_pt2 = sprintf(' %d', x_new);    x_new_string_pt3 = sprintf('] ,0);');
x3_new = [x_new_string_pt1 x_new_string_pt2 x_new_string_pt3]

clear x_new x_new_string_pt2
x_new = find(x_all(2:end,4));     x_new_string_pt1 = sprintf('EEG = pop_rejepoch( EEG, [');     x_new_string_pt2 = sprintf(' %d', x_new);    x_new_string_pt3 = sprintf('] ,0);');
x4_new = [x_new_string_pt1 x_new_string_pt2 x_new_string_pt3]

clear x_new x_new_string_pt2
x_new = find(x_all(2:end,5));     x_new_string_pt1 = sprintf('EEG = pop_rejepoch( EEG, [');     x_new_string_pt2 = sprintf(' %d', x_new);    x_new_string_pt3 = sprintf('] ,0);');
x5_new = [x_new_string_pt1 x_new_string_pt2 x_new_string_pt3]

clear x_new x_new_string_pt2
x_new = find(x_all(2:end,6));     x_new_string_pt1 = sprintf('EEG = pop_rejepoch( EEG, [');     x_new_string_pt2 = sprintf(' %d', x_new);    x_new_string_pt3 = sprintf('] ,0);');
x6_new = [x_new_string_pt1 x_new_string_pt2 x_new_string_pt3]

clear x_new x_new_string_pt2
x_new = find(x_all(2:end,7));     x_new_string_pt1 = sprintf('EEG = pop_rejepoch( EEG, [');     x_new_string_pt2 = sprintf(' %d', x_new);    x_new_string_pt3 = sprintf('] ,0);');
x7_new = [x_new_string_pt1 x_new_string_pt2 x_new_string_pt3]

clear x_new x_new_string_pt2
x_new = find(x_all(2:end,8));     x_new_string_pt1 = sprintf('EEG = pop_rejepoch( EEG, [');     x_new_string_pt2 = sprintf(' %d', x_new);    x_new_string_pt3 = sprintf('] ,0);');
x8_new = [x_new_string_pt1 x_new_string_pt2 x_new_string_pt3]

clear x_new x_new_string_pt2
x_new = find(x_all(2:end,9));     x_new_string_pt1 = sprintf('EEG = pop_rejepoch( EEG, [');     x_new_string_pt2 = sprintf(' %d', x_new);    x_new_string_pt3 = sprintf('] ,0);');
x9_new = [x_new_string_pt1 x_new_string_pt2 x_new_string_pt3]



