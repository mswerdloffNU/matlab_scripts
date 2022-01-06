tbl = table(subjects,conditions,sessions,motions,p3_mean,p3_median,'VariableNames',{'Subject','Condition','Session','Motion_RMS_Magnitude','P3_Mean','P3_Median'});
tbl_out = [tbl(1:103,:);tbl(112:end,:)];
lme = fitlme(tbl_out,'P3_Mean ~ Condition + (1|Subject)')

% conditions_out = [conditions(1:103);conditions(112:end)];
% sessions_out = [sessions(1:103);sessions(112:end)];
% p3_rms_allsubs_allconds_sorted_sub_out = [p3_rms_allsubs_allconds_sorted_sub(1:103,:);p3_rms_allsubs_allconds_sorted_sub(112:end,:)];
% table([p3_rms_allsubs_allconds_sorted_sub_out,conditions_out,sessions_out])
% tbl_subs_out = table({p3_rms_allsubs_allconds_sorted_sub(1:103,:);p3_rms_allsubs_allconds_sorted_sub(112:end,:)},conditions_out,sessions_out,'VariableNames',{'Subject','blah','Motion_RMS_Magnitude','trial','P3_Mean','P3_Median','Condition','Session'});
% lme = fitlme(tbl_subs_out,'P3_Mean ~ Condition + (1|Subject)')

%%
pd_p3_sit = fitdist(p3_rms_allsubs_sit_sorted_sub2(:,5),'Normal')
pd_p3_stand = fitdist(p3_rms_allsubs_stand_sorted_sub2(:,5),'Normal')
pd_p3_walk = fitdist(p3_rms_allsubs_walk_sorted_sub2(:,5),'Normal')
pd_p3_walk_out = fitdist([p3_rms_allsubs_walk_sorted_sub2(1:29,5);p3_rms_allsubs_walk_sorted_sub2(38:end,5)],'Normal')

pd_rms_sit = fitdist(p3_rms_allsubs_sit_sorted_sub2(:,3),'Normal')
pd_rms_stand = fitdist(p3_rms_allsubs_stand_sorted_sub2(:,3),'Normal')
pd_rms_walk = fitdist(p3_rms_allsubs_walk_sorted_sub2(:,3),'Normal')
pd_rms_walk_out = fitdist([p3_rms_allsubs_walk_sorted_sub2(1:29,3);p3_rms_allsubs_walk_sorted_sub2(38:end,3)],'Normal')

x_values_p3 = -100:.1:100;
y_p3_sit = pdf(pd_p3_sit,x_values_p3);
y_p3_stand = pdf(pd_p3_stand,x_values_p3);
y_p3_walk = pdf(pd_p3_walk,x_values_p3);
y_p3_walk_out = pdf(pd_p3_walk_out,x_values_p3);

x_values_rms = -.02:.001:.3;
y_rms_sit = pdf(pd_rms_sit,x_values_rms);
y_rms_stand = pdf(pd_rms_stand,x_values_rms);
y_rms_walk = pdf(pd_rms_walk,x_values_rms);
y_rms_walk_out = pdf(pd_rms_walk_out,x_values_rms);
%%
figure
subplot(2,2,1)
hold on
plot(x_values_p3,y_p3_sit,'-','LineWidth',2)
plot(x_values_p3,y_p3_stand,':','LineWidth',2)
plot(x_values_p3,y_p3_walk,'-.','LineWidth',2)
title('P3 with outliers (mu = 3.41262)')
subplot(2,2,2)
hold on
plot(x_values_rms,y_rms_sit,'-','LineWidth',2)
plot(x_values_rms,y_rms_stand,':','LineWidth',2)
plot(x_values_rms,y_rms_walk,'-.','LineWidth',2)
title('RMS with outliers')
subplot(2,2,3)
hold on
plot(x_values_p3,y_p3_sit,'-','LineWidth',2)
plot(x_values_p3,y_p3_stand,':','LineWidth',2)
plot(x_values_p3,y_p3_walk_out,'-.','LineWidth',2)
title('P3 without outliers (mu =  3.41781)')
subplot(2,2,4)
hold on
plot(x_values_rms,y_rms_sit,'-','LineWidth',2)
plot(x_values_rms,y_rms_stand,':','LineWidth',2)
plot(x_values_rms,y_rms_walk_out,'-.','LineWidth',2)
title('RMS without outliers')
%%
figure
hold on
plot(x_values_p3,y_p3_sit,'-','LineWidth',2,'Color',[0, 0.4470, 0.7410])
plot(x_values_p3,y_p3_stand,':','LineWidth',2,'Color',[0.8500, 0.3250, 0.0980])
plot(x_values_p3,y_p3_walk,'-.','LineWidth',2,'Color',1/255*[200,200,200])
plot(x_values_p3,y_p3_walk_out,'-.','LineWidth',2,'Color',[0.9290, 0.6940, 0.1250])
title('P3 Gaussians')
legend('Sit','Stand','Walk with Outliers (mu = 3.41262)','Walk without Outliers (mu =  3.41781)')

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

