%% description for p3_rms.m
% Requires p3_rms.mat struct from selfP3
% Uncomment 58-62 (p3_rms variables) as needed
% Makes erp and scatterplots


%% stuff I probably don't need

% temp5 = [];
% temp6 = [];
% temp7 = [];
% 
% for ii = 1:numel(ALLEEG(9).event)
%     if ALLEEG(9).event(ii).bini == 1
%         temp5(ii) = ALLEEG(9).event(ii).bepoch;
%     end
% end
% 
% [~, temp6] = find(temp5);
% temp7 = 1+temp5(temp6)';
% 
% temp8 = zeros(length(accLat(3).targetsAcc),1);
% for ii = 1:length(accLat(3).targetsAcc)
%     for jj = 1:length(ALLEEG(8).event)
%         if accLat(3).targetsAcc(ii) == ALLEEG(8).event(jj).item
%             if ALLEEG(8).event(jj).bini ~= 1
%                 pause
%             end
%         end
%     end
% end
% 
% 
% for mm = 1:numel(subs)
%     for k = 1:9
%         trials_Ax_goof = accel_trials(k,mm).trials_Ax;
%         trials_Ay_goof = accel_trials(k,mm).trials_Ay;
%         trials_Az_goof = accel_trials(k,mm).trials_Az;
%         rms_Ax = rms(trials_Ax_goof(:,accLat(k,mm).targetsAcc));
%         rms_Ay = rms(trials_Ay_goof(:,accLat(k,mm).targetsAcc));
%         rms_Az = rms(trials_Az_goof(:,accLat(k,mm).targetsAcc));
%         
%         rms_avg = mean([rms_Ax;rms_Ay;rms_Az],'double');
%         
%         accel_trials(k,mm).rms_avg = rms_avg';
%         
%     end
% end


%% load files
% load('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2_Accel\accLat_allsubs.mat')
load('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2_Accel\10_22_21\accel_trials_allsubs.mat')
% use this if you want to load the previously saved p3_rms variable:
load('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2_Accel\10_22_21\p3_rms.mat')

%% adjust p3_rms entries as needed
for mm = 1:numel(subs)
    for k = 1:9
        p3_rms(k,mm).trialnum = accel_trials(k,mm).targetsAcc;
        p3_rms(k,mm).bL = mean(p3_rms(k,mm).erp_pz_target(1:61,:),1); % timepoints that are before 0
        p3_rms(k,mm).erp_pz_target_bL = p3_rms(k,mm).erp_pz_target-p3_rms(k,mm).bL; % subtract the baseline from the erp
        p3_rms(k,mm).p3_mean = mean(p3_rms(k,mm).erp_pz_target_bL(136:166,:),1)'; % choose the mean tiem window here
        p3_rms(k,mm).p3_median = median(p3_rms(k,mm).erp_pz_target_bL(136:166,:),1)'; % choose the median tiem window here
        
        p3_rms(k,mm).rms1 = accel_trials(k,mm).rms_avg';
        p3_rms(k,mm).rms2 = sqrt((rms(accel_trials(k,mm).trials_Ax_accepted).*rms(accel_trials(k,mm).trials_Ax_accepted))+(rms(accel_trials(k,mm).trials_Ay_accepted).*rms(accel_trials(k,mm).trials_Ay_accepted))+(rms(accel_trials(k,mm).trials_Az_accepted).*rms(accel_trials(k,mm).trials_Az_accepted)))';
        p3_rms(k,mm).rms3 = accel_trials(k,mm).rms_mag';
        
        p3_rms(k,mm).p3_rms_comb1 = [p3_rms(k,mm).rms1, p3_rms(k,mm).trialnum, p3_rms(k,mm).p3_mean];
        p3_rms(k,mm).p3_rms_comb2 = [p3_rms(k,mm).rms2, p3_rms(k,mm).trialnum, p3_rms(k,mm).p3_mean];
        p3_rms(k,mm).p3_rms_comb3 = [p3_rms(k,mm).rms3, p3_rms(k,mm).trialnum, p3_rms(k,mm).p3_mean, p3_rms(k,mm).p3_median, mm*ones(length(p3_rms(k,mm).trialnum),1), k*ones(length(p3_rms(k,mm).trialnum),1)];
        p3_rms(k,mm).p3_rms_comb3_sub = [mm*ones(length(p3_rms(k,mm).trialnum),1), k*ones(length(p3_rms(k,mm).trialnum),1), p3_rms(k,mm).rms3, p3_rms(k,mm).trialnum, p3_rms(k,mm).p3_mean, p3_rms(k,mm).p3_median];
    end
end

%% decide whether to use rms1 or rms2
for mm = 1:numel(subs)
    sub = subs{mm};
    for k = 1:9
%         if mm == 2 && k==5 % stand B S006
%                 sprintf('Warning: S006 stand B contains no accepted targets')
%                 p3_rms(k,mm).p3_rms_comb = [p3_rms(k,mm).p3_rms_comb3 NaN(length(p3_rms(k,mm).p3_rms_comb3),4)]; % choose comb1, comb2, or comb3
%                 p3_rms(k,mm).p3_rms_comb_sub = [mm*ones(length(p3_rms(k,mm).p3_rms_comb3_sub),1) k*ones(length(p3_rms(k,mm).p3_rms_comb3_sub),1) NaN(length(p3_rms(k,mm).p3_rms_comb3_sub),4)]; % choose comb1, comb2, or comb3
% %         elseif mm == 4 && k==1 % sit A S008
% %                 sprintf('Warning: S008 sit A contains no accepted targets')
% %                 p3_rms(k,mm).p3_rms_comb = [p3_rms(k,mm).p3_rms_comb3 NaN(length(p3_rms(k,mm).p3_rms_comb3),4)]; % choose comb1, comb2, or comb3
% %                 p3_rms(k,mm).p3_rms_comb_sub = [mm*ones(length(p3_rms(k,mm).p3_rms_comb3_sub),1) k*ones(length(p3_rms(k,mm).p3_rms_comb3_sub),1) NaN(length(p3_rms(k,mm).p3_rms_comb3_sub),4)]; % choose comb1, comb2, or comb3
%         elseif mm == 5 && k==2 % sit B S009
%                 sprintf('Warning: S009 sit B contains no accepted targets')
%                 p3_rms(k,mm).p3_rms_comb = [p3_rms(k,mm).p3_rms_comb3 NaN(length(p3_rms(k,mm).p3_rms_comb3),4)]; % choose comb1, comb2, or comb3
%                 p3_rms(k,mm).p3_rms_comb_sub = [mm*ones(length(p3_rms(k,mm).p3_rms_comb3_sub),1) k*ones(length(p3_rms(k,mm).p3_rms_comb3_sub),1) NaN(length(p3_rms(k,mm).p3_rms_comb3_sub),4)]; % choose comb1, comb2, or comb3
%         else
                p3_rms(k,mm).p3_rms_comb = p3_rms(k,mm).p3_rms_comb3; % choose comb1, comb2, or comb3
                p3_rms(k,mm).p3_rms_comb_sub = p3_rms(k,mm).p3_rms_comb3_sub; % choose comb1, comb2, or comb3
%         end
    end
end
%% create variables containing p3 and rms data
if numel(subs) == 9 % edit for more subs
    p3_rms_allsubs_sitA = [p3_rms(1,1).p3_rms_comb; p3_rms(1,2).p3_rms_comb; p3_rms(1,3).p3_rms_comb; p3_rms(1,4).p3_rms_comb; p3_rms(1,5).p3_rms_comb; p3_rms(1,6).p3_rms_comb; p3_rms(1,7).p3_rms_comb; p3_rms(1,8).p3_rms_comb; p3_rms(1,9).p3_rms_comb];
    p3_rms_allsubs_sitB = [p3_rms(2,1).p3_rms_comb; p3_rms(2,2).p3_rms_comb; p3_rms(2,3).p3_rms_comb; p3_rms(2,4).p3_rms_comb; p3_rms(2,5).p3_rms_comb; p3_rms(2,6).p3_rms_comb; p3_rms(2,7).p3_rms_comb; p3_rms(2,8).p3_rms_comb; p3_rms(2,9).p3_rms_comb];
    p3_rms_allsubs_sitC = [p3_rms(3,1).p3_rms_comb; p3_rms(3,2).p3_rms_comb; p3_rms(3,3).p3_rms_comb; p3_rms(3,4).p3_rms_comb; p3_rms(3,5).p3_rms_comb; p3_rms(3,6).p3_rms_comb; p3_rms(3,7).p3_rms_comb; p3_rms(3,8).p3_rms_comb; p3_rms(3,9).p3_rms_comb];
    p3_rms_allsubs_standA = [p3_rms(4,1).p3_rms_comb; p3_rms(4,2).p3_rms_comb; p3_rms(4,3).p3_rms_comb; p3_rms(4,4).p3_rms_comb; p3_rms(4,5).p3_rms_comb; p3_rms(4,6).p3_rms_comb; p3_rms(4,7).p3_rms_comb; p3_rms(4,8).p3_rms_comb; p3_rms(4,9).p3_rms_comb];
    p3_rms_allsubs_standB = [p3_rms(5,1).p3_rms_comb; p3_rms(5,2).p3_rms_comb; p3_rms(5,3).p3_rms_comb; p3_rms(5,4).p3_rms_comb; p3_rms(5,5).p3_rms_comb; p3_rms(5,6).p3_rms_comb; p3_rms(5,7).p3_rms_comb; p3_rms(5,8).p3_rms_comb; p3_rms(5,9).p3_rms_comb];
    p3_rms_allsubs_standC = [p3_rms(6,1).p3_rms_comb; p3_rms(6,2).p3_rms_comb; p3_rms(6,3).p3_rms_comb; p3_rms(6,4).p3_rms_comb; p3_rms(6,5).p3_rms_comb; p3_rms(6,6).p3_rms_comb; p3_rms(6,7).p3_rms_comb; p3_rms(6,8).p3_rms_comb; p3_rms(6,9).p3_rms_comb];
    p3_rms_allsubs_walkA = [p3_rms(7,1).p3_rms_comb; p3_rms(7,2).p3_rms_comb; p3_rms(7,3).p3_rms_comb; p3_rms(7,4).p3_rms_comb; p3_rms(7,5).p3_rms_comb; p3_rms(7,6).p3_rms_comb; p3_rms(7,7).p3_rms_comb; p3_rms(7,8).p3_rms_comb; p3_rms(7,9).p3_rms_comb];
    p3_rms_allsubs_walkB = [p3_rms(8,1).p3_rms_comb; p3_rms(8,2).p3_rms_comb; p3_rms(8,3).p3_rms_comb; p3_rms(8,4).p3_rms_comb; p3_rms(8,5).p3_rms_comb; p3_rms(8,6).p3_rms_comb; p3_rms(8,7).p3_rms_comb; p3_rms(8,8).p3_rms_comb; p3_rms(8,9).p3_rms_comb];
    p3_rms_allsubs_walkC = [p3_rms(9,1).p3_rms_comb; p3_rms(9,2).p3_rms_comb; p3_rms(9,3).p3_rms_comb; p3_rms(9,4).p3_rms_comb; p3_rms(9,5).p3_rms_comb; p3_rms(9,6).p3_rms_comb; p3_rms(9,7).p3_rms_comb; p3_rms(9,8).p3_rms_comb; p3_rms(9,9).p3_rms_comb];
else
    sprintf('make new columns for additional subjects')
    pause
end

if numel(subs) == 9 % edit for more subs
    p3_rms_allsubs_sitA_sub = [p3_rms(1,1).p3_rms_comb_sub; p3_rms(1,2).p3_rms_comb_sub; p3_rms(1,3).p3_rms_comb_sub; p3_rms(1,4).p3_rms_comb_sub; p3_rms(1,5).p3_rms_comb_sub; p3_rms(1,6).p3_rms_comb_sub; p3_rms(1,7).p3_rms_comb_sub; p3_rms(1,8).p3_rms_comb_sub; p3_rms(1,9).p3_rms_comb_sub];
    p3_rms_allsubs_sitB_sub = [p3_rms(2,1).p3_rms_comb_sub; p3_rms(2,2).p3_rms_comb_sub; p3_rms(2,3).p3_rms_comb_sub; p3_rms(2,4).p3_rms_comb_sub; p3_rms(2,5).p3_rms_comb_sub; p3_rms(2,6).p3_rms_comb_sub; p3_rms(2,7).p3_rms_comb_sub; p3_rms(2,8).p3_rms_comb_sub; p3_rms(2,9).p3_rms_comb_sub];
    p3_rms_allsubs_sitC_sub = [p3_rms(3,1).p3_rms_comb_sub; p3_rms(3,2).p3_rms_comb_sub; p3_rms(3,3).p3_rms_comb_sub; p3_rms(3,4).p3_rms_comb_sub; p3_rms(3,5).p3_rms_comb_sub; p3_rms(3,6).p3_rms_comb_sub; p3_rms(3,7).p3_rms_comb_sub; p3_rms(3,8).p3_rms_comb_sub; p3_rms(3,9).p3_rms_comb_sub];
    p3_rms_allsubs_standA_sub = [p3_rms(4,1).p3_rms_comb_sub; p3_rms(4,2).p3_rms_comb_sub; p3_rms(4,3).p3_rms_comb_sub; p3_rms(4,4).p3_rms_comb_sub; p3_rms(4,5).p3_rms_comb_sub; p3_rms(4,6).p3_rms_comb_sub; p3_rms(4,7).p3_rms_comb_sub; p3_rms(4,8).p3_rms_comb_sub; p3_rms(4,9).p3_rms_comb_sub];
    p3_rms_allsubs_standB_sub = [p3_rms(5,1).p3_rms_comb_sub; p3_rms(5,2).p3_rms_comb_sub; p3_rms(5,3).p3_rms_comb_sub; p3_rms(5,4).p3_rms_comb_sub; p3_rms(5,5).p3_rms_comb_sub; p3_rms(5,6).p3_rms_comb_sub; p3_rms(5,7).p3_rms_comb_sub; p3_rms(5,8).p3_rms_comb_sub; p3_rms(5,9).p3_rms_comb_sub];
    p3_rms_allsubs_standC_sub = [p3_rms(6,1).p3_rms_comb_sub; p3_rms(6,2).p3_rms_comb_sub; p3_rms(6,3).p3_rms_comb_sub; p3_rms(6,4).p3_rms_comb_sub; p3_rms(6,5).p3_rms_comb_sub; p3_rms(6,6).p3_rms_comb_sub; p3_rms(6,7).p3_rms_comb_sub; p3_rms(6,8).p3_rms_comb_sub; p3_rms(6,9).p3_rms_comb_sub];
    p3_rms_allsubs_walkA_sub = [p3_rms(7,1).p3_rms_comb_sub; p3_rms(7,2).p3_rms_comb_sub; p3_rms(7,3).p3_rms_comb_sub; p3_rms(7,4).p3_rms_comb_sub; p3_rms(7,5).p3_rms_comb_sub; p3_rms(7,6).p3_rms_comb_sub; p3_rms(7,7).p3_rms_comb_sub; p3_rms(7,8).p3_rms_comb_sub; p3_rms(7,9).p3_rms_comb_sub];
    p3_rms_allsubs_walkB_sub = [p3_rms(8,1).p3_rms_comb_sub; p3_rms(8,2).p3_rms_comb_sub; p3_rms(8,3).p3_rms_comb_sub; p3_rms(8,4).p3_rms_comb_sub; p3_rms(8,5).p3_rms_comb_sub; p3_rms(8,6).p3_rms_comb_sub; p3_rms(8,7).p3_rms_comb_sub; p3_rms(8,8).p3_rms_comb_sub; p3_rms(8,9).p3_rms_comb_sub];
    p3_rms_allsubs_walkC_sub = [p3_rms(9,1).p3_rms_comb_sub; p3_rms(9,2).p3_rms_comb_sub; p3_rms(9,3).p3_rms_comb_sub; p3_rms(9,4).p3_rms_comb_sub; p3_rms(9,5).p3_rms_comb_sub; p3_rms(9,6).p3_rms_comb_sub; p3_rms(9,7).p3_rms_comb_sub; p3_rms(9,8).p3_rms_comb_sub; p3_rms(9,9).p3_rms_comb_sub];
