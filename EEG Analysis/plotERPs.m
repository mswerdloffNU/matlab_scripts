% close
filename_info = 'S008_info.mat';

% % TTHigh
% figure()
% sit_A = plot(time,Pz_A)
% hold on
% stand_C = plot(time,Pz_C)
% legend('Sitting', 'Walking');
% grid minor
% title('Averaged ERP at Pz - Target Tone High')
% xlabel('Time relative to stimuli (ms)')
% ylabel('Potential (uV)')
% hold off
% 
% % TTLow
% figure()
% sit_B = plot(time,Pz_B)
% hold on
% stand_D = plot(time,Pz_D)
% legend('Sitting', 'Walking');
% grid minor
% title('Averaged ERP at Pz - Target Tone Low')
% xlabel('Time relative to stimuli (ms)')
% ylabel('Potential (uV)')
% hold off
%%
clear all
addpath('C:\Users\mswerdloff\eeglab14_1_2b\importTarget.m')
subs = {'S003','S006','S007','S008','S009','S010','S012','S013','S014'};
% now, put everything into the original format
for i = 1:numel(subs)
load('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\codes_allSubs.mat') %codes
sub = subs{i};
loc_sub = strcat('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\',sub);
filename = strcat(loc_sub,'\rejectedAcceptedTrials_',sub,'_eq.mat');
load(filename)

clear x_all_combined

if i == 1
    x_all_combined = table2array(RejectedTrials_S003_eq);
    codes_all = codes_all_S003;
% elseif i == 2
%     x_all_combined = table2array(RejectedTrials_S005_eq);
%     codes_all = codes_all_S005;
elseif i == 2
    x_all_combined = table2array(RejectedTrials_S006_eq);
    codes_all = codes_all_S006;
elseif i == 3
    x_all_combined = table2array(RejectedTrials_S007_eq);
    codes_all = codes_all_S007;
elseif i == 4
    x_all_combined = table2array(RejectedTrials_S008_eq);
    codes_all = codes_all_S008;
elseif i == 5
    x_all_combined = table2array(RejectedTrials_S009_eq);
    codes_all = codes_all_S009;
elseif i == 6
    x_all_combined = table2array(RejectedTrials_S010_eq);
    codes_all = codes_all_S010;
elseif i == 7
    x_all_combined = table2array(RejectedTrials_S012_eq);
    codes_all = codes_all_S012;
elseif i == 8
    x_all_combined = table2array(RejectedTrials_S013_eq);
    codes_all = codes_all_S013;
elseif i == 9
    x_all_combined = table2array(RejectedTrials_S014_eq);
    codes_all = codes_all_S014;
end
x_all = [x_all_combined(1:301,1) x_all_combined(302:602,1) x_all_combined(603:903,1) x_all_combined(1:301,2) x_all_combined(302:602,2) x_all_combined(603:903,2) x_all_combined(1:301,3) x_all_combined(302:602,3) x_all_combined(603:903,3)];


% import any subject
clear Files

loc_sit = strcat(loc_sub,'\sit');

filePath = strrep(loc_sit,'sit','redoEq9_avg'); % destination folder

loc_stand = strrep(loc_sit,'sit','stand');
loc_walk = strrep(loc_sit,'sit','walk');

cd(loc_sit)
Files_sit = dir('*eq9_ICA_Num_Target.txt'); % choose 1, 2, or 4 for the order of the butterworth filter
for k=1:length(Files_sit)
   filename=Files_sit(k).name % file to be converted
   if strfind(filename, '_A_')
        Files_sit(k).session = '_A_';
   elseif strfind(filename, '_B_')
       Files_sit(k).session = '_B_';
   elseif strfind(filename, '_C_')
       Files_sit(k).session = '_C_';
   end
end
T = struct2table(Files_sit); % convert the struct array to a table
aa_t = sortrows(T, 'session'); % sort the table by session

cd(loc_stand)
Files_stand = dir('*eq9_ICA_Num_Target.txt');
for k=1:length(Files_stand)
   filename=Files_stand(k).name % file to be converted
   if strfind(filename, '_A_')
        Files_stand(k).session = '_A_';
   elseif strfind(filename, '_B_')
       Files_stand(k).session = '_B_';
   elseif strfind(filename, '_C_')
       Files_stand(k).session = '_C_';
   end
end
T = struct2table(Files_stand); % convert the struct array to a table
bb_t = sortrows(T, 'session'); % sort the table by session

cd(loc_walk)
Files_walk = dir('*eq9_ICA_Num_Target.txt');
for k=1:length(Files_stand)
   filename=Files_walk(k).name % file to be converted
   if strfind(filename, '_A_')
        Files_walk(k).session = '_A_';
   elseif strfind(filename, '_B_')
       Files_walk(k).session = '_B_';
   elseif strfind(filename, '_C_')
       Files_walk(k).session = '_C_';
   end
end
T = struct2table(Files_walk); % convert the struct array to a table
cc_t = sortrows(T, 'session'); % sort the table by session

% Concatenate tables
merge_t = [aa_t;bb_t;cc_t];
% Convert table to structure
Files = table2struct(merge_t)

cd(loc_sit)
sitA = importTarget(Files(1).name);
sitB = importTarget(Files(2).name);
sitC = importTarget(Files(3).name);
cd(loc_stand)
standA = importTarget(Files(4).name);
standB = importTarget(Files(5).name);
standC = importTarget(Files(6).name);
cd(loc_walk)
walkA = importTarget(Files(7).name);
walkB = importTarget(Files(8).name);
walkC = importTarget(Files(9).name);

cd(filePath)

time = table2array(sitA(1,2:end));
Pz_SitA = table2array(sitA(2,2:end));
Pz_SitB = table2array(sitB(2,2:end));
Pz_SitC = table2array(sitC(2,2:end));
Pz_StandA = table2array(standA(2,2:end));
Pz_StandB = table2array(standB(2,2:end));
Pz_StandC = table2array(standC(2,2:end));
Pz_TreadA = table2array(walkA(2,2:end));
Pz_TreadB = table2array(walkB(2,2:end));
Pz_TreadC = table2array(walkC(2,2:end));
x2 = [time, fliplr(time)];

clear normParam
for ii = 1:length(Files)
    normParam(ii) = numel(find(codes_all(:,ii)==1))-numel(find(x_all(:,ii)==1))-numel(find(x_all(2:end,ii)==4));
end

S00X_sit_avg_eq(:,i) = ((Pz_SitA*(normParam(1)))+(Pz_SitB*(normParam(2)))+(Pz_SitC*(normParam(3))))/(sum(normParam(1:3)));
S00X_stand_avg_eq(:,i) = ((Pz_StandA*(normParam(4)))+(Pz_StandB*(normParam(5)))+(Pz_StandC*(normParam(6))))/(sum(normParam(4:6)));
S00X_walk_avg_eq(:,i) = ((Pz_TreadA*(normParam(7)))+(Pz_TreadB*(normParam(8)))+(Pz_TreadC*(normParam(9))))/(sum(normParam(7:9)));

S00X_sit_avg_eq_A(:,i) = ((Pz_SitA*(normParam(1)))+(Pz_SitB*0*(normParam(2)))+(Pz_SitC*0*(normParam(3))))/(sum(normParam(1)));
S00X_stand_avg_eq_A(:,i) = ((Pz_StandA*(normParam(4)))+(Pz_StandB*0*(normParam(5)))+(Pz_StandC*0*(normParam(6))))/(sum(normParam(4)));
S00X_walk_avg_eq_A(:,i) = ((Pz_TreadA*(normParam(7)))+(Pz_TreadB*0*(normParam(8)))+(Pz_TreadC*0*(normParam(9))))/(sum(normParam(7)));

S00X_sit_avg_eq_B(:,i) = ((Pz_SitA*0*(normParam(1)))+(Pz_SitB*(normParam(2)))+(Pz_SitC*0*(normParam(3))))/(sum(normParam(2)));
S00X_stand_avg_eq_B(:,i) = ((Pz_StandA*0*(normParam(4)))+(Pz_StandB*(normParam(5)))+(Pz_StandC*0*(normParam(6))))/(sum(normParam(5)));
S00X_walk_avg_eq_B(:,i) = ((Pz_TreadA*0*(normParam(7)))+(Pz_TreadB*(normParam(8)))+(Pz_TreadC*0*(normParam(9))))/(sum(normParam(8)));

S00X_sit_avg_eq_C(:,i) = ((Pz_SitA*0*(normParam(1)))+(Pz_SitB*0*(normParam(2)))+(Pz_SitC*(normParam(3))))/(sum(normParam(3)));
S00X_stand_avg_eq_C(:,i) = ((Pz_StandA*0*(normParam(4)))+(Pz_StandB*0*(normParam(5)))+(Pz_StandC*(normParam(6))))/(sum(normParam(6)));
S00X_walk_avg_eq_C(:,i) = ((Pz_TreadA*0*(normParam(7)))+(Pz_TreadB*0*(normParam(8)))+(Pz_TreadC*(normParam(9))))/(sum(normParam(9)));

% figure()
% hold on
% sit = plot(time,S00X_sit_avg_eq(:,i),'k-','LineWidth',1)
% stand = plot(time,S00X_stand_avg_eq(:,i),'b-','LineWidth',1)
% treadmill = plot(time,S00X_walk_avg_eq(:,i),'r-','LineWidth',1)
% line([0 0], [-15 15]);
% line([-200 800], [0 0]);
% legend('Sit', 'Stand', 'Walk (Treadmill)');
% grid minor
% title('Averaged ERP at Pz (equalized) v9')
% xlabel('Time relative to stimuli (ms)')
% ylabel('Potential (µV)')
% xlim([-200 800])
% hold off
% %savefig('Averaged ERP at Pz (equalized) v9.fig')

clearvars -except i S00X_sit_avg_eq S00X_stand_avg_eq S00X_walk_avg_eq S00X_sit_avg_eq_A S00X_stand_avg_eq_A S00X_walk_avg_eq_A S00X_sit_avg_eq_B S00X_stand_avg_eq_B S00X_walk_avg_eq_B S00X_sit_avg_eq_C S00X_stand_avg_eq_C S00X_walk_avg_eq_C subs time
cd('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2')
%save('Pilot2_avgs_Subs_3678910121314.mat','S00X_sit_avg_eq','S00X_stand_avg_eq','S00X_walk_avg_eq','-mat');
end

% save('Pilot2_avgs_C_Subs_3678910121314.mat','S00X_sit_avg_eq_C','S00X_stand_avg_eq_C','S00X_walk_avg_eq_C','-mat');


%% plot grand averages
homeFolder = ('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2') % destination folder
cd(homeFolder)
n = numel(subs); % number of subjects

setName = 'Pilot2_avgs_Subs_3678910121314'; % these are the files you want to plot (and save the plots with that name)
prevFiles = strcat(homeFolder,'\',setName,'.mat');
load(prevFiles) %codes

% for i = 1:4
%     clear sit_all stand_all walk_all
%     if i == 1
%         sit_all = S00X_sit_avg_eq_A';
%         stand_all = S00X_stand_avg_eq_A';
%         walk_all = S00X_walk_avg_eq_A';
%         session = 'A';
%     elseif i == 2
%         sit_all = S00X_sit_avg_eq_B';
%         stand_all = S00X_stand_avg_eq_B';
%         walk_all = S00X_walk_avg_eq_B';
%         session = 'B';
%     elseif i == 3
%         sit_all = S00X_sit_avg_eq_C';
%         stand_all = S00X_stand_avg_eq_C';
%         walk_all = S00X_walk_avg_eq_C';
%         session = 'C';
%     elseif i == 4
%         sit_all = S00X_sit_avg_eq';
%         stand_all = S00X_stand_avg_eq';
%         walk_all = S00X_walk_avg_eq';
%         session = 'allSessions';
%     end
%     sit_grandAvg = sum(sit_all)/(n);
%     stand_grandAvg = sum(stand_all)/n;
%     walk_grandAvg = sum(walk_all)/n;
%     
%     figure()
%     hold on
%     sit = plot(time,sit_grandAvg,'b-','LineWidth',1)
%     stand = plot(time,stand_grandAvg,'g-','LineWidth',1)
%     treadmill = plot(time,walk_grandAvg,'r-','LineWidth',1)
%     line([0 0], [-15 15]);
%     line([-200 800], [0 0]);
%     legend('Sit', 'Stand', 'Walk');
% %    grid minor
%     if i == 1
%         title('Averaged ERP at Pz (n=9), Session A')
%     elseif i == 2
%         title('Averaged ERP at Pz (n=9), Session B')
%     elseif i == 3
%         title('Averaged ERP at Pz (n=9), Session C')
%     elseif i == 4
%         title('Averaged ERP at Pz (n=9), All Sessions')
%     end
%     xlabel('Time relative to stimuli (ms)')
%     ylabel('Potential (µV)')
%     xlim([-200 800])
%     hold off
%     fnm = sprintf('Averaged ERP at Pz (Grand Average) eq9_noGrid_%s_(%s).fig',session,setName);
%     cd(homeFolder)
%     savefig(fnm)
%     fnm_png = strrep(fnm,'fig','png');
%     print(fnm_png,'-dpng','-r600')
% end

  

% for i = 1:4
%     clear sit_all stand_all walk_all
%     if i == 1
%         sit_all = S00X_sit_avg_eq_A';
%         stand_all = S00X_stand_avg_eq_A';
%         walk_all = S00X_walk_avg_eq_A';
%         session = 'A';
%     elseif i == 2
%         sit_all = S00X_sit_avg_eq_B';
%         stand_all = S00X_stand_avg_eq_B';
%         walk_all = S00X_walk_avg_eq_B';
%         session = 'B';
%     elseif i == 3
%         sit_all = S00X_sit_avg_eq_C';
%         stand_all = S00X_stand_avg_eq_C';
%         walk_all = S00X_walk_avg_eq_C';
%         session = 'C';
%     elseif i == 4
%         sit_all = S00X_sit_avg_eq';
%         stand_all = S00X_stand_avg_eq';
%         walk_all = S00X_walk_avg_eq';
%         session = 'allSessions';
%     end
%     sit_grandAvg = sum(sit_all)/(n);
%     stand_grandAvg = sum(stand_all)/n;
%     walk_grandAvg = sum(walk_all)/n;
%     
%     sit_std = nanstd(sit_all,0,1)/sqrt(n);
%     stand_std = nanstd(stand_all,0,1)/sqrt(n);
%     walk_std = nanstd(walk_all,0,1)/sqrt(n);
%     sit_SEM_p = sit_grandAvg + sit_std;
%     sit_SEM_m = sit_grandAvg - sit_std;
%     stand_SEM_p = stand_grandAvg + stand_std;
%     stand_SEM_m = stand_grandAvg - stand_std;
%     walk_SEM_p = walk_grandAvg + walk_std;
%     walk_SEM_m = walk_grandAvg - walk_std;
%     
%     figure()
% %     plot(time, sit_grandAvg, 'b', time, stand_grandAvg, 'g', time, walk_grandAvg, 'r');
%     sit = plot(time,sit_grandAvg,'b-','LineWidth',1)
%     hold on
%     stand = plot(time,stand_grandAvg,'g-','LineWidth',1)
%     treadmill = plot(time,walk_grandAvg,'r-','LineWidth',1)
%     line([0 0], [-15 15]);
%     line([-200 800], [0 0]);
%     fill([time(1:1:300) time(300:-1:1)], [sit_SEM_m(1:1:300) sit_SEM_p(300:-1:1)], [0.5 0.5 1],'facealpha',0.4,'edgecolor','none');
%     fill([time(1:1:300) time(300:-1:1)], [stand_SEM_m(1:1:300) stand_SEM_p(300:-1:1)], [0.5 1 0.5],'facealpha',0.4,'edgecolor','none');
%     fill([time(1:1:300) time(300:-1:1)], [walk_SEM_m(1:1:300) walk_SEM_p(300:-1:1)], [1 0.5 0.5],'facealpha',0.4,'edgecolor','none');
%     grid minor
%     if i == 1
%         title('Averaged ERP at Pz (n=9), Session A')
%     elseif i == 2
%         title('Averaged ERP at Pz (n=9), Session B')
%     elseif i == 3
%         title('Averaged ERP at Pz (n=9), Session C')
%     elseif i == 4
%         title('Averaged ERP at Pz (n=9), All Sessions')
%     end
%     xlabel('Time relative to stimuli (ms)')
%     ylabel('Potential (µV)')
%     legend('Sit', 'Stand', 'Walk');
%     fnm = sprintf('Averaged ERP at Pz (Grand Average) eq9 with stErr_%s_(%s).fig',session,setName);
%     cd(homeFolder)
%     savefig(fnm)
%     fnm_png = strrep(fnm,'fig','png');
%     print(fnm_png,'-dpng','-r600')
% end

% figure()
% for i = 1:4
%     clear sit_all stand_all walk_all
%     if i == 1
%         sit_all = S00X_sit_avg_eq_A';
%         stand_all = S00X_stand_avg_eq_A';
%         walk_all = S00X_walk_avg_eq_A';
%         session = 'A';
%     elseif i == 2
%         sit_all = S00X_sit_avg_eq_B';
%         stand_all = S00X_stand_avg_eq_B';
%         walk_all = S00X_walk_avg_eq_B';
%         session = 'B';
%     elseif i == 3
%         sit_all = S00X_sit_avg_eq_C';
%         stand_all = S00X_stand_avg_eq_C';
%         walk_all = S00X_walk_avg_eq_C';
%         session = 'C';
%     elseif i == 4
%         sit_all = S00X_sit_avg_eq';
%         stand_all = S00X_stand_avg_eq';
%         walk_all = S00X_walk_avg_eq';
%         session = 'allSessions';
%     end
%     sit_grandAvg = sum(sit_all)/(n);
%     stand_grandAvg = sum(stand_all)/n;
%     walk_grandAvg = sum(walk_all)/n;
%     
%     subplot(4,1,i)
%     hold on
%     sit = plot(time,sit_grandAvg,'b-','LineWidth',1)
%     stand = plot(time,stand_grandAvg,'g-','LineWidth',1)
%     treadmill = plot(time,walk_grandAvg,'r-','LineWidth',1)
%     line([0 0], [-15 15]);
%     line([-200 800], [0 0]);
%     legend('Sit', 'Stand', 'Walk');
%     %grid minor
%     if i == 1
%         title('Averaged ERP at Pz (n=9), Session A')
%     elseif i == 2
%         title('Averaged ERP at Pz (n=9), Session B')
%     elseif i == 3
%         title('Averaged ERP at Pz (n=9), Session C')
%     elseif i == 4
%         title('Averaged ERP at Pz (n=9), All Sessions')
%     end
%     xlabel('Time relative to stimuli (ms)')
%     ylabel('Potential (µV)')
%     xlim([-200 800])
%     hold off
%     fnm = sprintf('Averaged ERP at Pz (Grand Average) eq9_%s_(%s).fig',session,setName);
%     cd(homeFolder)
%     %savefig(fnm)
% end
% 
%   
% figure()
% for i = 1:4
%     clear sit_all stand_all walk_all
%     if i == 1
%         sit_all = S00X_sit_avg_eq_A';
%         stand_all = S00X_stand_avg_eq_A';
%         walk_all = S00X_walk_avg_eq_A';
%         session = 'A';
%     elseif i == 2
%         sit_all = S00X_sit_avg_eq_B';
%         stand_all = S00X_stand_avg_eq_B';
%         walk_all = S00X_walk_avg_eq_B';
%         session = 'B';
%     elseif i == 3
%         sit_all = S00X_sit_avg_eq_C';
%         stand_all = S00X_stand_avg_eq_C';
%         walk_all = S00X_walk_avg_eq_C';
%         session = 'C';
%     elseif i == 4
%         sit_all = S00X_sit_avg_eq';
%         stand_all = S00X_stand_avg_eq';
%         walk_all = S00X_walk_avg_eq';
%         session = 'allSessions';
%     end
%     sit_grandAvg = sum(sit_all)/(n);
%     stand_grandAvg = sum(stand_all)/n;
%     walk_grandAvg = sum(walk_all)/n;
%     
%     sit_std = nanstd(sit_all,0,1)/sqrt(n);
%     stand_std = nanstd(stand_all,0,1)/sqrt(n);
%     walk_std = nanstd(walk_all,0,1)/sqrt(n);
%     sit_SEM_p = sit_grandAvg + sit_std;
%     sit_SEM_m = sit_grandAvg - sit_std;
%     stand_SEM_p = stand_grandAvg + stand_std;
%     stand_SEM_m = stand_grandAvg - stand_std;
%     walk_SEM_p = walk_grandAvg + walk_std;
%     walk_SEM_m = walk_grandAvg - walk_std;
%     
%     subplot(4,1,i)
% %     plot(time, sit_grandAvg, 'b', time, stand_grandAvg, 'g', time, walk_grandAvg, 'r');
%     sit = plot(time,sit_grandAvg,'b-','LineWidth',1)
%     hold on
%     stand = plot(time,stand_grandAvg,'g-','LineWidth',1)
%     treadmill = plot(time,walk_grandAvg,'r-','LineWidth',1)
%     line([0 0], [-15 15]);
%     line([-200 800], [0 0]);
%     fill([time(1:1:300) time(300:-1:1)], [sit_SEM_m(1:1:300) sit_SEM_p(300:-1:1)], [0.5 0.5 1],'facealpha',0.4,'edgecolor','none');
%     fill([time(1:1:300) time(300:-1:1)], [stand_SEM_m(1:1:300) stand_SEM_p(300:-1:1)], [0.5 1 0.5],'facealpha',0.4,'edgecolor','none');
%     fill([time(1:1:300) time(300:-1:1)], [walk_SEM_m(1:1:300) walk_SEM_p(300:-1:1)], [1 0.5 0.5],'facealpha',0.4,'edgecolor','none');
%     grid minor
%     if i == 1
%         title('Averaged ERP at Pz (n=9), Session A')
%     elseif i == 2
%         title('Averaged ERP at Pz (n=9), Session B')
%     elseif i == 3
%         title('Averaged ERP at Pz (n=9), Session C')
%     elseif i == 4
%         title('Averaged ERP at Pz (n=9), All Sessions')
%     end
%     xlabel('Time relative to stimuli (ms)')
%     ylabel('Potential (µV)')
%     legend('Sit', 'Stand', 'Walk');
%     fnm = sprintf('Averaged ERP at Pz (Grand Average) eq9 with stErr_%s_(%s).fig',session,setName);
%     cd(homeFolder)
%     %savefig(fnm)
% end

% figure()
% for i = 1:4
%     clear sit_all stand_all walk_all
%     if i == 1
%         sit_all = S00X_sit_avg_eq_A';
%         stand_all = S00X_sit_avg_eq_B';
%         walk_all = S00X_sit_avg_eq_C';
%         session = 'Sit';
%     elseif i == 2
%         sit_all = S00X_stand_avg_eq_A';
%         stand_all = S00X_stand_avg_eq_B';
%         walk_all = S00X_stand_avg_eq_C';
%         session = 'Stand';
%     elseif i == 3
%         sit_all = S00X_walk_avg_eq_A';
%         stand_all = S00X_walk_avg_eq_B';
%         walk_all = S00X_walk_avg_eq_C';
%         session = 'Walk (Treadmill)';
%     elseif i == 4
%         sit_all = S00X_sit_avg_eq';
%         stand_all = S00X_stand_avg_eq';
%         walk_all = S00X_walk_avg_eq';
%         session = 'allSessions';
%     end
%     sit_grandAvg = sum(sit_all)/(n);
%     stand_grandAvg = sum(stand_all)/n;
%     walk_grandAvg = sum(walk_all)/n;
%     
%     subplot(4,1,i)
%     hold on
%     sit = plot(time,sit_grandAvg,'b-','LineWidth',1)
%     stand = plot(time,stand_grandAvg,'g-','LineWidth',1)
%     treadmill = plot(time,walk_grandAvg,'r-','LineWidth',1)
%     line([0 0], [-15 15]);
%     line([-200 800], [0 0]);
%     if i == 4
%         legend('Sit','Stand','Walk')
%     else
%         legend('A', 'B', 'C');
%     end
%     %grid minor
%     if i == 1
%         title('Averaged ERP at Pz (n=9), Sit')
%     elseif i == 2
%         title('Averaged ERP at Pz (n=9), Stand')
%     elseif i == 3
%         title('Averaged ERP at Pz (n=9), Walk (Treadmill)')
%     elseif i == 4
%         title('Averaged ERP at Pz (n=9), All Sessions')
%     end
%     xlabel('Time relative to stimuli (ms)')
%     ylabel('Potential (µV)')
%     xlim([-200 800])
%     hold off
%     fnm = sprintf('Averaged ERP at Pz (Grand Average) eq9_%s_(%s).fig',session,setName);
%     cd(homeFolder)
%     %savefig(fnm)
% end
% 

figure()
for i = 1:4
% make sure these lines work
%     figure1 = figure;
%     axes1 = axes('Parent',figure1,'ZMinorGrid','on','LineWidth',2,...
%         'YTick',[-10 0 10],...
%         'XTick',[0 300 600],...
%         'FontSize',30,...
%         'FontName','Times New Roman');
%     box(axes1,'on');
    clear sit_all stand_all walk_all
    if i == 1
        sit_all = S00X_sit_avg_eq_A';
        stand_all = S00X_sit_avg_eq_B';
        walk_all = S00X_sit_avg_eq_C';
        session = 'Sit';
    elseif i == 2
        sit_all = S00X_stand_avg_eq_A';
        stand_all = S00X_stand_avg_eq_B';
        walk_all = S00X_stand_avg_eq_C';
        session = 'Stand';
    elseif i == 3
        sit_all = S00X_walk_avg_eq_A';
        stand_all = S00X_walk_avg_eq_B';
        walk_all = S00X_walk_avg_eq_C';
        session = 'Walk (Treadmill)';
    elseif i == 4
        sit_all = S00X_sit_avg_eq';
        stand_all = S00X_stand_avg_eq';
        walk_all = S00X_walk_avg_eq';
        session = 'allSessions';
    end
    sit_grandAvg = sum(sit_all)/(n);
    stand_grandAvg = sum(stand_all)/n;
    walk_grandAvg = sum(walk_all)/n;
    
    subplot(4,1,i)
    hold on
    sit = plot(time,sit_grandAvg,'b-','LineWidth',1) % try making this 2
    stand = plot(time,stand_grandAvg,'g-','LineWidth',1)
    treadmill = plot(time,walk_grandAvg,'r-','LineWidth',1)
    line([0 0], [-15 15],'LineWidth',2,'LineStyle','--'); % make sure the linestuff works
    line([-200 800], [0 0],'LineWidth',2,'LineStyle','--'); % make sure the linestuff works
    if i == 4
        legend('Sit','Stand','Walk')
    else
        legend('A', 'B', 'C');
    end
    %grid minor
    if i == 1
        title('Averaged ERP at Pz (n=9), Sit')
    elseif i == 2
        title('Averaged ERP at Pz (n=9), Stand')
    elseif i == 3
        title('Averaged ERP at Pz (n=9), Walk (Treadmill)')
    elseif i == 4
        title('Averaged ERP at Pz (n=9), All Sessions')
    end
    
    xlabel('Time relative to stimuli (ms)','FontSize',30);
    ylabel('Potential (µV)','FontSize',30,'FontName','Times New Roman');
    set(legend,'Orientation','horizontal','Location','south','FontSize',30); % make sure this works
    xlim([-200 800])
    box on % make sure this works
    hold off
    fnm = sprintf('Averaged ERP at Pz (Grand Average) eq9_%s_(%s).fig',session,setName);
    cd(homeFolder)
    %savefig(fnm)
end




% figure()
% for i = 1:4
%     sit_std = nanstd(sit_all,0,1)/sqrt(n);
%     stand_std = nanstd(stand_all,0,1)/sqrt(n);
%     walk_std = nanstd(walk_all,0,1)/sqrt(n);
%     sit_SEM_p = sit_grandAvg + sit_std;
%     sit_SEM_m = sit_grandAvg - sit_std;
%     stand_SEM_p = stand_grandAvg + stand_std;
%     stand_SEM_m = stand_grandAvg - stand_std;
%     walk_SEM_p = walk_grandAvg + walk_std;
%     walk_SEM_m = walk_grandAvg - walk_std;
% %     figure()
%     subplot(4,1,i)
%     plot(time, sit_grandAvg, 'b', time, stand_grandAvg, 'g', time, walk_grandAvg, 'r');
%     hold on
%     line([0 0], [-15 15]);
%     line([-200 800], [0 0]);
%     fill([time(1:1:300) time(300:-1:1)], [sit_SEM_m(1:1:300) sit_SEM_p(300:-1:1)], [0.5 0.5 1],'facealpha',0.4,'edgecolor','none');
%     fill([time(1:1:300) time(300:-1:1)], [stand_SEM_m(1:1:300) stand_SEM_p(300:-1:1)], [0.5 1 0.5],'facealpha',0.4,'edgecolor','none');
%     fill([time(1:1:300) time(300:-1:1)], [walk_SEM_m(1:1:300) walk_SEM_p(300:-1:1)], [1 0.5 0.5],'facealpha',0.4,'edgecolor','none');
%     grid minor
%     if i == 1
%         title('Averaged ERP at Pz (n=9), Sit')
%     elseif i == 2
%         title('Averaged ERP at Pz (n=9), Stand')
%     elseif i == 3
%         title('Averaged ERP at Pz (n=9), Walk')
%     elseif i == 4
%         title('Averaged ERP at Pz (n=9), All Sessions')
%     end
%     xlabel('Time relative to stimuli (ms)')
%     ylabel('Potential (µV)')
%     %     legend('Sit', 'Stand', 'Walk (Treadmill)');
%     if i == 4
%         legend('Sit','Stand','Walk')
%     else
%         legend('A', 'B', 'C');
%     end
%     fnm = sprintf('Averaged ERP at Pz (Grand Average) eq9 with stErr_%s_(%s).fig',session,setName);
%     cd(homeFolder)
%     %savefig(fnm)
% end

% subplot(4,1,1); title('Averaged ERP at Pz (Grand Average) eq9, Session A')
% subplot(4,1,2); title('Averaged ERP at Pz (Grand Average) eq9, Session B')
% subplot(4,1,3); title('Averaged ERP at Pz (Grand Average) eq9, Session C')
% subplot(4,1,4); title('Averaged ERP at Pz (Grand Average) eq9, All Sessions')
%% import S003
n=1;
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S003\sit'
sitA = importTarget('S003_v2_sit_walk_stand_A_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
sitB = importTarget('S003_v2_walk_sit_stand_B_0002_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
sitC = importTarget('S003_v2_stand_walk_sit_C_0003_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S003\stand'
standA = importTarget('S003_v2_sit_walk_stand_A_0002_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
standB = importTarget('S003_v2_walk_sit_stand_B_0003_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
standC = importTarget('S003_v2_stand_walk_sit_C_0001_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S003\walk'
walkA = importTarget('S003_v2_sit_walk_stand_A_0001_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
walkB = importTarget('S003_v2_walk_sit_stand_B_0001_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
walkC = importTarget('S003_v2_stand_walk_sit_C_0002_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);

% cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S003\sit'
% sitA = importTarget('S003_v2_sit_walk_stand_A_filt_a_b_2_allTrials_ICA_Num_Target.txt', 1, 8);
% sitB = importTarget('S003_v2_walk_sit_stand_B_0002_filt_a_b_2_allTrials_ICA_Num_Target.txt', 1, 8);
% sitC = importTarget('S003_v2_stand_walk_sit_C_0003_filt_a_b_2_allTrials_ICA_Num_Target.txt', 1, 8);
% 
% cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S003\stand'
% standA = importTarget('S003_v2_sit_walk_stand_A_0002_filt_a_b_2_allTrials_ICA_Num_Target.txt', 1, 8);
% standB = importTarget('S003_v2_walk_sit_stand_B_0003_filt_a_b_2_allTrials_ICA_Num_Target.txt', 1, 8);
% standC = importTarget('S003_v2_stand_walk_sit_C_0001_filt_a_b_2_allTrials_ICA_Num_Target.txt', 1, 8);
% 
% cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S003\walk'
% walkA = importTarget('S003_v2_sit_walk_stand_A_0001_filt_a_b_2_allTrials_ICA_Num_Target.txt', 1, 8);
% walkB = importTarget('S003_v2_walk_sit_stand_B_0001_filt_a_b_2_allTrials_ICA_Num_Target.txt', 1, 8);
% walkC = importTarget('S003_v2_stand_walk_sit_C_0002_filt_a_b_2_allTrials_ICA_Num_Target.txt', 1, 8);
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S003\redoEq9'

time = table2array(sitA(1,2:end));
Pz_SitA = table2array(sitA(2,2:end));
Pz_SitB = table2array(sitB(2,2:end));
Pz_SitC = table2array(sitC(2,2:end));
Pz_StandA = table2array(standA(2,2:end));
Pz_StandB = table2array(standB(2,2:end));
Pz_StandC = table2array(standC(2,2:end));
Pz_TreadA = table2array(walkA(2,2:end));
Pz_TreadB = table2array(walkB(2,2:end));
Pz_TreadC = table2array(walkC(2,2:end));
x2 = [time, fliplr(time)];
% S003_sit_avg = (Pz_SitA+Pz_SitB+Pz_SitC)/3;
% S003_stand_avg = (Pz_StandA+Pz_StandB+Pz_StandC)/3;
% S003_walk_avg = (Pz_TreadA+Pz_TreadB+Pz_TreadC)/3;

% S00X_sit_avg_eq = ((Pz_SitA)+(Pz_SitB)+(Pz_SitC))/3;
% S00X_stand_avg_eq = ((Pz_StandA)+(Pz_StandB)+(Pz_StandC))/3;
% S00X_walk_avg_eq = ((Pz_TreadA)+(Pz_TreadB)+(Pz_TreadC))/3;

% figure()
% hold on
% sit = plot(time,S00X_sit_avg_eq,'k-','LineWidth',1)
% stand = plot(time,S00X_stand_avg_eq,'b-','LineWidth',1)
% treadmill = plot(time,S00X_walk_avg_eq,'r-','LineWidth',1)
% line([0 0], [-15 15]);
% line([-200 800], [0 0]);
% legend('Sit', 'Stand', 'Walk (Treadmill)');
% grid minor
% title('Averaged ERP at Pz (equalized) v9')
% xlabel('Time relative to stimuli (ms)')
% ylabel('Potential (µV)')
% xlim([-200 800])
% hold off
% savefig('Averaged ERP at Pz (equalized) v9.fig')

figure()
hold on
sit = plot(time,S003_sit_avg,'k-','LineWidth',1)
stand = plot(time,S003_stand_avg,'b-','LineWidth',1)
treadmill = plot(time,S003_walk_avg,'r-','LineWidth',1)
line([0 0], [-15 15]);
line([-200 800], [0 0]);
legend('Sit', 'Stand', 'Walk (Treadmill)');
grid minor
title('Averaged ERP at Pz (pre-equalize)')
xlabel('Time relative to stimuli (ms)')
ylabel('Potential (µV)')
xlim([-200 800])
hold off
savefig('Averaged ERP at Pz (pre-equalize).fig')

%% %% import S005
n=n+1;
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S005\sit'
sitA = importTarget('S005_v2_walk_sit_stand_A_0001_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
sitB = importTarget('S005_v2_sit_stand_walk_B_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
sitC = importTarget('S005_v2_stand_walk_sit_C_0002_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S005\stand'
standA = importTarget('S005_v2_walk_sit_stand_A_0002_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
standB = importTarget('S005_v2_sit_stand_walk_B_0001_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
standC = importTarget('S005_v2_stand_walk_sit_C_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S005\walk'
walkA = importTarget('S005_v2_walk_sit_stand_A_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
walkB = importTarget('S005_v2_sit_stand_walk_B_0002_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
walkC = importTarget('S005_v2_stand_walk_sit_C_0001_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S005'
time = table2array(sitA(1,2:end));
Pz_SitA = table2array(sitA(2,2:end));
Pz_SitB = table2array(sitB(2,2:end));
Pz_SitC = table2array(sitC(2,2:end));
Pz_StandA = table2array(standA(2,2:end));
Pz_StandB = table2array(standB(2,2:end));
Pz_StandC = table2array(standC(2,2:end));
Pz_TreadA = table2array(walkA(2,2:end));
Pz_TreadB = table2array(walkB(2,2:end));
Pz_TreadC = table2array(walkC(2,2:end));
x2 = [time, fliplr(time)];
S005_sit_avg = (Pz_SitA+Pz_SitB+Pz_SitC)/3;
S005_stand_avg = (Pz_StandA+Pz_StandB+Pz_StandC)/3;
S005_walk_avg = (Pz_TreadA+Pz_TreadB+Pz_TreadC)/3;

%% S006
n=n+1;
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S006\sit'
sitA = importTarget('S006_walk_sit_stand_A_0001_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
sitB = importTarget('S006_sit_stand_walk_B_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
sitC = importTarget('S006_stand_walk_sit_C_0002_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S006\stand'
standA = importTarget('S006_walk_sit_stand_A_0002_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
standB = importTarget('S006_sit_stand_walk_B_0001_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
standC = importTarget('S006_stand_walk_sit_C_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S006\walk'
walkA = importTarget('S006_walk_sit_stand_A_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
walkB = importTarget('S006_sit_stand_walk_B_0003_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
walkC = importTarget('S006_stand_walk_sit_C_0001_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S006'

time = table2array(sitA(1,2:end));
Pz_SitA = table2array(sitA(2,2:end));
Pz_SitB = table2array(sitB(2,2:end));
Pz_SitC = table2array(sitC(2,2:end));
Pz_StandA = table2array(standA(2,2:end));
Pz_StandB = table2array(standB(2,2:end));
Pz_StandC = table2array(standC(2,2:end));
Pz_TreadA = table2array(walkA(2,2:end));
Pz_TreadB = table2array(walkB(2,2:end));
Pz_TreadC = table2array(walkC(2,2:end));
x2 = [time, fliplr(time)];
S006_sit_avg = (Pz_SitA+Pz_SitB+Pz_SitC)/3;
S006_stand_avg = (Pz_StandA+Pz_StandB+Pz_StandC)/3;
S006_walk_avg = (Pz_TreadA+Pz_TreadB+Pz_TreadC)/3;

%% S007
n=n+1;
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S007\sit'
sitA = importTarget('S007_walk_stand_sit_A_0002_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
sitB = importTarget('S007_stand_sit_walk_B_0001_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
sitC = importTarget('S007_sit_walk_stand_C_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S007\stand'
standA = importTarget('S007_walk_stand_sit_A_0001_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
standB = importTarget('S007_stand_sit_walk_B_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
standC = importTarget('S007_sit_walk_stand_C_0002_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S007\walk'
walkA = importTarget('S007_walk_stand_sit_A_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
walkB = importTarget('S007_stand_sit_walk_B_0002_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
walkC = importTarget('S007_sit_walk_stand_C_0001_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S007'

time = table2array(sitA(1,2:end));
Pz_SitA = table2array(sitA(2,2:end));
Pz_SitB = table2array(sitB(2,2:end));
Pz_SitC = table2array(sitC(2,2:end));
Pz_StandA = table2array(standA(2,2:end));
Pz_StandB = table2array(standB(2,2:end));
Pz_StandC = table2array(standC(2,2:end));
Pz_TreadA = table2array(walkA(2,2:end));
Pz_TreadB = table2array(walkB(2,2:end));
Pz_TreadC = table2array(walkC(2,2:end));
x2 = [time, fliplr(time)];
S007_sit_avg = (Pz_SitA+Pz_SitB+Pz_SitC)/3;
S007_stand_avg = (Pz_StandA+Pz_StandB+Pz_StandC)/3;
S007_walk_avg = (Pz_TreadA+Pz_TreadB+Pz_TreadC)/3;
%% S008
n=n+1;
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S008\sit'
sitA = importTarget('S008_sit_walk_stand_A_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
sitB = importTarget('S008_stand_sit_walk_C_0001_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
sitC = importTarget('S008_walk_stand_sit_B_0002_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S008\stand'
standA = importTarget('S008_sit_walk_stand_A_0002_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
standB = importTarget('S008_stand_sit_walk_C_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
standC = importTarget('S008_walk_stand_sit_B_0001_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S008\walk'
walkA = importTarget('S008_sit_walk_stand_A_0001_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
walkB = importTarget('S008_stand_sit_walk_C_0002_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
walkC = importTarget('S008_walk_stand_sit_B_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S008'

time = table2array(sitA(1,2:end));
Pz_SitA = table2array(sitA(2,2:end));
Pz_SitB = table2array(sitB(2,2:end));
Pz_SitC = table2array(sitC(2,2:end));
Pz_StandA = table2array(standA(2,2:end));
Pz_StandB = table2array(standB(2,2:end));
Pz_StandC = table2array(standC(2,2:end));
Pz_TreadA = table2array(walkA(2,2:end));
Pz_TreadB = table2array(walkB(2,2:end));
Pz_TreadC = table2array(walkC(2,2:end));
x2 = [time, fliplr(time)];
S008_sit_avg = (Pz_SitA+Pz_SitB+Pz_SitC)/3;
S008_stand_avg = (Pz_StandA+Pz_StandB+Pz_StandC)/3;
S008_walk_avg = (Pz_TreadA+Pz_TreadB+Pz_TreadC)/3;
%% %% import S009
n=n+1;
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S009\sit'
sitA = importTarget('S009_stand_sit_walk_A_0001_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
sitB = importTarget('S009_sit_walk_stand_B_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
sitC = importTarget('S009_walk_stand_sit_C_0002_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S009\stand'
standA = importTarget('S009_stand_sit_walk_A_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
standB = importTarget('S009_sit_walk_stand_B_0002_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
standC = importTarget('S009_walk_stand_sit_C_0001_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S009\walk'
walkA = importTarget('S009_stand_sit_walk_A_0002_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
walkB = importTarget('S009_sit_walk_stand_B_0001_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
walkC = importTarget('S009_walk_stand_sit_C_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S009'
time = table2array(sitA(1,2:end));
Pz_SitA = table2array(sitA(2,2:end));
Pz_SitB = table2array(sitB(2,2:end));
Pz_SitC = table2array(sitC(2,2:end));
Pz_StandA = table2array(standA(2,2:end));
Pz_StandB = table2array(standB(2,2:end));
Pz_StandC = table2array(standC(2,2:end));
Pz_TreadA = table2array(walkA(2,2:end));
Pz_TreadB = table2array(walkB(2,2:end));
Pz_TreadC = table2array(walkC(2,2:end));
x2 = [time, fliplr(time)];
S009_sit_avg = (Pz_SitA+Pz_SitB+Pz_SitC)/3;
S009_stand_avg = (Pz_StandA+Pz_StandB+Pz_StandC)/3;
S009_walk_avg = (Pz_TreadA+Pz_TreadB+Pz_TreadC)/3;
%% import S010
n=n+1;
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S010\sit'
sitA = importTarget('S010_walk_stand_sit_A_0002_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
sitB = importTarget('S010_stand_sit_walk_B_0001_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
sitC = importTarget('S010_sit_walk_stand_C_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S010\stand'
standA = importTarget('S010_walk_stand_sit_A_0001_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
standB = importTarget('S010_stand_sit_walk_B_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
standC = importTarget('S010_sit_walk_stand_C_0002_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S010\walk'
walkA = importTarget('S010_walk_stand_sit_A_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
walkB = importTarget('S010_stand_sit_walk_B_0002_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
walkC = importTarget('S010_sit_walk_stand_C_0001_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S010'
time = table2array(sitA(1,2:end));
Pz_SitA = table2array(sitA(2,2:end));
Pz_SitB = table2array(sitB(2,2:end));
Pz_SitC = table2array(sitC(2,2:end));
Pz_StandA = table2array(standA(2,2:end));
Pz_StandB = table2array(standB(2,2:end));
Pz_StandC = table2array(standC(2,2:end));
Pz_TreadA = table2array(walkA(2,2:end));
Pz_TreadB = table2array(walkB(2,2:end));
Pz_TreadC = table2array(walkC(2,2:end));
x2 = [time, fliplr(time)];

S010_sit_avg = (Pz_SitA+Pz_SitB+Pz_SitC)/3;
S010_stand_avg = (Pz_StandA+Pz_StandB+Pz_StandC)/3;
S010_walk_avg = (Pz_TreadA+Pz_TreadB+Pz_TreadC)/3;
%% import S011
n=n+1;
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S011\sit'
sitA = importTarget('S010_walk_stand_sit_A_0002_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
sitB = importTarget('S010_stand_sit_walk_B_0001_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
sitC = importTarget('S011_walk_stand_sit_C_0002_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S011\stand'
standA = importTarget('S010_walk_stand_sit_A_0001_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
standB = importTarget('S010_stand_sit_walk_B_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
standC = importTarget('S010_sit_walk_stand_C_0002_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S011\walk'
walkA = importTarget('S010_walk_stand_sit_A_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
walkB = importTarget('S010_stand_sit_walk_B_0002_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);
walkC = importTarget('S010_sit_walk_stand_C_0001_filt_a_b_2_allTrials_eq9_ICA_Num_Target.txt', 1, 8);

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S011'
time = table2array(sitA(1,2:end));
Pz_SitA = table2array(sitA(2,2:end));
Pz_SitB = table2array(sitB(2,2:end));
Pz_SitC = table2array(sitC(2,2:end));
Pz_StandA = table2array(standA(2,2:end));
Pz_StandB = table2array(standB(2,2:end));
Pz_StandC = table2array(standC(2,2:end));
Pz_TreadA = table2array(walkA(2,2:end));
Pz_TreadB = table2array(walkB(2,2:end));
Pz_TreadC = table2array(walkC(2,2:end));
x2 = [time, fliplr(time)];

S011_sit_avg = (Pz_SitA+Pz_SitB+Pz_SitC)/3;
S011_stand_avg = (Pz_StandA+Pz_StandB+Pz_StandC)/3;
S011_walk_avg = (Pz_TreadA+Pz_TreadB+Pz_TreadC)/3;
%%
% time = table2array(grandavgpilot15Target(:,1));
% Pz_Stand = table2array(grandavgpilotstand15Target(:,2));
% Pz_Stand_SEM = table2array(grandavgpilotstand15SEMdataTarget(:,2));
% Pz_Tread = table2array(grandavgpilotwalk135Target(:,2));
% Pz_Tread_SEM = table2array(grandavgpilotwalk135SEMdataTarget(:,2));
% Pz_Sit = table2array(grandavgpilot15Target(:,2));
% Pz_Sit_SEM = table2array(SEMdataTarget(:,2));
% sit_SEM_p = Pz_Sit+Pz_Sit_SEM;
% sit_SEM_m = Pz_Sit-Pz_Sit_SEM;
% stand_SEM_p = Pz_Stand+Pz_Stand_SEM;
% stand_SEM_m = Pz_Stand-Pz_Stand_SEM;
% tread_SEM_p = Pz_Tread+Pz_Tread_SEM;
% tread_SEM_m = Pz_Tread-Pz_Tread_SEM;
% x2 = [time, fliplr(time)];

% time = table2array(sitA(1,2:end));
% Pz_SitA = table2array(sitA(2,2:end));
% Pz_SitB = table2array(sitB(2,2:end));
% Pz_SitC = table2array(sitC(2,2:end));
% Pz_StandA = table2array(standA(2,2:end));
% Pz_StandB = table2array(standB(2,2:end));
% Pz_StandC = table2array(standC(2,2:end));
% Pz_TreadA = table2array(walkA(2,2:end));
% Pz_TreadB = table2array(walkB(2,2:end));
% Pz_TreadC = table2array(walkC(2,2:end));
% x2 = [time, fliplr(time)];

%%
time = table2array(erpsetMaggieWalkTTHighArduinoRecording10min1sISIv2manualFixRfil(:,1));
Pz_Walk_NT = table2array(erpsetMaggieWalkTTHighArduinoRecording10min1sISIv2manualFixRfil(:,2));
Pz_Walk_T = table2array(erpsetMaggieWalkTTHighArduinoRecording10min1sISIv2manualFixRfil(:,2));
% ERPfilename = [erpsetMaggieSitTTHighArduinoRecording10min1sISIpostWalkmanualFi erpsetMaggieTreadmillTTHighArduinoRecording10min1sISIpostWalkSi erpsetMaggieWalkTTHighArduinoRecording10min1sISIv2manualFixRfil]
% ERPset(i) = importERP(ERPfilename(i), startRow, endRow)
%%
% TTHigh
figure()
fill([time(1:1:300);time(300:-1:1)], [sit_SEM_m(1:1:300);sit_SEM_p(300:-1:1)], [0.5 0.5 0.5],'facealpha',0.4,'edgecolor','none');
hold on
fill([time(1:1:300);time(300:-1:1)], [stand_SEM_m(1:1:300);stand_SEM_p(300:-1:1)], [0.5 0.5 1],'facealpha',0.4,'edgecolor','none');
fill([time(1:1:300);time(300:-1:1)], [tread_SEM_m(1:1:300);tread_SEM_p(300:-1:1)], [1 0.5 0.5],'facealpha',0.4,'edgecolor','none');
% sit_SEM_plus = plot(time,Pz_Sit+Pz_Sit_SEM,'b-','LineWidth',1.5)
% hold on
% sit_SEM_minus = plot(time,Pz_Sit-Pz_Sit_SEM,'b-','LineWidth',1.5)
% hold on
% sit_SEM_plus = area(time,sit_SEM_p)
% hold on
% sit_SEM_minus = area(time,sit_SEM_m)

%%
figure()
hold on
sit = plot(time,Pz_SitA,'k-','LineWidth',1)
stand = plot(time,Pz_StandA,'b-','LineWidth',1)
treadmill = plot(time,Pz_TreadA,'r-','LineWidth',1)
line([0 0], [-15 15]);
line([-200 800], [0 0]);
legend('Sit', 'Stand', 'Walk (Treadmill)');
grid minor
title('Averaged ERP at Pz (Early)')
xlabel('Time relative to stimuli (ms)')
ylabel('Potential (µV)')
xlim([-200 800])
hold off
savefig('Averaged ERP at Pz (Early).fig')

figure()
hold on
sit = plot(time,Pz_SitB,'k-','LineWidth',1)
stand = plot(time,Pz_StandB,'b-','LineWidth',1)
treadmill = plot(time,Pz_TreadB,'r-','LineWidth',1)
line([0 0], [-15 15]);
line([-200 800], [0 0]);
legend('Sit', 'Stand', 'Walk (Treadmill)');
grid minor
title('Averaged ERP at Pz (Middle)')
xlabel('Time relative to stimuli (ms)')
ylabel('Potential (µV)')
xlim([-200 800])
hold off
savefig('Averaged ERP at Pz (Middle).fig')

figure()
hold on
sit = plot(time,Pz_SitC,'k-','LineWidth',1)
stand = plot(time,Pz_StandC,'b-','LineWidth',1)
treadmill = plot(time,Pz_TreadC,'r-','LineWidth',1)
line([0 0], [-15 15]);
line([-200 800], [0 0]);
legend('Sit', 'Stand', 'Walk (Treadmill)');
grid minor
title('Averaged ERP at Pz for (Late)')
xlabel('Time relative to stimuli (ms)')
ylabel('Potential (µV)')
xlim([-200 800])
hold off
savefig('Averaged ERP at Pz (Late).fig')

sit_avg = (Pz_SitA+Pz_SitB+Pz_SitC)/3;
stand_avg = (Pz_StandA+Pz_StandB+Pz_StandC)/3;
walk_avg = (Pz_TreadA+Pz_TreadB+Pz_TreadC)/3;

[pks_sit,locs_sit] = findpeaks(sit_avg);
max_sit = max(pks_sit);
latency_sit = time(locs_sit(find(pks_sit == max_sit)));
[pks_stand,locs_stand] = findpeaks(stand_avg);
max_stand = max(pks_stand);
latency_stand = time(locs_stand(find(pks_stand == max_stand)));
[pks_walk,locs_walk] = findpeaks(walk_avg);
max_walk = max(pks_walk);
latency_walk = time(locs_walk(find(pks_walk == max_walk)));

figure()
hold on
sit = plot(time,sit_avg,'k-','LineWidth',1)
stand = plot(time,stand_avg,'b-','LineWidth',1)
treadmill = plot(time,walk_avg,'r-','LineWidth',1)
line([0 0], [-15 15]);
line([-200 800], [0 0]);
legend('Sit', 'Stand', 'Walk (Treadmill)');
grid minor
title('Averaged ERP at Pz (Averaged)')
xlabel('Time relative to stimuli (ms)')
ylabel('Potential (µV)')
xlim([-200 800])
hold off
savefig('Averaged ERP at Pz (Averaged).fig')

%%
pause
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S010'
save(filename_info,'latency_sit','latency_stand','latency_walk','max_sit','max_stand','max_walk', '-mat');

%% plot grand averages
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2'
n = 10; % number of subjects
sit_all = [S003_sit_avg;S005_sit_avg;S006_sit_avg;S007_sit_avg;S008_sit_avg;S009_sit_avg;S010_sit_avg;S012_sit_avg;S013_sit_avg;S014_sit_avg];
stand_all = [S003_stand_avg;S005_stand_avg;S006_stand_avg;S007_stand_avg;S008_stand_avg;S009_stand_avg;S010_stand_avg;S012_stand_avg;S013_stand_avg;S014_stand_avg];
walk_all = [S003_walk_avg;S005_walk_avg;S006_walk_avg;S007_walk_avg;S008_walk_avg;S009_walk_avg;S010_walk_avg;S012_walk_avg;S013_walk_avg;S014_walk_avg];

sit_grandAvg = sum(sit_all)/(n);
stand_grandAvg = sum(stand_all)/n;
walk_grandAvg = sum(walk_all)/n;

figure()
hold on
sit = plot(time,sit_grandAvg,'k-','LineWidth',1)
stand = plot(time,stand_grandAvg,'b-','LineWidth',1)
treadmill = plot(time,walk_grandAvg,'r-','LineWidth',1)
line([0 0], [-15 15]);
line([-200 800], [0 0]);
legend('Sit', 'Stand', 'Walk (Treadmill)');
grid minor
title('Averaged ERP at Pz (Grand Average)')
xlabel('Time relative to stimuli (ms)')
ylabel('Potential (µV)')
xlim([-200 800])
hold off
savefig('Averaged ERP at Pz (Grand Average) eq.fig')


%%
sit_std = nanstd(sit_all,0,1)/sqrt(n-1);
stand_std = nanstd(stand_all,0,1)/sqrt(n);
walk_std = nanstd(walk_all,0,1)/sqrt(n);
sit_SEM_p = sit_grandAvg + sit_std;
sit_SEM_m = sit_grandAvg - sit_std;
stand_SEM_p = stand_grandAvg + stand_std;
stand_SEM_m = stand_grandAvg - stand_std;
walk_SEM_p = walk_grandAvg + walk_std;
walk_SEM_m = walk_grandAvg - walk_std;
figure()
plot(time, sit_grandAvg, 'b', time, stand_grandAvg, 'g', time, walk_grandAvg, 'r');
hold on
line([0 0], [-15 15]);
line([-200 800], [0 0]);
fill([time(1:1:300) time(300:-1:1)], [sit_SEM_m(1:1:300) sit_SEM_p(300:-1:1)], [0.5 0.5 1],'facealpha',0.4,'edgecolor','none');
fill([time(1:1:300) time(300:-1:1)], [stand_SEM_m(1:1:300) stand_SEM_p(300:-1:1)], [0.5 1 0.5],'facealpha',0.4,'edgecolor','none');
fill([time(1:1:300) time(300:-1:1)], [walk_SEM_m(1:1:300) walk_SEM_p(300:-1:1)], [1 0.5 0.5],'facealpha',0.4,'edgecolor','none');
grid minor
title('Averaged ERP at Pz (Grand Average)')
xlabel('Time relative to stimuli (ms)')
ylabel('Potential (µV)')
legend({'Sit', 'Stand', 'Walk'})
savefig('Averaged ERP at Pz (Grand Average) with stErr.fig')

%% bar graphs
x = 1:5;
y1 = [cursor_info_S001_sit_ICA_18.Position(2) cursor_info_S001_treadmill_34.Position(2) cursor_info_S001_stand_34.Position(2)];
y2 = [cursor_info_S002_sit_60.Position(2) 0 0];
y3 = [cursor_info_S003_sit_63.Position(2) cursor_info_S003_treadmill_63.Position(2) cursor_info_S003_stand_63.Position(2)];
y4 = [cursor_info_S004_sit_64.Position(2) cursor_info_S004_stand_64.Position(2) 0];
y5 = [cursor_info_S005_sit_57.Position(2) cursor_info_S005_stand_57.Position(2) cursor_info_S005_treadmill_57.Position(2)];
y = [y1 y2 y3 y4 y5];

% S001:
S001_sit_hSE = cursor_info_S001_sit_ICA_18_plusSE.Position(2);
S001_treadmill_hSE = cursor_info_S001_treadmill_34_plusSE.Position(2);
S001_stand_hSE = cursor_info_S001_stand_34_plusSE.Position(2);
S001_hSE = [cursor_info_S001_sit_ICA_18_plusSE.Position(2) cursor_info_S001_treadmill_34_plusSE.Position(2) cursor_info_S001_stand_34_plusSE.Position(2)];
% S002
S002_sit_hSE = cursor_info_S002_sit_60_plusSE.Position(2);
S002_stand_hSE = 0;
S002_treadmill_hSE = 0;
S002_hSE = [cursor_info_S002_sit_60_plusSE.Position(2) 0 0];
% S003
S003_sit_hSE = cursor_info_S003_sit_63_plusSE.Position(2);
S003_treadmill_hSE = cursor_info_S003_treadmill_63_plusSE.Position(2);
S003_stand_hSE = cursor_info_S003_stand_63_plusSE.Position(2);
S003_hSE = [cursor_info_S003_sit_63_plusSE.Position(2) cursor_info_S003_treadmill_63_plusSE.Position(2) cursor_info_S003_stand_63_plusSE.Position(2)];
% S004
S004_sit_hSE = cursor_info_S004_sit_64_plusSE.Position(2);
S004_stand_hSE = cursor_info_S004_stand_64_plusSE.Position(2);
S004_treadmill_hSE = 0;
S004_hSE = [cursor_info_S004_sit_64_plusSE.Position(2) cursor_info_S004_stand_64_plusSE.Position(2) 0];
% S005
S005_sit_hSE = cursor_info_S005_sit_57_plusSE.Position(2);
S005_stand_hSE = cursor_info_S005_stand_57_plusSE.Position(2);
S005_treadmill_hSE = cursor_info_S005_treadmill_57_plusSE.Position(2);
S005_hSE = [cursor_info_S005_sit_57_plusSE.Position(2) cursor_info_S005_stand_57_plusSE.Position(2) cursor_info_S005_treadmill_57_plusSE.Position(2)]; 

%errhigh = [S001_sit_hSE;S001_treadmill_hSE;S001_stand_hSE;S002_sit_hSE;S002_stand_hSE;S002_treadmill_hSE;S003_sit_hSE;S003_treadmill_hSE;S003_stand_hSE;S004_sit_hSE;S004_stand_hSE;S004_treadmill_hSE;S005_sit_hSE;S005_stand_hSE;S005_treadmill_hSE];
errhigh = [S001_hSE;S002_hSE;S003_hSE;S004_hSE;S005_hSE];

% S001:
S001_sit_lSE = cursor_info_S001_sit_ICA_18_minusSE.Position(2);
S001_treadmill_lSE = cursor_info_S001_treadmill_34_minusSE.Position(2);
S001_stand_lSE = cursor_info_S001_stand_34_minusSE.Position(2);
S001_lSE = [cursor_info_S001_sit_ICA_18_minusSE.Position(2) cursor_info_S001_treadmill_34_minusSE.Position(2) cursor_info_S001_stand_34_minusSE.Position(2)];
% S002
S002_sit_lSE = cursor_info_S002_sit_60_minusSE.Position(2);
S002_stand_lSE = 0;
S002_treadmill_lSE = 0;
S002_lSE = [cursor_info_S002_sit_60_minusSE.Position(2) 0 0];
% S003
S003_sit_lSE = cursor_info_S003_sit_63_minusSE.Position(2);
S003_treadmill_lSE = cursor_info_S003_treadmill_63_minusSE.Position(2);
S003_stand_lSE = cursor_info_S003_stand_63_minusSE.Position(2);
S003_lSE = [cursor_info_S003_sit_63_minusSE.Position(2) cursor_info_S003_treadmill_63_minusSE.Position(2) cursor_info_S003_stand_63_minusSE.Position(2)];
% S004
S004_sit_lSE = cursor_info_S004_sit_64_minusSE.Position(2);
S004_stand_lSE = cursor_info_S004_stand_64_minusSE.Position(2);
S004_treadmill_lSE = 0;
S004_lSE = [cursor_info_S004_sit_64_minusSE.Position(2) cursor_info_S004_stand_64_minusSE.Position(2) 0];
% S005
S005_sit_lSE = cursor_info_S005_sit_57_minusSE.Position(2);
S005_stand_lSE = cursor_info_S005_stand_57_minusSE.Position(2);
S005_treadmill_lSE = cursor_info_S005_treadmill_57_minusSE.Position(2);
S005_lSE = [cursor_info_S005_sit_57_minusSE.Position(2) cursor_info_S005_stand_57_minusSE.Position(2) cursor_info_S005_treadmill_57_minusSE.Position(2)]; 

% errlow = [S001_sit_lSE;S001_treadmill_lSE;S001_stand_lSE;S002_sit_lSE;S002_stand_lSE;S002_treadmill_lSE;S003_sit_lSE;S003_treadmill_lSE;S003_stand_lSE;S004_sit_lSE;S004_stand_lSE;S004_treadmill_lSE;S005_sit_lSE;S005_stand_lSE;S005_treadmill_lSE];
errlow = [S001_lSE;S002_lSE;S003_lSE;S004_lSE;S005_lSE];
    
figure()
bar(y)
grid minor
title('Average P3 at Pz')
ylabel('Potential (µV)')
hold on
er = errorbar(x,y,errlow,errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
hold off
%%
figure()
sit = plot(time,Pz_Sit,'-','LineWidth',2)
line([0 0], [-8 12]);
legend('Sit');
grid minor
title('Averaged ERP at Pz')
xlabel('Time relative to stimuli (ms)')
ylabel('Potential (µV)')
xlim([-200 800])

figure()
lgw = plot(time,Pz_Stand,'-','LineWidth',2)
line([0 0], [-8 12]);
legend('Stand');
grid minor
title('Averaged ERP at Pz')
xlabel('Time relative to stimuli (ms)')
ylabel('Potential (µV)')
xlim([-200 800])

figure()
treadmill = plot(time,Pz_Tread,'-','LineWidth',2)
line([0 0], [-8 12]);
legend('Walk (Treadmill)');
grid minor
title('Averaged ERP at Pz')
xlabel('Time relative to stimuli (ms)')
ylabel('Potential (µV)')
xlim([-200 800])

%%
figure()
lgw_NT = plot(time,Pz_Walk_NT,'r-','LineWidth',2)
hold on
lgw_T = plot(time,Pz_Walk_T,'b-','LineWidth',2)
line([0 0], [-6 6]);
legend('LGW');
grid minor
title('Averaged ERP at Pz')
xlabel('Time relative to stimuli (ms)')
ylabel('Potential (µV)')
xlim([-200 800])