%%
ii = 1;
while ii <= 9
    ii = 1;
    temp4 = tbl{1:11,4}; erp_mim_rms{1,ii} = mean(temp4); erp_mim_ntrials(1,ii) = length(temp4);
    temp4 = tbl{12:26,4}; erp_mim_rms{2,ii} = mean(temp4); erp_mim_ntrials(2,ii) = length(temp4);
    temp4 = tbl{27:37,4}; erp_mim_rms{3,ii} = mean(temp4); erp_mim_ntrials(3,ii) = length(temp4);
    temp4 = tbl{38:51,4}; erp_mim_rms{4,ii} = mean(temp4); erp_mim_ntrials(4,ii) = length(temp4);
    temp4 = tbl{52:58,4}; erp_mim_rms{5,ii} = mean(temp4); erp_mim_ntrials(5,ii) = length(temp4);
    temp4 = tbl{59:74,4}; erp_mim_rms{6,ii} = mean(temp4); erp_mim_ntrials(6,ii) = length(temp4);
    temp4 = tbl{75:86,4}; erp_mim_rms{7,ii} = mean(temp4); erp_mim_ntrials(7,ii) = length(temp4);
    temp4 = tbl{87:103,4}; erp_mim_rms{8,ii} = mean(temp4); erp_mim_ntrials(8,ii) = length(temp4);
    temp4 = tbl{104:111,4}; erp_mim_rms{9,ii} = mean(temp4); erp_mim_ntrials(9,ii) = length(temp4);
    ii = 2;
    temp4 = tbl{112:125,4}; erp_mim_rms{1,ii} = mean(temp4); erp_mim_ntrials(1,ii) = length(temp4);
    temp4 = tbl{126:139,4}; erp_mim_rms{2,ii} = mean(temp4); erp_mim_ntrials(2,ii) = length(temp4);
    temp4 = tbl{140:148,4}; erp_mim_rms{3,ii} = mean(temp4); erp_mim_ntrials(3,ii) = length(temp4);
    temp4 = tbl{149:158,4}; erp_mim_rms{4,ii} = mean(temp4); erp_mim_ntrials(4,ii) = length(temp4);
    temp4 = tbl{159:172,4}; erp_mim_rms{5,ii} = mean(temp4); erp_mim_ntrials(5,ii) = length(temp4);
    temp4 = tbl{173:185,4}; erp_mim_rms{6,ii} = mean(temp4); erp_mim_ntrials(6,ii) = length(temp4);
    temp4 = tbl{186:201,4}; erp_mim_rms{7,ii} = mean(temp4); erp_mim_ntrials(7,ii) = length(temp4);
    temp4 = tbl{202:212,4}; erp_mim_rms{8,ii} = mean(temp4); erp_mim_ntrials(8,ii) = length(temp4);
    temp4 = tbl{213:222,4}; erp_mim_rms{9,ii} = mean(temp4); erp_mim_ntrials(9,ii) = length(temp4);
    ii = 3;
    temp4 = tbl{223:235,4}; erp_mim_rms{1,ii} = mean(temp4); erp_mim_ntrials(1,ii) = length(temp4);
    temp4 = tbl{236:246,4}; erp_mim_rms{2,ii} = mean(temp4); erp_mim_ntrials(2,ii) = length(temp4);
    temp4 = tbl{247:259,4}; erp_mim_rms{3,ii} = mean(temp4); erp_mim_ntrials(3,ii) = length(temp4);
    temp4 = tbl{260:274,4}; erp_mim_rms{4,ii} = mean(temp4); erp_mim_ntrials(4,ii) = length(temp4);
    temp4 = tbl{275:284,4}; erp_mim_rms{5,ii} = mean(temp4); erp_mim_ntrials(5,ii) = length(temp4);
    temp4 = tbl{285:296,4}; erp_mim_rms{6,ii} = mean(temp4); erp_mim_ntrials(6,ii) = length(temp4);
    temp4 = tbl{297:307,4}; erp_mim_rms{7,ii} = mean(temp4); erp_mim_ntrials(7,ii) = length(temp4);
    temp4 = tbl{308:321,4}; erp_mim_rms{8,ii} = mean(temp4); erp_mim_ntrials(8,ii) = length(temp4);
    temp4 = tbl{322:333,4}; erp_mim_rms{9,ii} = mean(temp4); erp_mim_ntrials(9,ii) = length(temp4);
    ii = 4;
    temp4 = tbl{334:342,4}; erp_mim_rms{1,ii} = mean(temp4); erp_mim_ntrials(1,ii) = length(temp4);
    temp4 = tbl{343:359,4}; erp_mim_rms{2,ii} = mean(temp4); erp_mim_ntrials(2,ii) = length(temp4);
    temp4 = tbl{360:370,4}; erp_mim_rms{3,ii} = mean(temp4); erp_mim_ntrials(3,ii) = length(temp4);
    temp4 = tbl{371:381,4}; erp_mim_rms{4,ii} = mean(temp4); erp_mim_ntrials(4,ii) = length(temp4);
    temp4 = tbl{382:395,4}; erp_mim_rms{5,ii} = mean(temp4); erp_mim_ntrials(5,ii) = length(temp4);
    temp4 = tbl{396:407,4}; erp_mim_rms{6,ii} = mean(temp4); erp_mim_ntrials(6,ii) = length(temp4);
    temp4 = tbl{408:418,4}; erp_mim_rms{7,ii} = mean(temp4); erp_mim_ntrials(7,ii) = length(temp4);
    temp4 = tbl{419:431,4}; erp_mim_rms{8,ii} = mean(temp4); erp_mim_ntrials(8,ii) = length(temp4);
    temp4 = tbl{432:444,4}; erp_mim_rms{9,ii} = mean(temp4); erp_mim_ntrials(9,ii) = length(temp4);
    ii = 5;
    temp4 = tbl{445:457,4}; erp_mim_rms{1,ii} = mean(temp4); erp_mim_ntrials(1,ii) = length(temp4);
    temp4 = tbl{458:469,4}; erp_mim_rms{2,ii} = mean(temp4); erp_mim_ntrials(2,ii) = length(temp4);
    temp4 = tbl{470:481,4}; erp_mim_rms{3,ii} = mean(temp4); erp_mim_ntrials(3,ii) = length(temp4);
    temp4 = tbl{482:495,4}; erp_mim_rms{4,ii} = mean(temp4); erp_mim_ntrials(4,ii) = length(temp4);
    temp4 = tbl{496:509,4}; erp_mim_rms{5,ii} = mean(temp4); erp_mim_ntrials(5,ii) = length(temp4);
    temp4 = tbl{510:518,4}; erp_mim_rms{6,ii} = mean(temp4); erp_mim_ntrials(6,ii) = length(temp4);
    temp4 = tbl{519:537,4}; erp_mim_rms{7,ii} = mean(temp4); erp_mim_ntrials(7,ii) = length(temp4);
    temp4 = tbl{538:544,4}; erp_mim_rms{8,ii} = mean(temp4); erp_mim_ntrials(8,ii) = length(temp4);
    temp4 = tbl{545:555,4}; erp_mim_rms{9,ii} = mean(temp4); erp_mim_ntrials(9,ii) = length(temp4);
    ii = 6;
    temp4 = tbl{556:570,4}; erp_mim_rms{1,ii} = mean(temp4); erp_mim_ntrials(1,ii) = length(temp4);
    temp4 = tbl{571:579,4}; erp_mim_rms{2,ii} = mean(temp4); erp_mim_ntrials(2,ii) = length(temp4);
    temp4 = tbl{580:592,4}; erp_mim_rms{3,ii} = mean(temp4); erp_mim_ntrials(3,ii) = length(temp4);
    temp4 = tbl{593:606,4}; erp_mim_rms{4,ii} = mean(temp4); erp_mim_ntrials(4,ii) = length(temp4);
    temp4 = tbl{607:617,4}; erp_mim_rms{5,ii} = mean(temp4); erp_mim_ntrials(5,ii) = length(temp4);
    temp4 = tbl{618:629,4}; erp_mim_rms{6,ii} = mean(temp4); erp_mim_ntrials(6,ii) = length(temp4);
    temp4 = tbl{630:651,4}; erp_mim_rms{7,ii} = mean(temp4); erp_mim_ntrials(7,ii) = length(temp4);
    temp4 = tbl{652:656,4}; erp_mim_rms{8,ii} = mean(temp4); erp_mim_ntrials(8,ii) = length(temp4);
    temp4 = tbl{657:666,4}; erp_mim_rms{9,ii} = mean(temp4); erp_mim_ntrials(9,ii) = length(temp4);
    ii = 7;
    temp4 = tbl{667:678,4}; erp_mim_rms{1,ii} = mean(temp4); erp_mim_ntrials(1,ii) = length(temp4);
    temp4 = tbl{679:694,4}; erp_mim_rms{2,ii} = mean(temp4); erp_mim_ntrials(2,ii) = length(temp4);
    temp4 = tbl{695:703,4}; erp_mim_rms{3,ii} = mean(temp4); erp_mim_ntrials(3,ii) = length(temp4);
    temp4 = tbl{704:713,4}; erp_mim_rms{4,ii} = mean(temp4); erp_mim_ntrials(4,ii) = length(temp4);
    temp4 = tbl{714:727,4}; erp_mim_rms{5,ii} = mean(temp4); erp_mim_ntrials(5,ii) = length(temp4);
    temp4 = tbl{728:740,4}; erp_mim_rms{6,ii} = mean(temp4); erp_mim_ntrials(6,ii) = length(temp4);
    temp4 = tbl{741:744,4}; erp_mim_rms{7,ii} = mean(temp4); erp_mim_ntrials(7,ii) = length(temp4);
    temp4 = tbl{745:754,4}; erp_mim_rms{8,ii} = mean(temp4); erp_mim_ntrials(8,ii) = length(temp4);
    temp4 = tbl{755:777,4}; erp_mim_rms{9,ii} = mean(temp4); erp_mim_ntrials(9,ii) = length(temp4);
    ii = 8;
    temp4 = tbl{778:789,4}; erp_mim_rms{1,ii} = mean(temp4); erp_mim_ntrials(1,ii) = length(temp4);
    temp4 = tbl{790:802,4}; erp_mim_rms{2,ii} = mean(temp4); erp_mim_ntrials(2,ii) = length(temp4);
    temp4 = tbl{803:814,4}; erp_mim_rms{3,ii} = mean(temp4); erp_mim_ntrials(3,ii) = length(temp4);
    temp4 = tbl{815:825,4}; erp_mim_rms{4,ii} = mean(temp4); erp_mim_ntrials(4,ii) = length(temp4);
    temp4 = tbl{826:836,4}; erp_mim_rms{5,ii} = mean(temp4); erp_mim_ntrials(5,ii) = length(temp4);
    temp4 = tbl{837:851,4}; erp_mim_rms{6,ii} = mean(temp4); erp_mim_ntrials(6,ii) = length(temp4);
    temp4 = tbl{852:860,4}; erp_mim_rms{7,ii} = mean(temp4); erp_mim_ntrials(7,ii) = length(temp4);
    temp4 = tbl{861:872,4}; erp_mim_rms{8,ii} = mean(temp4); erp_mim_ntrials(8,ii) = length(temp4);
    temp4 = tbl{873:888,4}; erp_mim_rms{9,ii} = mean(temp4); erp_mim_ntrials(9,ii) = length(temp4);
    ii = 9;
    temp4 = tbl{889:901,4}; erp_mim_rms{1,ii} = mean(temp4); erp_mim_ntrials(1,ii) = length(temp4);
    temp4 = tbl{902:912,4}; erp_mim_rms{2,ii} = mean(temp4); erp_mim_ntrials(2,ii) = length(temp4);
    temp4 = tbl{913:925,4}; erp_mim_rms{3,ii} = mean(temp4); erp_mim_ntrials(3,ii) = length(temp4);
    temp4 = tbl{926:940,4}; erp_mim_rms{4,ii} = mean(temp4); erp_mim_ntrials(4,ii) = length(temp4);
    temp4 = tbl{941:953,4}; erp_mim_rms{5,ii} = mean(temp4); erp_mim_ntrials(5,ii) = length(temp4);
    temp4 = tbl{954:962,4}; erp_mim_rms{6,ii} = mean(temp4); erp_mim_ntrials(6,ii) = length(temp4);
    temp4 = tbl{963:978,4}; erp_mim_rms{7,ii} = mean(temp4); erp_mim_ntrials(7,ii) = length(temp4);
    temp4 = tbl{979:984,4}; erp_mim_rms{8,ii} = mean(temp4); erp_mim_ntrials(8,ii) = length(temp4);
    temp4 = tbl{985:999,4}; erp_mim_rms{9,ii} = mean(temp4); erp_mim_ntrials(9,ii) = length(temp4);
    ii = 10;