else
    sprintf('make new columns for additional subjects')
    pause
end

p3_rms_allsubs_sit = [p3_rms_allsubs_sitA;  p3_rms_allsubs_sitB;  p3_rms_allsubs_sitC];
p3_rms_allsubs_sit_sub = [p3_rms_allsubs_sitA_sub;  p3_rms_allsubs_sitB_sub;  p3_rms_allsubs_sitC_sub];
p3_rms_allsubs_stand = [p3_rms_allsubs_standA;  p3_rms_allsubs_standB;  p3_rms_allsubs_standC];
p3_rms_allsubs_stand_sub = [p3_rms_allsubs_standA_sub;  p3_rms_allsubs_standB_sub;  p3_rms_allsubs_standC_sub];
p3_rms_allsubs_walk = [p3_rms_allsubs_walkA;  p3_rms_allsubs_walkB;  p3_rms_allsubs_walkC];
p3_rms_allsubs_walk_sub = [p3_rms_allsubs_walkA_sub;  p3_rms_allsubs_walkB_sub;  p3_rms_allsubs_walkC_sub];
p3_rms_allsubs_allconds = [p3_rms_allsubs_sitA;  p3_rms_allsubs_sitB;  p3_rms_allsubs_sitC; p3_rms_allsubs_standA;  p3_rms_allsubs_standB;  p3_rms_allsubs_standC; p3_rms_allsubs_walkA;  p3_rms_allsubs_walkB;  p3_rms_allsubs_walkC];
p3_rms_allsubs_allconds_sub = [p3_rms_allsubs_sitA_sub;  p3_rms_allsubs_sitB_sub;  p3_rms_allsubs_sitC_sub; p3_rms_allsubs_standA_sub;  p3_rms_allsubs_standB_sub;  p3_rms_allsubs_standC_sub; p3_rms_allsubs_walkA_sub;  p3_rms_allsubs_walkB_sub;  p3_rms_allsubs_walkC_sub];
[~,p3_rms_allsubs_order_sit] = sort(p3_rms_allsubs_sit,1,'ascend');
[~,p3_rms_allsubs_order_stand] = sort(p3_rms_allsubs_stand,1,'ascend');
[~,p3_rms_allsubs_order_walk] = sort(p3_rms_allsubs_walk,1,'ascend');
[~,p3_rms_allsubs_order_sub] = sort(p3_rms_allsubs_walk_sub,1,'ascend');
[~,p3_rms_allsubs_allconds_order] = sort(p3_rms_allsubs_allconds,1,'ascend');
[~,p3_rms_allsubs_allconds_order_sub] = sort(p3_rms_allsubs_allconds_sub,1,'ascend');
temp_sit = p3_rms_allsubs_sit(p3_rms_allsubs_order_sit,:); %new = old(idx,:)
temp_stand = p3_rms_allsubs_stand(p3_rms_allsubs_order_stand,:); %new = old(idx,:)
temp_walk = p3_rms_allsubs_walk(p3_rms_allsubs_order_walk,:); %new = old(idx,:)
temp_sub = p3_rms_allsubs_walk_sub(p3_rms_allsubs_order_sub,:); %new = old(idx,:)
temp_allconds = p3_rms_allsubs_allconds(p3_rms_allsubs_allconds_order,:); %new = old(idx,:)
temp_allconds_sub = p3_rms_allsubs_allconds_sub(p3_rms_allsubs_allconds_order_sub,:); %new = old(idx,:)
p3_rms_allsubs_sit_sorted = temp_sit(1:length(p3_rms_allsubs_sit),:);
p3_rms_allsubs_stand_sorted = temp_stand(1:length(p3_rms_allsubs_stand),:);
p3_rms_allsubs_walk_sorted = temp_walk(1:length(p3_rms_allsubs_walk),:);
p3_rms_allsubs_walk_sorted_sub = temp_sub(1:length(p3_rms_allsubs_walk_sub),:);
p3_rms_allsubs_allconds_sorted = temp_allconds(1:length(p3_rms_allsubs_allconds),:);
p3_rms_allsubs_allconds_sorted_sub = temp_allconds_sub(1:length(p3_rms_allsubs_allconds_sub),:);
p3_rms_allsubs_allconds_sorted_sub(any(isnan(p3_rms_allsubs_allconds_sorted_sub),2),:) = []; 
% p3_rms_allsubs_walk_sorted_artTrialsRem = p3_rms_allsubs_walk_sorted;
p3_rms_allsubs_walk_sorted_artTrialsRem = [p3_rms_allsubs_walk_sorted(1:17,:); p3_rms_allsubs_walk_sorted(19:305,:); p3_rms_allsubs_walk_sorted(307:end,:)];
%% plot scatterplot of all data points
% figure
% hold on
% scatter(p3_rms_allsubs_walk_sorted_artTrialsRem(1:17,1),p3_rms_allsubs_walk_sorted_artTrialsRem(1:17,3),[],p3_rms_allsubs_walk_sorted_artTrialsRem(1:17,5),'filled')
% scatter(p3_rms_allsubs_walk_sorted_artTrialsRem(19:305,1),p3_rms_allsubs_walk_sorted_artTrialsRem(19:305,3),[],p3_rms_allsubs_walk_sorted_artTrialsRem(19:305,5),'filled')
% scatter(p3_rms_allsubs_walk_sorted_artTrialsRem(307:end,1),p3_rms_allsubs_walk_sorted_artTrialsRem(307:end,3),[],p3_rms_allsubs_walk_sorted_artTrialsRem(307:end,5),'filled')
% scatter(p3_rms_allsubs_walk_sorted_artTrialsRem(18,1),p3_rms_allsubs_walk_sorted_artTrialsRem(18,3),50,'ko')
% scatter(p3_rms_allsubs_walk_sorted_artTrialsRem(306,1),p3_rms_allsubs_walk_sorted_artTrialsRem(306,3),50,'ko')
% xlabel('Motion RMS')
% ylabel('uV at Pz')

% art trials removed
figure
scatter(p3_rms_allsubs_walk_sorted_artTrialsRem(1:end,1),p3_rms_allsubs_walk_sorted_artTrialsRem(1:end,3),[],p3_rms_allsubs_walk_sorted_artTrialsRem(1:end,5),'filled')
xlabel('Motion RMS')
ylabel('uV at Pz')
[r,p] = corrcoef(p3_rms_allsubs_walk_sorted_artTrialsRem(1:end,1),p3_rms_allsubs_walk_sorted_artTrialsRem(1:end,3))
% all trials
[r,p] = corrcoef(p3_rms_allsubs_walk_sorted(1:end,1),p3_rms_allsubs_walk_sorted(1:end,3))

figure
hold on
scatter(p3_rms_allsubs_allconds_sorted(:,1),p3_rms_allsubs_allconds_sorted(:,3),[],p3_rms_allsubs_allconds_sorted(:,6),'filled')
xlabel('Motion RMS')
ylabel('uV at Pz')

%remake scatterplot separate variables for sit, stand, walk
p3_rms_allsubs_sit_sorted_sub2 = [p3_rms_allsubs_allconds_sorted_sub(1:37,:); p3_rms_allsubs_allconds_sorted_sub(112:148,:); p3_rms_allsubs_allconds_sorted_sub(223:259,:); p3_rms_allsubs_allconds_sorted_sub(334:370,:); p3_rms_allsubs_allconds_sorted_sub(445:481,:); p3_rms_allsubs_allconds_sorted_sub(556:592,:); p3_rms_allsubs_allconds_sorted_sub(667:703,:); p3_rms_allsubs_allconds_sorted_sub(778:814,:); p3_rms_allsubs_allconds_sorted_sub(889:925,:)];
p3_rms_allsubs_stand_sorted_sub2 = [p3_rms_allsubs_allconds_sorted_sub(38:74,:); p3_rms_allsubs_allconds_sorted_sub(149:185,:); p3_rms_allsubs_allconds_sorted_sub(260:296,:);  p3_rms_allsubs_allconds_sorted_sub(371:407,:); p3_rms_allsubs_allconds_sorted_sub(482:518,:); p3_rms_allsubs_allconds_sorted_sub(593:629,:); p3_rms_allsubs_allconds_sorted_sub(704:740,:); p3_rms_allsubs_allconds_sorted_sub(815:851,:); p3_rms_allsubs_allconds_sorted_sub(926:962,:)];
p3_rms_allsubs_walk_sorted_sub2 = [p3_rms_allsubs_allconds_sorted_sub(75:111,:); p3_rms_allsubs_allconds_sorted_sub(186:222,:); p3_rms_allsubs_allconds_sorted_sub(297:333,:); p3_rms_allsubs_allconds_sorted_sub(408:444,:); p3_rms_allsubs_allconds_sorted_sub(519:555,:); p3_rms_allsubs_allconds_sorted_sub(630:666,:); p3_rms_allsubs_allconds_sorted_sub(741:777,:); p3_rms_allsubs_allconds_sorted_sub(852:888,:); p3_rms_allsubs_allconds_sorted_sub(963:end,:)];


figure
hold on
scatter(p3_rms_allsubs_sit_sorted_sub2(:,3),p3_rms_allsubs_sit_sorted_sub2(:,5),[],p3_rms_allsubs_sit_sorted_sub2(:,2),'filled')
scatter(p3_rms_allsubs_stand_sorted_sub2(:,3),p3_rms_allsubs_stand_sorted_sub2(:,5),[],p3_rms_allsubs_stand_sorted_sub2(:,2),'filled')
scatter(p3_rms_allsubs_walk_sorted_sub2(:,3),p3_rms_allsubs_walk_sorted_sub2(:,5),[],p3_rms_allsubs_walk_sorted_sub2(:,2),'filled')
xlabel('Motion RMS')
ylabel('uV at Pz')

figure
hold on
scatter(p3_rms_allsubs_sit_sorted_sub2(:,3),p3_rms_allsubs_sit_sorted_sub2(:,5),'filled','MarkerFaceAlpha',.5,'MarkerEdgeColor',[0, 0.4470, 0.7410],'MarkerFaceColor',[0, 0.4470, 0.7410])
scatter(p3_rms_allsubs_stand_sorted_sub2(:,3),p3_rms_allsubs_stand_sorted_sub2(:,5),'filled','MarkerFaceAlpha',.3,'MarkerEdgeColor',[0.8500, 0.3250, 0.0980],'MarkerFaceColor',[0.8500, 0.3250, 0.0980])
scatter(p3_rms_allsubs_walk_sorted_sub2(:,3),p3_rms_allsubs_walk_sorted_sub2(:,5),'filled','MarkerFaceAlpha',.5,'MarkerEdgeColor',[0.9290, 0.6940, 0.1250],'MarkerFaceColor',[0.9290, 0.6940, 0.1250])
xlabel('Head Motion RMS')
ylabel('uV at Pz')
legend('Sit','Stand','Walk')
set(gca,'FontSize',14)

pd_p3_sit = fitdist(p3_rms_allsubs_sit_sorted_sub2(:,5),'Normal')
pd_p3_stand = fitdist(p3_rms_allsubs_stand_sorted_sub2(:,5),'Normal')
pd_p3_walk = fitdist(p3_rms_allsubs_walk_sorted_sub2(:,5),'Normal')

pd_rms_sit = fitdist(p3_rms_allsubs_sit_sorted_sub2(:,3),'Normal')
pd_rms_stand = fitdist(p3_rms_allsubs_stand_sorted_sub2(:,3),'Normal')
pd_rms_walk = fitdist([p3_rms_allsubs_walk_sorted_sub2(1:29,3);p3_rms_allsubs_walk_sorted_sub2(38:end,3)],'Normal')

x_values_p3 = -100:.1:150;
y_p3_sit = pdf(pd_p3_sit,x_values_p3);
y_p3_stand = pdf(pd_p3_stand,x_values_p3);
y_p3_walk = pdf(pd_p3_walk,x_values_p3);

figure
hold on
plot(x_values_p3,y_p3_sit,'-','LineWidth',2)
plot(x_values_p3,y_p3_stand,'-','LineWidth',2)
plot(x_values_p3,y_p3_walk,'-','LineWidth',2)
area(x_values_p3,y_p3_sit,'FaceColor',[0 0.4470 0.7410],'FaceAlpha',.4,'EdgeColor','none')
area(x_values_p3,y_p3_stand,'FaceColor',[0.8500 0.3250 0.0980],'FaceAlpha',.3,'EdgeColor','none')
area(x_values_p3,y_p3_walk,'FaceColor',[0.9290 0.6940 0.1250],'FaceAlpha',.2,'EdgeColor','none')
axis off

x_values_rms = -.02:.001:.3;
y_rms_sit = pdf(pd_rms_sit,x_values_rms);
y_rms_stand = pdf(pd_rms_stand,x_values_rms);
y_rms_walk = pdf(pd_rms_walk,x_values_rms);

figure
hold on
plot(x_values_rms,y_rms_sit,'-','LineWidth',2)
plot(x_values_rms,y_rms_stand,'-','LineWidth',2)
plot(x_values_rms,y_rms_walk,'-','LineWidth',2)
area(x_values_rms,y_rms_sit,'FaceColor',[0 0.4470 0.7410],'FaceAlpha',.4,'EdgeColor','none')
area(x_values_rms,y_rms_stand,'FaceColor',[0.8500 0.3250 0.0980],'FaceAlpha',.3,'EdgeColor','none')
area(x_values_rms,y_rms_walk,'FaceColor',[0.9290 0.6940 0.1250],'FaceAlpha',.2,'EdgeColor','none')
axis off

%% create 1 plot per subject for walk trials
figure
subplot(3,3,1)
scatter(p3_rms_allsubs_walk_sorted_sub(1:37,3),p3_rms_allsubs_walk_sorted_sub(1:37,5),[],p3_rms_allsubs_walk_sorted_sub(1:37,2),'filled')
subplot(3,3,2)
scatter(p3_rms_allsubs_walk_sorted_sub(38:74,3),p3_rms_allsubs_walk_sorted_sub(38:74,5),[],p3_rms_allsubs_walk_sorted_sub(38:74,2),'filled')
subplot(3,3,3)
scatter(p3_rms_allsubs_walk_sorted_sub(75:111,3),p3_rms_allsubs_walk_sorted_sub(75:111,5),[],p3_rms_allsubs_walk_sorted_sub(75:111,2),'filled')
subplot(3,3,4)
scatter(p3_rms_allsubs_walk_sorted_sub(112:148,3),p3_rms_allsubs_walk_sorted_sub(112:148,5),[],p3_rms_allsubs_walk_sorted_sub(112:148,2),'filled')
subplot(3,3,5)
scatter(p3_rms_allsubs_walk_sorted_sub(149:185,3),p3_rms_allsubs_walk_sorted_sub(149:185,5),[],p3_rms_allsubs_walk_sorted_sub(149:185,2),'filled')
subplot(3,3,6)
scatter(p3_rms_allsubs_walk_sorted_sub(186:222,3),p3_rms_allsubs_walk_sorted_sub(186:222,5),[],p3_rms_allsubs_walk_sorted_sub(186:222,2),'filled')
subplot(3,3,7)
scatter(p3_rms_allsubs_walk_sorted_sub(223:259,3),p3_rms_allsubs_walk_sorted_sub(223:259,5),[],p3_rms_allsubs_walk_sorted_sub(223:259,2),'filled')
subplot(3,3,8)
scatter(p3_rms_allsubs_walk_sorted_sub(260:296,3),p3_rms_allsubs_walk_sorted_sub(260:296,5),[],p3_rms_allsubs_walk_sorted_sub(260:296,2),'filled')
subplot(3,3,9)
scatter(p3_rms_allsubs_walk_sorted_sub(297:end,3),p3_rms_allsubs_walk_sorted_sub(297:end,5),[],p3_rms_allsubs_walk_sorted_sub(297:end,2),'filled')
xlabel('Motion RMS')
ylabel('uV at Pz')

