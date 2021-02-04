
%% move to EEGLAB

clear
clc
cd 'C:\Users\mswerdloff\eeglab14_1_2b'
%cd 'C:\Users\maggi\Documents\MATLAB\eeglab14_1_2b'
eeglab
%% specify filename

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S003\walk'

Files=dir('*2_allTrials.mat'); % choose 1, 2, or 4 for the order of the butterworth filter

for k=1:length(Files)
   filename=Files(k).name % file to be converted
   if strfind(filename, 'A')
        Files(k).session = 'A';
   elseif strfind(filename, 'B')
       Files(k).session = 'B';
   elseif strfind(filename, 'C')
       Files(k).session = 'C';
   end
end

T = struct2table(Files); % convert the struct array to a table
sortedT = sortrows(T, 'session'); % sort the table by 'DOB'
clear Files
Files = table2struct(sortedT) % c
% Files = orderfields(Files,'session')

for k=1:length(Files)   
   filename=Files(k).name % file to be converted
   location2 = pwd % source folder
   filePath = strrep(location2,'walk','redoEq') % destination folder
end

for i = 1:9
    setNum = i;
%     filename = 'S003_v2_stand_walk_sit_C_0002_filt_a_b_2_allTrials.mat'; % file to be converted
%     location2 = 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S003\walk'; % source folder
%     filePath = 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S003\redoEq'; % destination folder
    % filePath = location2;
    
    location = strcat(location2,filename);
    setName = strrep(filename,'.mat','_eq2');
    erpName = strcat('erpset_',setName,'_ICA_Num');
    filename_info = strrep(location,'.mat','_eq2_info_pt2.mat');
    erpFilename = strrep(erpName,'_ICA_Num','_ICA_Num.erp');
    eventlistA = strrep(location,'.mat','_eq2_ICA_EventListA.txt');
    eventlistB = strrep(location,'.mat','_eq2_ICA_EventListB.txt');
    startSet = 0;
    setICA = strrep(location,'.mat','_eq2_ICA.set');
    setBinned = strrep(location,'.mat','_eq2_ICA_elist_bins.set');
    setEpoched = strrep(location,'.mat','_eq2_ICA_elist_bins_be.set');
    trialsTxt = strrep(location,'.mat','eq2_trialsNum.txt');
    erpText = strrep(location,'.mat','_eq2_ICA_Num.txt');
    %% open new set
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',location,'setname',setName,'srate',300,'pnts',0,'xmin',0);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet,'gui','off');
    EEG = eeg_checkset( EEG );
    EEG = pop_chanevent(EEG, 8,'edge','leading','edgelen',0);
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = eeg_checkset( EEG );
    EEG = pop_editset(EEG, 'chanlocs', 'C:\Users\mswerdloff\eeglab14_1_2b\chanlocsDSI7.ced');
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    % EEG = pop_runica(EEG, 'extended',startSet,'interupt','on');
    % [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet+1,'savenew',setICA,'gui','off');
    % open existing set
    %EEG = pop_loadset('filename','S006_stand_walk_sit_C_0001_filt_a_b_2_allTrials_ICA_elist_bins_be.set','filepath','Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S006\walk\');
    %
    EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist', eventlistA ); % GUI: 28-May-2019 11:10:03
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet+2,'gui','off');
    EEG  = pop_binlister( EEG , 'BDF', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\EEG_data_withTriggers\binlist6.txt', 'ExportEL', eventlistB, 'IndexEL',  1, 'SendEL2', 'All', 'UpdateEEG', 'on', 'Voutput', 'EEG' ); % GUI: 28-May-2019 11:12:06
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    EEG = pop_epochbin( EEG , [-200.0  800.0],  'pre'); % GUI: 28-May-2019 11:14:08
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet+3,'savenew',setBinned,'gui','off');
    % perform artifact rejection
    EEG = eeg_checkset( EEG );
    if setNum == 1
        EEG = pop_rejepoch( EEG, [ 59 74 75 114 119 171 201 236 237 267 276 290] ,0);
    elseif setNum == 2
        EEG = pop_rejepoch( EEG, [ 19 22 44 79 81 84 129 164 169 202 212 232 251 274 280 285] ,0);
    elseif setNum == 3
        EEG = pop_rejepoch( EEG, [ 2 5 59 60 64 65 66 67 68 69 70 71 73 75 94 99 122 133 134 155 159 172 181 191 194 195 196 197 198 201 216 231 232 236 263 264 265 266 267 269 270 279 280 281 282 285 286 287 288 289 290 291 292 294 295 296 297 300] ,0);
    elseif setNum == 4
        EEG = pop_rejepoch( EEG, [ 4 12 14 17 25 37 39 44 63 65 71 82 85 118 147 148 180 217 218 246 247 288 300] ,0);
    elseif setNum == 5
        EEG = pop_rejepoch( EEG, [ 1 7 11 12 14 17 18 19 20 21 22 23 32 53 64 65 66 73 94 96 98 101 102 103 105 123 124 125 126 149 150 151 152 153 161 167 168 179 184 195 196 197 212 216 222 242 245 252 257 270 271 290] ,0);
    elseif setNum == 6
        EEG = pop_rejepoch( EEG, [ 10 14 43 70 71 114 122 170 171 172 180 185 186 215 218 222 239 250 263 269 276 286] ,0);
    elseif setNum == 7
        EEG = pop_rejepoch( EEG, [ 4 11 14 19 23 28 30 72 92 146 160 179 181 203 216 217 220 249 261] ,0);
    elseif setNum == 8
        EEG = pop_rejepoch( EEG, [ 23 28 39 43 67 97 103 107 110 116 123 124 131 140 152 178 184 185 188 195 203 213 214 215 216 220 243 248 255 257 261 267 285] ,0);
    elseif setNum == 9
        EEG = pop_rejepoch( EEG, [ 1 2 3 4 6 7 13 14 16 17 18 19 20 21 22 23 24 25 27 28 29 30 31 33 34 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 82 85 87 89 90 91 92 93 94 95 102 103 104 105 112 113 114 115 116 117 118 119 120 121 122 124 126 127 128 129 131 132 133 135 138 139 140 141 142 143 163 164 165 167 173 191 195 196 197 198 199 200 201 202 206 207 229 230 231 232 241 253 267 268 300] ,0);
    end
    
    % if setNum == 1
    %     EEG = pop_rejepoch( EEG, [ 59 75 114 197 203 236 237 276 290] ,0);
    % elseif setNum == 2
    %     EEG = pop_rejepoch( EEG, [ 16 22 79 81 84 86 103 129 162 164 202 212 227 232 251 274 280 284 285] ,0);
    % elseif setNum == 3
    %     EEG = pop_rejepoch( EEG, [ 2 5 59 60 64 65 66 67 68 69 70 71 73 75 81 94 99 110 133 134 159 172 181 188 191 194 195 196 197 198 201 231 236 263 264 265 266 267 269 270 279 280 281 282 285 286 287 288 289 290 291 292 294 295 296 297 299 300] ,0);
    % elseif setNum == 4
    %     EEG = pop_rejepoch( EEG, [ 4 6 12 14 37 39 44 63 65 66 71 77 82 85 118 137 147 148 180 217 218 237 246 288 300] ,0);
    % elseif setNum == 5
    %     EEG = pop_rejepoch( EEG, [ 1 7 11 12 14 17 18 19 20 21 22 23 32 53 64 65 66 73 91 94 98 101 102 103 105 123 126 149 150 151 152 153 167 195 196 197 212 216 222 230 242 245 256 270 271 280 290] ,0);
    % elseif setNum == 6
    %     EEG = pop_rejepoch( EEG, [ 8 10 11 14 17 37 43 70 71 114 122 137 170 171 172 180 185 186 206 215 218 222 239 263 286] ,0);
    % elseif setNum == 7
    %     EEG = pop_rejepoch( EEG, [ 14 19 28 30 41 72 92 146 181 203 216 217 220 249 252 261] ,0);
    % elseif setNum == 8
    %     EEG = pop_rejepoch( EEG, [ 28 31 32 39 43 44 57 67 77 97 103 107 110 116 123 124 131 133 140 178 184 185 188 195 203 213 214 215 216 220 248 255 257 258 261 267] ,0);
    % elseif setNum == 9
    %     EEG = pop_rejepoch( EEG, [ 1 2 3 4 6 7 13 14 16 17 18 19 20 21 22 23 24 25 27 28 29 30 31 33 34 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 82 85 87 89 90 91 92 93 94 95 97 100 102 103 104 105 112 113 114 115 116 117 118 119 120 121 122 124 126 127 128 129 131 132 133 138 139 140 141 142 143 152 163 164 165 167 171 173 195 196 197 198 199 200 201 202 206 207 229 230 231 232 241 284 300] ,0);
    % end
    
    % x1_new =
    %
    % EEG = pop_rejepoch( EEG, [ 59 75 114 197 203 236 237 276 290] ,0);
    %
    %
    % x2_new =
    %
    % EEG = pop_rejepoch( EEG, [ 16 22 79 81 84 86 103 129 162 164 202 212 227 232 251 274 280 284 285] ,0);
    %
    %
    % x3_new =
    %
    % EEG = pop_rejepoch( EEG, [ 2 5 59 60 64 65 66 67 68 69 70 71 73 75 81 94 99 110 133 134 159 172 181 188 191 194 195 196 197 198 201 231 236 263 264 265 266 267 269 270 279 280 281 282 285 286 287 288 289 290 291 292 294 295 296 297 299 300] ,0);
    %
    %
    % x4_new =
    %
