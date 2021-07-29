%%
clear
subs = {'S003','S006','S007','S008','S009','S010','S012','S013','S014'};
% now, put everything into the original format
for i = 1:numel(subs)
% close all
load('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\codes_allSubs.mat') %codes
load('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\Pilot2_rejectedAcceptedTrials_allSubs_eq.mat') %codes
sub = subs{i};
loc_sub = strcat('Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2\',sub);
filename = strcat(loc_sub,'\rejectedAcceptedTrials_',sub,'_eq.mat');
% load(filename)
cd(loc_sub)
loc_sit = strcat(loc_sub,'\sit'); % source folder
% if ~exist('redoEq10_avg', 'dir') % create destination folder if it doesn't already exist
%   mkdir('redoEq10_avg');
% end
 filePath = strrep(loc_sit,'sit','redoEq9_avg'); % destination folder

loc_stand = strrep(loc_sit,'sit','stand');
loc_walk = strrep(loc_sit,'sit','walk');

clearvars x_all_combined x_all codes_all

if i == 1
    x_all_combined = table2array(RejectedTrials_S003_eq);
    codes_all = codes_all_S003;
elseif i == 2
    x_all_combined = table2array(RejectedTrials_S005_eq);
    codes_all = codes_all_S005;
elseif i == 3
    x_all_combined = table2array(RejectedTrials_S006_eq);
    codes_all = codes_all_S006;
elseif i == 4
    x_all_combined = table2array(RejectedTrials_S007_eq);
    codes_all = codes_all_S007;
elseif i == 5
    x_all_combined = table2array(RejectedTrials_S008_eq);
    codes_all = codes_all_S008;
elseif i == 6
    x_all_combined = table2array(RejectedTrials_S009_eq);
    codes_all = codes_all_S009;
elseif i == 7
    x_all_combined = table2array(RejectedTrials_S010_eq);
    codes_all = codes_all_S010;
elseif i == 8
    x_all_combined = table2array(RejectedTrials_S012_eq);
    codes_all = codes_all_S012;
elseif i == 9
    x_all_combined = table2array(RejectedTrials_S013_eq);
    codes_all = codes_all_S013;
elseif i == 10
    x_all_combined = table2array(RejectedTrials_S014_eq);
    codes_all = codes_all_S014;
end

x_all = [x_all_combined(1:301,1) x_all_combined(302:602,1) x_all_combined(603:903,1) x_all_combined(1:301,2) x_all_combined(302:602,2) x_all_combined(603:903,2) x_all_combined(1:301,3) x_all_combined(302:602,3) x_all_combined(603:903,3)];

% clearvars x_new x_new_string_pt2
% x_new = find(x_all(2:end,1));     x_new_string_pt1 = sprintf('EEG = pop_rejepoch( EEG, [');     x_new_string_pt2 = sprintf(' %d', x_new);    x_new_string_pt3 = sprintf('] ,0);');
% x1_new = [x_new_string_pt1 x_new_string_pt2 x_new_string_pt3]
% 
% clearvars x_new x_new_string_pt2
% x_new = find(x_all(2:end,2));     x_new_string_pt1 = sprintf('EEG = pop_rejepoch( EEG, [');     x_new_string_pt2 = sprintf(' %d', x_new);    x_new_string_pt3 = sprintf('] ,0);');
% x2_new = [x_new_string_pt1 x_new_string_pt2 x_new_string_pt3]
% 
% clearvars x_new x_new_string_pt2
% x_new = find(x_all(2:end,3));     x_new_string_pt1 = sprintf('EEG = pop_rejepoch( EEG, [');     x_new_string_pt2 = sprintf(' %d', x_new);    x_new_string_pt3 = sprintf('] ,0);');
% x3_new = [x_new_string_pt1 x_new_string_pt2 x_new_string_pt3]
% 
% clearvars x_new x_new_string_pt2
% x_new = find(x_all(2:end,4));     x_new_string_pt1 = sprintf('EEG = pop_rejepoch( EEG, [');     x_new_string_pt2 = sprintf(' %d', x_new);    x_new_string_pt3 = sprintf('] ,0);');
% x4_new = [x_new_string_pt1 x_new_string_pt2 x_new_string_pt3]
% 
% clearvars x_new x_new_string_pt2
% x_new = find(x_all(2:end,5));     x_new_string_pt1 = sprintf('EEG = pop_rejepoch( EEG, [');     x_new_string_pt2 = sprintf(' %d', x_new);    x_new_string_pt3 = sprintf('] ,0);');
% x5_new = [x_new_string_pt1 x_new_string_pt2 x_new_string_pt3]
% 
% clearvars x_new x_new_string_pt2
% x_new = find(x_all(2:end,6));     x_new_string_pt1 = sprintf('EEG = pop_rejepoch( EEG, [');     x_new_string_pt2 = sprintf(' %d', x_new);    x_new_string_pt3 = sprintf('] ,0);');
% x6_new = [x_new_string_pt1 x_new_string_pt2 x_new_string_pt3]
% 
% clearvars x_new x_new_string_pt2
% x_new = find(x_all(2:end,7));     x_new_string_pt1 = sprintf('EEG = pop_rejepoch( EEG, [');     x_new_string_pt2 = sprintf(' %d', x_new);    x_new_string_pt3 = sprintf('] ,0);');
% x7_new = [x_new_string_pt1 x_new_string_pt2 x_new_string_pt3]
% 
% clearvars x_new x_new_string_pt2
% x_new = find(x_all(2:end,8));     x_new_string_pt1 = sprintf('EEG = pop_rejepoch( EEG, [');     x_new_string_pt2 = sprintf(' %d', x_new);    x_new_string_pt3 = sprintf('] ,0);');
% x8_new = [x_new_string_pt1 x_new_string_pt2 x_new_string_pt3]
% 
% clearvars x_new x_new_string_pt2
% x_new = find(x_all(2:end,9));     x_new_string_pt1 = sprintf('EEG = pop_rejepoch( EEG, [');     x_new_string_pt2 = sprintf(' %d', x_new);    x_new_string_pt3 = sprintf('] ,0);');
% x9_new = [x_new_string_pt1 x_new_string_pt2 x_new_string_pt3]
% 
% x_new_struct.execTrials = {x1_new,x2_new,x3_new,x4_new,x5_new,x6_new,x7_new,x8_new,x9_new};
% 
% % pause
% %% move to EEGLAB
% cd 'C:\Users\mswerdloff\eeglab14_1_2b'
% %cd 'C:\Users\maggi\Documents\MATLAB\eeglab14_1_2b'
% eeglab
% %% specify filename
% cd(loc_sub)
% loc_sit = strcat(loc_sub,'\sit'); % source folder
% if ~exist('redoEq10_avg', 'dir') % create destination folder if it doesn't already exist
%   mkdir('redoEq10_avg');
% end
%  filePath = strrep(loc_sit,'sit','redoEq10_avg'); % destination folder
% 
% loc_stand = strrep(loc_sit,'sit','stand');
% loc_walk = strrep(loc_sit,'sit','walk');
% 
% cd(loc_sit)
% Files_sit = dir('*2_allTrials.mat'); % choose 1, 2, or 4 for the order of the butterworth filter
% for k=1:length(Files_sit)
%    filename=Files_sit(k).name % file to be converted
%    if strfind(filename, 'A')
%         Files_sit(k).session = 'A';
%    elseif strfind(filename, 'B')
%        Files_sit(k).session = 'B';
%    elseif strfind(filename, 'C')
%        Files_sit(k).session = 'C';
%    end
% end
% T = struct2table(Files_sit); % convert the struct array to a table
% aa_t = sortrows(T, 'session'); % sort the table by session
% 
% cd(loc_stand)
% Files_stand = dir('*2_allTrials.mat');
% for k=1:length(Files_stand)
%    filename=Files_stand(k).name % file to be converted
%    if strfind(filename, 'A')
%         Files_stand(k).session = 'A';
%    elseif strfind(filename, 'B')
%        Files_stand(k).session = 'B';
%    elseif strfind(filename, 'C')
%        Files_stand(k).session = 'C';
%    end
% end
% T = struct2table(Files_stand); % convert the struct array to a table
% bb_t = sortrows(T, 'session'); % sort the table by session
% 
% cd(loc_walk)
% Files_walk = dir('*2_allTrials.mat');
% for k=1:length(Files_stand)
%    filename=Files_walk(k).name % file to be converted
%    if strfind(filename, 'A')
%         Files_walk(k).session = 'A';
%    elseif strfind(filename, 'B')
%        Files_walk(k).session = 'B';
%    elseif strfind(filename, 'C')
%        Files_walk(k).session = 'C';
%    end
% end
% T = struct2table(Files_walk); % convert the struct array to a table
% cc_t = sortrows(T, 'session'); % sort the table by session
% 
% % Concatenate tables
% merge_t = [aa_t;bb_t;cc_t];
% % Convert table to structure
% Files = table2struct(merge_t)
% 
% for k=1:length(Files)   
%     filename=Files(k).name % file to be converted
%     % choose source folder
%     if k == 1 || k == 2 || k ==3
%         location2 = loc_sit;
%     elseif k == 4 || k == 5 || k == 6
%         location2 = loc_stand;
%     elseif k == 7 || k == 8 || k == 9
%         location2 = loc_walk;
%     end
%     
%     setNum = k;
%     
%     location = strcat(location2,'\',filename);
%     setName = strrep(filename,'.mat','_eq10');
%     erpName = strcat('erpset_',setName,'_ICA_Num');
%     filename_info = strrep(location,'.mat','_eq10_info_pt2.mat');
%     erpFilename = strrep(erpName,'_ICA_Num','_ICA_Num.erp');
%     eventlistA = strrep(location,'.mat','_eq10_ICA_EventListA.txt');
%     eventlistB = strrep(location,'.mat','_eq10_ICA_EventListB.txt');
%     startSet = 0;
%     setICA = strrep(location,'.mat','_eq10_ICA.set');
%     setBinned = strrep(location,'.mat','_eq10_ICA_elist_bins.set');
%     setEpoched = strrep(location,'.mat','_eq10_ICA_elist_bins_be.set');
%     trialsTxt = strrep(location,'.mat','eq10_trialsNum.txt');
%     erpText = strrep(location,'.mat','_eq10_ICA_Num.txt');
%     %% open new set
%     [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
%     EEG = pop_importdata('dataformat','matlab','nbchan',0,'data',location,'setname',setName,'srate',300,'pnts',0,'xmin',0);
%     [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet,'gui','off');
%     EEG = eeg_checkset( EEG );
%     EEG = pop_chanevent(EEG, 8,'edge','leading','edgelen',0);
%     [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
%     EEG = eeg_checkset( EEG );
%     EEG = pop_editset(EEG, 'chanlocs', 'C:\Users\mswerdloff\eeglab14_1_2b\chanlocsDSI7.ced');
%     [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
%     % EEG = pop_runica(EEG, 'extended',startSet,'interupt','on');
%     % [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
%     [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet+1,'savenew',setICA,'gui','off');
%     % open existing set
%     %EEG = pop_loadset('filename','S006_stand_walk_sit_C_0001_filt_a_b_2_allTrials_ICA_elist_bins_be.set','filepath','Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S006\walk\');
%     %
%     EEG  = pop_creabasiceventlist( EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' }, 'Eventlist', eventlistA ); % GUI: 28-May-2019 11:10:03
%     [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet+2,'gui','off');
%     EEG  = pop_binlister( EEG , 'BDF', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\EEG_data_withTriggers\binlist6.txt', 'ExportEL', eventlistB, 'IndexEL',  1, 'SendEL2', 'All', 'UpdateEEG', 'on', 'Voutput', 'EEG' ); % GUI: 28-May-2019 11:12:06
%     [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
%     EEG = pop_epochbin( EEG , [-200.0  800.0],  'pre'); % GUI: 28-May-2019 11:14:08
%     [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet+3,'savenew',setBinned,'gui','off');
%     % perform artifact rejection
%     EEG = eeg_checkset( EEG );
% %     if setNum == 1
% %         EEG = pop_rejepoch( EEG, [ 2 32 48 59 71 80 86 87 89 98 104 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 142 149 150 151 155 156 157 158 159 166 167 176 177 184 186 201 218 226 232 236 238 244 246 257 258 259 262 264 269 272 275 295] ,0);
% %     elseif setNum == 2
% %         EEG = pop_rejepoch( EEG, [ 2 4 6 20 21 24 25 30 31 32 33 34 37 38 39 40 45 46 47 50 58 59 60 61 62 72 73 74 81 84 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122 123 124 125 126 127 138 139 146 147 152 160 161 162 169 182 185 186 190 194 195 196 197 199 207 208 209 210 211 212 215 219 221 226 227 228 229 231 235 237 242 247 258 259 260 276 286 288 293] ,0);
% %     elseif setNum == 3
% %         EEG = pop_rejepoch( EEG, [ 20 40 45 51 64 68 70 72 76 77 78 94 95 98 103 104 106 109 120 139 140 156 157 188 197 198 201 202 205 207 210 214 233 246 247 252 258 269 277 292 295] ,0);
% %     elseif setNum == 4
% %         EEG = pop_rejepoch( EEG, [ 1 4 7 15 25 54 61 66 75 77 90 91 109 113 114 119 122 133 143 144 165 167 176 178 186 197 199 204 219 223 228 233 248 276 279 288 292] ,0);
% %     elseif setNum == 5
% %         EEG = pop_rejepoch( EEG, [ 4 7 13 26 33 39 57 58 59 61 63 65 66 78 80 106 114 115 116 118 120 121 133 136 137 141 147 156 159 168 171 179 185 187 208 209 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 233 234 235 236 237 238 239 240 241 242 243 244 245 246 247 248 249 250 251 252 253 254 255 256 257 258 259 260 261 262 263 264 265 266 267 268 269 270 272 273 286 288 289 297 298] ,0);
% %     elseif setNum == 6
% %         EEG = pop_rejepoch( EEG, [ 1 2 3 4 5 6 7 8 14 16 21 22 25 26 36 38 48 52 56 63 66 71 72 73 74 79 80 81 82 83 84 85 86 87 88 89 90 91 92 100 101 102 109 113 122 123 135 136 137 140 142 143 144 145 146 147 148 149 150 151 152 153 154 156 159 161 170 174 183 186 189 190 191 192 200 202 203 212 219 220 225 229 231 232 233 234 235 236 239 243 245 246 247 249 250 251 260 264 272 273 282 285 286 288 291 292 293 295 298] ,0);
% %     elseif setNum == 7
% %         EEG = pop_rejepoch( EEG, [ 4 5 13 14 15 16 17 18 19 20 21 32 42 43 51 58 59 60 61 62 63 64 65 66 67 68 69 70 71 72 73 78 82 87 88 89 90 91 92 94 95 96 97 98 99 100 101 102 103 104 105 106 107 108 114 116 125 129 144 145 150 151 157 161 163 165 168 169 172 173 177 183 185 187 188 190 195 196 197 198 199 205 206 213 214 216 220 222 224 225 226 228 232 233 235 236 240 241 245 247 248 249 251 253 254 258 261 263 264 266 267 268 269 271 275 276 277 279 280 282 283 284 287 288 289 290 291 292 294 299 300] ,0);
% %     elseif setNum == 8
% %         EEG = pop_rejepoch( EEG, [ 1 2 3 5 7 8 10 12 13 16 17 18 19 20 21 23 26 28 30 31 32 33 34 35 36 37 38 39 40 41 43 44 47 51 54 55 56 60 61 62 64 66 67 69 70 72 75 76 78 80 82 83 87 88 90 91 93 96 99 101 102 104 108 109 114 118 119 120 121 122 123 124 125 126 128 129 131 132 133 134 135 138 139 146 147 149 150 151 152 153 154 155 156 158 159 160 161 162 164 165 167 168 169 170 171 172 173 174 175 176 177 178 180 181 182 185 186 187 188 189 191 192 197 199 200 201 202 203 205 207 208 209 210 213 217 218 219 220 221 222 223 224 225 226 227 228 229 230 231 232 234 240 241 242 243 244 245 246 247 248 250 251 252 253 254 255 256 257 258 259 260 261 262 264 265 267 268 271 272 273 274 276 277 280 281 284 285 286 287 289 290 291 292 293 294 295 296 297 298 300] ,0);
% %     elseif setNum == 9
% %         EEG = pop_rejepoch( EEG, [ 1 3 4 6 9 11 14 16 22 24 25 26 27 32 33 34 35 38 39 51 52 53 54 59 60 63 66 67 69 70 73 84 86 87 96 102 105 107 114 119 120 121 123 124 125 128 129 130 131 132 133 134 135 136 137 138 139 140 142 143 145 146 147 151 152 153 154 155 156 157 158 159 160 162 163 164 165 166 167 168 169 171 172 176 180 183 184 185 195 198 206 208 222 226 236 238 239 240 242 247 248 250 252 256 268 271 290] ,0);
% %     end
%     eval(x_new_struct.execTrials{setNum});
% 
%     %% save & epoch bins
%     % pause
%     [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, startSet+4,'savenew',setEpoched,'saveold',setBinned,'gui','off');
%     ERP = pop_averager( ALLEEG , 'Criterion', trialsTxt,...
%         'DSindex',  startSet+5, 'ExcludeBoundary', 'on', 'SEM', 'on' );
%     ERP = pop_savemyerp(ERP, 'erpname',...
%         erpName, 'filename', erpFilename,...
%         'filepath', filePath, 'Warning', 'on');
%     ERP = pop_ploterps( ERP, [ 1 2],  1:7 , 'AutoYlim', 'on', 'Axsize', [ 0.05 0.08], 'BinNum', 'on', 'Blc', 'pre', 'Box', [ 3 3], 'ChLabel',...
%         'on', 'FontSizeChan',  10, 'FontSizeLeg',  12, 'FontSizeTicks',  10, 'LegPos', 'bottom', 'Linespec', {'k-' , 'r--' }, 'LineWidth',  1, 'Maximize',...
%         'on', 'Position', [ 103.714 17.7059 106.857 32], 'SEM', 'on', 'Style', 'Classic', 'Tag', 'ERP_figure', 'Transparency',  0.5, 'xscale',...
%         [ -200.0 796.0   -200:200:600 ], 'YDir', 'normal' );
%     pop_export2text( ERP, erpText,...
%         [ 1 2], 'electrodes', 'on', 'precision',  10, 'time', 'on', 'timeunit',  0.001 );
%     fnm = sprintf('erp_%s.fig',setName);
%     cd(filePath)
%     savefig(fnm)
%     
%     % save stuff
%     eq_naccepted = ERP.ntrials;
%     eq_ntotal = ERP.EVENTLIST.trialsperbin;
%     eq_info = ERP.history;
%     fnm = sprintf('eq_info_part2_%s.mat',setName);
%     cd(filePath)
%     save(fnm,'eq_naccepted','eq_ntotal','eq_info','-mat');
% 
% end
%%
clearvars Files

cd(loc_sit)
Files_sit = dir('*eq9_ICA_Num_Target.txt'); % choose 1, 2, or 4 for the order of the butterworth filter
for k=1:length(Files_sit)
   filename=Files_sit(k).name % file to be converted
   if strfind(filename, '_A_')
        Files_sit(k).session = '_A_';
   elseif strfind(filename, '_B_')
       Files_sit(k).session = '_B_';
   elseif strfind(filename, '_C_')
       Files_sit(k).session = '_C_';
   end
end
T = struct2table(Files_sit); % convert the struct array to a table
aa_t = sortrows(T, 'session'); % sort the table by session

cd(loc_stand)
Files_stand = dir('*eq9_ICA_Num_Target.txt');
for k=1:length(Files_stand)
   filename=Files_stand(k).name % file to be converted
   if strfind(filename, '_A_')
        Files_stand(k).session = '_A_';
   elseif strfind(filename, '_B_')
       Files_stand(k).session = '_B_';
   elseif strfind(filename, '_C_')
       Files_stand(k).session = '_C_';
   end
end
T = struct2table(Files_stand); % convert the struct array to a table
bb_t = sortrows(T, 'session'); % sort the table by session

cd(loc_walk)
Files_walk = dir('*eq9_ICA_Num_Target.txt');
for k=1:length(Files_stand)
   filename=Files_walk(k).name % file to be converted
   if strfind(filename, '_A_')
        Files_walk(k).session = '_A_';
   elseif strfind(filename, '_B_')
       Files_walk(k).session = '_B_';
   elseif strfind(filename, '_C_')
       Files_walk(k).session = '_C_';
   end
end
T = struct2table(Files_walk); % convert the struct array to a table
cc_t = sortrows(T, 'session'); % sort the table by session

% Concatenate tables
merge_t = [aa_t;bb_t;cc_t];

if size(merge_t,1) ~= 9
    pause
end
% Convert table to structure
Files = table2struct(merge_t)

cd(loc_sit)
sitA = importTarget(Files(1).name);
sitB = importTarget(Files(2).name);
sitC = importTarget(Files(3).name);
cd(loc_stand)
standA = importTarget(Files(4).name);
standB = importTarget(Files(5).name);
standC = importTarget(Files(6).name);
cd(loc_walk)
walkA = importTarget(Files(7).name);
walkB = importTarget(Files(8).name);
walkC = importTarget(Files(9).name);

cd(filePath)

time = table2array(sitA(1,2:end));
Pz_SitA = table2array(sitA(2,2:end));
Pz_SitB = table2array(sitB(2,2:end));
Pz_SitC = table2array(sitC(2,2:end));
Pz_StandA = table2array(standA(2,2:end));
Pz_StandB = table2array(standB(2,2:end));
Pz_StandC = table2array(standC(2,2:end));
Pz_TreadA = table2array(walkA(2,2:end));
Pz_TreadB = table2array(walkB(2,2:end));
Pz_TreadC = table2array(walkC(2,2:end));
x2 = [time, fliplr(time)];

% count up the number of accepted targets in each session and condition
% clearvars normParam
for ii = 1:length(Files)
normParam(ii,i) = numel(find(codes_all(:,ii)==1))-numel(find(x_all(:,ii)==1))-numel(find(x_all(2:end,ii)==4));
end

% clearvars normParam_alt normParam_alt_num
% for jj = 1:length(Files)
%     for ii = 1:301
%         if (codes_all(ii,jj)==1)  && ((x_all(ii,jj)==1) || (x_all(ii,jj)==4))
%             normParam_alt(ii,jj) = ii;
%             %numel(find(codes_all(:,ii)==1))-numel(find(x_all(:,ii)==1))-numel(find(x_all(2:end,ii)==4));
%         else normParam_alt(ii,jj) = 0;
%         end
%     end
% normParam_alt_num(jj) = 30-numel(find(normParam_alt(:,jj)))
% end


% clearvars S00X_sit_avg_eq S00X_stand_avg_eq S00X_walk_avg_eq
S00X_sit_avg_eq(:,i) = ((Pz_SitA*(normParam(1)))+(Pz_SitB*(normParam(2)))+(Pz_SitC*(normParam(3))))/(sum(normParam(1:3)));
S00X_stand_avg_eq(:,i) = ((Pz_StandA*(normParam(4)))+(Pz_StandB*(normParam(5)))+(Pz_StandC*(normParam(6))))/(sum(normParam(4:6)));
S00X_walk_avg_eq(:,i) = ((Pz_TreadA*(normParam(7)))+(Pz_TreadB*(normParam(8)))+(Pz_TreadC*(normParam(9))))/(sum(normParam(7:9)));

figure()
hold on
sit = plot(time,S00X_sit_avg_eq(:,i),'k-','LineWidth',1)
stand = plot(time,S00X_stand_avg_eq(:,i),'b-','LineWidth',1)
treadmill = plot(time,S00X_walk_avg_eq(:,i),'r-','LineWidth',1)
line([0 0], [-15 15]);
line([-200 800], [0 0]);
legend('Sit', 'Stand', 'Walk (Treadmill)');
grid minor
title('Averaged ERP at Pz (equalized) v10')
xlabel('Time relative to stimuli (ms)')
ylabel('Potential (µV)')
xlim([-200 800])
hold off
% savefig('Averaged ERP at Pz (equalized) v10.fig')

clearvars -except i S00X_sit_avg_eq S00X_stand_avg_eq S00X_walk_avg_eq subs time normParam
end

%% plot grand averages
cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG_gait\EEG\Matlab_data\Pilot2' % destination folder
n = numel(subs); % number of subjects

sit_all = S00X_sit_avg_eq';
stand_all = S00X_stand_avg_eq';
walk_all = S00X_walk_avg_eq';

sit_grandAvg = sum(sit_all)/(n);
stand_grandAvg = sum(stand_all)/n;
walk_grandAvg = sum(walk_all)/n;
        
figure()
hold on
sit = plot(time,sit_grandAvg,'k-','LineWidth',1)
stand = plot(time,stand_grandAvg,'b-','LineWidth',1)
treadmill = plot(time,walk_grandAvg,'r-','LineWidth',1)
line([0 0], [-15 15]);
line([-200 800], [0 0]);
legend('Sit', 'Stand', 'Walk (Treadmill)');
grid minor
title('Averaged ERP at Pz (Grand Average) eq10')
xlabel('Time relative to stimuli (ms)')
ylabel('Potential (µV)')
xlim([-200 800])
hold off
% savefig('Averaged ERP at Pz (Grand Average) eq10.fig')

sit_std = nanstd(sit_all,0,1)/sqrt(n);
stand_std = nanstd(stand_all,0,1)/sqrt(n);
walk_std = nanstd(walk_all,0,1)/sqrt(n);
sit_SEM_p = sit_grandAvg + sit_std;
sit_SEM_m = sit_grandAvg - sit_std;
stand_SEM_p = stand_grandAvg + stand_std;
stand_SEM_m = stand_grandAvg - stand_std;
walk_SEM_p = walk_grandAvg + walk_std;
walk_SEM_m = walk_grandAvg - walk_std;
figure()
plot(time, sit_grandAvg, 'b', time, stand_grandAvg, 'g', time, walk_grandAvg, 'r');
hold on
line([0 0], [-15 15]);
line([-200 800], [0 0]);
fill([time(1:1:300) time(300:-1:1)], [sit_SEM_m(1:1:300) sit_SEM_p(300:-1:1)], [0.5 0.5 1],'facealpha',0.4,'edgecolor','none');
fill([time(1:1:300) time(300:-1:1)], [stand_SEM_m(1:1:300) stand_SEM_p(300:-1:1)], [0.5 1 0.5],'facealpha',0.4,'edgecolor','none');
fill([time(1:1:300) time(300:-1:1)], [walk_SEM_m(1:1:300) walk_SEM_p(300:-1:1)], [1 0.5 0.5],'facealpha',0.4,'edgecolor','none');
grid minor
title('Averaged ERP at Pz (Grand Average) eq10')
xlabel('Time relative to stimuli (ms)')
ylabel('Potential (µV)')
legend({'Sit', 'Stand', 'Walk'})
% savefig('Averaged ERP at Pz (Grand Average) eq10 with stErr.fig')