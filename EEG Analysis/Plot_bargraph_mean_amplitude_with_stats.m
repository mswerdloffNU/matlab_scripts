%% irrelevant
% cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\allSubs\Pilot2_avgs_Subs_3678910121314'
% dlmwrite('S00X_walk_avg_eq.txt', S00X_walk_avg_eq, 'delimiter','\t','newline','pc')
% dlmwrite('S00X_stand_avg_eq.txt', S00X_stand_avg_eq, 'delimiter','\t','newline','pc')
% dlmwrite('S00X_sit_avg_eq.txt', S00X_sit_avg_eq, 'delimiter','\t','newline','pc')
% close all
%% find the average value in the 200-500 region 
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2'

load('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\S00X_avg_eq_subs_3678910121314.mat')

% for each subject
nsub = 9
sr = 300 % Hz = 1/s
frame = [490 540]*sr/1000;
clearfig = 0; % 0 is off, 1 is on.
color = 0; % 0 is off, 1 is on.

for i = 1:nsub
    frame_avg_walk(i) = mean(S00X_walk_avg_eq(frame(1):frame(2),i));
    frame_avg_stand(i) = mean(S00X_stand_avg_eq(frame(1):frame(2),i));
    frame_avg_sit(i) = mean(S00X_sit_avg_eq(frame(1):frame(2),i));
end
frame_avg_all = [frame_avg_sit; frame_avg_stand; frame_avg_walk]';
frame_mean_all = [mean(frame_avg_sit) mean(frame_avg_stand) mean(frame_avg_walk)];
frame_sterr_all = [std(frame_avg_sit)/sqrt(length(frame_avg_sit)) std(frame_avg_stand)/sqrt(length(frame_avg_stand)) std(frame_avg_walk)/sqrt(length(frame_avg_walk))];


err = frame_sterr_all;
y=frame_mean_all;


% mdl = fitlme(tbl,'y ~ 1 + x1 + x2 + x3')

[h1,p1] = ttest(frame_avg_sit, frame_avg_stand);
[h2,p2] = ttest(frame_avg_sit, frame_avg_walk);
[h3,p3] = ttest(frame_avg_stand, frame_avg_walk);
[p1w,h1w] = signrank(frame_avg_sit, frame_avg_stand);
[p2w,h2w] = signrank(frame_avg_sit, frame_avg_walk);
[p3w,h3w] = signrank(frame_avg_stand, frame_avg_walk);
% figure
% bar(y)
% hold on
% errorbar(y, err, '.')
% ylabel('Mean Amplitude in P3 timeframe');


[~,~,stats] = anova2(frame_avg_all,3,'off')
f=figure
% c = multcompare(stats)
if clearfig == 1
    Plot_bargraph_clear(y,err)
end
if color == 1
    Plot_bargraph_color_mean_bwSafe_cropped(y,err)
end
f=gcf;
exportgraphics(f,'barchartaxes.png','Resolution',300)

R_mean_sit_stand = corrcoef(frame_avg_sit,frame_avg_stand);
R_mean_sit_walk = corrcoef(frame_avg_sit,frame_avg_walk);
R_mean_stand_walk = corrcoef(frame_avg_stand,frame_avg_walk);
% %% narrow peak
% frame = [480 560]*sr/1000;
% for i = 1:nsub
%     frame_avg_walk(i) = mean(S00X_walk_avg_eq(frame(1):frame(2),i));
%     frame_avg_stand(i) = mean(S00X_stand_avg_eq(frame(1):frame(2),i));
%     frame_avg_sit(i) = mean(S00X_sit_avg_eq(frame(1):frame(2),i));
% end
% frame_avg_all = [frame_avg_sit; frame_avg_stand; frame_avg_walk]';
% frame_mean_all = [mean(frame_avg_sit) mean(frame_avg_stand) mean(frame_avg_walk)];
% frame_sterr_all = [std(frame_avg_sit)/sqrt(length(frame_avg_sit)) std(frame_avg_stand)/sqrt(length(frame_avg_stand)) std(frame_avg_walk)/sqrt(length(frame_avg_walk))];
% 
% 
% err = frame_sterr_all;
% y=frame_mean_all;
% 
% figure
% bar(y)
% hold on
% errorbar(y, err, '.')
% ylabel('Mean Amplitude in P3 timeframe');
% 
% 
% [~,~,stats] = anova2(frame_avg_all,3,'off')
% figure
% c = multcompare(stats)

%% find the average value in the 200-500 region for Session A

% for each subject
% nsub = 9
% sr = 300 % Hz = 1/s
% frame = [400 700]*sr/1000;


for i = 1:nsub
    frame_avg_walk_A(i) = mean(S00X_walk_avg_eq_A(frame(1):frame(2),i));
    frame_avg_stand_A(i) = mean(S00X_stand_avg_eq_A(frame(1):frame(2),i));
    frame_avg_sit_A(i) = mean(S00X_sit_avg_eq_A(frame(1):frame(2),i));
