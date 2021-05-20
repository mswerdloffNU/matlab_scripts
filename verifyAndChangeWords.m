function [idxWordsOn_alt, idxWordsOff_alt, alters] = verifyAndChangeWords(idxword_flag,idxword_on_flag)

%% decide if flagged words are actually good or bad
input_flags = {idxword_flag idxword_on_flag};

for mm = 1:length(input_flags)
    input_flag = input_flags{mm};
    
    numel(input_flag)
    word_flagged = zeros(length(input_flag),2);
    
    for jj = 1:numel(input_flag)
        figure
        plot(word)
        ylabel('word')
        hold on
        plot(idxTonesOn,ones(1,numel(idxTonesOn)),'ko')
        plot(idxTonesOff,ones(1,numel(idxTonesOff)),'k+')
        plot(idxTonesOn_only_long,ones(1,numel(idxTonesOn_only_long)),'ko')
        plot(idxTonesOff_only_long,ones(1,numel(idxTonesOff_only_long)),'k+')
        plot(idxTonesOn_comb_nz,ones(1,numel(idxTonesOn_comb_nz)),'go')
        plot(idxTonesOff_comb_nz,ones(1,numel(idxTonesOff_comb_nz)),'g+')
        plot(idxWordsOn,ones(1,numel(idxWordsOn)),'ko')
        plot(idxWordsOff,ones(1,numel(idxWordsOff)),'ko')
        
        for ii = 1:numel(input_flag)
            plot(idxWordsOff(input_flag(ii)+1),1,'r+')
            plot(idxWordsOn(input_flag(ii)+1),1,'ro')
        end
        
        xlim([idxWordsOff(input_flag(jj)+1)-1500 idxWordsOff(input_flag(jj)+1)+1500])
        ylim([.90 1.15])
        [jj numel(input_flag)]
        
        pause
        
        prompt = {'Enter 1 if good, 2 if bad:'};
        dlgtitle = 'Input';
        dims = [1 65];
        definput = {'0'};
        answer = inputdlg(prompt,dlgtitle,dims,definput);
        word_flagged(jj,:) = [input_flag(jj) str2num(answer{1})]
    end
    
    figure
    plot(word)
    ylabel('word')
    hold on
    plot(idxTonesOn,ones(1,numel(idxTonesOn)),'ko')
    plot(idxTonesOff,ones(1,numel(idxTonesOff)),'k+')
    plot(idxTonesOn_only_long,ones(1,numel(idxTonesOn_only_long)),'ko')
    plot(idxTonesOff_only_long,ones(1,numel(idxTonesOff_only_long)),'k+')
    plot(idxTonesOn_comb_nz,ones(1,numel(idxTonesOn_comb_nz)),'go')
    plot(idxTonesOff_comb_nz,ones(1,numel(idxTonesOff_comb_nz)),'g+')
    plot(idxWordsOn,ones(1,numel(idxWordsOn)),'ko')
    plot(idxWordsOff,ones(1,numel(idxWordsOff)),'ko')
    
    if isempty(input_flag) == 0
        for ii = 1:numel(input_flag)
            numel(input_flag)
            plot(idxWordsOff(input_flag(ii)+1),1,'r+')
            plot(idxWordsOn(input_flag(ii)+1),1,'ro')
        end
    end
    
    
    %% plot again to visually verify flag designations are correct
    
    idxword_flagged = word_flagged(:,1);
    %     idxword_flagged = word_flagged(find(word_flagged(:,2) == 2),1);
    word_verify = zeros(length(idxword_flagged),2);
    
    for ii = 1:numel(idxword_flagged)
        figure
        plot(word)
        ylabel('word')
        hold on
        
        if word_flagged(ii,2) == 1 % good
            plot(idxWordsOff(idxword_flagged(ii)+1),1,'g+')
            plot(idxWordsOn(idxword_flagged(ii)+1),1,'go')
        elseif word_flagged(ii,2) == 2 % bad
            plot(idxWordsOff(idxword_flagged(ii)+1),1,'r+')
            plot(idxWordsOn(idxword_flagged(ii)+1),1,'ro')
        end
        
        plot(idxWordsOn,ones(1,numel(idxWordsOn)),'.')
        xlim([idxWordsOn(idxword_flagged(ii)+1)-2500 idxWordsOff(idxword_flagged(ii)+1)+2500])
        ylim([.90 1.05])
        pause
        
        prompt = {'Keep 1 if correct, 2 if incorrect:'};
        dlgtitle = 'Input';
        dims = [1 65];
        definput = {'1'};
        answer = inputdlg(prompt,dlgtitle,dims,definput);
        word_verify(ii,:) = [idxword_flagged(ii) str2num(answer{1})]        
    end
    alters_cells{mm} = num2cell(idxword_flagged(find(word_flagged(:,2)==2)),[1 2]);
    goofs_cells{mm} = find(word_verify(:,2) == 2); % 2 means there was a goof
