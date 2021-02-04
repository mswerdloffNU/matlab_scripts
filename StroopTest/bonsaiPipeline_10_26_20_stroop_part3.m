%%
clearvars
close all
subs = {'Maggie'};
% subs = {'S015','S016','S017','S018','Maggie_day1'};
PLOT = 0;
%%
filePath='Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\Pilot2\Maggie';
cd(filePath)
Files_v5 = dir('*pt1*_ICA_Num_*'); % choose 1, 2, or 4 for the order of the butterworth filter
Files_v6 = dir('*pt2*_ICA_Num_*'); % choose 1, 2, or 4 for the order of the butterworth filter
Files_all = [Files_v5;Files_v6];
%%
for f = 1:1%2
    if f == 1
        Files=Files_all;
        setName = 'stroop_pt1'; %'stroop_v5_S015678M1_AR_eq';
    elseif f == 2
        Files=Files_v6;
        setName = 'stroop_pt2'; %'stroop_v6_hard_S015678M1_AR_eq';
    end
    setName_all= 'stroop_all'; %'stroop_v5_v6_S015678M1_AR_eq';
    for ii = 1:8:(8*numel(subs))
        filename=Files(ii).name % file to be converted
%         if strfind(filename, 'S015')
%             for k=1:8
%                 Files(k).sub = 'S015';
%             end
%         elseif strfind(filename, 'S016')
%             for k=1:8
%                 Files(k+8).sub = 'S016';
%             end
%         elseif strfind(filename, 'S017')
%             for k=1:8
%                 Files(k+16).sub = 'S017';
%             end
%         elseif strfind(filename,'S018')
%             for k=1:8
%                 Files(k+24).sub = 'S018';
%             end
%         elseif strfind(filename,'Maggie_day1')
%             for k=1:8
%                 Files(k+32).sub = 'Maggie_day1';
%             end
        if strfind(filename,'Maggie')
            for k=1:16
                Files(k).sub = 'Maggie';
            end
        end
    end

%%  
for kk = 1:numel(Files)
    Files(kk).code=0;
    if    isempty(strfind(Files(kk).name,'Pre-Stroop Onset.txt'))==0
        Files(kk).code=1;
    elseif isempty(strfind(Files(kk).name,'At Stroop Onset .txt'))==0
        Files(kk).code=2;
    elseif isempty(strfind(Files(kk).name,'After Stroop Onset.txt'))==0
        Files(kk).code=3;
    elseif isempty(strfind(Files(kk).name,'After Stroop Onset x 2.txt'))==0
        Files(kk).code=4;
    elseif isempty(strfind(Files(kk).name,'Non-Target Non-Stroop .txt'))==0
        Files(kk).code=5;
    elseif isempty(strfind(Files(kk).name,'Non-Target Stroop .txt'))==0
        Files(kk).code=6;
    elseif isempty(strfind(Files(kk).name,'Target Non-Stroop .txt'))==0
        Files(kk).code=7;
    elseif isempty(strfind(Files(kk).name,'Stroop Congruent.txt'))==0
        Files(kk).code=8;
    end
end

    T = struct2table(Files); % convert the struct array to a table
    aa_t = sortrows(T, {'sub', 'code'}); % sort the table by session
    T_sorted = struct(aa_t);
    
    clear stroop_noAR stroop_noAR_pz
    for ii = 1:(8*numel(subs))
%         stroop_noAR = importTarget(Files(ii).name);
        stroop_noAR = importTarget(T_sorted.data{1,1}{ii,1});
        stroop_noAR_pz(:,ii) = table2array(stroop_noAR(2,2:end))';
    end
%     stroop_noAR_pz(:,8)=NaN;
    
    time = table2array(stroop_noAR(1,2:end))';
    x2 = [time, fliplr(time)];
    
    
    %% plot grand averages
    n = numel(subs); % number of subjects
    if f==1
        v5_all = stroop_noAR_pz;
    elseif f==2
        v6_all=stroop_noAR_pz;
    end
    %%
%     clear v5_grandAvg_idvtone v5_grandAvg_sum
    for kk = 1:8
        % for ii = kk:8:(8*numel(subs))
        if f == 1
        v5_grandAvg_idvtone = v5_all(:,kk:8:end);
        elseif f == 2
        v6_grandAvg_idvtone = v6_all(:,kk:8:end);
        end
        % end
        n_adj=n;
