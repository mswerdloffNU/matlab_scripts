%%
close all
subs = {'S015','S016','S017','S018'};
%%
filePath='Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\Pilot2\AR_eq';
cd(filePath)
Files_v5 = dir('*v5*_ICA_Num_*'); % choose 1, 2, or 4 for the order of the butterworth filter
Files_v6 = dir('*v6*_ICA_Num_*'); % choose 1, 2, or 4 for the order of the butterworth filter
for f = 1:2
    if f == 1
        Files=Files_v5;
        setName = 'stroop_v5_S015678_AR_eq';
    elseif f == 2
        Files=Files_v6;
        setName = 'stroop_v6_hard_S015678_AR_eq';
    end
    setName_all='stroop_v5_v6_S015678_AR_eq';
    for ii = 1:8:(8*numel(subs))
        filename=Files(ii).name % file to be converted
        if strfind(filename, 'S015')
            for k=1:8
                Files(k).sub = 'S015';
            end
        elseif strfind(filename, 'S016')
            for k=1:8
                Files(k+8).sub = 'S016';
            end
        elseif strfind(filename, 'S017')
            for k=1:8
                Files(k+16).sub = 'S017';
            end
        elseif strfind(filename,'S018')
            for k=1:8
                Files(k+24).sub = 'S018';
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
    
    clear stroop_noAR stroop_noAR_pz
    for ii = 1:(8*numel(subs))
        stroop_noAR = importTarget(Files(ii).name);
        stroop_noAR_pz(:,ii) = table2array(stroop_noAR(2,2:end))';
    end
    stroop_noAR_pz(:,8)=NaN;
    
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
    clear v5_grandAvg_idvtone v5_grandAvg_sum
    for kk = 1:8
        % for ii = kk:8:(8*numel(subs))
        v5_grandAvg_idvtone = v5_all(:,kk:8:end);
        v6_grandAvg_idvtone = v6_all(:,kk:8:end);
        % end
        if kk == 8
            n_adj = n-1;
        else
            n_adj = n;
        end
        v5_grandAvg_sum(kk,:) = (nansum(v5_grandAvg_idvtone'))/n_adj
        v6_grandAvg_sum(kk,:) = (nansum(v6_grandAvg_idvtone'))/n_adj
    end
end
for f=1:2
    h(1*f)=figure;
    for kk = 1:8
        for ii = kk:8:(8*numel(subs))
            subplot(2,4,kk)
            hold on
            if f==1
                plot(time,v5_all(:,ii),'LineWidth',1)
            elseif f==2
                plot(time,v6_all(:,ii),'LineWidth',1)
            end
            line([0 0], [-15 15]);
            line([-200 800], [0 0]);
            grid minor
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
            elseif kk == 5
                title('Audio Non-Target')
            elseif kk == 6
                title('Non-Target Stroop')
            elseif kk == 7
                title('Audio Target')
            elseif kk == 8
                title('Stroop Congruent')
            end
        end
        if f==1
            plot(time,v5_grandAvg_sum(kk,:),'LineWidth',4)
        elseif f==2
            plot(time,v6_grandAvg_sum(kk,:),'LineWidth',4)
        end
    end
    %%
%     h(2+f)=figure;
%     for kk = 1:8
%         for ii = kk:8:(8*numel(subs))
%             subplot(2,4,kk)
%             hold on
%             plot(time,v5_all(:,ii)-v5_grandAvg_sum(8,:)','LineWidth',1)
%             line([0 0], [-15 15]);
%             line([-200 800], [0 0]);
%             grid minor
%             xlabel('Time relative to stimuli (ms)')
%             ylabel('Potential (µV)')
%             xlim([-200 800])
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
%         plot(time,v5_grandAvg_sum(kk,:)-v5_grandAvg_sum(8,:),'LineWidth',4)
%     end
    fnm = sprintf('erp_%s.fig',setName_all);
    cd(filePath)
%     savefig(h,fnm)
end
%%
figure
subplot(1,3,1)
for kk = 7
    for ii = kk:8:(8*numel(subs))
%         disp(ii)
%         disp(v5_all(1:5,ii))       
        hold on
        plot(time,v5_all(:,ii),'LineWidth',1)
        line([0 0], [-15 15]);
        line([-200 800], [0 0]);
        grid minor
        xlabel('Time relative to stimuli (ms)')
        ylabel('Potential (µV)')
        xlim([-200 800])
        title('Audio Target - Easy')
    end
end
plot(time,v5_grandAvg_sum(kk,:),'LineWidth',4)
subplot(1,3,2)
for kk = 7
    for ii = kk:8:(8*numel(subs))
        hold on
        plot(time,v6_all(:,ii),'LineWidth',1)
        line([0 0], [-15 15]);
        line([-200 800], [0 0]);
        grid minor
        xlabel('Time relative to stimuli (ms)')
        ylabel('Potential (µV)')
        xlim([-200 800])
        title('Audio Target - Hard')
    end
end
plot(time,v6_grandAvg_sum(kk,:),'LineWidth',4)
%
subplot(1,3,3)
plot(time,v5_grandAvg_sum(kk,:),'LineWidth',4)
hold on
plot(time,v6_grandAvg_sum(kk,:),'LineWidth',4)
line([0 0], [-15 15]);
line([-200 800], [0 0]);
grid minor
xlabel('Time relative to stimuli (ms)')
ylabel('Potential (µV)')
xlim([-200 800])
title('Audio Target')
legend('Easy','Hard')
fnm = sprintf('erp_Comp1_%s.fig',setName_all);
cd(filePath)
savefig(fnm)

%%
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
        plot(time,v6_all(:,ii),'LineWidth',1)
        line([0 0], [-30 30]);
        line([-200 800], [0 0]);
        grid minor
        xlabel('Time relative to stimuli (ms)')
        ylabel('Potential (µV)')
        xlim([-200 800])
        title('At Stroop Target - Hard')
    end
end
plot(time,v6_grandAvg_sum(kk,:),'LineWidth',4)
%
subplot(1,3,3)
plot(time,v5_grandAvg_sum(kk,:),'LineWidth',4)
hold on
plot(time,v6_grandAvg_sum(kk,:),'LineWidth',4)
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
savefig(fnm)
