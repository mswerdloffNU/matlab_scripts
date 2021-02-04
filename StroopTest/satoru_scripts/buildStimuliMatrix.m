clearvars
subs = {'S015','S016','S017','S018'};
%% create setnames
for i = 1:numel(subs)
    for n = 1:2
        sub = subs{i};
        loc_sub = strcat('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\Pilot2\',sub);
        if n == 1
            filename = 'Sub_v5_stroopStimuli_filt_a_b_2_allTrials_ICA_elist_bins.set';
            % filename = 'Sub_v5_stroopStimuli_filt_a_b_2_allTrials_ICA_elist_bins_be_rejected.set';
        elseif n == 2
            filename = 'Sub_v6_hard_stroopStimuli_filt_a_b_2_allTrials_ICA_elist_bins.set';
            % filename = 'Sub_v6_hard_stroopStimuli_filt_a_b_2_allTrials_ICA_elist_bins_be_rejected.set';
        end
        filename_location_gen = 'Z:\Lab Member folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\StroopAudio\Pilot2\Sub\';
        filename_only{i,n} = strrep(filename,'Sub',sub);
        filename_location{i,n} = strrep(filename_location_gen,'Sub',sub);
    end
end
%% import sets into EEGLAB
cd 'C:\Users\mswerdloff\eeglab14_1_2b'
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
Ns = numel(subs);
Nc = 2;
for S = 1:Ns
    for s = 1:Nc
        EEG = pop_loadset('filename',filename_only{S,s},'filepath',filename_location{S,s});
        EEG = eeg_checkset( EEG );
        [ALLEEG EEG] = eeg_store(ALLEEG, EEG, Nc*(S-1) + s);  % Store the dataset in ALLEEG
    end
end
eeglab redraw
%%
% stroops{1} = ALLEEG(1:2:end);
% stroops{2} = ALLEEG(2:2:end);
% %% re-name condition 2 stimuli
% for S = 1:Ns
%     for s = 1:Nc
%         for ii = 1:numel([stroops{1, s}(S).event.bini].')
%             if s == 1
%                 ToneLabelCatEq(ii,S,s) = [stroops{1, s}(S).epoch.eventbini].';
%             elseif s == 2
%                 ToneLabelCatEq(ii,S,s) = 10*[stroops{1, s}(S).epoch.eventbini].';
%             end
%         end
%     end
% end
%
%     if strcmp(sub,'S015') == 1
%         ToneMatrix(:,i,n) = [find(ToneLabelCatEq); -1*ones(5,1)];
%     else
%         ToneMatrix(:,i,n) = find(ToneLabelCatEq);
%     end
%     ToneMatrix_num(i,n) = numel(ToneMatrix(:,i,n));
%
%%
for sn = 1:Ns*Nc
    clearvars -except Ns Nc ALLEEG S s sn
    
    icarejthresh=ALLEEG(sn).reject.icarejthresh;
    icarejconst=ALLEEG(sn).reject.icarejconst;
    icarejjp=ALLEEG(sn).reject.icarejjp;
    icarejkurt=ALLEEG(sn).reject.icarejkurt;
    icarejfreq=ALLEEG(sn).reject.icarejfreq;
    icarej=[icarejthresh;icarejconst;icarejjp;icarejkurt;icarejfreq];
    icarej_all=zeros(size(icarej(1,:)));
    for ii = 1:numel(icarej(1,:))
        icarej_all(1,ii)=max(icarej(1:5,ii));
    end
    icarej_all(2,:)=zeros(size(icarej_all(1,:)));
    for ii = 1:numel(icarej_all(1,:))
        icarej_all(2,ii)=ALLEEG(sn).event(ii).bini;
    end
    
    [numel(find(icarej_all(2,:)==1)) numel(find(icarej_all(2,:)==2)) numel(find(icarej_all(2,:)==3)) numel(find(icarej_all(2,:)==4)) numel(find(icarej_all(2,:)==5)) numel(find(icarej_all(2,:)==6)) numel(find(icarej_all(2,:)==7)) numel(find(icarej_all(2,:)==8))]
    idx1=zeros(size(icarej_all(1,:)));
    idx2=zeros(size(icarej_all(1,:)));
    idx3=zeros(size(icarej_all(1,:)));
    idx4=zeros(size(icarej_all(1,:)));
    idx5=zeros(size(icarej_all(1,:)));
    idx6=zeros(size(icarej_all(1,:)));
    idx7=zeros(size(icarej_all(1,:)));
    idx8=zeros(size(icarej_all(1,:)));
    
    for ii  = 1:numel(icarej_all(1,:))
        if icarej_all(1,ii)==0;
            if icarej_all(2,ii)==1
                idx1(ii)=ii;
            elseif icarej_all(2,ii)==2
                idx2(ii)=ii;
            elseif icarej_all(2,ii)==3
                idx3(ii)=ii;
            elseif icarej_all(2,ii)==4
                idx4(ii)=ii;
            elseif icarej_all(2,ii)==5
                idx5(ii)=ii;
            elseif icarej_all(2,ii)==6
                idx6(ii)=ii;
            elseif icarej_all(2,ii)==7
                idx7(ii)=ii;
            elseif icarej_all(2,ii)==8
                idx8(ii)=ii;
            end
        elseif icarej_all(1,ii)==1
            if icarej_all(2,ii)==1
                idx1(ii)=0;
            elseif icarej_all(2,ii)==2
                idx2(ii)=0;
            elseif icarej_all(2,ii)==3
                idx3(ii)=0;
            elseif icarej_all(2,ii)==4
                idx4(ii)=0;
            elseif icarej_all(2,ii)==5
                idx5(ii)=0;
            elseif icarej_all(2,ii)==6
                idx6(ii)=0;
            elseif icarej_all(2,ii)==7
                idx7(ii)=0;
            elseif icarej_all(2,ii)==8
                idx8(ii)=0;
            end
        end
    end
    idx1=nonzeros(idx1);idx2=nonzeros(idx2);idx3=nonzeros(idx3);idx4=nonzeros(idx4);idx5=nonzeros(idx5);idx6=nonzeros(idx6);idx7=nonzeros(idx7);idx8=nonzeros(idx8);
    [numel(find(idx1)) numel(find(idx2)) numel(find(idx3)) numel(find(idx4)) numel(find(idx5)) numel(find(idx6)) numel(find(idx7)) numel(find(idx8))]
    
    %% equalize number of trials
    
    % for n = 5 (assuming no artifact detection will be done)
    numelements = 5;
    % get the randomly-selected indices
    if numel(find(idx1)) >= 5
        clear indices
        indices = randperm(length(idx1));
        indices = indices(1:numelements);
        % choose the subset of a you want
        idx1_5 = idx1(indices);
    else
        idx1_5=idx1;
    end
    
    if numel(find(idx2)) >= 5
        clear indices
        indices = randperm(length(idx2));
        indices = indices(1:numelements);
        % choose the subset of a you want
        idx2_5 = idx2(indices);
    else
        idx2_5=idx2;
    end
    
    if numel(find(idx3)) >= 5
        clear indices
        indices = randperm(length(idx3));
        indices = indices(1:numelements);
        % choose the subset of a you want
        idx3_5 = idx3(indices);
    else
        idx3_5=idx3;
    end
    
    if numel(find(idx4)) >= 5
        clear indices
        indices = randperm(length(idx4));
        indices = indices(1:numelements);
        % choose the subset of a you want
        idx4_5 = idx4(indices);
    else
        idx4_5=idx4;
    end
    
    clear indices
    indices = randperm(length(idx5));
    indices = indices(1:numelements);
    % choose the subset of a you want
    idx5_5 = idx5(indices);
    
    clear indices
    indices = randperm(length(idx6));
    indices = indices(1:numelements);
    % choose the subset of a you want
    idx6_5 = idx6(indices);
    
    clear indices
    indices = randperm(length(idx7));
    indices = indices(1:numelements);
    % choose the subset of a you want
    idx7_5 = idx7(indices);
    
    if sn > 2 %strcmp(sub,'S015')==0;
        clear indices
        indices = randperm(length(idx8));
        indices = indices(1:numelements);
        % choose the subset of a you want
        idx8_5 = idx8(indices);
    end
    rand5check = [0 0 0 0 0 0 0 0];
    if sn > 2 %strcmp(sub,'S015')==0;
        rand5check_goal = [5 5 5 5 5 5 5 5];
    else
        rand5check_goal = [5 5 5 5 5 5 5 0];
    end
    maxIter=100;
    
    for iter=1:maxIter
        icarej_eq = zeros(length(icarej_all(1,:)),1);
        for ii = 1:length(idx1_5)
            icarej_eq(idx1_5(ii)) = 1; % non-stroop non-target (blue star)
        end
        for ii = 1:length(idx2_5)
            icarej_eq(idx2_5(ii)) = 2; % non-stroop non-target (blue star)
        end
        for ii = 1:length(idx3_5)
            icarej_eq(idx3_5(ii)) = 3; % non-stroop non-target (blue star)
        end
        for ii = 1:length(idx4_5)
            icarej_eq(idx4_5(ii)) = 4; % non-stroop non-target (blue star)
        end
        for ii = 1:length(idx5_5)
            icarej_eq(idx5_5(ii)) = 5; % non-stroop non-target (blue star)
        end
        for ii = 1:length(idx6_5)
            icarej_eq(idx6_5(ii)) = 6; % stroop non-target (cyan star)
        end
        for ii = 1:length(idx7_5)
            icarej_eq(idx7_5(ii)) = 7; % non-stroop target (magenta circle)
        end
        if sn > 2 % strcmp(sub,'S015')==0
            for ii = 1:length(idx8_5)
                icarej_eq(idx8_5(ii)) = 8; % non-stroop target (black star)
            end
        end
        rand5check = [numel(find(icarej_eq==1)) numel(find(icarej_eq==2)) numel(find(icarej_eq==3)) numel(find(icarej_eq==4)) numel(find(icarej_eq==5)) numel(find(icarej_eq==6)) numel(find(icarej_eq==7)) numel(find(icarej_eq==8))];
        
        if rand5check==rand5check_goal
            break
        elseif iter == maxIter
            warning('Max Iterations reached')
            break
        end
    end
    disp(rand5check)
    
    
    %%
    icarej_eq(:,2)=zeros(numel(icarej_eq(:,1)),1);
    for ii=1:numel(icarej_eq(:,1))
        if icarej_eq(ii,1)==0
            icarej_eq(ii,2)=1;
        end
    end
    %% flag artifact epochs
    for ii = 1:numel(icarej_eq(:,2))
        ALLEEG(sn).EVENTLIST.eventinfo(ii).flag = icarej_eq(ii,2);
    end
    
end

%%
clear binis binnums
for S = 1:Ns;
    for s = 1:Nc;
        binis{S,s} = [ALLEEG( Nc*(S-1) + s).EVENTLIST.eventinfo.bini].';
        binnums(S,s) = numel(binis{S,s});
        if s == 2
            binis{S,s} = 10*binis{S,s};
        end
    end
end
maxel = max(binnums(:));
% old stimMat (doesn't include -1's)
%     stimMat(1,:)=[binis{1,1}; binis{2,1}; binis{3,1}; binis{4,1}]';
%     stimMat(2,:)=[binis{1,2}; binis{2,2}; binis{3,2}; binis{4,2}]';
clear stimMat
for s = 1:Nc % make sure expand for more subjects
    stimMat(s,:) = [binis{1,s}' -1*ones(1,maxel-binnums(1,s)) binis{2,s}' -1*ones(1,maxel-binnums(2,s)) binis{3,s}' -1*ones(1,maxel-binnums(3,s)) binis{4,s}' -1*ones(1,maxel-binnums(4,s))];
end