%         if kk == 8
%             n_adj = n-1;
%         else
%             n_adj = n;
%         end
        if f == 1
        v5_grandAvg_sum(kk,:) = (nansum(v5_grandAvg_idvtone'))/n_adj;
        elseif f == 2
        v6_grandAvg_sum(kk,:) = (nansum(v6_grandAvg_idvtone'))/n_adj;
        end
    end
end
%% PLOT
PLOT = 1;
if PLOT == 1
for f=1:1%2
%     h(1*f)=figure;
%     for kk = 1:8
%         for ii = kk:8:(8*numel(subs))
%             subplot(2,4,kk)
%             hold on
%             if f==1
%                 plot(time,v5_all(:,ii),'LineWidth',1)
%             elseif f==2
%                 plot(time,v6_all(:,ii),'LineWidth',1)
%             end
% %             line([0 0], [-15 15]);
% %             line([-200 800], [0 0]);
%             grid minor
%             xlabel('Time relative to stimuli (ms)')
%             ylabel('Potential (µV)')
% %             xlim([-200 800])
%             if kk == 1
%                 title('Pre-Stroop Onset')
%             elseif kk == 2
%                 title('At Stroop Onset')
%             elseif kk == 3
%                 title('After Stroop Onset')
%             elseif kk == 4
%                 title('After Stroop Onset x 2')
%             elseif kk == 5
%                 title('Audio Non-Target')
%             elseif kk == 6
%                 title('Non-Target Stroop')
%             elseif kk == 7
%                 title('Audio Target')
%             elseif kk == 8
%                 title('Stroop Congruent')
%             end
%         end
%         if f==1
%             plot(time,v5_grandAvg_sum(kk,:),'LineWidth',4)
%         elseif f==2
%             plot(time,v6_grandAvg_sum(kk,:),'LineWidth',4)
%         end
%     end
    %
%     h(2+f)=figure;
	figure
    for kk = 1:8
        for ii = kk:8:(8*numel(subs))
            subplot(2,4,kk)
            hold on
            if f == 1
            plot(time,v5_all(:,ii),'LineWidth',1)
            elseif f == 2
            plot(time,v6_all(:,ii),'LineWidth',1)
            end
            line([0 0], [-30 30]);
            line([-200 800], [0 0]);
            grid minor
            xlabel('Time relative to stimuli (ms)')
            ylabel('Potential (µV)')
            xlim([-200 800])
            ylim([-30 30])
            if kk == 1
                title('Pre-Stroop Onset HARD')
            elseif kk == 2
                title('At Stroop Onset HARD')
            elseif kk == 3
                title('After Stroop Onset HARD')
            elseif kk == 4
                title('After Stroop Onset x 2 HARD')
            elseif kk == 5
                title('Pre-Stroop Onset EASY')
            elseif kk == 6
                title('At Stroop Onset EASY')
            elseif kk == 7
                title('After Stroop Onset EASY')
            elseif kk == 8
                title('After Stroop Onset x 2 EASY')
            end
        end
        if f == 1
            plot(time,v5_grandAvg_sum(kk,:),'LineWidth',4)
        elseif f == 2
            plot(time,v6_grandAvg_sum(kk,:),'LineWidth',4)
        end
    end
    fnm = sprintf('erp_%s.fig',setName_all);
    cd(filePath)
%     savefig(h,fnm)
end
end
PLOT = 0;
%% Comparison 1 PLOT
PLOT = 1;
if PLOT == 1
    colors = [0 0.447 .741;.85 .325 .098;.929 .694 .125;.494 .184 .556];
    figure
    for kk = 1:4
        
        subplot(1,4,kk)
        
        for ii = kk:8:(8*numel(subs))
            %         disp(ii)
            %         disp(v5_all(1:5,ii))
            hold on
            plot(time,v5_all(:,ii),'r-') %hard
            line([0 0], [-30 30]);
            line([-200 800], [0 0]);
            grid minor
            xlabel('Time relative to stimuli (ms)')
            ylabel('Potential (µV)')
            xlim([-200 800])
            ylim([-30 30])
            if kk == 1
                title('Pre-Stroop Onset')
            elseif kk == 2
                title('At Stroop Onset')
            elseif kk == 3
                title('After Stroop Onset')
            elseif kk == 4
                title('After Stroop Onset x 2')
            end
            %     legend('Easy','Hard','Easy-Hard')
        end
        
        plot(time,v5_grandAvg_sum(kk,:),'LineWidth',4)
        
        kk = kk+4;
        % subplot(1,3,2)
        for ii = kk:8:(8*numel(subs))
            hold on
            plot(time,v5_all(:,ii),'b-') %easy
            vDiff = v5_all(:,ii)-v5_all(:,ii-4); %easy-hard
            plot(time,vDiff,'LineWidth',2,'LineStyle','-','Color',colors(kk-4,:))
            line([0 0], [-30 30]);
            line([-200 800], [0 0]);
            grid minor
            xlabel('Time relative to stimuli (ms)')
            ylabel('Potential (µV)')
            xlim([-200 800])
            ylim([-30 30])
        end
        
        % vDiff = v5_all(:,ii-4)-v5_all(:,ii);
        % plot(time,vDiff,'LineWidth',2)
        
        
        % plot(time,v5_grandAvg_sum(kk,:),'LineWidth',4)
        % %
        % kk = kk - 4;
        % subplot(1,3,3)
        % plot(time,v5_grandAvg_sum(kk,:),'LineWidth',4)
        % hold on
        % kk = kk + 4;
        % plot(time,v5_grandAvg_sum(kk,:),'LineWidth',4)
        % line([0 0], [-15 15]);
        % line([-200 800], [0 0]);
        % grid minor
        % xlabel('Time relative to stimuli (ms)')
        % ylabel('Potential (µV)')
        % xlim([-200 800])
        % ylim([-30 30])
        % title('Audio Target')
        % legend('Easy','Hard')
        % fnm = sprintf('erp_Comp1_%s.fig',setName_all);
        % cd(filePath)
        % % savefig(fnm)
    end
end
PLOT = 0;
%% Comparison 2
if PLOT == 1
figure
subplot(1,3,1)
for kk = 2
    for ii = kk:8:(8*numel(subs))
%         disp(ii)
%         disp(v5_all(1:5,ii))       
        hold on
        plot(time,v5_all(:,ii),'LineWidth',1)
        line([0 0], [-30 30]);
        line([-200 800], [0 0]);
        grid minor
        xlabel('Time relative to stimuli (ms)')
        ylabel('Potential (µV)')
        xlim([-200 800])
        title('At Stroop Target - Easy')
    end
end
plot(time,v5_grandAvg_sum(kk,:),'LineWidth',4)
subplot(1,3,2)
for kk = 2
    for ii = kk:8:(8*numel(subs))
        hold on
        plot(time,v5_all(:,ii),'LineWidth',1)
        line([0 0], [-30 30]);
        line([-200 800], [0 0]);
        grid minor
        xlabel('Time relative to stimuli (ms)')
        ylabel('Potential (µV)')
        xlim([-200 800])
        title('At Stroop Target - Hard')
    end
end
plot(time,v5_grandAvg_sum(kk,:),'LineWidth',4)
%
subplot(1,3,3)
plot(time,v5_grandAvg_sum(kk,:),'LineWidth',4)
hold on
plot(time,v5_grandAvg_sum(kk,:),'LineWidth',4)
line([0 0], [-30 30]);
line([-200 800], [0 0]);
grid minor
xlabel('Time relative to stimuli (ms)')
ylabel('Potential (µV)')
xlim([-200 800])
title('At Stroop Target')
legend('Easy','Hard')
fnm = sprintf('erp_Comp2_%s.fig',setName_all);
cd(filePath)
% savefig(fnm)
end
%% Compare timing curves PLOT
PLOT = 1;
if PLOT == 1
    figure
    subplot(1,3,1)
    for kk = 5:8
        hold on
        plot(time,v5_all(:,kk),'LineWidth',2)
    end
    line([0 0], [-40 40]);
    line([-200 800], [0 0]);
    xlabel('Time relative to stimuli (ms)')
    ylabel('Potential (µV)')
    title('Level - EASY')
    legend('(1) pre-stroop onset','(2) at stroop onset','(3) post-stroop onset','(4) post-stroop onset x2')
    subplot(1,3,2)
    for kk = 1:4
        hold on
        plot(time,v5_all(:,kk),'LineWidth',2)
    end
    line([0 0], [-40 40]);
    line([-200 800], [0 0]);
    title('Level - HARD')
    xlabel('Time relative to stimuli (ms)')
    ylabel('Potential (µV)')
    legend('(1) pre-stroop onset','(2) at stroop onset','(3) post-stroop onset','(4) post-stroop onset x2')
    subplot(1,3,3)
    for kk = 1:4
        hold on
        plot(time,v5_all(:,kk+4)-v5_all(:,kk),'LineWidth',2)
    end
    line([0 0], [-40 40]);
    line([-200 800], [0 0]);
    title('EASY - HARD')
    xlabel('Time relative to stimuli (ms)')
    ylabel('Potential (µV)')
    legend('(1) pre-stroop onset','(2) at stroop onset','(3) post-stroop onset','(4) post-stroop onset x2')
end
PLOT = 0;
%% plot bargraphs for timing curves
% for each subject
nsub = 2;
sr = 300; % Hz = 1/s
% frame = [490 540]*sr/1000;
frame = [400 700]*sr/1000;
for version = 1:1%2
    clear v_tbl
    if version == 1
        v_tbl = v5_all;
    elseif version == 2
        v_tbl = v6_all;
    end
    for i = 1:nsub
        frame_avg_1(i) = mean(v_tbl(frame(1):frame(2),((i-1)*8)+1));
        frame_avg_2(i) = mean(v_tbl(frame(1):frame(2),((i-1)*8)+2));
        frame_avg_3(i) = mean(v_tbl(frame(1):frame(2),((i-1)*8)+3));
        frame_avg_4(i) = mean(v_tbl(frame(1):frame(2),((i-1)*8)+4));
        frame_avg_5(i) = mean(v_tbl(frame(1):frame(2),((i-1)*8)+5));
        frame_avg_6(i) = mean(v_tbl(frame(1):frame(2),((i-1)*8)+6));
        frame_avg_7(i) = mean(v_tbl(frame(1):frame(2),((i-1)*8)+7));
        frame_avg_8(i) = mean(v_tbl(frame(1):frame(2),((i-1)*8)+8));
    end
    frame_avg_all = [frame_avg_1; frame_avg_2; frame_avg_3; frame_avg_4; frame_avg_5; frame_avg_6; frame_avg_7; frame_avg_8]';
    frame_mean_all = [mean(frame_avg_1) mean(frame_avg_2) mean(frame_avg_3) mean(frame_avg_4) mean(frame_avg_5) mean(frame_avg_6) mean(frame_avg_7) mean(frame_avg_8)];
    frame_sterr_all = [std(frame_avg_1)/sqrt(length(frame_avg_1)) std(frame_avg_2)/sqrt(length(frame_avg_2)) std(frame_avg_3)/sqrt(length(frame_avg_3)) std(frame_avg_4)/sqrt(length(frame_avg_4)) std(frame_avg_5)/sqrt(length(frame_avg_5)) std(frame_avg_6)/sqrt(length(frame_avg_6)) std(frame_avg_7)/sqrt(length(frame_avg_7)) std(frame_avg_8)/sqrt(length(frame_avg_8))];
%     frame_avg_all = [frame_avg_1; frame_avg_2; frame_avg_3; frame_avg_4]';
%     frame_mean_all = [mean(frame_avg_1) mean(frame_avg_2) mean(frame_avg_3) mean(frame_avg_4)];
%     frame_sterr_all = [std(frame_avg_1)/sqrt(length(frame_avg_1)) std(frame_avg_2)/sqrt(length(frame_avg_2)) std(frame_avg_3)/sqrt(length(frame_avg_3)) std(frame_avg_4)/sqrt(length(frame_avg_4))];
    if version == 1
        err_v5 = frame_sterr_all;
        y_v5 = frame_mean_all;
        [p_v5w,h_v5w] = signrank(frame_avg_1, frame_avg_2);
    elseif version == 2
        err_v6 = frame_sterr_all;
        y_v6 = frame_mean_all;
        [p_v6w,h_v6w] = signrank(frame_avg_1, frame_avg_2);
    end

end
%%
cd('Z:\Lab Member folders\Margaret Swerdloff\From Eric')
colors = [0 0.447 .741;.85 .325 .098;.929 .694 .125;.494 .184 .556];
figure
errorbarbar(y_v5,err_v5,axes,colors)
figure
errorbarbar(y_v6,err_v6,axes,colors)
    
%%
%% Easy vs Hard for each time group with all trials plotted
figure
for kk = 1:4 
subplot(4,3,((kk-1)*3)+1)
    for ii = kk:8:(8*numel(subs))
%         disp(ii)
%         disp(v5_all(1:5,ii))       
        hold on
        plot(time,v5_all(:,ii),'LineWidth',1)
        line([0 0], [-40 40]);
        line([-200 800], [0 0]);
        grid minor
%         xlabel('Time relative to stimuli (ms)')
%         ylabel('Potential (µV)')
        xlim([-200 800])
%         title('At Stroop Target - Easy')
    end

plot(time,v5_grandAvg_sum(kk,:),'LineWidth',4)
subplot(4,3,((kk-1)*3)+2)

    for ii = kk:8:(8*numel(subs))
        hold on
        plot(time,v6_all(:,ii),'LineWidth',1)
        line([0 0], [-40 40]);
        line([-200 800], [0 0]);
        grid minor
%         xlabel('Time relative to stimuli (ms)')
%         ylabel('Potential (µV)')
        xlim([-200 800])
%         title('At Stroop Target - Hard')
    end

plot(time,v6_grandAvg_sum(kk,:),'LineWidth',4)
%
subplot(4,3,((kk-1)*3)+3)
plot(time,v5_grandAvg_sum(kk,:),'LineWidth',4)
hold on
plot(time,v6_grandAvg_sum(kk,:),'LineWidth',4)
line([0 0], [-40 40]);
line([-200 800], [0 0]);
grid minor
% xlabel('Time relative to stimuli (ms)')
% ylabel('Potential (µV)')
xlim([-200 800])
% title('At Stroop Target')
legend('Easy','Hard')
fnm = sprintf('erp_Comp3_%s.fig',setName_all);
cd(filePath)
% savefig(fnm)

end
xlabel('Time relative to stimuli (ms)')
ylabel('Potential (µV)')

%% Easy vs Hard for each time group 
figure
for kk = 1:4
    subplot(1,4,kk)
    plot(time,v5_grandAvg_sum(kk,:),'LineWidth',4)
    hold on
    plot(time,v6_grandAvg_sum(kk,:),'LineWidth',4)
    line([0 0], [-10 20]);
    line([-200 800], [0 0]);
    xlabel('Time relative to stimuli (ms)')
    ylabel('Potential (µV)')
    xlim([-200 800])
    if kk == 1
        title('Pre-Stroop Onset')
    elseif kk == 2
        title('At Stroop Onset')
    elseif kk == 3
        title('After Stroop Onset')
    elseif kk == 4
        title('After Stroop Onset x 2')
    end
    legend('Easy','Hard')
    fnm = sprintf('erp_Comp3_%s.fig',setName_all);
    cd(filePath)
    % savefig(fnm)
end

%%
cd('Z:\Lab Member folders\Margaret Swerdloff\From Eric')
colors = [0 0.447 .741;    .85 .325 .098];
figure
errorbarbar([y_v5; y_v6]',[err_v5; err_v6]',axes,[colors])
ylabel('Mean P3 Potential (µV)')
%
%% plot bargraphs for timing curves minusStroop
% for each subject
nsub = 4;
sr = 300; % Hz = 1/s
% frame = [490 540]*sr/1000;
frame = [400 700]*sr/1000;
for version = 1:2
    clear v_tbl
    if version == 1
%         v_tbl = v5_all;
        v_tbl = bsxfun(@minus, v5_all, v5_grandAvg_sum(8,:)');
    elseif version == 2
%         v_tbl = v6_all;
        v_tbl = bsxfun(@minus, v6_all, v6_grandAvg_sum(8,:)');
    end
    for i = 1:nsub
        frame_avg_1(i) = mean(v_tbl(frame(1):frame(2),((i-1)*8)+1));
        frame_avg_2(i) = mean(v_tbl(frame(1):frame(2),((i-1)*8)+2));
        frame_avg_3(i) = mean(v_tbl(frame(1):frame(2),((i-1)*8)+3));
        frame_avg_4(i) = mean(v_tbl(frame(1):frame(2),((i-1)*8)+4));
        frame_avg_5(i) = mean(v_tbl(frame(1):frame(2),((i-1)*8)+5));
        frame_avg_6(i) = mean(v_tbl(frame(1):frame(2),((i-1)*8)+6));
        frame_avg_7(i) = mean(v_tbl(frame(1):frame(2),((i-1)*8)+7));
        frame_avg_8(i) = mean(v_tbl(frame(1):frame(2),((i-1)*8)+8));
    end
    frame_avg_all = [frame_avg_1; frame_avg_2; frame_avg_3; frame_avg_4; frame_avg_5; frame_avg_6; frame_avg_7; frame_avg_8]';
    frame_mean_all = [mean(frame_avg_1) mean(frame_avg_2) mean(frame_avg_3) mean(frame_avg_4) mean(frame_avg_5) mean(frame_avg_6) mean(frame_avg_7) mean(frame_avg_8)];
    frame_sterr_all = [std(frame_avg_1)/sqrt(length(frame_avg_1)) std(frame_avg_2)/sqrt(length(frame_avg_2)) std(frame_avg_3)/sqrt(length(frame_avg_3)) std(frame_avg_4)/sqrt(length(frame_avg_4)) std(frame_avg_5)/sqrt(length(frame_avg_5)) std(frame_avg_6)/sqrt(length(frame_avg_6)) std(frame_avg_7)/sqrt(length(frame_avg_7)) std(frame_avg_8)/sqrt(length(frame_avg_8))];
    %     frame_avg_all = [frame_avg_1; frame_avg_2; frame_avg_3; frame_avg_4]';
    %     frame_mean_all = [mean(frame_avg_1) mean(frame_avg_2) mean(frame_avg_3) mean(frame_avg_4)];
    %     frame_sterr_all = [std(frame_avg_1)/sqrt(length(frame_avg_1)) std(frame_avg_2)/sqrt(length(frame_avg_2)) std(frame_avg_3)/sqrt(length(frame_avg_3)) std(frame_avg_4)/sqrt(length(frame_avg_4))];
    if version == 1
        err_v5_minusStroop = frame_sterr_all;
        y_v5_minusStroop = frame_mean_all;
        [p_v5w_minusStroop,h_v5w_minusStroop] = signrank(frame_avg_1, frame_avg_2);
    elseif version == 2
        err_v6_minusStroop = frame_sterr_all;
        y_v6_minusStroop = frame_mean_all;
        [p_v6w_minusStroop,h_v6w_minusStroop] = signrank(frame_avg_1, frame_avg_2);
    end

end
%%
cd('Z:\Lab Member folders\Margaret Swerdloff\From Eric')
colors = [0 0.447 .741;    .85 .325 .098];
figure
% errorbarbar([y_v5_minusStroop(2); y_v6_minusStroop(2)]',[err_v5_minusStroop(2); err_v6_minusStroop(2)]',axes,[colors])
errorbarbar([y_v5(7); y_v6(7)]',[err_v5(7); err_v6(7)]',axes,[colors])
ylabel('Mean P3 Potential (µV)')
%%

    for kk = 1:8
        % for ii = kk:8:(8*numel(subs))
        
        v_diff_grandAvg_idvtone = v5_all(:,kk:8:end)-v6_all(:,kk:8:end);
        
        % end
        if kk == 8
            n_adj = n-1;
        else
            n_adj = n;
        end
        
        v_diff_grandAvg_sum(kk,:) = (nansum(v_diff_grandAvg_idvtone'))/n_adj;
        
    end

%% Easy vs Hard for each time group 
figure
for kk = 1:4
    subplot(1,4,kk)
    plot(time,v5_grandAvg_sum(kk,:),'Color',colors(1,:),'LineWidth',1)
    hold on
    plot(time,v6_grandAvg_sum(kk,:),'Color',colors(2,:),'LineWidth',1)
    
    plot(time,v_diff_grandAvg_sum(kk,:),'Color',colors(kk,:),'LineWidth',3)
    
    line([0 0], [-10 20]);
    line([-200 800], [0 0]);
    xlabel('Time relative to stimuli (ms)')
    ylabel('Potential (µV)')
    xlim([-200 800])
    if kk == 1
        title('Pre-Stroop Onset')
    elseif kk == 2
        title('At Stroop Onset')
    elseif kk == 3
        title('After Stroop Onset')
    elseif kk == 4
        title('After Stroop Onset x 2')
    end
    legend('Easy','Hard','Easy-Hard')
   
end
fnm = sprintf('erp_diff.fig');
cd('Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\Pilot2\ERP_plots');
    savefig(fnm)
%% plot bargraphs for timing curves minusStroop
% for each subject
nsub = 4;
sr = 300; % Hz = 1/s
% frame = [490 540]*sr/1000;
frame = [400 700]*sr/1000;

    clear v_tbl frame_avg_all frame_mean_all frame_sterr_all 
        v_tbl = v5_all-v6_all;
    for i = 1:nsub
        frame_avg_1(i) = mean(v_tbl(frame(1):frame(2),((i-1)*8)+1));
        frame_avg_2(i) = mean(v_tbl(frame(1):frame(2),((i-1)*8)+2));
        frame_avg_3(i) = mean(v_tbl(frame(1):frame(2),((i-1)*8)+3));
        frame_avg_4(i) = mean(v_tbl(frame(1):frame(2),((i-1)*8)+4));
%         frame_avg_5(i) = mean(v_tbl(frame(1):frame(2),((i-1)*8)+5));
%         frame_avg_6(i) = mean(v_tbl(frame(1):frame(2),((i-1)*8)+6));
%         frame_avg_7(i) = mean(v_tbl(frame(1):frame(2),((i-1)*8)+7));
%         frame_avg_8(i) = mean(v_tbl(frame(1):frame(2),((i-1)*8)+8));
    end
%     frame_avg_all = [frame_avg_1; frame_avg_2; frame_avg_3; frame_avg_4; frame_avg_5; frame_avg_6; frame_avg_7; frame_avg_8]';
%     frame_mean_all = [mean(frame_avg_1) mean(frame_avg_2) mean(frame_avg_3) mean(frame_avg_4) mean(frame_avg_5) mean(frame_avg_6) mean(frame_avg_7) mean(frame_avg_8)];
%     frame_sterr_all = [std(frame_avg_1)/sqrt(length(frame_avg_1)) std(frame_avg_2)/sqrt(length(frame_avg_2)) std(frame_avg_3)/sqrt(length(frame_avg_3)) std(frame_avg_4)/sqrt(length(frame_avg_4)) std(frame_avg_5)/sqrt(length(frame_avg_5)) std(frame_avg_6)/sqrt(length(frame_avg_6)) std(frame_avg_7)/sqrt(length(frame_avg_7)) std(frame_avg_8)/sqrt(length(frame_avg_8))];
        frame_avg_all = [frame_avg_1; frame_avg_2; frame_avg_3; frame_avg_4]';
        frame_mean_all = [mean(frame_avg_1) mean(frame_avg_2) mean(frame_avg_3) mean(frame_avg_4)];
        frame_sterr_all = [std(frame_avg_1)/sqrt(length(frame_avg_1)) std(frame_avg_2)/sqrt(length(frame_avg_2)) std(frame_avg_3)/sqrt(length(frame_avg_3)) std(frame_avg_4)/sqrt(length(frame_avg_4))];
    
        err_diff= frame_sterr_all;
        y_diff = frame_mean_all;
        [p_w_diff,h_w_diff] = signrank(frame_avg_1, frame_avg_2);


%%
cd('Z:\Lab Member folders\Margaret Swerdloff\From Eric')
colors = [0 0.447 .741;.85 .325 .098;.929 .694 .125;.494 .184 .556];
figure
% errorbarbar([y_v5_minusStroop(2); y_v6_minusStroop(2)]',[err_v5_minusStroop(2); err_v6_minusStroop(2)]',axes,[colors])
errorbarbar([y_diff],[err_diff],axes,[colors])
ylabel('Mean Decrease in P3 Potential (µV)')