%     EEG = pop_rejepoch( EEG, [ 4 6 12 14 37 39 44 63 65 66 71 77 82 85 118 137 147 148 180 217 218 237 246 288 300] ,0);
%     %
%     %
%     % x5_new =
%     %
%     EEG = pop_rejepoch( EEG, [ 1 7 11 12 14 17 18 19 20 21 22 23 32 53 64 65 66 73 91 94 98 101 102 103 105 123 126 149 150 151 152 153 167 195 196 197 212 216 222 230 242 245 256 270 271 280 290] ,0);
%     %
%     %
%     % x6_new =
%     %
%     EEG = pop_rejepoch( EEG, [ 8 10 11 14 17 37 43 70 71 114 122 137 170 171 172 180 185 186 206 215 218 222 239 263 286] ,0);
%     %
%     %
%     % x7_new =
%     %
%     EEG = pop_rejepoch( EEG, [ 14 19 28 30 41 72 92 146 181 203 216 217 220 249 252 261] ,0);
%     %
%     %
%     % x8_new =
%     %
%     EEG = pop_rejepoch( EEG, [ 28 31 32 39 43 44 57 67 77 97 103 107 110 116 123 124 131 133 140 178 184 185 188 195 203 213 214 215 216 220 248 255 257 258 261 267] ,0);
%     %
%     %
%     % x9_new =
%     %
%     EEG = pop_rejepoch( EEG, [ 1 2 3 4 6 7 13 14 16 17 18 19 20 21 22 23 24 25 27 28 29 30 31 33 34 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 74 75 76 77 78 82 85 87 89 90 91 92 93 94 95 97 100 102 103 104 105 112 113 114 115 116 117 118 119 120 121 122 124 126 127 128 129 131 132 133 138 139 140 141 142 143 152 163 164 165 167 171 173 195 196 197 198 199 200 201 202 206 207 229 230 231 232 241 284 300] ,0);
%     
    %%
    % EEG = eeg_checkset( EEG );
    % EEG = pop_eegthresh(EEG,0,[1:7] ,[-75 -25] ,[75 25] ,[-0.2 -0.1] ,[0.79667 0] ,2,0);
    % EEG = pop_rejtrend(EEG,0,[1:7] ,300,50,0.3,2,0);
    % promptRejNum = 'enter the number of epochs rejected by trend: ';
    % rejTrend_num = input(promptRejNum);
    % promptRej = 'enter the epoch number: ';
    % for i = 1:numel(rejTrend_num)+1
    %     rejTrend(i) = input(promptRej);
    % end
    % EEG = pop_jointprob(EEG,0,[1:7],5,5,0,1,[],0);
    % rejJointProb = find(TMPREJ);
    % EEG = pop_rejkurt(EEG,0,[1:7],5,5,0,1,[],0);
    % rejKurt = find(TMPREJ);
    % % EEG = pop_jointprob(EEG,0,[1:7],5,5,0,0,set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'mantrial'), 'string', num2str(sum(EEG.reject.icarejmanual))); set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'threshtrial'), 'string', num2str(sum(EEG.reject.icarejthresh))) ; set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'freqtrial'), 'string', num2str(sum(EEG.reject.icarejfreq))) ; set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'consttrial'), 'string', num2str(sum(EEG.reject.icarejconst))) ; set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'enttrial'), 'string', num2str(sum(EEG.reject.icarejjp))) ;set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'kurttrial'), 'string', num2str(sum(EEG.reject.icarejkurt))),[],0);
    % % EEG = pop_rejkurt(EEG,0,[1:7] ,5,5,0,0,
    % %     set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'mantrial'), 'string', num2str(sum(EEG.reject.icarejmanual)));
    % %     set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'threshtrial'), 'string', num2str(sum(EEG.reject.icarejthresh)));
    % %     set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'freqtrial'), 'string', num2str(sum(EEG.reject.icarejfreq)));
    % %     set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'consttrial'), 'string', num2str(sum(EEG.reject.icarejconst)));
    % %     set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'enttrial'), 'string', num2str(sum(EEG.reject.icarejjp)));
    % %     set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'kurttrial'), 'string', num2str(sum(EEG.reject.icarejkurt)));
    % %     '',[],0);
    % EEG = pop_rejspec(EEG,0,'elecrange',[1:7] ,'method','multitaper','threshold',[-50 50;-100 25],'freqlimits',[0 2;20 40],'eegplotplotallrej',2,'eegplotreject',0);
    % % EEG = pop_rejspec( EEG, 0,'elecrange',[1:7] ,'method','multitaper','threshold',[-50 50;-100 25],'freqlimits',[0 2;20 40],'eegplotcom','
    % % set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'mantrial'), 'string', num2str(sum(EEG.reject.icarejmanual)));
    % % set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'threshtrial'), 'string', num2str(sum(EEG.reject.icarejthresh)));
    % % set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'freqtrial'), 'string', num2str(sum(EEG.reject.icarejfreq)));
    % % set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'consttrial'), 'string', num2str(sum(EEG.reject.icarejconst)));
    % % set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'enttrial'), 'string', num2str(sum(EEG.reject.icarejjp)));
    % % set(findobj('parent', findobj('tag', 'rejtrialica'), 'tag', 'kurttrial'), 'string', num2str(sum(EEG.reject.icarejkurt)));','eegplotplotallrej',2,'eegplotreject',0);
    % EEG = eeg_rejsuperpose( EEG, 0, 1, 1, 1, 1, 1, 1, 1);
    % EEG = pop_rejepoch( EEG, [5 46 47 134 142 169 193 200 207 225 226 230 258 272 285] ,0);
    % EEG = pop_rejepoch( EEG, [4 11 12 16 24 25 26 30 33 34 36 39 41 42 43 46 47 49 51 52 53 55 56 60 61 62 64 67 69 70 71 73 87 89 90 94 96 98 99 101 105 106 110 113 114 115 116 117 119 124 125 129 130 132 133 135 138 139 140 141 142 146 148 149 150 153 159 160 161 163 165 166 167 168 170 174 176 177 179 184 186 187 189 191 192 196 197 198 199 212 215 218 219 222 229 230 234 237 238 239 240 241 245 251 254 259 260 262 263 264 265 266 267 270 271 274 275 276 280 287 292 293 299 300] ,0;
    %% save & epoch bins
    % pause
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet+4,'savenew',setEpoched,'saveold',setBinned,'gui','off');
    ERP = pop_averager( ALLEEG , 'Criterion', trialsTxt,...
        'DSindex',  startSet+5, 'ExcludeBoundary', 'on', 'SEM', 'on' );
    ERP = pop_savemyerp(ERP, 'erpname',...
        erpName, 'filename', erpFilename,...
        'filepath', filePath, 'Warning', 'on');
    ERP = pop_ploterps( ERP, [ 1 2],  1:7 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 3 3], 'ChLabel',...
        'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r--' }, 'LineWidth',  1, 'Maximize',...
        'on', 'Position', [ 103.714 17.7059 106.857 32], 'SEM', 'on', 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0.5, 'xscale',...
        [ -200.0 796.0   -200:200:600 ], 'YDir', 'normal' );
    pop_export2text( ERP, erpText,...
        [ 1 2], 'electrodes', 'on', 'precision',  10, 'time', 'on', 'timeunit',  0.001 );
    fnm = sprintf('erp_%s.fig',setName);
    savefig(fnm)
    
    % save stuff
    eq_naccepted = ERP.ntrials;
    eq_ntotal = ERP.EVENTLIST.trialsperbin;
    eq_info = ERP.history;
    fnm = sprintf('eq_info_part2_%s.mat',setName);
    cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S003\redoEq'
    save(fnm,'eq_naccepted','eq_ntotal','eq_info','-mat');