[r1,p1] = corrcoef(p3_rms_allsubs_walk_sorted_sub(1:37,3),p3_rms_allsubs_walk_sorted_sub(1:37,5))
[r2,p2] = corrcoef(p3_rms_allsubs_walk_sorted_sub(38:74,3),p3_rms_allsubs_walk_sorted_sub(38:74,5))
[r3,p3] = corrcoef(p3_rms_allsubs_walk_sorted_sub(75:111,3),p3_rms_allsubs_walk_sorted_sub(75:111,5))
[r4,p4] = corrcoef(p3_rms_allsubs_walk_sorted_sub(112:148,3),p3_rms_allsubs_walk_sorted_sub(112:148,5))
[r5,p5] = corrcoef(p3_rms_allsubs_walk_sorted_sub(149:185,3),p3_rms_allsubs_walk_sorted_sub(149:185,5))
[r6,p6] = corrcoef(p3_rms_allsubs_walk_sorted_sub(186:222,3),p3_rms_allsubs_walk_sorted_sub(186:222,5))
[r7,p7] = corrcoef(p3_rms_allsubs_walk_sorted_sub(223:259,3),p3_rms_allsubs_walk_sorted_sub(223:259,5))
[r8,p8] = corrcoef(p3_rms_allsubs_walk_sorted_sub(260:296,3),p3_rms_allsubs_walk_sorted_sub(260:296,5))
[r9,p9] = corrcoef(p3_rms_allsubs_walk_sorted_sub(297:end,3),p3_rms_allsubs_walk_sorted_sub(297:end,5))

%% create 1 plot per subject for sit, stand, and walk trials
sit1 = p3_rms_allsubs_allconds_sorted_sub(1:37,:); 
sit2 = p3_rms_allsubs_allconds_sorted_sub(112:148,:); 
sit3 = p3_rms_allsubs_allconds_sorted_sub(223:259,:); 
sit4 = p3_rms_allsubs_allconds_sorted_sub(334:370,:); 
sit5 = p3_rms_allsubs_allconds_sorted_sub(445:481,:); 
sit6 = p3_rms_allsubs_allconds_sorted_sub(556:592,:); 
sit7 = p3_rms_allsubs_allconds_sorted_sub(667:703,:); 
sit8 = p3_rms_allsubs_allconds_sorted_sub(778:814,:); 
sit9 = p3_rms_allsubs_allconds_sorted_sub(889:925,:);

stand1 = p3_rms_allsubs_allconds_sorted_sub(38:74,:); 
stand2 = p3_rms_allsubs_allconds_sorted_sub(149:185,:); 
stand3 = p3_rms_allsubs_allconds_sorted_sub(260:296,:);  
stand4 = p3_rms_allsubs_allconds_sorted_sub(371:407,:); 
stand5 = p3_rms_allsubs_allconds_sorted_sub(482:518,:); 
stand6 = p3_rms_allsubs_allconds_sorted_sub(593:629,:); 
stand7 = p3_rms_allsubs_allconds_sorted_sub(704:740,:); 
stand8 = p3_rms_allsubs_allconds_sorted_sub(815:851,:); 
stand9 = p3_rms_allsubs_allconds_sorted_sub(926:962,:);

walk1 = p3_rms_allsubs_allconds_sorted_sub(75:111,:); 
walk2 = p3_rms_allsubs_allconds_sorted_sub(186:222,:); 
walk3 = p3_rms_allsubs_allconds_sorted_sub(297:333,:); 
walk4 = p3_rms_allsubs_allconds_sorted_sub(408:444,:); 
walk5 = p3_rms_allsubs_allconds_sorted_sub(519:555,:); 
walk6 = p3_rms_allsubs_allconds_sorted_sub(630:666,:); 
walk7 = p3_rms_allsubs_allconds_sorted_sub(741:777,:); 
walk8 = p3_rms_allsubs_allconds_sorted_sub(852:888,:); 
walk9 = p3_rms_allsubs_allconds_sorted_sub(963:end,:);

figure
subplot(3,3,1)
hold on
scatter(sit1(:,3),sit1(:,5),'filled')
scatter(stand1(:,3),stand1(:,5),'filled')
scatter(walk1(:,3),walk1(:,5),'filled')
subplot(3,3,2)
hold on
scatter(sit2(:,3),sit2(:,5),'filled')
scatter(stand2(:,3),stand2(:,5),'filled')
scatter(walk2(:,3),walk2(:,5),'filled')
subplot(3,3,3)
hold on
scatter(sit3(:,3),sit3(:,5),'filled')
scatter(stand3(:,3),stand3(:,5),'filled')
scatter(walk3(:,3),walk3(:,5),'filled')
subplot(3,3,4)
hold on
scatter(sit4(:,3),sit4(:,5),'filled')
scatter(stand4(:,3),stand4(:,5),'filled')
scatter(walk4(:,3),walk4(:,5),'filled')
subplot(3,3,5)
hold on
scatter(sit5(:,3),sit5(:,5),'filled')
scatter(stand5(:,3),stand5(:,5),'filled')
scatter(walk5(:,3),walk5(:,5),'filled')
subplot(3,3,6)
hold on
scatter(sit6(:,3),sit6(:,5),'filled')
scatter(stand6(:,3),stand6(:,5),'filled')
scatter(walk6(:,3),walk6(:,5),'filled')
subplot(3,3,7)
hold on
scatter(sit7(:,3),sit7(:,5),'filled')
scatter(stand7(:,3),stand7(:,5),'filled')
scatter(walk7(:,3),walk7(:,5),'filled')
subplot(3,3,8)
hold on
scatter(sit8(:,3),sit8(:,5),'filled')
scatter(stand8(:,3),stand8(:,5),'filled')
scatter(walk8(:,3),walk8(:,5),'filled')
subplot(3,3,9)
hold on
scatter(sit9(:,3),sit9(:,5),'filled')
scatter(stand9(:,3),stand9(:,5),'filled')
scatter(walk9(:,3),walk9(:,5),'filled')
xlabel('Motion RMS')
ylabel('uV at Pz')

%% assign condition and session
conditions=[]; sessions= [];
for ii = 1:length(p3_rms_allsubs_allconds_sorted_sub)
    if p3_rms_allsubs_allconds_sorted_sub(ii,2) == 1
        conditions{ii} = 'sit';
        sessions{ii} = 'A';
    elseif p3_rms_allsubs_allconds_sorted_sub(ii,2) == 2
        conditions{ii} = 'sit';
        sessions{ii} = 'B';
    elseif p3_rms_allsubs_allconds_sorted_sub(ii,2) == 3
        conditions{ii} = 'sit';
        sessions{ii} = 'C';
    elseif p3_rms_allsubs_allconds_sorted_sub(ii,2) == 4
        conditions{ii} = 'stand';
        sessions{ii} = 'A';
    elseif p3_rms_allsubs_allconds_sorted_sub(ii,2) == 5
        conditions{ii} = 'stand';
        sessions{ii} = 'B';
    elseif p3_rms_allsubs_allconds_sorted_sub(ii,2) == 6
        conditions{ii} = 'stand';
        sessions{ii} = 'C';
    elseif p3_rms_allsubs_allconds_sorted_sub(ii,2) == 7
        conditions{ii} = 'walk';
        sessions{ii} = 'A';
    elseif p3_rms_allsubs_allconds_sorted_sub(ii,2) == 8
        conditions{ii} = 'walk';
        sessions{ii} = 'B';
    elseif p3_rms_allsubs_allconds_sorted_sub(ii,2) == 9
        conditions{ii} = 'walk';
        sessions{ii} = 'C';
    end
end
sessions = sessions';
conditions = conditions';
%% create linear model with all conditions and subject as random factor
subjects = categorical(p3_rms_allsubs_allconds_sorted_sub(:,1));
% ks = categorical(p3_rms_allsubs_allconds_sorted_sub(:,2));
conditions = categorical(conditions);
sessions = categorical(sessions);
motions = double(p3_rms_allsubs_allconds_sorted_sub(:,3));
p3_mean = double(p3_rms_allsubs_allconds_sorted_sub(:,5));
p3_median = double(p3_rms_allsubs_allconds_sorted_sub(:,6));

%% create linear model with all conditions and subject as random factor
subjects = categorical(p3_rms_allsubs_allconds_sorted_sub(:,1));
% ks = categorical(p3_rms_allsubs_allconds_sorted_sub(:,2));
conditions = categorical(conditions);
sessions = categorical(sessions);
motions = double(p3_rms_allsubs_allconds_sorted_sub(:,3));
p3_mean = double(p3_rms_allsubs_allconds_sorted_sub(:,5));
p3_median = double(p3_rms_allsubs_allconds_sorted_sub(:,6));
tbl = table(subjects,conditions,sessions,motions,p3_mean,p3_median,'VariableNames',{'Subject','Condition','Session','Motion_RMS_Magnitude','P3_Mean','P3_Median'});
lme = fitlme(tbl,'P3_Mean ~ Condition + (1|Subject)')

%% scatterplot with boxplots
p3_rms_ssw_sub_tbl = tbl;
figure
h1 = scatterhist(p3_rms_ssw_sub_tbl{:,4},p3_rms_ssw_sub_tbl{:,5},'Group',p3_rms_ssw_sub_tbl{:,2});
hold on;
clr = get(h1(1),'colororder');
boxplot(h1(2),p3_rms_ssw_sub_tbl{:,4},p3_rms_ssw_sub_tbl{:,2},'orientation','horizontal',...
     'label',{'','',''},'color',clr);
boxplot(h1(3),p3_rms_ssw_sub_tbl{:,5},p3_rms_ssw_sub_tbl{:,2},'orientation','horizontal',...
     'label', {'','',''},'color',clr);
set(h1(2:3),'XTickLabel','');
view(h1(3),[270,90]);  % Rotate the Y plot
axis(h1(1),'auto');  % Sync axes
hold off;

%% scatterplot with gaussians
figure
h1 = scatterhist(p3_rms_ssw_sub_tbl{:,4},p3_rms_ssw_sub_tbl{:,5},'Group',p3_rms_ssw_sub_tbl{:,2},'Marker','o+d','MarkerSize',[8,8,8],'LineWidth',[.8,.8,.8]);
hold on
plot(h1(2),x_values_rms,[y_rms_sit;y_rms_stand;y_rms_walk],'LineWidth',2)
plot(h1(3),x_values_p3,[y_p3_sit;y_p3_stand;y_p3_walk],'LineWidth',2)
set(h1(2:3),'XTickLabel','');
view(h1(3),[90,270]);  % Rotate the Y plot
axis(h1(1),'auto');  % Sync axes
hold off;
xlabel('Head Motion RMS')
ylabel('uV at Pz')
legend('Sit','Stand','Walk')
set(gca,'FontSize',14)

%% Subject 1 scatterplot with gaussians
pd_p3_sit1 = fitdist(tbl{1:37,5},'Normal');
y_p3_sit1 = pdf(pd_p3_sit1,x_values_p3);
pd_rms_sit1 = fitdist(tbl{1:37,4},'Normal');
y_rms_sit1 = pdf(pd_rms_sit1,x_values_rms);

pd_p3_stand1 = fitdist(tbl{38:74,5},'Normal');
y_p3_stand1 = pdf(pd_p3_stand1,x_values_p3);
pd_rms_stand1 = fitdist(tbl{38:74,4},'Normal');
y_rms_stand1 = pdf(pd_rms_stand1,x_values_rms);

pd_p3_walk1 = fitdist(tbl{75:111,5},'Normal');
y_p3_walk1 = pdf(pd_p3_walk1,x_values_p3);
pd_rms_walk1 = fitdist(tbl{75:111,4},'Normal');
y_rms_walk1 = pdf(pd_rms_walk1,x_values_rms);

figure
h1 = scatterhist(tbl{1:111,4},tbl{1:111,5},'Group',tbl{1:111,2},'Marker','o+d','MarkerSize',[8,8,8],'LineWidth',[.8,.8,.8]);
hold on
plot(h1(2),x_values_rms,[y_rms_sit1;y_rms_stand1;y_rms_walk1],'LineWidth',2)
plot(h1(3),x_values_p3,[y_p3_sit1;y_p3_stand1;y_p3_walk1],'LineWidth',2)
set(h1(2:3),'XTickLabel','');
view(h1(3),[90,270]);  % Rotate the Y plot
axis(h1(1),'auto');  % Sync axes
hold off;
title('Subject 1')
xlabel('Head Motion RMS')
ylabel('uV at Pz')
legend('Sit','Stand','Walk')
set(gca,'FontSize',14)

%% Subject 2 scatterplot with gaussians
pd_p3_sit1 = fitdist(tbl{112:148,5},'Normal');
y_p3_sit1 = pdf(pd_p3_sit1,x_values_p3);
pd_rms_sit1 = fitdist(tbl{112:148,4},'Normal');
y_rms_sit1 = pdf(pd_rms_sit1,x_values_rms);

pd_p3_stand1 = fitdist(tbl{149:185,5},'Normal');
y_p3_stand1 = pdf(pd_p3_stand1,x_values_p3);
pd_rms_stand1 = fitdist(tbl{149:185,4},'Normal');
y_rms_stand1 = pdf(pd_rms_stand1,x_values_rms);

pd_p3_walk1 = fitdist(tbl{186:222,5},'Normal');
y_p3_walk1 = pdf(pd_p3_walk1,x_values_p3);
pd_rms_walk1 = fitdist(tbl{186:222,4},'Normal');
y_rms_walk1 = pdf(pd_rms_walk1,x_values_rms);

figure
h1 = scatterhist(tbl{112:222,4},tbl{112:222,5},'Group',tbl{112:222,2},'Marker','o+d','MarkerSize',[8,8,8],'LineWidth',[.8,.8,.8]);
hold on
plot(h1(2),x_values_rms,[y_rms_sit1;y_rms_stand1;y_rms_walk1],'LineWidth',2)
plot(h1(3),x_values_p3,[y_p3_sit1;y_p3_stand1;y_p3_walk1],'LineWidth',2)
set(h1(2:3),'XTickLabel','');
view(h1(3),[90,270]);  % Rotate the Y plot
axis(h1(1),'auto');  % Sync axes
hold off;
title('Subject 2')
xlabel('Head Motion RMS')
ylabel('uV at Pz')
legend('Sit','Stand','Walk')
set(gca,'FontSize',14)
%% Subject 3 scatterplot with gaussians
pd_p3_sit1 = fitdist(tbl{223:259,5},'Normal');
y_p3_sit1 = pdf(pd_p3_sit1,x_values_p3);
pd_rms_sit1 = fitdist(tbl{223:259,4},'Normal');
y_rms_sit1 = pdf(pd_rms_sit1,x_values_rms);

