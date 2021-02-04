%% bar graph
x = 1:19;
y1 = [cursor_info_S001_sit_34.Position(2) cursor_info_S001_treadmill_34.Position(2) cursor_info_S001_stand_34.Position(2) 0 ];
y2 = [cursor_info_S002_sit_60.Position(2) 0 0 0 ];
y3 = [cursor_info_S003_sit_63.Position(2) cursor_info_S003_treadmill_63.Position(2) cursor_info_S003_stand_63.Position(2) 0 ];
y4 = [cursor_info_S004_sit_64.Position(2) cursor_info_S004_stand_64.Position(2) 0 0 ];
y5 = [cursor_info_S005_sit_57.Position(2) cursor_info_S005_stand_57.Position(2) cursor_info_S005_treadmill_57.Position(2)];
y = [y1 y2 y3 y4 y5]';

%%
% S001:
S001_sit_hSE = cursor_info_S001_sit_34_plusSE.Position(2)-cursor_info_S001_sit_34.Position(2);
S001_treadmill_hSE = cursor_info_S001_treadmill_34_plusSE.Position(2)-cursor_info_S001_treadmill_34.Position(2);
S001_stand_hSE = cursor_info_S001_stand_34_plusSE.Position(2)-cursor_info_S001_stand_34.Position(2);
% S002
S002_sit_hSE = cursor_info_S002_sit_60_plusSE.Position(2)-cursor_info_S002_sit_60.Position(2);
S002_stand_hSE = 0;
S002_treadmill_hSE = 0;
% S003
S003_sit_hSE = cursor_info_S003_sit_63_plusSE.Position(2)-cursor_info_S003_sit_63.Position(2);
S003_treadmill_hSE = cursor_info_S003_treadmill_63_plusSE.Position(2)-cursor_info_S003_treadmill_63.Position(2);
S003_stand_hSE = cursor_info_S003_stand_63_plusSE.Position(2)-cursor_info_S003_stand_63.Position(2);
% S004
S004_sit_hSE = cursor_info_S004_sit_64_plusSE.Position(2)-cursor_info_S004_sit_64.Position(2);
S004_stand_hSE = cursor_info_S004_stand_64_plusSE.Position(2)-cursor_info_S004_stand_64.Position(2);
S004_treadmill_hSE = 0;
% S005
S005_sit_hSE = cursor_info_S005_sit_57_plusSE.Position(2)-cursor_info_S005_sit_57.Position(2);
S005_stand_hSE = cursor_info_S005_stand_57_plusSE.Position(2)-cursor_info_S005_stand_57.Position(2);
S005_treadmill_hSE = cursor_info_S005_treadmill_57_plusSE.Position(2)-cursor_info_S005_treadmill_57.Position(2);
errhigh = [S001_sit_hSE S001_treadmill_hSE S001_stand_hSE 0 S002_sit_hSE S002_stand_hSE S002_treadmill_hSE 0 S003_sit_hSE S003_treadmill_hSE S003_stand_hSE 0 S004_sit_hSE S004_stand_hSE S004_treadmill_hSE 0 S005_sit_hSE S005_stand_hSE S005_treadmill_hSE];


%%
% S001:
S001_sit_lSE = -cursor_info_S001_sit_34_minusSE.Position(2)+cursor_info_S001_sit_34.Position(2);
S001_treadmill_lSE = -cursor_info_S001_treadmill_34_minusSE.Position(2)+cursor_info_S001_treadmill_34.Position(2);
S001_stand_lSE = -cursor_info_S001_stand_34_minusSE.Position(2)+cursor_info_S001_stand_34.Position(2);
% S002
S002_sit_lSE = -cursor_info_S002_sit_60_minusSE.Position(2)+cursor_info_S002_sit_60.Position(2);
S002_stand_lSE = 0;
S002_treadmill_lSE = 0;
% S003
S003_sit_lSE = -cursor_info_S003_sit_63_minusSE.Position(2)+cursor_info_S003_sit_63.Position(2);
S003_treadmill_lSE = -cursor_info_S003_treadmill_63_minusSE.Position(2)+cursor_info_S003_treadmill_63.Position(2);
S003_stand_lSE = -cursor_info_S003_stand_63_minusSE.Position(2)+cursor_info_S003_stand_63.Position(2);
% S004
S004_sit_lSE = -cursor_info_S004_sit_64_minusSE.Position(2)+cursor_info_S004_sit_64.Position(2);
S004_stand_lSE = -cursor_info_S004_stand_64_minusSE.Position(2)+cursor_info_S004_stand_64.Position(2);
S004_treadmill_lSE = 0;
% S005
S005_sit_lSE = -cursor_info_S005_sit_57_minusSE.Position(2)+cursor_info_S005_sit_57.Position(2);
S005_stand_lSE = -cursor_info_S005_stand_57_minusSE.Position(2)+cursor_info_S005_stand_57.Position(2);
S005_treadmill_lSE = -cursor_info_S005_treadmill_57_minusSE.Position(2)+cursor_info_S005_treadmill_57.Position(2);
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
set(gca, 'XTick', 1:numel(y), 'XTickLabel', {'C1', 'C2', 'C3','  '},'FontSize',12)
er = errorbar(x,y,errlow,errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none'; 
grid minor
hLg=legend(['Sit  ';'Walk ';'Stand'], ...
           'orientation','horizontal', ...
           'location','north'); legend('boxoff') % add legend
hLg.FontSize = 14;
title('Average P3 at Pz','FontSize',16)
ylabel('Potential (uV)','FontSize',16)
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