end
%%
% EEG = pop_importdata('data','tbl_filt_a_b_2_tr','dataformat','array');
% EEG = pop_editset(EEG);
% EEG = pop_chanevent(EEG, 8);
% eeg_checkset
% pop_editset() % 'C:\Users\mswerdloff\eeglab14_1_2b\chanlocsDSI7.ced'
% readlocs() % 'chanedit' format assumed from file extension
% EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist',...
%  'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T4\Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_EventListA.txt' ); % GUI: 08-Apr-2019 15:02:09
% EEG  = pop_binlister( EEG , 'BDF', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\EEG_data_withTriggers\binlist6.txt',...
%  'ExportEL', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T4\Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_EventListB.txt',...
%  'IndexEL',  1, 'SendEL2', 'All', 'UpdateEEG', 'on', 'Voutput', 'EEG' ); % GUI: 08-Apr-2019 15:02:57
% EEG = pop_epochbin( EEG , [-200.0  800.0],  'pre'); % GUI: 08-Apr-2019 15:03:20
% EEG  = pop_artmwppth( EEG , 'Channel',  1:7, 'Flag',  1, 'Threshold',  100, 'Twindow', [ -200 796.7], 'Windowsize',  200, 'Windowstep',...
%   100 ); % GUI: 08-Apr-2019 15:03:40
% ERP = pop_averager( ALLEEG , 'Criterion', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T4\trials84.txt',...
%  'DSindex',  5, 'ExcludeBoundary', 'on', 'SEM', 'on' );
% ERP = pop_savemyerp(ERP, 'erpname',...
%  'erpset_Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_84', 'filename',...
%  'erpset_Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_84.erp', 'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T4',...
%  'Warning', 'on');
% ERP = pop_ploterps( ERP, [ 1 2],  1:7 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 3 3], 'ChLabel',...
%  'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r--' }, 'LineWidth',  1, 'Maximize',...
%  'on', 'Position', [ 103.714 17.7059 106.857 32], 'SEM', 'on', 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0.5, 'xscale',...
%  [ -200.0 796.0   -200:200:600 ], 'YDir', 'normal' );
% pop_export2text( ERP, 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T4\Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials.txt',...
%  [ 1 2], 'electrodes', 'on', 'precision',  10, 'time', 'on', 'timeunit',  0.001 );
% %% first 26
% ERP = pop_averager( ALLEEG , 'Criterion', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T5\trials_first26.txt',...
%  'DSindex',  5, 'ExcludeBoundary', 'on', 'SEM', 'on' );
% ERP = pop_savemyerp(ERP, 'erpname',...
%  'erpset_Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_first26', 'filename',...
%  'erpset_Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_first26.erp', 'filepath',...
%  'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T5', 'Warning',...
%  'on');
% ERP = pop_ploterps( ERP, [ 1 2],  1:7 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 3 3], 'ChLabel',...
%  'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r--' }, 'LineWidth',  1, 'Maximize',...
%  'on', 'Position', [ 103.714 17.7059 106.857 32], 'SEM', 'on', 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0.5, 'xscale',...
%  [ -200.0 796.0   -200:200:600 ], 'YDir', 'normal' );
% pop_export2text( ERP, 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T4\Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_first26.txt',...
%  [ 1 2], 'electrodes', 'on', 'precision',  10, 'time', 'on', 'timeunit',  0.001 );
% %% last 26
% ERP = pop_averager( ALLEEG , 'Criterion', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T6\trials_last26.txt',...
%  'DSindex',  5, 'ExcludeBoundary', 'on', 'SEM', 'on' );
% ERP = pop_savemyerp(ERP, 'erpname',...
%  'erpset_Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_last26', 'filename',...
%  'erpset_Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_last26.erp', 'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T6',...
%  'Warning', 'on');
% ERP = pop_ploterps( ERP, [ 1 2],  1:7 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 3 3], 'ChLabel',...
%  'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r--' }, 'LineWidth',  1, 'Maximize',...
%  'on', 'Position', [ 103.714 17.7059 106.857 32], 'SEM', 'on', 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0.5, 'xscale',...
%  [ -200.0 796.0   -200:200:600 ], 'YDir', 'normal' );
% pop_export2text( ERP, 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Troubleshooting3_05Hz_30Hz\Sit\stim 1 ISI 375 jitter\T6\Maggie_Sit_TTHigh_ArduinoRecording_15min_1sISI_375msjitter_filt_a_b_2_allTrials_last26.txt',...
%  [ 1 2], 'electrodes', 'on', 'precision',  10, 'time', 'on', 'timeunit',  0.001 );
% %%
% ERP = pop_exporterplabfigure( ERP , 'Filepath', 'C:\Users\mswerdloff\eeglab14_1_2b', 'Format', 'pdf', 'Resolution',  1200, 'SaveMode', 'saveas',...
%  'Tag', {'ERP_figure' } );