end
rms_sub = double(cell2mat([erp_mim_rms(:)]));

%%
load('Z:\Lab Member Folders\Margaret Swerdloff\for Levi\Pilot2_accel\table_avgbySub.mat')
%%
[tbl2,order] = sortrows(tbl2,'Condition','ascend');
rms_sub2 = rms_sub(order)
%%
pd_p3_sit_sub = fitdist(tbl2{1:27,5},'Normal')
pd_p3_stand_sub = fitdist(tbl2{28:54,5},'Normal')
pd_p3_walk_sub = fitdist(tbl2{55:end,5},'Normal')

pd_rms_sit_sub = fitdist(rms_sub2(1:27),'Normal')
pd_rms_stand_sub = fitdist(rms_sub2(28:54),'Normal')
pd_rms_walk_sub = fitdist(rms_sub2(55:end),'Normal')

x_values_p3 = -100:.1:100;
y_p3_sit_sub = pdf(pd_p3_sit_sub,x_values_p3);
y_p3_stand_sub = pdf(pd_p3_stand_sub,x_values_p3);
y_p3_walk_sub = pdf(pd_p3_walk_sub,x_values_p3);

x_values_rms = -.02:.001:.3;
y_rms_sit_sub = pdf(pd_rms_sit_sub,x_values_rms);
y_rms_stand_sub = pdf(pd_rms_stand_sub,x_values_rms);
y_rms_walk_sub = pdf(pd_rms_walk_sub,x_values_rms);

