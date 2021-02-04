%% this is a new script for testing the accuracy of matlab/the trigger hub to play tones at the right intervals
numBase=7;

for n = 1:numBase % 
[nextTone(:,:,n) nextTone_val(:,1,n)] = make_wav_file_MMS_unRand_adj(numBase,5)
end

for n = 1:numBase % 
[nextTone(:,:,n) nextTone_val(:,1,n)] = make_wav_file_MMS_unRand_adj(numBase,6)
end

for n = 1:numBase
[nextTone(:,:,n) nextTone_val(:,1,n)] = make_wav_file_MMS_unRand_adj(1,5)
[nextTone(:,:,n) nextTone_val(:,1,n)] = make_wav_file_MMS_unRand_adj(1,6)
end