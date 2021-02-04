function data = newz(numRep)
%% this is a new script for testing the accuracy of matlab/the trigger hub to play tones at the right intervals
for ii = 1:numRep
    clearvars -except data ii
    numBase=7;
    startT = clock;
    
    for n = 1:numBase %
        [nextTone_5a(:,:,n) nextTone_5a_val(:,1,n)] = make_wav_file_MMS_unRand_adj(1,5)
    end
    
    t5_a_separate = clock;
    
    [nextTone_5b(:,:,n) nextTone_5b_val(:,1,n)] = make_wav_file_MMS_unRand_adj(numBase,5)
    
    t5_b_combined = clock;
    
    for n = 1:numBase %
        [nextTone_6a(:,:,n) nextTone_6a_val(:,1,n)] = make_wav_file_MMS_unRand_adj(1,6)
    end
    
    t6_a_separate = clock;
    
    [nextTone_6b(:,:,n) nextTone_6b_val(:,1,n)] = make_wav_file_MMS_unRand_adj(numBase,6)
    
    t6_b_combined = clock;
    
    for n = 1:numBase
        [nextTone_5c(:,:,n) nextTone_5c_val(:,1,n)] = make_wav_file_MMS_unRand_adj(1,5)
        [nextTone_6c(:,:,n) nextTone_6c_val(:,1,n)] = make_wav_file_MMS_unRand_adj(1,6)
    end
    
    endT = clock;
    
    %%
    a5 = etime(t5_a_separate,startT); % time it took for separate tones
    b5 = etime(t5_b_combined,t5_a_separate); % time it took for combined tones
    ML5_diff = a5-b5; % positive means separated took longer
    % does a = b? what's the difference? does the DSI agree?
    
    %%
    a6 = etime(t6_a_separate,t5_b_combined); % time it took for separate tones
    b6 = etime(t6_b_combined,t6_a_separate); % time it took for combined tones
    ML6_diff = a6-b6; % positive means separated took longer
    
    %% now compare length it took to run 14 tones combined
    c56 = etime(endT,t6_b_combined); % time it took for combined tones (alternating)
    MLc_sep_diff = c56-(a5+a6); % positive means combined alternating tones took longer than separated tones
    MLc_comb_diff = c56-(b5+b6); % positive means combined alternating tones took longer than adding both rounds of combined tones together
    
    data.a5(ii) = a5;
    data.b5(ii) = b5;
    data.ML5_diff(ii) = ML5_diff;
    data.a6(ii) = a6;
    data.b6(ii) = b6;
    data.ML6_diff(ii) = ML6_diff;
    data.c56(ii) = c56;
    data.MLc_sep_diff(ii) = MLc_sep_diff;
    data.MLc_comb_diff(ii) = MLc_comb_diff;
end

end