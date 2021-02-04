%% bar graph separated
%S006
x = 1:11;
y1 = [walk_A.Position(2) sit_A.Position(2) stand_A.Position(2) 0];
y2 = [sit_B.Position(2) stand_B.Position(2) walk_B.Position(2) 0];
y3 = [stand_C.Position(2) walk_C.Position(2) sit_C.Position(2)];
y = [y1 y2 y3]';

A_hSE = [walk_A_high.Position(2) sit_A_high.Position(2) stand_A_high.Position(2) 0];
B_hSE = [sit_B_high.Position(2) stand_B_high.Position(2) walk_B_high.Position(2) 0];
C_hSE = [stand_C_high.Position(2) walk_C_high.Position(2) sit_C_high.Position(2)];

A_lSE = [walk_A_low.Position(2) sit_A_low.Position(2) stand_A_low.Position(2) 0];
B_lSE = [sit_B_low.Position(2) stand_B_low.Position(2) walk_B_low.Position(2) 0];
C_lSE = [stand_C_low.Position(2) walk_C_low.Position(2) sit_C_low.Position(2)];

errhigh = [A_hSE B_hSE C_hSE]-y';
errlow = [A_lSE B_lSE C_lSE]-y';

%%
%S003
x = 1:11;

sit_C.Position(2) = (sit_C_p3.Position(2)+sit_C_p4.Position(2))/2;
sit_C_high.Position(2) = (sit_C_p3_high.Position(2)+sit_C_p4_high.Position(2))/2;
sit_C_low.Position(2) = (sit_C_p3_low.Position(2)+sit_C_p4_low.Position(2))/2;

walk_B.Position(2) = (walk_B_p3.Position(2)+walk_B_p4.Position(2))/2;
walk_B_high.Position(2) = (walk_B_p3_high.Position(2)+walk_B_p4_high.Position(2))/2;
walk_B_low.Position(2) = (walk_B_p3_low.Position(2)+walk_B_p4_low.Position(2))/2;

walk_C.Position(2) = (walk_C_p3.Position(2)+walk_C_p4.Position(2))/2;
walk_C_high.Position(2) = (walk_C_p3_high.Position(2)+walk_C_p4_high.Position(2))/2;
walk_C_low.Position(2) = (walk_C_p3_low.Position(2)+walk_C_p4_low.Position(2))/2;

A_hSE = [sit_A_high.Position(2) walk_A_high.Position(2) stand_A_high.Position(2) 0];
B_hSE = [walk_B_high.Position(2) sit_B_high.Position(2) stand_B_high.Position(2) 0];
C_hSE = [stand_C_high.Position(2) walk_C_high.Position(2) sit_C_high.Position(2)];

A_lSE = [sit_A_low.Position(2) walk_A_low.Position(2) stand_A_low.Position(2) 0];
B_lSE = [walk_B_low.Position(2) sit_B_low.Position(2) stand_B_low.Position(2) 0];
C_lSE = [stand_C_low.Position(2) walk_C_low.Position(2) sit_C_low.Position(2)];

errhigh = [A_hSE B_hSE C_hSE]-y';
errlow = [A_lSE B_lSE C_lSE]-y';

%%
y1 = [sit_A.Position(2) sit_B.Position(2) sit_C.Position(2) 0];
y2 = [stand_A.Position(2) stand_B.Position(2) stand_C.Position(2) 0];
y3 = [walk_A.Position(2) walk_B.Position(2) walk_C.Position(2)];
y = [y1 y2 y3]';

A_hSE = [sit_A_high.Position(2) sit_B_high.Position(2) sit_C_high.Position(2) 0];
B_hSE = [stand_A_high.Position(2) stand_B_high.Position(2) stand_C_high.Position(2) 0];
C_hSE = [walk_A_high.Position(2) walk_B_high.Position(2) walk_C_high.Position(2)];

A_lSE = [sit_A_low.Position(2) sit_B_low.Position(2) sit_C_low.Position(2) 0];
B_lSE = [stand_A_low.Position(2) stand_B_low.Position(2) stand_C_low.Position(2) 0];
C_lSE = [walk_A_low.Position(2) walk_B_low.Position(2) walk_C_low.Position(2)];
%%
fHand = figure;
aHand = axes('parent', fHand);
hold(aHand, 'on')
%colors = hsv(numel(y));
colors = [0 0.4470 0.7410; 0 0.4470 0.7410; 0 0.4470 0.7410; 0 0 0;... %S001
    0.8500 0.3250 0.0980; 0.8500 0.3250 0.0980; 0.8500 0.3250 0.0980; 0 0 0;... %S002
    0.9290 0.6940 0.1250; 0.9290 0.6940 0.1250; 0.9290 0.6940 0.1250]; %S003
for i = 1:numel(y)
    bar(i, y(i), 'parent', aHand, 'facecolor', colors(i,:));
end
set(gca, 'XTick', 1:numel(y), 'XTickLabel', {'   ', '   ', '   ','  '},'FontSize',12)
er = errorbar(x,y,errlow,errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none'; 
grid minor
hLg.FontSize = 26;
title('Average P3 at Pz','FontSize',32)
ylabel('Potential (?V)','FontSize',32)

%%
avg_sit = mean([y1(1),y1(2),y1(3)]);
avg_walk = mean([y2(1),y2(2),y3(3)]);
avg_stand = mean([y3(1),y3(2),y3(3)]);

%% bar graph combined
% S006
x = 1:11;
y1 = [walk_A.Position(2) sit_A.Position(2) stand_A.Position(2) 0];
y2 = [sit_B.Position(2) stand_B.Position(2) walk_B.Position(2) 0];
y3 = [stand_C.Position(2) walk_C.Position(2) sit_C.Position(2)];
y = [y1 y2 y3]';

%S003
x = 1:11;
y1 = [sit_A.Position(2) walk_A.Position(2) stand_A.Position(2) 0];
y2 = [walk_B.Position(2) sit_B.Position(2) stand_B.Position(2) 0];
y3 = [stand_C.Position(2) walk_C.Position(2) sit_C.Position(2)];
y = [y1 y2 y3]';

%%
fHand = figure;
aHand = axes('parent', fHand);
hold(aHand, 'on')
%colors = hsv(numel(y));
colors = [0.9290 0.6940 0.1250; 0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0 0 0;... %S001
    0 0.4470 0.7410; 0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250; 0 0 0;... %S002
    0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250; 0 0.4470 0.7410]; %S003
for i = 1:numel(y)
    bar(i, y(i), 'parent', aHand, 'facecolor', colors(i,:));
end
set(gca, 'XTick', 1:numel(y), 'XTickLabel', {'   ', '   ', '   ','  '},'FontSize',12)
er = errorbar(x,y,errlow,errhigh);    
er.Color = [0 0 0];                            
er.LineStyle = 'none'; 
grid minor
% S005 and S006
% hLg=legend(['Walk ';'Sit  ';'Stand'], ...
%            'orientation','horizontal', ...
%            'location','north'); legend('boxoff') % add legend
% S003
hLg=legend(['Sit  ';'Walk ';'Stand'], ...
           'orientation','horizontal', ...
           'location','north'); legend('boxoff') % add legend
hLg.FontSize = 26;
title('Average P3 at Pz','FontSize',32)
ylabel('Potential (uV)','FontSize',32)