pd_p3_stand1 = fitdist(tbl{260:296,5},'Normal');
y_p3_stand1 = pdf(pd_p3_stand1,x_values_p3);
pd_rms_stand1 = fitdist(tbl{260:296,4},'Normal');
y_rms_stand1 = pdf(pd_rms_stand1,x_values_rms);

pd_p3_walk1 = fitdist(tbl{297:333,5},'Normal');
y_p3_walk1 = pdf(pd_p3_walk1,x_values_p3);
pd_rms_walk1 = fitdist(tbl{297:333,4},'Normal');
y_rms_walk1 = pdf(pd_rms_walk1,x_values_rms);

figure
h1 = scatterhist(tbl{223:333,4},tbl{223:333,5},'Group',tbl{223:333,2},'Marker','o+d','MarkerSize',[8,8,8],'LineWidth',[.8,.8,.8]);
hold on
plot(h1(2),x_values_rms,[y_rms_sit1;y_rms_stand1;y_rms_walk1],'LineWidth',2)
plot(h1(3),x_values_p3,[y_p3_sit1;y_p3_stand1;y_p3_walk1],'LineWidth',2)
set(h1(2:3),'XTickLabel','');
view(h1(3),[90,270]);  % Rotate the Y plot
axis(h1(1),'auto');  % Sync axes
hold off;
title('Subject 3')
xlabel('Head Motion RMS')
ylabel('uV at Pz')
legend('Sit','Stand','Walk')
set(gca,'FontSize',14)

%% Subject 4 scatterplot with gaussians
pd_p3_sit1 = fitdist(tbl{334:370,5},'Normal');
y_p3_sit1 = pdf(pd_p3_sit1,x_values_p3);
pd_rms_sit1 = fitdist(tbl{334:370,4},'Normal');
y_rms_sit1 = pdf(pd_rms_sit1,x_values_rms);

pd_p3_stand1 = fitdist(tbl{371:407,5},'Normal');
y_p3_stand1 = pdf(pd_p3_stand1,x_values_p3);
pd_rms_stand1 = fitdist(tbl{371:407,4},'Normal');
y_rms_stand1 = pdf(pd_rms_stand1,x_values_rms);

pd_p3_walk1 = fitdist(tbl{408:444,5},'Normal');
y_p3_walk1 = pdf(pd_p3_walk1,x_values_p3);
pd_rms_walk1 = fitdist(tbl{408:444,4},'Normal');
y_rms_walk1 = pdf(pd_rms_walk1,x_values_rms);

figure
h1 = scatterhist(tbl{334:444,4},tbl{334:444,5},'Group',tbl{334:444,2},'Marker','o+d','MarkerSize',[8,8,8],'LineWidth',[.8,.8,.8]);
hold on
plot(h1(2),x_values_rms,[y_rms_sit1;y_rms_stand1;y_rms_walk1],'LineWidth',2)
plot(h1(3),x_values_p3,[y_p3_sit1;y_p3_stand1;y_p3_walk1],'LineWidth',2)
set(h1(2:3),'XTickLabel','');
view(h1(3),[90,270]);  % Rotate the Y plot
axis(h1(1),'auto');  % Sync axes
hold off;
title('Subject 4')
xlabel('Head Motion RMS')
ylabel('uV at Pz')
legend('Sit','Stand','Walk')
set(gca,'FontSize',14)
%% Subject 5 scatterplot with gaussians
pd_p3_sit1 = fitdist(tbl{445:481,5},'Normal');
y_p3_sit1 = pdf(pd_p3_sit1,x_values_p3);
pd_rms_sit1 = fitdist(tbl{445:481,4},'Normal');
y_rms_sit1 = pdf(pd_rms_sit1,x_values_rms);

pd_p3_stand1 = fitdist(tbl{482:518,5},'Normal');
y_p3_stand1 = pdf(pd_p3_stand1,x_values_p3);
pd_rms_stand1 = fitdist(tbl{482:518,4},'Normal');
y_rms_stand1 = pdf(pd_rms_stand1,x_values_rms);

pd_p3_walk1 = fitdist(tbl{519:555,5},'Normal');
y_p3_walk1 = pdf(pd_p3_walk1,x_values_p3);
pd_rms_walk1 = fitdist(tbl{519:555,4},'Normal');
y_rms_walk1 = pdf(pd_rms_walk1,x_values_rms);

figure
h1 = scatterhist(tbl{445:555,4},tbl{445:555,5},'Group',tbl{445:555,2},'Marker','o+d','MarkerSize',[8,8,8],'LineWidth',[.8,.8,.8]);
hold on
plot(h1(2),x_values_rms,[y_rms_sit1;y_rms_stand1;y_rms_walk1],'LineWidth',2)
plot(h1(3),x_values_p3,[y_p3_sit1;y_p3_stand1;y_p3_walk1],'LineWidth',2)
set(h1(2:3),'XTickLabel','');
view(h1(3),[90,270]);  % Rotate the Y plot
axis(h1(1),'auto');  % Sync axes
hold off;
title('Subject 5')
xlabel('Head Motion RMS')
ylabel('uV at Pz')
legend('Sit','Stand','Walk')
set(gca,'FontSize',14)

%% Subject 6 scatterplot with gaussians
pd_p3_sit1 = fitdist(tbl{556:592,5},'Normal');
y_p3_sit1 = pdf(pd_p3_sit1,x_values_p3);
pd_rms_sit1 = fitdist(tbl{556:592,4},'Normal');
y_rms_sit1 = pdf(pd_rms_sit1,x_values_rms);

pd_p3_stand1 = fitdist(tbl{593:629,5},'Normal');
y_p3_stand1 = pdf(pd_p3_stand1,x_values_p3);
pd_rms_stand1 = fitdist(tbl{593:629,4},'Normal');
y_rms_stand1 = pdf(pd_rms_stand1,x_values_rms);

pd_p3_walk1 = fitdist(tbl{630:666,5},'Normal');
y_p3_walk1 = pdf(pd_p3_walk1,x_values_p3);
pd_rms_walk1 = fitdist(tbl{630:666,4},'Normal');
y_rms_walk1 = pdf(pd_rms_walk1,x_values_rms);

figure
h1 = scatterhist(tbl{556:666,4},tbl{556:666,5},'Group',tbl{556:666,2},'Marker','o+d','MarkerSize',[8,8,8],'LineWidth',[.8,.8,.8]);
hold on
plot(h1(2),x_values_rms,[y_rms_sit1;y_rms_stand1;y_rms_walk1],'LineWidth',2)
plot(h1(3),x_values_p3,[y_p3_sit1;y_p3_stand1;y_p3_walk1],'LineWidth',2)
set(h1(2:3),'XTickLabel','');
view(h1(3),[90,270]);  % Rotate the Y plot
axis(h1(1),'auto');  % Sync axes
hold off;
title('Subject 6')
xlabel('Head Motion RMS')
ylabel('uV at Pz')
legend('Sit','Stand','Walk')
set(gca,'FontSize',14)

%% Subject 7 scatterplot with gaussians
pd_p3_sit1 = fitdist(tbl{667:703,5},'Normal');
y_p3_sit1 = pdf(pd_p3_sit1,x_values_p3);
pd_rms_sit1 = fitdist(tbl{667:703,4},'Normal');
y_rms_sit1 = pdf(pd_rms_sit1,x_values_rms);

pd_p3_stand1 = fitdist(tbl{704:740,5},'Normal');
y_p3_stand1 = pdf(pd_p3_stand1,x_values_p3);
pd_rms_stand1 = fitdist(tbl{704:740,4},'Normal');
y_rms_stand1 = pdf(pd_rms_stand1,x_values_rms);

pd_p3_walk1 = fitdist(tbl{741:777,5},'Normal');
y_p3_walk1 = pdf(pd_p3_walk1,x_values_p3);
pd_rms_walk1 = fitdist(tbl{741:777,4},'Normal');
y_rms_walk1 = pdf(pd_rms_walk1,x_values_rms);

figure
h1 = scatterhist(tbl{667:777,4},tbl{667:777,5},'Group',tbl{667:777,2},'Marker','o+d','MarkerSize',[8,8,8],'LineWidth',[.8,.8,.8]);
hold on
plot(h1(2),x_values_rms,[y_rms_sit1;y_rms_stand1;y_rms_walk1],'LineWidth',2)
plot(h1(3),x_values_p3,[y_p3_sit1;y_p3_stand1;y_p3_walk1],'LineWidth',2)
set(h1(2:3),'XTickLabel','');
view(h1(3),[90,270]);  % Rotate the Y plot
axis(h1(1),'auto');  % Sync axes
hold off;
title('Subject 7')
xlabel('Head Motion RMS')
ylabel('uV at Pz')
legend('Sit','Stand','Walk')
set(gca,'FontSize',14)

%% Subject 8 scatterplot with gaussians
pd_p3_sit1 = fitdist(tbl{778:814,5},'Normal');
y_p3_sit1 = pdf(pd_p3_sit1,x_values_p3);
pd_rms_sit1 = fitdist(tbl{778:814,4},'Normal');
y_rms_sit1 = pdf(pd_rms_sit1,x_values_rms);

pd_p3_stand1 = fitdist(tbl{815:851,5},'Normal');
y_p3_stand1 = pdf(pd_p3_stand1,x_values_p3);
pd_rms_stand1 = fitdist(tbl{815:851,4},'Normal');
y_rms_stand1 = pdf(pd_rms_stand1,x_values_rms);

pd_p3_walk1 = fitdist(tbl{852:888,5},'Normal');
y_p3_walk1 = pdf(pd_p3_walk1,x_values_p3);
pd_rms_walk1 = fitdist(tbl{852:888,4},'Normal');
y_rms_walk1 = pdf(pd_rms_walk1,x_values_rms);

figure
h1 = scatterhist(tbl{778:888,4},tbl{778:888,5},'Group',tbl{778:888,2},'Marker','o+d','MarkerSize',[8,8,8],'LineWidth',[.8,.8,.8]);
hold on
plot(h1(2),x_values_rms,[y_rms_sit1;y_rms_stand1;y_rms_walk1],'LineWidth',2)
plot(h1(3),x_values_p3,[y_p3_sit1;y_p3_stand1;y_p3_walk1],'LineWidth',2)
set(h1(2:3),'XTickLabel','');
view(h1(3),[90,270]);  % Rotate the Y plot
axis(h1(1),'auto');  % Sync axes
hold off;
title('Subject 8')
xlabel('Head Motion RMS')
ylabel('uV at Pz')
legend('Sit','Stand','Walk')
set(gca,'FontSize',14)

%% Subject 9 scatterplot with gaussians
pd_p3_sit1 = fitdist(tbl{889:925,5},'Normal');
y_p3_sit1 = pdf(pd_p3_sit1,x_values_p3);
pd_rms_sit1 = fitdist(tbl{889:925,4},'Normal');
y_rms_sit1 = pdf(pd_rms_sit1,x_values_rms);

pd_p3_stand1 = fitdist(tbl{926:962,5},'Normal');
y_p3_stand1 = pdf(pd_p3_stand1,x_values_p3);
pd_rms_stand1 = fitdist(tbl{926:962,4},'Normal');
y_rms_stand1 = pdf(pd_rms_stand1,x_values_rms);

pd_p3_walk1 = fitdist(tbl{963:999,5},'Normal');
y_p3_walk1 = pdf(pd_p3_walk1,x_values_p3);
pd_rms_walk1 = fitdist(tbl{963:999,4},'Normal');
y_rms_walk1 = pdf(pd_rms_walk1,x_values_rms);

figure
h1 = scatterhist(tbl{889:999,4},tbl{889:999,5},'Group',tbl{889:999,2},'Marker','o+d','MarkerSize',[8,8,8],'LineWidth',[.8,.8,.8]);
hold on
plot(h1(2),x_values_rms,[y_rms_sit1;y_rms_stand1;y_rms_walk1],'LineWidth',2)
plot(h1(3),x_values_p3,[y_p3_sit1;y_p3_stand1;y_p3_walk1],'LineWidth',2)
set(h1(2:3),'XTickLabel','');
view(h1(3),[90,270]);  % Rotate the Y plot
axis(h1(1),'auto');  % Sync axes
hold off;
title('Subject 9')
xlabel('Head Motion RMS')
ylabel('uV at Pz')
legend('Sit','Stand','Walk')
set(gca,'FontSize',14)

%% create 8 bins and plot uV vs motion
div = 8;
nbinel = round(numel(p3_rms_allsubs_walk_sorted_artTrialsRem(:,1))/div)-1;
p3_rms_bin1 = mean(p3_rms_allsubs_walk_sorted_artTrialsRem(1:nbinel,:))/(nbinel-1);
p3_rms_bin2 = mean(p3_rms_allsubs_walk_sorted_artTrialsRem(nbinel+1:nbinel*2,:))/nbinel;
p3_rms_bin3 = mean(p3_rms_allsubs_walk_sorted_artTrialsRem(2*nbinel+1:nbinel*3,:))/nbinel;
p3_rms_bin4 = mean(p3_rms_allsubs_walk_sorted_artTrialsRem(3*nbinel+1:nbinel*4,:))/nbinel;
p3_rms_bin5 = mean(p3_rms_allsubs_walk_sorted_artTrialsRem(4*nbinel+1:nbinel*5,:))/nbinel;
p3_rms_bin6 = mean(p3_rms_allsubs_walk_sorted_artTrialsRem(5*nbinel+1:nbinel*6,:))/nbinel;
p3_rms_bin7 = mean(p3_rms_allsubs_walk_sorted_artTrialsRem(6*nbinel+1:nbinel*7,:))/nbinel;
if div == 8
    p3_rms_bin8 = mean(p3_rms_allsubs_walk_sorted_artTrialsRem(7*nbinel+1:end,:))/(nbinel+4);
end

figure
hold on
plot(1,p3_rms_bin1(1,3),'.','MarkerSize',20)
plot(2,p3_rms_bin2(1,3),'.','MarkerSize',20)
plot(3,p3_rms_bin3(1,3),'.','MarkerSize',20)
plot(4,p3_rms_bin4(1,3),'.','MarkerSize',20)
plot(5,p3_rms_bin5(1,3),'.','MarkerSize',20)
plot(6,p3_rms_bin6(1,3),'.','MarkerSize',20)
plot(7,p3_rms_bin7(1,3),'.','MarkerSize',20)
if div == 8
plot(8,p3_rms_bin8(1,3),'.','MarkerSize',20)
end
xlabel('Motion level')
ylabel('uV at Pz')
legend('1 - Least Motion','2','3','4','5','6','7','8 - Most Motion')
set(gca,'FontSize',14)

[p3_rms_bin1(1,3) p3_rms_bin2(1,3) p3_rms_bin3(1,3) p3_rms_bin4(1,3) p3_rms_bin5(1,3) p3_rms_bin6(1,3) p3_rms_bin7(1,3) p3_rms_bin8(1,3)]

%% create linear model with subject as random factor
% subjects = categorical(p3_rms_allsubs_walk_sorted_sub(:,1));
% sessions = categorical(p3_rms_allsubs_walk_sorted_sub(:,2));
% motions = double(p3_rms_allsubs_walk_sorted_sub(:,3));
% p3_mean = double(p3_rms_allsubs_walk_sorted_sub(:,5));
% p3_median = double(p3_rms_allsubs_walk_sorted_sub(:,6));
% tbl = table(subjects,sessions,motions,p3_mean,p3_median,'VariableNames',{'Subject','Session','Motion_RMS_Magnitude','P3_Mean','P3_Median'});
% lme = fitlme(tbl,'P3_Mean ~ Motion_RMS_Magnitude + (1|Subject)')

