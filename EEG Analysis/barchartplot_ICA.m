%% bar graph
x = 1:19;
y1 = [cursor_info_S001_sit_ICA_18.Position(2) cursor_info_S001_treadmill_ICA_18.Position(2) cursor_info_S001_stand_ICA_18.Position(2) 0];
y2 = [cursor_info_S002_sit_ICA_65.Position(2) cursor_info_S002_stand_ICA_65.Position(2) 0 0];
y3 = [cursor_info_S003_sit_ICA_63.Position(2) cursor_info_S003_treadmill_ICA_63.Position(2) cursor_info_S003_stand_ICA_63.Position(2) 0];
y4 = [cursor_info_S004_sit_ICA_63.Position(2) cursor_info_S004_stand_ICA_63.Position(2) 0 0];
y5 = [cursor_info_S005_sit_ICA_81.Position(2) cursor_info_S005_stand_ICA_81.Position(2) cursor_info_S005_treadmill_ICA_81.Position(2)];
y = [y1 y2 y3 y4 y5]';

avg_sit = mean([y1(1),y2(1),y3(1),y4(1),y5(1)]);
avg_walk = mean([y1(2),y3(2),y5(3)]);
avg_stand = mean([y1(3),y2(2),y3(3),y4(2),y5(2)]);
%%
% S001:
S001_sit_hSE = cursor_info_S001_sit_ICA_18_plusSE.Position(2)-y1(1);
S001_treadmill_hSE = cursor_info_S001_treadmill_ICA_18_plusSE.Position(2)-y1(2);
S001_stand_hSE = cursor_info_S001_stand_ICA_18_plusSE.Position(2)-y1(3);
S001_hSE = [S001_sit_hSE S001_treadmill_hSE S001_stand_hSE];
% S002
S002_sit_hSE = cursor_info_S002_sit_ICA_65_plusSE.Position(2)-y2(1);
S002_stand_hSE = cursor_info_S002_stand_ICA_65_plusSE.Position(2)-y2(2);
S002_treadmill_hSE = 0;
S002_hSE = [S002_sit_hSE S002_stand_hSE S002_treadmill_hSE];
% S003
S003_sit_hSE = cursor_info_S003_sit_ICA_63_plusSE.Position(2)-y3(1);
S003_treadmill_hSE = cursor_info_S003_treadmill_ICA_63_plusSE.Position(2)-y3(2);
S003_stand_hSE = cursor_info_S003_stand_ICA_63_plusSE.Position(2)-y3(3);
S003_hSE = [S003_sit_hSE S003_treadmill_hSE S003_stand_hSE];
% S004
S004_sit_hSE = cursor_info_S004_sit_ICA_63_plusSE.Position(2)-y4(1);
S004_stand_hSE = cursor_info_S004_stand_ICA_63_plusSE.Position(2)-y4(2);
S004_treadmill_hSE = 0;
S004_hSE = [S004_sit_hSE S004_stand_hSE S004_treadmill_hSE];
% S005
S005_sit_hSE = cursor_info_S005_sit_ICA_81_plusSE.Position(2)-y5(1);
S005_stand_hSE = cursor_info_S005_stand_ICA_81_plusSE.Position(2)-y5(2);
S005_treadmill_hSE = cursor_info_S005_treadmill_ICA_81_plusSE.Position(2)-y5(3);
S005_hSE = [S005_sit_hSE S005_treadmill_hSE S005_stand_hSE];

errhigh = [S001_sit_hSE S001_treadmill_hSE S001_stand_hSE 0 S002_sit_hSE S002_stand_hSE S002_treadmill_hSE 0 S003_sit_hSE S003_treadmill_hSE S003_stand_hSE 0 S004_sit_hSE S004_stand_hSE S004_treadmill_hSE 0 S005_sit_hSE S005_stand_hSE S005_treadmill_hSE];