end 

%% fix errors in stim
for mm = 1:numel(input_flag)
    alters_cell = [alters_cells{:}];
    alters = cell2mat(alters_cell(:));
    
    goofs_cell = [goofs_cells{:}];
    goofs = cell2mat(goofs_cell(:));
end
idxWordsOn_alt = idxWordsOn;
idxWordsOff_alt = idxWordsOff;

if isempty(goofs) == 0
    goofs
    error('ya darn goofed. go back')
    pause
elseif isempty(goofs) == 1 && isempty(alters == 2) == 0
    sprintf('changing alters now')
    alters
    for ii = 1:numel(alters)
        idxWordsOn_alt(alters(ii)+1) = [];
        idxWordsOff_alt(alters(ii)+1) = [];
    end
end

%%
word_int_alt = [];
for ii = 1:numel(idxWordsOn_alt)-1
    word_int_alt(ii) = idxWordsOn_alt(ii+1) - idxWordsOff_alt(ii);
end

figure()
plot(word_int_alt,'.')
ylim([0,4000])
ylabel('word interval')

word_flag_alt = zeros(numel(word_int_alt),1);
for ii = 1:numel(word_int_alt)
    if word_int_alt(ii) < 320
        word_flag_alt(ii) = 1;
    else
        word_flag_alt(ii) = 2;
    end
end
[idxword_flag_alt,~] = find(word_flag_alt == 1)

word_int_val_alt = [];
for ii = 1:numel(idxword_flag_alt)
    word_int_val_alt(ii) = word_int(idxword_flag_alt(ii));
    
end

word_int_val = [];
for ii = 1:numel(input_flag)
    word_int_val(ii) = word_int(input_flag(ii))+1;
end

figure
plot(word_int_alt,'k.')
hold on
plot(idxword_flagged,word_int_val,'g.')
plot(idxword_flag_alt,word_int_val_alt,'ro','MarkerSize',12)
plot(idxword_flag_alt,word_int_val_alt,'r.')
ylim([0,4000])
ylabel('word interval')
xlabel('index')
%%
figure
plot(word)
ylabel('word')
hold on
plot(idxTonesOn,ones(1,numel(idxTonesOn)),'ko')
plot(idxTonesOff,ones(1,numel(idxTonesOff)),'k+')
plot(idxTonesOn_only_long,ones(1,numel(idxTonesOn_only_long)),'ko')
plot(idxTonesOff_only_long,ones(1,numel(idxTonesOff_only_long)),'k+')
plot(idxTonesOn_comb_nz,ones(1,numel(idxTonesOn_comb_nz)),'go')
plot(idxTonesOff_comb_nz,ones(1,numel(idxTonesOff_comb_nz)),'g+')
plot(idxWordsOn_alt,ones(1,numel(idxWordsOn_alt)),'ko')
plot(idxWordsOff_alt,ones(1,numel(idxWordsOff_alt)),'ko')

%     plot(idxWordsOff_alt(alters(ii)),1,'ko')
%     plot(idxWordsOn_alt(alters(ii)),1,'ko')

plot(idxWordsOn_alt,ones(1,numel(idxWordsOn_alt)),'k.')
for ii = 1:numel(alters)
    
    xlim([idxWordsOn_alt(alters(ii))-2500 idxWordsOff(alters(ii))+2500])
    ylim([.90 1.05])
    pause
end

end