%% create linear model with subject as random factor
% subjects_out = categorical([p3_rms_allsubs_allconds_sorted_sub(1:29,1);p3_rms_allsubs_allconds_sorted_sub(38:end,1)]);
% % sessions_out = categorical([p3_rms_allsubs_allconds_sorted_sub(1:29,2);p3_rms_allsubs_allconds_sorted_sub(38:end,2)]);
% conditions_out = categorical([conditions(1:29);conditions(38:end)]);
% sessions_out = categorical([sessions(1:29);sessions(38:end)]);
% motions_out = double([p3_rms_allsubs_allconds_sorted_sub(1:29,3);p3_rms_allsubs_allconds_sorted_sub(38:end,3)]);
% p3_mean_out = double([p3_rms_allsubs_allconds_sorted_sub(1:29,5);p3_rms_allsubs_allconds_sorted_sub(38:end,5)]);
% p3_median_out = double([p3_rms_allsubs_allconds_sorted_sub(1:29,6);p3_rms_allsubs_walk_sorted_sub(38:end,6)]);
% tbl_out = table(subjects_out,sessions_out,conditions_out,motions_out,p3_mean_out,p3_median_out,'VariableNames',{'Subject','Session','Condition','Motion_RMS_Magnitude','P3_Mean','P3_Median'});
% lme = fitlme(tbl_out,'P3_Mean ~ Condition + (1|Subject)')

%% create grand average erp (no baseline subtraction)
% p3_rms_erp_walkA = [p3_rms(7,1).erp_pz_target'; p3_rms(7,2).erp_pz_target'; p3_rms(7,3).erp_pz_target'; p3_rms(7,4).erp_pz_target'; p3_rms(7,5).erp_pz_target'; p3_rms(7,6).erp_pz_target'];
% p3_rms_erp_walkB = [p3_rms(8,1).erp_pz_target'; p3_rms(8,2).erp_pz_target'; p3_rms(8,3).erp_pz_target'; p3_rms(8,4).erp_pz_target'; p3_rms(8,5).erp_pz_target'; p3_rms(8,6).erp_pz_target'];
% p3_rms_erp_walkC = [p3_rms(9,1).erp_pz_target'; p3_rms(9,2).erp_pz_target'; p3_rms(9,3).erp_pz_target'; p3_rms(9,4).erp_pz_target'; p3_rms(9,5).erp_pz_target'; p3_rms(9,6).erp_pz_target'];
% p3_rms_erp_walk = [p3_rms_erp_walkA;  p3_rms_erp_walkB;  p3_rms_erp_walkC];  
% temp2 = p3_rms_erp_walk(p3_rms_allsubs_order,:); %new = old(idx,:)
% p3_rms_erp_walk_sorted = temp2(1:size(p3_rms_erp_walk,1),:);