%% scatterplot with gaussians avg by sub
figure
h1 = scatterhist(rms_sub2,tbl2{:,5},'Group',tbl2{:,2},'Marker','o+d','MarkerSize',[8,8,8],'LineWidth',[.1,.1,.1]);
hold on
% scatter(mean(p3_rms_ssw_sub_tbl{1:11,4}),mean(p3_rms_ssw_sub_tbl{1:11,5}),'ko','MarkerFaceColor',[0, 0.4470, 0.7410],'LineWidth',1)
% scatter(mean(p3_rms_ssw_sub_tbl{159:172,4}),mean(p3_rms_ssw_sub_tbl{159:172,5}),'k+','MarkerFaceColor',[0.8500, 0.3250, 0.0980],'LineWidth',1)
% scatter(mean(p3_rms_ssw_sub_tbl{322:333,4}),mean(p3_rms_ssw_sub_tbl{322:333,5}),'kd','MarkerFaceColor',[0.9290, 0.6940, 0.1250],'LineWidth',1)
plot(h1(2),x_values_rms,[y_rms_sit_sub;y_rms_stand_sub;y_rms_walk_sub],'LineWidth',2)
plot(h1(3),x_values_p3,[y_p3_sit_sub;y_p3_stand_sub;y_p3_walk_sub],'LineWidth',2)
ylim([-20 20])
set(h1(2:3),'XTickLabel','');
view(h1(3),[90,270]);  % Rotate the Y plot
%axis(h1(1),'auto');  % Sync axes
hold off;
xlabel('Head Motion RMS')
ylabel('uV at Pz')
legend('Sit','Stand','Walk')
set(gca,'FontSize',14)