end
frame_avg_all_A = [frame_avg_sit_A; frame_avg_stand_A; frame_avg_walk_A]';
frame_mean_all_A = [mean(frame_avg_sit_A) mean(frame_avg_stand_A) mean(frame_avg_walk_A)];
frame_sterr_all_A = [std(frame_avg_sit_A)/sqrt(length(frame_avg_sit_A)) std(frame_avg_stand_A)/sqrt(length(frame_avg_stand_A)) std(frame_avg_walk_A)/sqrt(length(frame_avg_walk_A))];


err = frame_sterr_all_A;
y=frame_mean_all_A;

[h4,p4] = ttest(frame_avg_sit_A, frame_avg_stand_A);
[h5,p5] = ttest(frame_avg_sit_A, frame_avg_walk_A);
[h6,p6] = ttest(frame_avg_stand_A, frame_avg_walk_A);
% reviewer 3: use Wilcoxon signed rank test
[p4w,h4w] = signrank(frame_avg_sit_A, frame_avg_stand_A);
[p5w,h5w] = signrank(frame_avg_sit_A, frame_avg_walk_A);
[p6w,h6w] = signrank(frame_avg_stand_A, frame_avg_walk_A);
% figure
% bar(y)
% hold on
% errorbar(y, err, '.')
% ylabel('Mean Amplitude in P3 timeframe for Session A');


[~,~,stats] = anova2(frame_avg_all_A,3,'off')
figure
c = multcompare(stats)
title('Mean Amplitude in P3 timeframe for Session A');

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\Matlab scripts\EEG Analysis'
if clearfig == 1
    Plot_bargraph_clear(y,err)
end
if color == 1
    figureA = Plot_bargraph_color_A_bwSafe(y,err)
end

R_mean_sit_stand_A = corrcoef(frame_avg_sit_A,frame_avg_stand_A);
R_mean_sit_walk_A = corrcoef(frame_avg_sit_A,frame_avg_walk_A);
R_mean_stand_walk_A = corrcoef(frame_avg_stand_A,frame_avg_walk_A);
%% find the average value in the 200-500 region for Session B

% for each subject
% nsub = 9
% sr = 300 % Hz = 1/s
% frame = [400 700]*sr/1000;


for i = 1:nsub
    frame_avg_walk_B(i) = mean(S00X_walk_avg_eq_B(frame(1):frame(2),i));
    frame_avg_stand_B(i) = mean(S00X_stand_avg_eq_B(frame(1):frame(2),i));
    frame_avg_sit_B(i) = mean(S00X_sit_avg_eq_B(frame(1):frame(2),i));
end
frame_avg_all_B = [frame_avg_sit_B; frame_avg_stand_B; frame_avg_walk_B]';
frame_mean_all_B = [mean(frame_avg_sit_B) mean(frame_avg_stand_B) mean(frame_avg_walk_B)];
frame_sterr_all_B = [std(frame_avg_sit_B)/sqrt(length(frame_avg_sit_B)) std(frame_avg_stand_B)/sqrt(length(frame_avg_stand_B)) std(frame_avg_walk_B)/sqrt(length(frame_avg_walk_B))];


err = frame_sterr_all_B;
y=frame_mean_all_B;

[h7,p7] = ttest(frame_avg_sit_B, frame_avg_stand_B);
[h8,p8] = ttest(frame_avg_sit_B, frame_avg_walk_B);
[h9,p9] = ttest(frame_avg_stand_B, frame_avg_walk_B);
% wilcoxon signed rank test
[p7w,h7w] = signrank(frame_avg_sit_B, frame_avg_stand_B);
[p8w,h8w] = signrank(frame_avg_sit_B, frame_avg_walk_B);
[p9w,h9w] = signrank(frame_avg_stand_B, frame_avg_walk_B);
% figure
% bar(y)
% hold on
% errorbar(y, err, '.')
% ylabel('Mean Amplitude in P3 timeframe for Session B');


[~,~,stats] = anova2(frame_avg_all_B,3,'off')
figure
c = multcompare(stats)
title('Mean Amplitude in P3 timeframe for Session B');

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\Matlab scripts\EEG Analysis'
if clearfig == 1
    Plot_bargraph_clear(y,err)
end
if color == 1
    figureB = Plot_bargraph_color_B_bwSafe(y,err)
end

R_mean_sit_stand_B = corrcoef(frame_avg_sit_B,frame_avg_stand_B);
R_mean_sit_walk_B = corrcoef(frame_avg_sit_B,frame_avg_walk_B);
R_mean_stand_walk_B = corrcoef(frame_avg_stand_B,frame_avg_walk_B);
%% find the average value in the 200-500 region for Session C

% % for each subject
% nsub = 9
% sr = 300 % Hz = 1/s
% frame = [400 700]*sr/1000;