%%
% S001:
S001_sit_lSE = y1(1)-cursor_info_S001_sit_ICA_18_minusSE.Position(2);
S001_treadmill_lSE = y1(2)-cursor_info_S001_treadmill_ICA_18_minusSE.Position(2);
S001_stand_lSE = y1(3)-cursor_info_S001_stand_ICA_18_minusSE.Position(2);
S001_lSE = [S001_sit_lSE S001_treadmill_lSE S001_stand_lSE];
% S002
S002_sit_lSE = y2(1)-cursor_info_S002_sit_ICA_65_minusSE.Position(2);
S002_stand_lSE = y2(2)-cursor_info_S002_stand_ICA_65_minusSE.Position(2);
S002_treadmill_lSE = 0;
S002_lSE = [S002_sit_lSE S002_stand_lSE S002_treadmill_lSE];
% S003
S003_sit_lSE = y3(1)-cursor_info_S003_sit_ICA_63_minusSE.Position(2);
S003_treadmill_lSE = y3(2)-cursor_info_S003_treadmill_ICA_63_minusSE.Position(2);
S003_stand_lSE = y3(3)-cursor_info_S003_stand_ICA_63_minusSE.Position(2);
S003_lSE = [S003_sit_lSE S003_treadmill_lSE S003_stand_lSE];
% S004
S004_sit_lSE = y4(1)-cursor_info_S004_sit_ICA_63_minusSE.Position(2);
S004_stand_lSE = y4(2)-cursor_info_S004_stand_ICA_63_minusSE.Position(2);
S004_treadmill_lSE = 0;
S004_lSE = [S004_sit_lSE S004_stand_lSE S004_treadmill_lSE];
% S005
S005_sit_lSE = y5(1)-cursor_info_S005_sit_ICA_81_minusSE.Position(2);
S005_stand_lSE = y5(2)-cursor_info_S005_stand_ICA_81_minusSE.Position(2);
S005_treadmill_lSE = y5(3)-cursor_info_S005_treadmill_ICA_81_minusSE.Position(2);
S005_lSE = [S005_sit_lSE S005_treadmill_lSE S005_stand_lSE];

errlow = [S001_sit_lSE S001_treadmill_lSE S001_stand_lSE 0 S002_sit_lSE S002_stand_lSE S002_treadmill_lSE 0 S003_sit_lSE S003_treadmill_lSE S003_stand_lSE 0 S004_sit_lSE S004_stand_lSE S004_treadmill_lSE 0 S005_sit_lSE S005_stand_lSE S005_treadmill_lSE];

% figure()
% b = bar(y)
% grid minor
% title('Average P3 at Pz')
% ylabel('Potential (uV)')
% b.FaceColor = ['c'];
% % b.CData(2,:) = [.5 0 .5];
% hold on
% er = errorbar(x,y,errlow,errhigh);    
% er.Color = [0 0 0];                            
% er.LineStyle = 'none';  
% hold off

%%
fHand = figure;
aHand = axes('parent', fHand);
hold(aHand, 'on')
%colors = hsv(numel(y));
colors = [0 0.4470 0.7410; 0.9290 0.6940 0.1250; 0.8500 0.3250 0.0980; 0 0 0;... %S001
    0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250; 0 0 0;... %S002
    0 0.4470 0.7410; 0.9290 0.6940 0.1250; 0.8500 0.3250 0.0980; 0 0 0;... %S003
    0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250; 0 0 0;... %S004
    0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250]; %S005
for i = 1:numel(y)
    bar(i, y(i), 'parent', aHand, 'facecolor', colors(i,:));
end
set(gca, 'XTick', 1:numel(y), 'XTickLabel', {'   ', '   ', '   ','  '},'FontSize',12)
er = errorbar(x,y,errlow,errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none'; 
grid minor
hLg=legend(['Sit  ';'Walk ';'Stand'], ...
           'orientation','horizontal', ...
           'location','north'); legend('boxoff') % add legend
hLg.FontSize = 26;
title('Average P3 at Pz','FontSize',32)
ylabel('Potential (uV)','FontSize',32)
%%
% figure()
% ABC=[y1' y2' y3' y4' y5'].';
% hBar=bar(ABC,'grouped');      % basic grouped bar plot, keep handle
% hFg=gcf; hAx=gca;             % handles to current figure, axes
% ylim([0 14])                % space out a little extra room
% hAx.XTickLabel={'S001';'S002';'S003';'S004';'S005'}; % label x axis
% hAx.XAxisLocation='bottom';
% %hBar(2).FaceColor='r';
% %hAx.YColor=get(hFg,'color'); box off  % hide y axis/labels, outline
% hLg=legend(['Sit  ';'Walk ';'Stand'], ...
%            'orientation','horizontal', ...
%            'location','north'); legend('boxoff') % add legend