%%
sessions2 = categorical(repmat([1;2;3;4;5;6;7;8;9],9,1));

%% scatterplot with gaussians avg by sub and session
figure
h1 = scatterhist(rms_sub2,tbl2{:,5},'Group',sessions2);
hold on
plot(h1(2),single(x_values_rms),[y_rms_sit_sub;y_rms_stand_sub;y_rms_walk_sub],'LineWidth',2)
plot(h1(3),single(x_values_p3),[y_p3_sit_sub;y_p3_stand_sub;y_p3_walk_sub],'LineWidth',2)
ylim([-50 50])
set(h1(2:3),'XTickLabel','');
view(h1(3),[90,270]);  % Rotate the Y plot
axis(h1(1),'auto');  % Sync axes
hold off;
xlabel('Head Motion RMS')
ylabel('uV at Pz')
% legend('Sit','Stand','Walk')
set(gca,'FontSize',14)










%% scatterplot with gaussians avg by sub and session
figure
subplot(1,3,1)
h1 = scatterhist(rms_sub(1:3:end),tbl2{1:3:end,5},'Group',tbl2{1:3:end,2});
%h1 = scatterhist([rms_sub(1:3:end);rms_sub(2:3:end);rms_sub(3:3:end)],[tbl2{1:3:end,5};tbl2{2:3:end,5};tbl2{3:3:end,5}],'Group',[tbl2{1:3:end,2};tbl2{2:3:end,2};tbl2{2:3:end,2}]);
hold on
plot(h1(2),x_values_rms,[y_rms_sit;y_rms_stand;y_rms_walk],'LineWidth',2)
plot(h1(3),x_values_p3,[y_p3_sit;y_p3_stand;y_p3_walk],'LineWidth',2)
ylim([-100 100])
set(h1(2:3),'XTickLabel','');
view(h1(3),[90,270]);  % Rotate the Y plot
%axis(h1(1),'auto');  % Sync axes
hold off;
xlabel('Head Motion RMS')
ylabel('uV at Pz')
legend('Sit','Stand','Walk')
set(gca,'FontSize',14)
title('Session A')

