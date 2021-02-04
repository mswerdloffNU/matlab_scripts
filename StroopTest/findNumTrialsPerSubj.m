%% investigate # in each subj

ToneLabelCat = S015_v5_ToneLabelCat;

ToneLabelCatNum(1,:) = [numel(find(ToneLabelCat==1)) numel(find(ToneLabelCat==2)) numel(find(ToneLabelCat==3)) numel(find(ToneLabelCat==4)) numel(find(ToneLabelCat==5)) numel(find(ToneLabelCat==6)) numel(find(ToneLabelCat==7)) numel(find(ToneLabelCat==8))]

ToneLabelCat = S015_v6_ToneLabelCat;

ToneLabelCatNum(2,:) = [numel(find(ToneLabelCat==1)) numel(find(ToneLabelCat==2)) numel(find(ToneLabelCat==3)) numel(find(ToneLabelCat==4)) numel(find(ToneLabelCat==5)) numel(find(ToneLabelCat==6)) numel(find(ToneLabelCat==7)) numel(find(ToneLabelCat==8))]


ToneLabelCat = S016_v5_ToneLabelCat;

ToneLabelCatNum(3,:) = [numel(find(ToneLabelCat==1)) numel(find(ToneLabelCat==2)) numel(find(ToneLabelCat==3)) numel(find(ToneLabelCat==4)) numel(find(ToneLabelCat==5)) numel(find(ToneLabelCat==6)) numel(find(ToneLabelCat==7)) numel(find(ToneLabelCat==8))]

ToneLabelCat = S016_v6_ToneLabelCat;

ToneLabelCatNum(4,:) = [numel(find(ToneLabelCat==1)) numel(find(ToneLabelCat==2)) numel(find(ToneLabelCat==3)) numel(find(ToneLabelCat==4)) numel(find(ToneLabelCat==5)) numel(find(ToneLabelCat==6)) numel(find(ToneLabelCat==7)) numel(find(ToneLabelCat==8))]


ToneLabelCat = S017_v5_ToneLabelCat;

ToneLabelCatNum(5,:) = [numel(find(ToneLabelCat==1)) numel(find(ToneLabelCat==2)) numel(find(ToneLabelCat==3)) numel(find(ToneLabelCat==4)) numel(find(ToneLabelCat==5)) numel(find(ToneLabelCat==6)) numel(find(ToneLabelCat==7)) numel(find(ToneLabelCat==8))]

ToneLabelCat = S017_v6_ToneLabelCat;

ToneLabelCatNum(6,:) = [numel(find(ToneLabelCat==1)) numel(find(ToneLabelCat==2)) numel(find(ToneLabelCat==3)) numel(find(ToneLabelCat==4)) numel(find(ToneLabelCat==5)) numel(find(ToneLabelCat==6)) numel(find(ToneLabelCat==7)) numel(find(ToneLabelCat==8))]


ToneLabelCat = S018_v5_ToneLabelCat;

ToneLabelCatNum(7,:) = [numel(find(ToneLabelCat==1)) numel(find(ToneLabelCat==2)) numel(find(ToneLabelCat==3)) numel(find(ToneLabelCat==4)) numel(find(ToneLabelCat==5)) numel(find(ToneLabelCat==6)) numel(find(ToneLabelCat==7)) numel(find(ToneLabelCat==8))]

ToneLabelCat = S018_v6_ToneLabelCat;

ToneLabelCatNum(8,:) = [numel(find(ToneLabelCat==1)) numel(find(ToneLabelCat==2)) numel(find(ToneLabelCat==3)) numel(find(ToneLabelCat==4)) numel(find(ToneLabelCat==5)) numel(find(ToneLabelCat==6)) numel(find(ToneLabelCat==7)) numel(find(ToneLabelCat==8))]

%% plot trouble files
% % plot S017_v5
% stim=S017_v5;
% idxTonesOn_only_5 = zeros(length(stim));
% for ii = 1:length(stim)
%     if stim(ii) == 1
%         idxTonesOn_only_5(ii) = 1;
%     elseif stim(ii)==6
%         nearestToneNonProv_5(ii) = 1;
%     elseif stim(ii)==7
%         audioTarget_5(ii) = 7;
%     elseif stim(ii)==8
%         idxWordsOn_only_5(ii) = 8;
%     else
%         tonCategory(ii)=stim(ii);
% end
% %%
%     figure
%     plot(tone)
%     ylabel('tone')
%     hold on
%     plot(idxSStart2,ones(1,20),'k+') % approx when the Prov word should have started ended
%     % plot(idxTonesOn_only,ones(1,numel(idxTonesOn_only)),'b*') % tone detected by Trigger Hub
%     plot(audioTarget_5,ones(1,numelements),'mo')
%     plot(stroopTarget,ones(1,numel(stroopTarget)),'bo')
%     plot(nearestToneNonProv_5,ones(1,numelements),'go')
%     plot(idxTonesOn_only_5,ones(1,numelements),'ko')
%     ylim([-.15 1.15])