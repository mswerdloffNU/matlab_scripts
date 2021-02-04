figure()
% sit = plot(time,Pz_Sit,'-','LineWidth',1.5)
hold on
% sit_SEM_plus = plot(time,Pz_Sit+Pz_Sit_SEM,'-','LineWidth',1.5)
% hold on
% sit_SEM_minus = plot(time,Pz_Sit-Pz_Sit_SEM,'-','LineWidth',1.5)
% hold on
% sit_SEM_plus = area(time,sit_SEM_p)
% hold on
% sit_SEM_minus = area(time,sit_SEM_m)
% hold on
fill([time(1:1:300);time(300:-1:1)], [sit_SEM_m(1:1:300);sit_SEM_p(300:-1:1)], 'g');
% lgw = plot(time,Pz_Stand,'-','LineWidth',1.5)
% hold on
% treadmill = plot(time,Pz_Tread,'-','LineWidth',1.5)
% line([0 0], [-15 15]);
% line([-200 800], [0 0]);
%legend('Sit', 'Stand', 'Walk (Treadmill)');
grid minor
title('Averaged ERP at Pz')
xlabel('Time relative to stimuli (ms)')
ylabel('Potential (µV)')
xlim([-200 800])
hold off