figure
h2 = scatterhist(rms_sub(2:3:end),tbl2{2:3:end,5},'Group',tbl2{2:3:end,2});
hold on
plot(h2(2),x_values_rms,[y_rms_sit;y_rms_stand;y_rms_walk],'LineWidth',2)
plot(h2(3),x_values_p3,[y_p3_sit;y_p3_stand;y_p3_walk],'LineWidth',2)
ylim([-100 100])
set(h2(2:3),'XTickLabel','');
view(h2(3),[90,270]);  % Rotate the Y plot
%axis(h1(1),'auto');  % Sync axes
hold off;
xlabel('Head Motion RMS')
ylabel('uV at Pz')
legend('Sit','Stand','Walk')
set(gca,'FontSize',14)
title('Session B')

figure
h3 = scatterhist(rms_sub(3:3:end),tbl2{3:3:end,5},'Group',tbl2{3:3:end,2});
hold on
plot(h3(2),x_values_rms,[y_rms_sit;y_rms_stand;y_rms_walk],'LineWidth',2)
plot(h3(3),x_values_p3,[y_p3_sit;y_p3_stand;y_p3_walk],'LineWidth',2)
ylim([-100 100])
set(h3(2:3),'XTickLabel','');
view(h3(3),[90,270]);  % Rotate the Y plot
%axis(h1(1),'auto');  % Sync axes
hold off;
xlabel('Head Motion RMS')
ylabel('uV at Pz')
legend('Sit','Stand','Walk')
set(gca,'FontSize',14)
title('Session C')

%%
figure
hold on
scatter(rms_sub(1:3:end),tbl2{1:3:end,5},tbl2{1:3:end,2})
scatter(rms_sub(2:3:end),tbl2{2:3:end,5},tbl2{2:3:end,2})
scatter(rms_sub(3:3:end),tbl2{3:3:end,5},tbl2{3:3:end,2})