for i = 1:nsub
    frame_avg_walk_C(i) = mean(S00X_walk_avg_eq_C(frame(1):frame(2),i));
    frame_avg_stand_C(i) = mean(S00X_stand_avg_eq_C(frame(1):frame(2),i));
    frame_avg_sit_C(i) = mean(S00X_sit_avg_eq_C(frame(1):frame(2),i));
end
frame_avg_all_C = [frame_avg_sit_C; frame_avg_stand_C; frame_avg_walk_C]';
frame_mean_all_C = [mean(frame_avg_sit_C) mean(frame_avg_stand_C) mean(frame_avg_walk_C)];
frame_sterr_all_C = [std(frame_avg_sit_C)/sqrt(length(frame_avg_sit_C)) std(frame_avg_stand_C)/sqrt(length(frame_avg_stand_C)) std(frame_avg_walk_C)/sqrt(length(frame_avg_walk_C))];


err = frame_sterr_all_C;
y=frame_mean_all_C;

[h10,p10] = ttest(frame_avg_sit_C, frame_avg_stand_C);
[h11,p11] = ttest(frame_avg_sit_C, frame_avg_walk_C);
[h12,p12] = ttest(frame_avg_stand_C, frame_avg_walk_C);
% wilcoxon signed rank test
[p10w,h10w] = signrank(frame_avg_sit_C, frame_avg_stand_C);
[p11w,h11w] = signrank(frame_avg_sit_C, frame_avg_walk_C);
[p12w,h12w] = signrank(frame_avg_stand_C, frame_avg_walk_C);

%plot distributions:
nb=100;figure;subplot(3,1,1);histogram(frame_avg_sit_C,nb);subplot(3,1,2);histogram(frame_avg_stand_C,nb);subplot(3,1,3);histogram(frame_avg_walk_C,nb)

% figure
% bar(y)
% hold on
% errorbar(y, err, '.')
% ylabel('Mean Amplitude in P3 timeframe for Session C');

[oc1,oc2,stats] = anova2(frame_avg_all_C,3,'off')
figure
c = multcompare(stats)
title('Mean Amplitude in P3 timeframe for Session C');

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\Matlab scripts\EEG Analysis'
if clearfig == 1
    Plot_bargraph_clear(y,err)
end
if color == 1
    figureC = Plot_bargraph_color_C_bwSafe(y,err)
end

R_mean_sit_stand_C = corrcoef(frame_avg_sit_C,frame_avg_stand_C);
R_mean_sit_walk_C = corrcoef(frame_avg_sit_C,frame_avg_walk_C);
R_mean_stand_walk_C = corrcoef(frame_avg_stand_C,frame_avg_walk_C);

% nout = sampsizepwr('t',[100 5],102,0.80)
%%
% [h13,p13] = ttest(frame_avg_sit_A, frame_avg_sit_B);
% [h14,p14] = ttest(frame_avg_sit_A, frame_avg_sit_C);
% [h15,p15] = ttest(frame_avg_sit_B, frame_avg_sit_C);
% [h16,p16] = ttest(frame_avg_stand_A, frame_avg_stand_B);
% [h17,p17] = ttest(frame_avg_stand_A, frame_avg_stand_C);
% [h18,p18] = ttest(frame_avg_stand_B, frame_avg_stand_C);
% [h19,p19] = ttest(frame_avg_walk_A, frame_avg_walk_B);
% [h20,p20] = ttest(frame_avg_walk_A, frame_avg_walk_C);
% [h21,p21] = ttest(frame_avg_walk_B, frame_avg_walk_C);
% 
% %%
% [h22,p22] = ttest(frame_avg_sit, frame_avg_sit_A);
% [h23,p23] = ttest(frame_avg_sit, frame_avg_sit_B);
% [h24,p24] = ttest(frame_avg_sit, frame_avg_sit_C);
% [h25,p25] = ttest(frame_avg_stand, frame_avg_stand_A);
% [h26,p26] = ttest(frame_avg_stand, frame_avg_stand_B);
% [h27,p27] = ttest(frame_avg_stand, frame_avg_stand_C);
% [h28,p28] = ttest(frame_avg_walk, frame_avg_walk_A);
% [h29,p29] = ttest(frame_avg_walk, frame_avg_walk_B);
% [h30,p30] = ttest(frame_avg_walk, frame_avg_walk_C);
%%
% savefig([figureA figureB figureC],'BargraphsABC')
% savefig([figure5 figure6 figure7],'BargraphsABC_clear')
% savefig([figure5 figure6 figure7],'BargraphsABC_colorBWSafe')

%% plot line graph
frame_mean_all_conds = [frame_mean_all_A; frame_mean_all_B; frame_mean_all_C];
frame_sterr_all_conds = [frame_sterr_all_A; frame_sterr_all_B; frame_sterr_all_C];

% figure
% plot(frame_mean_all_conds,frame_sterr_all_conds)
% errorbar(frame_mean_all_conds,frame_sterr_all_conds)