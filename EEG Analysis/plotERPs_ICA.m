% close

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
time = table2array(S005sitfiltab2allTrials57Target(:,1));
Pz_Stand = table2array(S005standfiltab2allTrials57Target(:,2));
Pz_Tread = table2array(S005treadmillfiltab2allTrialstrials57firstTarget(:,2));
Pz_Sit = table2array(S005sitfiltab2allTrials57Target(:,2));
%%
time = table2array(erpsetMaggieWalkTTHighArduinoRecording10min1sISIv2manualFixRfil(:,1));
Pz_Walk_NT = table2array(erpsetMaggieWalkTTHighArduinoRecording10min1sISIv2manualFixRfil(:,2));
Pz_Walk_T = table2array(erpsetMaggieWalkTTHighArduinoRecording10min1sISIv2manualFixRfil(:,2));
% ERPfilename = [erpsetMaggieSitTTHighArduinoRecording10min1sISIpostWalkmanualFi erpsetMaggieTreadmillTTHighArduinoRecording10min1sISIpostWalkSi erpsetMaggieWalkTTHighArduinoRecording10min1sISIv2manualFixRfil]
% ERPset(i) = importERP(ERPfilename(i), startRow, endRow)
%%
% TTHigh
figure()
sit = plot(time,Pz_Sit,'-','LineWidth',1.5)
hold on
lgw = plot(time,Pz_Stand,'-','LineWidth',1.5)
hold on
treadmill = plot(time,Pz_Tread,'-','LineWidth',1.5)
line([0 0], [-15 15]);
line([-200 800], [0 0]);
legend('Sit', 'Stand', 'Walk (Treadmill)');
grid minor
title('Averaged ERP at Pz')
xlabel('Time relative to stimuli (ms)')
ylabel('Potential (uV)')
xlim([-200 800])
hold off

%% bar graphs
x = 1:15;
y1 = [cursor_info_S001_sit_ICA_18.Position(2) cursor_info_S001_treadmill_ICA_18.Position(2) cursor_info_S001_stand_ICA_18.Position(2)];
y2 = [cursor_info_S002_sit_ICA_65.Position(2) cursor_info_S002_stand_ICA_65.Position(2) 0];
y3 = [cursor_info_S003_sit_ICA_63.Position(2) cursor_info_S003_treadmill_ICA_63.Position(2) cursor_info_S003_stand_ICA_63.Position(2)];
y4 = [cursor_info_S004_sit_ICA_63.Position(2) cursor_info_S004_stand_ICA_63.Position(2) 0];
y5 = [cursor_info_S005_sit_ICA_81.Position(2) cursor_info_S005_stand_ICA_81.Position(2) cursor_info_S005_treadmill_ICA_81.Position(2)];
y = [y1 y2 y3 y4 y5];

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

%errhigh = [S001_sit_hSE;S001_treadmill_hSE;S001_stand_hSE;S002_sit_hSE;S002_stand_hSE;S002_treadmill_hSE;S003_sit_hSE;S003_treadmill_hSE;S003_stand_hSE;S004_sit_hSE;S004_stand_hSE;S004_treadmill_hSE;S005_sit_hSE;S005_stand_hSE;S005_treadmill_hSE];
errhigh = [S001_hSE S002_hSE S003_hSE S004_hSE S005_hSE];

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

% errlow = [S001_sit_lSE;S001_treadmill_lSE;S001_stand_lSE;S002_sit_lSE;S002_stand_lSE;S002_treadmill_lSE;S003_sit_lSE;S003_treadmill_lSE;S003_stand_lSE;S004_sit_lSE;S004_stand_lSE;S004_treadmill_lSE;S005_sit_lSE;S005_stand_lSE;S005_treadmill_lSE];
errlow = [S001_lSE S002_lSE S003_lSE S004_lSE S005_lSE];
    
figure()
bar(y)
grid minor
title('Average P3 at Pz')
ylabel('Potential (uV)')
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
ylabel('Potential (uV)')
xlim([-200 800])

figure()
lgw = plot(time,Pz_Stand,'-','LineWidth',2)
line([0 0], [-8 12]);
legend('Stand');
grid minor
title('Averaged ERP at Pz')
xlabel('Time relative to stimuli (ms)')
ylabel('Potential (uV)')
xlim([-200 800])

figure()
treadmill = plot(time,Pz_Tread,'-','LineWidth',2)
line([0 0], [-8 12]);
legend('Walk (Treadmill)');
grid minor
title('Averaged ERP at Pz')
xlabel('Time relative to stimuli (ms)')
ylabel('Potential (uV)')
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
ylabel('Potential (uV)')
xlim([-200 800])
