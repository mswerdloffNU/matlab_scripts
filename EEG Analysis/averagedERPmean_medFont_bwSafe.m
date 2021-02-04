function averagedERPmean_medFont_bwSafe(X1, YMatrix1, XData1, YData1, XData2, YData2, XData3, YData3, YData4)
%CREATEFIGURE(X1, YMATRIX1, XDATA1, YDATA1, XDATA2, YDATA2, XDATA3, YDATA3, YDATA4)
%  X1:  vector of x data
%  YMATRIX1:  matrix of y data
%  XDATA1:  line xdata
%  YDATA1:  line ydata
%  XDATA2:  line xdata
%  YDATA2:  patch ydata
%  XDATA3:  patch xdata
%  YDATA3:  patch ydata
%  YDATA4:  patch ydata

%  Auto-generated by MATLAB on 17-Jan-2020 10:25:33

% Create figure
figure1 = figure;

% Create axes
axes1 = axes('Parent',figure1,'ZMinorGrid','on','LineWidth',2,...
    'YTick',[-10 -5 0 5 10],...
    'XTick',[0 300 600],...
    'GridColor',[0 0 0],...
    'FontSize',25,...
    'FontName','Times New Roman',...
    'Position',[0.13 0.219148936170213 0.865535714285714 0.705851063829786]);
%% Uncomment the following line to preserve the Y-limits of the axes
% ylim(axes1,[-10 10]);
box(axes1,'on');
hold(axes1,'on');

% Create multiple lines using matrix input to plot
plot1 = plot(X1,YMatrix1,'LineWidth',2,'Parent',axes1);
set(plot1(1),'DisplayName','Sit','LineStyle','--',...
    'Color',[0.152941176470588 0.227450980392157 0.372549019607843]);
set(plot1(2),'DisplayName','Stand',...
    'Color',[0.250980392156863 0.584313725490196 0.419607843137255]);
set(plot1(3),'DisplayName','Walk','LineStyle','-.','Color',[1 0 0]);

% Create line
line(XData1,YData1,'Parent',axes1,'LineWidth',2,'LineStyle','--');

% Create line
line(XData2,XData1,'Parent',axes1,'LineWidth',2,'LineStyle','--');

% Create patch
patch('Parent',axes1,'YData',YData2,'XData',XData3,'FaceAlpha',0.4,...
    'FaceColor',[0.5 0.5 1],...
    'EdgeColor','none');

% Create patch
patch('Parent',axes1,'YData',YData3,'XData',XData3,'FaceAlpha',0.4,...
    'FaceColor',[0.5 1 0.5],...
    'EdgeColor','none');

% Create patch
patch('Parent',axes1,'YData',YData4,'XData',XData3,'FaceAlpha',0.4,...
    'FaceColor',[1 0.5 0.5],...
    'EdgeColor','none');

% Create xlabel
xlabel('Time relative to stimuli (ms)','FontSize',25,...
    'FontName','Times New Roman');

% Create ylabel
ylabel('Potential (�V)','FontSize',25,'FontName','Times New Roman');

% Create title
title({''},'FontSize',11);

% Create legend
legend1 = legend(axes1,'show');
set(legend1,'Orientation','horizontal','Location','south');