%%
p3_rms_erp_sitA = [p3_rms(1,1).erp_pz_target_bL'; p3_rms(1,2).erp_pz_target_bL'; p3_rms(1,3).erp_pz_target_bL'; p3_rms(1,4).erp_pz_target_bL'; p3_rms(1,5).erp_pz_target_bL'; p3_rms(1,6).erp_pz_target_bL'; p3_rms(1,7).erp_pz_target_bL'; p3_rms(1,8).erp_pz_target_bL'; p3_rms(1,9).erp_pz_target_bL'];
p3_rms_erp_sitB = [p3_rms(2,1).erp_pz_target_bL'; p3_rms(2,2).erp_pz_target_bL'; p3_rms(2,3).erp_pz_target_bL'; p3_rms(2,4).erp_pz_target_bL'; p3_rms(2,5).erp_pz_target_bL'; p3_rms(2,6).erp_pz_target_bL'; p3_rms(2,7).erp_pz_target_bL'; p3_rms(2,8).erp_pz_target_bL'; p3_rms(2,9).erp_pz_target_bL'];
p3_rms_erp_sitC = [p3_rms(3,1).erp_pz_target_bL'; p3_rms(3,2).erp_pz_target_bL'; p3_rms(3,3).erp_pz_target_bL'; p3_rms(3,4).erp_pz_target_bL'; p3_rms(3,5).erp_pz_target_bL'; p3_rms(3,6).erp_pz_target_bL'; p3_rms(3,7).erp_pz_target_bL'; p3_rms(3,8).erp_pz_target_bL'; p3_rms(3,9).erp_pz_target_bL'];
p3_rms_erp_sit = [p3_rms_erp_sitA;  p3_rms_erp_sitB;  p3_rms_erp_sitC];  
std_sit = std(p3_rms_erp_sit);

figure
plot(times,p3_rms_erp_sit,'-','LineWidth',1)
hold on
plot(times,mean(p3_rms_erp_sit,1),'k-','LineWidth',1)
plot(times,mean(p3_rms_erp_sit,1)+(3*std_sit),'k-.','LineWidth',1)
plot(times,mean(p3_rms_erp_sit,1)-(3*std_sit),'k-.','LineWidth',1)

p3_rms_erp_standA = [p3_rms(4,1).erp_pz_target_bL'; p3_rms(4,2).erp_pz_target_bL'; p3_rms(4,3).erp_pz_target_bL'; p3_rms(4,4).erp_pz_target_bL'; p3_rms(4,5).erp_pz_target_bL'; p3_rms(4,6).erp_pz_target_bL'; p3_rms(4,7).erp_pz_target_bL'; p3_rms(4,8).erp_pz_target_bL'; p3_rms(4,9).erp_pz_target_bL'];
p3_rms_erp_standB = [p3_rms(5,1).erp_pz_target_bL'; p3_rms(5,2).erp_pz_target_bL'; p3_rms(5,3).erp_pz_target_bL'; p3_rms(5,4).erp_pz_target_bL'; p3_rms(5,5).erp_pz_target_bL'; p3_rms(5,6).erp_pz_target_bL'; p3_rms(5,7).erp_pz_target_bL'; p3_rms(5,8).erp_pz_target_bL'; p3_rms(5,9).erp_pz_target_bL'];
p3_rms_erp_standC = [p3_rms(6,1).erp_pz_target_bL'; p3_rms(6,2).erp_pz_target_bL'; p3_rms(6,3).erp_pz_target_bL'; p3_rms(6,4).erp_pz_target_bL'; p3_rms(6,5).erp_pz_target_bL'; p3_rms(6,6).erp_pz_target_bL'; p3_rms(6,7).erp_pz_target_bL'; p3_rms(6,8).erp_pz_target_bL'; p3_rms(6,9).erp_pz_target_bL'];
p3_rms_erp_stand = [p3_rms_erp_standA;  p3_rms_erp_standB;  p3_rms_erp_standC];  
std_stand = std(p3_rms_erp_stand);

figure
plot(times,p3_rms_erp_stand,'-','LineWidth',1)
hold on
plot(times,mean(p3_rms_erp_stand,1),'k-','LineWidth',1)
plot(times,mean(p3_rms_erp_stand,1)+(3*std_stand),'k-.','LineWidth',1)
plot(times,mean(p3_rms_erp_stand,1)-(3*std_stand),'k-.','LineWidth',1)


std_walk = std(p3_rms_erp_walk);

figure
plot(times,p3_rms_erp_walk,'-','LineWidth',1)
hold on
plot(times,mean(p3_rms_erp_walk,1),'k-','LineWidth',1)
plot(times,mean(p3_rms_erp_walk,1)+(3*std_walk),'k-.','LineWidth',1)
plot(times,mean(p3_rms_erp_walk,1)-(3*std_walk),'k-.','LineWidth',1)

%% create grand average erp
p3_rms_erp_walkA = [p3_rms(7,1).erp_pz_target_bL'; p3_rms(7,2).erp_pz_target_bL'; p3_rms(7,3).erp_pz_target_bL'; p3_rms(7,4).erp_pz_target_bL'; p3_rms(7,5).erp_pz_target_bL'; p3_rms(7,6).erp_pz_target_bL'; p3_rms(7,7).erp_pz_target_bL'; p3_rms(7,8).erp_pz_target_bL'; p3_rms(7,9).erp_pz_target_bL'];
p3_rms_erp_walkB = [p3_rms(8,1).erp_pz_target_bL'; p3_rms(8,2).erp_pz_target_bL'; p3_rms(8,3).erp_pz_target_bL'; p3_rms(8,4).erp_pz_target_bL'; p3_rms(8,5).erp_pz_target_bL'; p3_rms(8,6).erp_pz_target_bL'; p3_rms(8,7).erp_pz_target_bL'; p3_rms(8,8).erp_pz_target_bL'; p3_rms(8,9).erp_pz_target_bL'];
p3_rms_erp_walkC = [p3_rms(9,1).erp_pz_target_bL'; p3_rms(9,2).erp_pz_target_bL'; p3_rms(9,3).erp_pz_target_bL'; p3_rms(9,4).erp_pz_target_bL'; p3_rms(9,5).erp_pz_target_bL'; p3_rms(9,6).erp_pz_target_bL'; p3_rms(9,7).erp_pz_target_bL'; p3_rms(9,8).erp_pz_target_bL'; p3_rms(9,9).erp_pz_target_bL'];
p3_rms_erp_walk = [p3_rms_erp_walkA;  p3_rms_erp_walkB;  p3_rms_erp_walkC];  
temp2_sit = p3_rms_erp_sit(p3_rms_allsubs_order_sit,:); %new = old(idx,:)
temp2_stand = p3_rms_erp_stand(p3_rms_allsubs_order_stand,:); %new = old(idx,:)
temp2_walk = p3_rms_erp_walk(p3_rms_allsubs_order_walk,:); %new = old(idx,:)
p3_rms_erp_sit_sorted_bL = temp2_sit(1:size(p3_rms_erp_sit,1),:);
p3_rms_erp_stand_sorted_bL = temp2_stand(1:size(p3_rms_erp_stand,1),:);
p3_rms_erp_walk_sorted_bL = temp2_walk(1:size(p3_rms_erp_walk,1),:);
% p3_rms_erp_walk_sorted_bL_artTrialsRem = p3_rms_erp_walk_sorted_bL;
p3_rms_erp_walk_sorted_bL_artTrialsRem = [p3_rms_erp_walk_sorted_bL(1:17,:); p3_rms_erp_walk_sorted_bL(19:305,:); p3_rms_erp_walk_sorted_bL(307:end,:)];

%% plot erp including all bins 
nbinel = round(numel(p3_rms_erp_walk_sorted_bL_artTrialsRem(:,1))/div)-1;
p3_erp_bin1 = mean(p3_rms_erp_walk_sorted_bL_artTrialsRem(1:nbinel,:))/(nbinel-1);
p3_erp_bin2 = mean(p3_rms_erp_walk_sorted_bL_artTrialsRem(nbinel+1:nbinel*2,:))/nbinel;
p3_erp_bin3 = mean(p3_rms_erp_walk_sorted_bL_artTrialsRem(2*nbinel+1:nbinel*3,:))/nbinel;
p3_erp_bin4 = mean(p3_rms_erp_walk_sorted_bL_artTrialsRem(3*nbinel+1:nbinel*4,:))/nbinel;
p3_erp_bin5 = mean(p3_rms_erp_walk_sorted_bL_artTrialsRem(4*nbinel+1:nbinel*5,:))/nbinel;
p3_erp_bin6 = mean(p3_rms_erp_walk_sorted_bL_artTrialsRem(5*nbinel+1:nbinel*6,:))/nbinel;
p3_erp_bin7 = mean(p3_rms_erp_walk_sorted_bL_artTrialsRem(6*nbinel+1:nbinel*7,:))/nbinel;
if div == 8
p3_erp_bin8 = mean(p3_rms_erp_walk_sorted_bL_artTrialsRem(7*nbinel+1:end,:))/(nbinel+4);
end

% grand average erp
times = -200:3.33:796;
figure
hold on
plot(times,p3_erp_bin1,'-','LineWidth',2)
plot(times,p3_erp_bin2,'-','LineWidth',2)
plot(times,p3_erp_bin3,'-','LineWidth',2)
plot(times,p3_erp_bin4,'-','LineWidth',2)
plot(times,p3_erp_bin5,'-','LineWidth',2)
plot(times,p3_erp_bin6,'-','LineWidth',2)
plot(times,p3_erp_bin7,'-','LineWidth',2)
plot(times,p3_erp_bin8,'-.','LineWidth',2)
xlabel('time')
ylabel('uV at Pz')
legend('1','2','3','4','5','6','7','8')

%% plot erp with and without bin 8
p3_erp_walk_n8 = mean([p3_erp_bin1;p3_erp_bin2;p3_erp_bin3;p3_erp_bin4;p3_erp_bin5;p3_erp_bin6;p3_erp_bin7;p3_erp_bin8],1);
p3_erp_walk_corr = mean([p3_erp_bin1;p3_erp_bin2;p3_erp_bin3;p3_erp_bin4;p3_erp_bin5;p3_erp_bin6;p3_erp_bin7],1);

figure
hold on
plot(times,p3_erp_walk_n8,'-.','LineWidth',2)
plot(times,p3_erp_walk_corr,'-','LineWidth',2)
legend('all bins','bins 1-7')

%% plot without artifactual trials
figure
% hold on
% plot(times,p3_rms_erp_walk_sorted_bL(1:17,:),'-','LineWidth',1)
% plot(times,p3_rms_erp_walk_sorted_bL(19:305,:),'-','LineWidth',1)
% plot(times,p3_rms_erp_walk_sorted_bL(307:end,:),'-','LineWidth',1)
plot(times,p3_rms_erp_walk_sorted_bL,'-','LineWidth',1)

%% Bin 1 before/after
figure % without artTrial #12
hold on
for ii = 1:nbinel
    plot(times,p3_rms_erp_walk_sorted_bL_artTrialsRem(ii,:)/nbinel,'-')
end

figure % with artTrial #12
hold on
for ii = 1:nbinel
    plot(times,p3_rms_erp_walk_sorted_bL(ii,:)/(nbinel+1),'-')
end

%% Bin 8 before/after
figure % without artTrial #201
hold on
for ii = 7*nbinel+1:nbinel*8
    plot(p3_rms_erp_walk_sorted_bL_artTrialsRem(ii,:)/nbinel,'-')
end

figure % with artTrial #201
hold on
for ii = 7*nbinel+1:nbinel*8
    plot(p3_rms_erp_walk_sorted_bL(ii,:)/(nbinel+4),'-')
end

%% bin 1 before/after ERP grand avg
figure % grand averages before/after
hold on
plot(times,mean(p3_rms_erp_walk_sorted_bL_artTrialsRem(1:nbinel,:))/nbinel,'k-')
plot(times,mean(p3_rms_erp_walk_sorted_bL(1:nbinel+1,:))/(nbinel+1),'k-.')

%% bin 8 before/after ERP grand avg
figure % grand averages before/after
hold on
plot(times,mean(p3_rms_erp_walk_sorted_bL_artTrialsRem(7*nbinel+1:nbinel*8,:))/nbinel,'k-')
plot(times,mean(p3_rms_erp_walk_sorted_bL(7*nbinel+1:nbinel*8,:))/(nbinel+4),'k-.')

%% plot with and without baseline correction
% figure
% hold on
% plot(times,mean([p3_rms_erp_walk_sorted(1:11,:); p3_rms_erp_walk_sorted(13:200,:); p3_rms_erp_walk_sorted(202:end,:)],1),'-','LineWidth',2)
% plot(times,mean([p3_rms_erp_walk_sorted_bL(1:11,:); p3_rms_erp_walk_sorted_bL(13:200,:); p3_rms_erp_walk_sorted_bL(202:end,:)],1),'-','LineWidth',2)

%% plot all erp

figure % grand averages before/after
hold on
plot(times,mean(p3_rms_erp_sit_sorted_bL),'-','LineWidth',1)
plot(times,mean(p3_rms_erp_stand_sorted_bL),'-','LineWidth',1)
plot(times,mean(p3_rms_erp_walk_sorted_bL),'k-','LineWidth',1)
legend('Sit','Stand','Walk')

%% update table to include actual data
% erp_data = [];
% for ii = 1:size(p3_rms_erp_sit,1)
%         erp_data{ii,1} = p3_rms_erp_sit(ii,:);
% end
% for ii = 1:size(p3_rms_erp_stand,1)
%     erp_data{ii+size(p3_rms_erp_sit,1),1} = p3_rms_erp_stand(ii,:);
% end
% for ii = 1:size(p3_rms_erp_walk,1)
%         erp_data{ii+size(p3_rms_erp_sit,1)+size(p3_rms_erp_stand,1),1} = p3_rms_erp_walk(ii,:);
% end
% 
% tbl = table(subjects,conditions,sessions,motions,p3_mean,p3_median,'VariableNames',{'Subject','Condition','Session','Motion_RMS_Magnitude','P3_Mean','P3_Median'});
% lme1 = fitlme(tbl,'P3_Mean ~ Condition + (1|Subject)')

%% plot mimicking old plots; divide subject data according to # trials in that set
erp_mim = [];
ii = 1;
while ii <= numel(subs)
    ii = 1;
    temp3 = tbl{1:11,7}; erp_mim{1,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{12:26,7}; erp_mim{2,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{27:37,7}; erp_mim{3,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{38:51,7}; erp_mim{4,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{52:58,7}; erp_mim{5,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{59:74,7}; erp_mim{6,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{75:86,7}; erp_mim{7,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{87:103,7}; erp_mim{8,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{104:111,7}; erp_mim{9,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    ii = 2;
    temp3 = tbl{112:125,7}; erp_mim{1,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{126:139,7}; erp_mim{2,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{140:148,7}; erp_mim{3,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{149:158,7}; erp_mim{4,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{159:172,7}; erp_mim{5,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{173:185,7}; erp_mim{6,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{186:201,7}; erp_mim{7,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{202:212,7}; erp_mim{8,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{213:222,7}; erp_mim{9,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    ii = 3;
    temp3 = tbl{223:235,7}; erp_mim{1,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{236:246,7}; erp_mim{2,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{247:259,7}; erp_mim{3,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{260:274,7}; erp_mim{4,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{275:284,7}; erp_mim{5,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{285:296,7}; erp_mim{6,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{297:307,7}; erp_mim{7,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{308:321,7}; erp_mim{8,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{322:333,7}; erp_mim{9,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    ii = 4;
    temp3 = tbl{334:342,7}; erp_mim{1,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{343:359,7}; erp_mim{2,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{360:370,7}; erp_mim{3,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{371:381,7}; erp_mim{4,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{382:395,7}; erp_mim{5,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{396:407,7}; erp_mim{6,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{408:418,7}; erp_mim{7,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{419:431,7}; erp_mim{8,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{432:444,7}; erp_mim{9,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    ii = 5;
    temp3 = tbl{445:457,7}; erp_mim{1,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{458:469,7}; erp_mim{2,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{470:481,7}; erp_mim{3,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{482:495,7}; erp_mim{4,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{496:509,7}; erp_mim{5,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{510:518,7}; erp_mim{6,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{519:537,7}; erp_mim{7,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{538:544,7}; erp_mim{8,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{545:555,7}; erp_mim{9,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    ii = 6;
    temp3 = tbl{556:570,7}; erp_mim{1,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{571:579,7}; erp_mim{2,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{580:592,7}; erp_mim{3,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{593:606,7}; erp_mim{4,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{607:617,7}; erp_mim{5,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{618:629,7}; erp_mim{6,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{630:651,7}; erp_mim{7,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{652:656,7}; erp_mim{8,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{657:666,7}; erp_mim{9,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    ii = 7;
    temp3 = tbl{667:678,7}; erp_mim{1,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{679:694,7}; erp_mim{2,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{695:703,7}; erp_mim{3,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{704:713,7}; erp_mim{4,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{714:727,7}; erp_mim{5,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{728:740,7}; erp_mim{6,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{741:744,7}; erp_mim{7,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{745:754,7}; erp_mim{8,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{755:777,7}; erp_mim{9,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    ii = 8;
    temp3 = tbl{778:789,7}; erp_mim{1,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{790:802,7}; erp_mim{2,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{803:814,7}; erp_mim{3,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{815:825,7}; erp_mim{4,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{826:836,7}; erp_mim{5,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{837:851,7}; erp_mim{6,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{852:860,7}; erp_mim{7,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{861:872,7}; erp_mim{8,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{873:888,7}; erp_mim{9,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    ii = 9;
    temp3 = tbl{889:901,7}; erp_mim{1,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{902:912,7}; erp_mim{2,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{913:925,7}; erp_mim{3,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{926:940,7}; erp_mim{4,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{941:953,7}; erp_mim{5,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{954:962,7}; erp_mim{6,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{963:978,7}; erp_mim{7,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{979:984,7}; erp_mim{8,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    temp3 = tbl{985:999,7}; erp_mim{9,ii} = mean(reshape([temp3{:}],300,length(temp3)),2)*length(temp3);
    ii = 10;
end

tempsitA = erp_mim(1,:); erp_mim_sitA = [tempsitA{:}];
tempsitB = erp_mim(2,:); erp_mim_sitB = [tempsitB{:}];
tempsitC = erp_mim(3,:); erp_mim_sitC = [tempsitC{:}];
erp_mim_sit = (erp_mim_sitA + erp_mim_sitB + erp_mim_sitC)/9;

tempstandA = erp_mim(4,:); erp_mim_standA = [tempstandA{:}]/37;
tempstandB = erp_mim(5,:); erp_mim_standB = [tempstandB{:}]/37;
tempstandC = erp_mim(6,:); erp_mim_standC = [tempstandC{:}]/37;
erp_mim_stand = (erp_mim_standA + erp_mim_standB + erp_mim_standC)/9;

tempwalkA = erp_mim(7,:); erp_mim_walkA = [tempwalkA{:}]/37;
tempwalkB = erp_mim(8,:); erp_mim_walkB = [tempwalkB{:}]/37;
tempwalkC = erp_mim(9,:); erp_mim_walkC = [tempwalkC{:}]/37;
erp_mim_walk = (erp_mim_walkA + erp_mim_walkB + erp_mim_walkC)/9;

% S00X_sit_avg_eq_A = mean(reshape([erp_mim_sitA{:}],300,numel(subs)),2)/numel(subs)
% mean(reshape([erp_mim{1:3,:}],300)
% 

figure % grand averages before/after
hold on
plot(times,mean(erp_mim_sit,2),'-','LineWidth',1)
plot(times,mean(erp_mim_stand,2),'-','LineWidth',1)
plot(times,mean(erp_mim_walk,2),'-','LineWidth',1)
legend('Sit','Stand','Walk')


%% export to csv
% cd('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2_Accel\10_22_21\csv')
% writematrix(p3_rms_erp_sit,'sit.csv')
% writematrix(p3_rms_erp_stand,'stand.csv')
% writematrix(p3_rms_erp_walk,'walk.csv')
% writetable(tbl,'parameters.csv')

% %% create subject averages
% erp_mim = [];
% ii = 1;
% while ii <= numel(subs)
%     ii = 1;
%     temp3 = tbl{1:11,7}; erp_mim{1,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(1,ii) = length(temp3);
%     temp3 = tbl{12:26,7}; erp_mim{2,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(2,ii) = length(temp3);
%     temp3 = tbl{27:37,7}; erp_mim{3,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(3,ii) = length(temp3);
%     temp3 = tbl{38:51,7}; erp_mim{4,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(4,ii) = length(temp3);
%     temp3 = tbl{52:58,7}; erp_mim{5,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(5,ii) = length(temp3);
%     temp3 = tbl{59:74,7}; erp_mim{6,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(6,ii) = length(temp3);
%     temp3 = tbl{75:86,7}; erp_mim{7,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(7,ii) = length(temp3);
%     temp3 = tbl{87:103,7}; erp_mim{8,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(8,ii) = length(temp3);
%     temp3 = tbl{104:111,7}; erp_mim{9,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(9,ii) = length(temp3);
%     ii = 2;
%     temp3 = tbl{112:125,7}; erp_mim{1,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(1,ii) = length(temp3);
%     temp3 = tbl{126:139,7}; erp_mim{2,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(2,ii) = length(temp3);
%     temp3 = tbl{140:148,7}; erp_mim{3,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(3,ii) = length(temp3);
%     temp3 = tbl{149:158,7}; erp_mim{4,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(4,ii) = length(temp3);
%     temp3 = tbl{159:172,7}; erp_mim{5,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(5,ii) = length(temp3);
%     temp3 = tbl{173:185,7}; erp_mim{6,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(6,ii) = length(temp3);
%     temp3 = tbl{186:201,7}; erp_mim{7,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(7,ii) = length(temp3);
%     temp3 = tbl{202:212,7}; erp_mim{8,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(8,ii) = length(temp3);
%     temp3 = tbl{213:222,7}; erp_mim{9,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(9,ii) = length(temp3);
%     ii = 3;
%     temp3 = tbl{223:235,7}; erp_mim{1,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(1,ii) = length(temp3);
%     temp3 = tbl{236:246,7}; erp_mim{2,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(2,ii) = length(temp3);
%     temp3 = tbl{247:259,7}; erp_mim{3,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(3,ii) = length(temp3);
%     temp3 = tbl{260:274,7}; erp_mim{4,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(4,ii) = length(temp3);
%     temp3 = tbl{275:284,7}; erp_mim{5,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(5,ii) = length(temp3);
%     temp3 = tbl{285:296,7}; erp_mim{6,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(6,ii) = length(temp3);
%     temp3 = tbl{297:307,7}; erp_mim{7,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(7,ii) = length(temp3);
%     temp3 = tbl{308:321,7}; erp_mim{8,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(8,ii) = length(temp3);
%     temp3 = tbl{322:333,7}; erp_mim{9,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(9,ii) = length(temp3);
%     ii = 4;
%     temp3 = tbl{334:342,7}; erp_mim{1,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(1,ii) = length(temp3);
%     temp3 = tbl{343:359,7}; erp_mim{2,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(2,ii) = length(temp3);
%     temp3 = tbl{360:370,7}; erp_mim{3,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(3,ii) = length(temp3);
%     temp3 = tbl{371:381,7}; erp_mim{4,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(4,ii) = length(temp3);
%     temp3 = tbl{382:395,7}; erp_mim{5,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(5,ii) = length(temp3);
%     temp3 = tbl{396:407,7}; erp_mim{6,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(6,ii) = length(temp3);
%     temp3 = tbl{408:418,7}; erp_mim{7,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(7,ii) = length(temp3);
%     temp3 = tbl{419:431,7}; erp_mim{8,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(8,ii) = length(temp3);
%     temp3 = tbl{432:444,7}; erp_mim{9,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(9,ii) = length(temp3);
%     ii = 5;
%     temp3 = tbl{445:457,7}; erp_mim{1,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(1,ii) = length(temp3);
%     temp3 = tbl{458:469,7}; erp_mim{2,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(2,ii) = length(temp3);
%     temp3 = tbl{470:481,7}; erp_mim{3,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(3,ii) = length(temp3);
%     temp3 = tbl{482:495,7}; erp_mim{4,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(4,ii) = length(temp3);
%     temp3 = tbl{496:509,7}; erp_mim{5,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(5,ii) = length(temp3);
%     temp3 = tbl{510:518,7}; erp_mim{6,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(6,ii) = length(temp3);
%     temp3 = tbl{519:537,7}; erp_mim{7,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(7,ii) = length(temp3);
%     temp3 = tbl{538:544,7}; erp_mim{8,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(8,ii) = length(temp3);
%     temp3 = tbl{545:555,7}; erp_mim{9,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(9,ii) = length(temp3);
%     ii = 6;
%     temp3 = tbl{556:570,7}; erp_mim{1,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(1,ii) = length(temp3);
%     temp3 = tbl{571:579,7}; erp_mim{2,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(2,ii) = length(temp3);
%     temp3 = tbl{580:592,7}; erp_mim{3,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(3,ii) = length(temp3);
%     temp3 = tbl{593:606,7}; erp_mim{4,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(4,ii) = length(temp3);
%     temp3 = tbl{607:617,7}; erp_mim{5,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(5,ii) = length(temp3);
%     temp3 = tbl{618:629,7}; erp_mim{6,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(6,ii) = length(temp3);
%     temp3 = tbl{630:651,7}; erp_mim{7,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(7,ii) = length(temp3);
%     temp3 = tbl{652:656,7}; erp_mim{8,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(8,ii) = length(temp3);
%     temp3 = tbl{657:666,7}; erp_mim{9,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(9,ii) = length(temp3);
%     ii = 7;
%     temp3 = tbl{667:678,7}; erp_mim{1,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(1,ii) = length(temp3);
%     temp3 = tbl{679:694,7}; erp_mim{2,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(2,ii) = length(temp3);
%     temp3 = tbl{695:703,7}; erp_mim{3,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(3,ii) = length(temp3);
%     temp3 = tbl{704:713,7}; erp_mim{4,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(4,ii) = length(temp3);
%     temp3 = tbl{714:727,7}; erp_mim{5,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(5,ii) = length(temp3);
%     temp3 = tbl{728:740,7}; erp_mim{6,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(6,ii) = length(temp3);
%     temp3 = tbl{741:744,7}; erp_mim{7,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(7,ii) = length(temp3);
%     temp3 = tbl{745:754,7}; erp_mim{8,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(8,ii) = length(temp3);
%     temp3 = tbl{755:777,7}; erp_mim{9,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(9,ii) = length(temp3);
%     ii = 8;
%     temp3 = tbl{778:789,7}; erp_mim{1,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(1,ii) = length(temp3);
%     temp3 = tbl{790:802,7}; erp_mim{2,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(2,ii) = length(temp3);
%     temp3 = tbl{803:814,7}; erp_mim{3,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(3,ii) = length(temp3);
%     temp3 = tbl{815:825,7}; erp_mim{4,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(4,ii) = length(temp3);
%     temp3 = tbl{826:836,7}; erp_mim{5,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(5,ii) = length(temp3);
%     temp3 = tbl{837:851,7}; erp_mim{6,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(6,ii) = length(temp3);
%     temp3 = tbl{852:860,7}; erp_mim{7,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(7,ii) = length(temp3);
%     temp3 = tbl{861:872,7}; erp_mim{8,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(8,ii) = length(temp3);
%     temp3 = tbl{873:888,7}; erp_mim{9,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(9,ii) = length(temp3);
%     ii = 9;
%     temp3 = tbl{889:901,7}; erp_mim{1,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(1,ii) = length(temp3);
%     temp3 = tbl{902:912,7}; erp_mim{2,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(2,ii) = length(temp3);
%     temp3 = tbl{913:925,7}; erp_mim{3,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(3,ii) = length(temp3);
%     temp3 = tbl{926:940,7}; erp_mim{4,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(4,ii) = length(temp3);
%     temp3 = tbl{941:953,7}; erp_mim{5,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(5,ii) = length(temp3);
%     temp3 = tbl{954:962,7}; erp_mim{6,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(6,ii) = length(temp3);
%     temp3 = tbl{963:978,7}; erp_mim{7,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(7,ii) = length(temp3);
%     temp3 = tbl{979:984,7}; erp_mim{8,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(8,ii) = length(temp3);
%     temp3 = tbl{985:999,7}; erp_mim{9,ii} = mean(reshape([temp3{:}],300,length(temp3)),2); erp_mim_ntrials(9,ii) = length(temp3);
%     ii = 10;
% end
% 
% subjects2 = []; erp_mim_all = []; erp_mim_ntrials_all = []; conditions2 = []; sessions2 = [];
% p3_mean_all = []; p3_median_all = [];
% erp_mim_ntrials_all = reshape([erp_mim_ntrials(:)],length(erp_mim_ntrials)*length(erp_mim_ntrials),1);
% 
% % for ii = 1:erp_mim_ntrials_all
% %     jj = erp_mim_ntrials_all(ii);
% %     erp_mim_new{ii} = tbl.ERP_data( 
% %     for kk = 2:jj
% %         erp_mim_new{ii} = [erp_mim_new; tbl.ERP_data{kk,1}]
% %     end
% % end
% % 
% % erp_mim_all = reshape([erp_mim(:)],length(erp_mim)*length(erp_mim),1);
% % for ii = 1:length(erp_mim_all)
% % p3_mean_all(ii,1) = mean(erp_mim_all{ii}(136:166),1);
% % p3_median_all(ii,1) = median(erp_mim_all{ii}(136:166),1);
% % end
% 
% ii = 1;
% while ii <= numel(subs)
%     ii = 1;
%     temp3 = tbl{1:11,5}; erp_mim{1,ii} = mean(temp3); erp_mim_ntrials(1,ii) = length(temp3);
%     temp3 = tbl{12:26,5}; erp_mim{2,ii} = mean(temp3); erp_mim_ntrials(2,ii) = length(temp3);
%     temp3 = tbl{27:37,5}; erp_mim{3,ii} = mean(temp3); erp_mim_ntrials(3,ii) = length(temp3);
%     temp3 = tbl{38:51,5}; erp_mim{4,ii} = mean(temp3); erp_mim_ntrials(4,ii) = length(temp3);
%     temp3 = tbl{52:58,5}; erp_mim{5,ii} = mean(temp3); erp_mim_ntrials(5,ii) = length(temp3);
%     temp3 = tbl{59:74,5}; erp_mim{6,ii} = mean(temp3); erp_mim_ntrials(6,ii) = length(temp3);
%     temp3 = tbl{75:86,5}; erp_mim{7,ii} = mean(temp3); erp_mim_ntrials(7,ii) = length(temp3);
%     temp3 = tbl{87:103,5}; erp_mim{8,ii} = mean(temp3); erp_mim_ntrials(8,ii) = length(temp3);
%     temp3 = tbl{104:111,5}; erp_mim{9,ii} = mean(temp3); erp_mim_ntrials(9,ii) = length(temp3);
%     ii = 2;
%     temp3 = tbl{112:125,5}; erp_mim{1,ii} = mean(temp3); erp_mim_ntrials(1,ii) = length(temp3);
%     temp3 = tbl{126:139,5}; erp_mim{2,ii} = mean(temp3); erp_mim_ntrials(2,ii) = length(temp3);
%     temp3 = tbl{140:148,5}; erp_mim{3,ii} = mean(temp3); erp_mim_ntrials(3,ii) = length(temp3);
%     temp3 = tbl{149:158,5}; erp_mim{4,ii} = mean(temp3); erp_mim_ntrials(4,ii) = length(temp3);
%     temp3 = tbl{159:172,5}; erp_mim{5,ii} = mean(temp3); erp_mim_ntrials(5,ii) = length(temp3);
%     temp3 = tbl{173:185,5}; erp_mim{6,ii} = mean(temp3); erp_mim_ntrials(6,ii) = length(temp3);
%     temp3 = tbl{186:201,5}; erp_mim{7,ii} = mean(temp3); erp_mim_ntrials(7,ii) = length(temp3);
%     temp3 = tbl{202:212,5}; erp_mim{8,ii} = mean(temp3); erp_mim_ntrials(8,ii) = length(temp3);
%     temp3 = tbl{213:222,5}; erp_mim{9,ii} = mean(temp3); erp_mim_ntrials(9,ii) = length(temp3);
%     ii = 3;
%     temp3 = tbl{223:235,5}; erp_mim{1,ii} = mean(temp3); erp_mim_ntrials(1,ii) = length(temp3);
%     temp3 = tbl{236:246,5}; erp_mim{2,ii} = mean(temp3); erp_mim_ntrials(2,ii) = length(temp3);
%     temp3 = tbl{247:259,5}; erp_mim{3,ii} = mean(temp3); erp_mim_ntrials(3,ii) = length(temp3);
%     temp3 = tbl{260:274,5}; erp_mim{4,ii} = mean(temp3); erp_mim_ntrials(4,ii) = length(temp3);
%     temp3 = tbl{275:284,5}; erp_mim{5,ii} = mean(temp3); erp_mim_ntrials(5,ii) = length(temp3);
%     temp3 = tbl{285:296,5}; erp_mim{6,ii} = mean(temp3); erp_mim_ntrials(6,ii) = length(temp3);
%     temp3 = tbl{297:307,5}; erp_mim{7,ii} = mean(temp3); erp_mim_ntrials(7,ii) = length(temp3);
%     temp3 = tbl{308:321,5}; erp_mim{8,ii} = mean(temp3); erp_mim_ntrials(8,ii) = length(temp3);
%     temp3 = tbl{322:333,5}; erp_mim{9,ii} = mean(temp3); erp_mim_ntrials(9,ii) = length(temp3);
%     ii = 4;
%     temp3 = tbl{334:342,5}; erp_mim{1,ii} = mean(temp3); erp_mim_ntrials(1,ii) = length(temp3);
%     temp3 = tbl{343:359,5}; erp_mim{2,ii} = mean(temp3); erp_mim_ntrials(2,ii) = length(temp3);
%     temp3 = tbl{360:370,5}; erp_mim{3,ii} = mean(temp3); erp_mim_ntrials(3,ii) = length(temp3);
%     temp3 = tbl{371:381,5}; erp_mim{4,ii} = mean(temp3); erp_mim_ntrials(4,ii) = length(temp3);
%     temp3 = tbl{382:395,5}; erp_mim{5,ii} = mean(temp3); erp_mim_ntrials(5,ii) = length(temp3);
%     temp3 = tbl{396:407,5}; erp_mim{6,ii} = mean(temp3); erp_mim_ntrials(6,ii) = length(temp3);
%     temp3 = tbl{408:418,5}; erp_mim{7,ii} = mean(temp3); erp_mim_ntrials(7,ii) = length(temp3);
%     temp3 = tbl{419:431,5}; erp_mim{8,ii} = mean(temp3); erp_mim_ntrials(8,ii) = length(temp3);
%     temp3 = tbl{432:444,5}; erp_mim{9,ii} = mean(temp3); erp_mim_ntrials(9,ii) = length(temp3);
%     ii = 5;
%     temp3 = tbl{445:457,5}; erp_mim{1,ii} = mean(temp3); erp_mim_ntrials(1,ii) = length(temp3);
%     temp3 = tbl{458:469,5}; erp_mim{2,ii} = mean(temp3); erp_mim_ntrials(2,ii) = length(temp3);
%     temp3 = tbl{470:481,5}; erp_mim{3,ii} = mean(temp3); erp_mim_ntrials(3,ii) = length(temp3);
%     temp3 = tbl{482:495,5}; erp_mim{4,ii} = mean(temp3); erp_mim_ntrials(4,ii) = length(temp3);
%     temp3 = tbl{496:509,5}; erp_mim{5,ii} = mean(temp3); erp_mim_ntrials(5,ii) = length(temp3);
%     temp3 = tbl{510:518,5}; erp_mim{6,ii} = mean(temp3); erp_mim_ntrials(6,ii) = length(temp3);
%     temp3 = tbl{519:537,5}; erp_mim{7,ii} = mean(temp3); erp_mim_ntrials(7,ii) = length(temp3);
%     temp3 = tbl{538:544,5}; erp_mim{8,ii} = mean(temp3); erp_mim_ntrials(8,ii) = length(temp3);
%     temp3 = tbl{545:555,5}; erp_mim{9,ii} = mean(temp3); erp_mim_ntrials(9,ii) = length(temp3);
%     ii = 6;
%     temp3 = tbl{556:570,5}; erp_mim{1,ii} = mean(temp3); erp_mim_ntrials(1,ii) = length(temp3);
%     temp3 = tbl{571:579,5}; erp_mim{2,ii} = mean(temp3); erp_mim_ntrials(2,ii) = length(temp3);
%     temp3 = tbl{580:592,5}; erp_mim{3,ii} = mean(temp3); erp_mim_ntrials(3,ii) = length(temp3);
%     temp3 = tbl{593:606,5}; erp_mim{4,ii} = mean(temp3); erp_mim_ntrials(4,ii) = length(temp3);
%     temp3 = tbl{607:617,5}; erp_mim{5,ii} = mean(temp3); erp_mim_ntrials(5,ii) = length(temp3);
%     temp3 = tbl{618:629,5}; erp_mim{6,ii} = mean(temp3); erp_mim_ntrials(6,ii) = length(temp3);
%     temp3 = tbl{630:651,5}; erp_mim{7,ii} = mean(temp3); erp_mim_ntrials(7,ii) = length(temp3);
%     temp3 = tbl{652:656,5}; erp_mim{8,ii} = mean(temp3); erp_mim_ntrials(8,ii) = length(temp3);
%     temp3 = tbl{657:666,5}; erp_mim{9,ii} = mean(temp3); erp_mim_ntrials(9,ii) = length(temp3);
%     ii = 7;
%     temp3 = tbl{667:678,5}; erp_mim{1,ii} = mean(temp3); erp_mim_ntrials(1,ii) = length(temp3);
%     temp3 = tbl{679:694,5}; erp_mim{2,ii} = mean(temp3); erp_mim_ntrials(2,ii) = length(temp3);
%     temp3 = tbl{695:703,5}; erp_mim{3,ii} = mean(temp3); erp_mim_ntrials(3,ii) = length(temp3);
%     temp3 = tbl{704:713,5}; erp_mim{4,ii} = mean(temp3); erp_mim_ntrials(4,ii) = length(temp3);
%     temp3 = tbl{714:727,5}; erp_mim{5,ii} = mean(temp3); erp_mim_ntrials(5,ii) = length(temp3);
%     temp3 = tbl{728:740,5}; erp_mim{6,ii} = mean(temp3); erp_mim_ntrials(6,ii) = length(temp3);
%     temp3 = tbl{741:744,5}; erp_mim{7,ii} = mean(temp3); erp_mim_ntrials(7,ii) = length(temp3);
%     temp3 = tbl{745:754,5}; erp_mim{8,ii} = mean(temp3); erp_mim_ntrials(8,ii) = length(temp3);
%     temp3 = tbl{755:777,5}; erp_mim{9,ii} = mean(temp3); erp_mim_ntrials(9,ii) = length(temp3);
%     ii = 8;
%     temp3 = tbl{778:789,5}; erp_mim{1,ii} = mean(temp3); erp_mim_ntrials(1,ii) = length(temp3);
%     temp3 = tbl{790:802,5}; erp_mim{2,ii} = mean(temp3); erp_mim_ntrials(2,ii) = length(temp3);
%     temp3 = tbl{803:814,5}; erp_mim{3,ii} = mean(temp3); erp_mim_ntrials(3,ii) = length(temp3);
%     temp3 = tbl{815:825,5}; erp_mim{4,ii} = mean(temp3); erp_mim_ntrials(4,ii) = length(temp3);
%     temp3 = tbl{826:836,5}; erp_mim{5,ii} = mean(temp3); erp_mim_ntrials(5,ii) = length(temp3);
%     temp3 = tbl{837:851,5}; erp_mim{6,ii} = mean(temp3); erp_mim_ntrials(6,ii) = length(temp3);
%     temp3 = tbl{852:860,5}; erp_mim{7,ii} = mean(temp3); erp_mim_ntrials(7,ii) = length(temp3);
%     temp3 = tbl{861:872,5}; erp_mim{8,ii} = mean(temp3); erp_mim_ntrials(8,ii) = length(temp3);
%     temp3 = tbl{873:888,5}; erp_mim{9,ii} = mean(temp3); erp_mim_ntrials(9,ii) = length(temp3);
%     ii = 9;
%     temp3 = tbl{889:901,5}; erp_mim{1,ii} = mean(temp3); erp_mim_ntrials(1,ii) = length(temp3);
%     temp3 = tbl{902:912,5}; erp_mim{2,ii} = mean(temp3); erp_mim_ntrials(2,ii) = length(temp3);
%     temp3 = tbl{913:925,5}; erp_mim{3,ii} = mean(temp3); erp_mim_ntrials(3,ii) = length(temp3);
%     temp3 = tbl{926:940,5}; erp_mim{4,ii} = mean(temp3); erp_mim_ntrials(4,ii) = length(temp3);
%     temp3 = tbl{941:953,5}; erp_mim{5,ii} = mean(temp3); erp_mim_ntrials(5,ii) = length(temp3);
%     temp3 = tbl{954:962,5}; erp_mim{6,ii} = mean(temp3); erp_mim_ntrials(6,ii) = length(temp3);
%     temp3 = tbl{963:978,5}; erp_mim{7,ii} = mean(temp3); erp_mim_ntrials(7,ii) = length(temp3);
%     temp3 = tbl{979:984,5}; erp_mim{8,ii} = mean(temp3); erp_mim_ntrials(8,ii) = length(temp3);
%     temp3 = tbl{985:999,5}; erp_mim{9,ii} = mean(temp3); erp_mim_ntrials(9,ii) = length(temp3);
%     ii = 10;
% end
% p3_mean_all = double(cell2mat([erp_mim(:)]));
% subjects2 = categorical([ones(9,1); 2*ones(9,1); 3*ones(9,1); 4*ones(9,1); 5*ones(9,1); 6*ones(9,1); 7*ones(9,1); 8*ones(9,1); 9*ones(9,1)]);
% conditions2 = categorical([repmat({'sit','sit','sit','stand','stand','stand','walk','walk','walk'},1,9)]');
% sessions2 = categorical([repmat({'A','B','C'},1,27)]');
% tbl2 = table(subjects2,conditions2,sessions2,erp_mim_ntrials_all,p3_mean_all,p3_median_all,'VariableNames',{'Subject','Condition','Session','nTrials','P3_Mean','P3_Median'});
% lme2 = fitlme(tbl2,'P3_Mean ~ Condition + (1|Subject)')
% 
% %%
% sit_abc = [mean(cat(2,erp_mim_all{1:9:81,:}),2), mean(cat(2,erp_mim_all{2:9:81,:}),2), mean(cat(2,erp_mim_all{3:9:81,:}),2)]
% 
% figure
% hold on
% % plot(times,mean(cat(2,erp_mim_all{1:3,:}),2),'-')
% % plot(times,mean(cat(2,erp_mim_all{10:12,:}),2),'-')
% % plot(times,mean(cat(2,erp_mim_all{19:21,:}),2),'-')
% % plot(times,mean(cat(2,erp_mim_all{28:30,:}),2),'-')
% % plot(times,mean(cat(2,erp_mim_all{37:39,:}),2),'-')
% % plot(times,mean(cat(2,erp_mim_all{46:48,:}),2),'-')
% % plot(times,mean(cat(2,erp_mim_all{55:57,:}),2),'-')
% % plot(times,mean(cat(2,erp_mim_all{64:66,:}),2),'-')
% % plot(times,mean(cat(2,erp_mim_all{73:75,:}),2),'-')
% plot(times,mean(cat(2,erp_mim_all{1:9:81,:}),2),'-')
% plot(times,mean(cat(2,erp_mim_all{2:9:81,:}),2),'-')
% plot(times,mean(cat(2,erp_mim_all{3:9:81,:}),2),'-')
% plot(times,mean(sit_abc,2),'k-')
%%








%% sit
% create 8 bins and plot uV vs motion
div = 8;
nbinel = round(numel(p3_rms_allsubs_sit_sorted(:,1))/div)-1;
p3_rms_bin1 = mean(p3_rms_allsubs_sit_sorted(1:nbinel,:))/(nbinel-1);
p3_rms_bin2 = mean(p3_rms_allsubs_sit_sorted(nbinel+1:nbinel*2,:))/nbinel;
p3_rms_bin3 = mean(p3_rms_allsubs_sit_sorted(2*nbinel+1:nbinel*3,:))/nbinel;
p3_rms_bin4 = mean(p3_rms_allsubs_sit_sorted(3*nbinel+1:nbinel*4,:))/nbinel;
p3_rms_bin5 = mean(p3_rms_allsubs_sit_sorted(4*nbinel+1:nbinel*5,:))/nbinel;
p3_rms_bin6 = mean(p3_rms_allsubs_sit_sorted(5*nbinel+1:nbinel*6,:))/nbinel;
p3_rms_bin7 = mean(p3_rms_allsubs_sit_sorted(6*nbinel+1:nbinel*7,:))/nbinel;
if div == 8
    p3_rms_bin8 = mean(p3_rms_allsubs_sit_sorted(7*nbinel+1:nbinel*8,:))/(nbinel-1);
end

figure
hold on
plot(1,p3_rms_bin1(1,3),'.','MarkerSize',20)
plot(2,p3_rms_bin2(1,3),'.','MarkerSize',20)
plot(3,p3_rms_bin3(1,3),'.','MarkerSize',20)
plot(4,p3_rms_bin4(1,3),'.','MarkerSize',20)
plot(5,p3_rms_bin5(1,3),'.','MarkerSize',20)
plot(6,p3_rms_bin6(1,3),'.','MarkerSize',20)
plot(7,p3_rms_bin7(1,3),'.','MarkerSize',20)
if div == 8
plot(8,p3_rms_bin8(1,3),'.','MarkerSize',20)
end
xlabel('Motion level')
ylabel('uV at Pz')
legend('1 - Least Motion','2','3','4','5','6','7','8 - Most Motion')
set(gca,'FontSize',14)

[p3_rms_bin1(1,3) p3_rms_bin2(1,3) p3_rms_bin3(1,3) p3_rms_bin4(1,3) p3_rms_bin5(1,3) p3_rms_bin6(1,3) p3_rms_bin7(1,3) p3_rms_bin8(1,3)]

% plot erp including all bins 
nbinel = round(numel(p3_rms_erp_sit_sorted_bL(:,1))/div)-1;
p3_erp_bin1 = mean(p3_rms_erp_sit_sorted_bL(1:nbinel,:))/(nbinel-1);
p3_erp_bin2 = mean(p3_rms_erp_sit_sorted_bL(nbinel+1:nbinel*2,:))/nbinel;
p3_erp_bin3 = mean(p3_rms_erp_sit_sorted_bL(2*nbinel+1:nbinel*3,:))/nbinel;
p3_erp_bin4 = mean(p3_rms_erp_sit_sorted_bL(3*nbinel+1:nbinel*4,:))/nbinel;
p3_erp_bin5 = mean(p3_rms_erp_sit_sorted_bL(4*nbinel+1:nbinel*5,:))/nbinel;
p3_erp_bin6 = mean(p3_rms_erp_sit_sorted_bL(5*nbinel+1:nbinel*6,:))/nbinel;
p3_erp_bin7 = mean(p3_rms_erp_sit_sorted_bL(6*nbinel+1:nbinel*7,:))/nbinel;
if div == 8
p3_erp_bin8 = mean(p3_rms_erp_sit_sorted_bL(7*nbinel+1:nbinel*8,:))/(nbinel-1);
end

% grand average erp
times = -200:3.33:796;
figure
hold on
plot(times,p3_erp_bin1,'-','LineWidth',2)
plot(times,p3_erp_bin2,'-','LineWidth',2)
plot(times,p3_erp_bin3,'-','LineWidth',2)
plot(times,p3_erp_bin4,'-','LineWidth',2)
plot(times,p3_erp_bin5,'-','LineWidth',2)
plot(times,p3_erp_bin6,'-','LineWidth',2)
plot(times,p3_erp_bin7,'-','LineWidth',2)
plot(times,p3_erp_bin8,'-.','LineWidth',2)
xlabel('time')
ylabel('uV at Pz')
legend('1','2','3','4','5','6','7','8')
set(gca,'FontSize',14)

%% stand
% create 8 bins and plot uV vs motion
div = 8;
nbinel = round(numel(p3_rms_allsubs_stand_sorted(:,1))/div)-1;
p3_rms_bin1 = mean(p3_rms_allsubs_stand_sorted(1:nbinel,:))/(nbinel-1);
p3_rms_bin2 = mean(p3_rms_allsubs_stand_sorted(nbinel+1:nbinel*2,:))/nbinel;
p3_rms_bin3 = mean(p3_rms_allsubs_stand_sorted(2*nbinel+1:nbinel*3,:))/nbinel;
p3_rms_bin4 = mean(p3_rms_allsubs_stand_sorted(3*nbinel+1:nbinel*4,:))/nbinel;
p3_rms_bin5 = mean(p3_rms_allsubs_stand_sorted(4*nbinel+1:nbinel*5,:))/nbinel;
p3_rms_bin6 = mean(p3_rms_allsubs_stand_sorted(5*nbinel+1:nbinel*6,:))/nbinel;
p3_rms_bin7 = mean(p3_rms_allsubs_stand_sorted(6*nbinel+1:nbinel*7,:))/nbinel;
if div == 8
    p3_rms_bin8 = mean(p3_rms_allsubs_stand_sorted(7*nbinel+1:nbinel*8,:))/(nbinel-1);
end

figure
hold on
plot(1,p3_rms_bin1(1,3),'.','MarkerSize',20)
plot(2,p3_rms_bin2(1,3),'.','MarkerSize',20)
plot(3,p3_rms_bin3(1,3),'.','MarkerSize',20)
plot(4,p3_rms_bin4(1,3),'.','MarkerSize',20)
plot(5,p3_rms_bin5(1,3),'.','MarkerSize',20)
plot(6,p3_rms_bin6(1,3),'.','MarkerSize',20)
plot(7,p3_rms_bin7(1,3),'.','MarkerSize',20)
if div == 8
plot(8,p3_rms_bin8(1,3),'.','MarkerSize',20)
end
xlabel('Motion level')
ylabel('uV at Pz')
legend('1 - Least Motion','2','3','4','5','6','7','8 - Most Motion')
set(gca,'FontSize',14)

[p3_rms_bin1(1,3) p3_rms_bin2(1,3) p3_rms_bin3(1,3) p3_rms_bin4(1,3) p3_rms_bin5(1,3) p3_rms_bin6(1,3) p3_rms_bin7(1,3) p3_rms_bin8(1,3)]

% plot erp including all bins 
nbinel = round(numel(p3_rms_erp_stand_sorted_bL(:,1))/div)-1;
p3_erp_bin1 = mean(p3_rms_erp_stand_sorted_bL(1:nbinel,:))/(nbinel-1);
p3_erp_bin2 = mean(p3_rms_erp_stand_sorted_bL(nbinel+1:nbinel*2,:))/nbinel;
p3_erp_bin3 = mean(p3_rms_erp_stand_sorted_bL(2*nbinel+1:nbinel*3,:))/nbinel;
p3_erp_bin4 = mean(p3_rms_erp_stand_sorted_bL(3*nbinel+1:nbinel*4,:))/nbinel;
p3_erp_bin5 = mean(p3_rms_erp_stand_sorted_bL(4*nbinel+1:nbinel*5,:))/nbinel;
p3_erp_bin6 = mean(p3_rms_erp_stand_sorted_bL(5*nbinel+1:nbinel*6,:))/nbinel;
p3_erp_bin7 = mean(p3_rms_erp_stand_sorted_bL(6*nbinel+1:nbinel*7,:))/nbinel;
if div == 8
p3_erp_bin8 = mean(p3_rms_erp_stand_sorted_bL(7*nbinel+1:nbinel*8,:))/(nbinel-1);
end

% grand average erp
times = -200:3.33:796;
figure
hold on
plot(times,p3_erp_bin1,'-','LineWidth',2)
plot(times,p3_erp_bin2,'-','LineWidth',2)
plot(times,p3_erp_bin3,'-','LineWidth',2)
plot(times,p3_erp_bin4,'-','LineWidth',2)
plot(times,p3_erp_bin5,'-','LineWidth',2)
plot(times,p3_erp_bin6,'-','LineWidth',2)
plot(times,p3_erp_bin7,'-','LineWidth',2)
plot(times,p3_erp_bin8,'-.','LineWidth',2)
xlabel('time')
ylabel('uV at Pz')
legend('1','2','3','4','5','6','7','8')
set(gca,'FontSize',14)

%% walk

% create 8 bins and plot uV vs motion
div = 8;
nbinel = round(numel(p3_rms_allsubs_walk_sorted(:,1))/div)-1;
p3_rms_bin1 = mean(p3_rms_allsubs_walk_sorted(1:nbinel,:))/(nbinel-1);
p3_rms_bin2 = mean(p3_rms_allsubs_walk_sorted(nbinel+1:nbinel*2,:))/nbinel;
p3_rms_bin3 = mean(p3_rms_allsubs_walk_sorted(2*nbinel+1:nbinel*3,:))/nbinel;
p3_rms_bin4 = mean(p3_rms_allsubs_walk_sorted(3*nbinel+1:nbinel*4,:))/nbinel;
p3_rms_bin5 = mean(p3_rms_allsubs_walk_sorted(4*nbinel+1:nbinel*5,:))/nbinel;
p3_rms_bin6 = mean(p3_rms_allsubs_walk_sorted(5*nbinel+1:nbinel*6,:))/nbinel;
p3_rms_bin7 = mean(p3_rms_allsubs_walk_sorted(6*nbinel+1:nbinel*7,:))/nbinel;
if div == 8
    p3_rms_bin8 = mean(p3_rms_allsubs_walk_sorted(7*nbinel+1:nbinel*8,:))/(nbinel-1);
end

figure
hold on
plot(1,p3_rms_bin1(1,3),'.','MarkerSize',20)
plot(2,p3_rms_bin2(1,3),'.','MarkerSize',20)
plot(3,p3_rms_bin3(1,3),'.','MarkerSize',20)
plot(4,p3_rms_bin4(1,3),'.','MarkerSize',20)
plot(5,p3_rms_bin5(1,3),'.','MarkerSize',20)
plot(6,p3_rms_bin6(1,3),'.','MarkerSize',20)
plot(7,p3_rms_bin7(1,3),'.','MarkerSize',20)
if div == 8
plot(8,p3_rms_bin8(1,3),'.','MarkerSize',20)
end
xlabel('Motion level')
ylabel('uV at Pz')
legend('1 - Least Motion','2','3','4','5','6','7','8 - Most Motion')
set(gca,'FontSize',14)

[p3_rms_bin1(1,3) p3_rms_bin2(1,3) p3_rms_bin3(1,3) p3_rms_bin4(1,3) p3_rms_bin5(1,3) p3_rms_bin6(1,3) p3_rms_bin7(1,3) p3_rms_bin8(1,3)]

% plot erp including all bins 
nbinel = round(numel(p3_rms_erp_walk_sorted_bL(:,1))/div)-1;
p3_erp_bin1 = mean(p3_rms_erp_walk_sorted_bL(1:nbinel,:))/(nbinel-1);
p3_erp_bin2 = mean(p3_rms_erp_walk_sorted_bL(nbinel+1:nbinel*2,:))/nbinel;
p3_erp_bin3 = mean(p3_rms_erp_walk_sorted_bL(2*nbinel+1:nbinel*3,:))/nbinel;
p3_erp_bin4 = mean(p3_rms_erp_walk_sorted_bL(3*nbinel+1:nbinel*4,:))/nbinel;
p3_erp_bin5 = mean(p3_rms_erp_walk_sorted_bL(4*nbinel+1:nbinel*5,:))/nbinel;
p3_erp_bin6 = mean(p3_rms_erp_walk_sorted_bL(5*nbinel+1:nbinel*6,:))/nbinel;
p3_erp_bin7 = mean(p3_rms_erp_walk_sorted_bL(6*nbinel+1:nbinel*7,:))/nbinel;
if div == 8
p3_erp_bin8 = mean(p3_rms_erp_walk_sorted_bL(7*nbinel+1:nbinel*8,:))/(nbinel-1);
end

% grand average erp
times = -200:3.33:796;
figure
hold on
plot(times,p3_erp_bin1,'-','LineWidth',2)
plot(times,p3_erp_bin2,'-','LineWidth',2)
plot(times,p3_erp_bin3,'-','LineWidth',2)
plot(times,p3_erp_bin4,'-','LineWidth',2)
plot(times,p3_erp_bin5,'-','LineWidth',2)
plot(times,p3_erp_bin6,'-','LineWidth',2)
plot(times,p3_erp_bin7,'-','LineWidth',2)
plot(times,p3_erp_bin8,'-.','LineWidth',2)
xlabel('time')
ylabel('uV at Pz')
legend('1','2','3','4','5','6','7','8')
set(gca,'FontSize',14)

%% create linear model
% motionLevel = p3_rms_allsubs_walk(:,1);
motionLevel = [1 2 3 4 5 6 7 8]';
% uVatPz = double([p3_rms_bin1(1,3), p3_rms_bin2(1,3), p3_rms_bin3(1,3), p3_rms_bin4(1,3), p3_rms_bin5(1,3), p3_rms_bin6(1,3), p3_rms_bin7(1,3), p3_rms_bin8(1,3)]);
% uVatPz = [-0.0120   -0.0851    0.0374    -.0168   .1638  .0547    0.0776    .0151]';
% uVatPz = [.0330   -0.0895    0.0588    -.0374   .1909  .0305    0.1289    -0.674]';
uVatPz_sit = [0.0977    0.2583    0.1177    0.0804    0.0700    0.1819    0.1359    0.3314]';
uVatPz_stand = [0.1347    0.1089    0.1695    0.1659    0.1763    0.2290    0.1322    0.1658]';
uVatPz_walk = [-.0024   -.0056    0.0824    .0244   .2025  .1202    0.0893    .0882]';
% uVatPz = p3_rms_allsubs_walk(:,3);
tbl_sit = table(motionLevel,uVatPz_sit)
tbl_stand = table(motionLevel,uVatPz_stand)
tbl_walk = table(motionLevel,uVatPz_walk)
fitlm(tbl_sit)
fitlm(tbl_stand)
fitlm(tbl_walk)