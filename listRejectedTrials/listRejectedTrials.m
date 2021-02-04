cd 'C:\Users\mswerdloff\eeglab14_1_2b'
%cd 'C:\Users\maggi\Documents\MATLAB\eeglab14_1_2b'
eeglab
%% create list of rejected trials
%For every trial, load the ERP file and grab the tone labels
ERP_sit_A = pop_loaderp('filename', 'erpset_S003_v2_sit_walk_stand_A_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S003\sit\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_A = codes;

ERP_sit_B = pop_loaderp('filename', 'erpset_S003_v2_walk_sit_stand_B_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S003\sit\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_B = codes;

ERP_sit_C = pop_loaderp('filename', 'erpset_S003_v2_stand_walk_sit_C_0003_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S003\sit\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_C = codes;

ERP_stand_A = pop_loaderp('filename', 'erpset_S003_v2_sit_walk_stand_A_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S003\stand\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_A = codes;

ERP_stand_B = pop_loaderp('filename', 'erpset_S003_v2_walk_sit_stand_B_0003_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S003\stand\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_B = codes;

ERP_stand_C = pop_loaderp('filename', 'erpset_S003_v2_stand_walk_sit_C_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S003\stand\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_C = codes;

ERP_walk_A = pop_loaderp('filename', 'erpset_S003_v2_sit_walk_stand_A_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S003\walk\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_A = codes;

ERP_walk_B = pop_loaderp('filename', 'erpset_S003_v2_walk_sit_stand_B_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S003\walk\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_B = codes;

ERP_walk_C = pop_loaderp('filename', 'erpset_S003_v2_stand_walk_sit_C_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S003\walk\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_C = codes;

codesAll = [codes_sit_A,codes_sit_B,codes_sit_C,codes_stand_A,codes_stand_B,codes_stand_C,codes_walk_A,codes_walk_B,codes_walk_C];
codes_sit = [codesAll(:,1);codesAll(:,2);codesAll(:,3)];
codes_stand = [codesAll(:,4);codesAll(:,5);codesAll(:,6)];
codes_walk = [codesAll(:,7);codesAll(:,8);codesAll(:,9)];
codesAll_combined = [codes_sit,codes_stand,codes_walk];

% S003 = zeros(300,9);
x1 = [75,114,236,237,290];
x2 = [22,79,81,84,202,212,251,274,280,285];
x3 = [2 59 60 64 65:71 73 75 94 133 134 159 172 181 191 194 195:197 201 231 236 263 264:267 269 270 279 280:282 285 286:292 294 295:297 300];
x4 = [12 14 44 71 82 85 118 147 148 218 246 288 300];
x5 = [1 11 12 14 17 18:23 64 65 66 98 101 102 103 105 126 149 150:153 195 196 197 212 216 222 245 271];
x6 = [14 70 114 170 171 172 180 215 218 222 263 286];
x7 = [14 19 28 30 72 181 203 216 217 220 249 261];
x8 = [28 39 43 67 97 103 107 110 116 123 124 131 178 184 185 188 195 203 213 214:216 220 248 255 257 261 267];
x9 = [1:4 6 7 13 14 16 17:25 27 28:31 33 34 36 37:78 82 85 87 89 90:95 102 103:105 112 113:122 124 126 127:129 131 132 133 138 139:143 163 164 165 167 173 195 196:202 206 207 229 230:232 241];

for i = 1:1 % make sure to run this all together (only once)
    x_all = [ones(1,9)*4;zeros(300,9)];
    for ii = 1:numel(x1)
        x_all(x1(ii)+1,1) = 1;
    end
    for ii = 1:numel(x2)
        x_all(x2(ii)+1,2) = 1;
    end
    for ii = 1:numel(x3)
        x_all(x3(ii)+1,3) = 1;
    end
    for ii = 1:numel(x4)
        x_all(x4(ii)+1,4) = 1;
    end
    for ii = 1:numel(x5)
        x_all(x5(ii)+1,5) = 1;
    end
    for ii = 1:numel(x6)
        x_all(x6(ii)+1,6) = 1;
    end
    for ii = 1:numel(x7)
        x_all(x7(ii)+1,7) = 1;
    end
    for ii = 1:numel(x8)
        x_all(x8(ii)+1,8) = 1;
    end
    for ii = 1:numel(x9)
        x_all(x9(ii)+1,9) = 1;
    end
    
    clear totalAccepted targetsAccepted
    % for each one marked as rejected, assign its actual tone label
    for i = 1:9
        for ii = 1:size(x_all,1)
            if x_all(ii,i) == 1
                x_all(ii,i) = codesAll(ii,i);
            end
        end
        totalAccepted(i) = numel(find(codesAll(:,i)))-numel(find(x_all(:,i)));
        targetsAccepted(i) = numel(find(codesAll(:,i)==1))-numel(find(x_all(:,i)==1));
    end
end
RejectedTrials_S003 = array2table(x_all,'VariableNames',{'Sit_A','Sit_B','Sit_C','Stand_A','Stand_B','Stand_C','Walk_A','Walk_B','Walk_C'});

clear targetsAccepted_sit targetsAccepted_stand targetsAccepted_walk targetsAccepted_all
targetsAccepted_sit = sum(targetsAccepted(1:3));
targetsAccepted_stand = sum(targetsAccepted(4:6));
targetsAccepted_walk = sum(targetsAccepted(7:9));
targetsAccepted_all = [targetsAccepted_sit,targetsAccepted_stand,targetsAccepted_walk];
targetsAccepted_all_S003 = [targetsAccepted_sit,targetsAccepted_stand,targetsAccepted_walk,min(targetsAccepted_all)];
totalAccepted_all_S003 = [sum(totalAccepted(1:3)),sum(totalAccepted(4:6)),sum(totalAccepted(7:9))]
codes_all_S003 = codesAll;

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S003'
save('rejectedAcceptedTrials.mat','RejectedTrials_S003','targetsAccepted_all_S003','totalAccepted_all_S003'); % save list of numbers of targets accepted


%% S005
ERP_sit_A = pop_loaderp('filename', 'erpset_S005_v2_walk_sit_stand_A_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S005\sit\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_A = codes;

ERP_sit_B = pop_loaderp('filename', 'erpset_S005_v2_sit_stand_walk_B_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S005\sit\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_B = codes;

ERP_sit_C = pop_loaderp('filename', 'erpset_S005_v2_stand_walk_sit_C_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S005\sit\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_C = codes;

ERP_stand_A = pop_loaderp('filename', 'erpset_S005_v2_walk_sit_stand_A_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S005\stand\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_A = codes;

ERP_stand_B = pop_loaderp('filename', 'erpset_S005_v2_sit_stand_walk_B_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S005\stand\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_B = codes;

ERP_stand_C = pop_loaderp('filename', 'erpset_S005_v2_stand_walk_sit_C_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S005\stand\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_C = codes;

ERP_walk_A = pop_loaderp('filename', 'erpset_S005_v2_walk_sit_stand_A_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S005\walk\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_A = codes;

ERP_walk_B = pop_loaderp('filename', 'erpset_S005_v2_sit_stand_walk_B_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S005\walk\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_B = codes;

ERP_walk_C = pop_loaderp('filename', 'erpset_S005_v2_stand_walk_sit_C_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S005\walk\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_C = codes;

codesAll = [codes_sit_A,codes_sit_B,codes_sit_C,codes_stand_A,codes_stand_B,codes_stand_C,codes_walk_A,codes_walk_B,codes_walk_C];
codes_sit = [codesAll(:,1);codesAll(:,2);codesAll(:,3)];
codes_stand = [codesAll(:,4);codesAll(:,5);codesAll(:,6)];
codes_walk = [codesAll(:,7);codesAll(:,8);codesAll(:,9)];
codesAll_combined = [codes_sit,codes_stand,codes_walk];

% rejTrials = zeros(300,9);
x1 = [4 34 67 71 74 89 125 155 161 166 169 178 186 216 217 226 227 231 240 247 251 253 254:256 265 266 270 280 288 292 293 299];
x2 = [8 43 45 50 61 62 63 101 105 110 136 146 151 163 164 184 185 186 191 196 197 200 206 218 225 226 228 231 232 248 253 254 278 279:288 294 296];
x3 = [8 27 32 34 52 58 59 61 84 94 125 160 162 192 198 199 201 238 257 262 265 267 268 276 283 291];
x4 = [4 73 76 100 103 121 126 133 143 160 175 183 190 213 215 254 256 261];
x5 = [83 96 97 109 113 114:116 123 127 128 163 168 180 200 202 213 227 273 283 284 298];
x6 = [10 16 17 22 52 55 61 98 106 107 125 128 146 150 152 155 171 172 174 177 179 180 189 204 207 212 215 218 226 241 248 254 267 270 272 286 294 296 299];
x7 = [6 10 11 12 127 150 181 213 219 220 227 245 246 262 266 283];
x8 = [1:16:33 61 87 141 146 147:149 177 199 212 216 222 227 228 236 261];
x9 = [18 19 35 62 66 67:70 72 119 120 153 160 167 215 216 271 295];

for i = 1:1 % make sure to run this all together (only once)
    x_all = [ones(1,9)*4;zeros(300,9)];
    for ii = 1:numel(x1)
        x_all(x1(ii)+1,1) = 1;
    end
    for ii = 1:numel(x2)
        x_all(x2(ii)+1,2) = 1;
    end
    for ii = 1:numel(x3)
        x_all(x3(ii)+1,3) = 1;
    end
    for ii = 1:numel(x4)
        x_all(x4(ii)+1,4) = 1;
    end
    for ii = 1:numel(x5)
        x_all(x5(ii)+1,5) = 1;
    end
    for ii = 1:numel(x6)
        x_all(x6(ii)+1,6) = 1;
    end
    for ii = 1:numel(x7)
        x_all(x7(ii)+1,7) = 1;
    end
    for ii = 1:numel(x8)
        x_all(x8(ii)+1,8) = 1;
    end
    for ii = 1:numel(x9)
        x_all(x9(ii)+1,9) = 1;
    end
    
    clear totalAccepted targetsAccepted
    % for each one marked as rejected, assign its actual tone label
    for i = 1:9
        for ii = 1:size(x_all,1)
            if x_all(ii,i) == 1
                x_all(ii,i) = codesAll(ii,i);
            end
        end
        totalAccepted(i) = numel(find(codesAll(:,i)))-numel(find(x_all(:,i)));
        targetsAccepted(i) = numel(find(codesAll(:,i)==1))-numel(find(x_all(:,i)==1));

    end
end
RejectedTrials_S005 = array2table(x_all,'VariableNames',{'Sit_A','Sit_B','Sit_C','Stand_A','Stand_B','Stand_C','Walk_A','Walk_B','Walk_C'});

clear targetsAccepted_sit targetsAccepted_stand targetsAccepted_walk targetsAccepted_all
targetsAccepted_sit = sum(targetsAccepted(1:3));
targetsAccepted_stand = sum(targetsAccepted(4:6));
targetsAccepted_walk = sum(targetsAccepted(7:9));
targetsAccepted_all = [targetsAccepted_sit,targetsAccepted_stand,targetsAccepted_walk];
targetsAccepted_all_S005 = [targetsAccepted_sit,targetsAccepted_stand,targetsAccepted_walk,min(targetsAccepted_all)];
totalAccepted_all_S005 = [sum(totalAccepted(1:3)),sum(totalAccepted(4:6)),sum(totalAccepted(7:9))]
codes_all_S005 = codesAll;

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S005'
save('rejectedAcceptedTrials.mat','RejectedTrials_S005','targetsAccepted_all_S005','totalAccepted_all_S005'); % save list of numbers of targets accepted

%% S006
%For every trial, load the ERP file and grab the tone labels
ERP_sit_A = pop_loaderp('filename', 'erpset_S006_walk_sit_stand_A_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S006\sit\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_A = codes;

ERP_sit_B = pop_loaderp('filename', 'erpset_S006_sit_stand_walk_B_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S006\sit\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_B = codes;

ERP_sit_C = pop_loaderp('filename', 'erpset_S006_stand_walk_sit_C_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S006\sit\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_C = codes;

ERP_stand_A = pop_loaderp('filename', 'erpset_S006_walk_sit_stand_A_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S006\stand\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_A = codes;

ERP_stand_B = pop_loaderp('filename', 'erpset_S006_sit_stand_walk_B_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S006\stand\');
codes = zeros(301,1);
for i = 1:280
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_B = codes;

ERP_stand_C = pop_loaderp('filename', 'erpset_S006_stand_walk_sit_C_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S006\stand\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_C = codes;

ERP_walk_A = pop_loaderp('filename', 'erpset_S006_walk_sit_stand_A_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S006\walk\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_A = codes;

ERP_walk_B = pop_loaderp('filename', 'erpset_S006_sit_stand_walk_B_0003_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S006\walk\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_B = codes;

ERP_walk_C = pop_loaderp('filename', 'erpset_S006_stand_walk_sit_C_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S006\walk\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_C = codes;

codesAll = [codes_sit_A,codes_sit_B,codes_sit_C,codes_stand_A,codes_stand_B,codes_stand_C,codes_walk_A,codes_walk_B,codes_walk_C];
codes_sit = [codesAll(:,1);codesAll(:,2);codesAll(:,3)];
codes_stand = [codesAll(:,4);codesAll(:,5);codesAll(:,6)];
codes_walk = [codesAll(:,7);codesAll(:,8);codesAll(:,9)];
codesAll_combined = [codes_sit,codes_stand,codes_walk];

x1 = [4 40 41 42 50 146 179 180 181 187 188 197 244 281 294];
x2 = [12 128 129 130 138 155 253 260 261 269 277 292];
x3 = [8 9 11 13 32 33 41 73 82 97 98 110 131 135 136 153 155 160 167 175 176 249];
x4 = [9 33 34 95 110 119 128 148 160 175 179 189 230 288 300];
x5 = [15:5:25 59 72 73 74 76 105 106 114 119 120 173 174 175 188 202 206 228 257];
x6 = [1 2 9 50 106 107 108 119 138 151 172 186 191 193 206 213 214 225 238 242 246 247 248 250 255 263 267 268 272 273 274 284 285 286 288 289:292 294 295:296];
x7 = [5 46 47 134 142 169 193 200 207 225 226 230 258 272 285];
x8 = [3 41 50 51 93 98 146 149 150 191 224 240 276 291 292 293 296 297];
x9 = [1 3 4 13 14 15 20 21 22 26 27 37 38 47 48 57 58 59 62 70 71 72 97 98 106 115 116 135 136:138 152 194 195 229 287];

for i = 1:1 % make sure to run this all together (only once)
    x_all = [ones(1,9)*4;zeros(300,9)];
    for ii = 1:numel(x1)
        x_all(x1(ii)+1,1) = 1;
    end
    for ii = 1:numel(x2)
        x_all(x2(ii)+1,2) = 1;
    end
    for ii = 1:numel(x3)
        x_all(x3(ii)+1,3) = 1;
    end
    for ii = 1:numel(x4)
        x_all(x4(ii)+1,4) = 1;
    end
    for ii = 1:numel(x5)
        x_all(x5(ii)+1,5) = 1;
    end
    for ii = 1:numel(x6)
        x_all(x6(ii)+1,6) = 1;
    end
    for ii = 1:numel(x7)
        x_all(x7(ii)+1,7) = 1;
    end
    for ii = 1:numel(x8)
        x_all(x8(ii)+1,8) = 1;
    end
    for ii = 1:numel(x9)
        x_all(x9(ii)+1,9) = 1;
    end
    
    clear totalAccepted targetsAccepted
    % for each one marked as rejected, assign its actual tone label
    for i = 1:9
        for ii = 1:size(x_all,1)
            if x_all(ii,i) == 1
                x_all(ii,i) = codesAll(ii,i);
            end
        end
totalAccepted(i) = numel(find(codesAll(:,i)))-numel(find(x_all(:,i)));
targetsAccepted(i) = numel(find(codesAll(:,i)==1))-numel(find(x_all(:,i)==1));

    end
end
RejectedTrials_S006 = array2table(x_all,'VariableNames',{'Sit_A','Sit_B','Sit_C','Stand_A','Stand_B','Stand_C','Walk_A','Walk_B','Walk_C'});

clear targetsAccepted_sit targetsAccepted_stand targetsAccepted_walk targetsAccepted_all
targetsAccepted_sit = sum(targetsAccepted(1:3));
targetsAccepted_stand = sum(targetsAccepted(4:6));
targetsAccepted_walk = sum(targetsAccepted(7:9));
targetsAccepted_all = [targetsAccepted_sit,targetsAccepted_stand,targetsAccepted_walk];
targetsAccepted_all_S006 = [targetsAccepted_sit,targetsAccepted_stand,targetsAccepted_walk,min(targetsAccepted_all)];
totalAccepted_all_S006 = [sum(totalAccepted(1:3)),sum(totalAccepted(4:6)),sum(totalAccepted(7:9))]
codes_all_S006 = codesAll;

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S006'
save('rejectedAcceptedTrials.mat','RejectedTrials_S006','targetsAccepted_all_S006','totalAccepted_all_S006'); % save list of numbers of targets accepted

%% S007
ERP_sit_A = pop_loaderp('filename', 'erpset_S007_walk_stand_sit_A_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S007\sit\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_A = codes;

ERP_sit_B = pop_loaderp('filename', 'erpset_S007_stand_sit_walk_B_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S007\sit\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_B = codes;

ERP_sit_C = pop_loaderp('filename', 'erpset_S007_sit_walk_stand_C_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S007\sit\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_C = codes;

ERP_stand_A = pop_loaderp('filename', 'erpset_S007_walk_stand_sit_A_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S007\stand\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_A = codes;

ERP_stand_B = pop_loaderp('filename', 'erpset_S007_stand_sit_walk_B_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S007\stand\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_B = codes;

ERP_stand_C = pop_loaderp('filename', 'erpset_S007_sit_walk_stand_C_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S007\stand\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_C = codes;

ERP_walk_A = pop_loaderp('filename', 'erpset_S007_walk_stand_sit_A_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S007\walk\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_A = codes;

ERP_walk_B = pop_loaderp('filename', 'erpset_S007_stand_sit_walk_B_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S007\walk\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_B = codes;

ERP_walk_C = pop_loaderp('filename', 'erpset_S007_sit_walk_stand_C_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S007\walk\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_C = codes;

codesAll = [codes_sit_A,codes_sit_B,codes_sit_C,codes_stand_A,codes_stand_B,codes_stand_C,codes_walk_A,codes_walk_B,codes_walk_C];
codes_sit = [codesAll(:,1);codesAll(:,2);codesAll(:,3)];
codes_stand = [codesAll(:,4);codesAll(:,5);codesAll(:,6)];
codes_walk = [codesAll(:,7);codesAll(:,8);codesAll(:,9)];
codesAll_combined = [codes_sit,codes_stand,codes_walk];

%
x1 = [2:4 8 9 11 12:17 19 20 26 27 28 30 31 32 41 42:44 48 50 51 58 59 60 65 66 67 70 71 80 81:84 87 88:92 94 95:97 99 100 103 104 110 112 113 114 116 128 131 132 134 137 148 175 181 190 191 192 231 233 234 237 238 246 250 251 252 262 264 269 272 276 277 280 281 283 284 285 292 295 296 299 300];
x2 = [1 3 4:6 9 10:17 20 21 27 39 42 44 45 46 48 54 55 56 65 67 71 73 74:77 80 82 86 92 93 100 107 109 114 115 122 123:129 134 136 139 143 145 146 148 149 152 153:158 161 167 177 178 179 181 187 197 198 201 203 206 210 215 223 225 227 236 239 242 255 258 270 278 282 291 292 296];
x3 = [1 2 8 9 11 12 14 18 29 30:32 35 37 40 41:45 47 49 53 56 58:2:62 63:69 71 72:77 79 82 86 87 89 102 109 110 117 124 126 127 130 135 152 154 157 159 163 164 182 183:186 191 193 195 196:199 205 210 214 224 229 230 234 236 238 250 252 253:255 268 269 271 272:275 277 278 280 281 285 290];
x4 = [2 4 7 17 25 31 32 44 45:47 51 54 55:58 61 62:64 67 68:71 73 75 76 81 82 84 87 90 92 93:95 97 98 99 103 104:106 108 109 110 115 116 117 119 120 121 124 125 126 128 129 131 132:135 137 138 139 143 145 146 147 155 156:165 169 170 171 176 177:187 189 190:195 199 200 201 204 205:207 210 211:214 219 223 224 226 228 229:233 241 247 248:255 257 262 263:267 274 275:277 281 283 284 290 291:295 297 298:300];
x5 = [1 5 7 9 10 12 14 24 29 42 55 57 64 66 68 69 79 82 86 87 92 94 95 98 99 103 105 107 108 111 115 116 120 122 123:125 129 131 132:135 138 141 154 158 159 160 162 164 165 171 173 174 190 192 193 196 197 199 201 204 205:208 210 211 213 214:222 224 225:227 232 233 235:2:239 240 242 246 248 249:251 255 262 263 265 267 268 275 278 279 280 289 290 291 293 294:300];
x6 = [2 3 6 9 20 21 23 25 26 27 29 32 41 42 48 49 52 64 66 74 82 83 84 87 89 92 93 97 101 106 110 115 116 122 123 125 126 127 131 133 134 135 137 146 148 150 151 154 156 162 164 165:170 173 175 176 179 182 184 185 192 193 202 205 206:208 213 214:216 221 223 227 228:235 237 239 244 245 248 249 251 252:256 260 262 263 264 266 269 275 276 277 279 280 283 284 291 292 294 297 298:300];
x7 = [1:7 10 11 13 14:21 24 25:30 35 37 38:42 44 47:3:53 55 56:59 63 64:67 72 73 78 80 81 82 86 87 92 94 95:98 101 102 103 105 107 108:111 113 114 116 117:121 123 124 129 130 132 133:137 139 140 141 143 145 148 149:155 157 158:162 164 165:168 170 174 175 181 182 183 185 190 191 192 194 195 196 201 205 206:208 210:2:218 219 222 223 229 231 232:234 236 238 239 241:2:245 246:253 255 258 259 265 266 268 269 271 272:280 282 283:285 287 288:292 296 299];
x8 = [6 9 11 12:14 17 19 20 24 25 40 42 43 45 51 52 53 55 57 58 63 65 69 72 86 89 97 102 103 109 110:112 114 117 118 122 124 125:127 130 133 139 141 142 148 149 154 156 157:159 161 164 165 168 170 171 172 176 179 191 192 195 196 198 199 202 205 207 209 210:212 215 218 219 222 223 224 227 228:230 236 241 242 247 257 259 260:262 265 266 268 276 283 284:286 298];
x9 = [4 7 8 10 12 13 15 16 17 19 20 25 27:2:33 34:40 42 48 49 51 56 58 61 62 63 66 71 73 74:79 86 87 93 107 115 118 123 128 129 130 136 137 139 141 142 145 152 153 154 156 163 164 166:2:170 171:174 178 179 183 186 188 189 190 192 193 194 197 199 201 204 207 208 210 215 218 219 220 222 225 226 227 235 239 240 244 247 250 256 257 258 260 263 264 266 270 272 273 277 278 279 281 283 286 288 296 297 298 300];

for i = 1:1 % make sure to run this all together (only once)
    x_all = [ones(1,9)*4;zeros(300,9)];
    for ii = 1:numel(x1)
        x_all(x1(ii)+1,1) = 1;
    end
    for ii = 1:numel(x2)
        x_all(x2(ii)+1,2) = 1;
    end
    for ii = 1:numel(x3)
        x_all(x3(ii)+1,3) = 1;
    end
    for ii = 1:numel(x4)
        x_all(x4(ii)+1,4) = 1;
    end
    for ii = 1:numel(x5)
        x_all(x5(ii)+1,5) = 1;
    end
    for ii = 1:numel(x6)
        x_all(x6(ii)+1,6) = 1;
    end
    for ii = 1:numel(x7)
        x_all(x7(ii)+1,7) = 1;
    end
    for ii = 1:numel(x8)
        x_all(x8(ii)+1,8) = 1;
    end
    for ii = 1:numel(x9)
        x_all(x9(ii)+1,9) = 1;
    end
    
    clear totalAccepted targetsAccepted
    % for each one marked as rejected, assign its actual tone label
    for i = 1:9
        for ii = 1:size(x_all,1)
            if x_all(ii,i) == 1
                x_all(ii,i) = codesAll(ii,i);
            end
        end
totalAccepted(i) = numel(find(codesAll(:,i)))-numel(find(x_all(:,i)));
targetsAccepted(i) = numel(find(codesAll(:,i)==1))-numel(find(x_all(:,i)==1));

    end
end
RejectedTrials_S007 = array2table(x_all,'VariableNames',{'Sit_A','Sit_B','Sit_C','Stand_A','Stand_B','Stand_C','Walk_A','Walk_B','Walk_C'});

clear targetsAccepted_sit targetsAccepted_stand targetsAccepted_walk targetsAccepted_all
targetsAccepted_sit = sum(targetsAccepted(1:3));
targetsAccepted_stand = sum(targetsAccepted(4:6));
targetsAccepted_walk = sum(targetsAccepted(7:9));
targetsAccepted_all = [targetsAccepted_sit,targetsAccepted_stand,targetsAccepted_walk];
targetsAccepted_all_S007 = [targetsAccepted_sit,targetsAccepted_stand,targetsAccepted_walk,min(targetsAccepted_all)];
totalAccepted_all_S007 = [sum(totalAccepted(1:3)),sum(totalAccepted(4:6)),sum(totalAccepted(7:9))]
codes_all_S007 = codesAll;

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S007'
save('rejectedAcceptedTrials.mat','RejectedTrials_S007','targetsAccepted_all_S007','totalAccepted_all_S007'); % save list of numbers of targets accepted

%% S008
ERP_sit_A = pop_loaderp('filename', 'erpset_S008_sit_walk_stand_A_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S008\sit\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_A = codes;

ERP_sit_B = pop_loaderp('filename', 'erpset_S008_walk_stand_sit_B_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S008\sit\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_B = codes;

ERP_sit_C = pop_loaderp('filename', 'erpset_S008_stand_sit_walk_C_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S008\sit\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_C = codes;

ERP_stand_A = pop_loaderp('filename', 'erpset_S008_sit_walk_stand_A_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S008\stand\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_A = codes;

ERP_stand_B = pop_loaderp('filename', 'erpset_S008_walk_stand_sit_B_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S008\stand\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_B = codes;

ERP_stand_C = pop_loaderp('filename', 'erpset_S008_stand_sit_walk_C_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S008\stand\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_C = codes;

ERP_walk_A = pop_loaderp('filename', 'erpset_S008_sit_walk_stand_A_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S008\walk\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_A = codes;

ERP_walk_B = pop_loaderp('filename', 'erpset_S008_walk_stand_sit_B_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S008\walk\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_B = codes;

ERP_walk_C = pop_loaderp('filename', 'erpset_S008_stand_sit_walk_C_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S008\walk\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_C = codes;

codesAll = [codes_sit_A,codes_sit_B,codes_sit_C,codes_stand_A,codes_stand_B,codes_stand_C,codes_walk_A,codes_walk_B,codes_walk_C];
codes_sit = [codesAll(:,1);codesAll(:,2);codesAll(:,3)];
codes_stand = [codesAll(:,4);codesAll(:,5);codesAll(:,6)];
codes_walk = [codesAll(:,7);codesAll(:,8);codesAll(:,9)];
codesAll_combined = [codes_sit,codes_stand,codes_walk];

%
x1 = [5 40 44 47 92 102 109 120 127 135 157 161 165 181 189 190 198 200 208:8:224 243 244 247 252 262 263 283 293 298];
x2 = [4:6 16 31 32 34 35 37 44 45 53 65 73 87 100 105 109 110 122 123 133 136 137 139 150 165 170 171 194 207 212 239 260 275 286];
x3 = [11 32 60 61 95 97 116 118 146 164 73 182 189 207 216 219 252 264 278];
x4 = [1 2 4 11 30 33 39 44 70 80 89 97 102 115 117 131 137 139 145 152 158 159 163 166 173 178 183 189 203 211 215 225 240 276 292];
x5 = [7 13 20 35 44 56 65 67 68 72 74 76 84 101 127 157 161 175 189 200 208 214 215:219 221 224 225 228 233 234 240 249 250 258 265 279 288 294 295];
x6 = [8 44 60 75 76 96 98 121 132 133 143 144 145 170 174 180 196 198 199 200 224 244 274 277 282 288];
x7 = [1 2 5 6 8 10 15 19 29 33 34 35 37 42 43 48 50 57 62 65 70 73 75 76 77 80 84 85:91 93 96 98 99 100 103:3:112 116 117 119 120 122 123:125 128 136 140 146 151 152 153 155 160 175 177 178 182 184 187 188 190 191 196 199 208 212 213 215 217 223 226 227 231 232 238 239 240 245 246 248 250 251 254:3:260 261 263 264:269 271 272 273 275 278 279 281 282 283 285 287 290 292 293 300];
x8 = [1:4 6 7 8 10 15 17 21 22 24 25:27 29 32 33 35 36 40 42 45 51 52:55 57 58 59 61 62 64 65 68 69 72 73 79 84 88 89 93:4:101 104 105 106 116 118 124 132 136 138 140 141 142 145:3:154 155 159 163 166 173 176 178 179 184 186 189 190 196 197 199 201 205 207 208 210 212 218 221 225 226 228 229:232 236 237 239 241 242:245 247 248 249 255 257 259 270 271 282 288 289 290 293 295];
x9 = [3:2:9 14 15 18 20 26 27 31 32:35 38 40 42 54 56 57 60 63 64 70 72 79 82 85 86 88 90 91 98 102 103 108 112 113:117 120 130 132 139 141 147 149 155 159 166 170 175 176 181 184 190 193 194 197 200 201 203 207 208 209 215 217 218 219 228 230 231 240 242 245 262 265 271 273 279 281 283 289 290 293 294 296];

for i = 1:1 % make sure to run this all together (only once)
    x_all = [ones(1,9)*4;zeros(300,9)];
    for ii = 1:numel(x1)
        x_all(x1(ii)+1,1) = 1;
    end
    for ii = 1:numel(x2)
        x_all(x2(ii)+1,2) = 1;
    end
    for ii = 1:numel(x3)
        x_all(x3(ii)+1,3) = 1;
    end
    for ii = 1:numel(x4)
        x_all(x4(ii)+1,4) = 1;
    end
    for ii = 1:numel(x5)
        x_all(x5(ii)+1,5) = 1;
    end
    for ii = 1:numel(x6)
        x_all(x6(ii)+1,6) = 1;
    end
    for ii = 1:numel(x7)
        x_all(x7(ii)+1,7) = 1;
    end
    for ii = 1:numel(x8)
        x_all(x8(ii)+1,8) = 1;
    end
    for ii = 1:numel(x9)
        x_all(x9(ii)+1,9) = 1;
    end
    
    clear totalAccepted targetsAccepted
    % for each one marked as rejected, assign its actual tone label
    for i = 1:9
        for ii = 1:size(x_all,1)
            if x_all(ii,i) == 1
                x_all(ii,i) = codesAll(ii,i);
            end
        end
totalAccepted(i) = numel(find(codesAll(:,i)))-numel(find(x_all(:,i)));
targetsAccepted(i) = numel(find(codesAll(:,i)==1))-numel(find(x_all(:,i)==1));

    end
end
RejectedTrials_S008 = array2table(x_all,'VariableNames',{'Sit_A','Sit_B','Sit_C','Stand_A','Stand_B','Stand_C','Walk_A','Walk_B','Walk_C'});

clear targetsAccepted_sit targetsAccepted_stand targetsAccepted_walk targetsAccepted_all
targetsAccepted_sit = sum(targetsAccepted(1:3));
targetsAccepted_stand = sum(targetsAccepted(4:6));
targetsAccepted_walk = sum(targetsAccepted(7:9));
targetsAccepted_all = [targetsAccepted_sit,targetsAccepted_stand,targetsAccepted_walk];
targetsAccepted_all_S008 = [targetsAccepted_sit,targetsAccepted_stand,targetsAccepted_walk,min(targetsAccepted_all)];
totalAccepted_all_S008 = [sum(totalAccepted(1:3)),sum(totalAccepted(4:6)),sum(totalAccepted(7:9))]
codes_all_S008 = codesAll;

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S008'
save('rejectedAcceptedTrials.mat','RejectedTrials_S008','targetsAccepted_all_S008','totalAccepted_all_S008'); % save list of numbers of targets accepted

%% S009
%1
ERP_sit_A = pop_loaderp('filename', 'erpset_S009_stand_sit_walk_A_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S009\sit\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_A = codes;
pause

%2
ERP_sit_B = pop_loaderp('filename', 'erpset_S009_sit_walk_stand_B_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S009\sit\');
codes = zeros(301,1);
for i = 1:202
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_B = codes;
pause

%3
ERP_sit_C = pop_loaderp('filename', 'erpset_S009_walk_stand_sit_C_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S009\sit\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_C = codes;
pause

%4
ERP_stand_A = pop_loaderp('filename', 'erpset_S009_stand_sit_walk_A_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S009\stand\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_A = codes;
pause

%5
ERP_stand_B = pop_loaderp('filename', 'erpset_S009_sit_walk_stand_B_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S009\stand\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_B = codes;
pause

%6
ERP_stand_C = pop_loaderp('filename', 'erpset_S009_walk_stand_sit_C_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S009\stand\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_C = codes;
pause

%7
ERP_walk_A = pop_loaderp('filename', 'erpset_S009_stand_sit_walk_A_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S009\walk\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_A = codes;
pause

%8
ERP_walk_B = pop_loaderp('filename', 'erpset_S009_sit_walk_stand_B_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S009\walk\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_B = codes;
pause

%9
ERP_walk_C = pop_loaderp('filename', 'erpset_S009_walk_stand_sit_C_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S009\walk\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_C = codes;
pause

codesAll = [codes_sit_A,codes_sit_B,codes_sit_C,codes_stand_A,codes_stand_B,codes_stand_C,codes_walk_A,codes_walk_B,codes_walk_C];
codes_sit = [codesAll(:,1);codesAll(:,2);codesAll(:,3)];
codes_stand = [codesAll(:,4);codesAll(:,5);codesAll(:,6)];
codes_walk = [codesAll(:,7);codesAll(:,8);codesAll(:,9)];
codesAll_combined = [codes_sit,codes_stand,codes_walk];

%
x1 = [1:4 12 13 30 37 41 44 63 64 66 67:69 80 82 87 88 89 109 112 113 116 120 121 124 125 129 130 134 137 139 151 161 163 181 184 185 193 194 195 197 200 201:203 208 209 213 214 220 221 222 225 226 227 229 230 231 233 234 238 239 241 242 251 253 254 256 257:259 262 269 273 278 279:286 293 296];
x2 = [4 5 12 13:15 17 26 64 67 134 135 157 160 164 166 167:169];
x3 = [1 2 7 8 11 12 13 17 18:33 39 40:43 50 52 57 60 62 69 73 76 80 84 87 92 107 126 141 162 163 183 190 196 201 202:205 212 226 246 248 249 255];
x4 = [2:4 99 137 140 141 142 157 167 172 173:176 178 198 200 217 218 227 228 254 255:257 272 273 279 281 282 294 295 296 299];
x5 = [8:7:22 30 33 56 58 72 91 111 113 126 161 165 185 196 218 231 232 236 247 248:250 258 271 273 282 286 292:6:298];
x6 = [1 6 7:20 26 28 46 68 88 97 130 135 136 140 143 144 146 147 148 150 152 153 157 161 162 163 170 173 185 186 188 189 191 192 193 195:2:201 217 218 228 229 232 233:239 242 243 249 252 253 256 259 260:262 264 266 267 269 270 273 274 279 282 289 290:292 294 295 298];
x7 = [1 2 5 6 8 10 15 19 29 33 34 35 37 42 43 48 50 57 62 65 70 73 75 76 77 80 84 85:91 93 96 98 99 100 103:3:112 116 117 119 120 122 123:125 128 136 140 146 151 152 153 155 160 175 177 178 182 184 187 188 190 191 196 199 208 212 213 215 217 223 226 227 231 232 238 239 240 245 246 248 250 251 254:3:260 261 263 264:269 271 272 273 275 278 279 281 282 283 285 287 290 292 293 300];
x8 = [1:3 5 6:26 28 29 31 32 35 36 38 39 43 45 47 48 49 52 53 55 56:59 62 63:70 74 75:82 84 85:119 122 124 131 132 138 141 142 148 150 156 157 159 162 164 166 169 170:174 179 180 184 185:187 189 190:193 195 196 197 199 200 201 203 204 205 208 209:211 213 214:216 220 221 224 225 226 228 229:233 235 236 238:2:246 247:250 252 253:258 260 261:271 273 274:281 289 290:300];
x9 = [1 2 4 5 6 8 9:11 13 17 18 20 21 22 25 26 35 36 38 43 47 48:52 55 56:66 70 71 74 77 78 80 81:84 89 92 95 97 102 103:106 108 109 111 113 114 118 120 124 125 127 130 132 133:135 140 141 143 144 146 150 151:161 166 167:170 176 177 178 180 183 184 187:3:193 194:204 209 210:213 217 218 221 222:232 234 235 238 240 241 244 245 249 250:252 256 257:259 261 262 263 269 270:272 278 279:281 283 284:287 289 291 292 294 295 297 298:300];

for i = 1:1 % make sure to run this all together (only once)
    x_all = [ones(1,9)*4;zeros(300,9)];
    for ii = 1:numel(x1)
        x_all(x1(ii)+1,1) = 1;
    end
    for ii = 1:numel(x2)
        x_all(x2(ii)+1,2) = 1;
    end
    for ii = 1:numel(x3)
        x_all(x3(ii)+1,3) = 1;
    end
    for ii = 1:numel(x4)
        x_all(x4(ii)+1,4) = 1;
    end
    for ii = 1:numel(x5)
        x_all(x5(ii)+1,5) = 1;
    end
    for ii = 1:numel(x6)
        x_all(x6(ii)+1,6) = 1;
    end
    for ii = 1:numel(x7)
        x_all(x7(ii)+1,7) = 1;
    end
    for ii = 1:numel(x8)
        x_all(x8(ii)+1,8) = 1;
    end
    for ii = 1:numel(x9)
        x_all(x9(ii)+1,9) = 1;
    end
    
    clear totalAccepted targetsAccepted
    % for each one marked as rejected, assign its actual tone label
    for i = 1:9
        for ii = 1:size(x_all,1)
            if x_all(ii,i) == 1
                x_all(ii,i) = codesAll(ii,i);
            end
        end
 totalAccepted(i) = numel(find(codesAll(:,i)))-numel(find(x_all(:,i)));
 targetsAccepted(i) = numel(find(codesAll(:,i)==1))-numel(find(x_all(:,i)==1));

    end
end
RejectedTrials_S009 = array2table(x_all,'VariableNames',{'Sit_A','Sit_B','Sit_C','Stand_A','Stand_B','Stand_C','Walk_A','Walk_B','Walk_C'});

clear targetsAccepted_sit targetsAccepted_stand targetsAccepted_walk targetsAccepted_all
targetsAccepted_sit = sum(targetsAccepted(1:3));
targetsAccepted_stand = sum(targetsAccepted(4:6));
targetsAccepted_walk = sum(targetsAccepted(7:9));
targetsAccepted_all = [targetsAccepted_sit,targetsAccepted_stand,targetsAccepted_walk];
targetsAccepted_all_S009 = [targetsAccepted_sit,targetsAccepted_stand,targetsAccepted_walk,min(targetsAccepted_all)];
totalAccepted_all_S009 = [sum(totalAccepted(1:3)),sum(totalAccepted(4:6)),sum(totalAccepted(7:9))]
codes_all_S009 = codesAll;

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S009'
save('rejectedAcceptedTrials.mat','RejectedTrials_S009','targetsAccepted_all_S009','totalAccepted_all_S009'); % save list of numbers of targets accepted


%% S010
%For every trial, load the ERP file and grab the tone labels
ERP_sit_A = pop_loaderp('filename', 'erpset_S010_walk_stand_sit_A_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S010\sit\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_A = codes;

ERP_sit_B = pop_loaderp('filename', 'erpset_S010_stand_sit_walk_B_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S010\sit\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_B = codes;

ERP_sit_C = pop_loaderp('filename', 'erpset_S010_sit_walk_stand_C_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S010\sit\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_C = codes;

ERP_stand_A = pop_loaderp('filename', 'erpset_S010_walk_stand_sit_A_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S010\stand\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_A = codes;

ERP_stand_B = pop_loaderp('filename', 'erpset_S010_stand_sit_walk_B_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S010\stand\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_B = codes;

ERP_stand_C =pop_loaderp('filename', 'erpset_S010_sit_walk_stand_C_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S010\stand\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_C = codes;

ERP_walk_A = pop_loaderp('filename', 'erpset_S010_walk_stand_sit_A_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S010\walk\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_A = codes;

ERP_walk_B = pop_loaderp('filename', 'erpset_S010_stand_sit_walk_B_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S010\walk\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_B = codes;

ERP_walk_C = pop_loaderp('filename', 'erpset_S010_sit_walk_stand_C_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S010\walk\');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_C = codes;

codesAll = [codes_sit_A,codes_sit_B,codes_sit_C,codes_stand_A,codes_stand_B,codes_stand_C,codes_walk_A,codes_walk_B,codes_walk_C];
codes_sit = [codesAll(:,1);codesAll(:,2);codesAll(:,3)];
codes_stand = [codesAll(:,4);codesAll(:,5);codesAll(:,6)];
codes_walk = [codesAll(:,7);codesAll(:,8);codesAll(:,9)];
codesAll_combined = [codes_sit,codes_stand,codes_walk];

% grab the lists of rejected trials (run this for every trial and copy and
% paste the list from the command line into the below variables x1:x9)
info_oneline = cellstr(ERP_walk_C.history); % change the ERP variable here for every trial
rejepoch = strfind(info_oneline,'rejepoch');
rejepochNum = rejepoch{1};
rejepochStart = rejepochNum + strfind(info_oneline{1}(rejepochNum:end),'[');
rejepochEnd = rejepochNum - 2 + strfind(info_oneline{1}(rejepochNum:end),']');
rejectedEpochsChar = info_oneline{1}(rejepochStart:rejepochEnd);
rejectedEpochsChar

x1 = [4 11 12 16 24 25 26 30 33 34 41 42 43 46 47 49 51 52 53 55 56 61 62 69 70 73 87 89 94 98 99 101 105 106 110 113 114 116 124 125 129 130 133 135 138 139:142 146 148 150 153 159 160 161 163 165 166:168 170 174 177 179 184 189 191 192 196 197 198 215 218 219 230 234 238 239:241 245 259 260 262 263:267 270 271 274 275 276 280 292 293 299 300];
x2 = [3 24 30 31:34 36 38 44 47 54 56 58 62 64 65 68 72 75 76 79 80 90 92 93:95 99 101 110 112 113 115 117 126 127 132 133 135 144 146 150 151 152 154 156 159 162 164 166 169 173 179 184 186 201 204 208 210 211 212 216 217 219 221 222 223 225 226 229 230:233 236 237 240 242 243 245 246 247 249 251 252:256 259 261 264 265 266 269 271 272 274 275 278 279 283 284:286 288 293 295 296 298];
x3 = [1:3 18 19 40 42 54 60 72 92 124 131 139 143 149 150 152 157 158 159 164 170 175 190 193 195 197 198 201 203 205 208 210 211 212 214 218 219 240 247 253 254 260 269 274 275 279 281 284 288 291 292:294 297 298:299];
x4 = [1 5 17 33 64 73 94 95 116 117 119 155 157 188 189 190 197 198 202 203:207 209 211 212:215 219 221 222 226 228 232 234 236 248 250 252 255 257 265 269 272 275 276 277 279 280 282 285 288 292 294 299];
x5 = [6 13 15 17 20 21 22 27 42 44 46 47 48 50 53 56 60 61 71 76 77 78 80 88 89 92 97 98 99 109 113 115 116:118 121 122 125 126:128 133 134 136 138 142 143 146 147 166 167 168 171 175 179 182 183 185 190 191 192 194 195:197 199 204 205 210 215 218 219 222 224 225 227 230 231 232 236 238 239 242 243 245 247 248 250 251 255 256 257 260 266 267 268 270 272 273 275 276:278 280 283 285 291 292:295 297:2:299];
x6 = [7 9 10 13 14 17 27 30 47 48 49 62 65 66 73 74 77 92 93 94 100 104 120 124 125 139 177 178 180 185 186 188 189 195 205 210 217 219 220 229 230 238 258 271 275 285 286 287 290 293 299];
x7 = [12 29 33 39 40 51 61 66 75 84 86 96 104 109 118 119 124 138 141 142 149 152 155 166 180 181 186 192 216 221 223 227 231 232 236 239 240 242 243 255 256 259 260 273 274 279 298 299];
x8 = [1 2 4 6 7 9 11 12 13 15 16 17 19 21 22:25 28 29 30 33 34:37 40 41:44 51 52 55 56:59 65 66 67 70 72 73:75 77 78 81 85 86 89 93 94 96 97 100 101 105 112 114 115:118 121 124 125 126 128 130 131 133 134:139 144 152 153 156 157 160 162 164 175 176 177 179 180:183 185 186:189 194 195 198 201 202 203 205 206 207 209 210:213 217 218:223 225 226:228 230 236 239 240 246 248 249 252 253 255:2:259 260 273 277 278:281 284 285 288 290 291 293 297 298];
x9 = [2:14 24 33 37 38:40 44 47 48:53 55 57 58 60 61 63 67 71 72 76 80 82:2:86 90 94 96 97 99:2:103 106 111 115 122 123 128 129 130 132 134 135 137 139 142 143 144 148 149:151 155 160 161 163 164 166 167 169 174 175 176 179 180 182 183:185 187 188 189 193 194:196 199 202 203:208 210 211 214 215 217 218 221 222 224 225 227 230 231 234 235 237 242 244 245 250 251:254 256 259 260:262 264 268 271 273 275 276:279 281 286 287:290 292 293 295 298 300];

for i = 1:1 % make sure to run this all together (only once)
    x_all = [ones(1,9)*4;zeros(300,9)];
    for ii = 1:numel(x1)
        x_all(x1(ii)+1,1) = 1;
    end
    for ii = 1:numel(x2)
        x_all(x2(ii)+1,2) = 1;
    end
    for ii = 1:numel(x3)
        x_all(x3(ii)+1,3) = 1;
    end
    for ii = 1:numel(x4)
        x_all(x4(ii)+1,4) = 1;
    end
    for ii = 1:numel(x5)
        x_all(x5(ii)+1,5) = 1;
    end
    for ii = 1:numel(x6)
        x_all(x6(ii)+1,6) = 1;
    end
    for ii = 1:numel(x7)
        x_all(x7(ii)+1,7) = 1;
    end
    for ii = 1:numel(x8)
        x_all(x8(ii)+1,8) = 1;
    end
    for ii = 1:numel(x9)
        x_all(x9(ii)+1,9) = 1;
    end
    
    clear totalAccepted targetsAccepted
    % for each one marked as rejected, assign its actual tone label
    for i = 1:9
        for ii = 1:size(x_all,1)
            if x_all(ii,i) == 1
                x_all(ii,i) = codesAll(ii,i);
            end
        end
totalAccepted(i) = numel(find(codesAll(:,i)))-numel(find(x_all(:,i)));
targetsAccepted(i) = numel(find(codesAll(:,i)==1))-numel(find(x_all(:,i)==1));

    end
end
RejectedTrials_S010 = array2table(x_all,'VariableNames',{'Sit_A','Sit_B','Sit_C','Stand_A','Stand_B','Stand_C','Walk_A','Walk_B','Walk_C'});

clear targetsAccepted_sit targetsAccepted_stand targetsAccepted_walk targetsAccepted_all
targetsAccepted_sit = sum(targetsAccepted(1:3));
targetsAccepted_stand = sum(targetsAccepted(4:6));
targetsAccepted_walk = sum(targetsAccepted(7:9));
targetsAccepted_all = [targetsAccepted_sit,targetsAccepted_stand,targetsAccepted_walk];
targetsAccepted_all_S010 = [targetsAccepted_sit,targetsAccepted_stand,targetsAccepted_walk,min(targetsAccepted_all)];
totalAccepted_all_S010 = [sum(totalAccepted(1:3)),sum(totalAccepted(4:6)),sum(totalAccepted(7:9))]
codes_all_S010 = codesAll;

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S010'
save('rejectedAcceptedTrials.mat','RejectedTrials_S010','targetsAccepted_all_S010','totalAccepted_all_S010'); % save list of numbers of targets accepted

%% S012
%For every trial, load the ERP file and grab the tone labels
ERP_sit_A = pop_loaderp('filename', 'erpset_S012_stand_walk_sit_A_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S012');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_A = codes;

ERP_sit_B = pop_loaderp('filename', 'erpset_S012_walk_sit_stand_B_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S012');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_B = codes;

ERP_sit_C = pop_loaderp('filename', 'erpset_S012_sit_stand_walk_C_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S012');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_C = codes;

ERP_stand_A = pop_loaderp('filename', 'erpset_S012_stand_walk_sit_A_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S012');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_A = codes;

ERP_stand_B = pop_loaderp('filename', 'erpset_S012_walk_sit_stand_B_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S012');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_B = codes;

ERP_stand_C = pop_loaderp('filename', 'erpset_S012_sit_stand_walk_C_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S012');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_C = codes;

ERP_walk_A = pop_loaderp('filename', 'erpset_S012_stand_walk_sit_A_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S012');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_A = codes;

ERP_walk_B = pop_loaderp('filename', 'erpset_S012_walk_sit_stand_B_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S012');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_B = codes;

ERP_walk_C = pop_loaderp('filename', 'erpset_S012_sit_stand_walk_C_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S012');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_C = codes;

codesAll = [codes_sit_A,codes_sit_B,codes_sit_C,codes_stand_A,codes_stand_B,codes_stand_C,codes_walk_A,codes_walk_B,codes_walk_C];
codes_sit = [codesAll(:,1);codesAll(:,2);codesAll(:,3)];
codes_stand = [codesAll(:,4);codesAll(:,5);codesAll(:,6)];
codes_walk = [codesAll(:,7);codesAll(:,8);codesAll(:,9)];
codesAll_combined = [codes_sit,codes_stand,codes_walk];

% grab the lists of rejected trials (run this for every trial and copy and
% paste the list from the command line into the below variables x1:x9)
info_oneline = cellstr(ERP_walk_C.history); % change the ERP variable here for every trial
rejepoch = strfind(info_oneline,'rejepoch');
rejepochNum = rejepoch{1};
rejepochStart = rejepochNum + strfind(info_oneline{1}(rejepochNum:end),'[');
rejepochEnd = rejepochNum - 2 + strfind(info_oneline{1}(rejepochNum:end),']');
rejectedEpochsChar = info_oneline{1}(rejepochStart:rejepochEnd);
rejectedEpochsChar

x1 = [1 2 11 12 14 30 38 39:41 64 66 67:69 79 81 84 86 87 101 102 104 105:107 112 113 122 124 127 136 151 161 162:165 171 178 183 184 187 194 203 204 211 213 214 219 220:222 224 229 246 254 255 256 261 263 270 281 282 291 292:298];
x2 = [1 2 18 19 50 54 55 77 84 89 90 91 101 113 114 116 136 174 225 235 260 263 264 294];
x3 = [1 12 14 38 44 45 54 69 74 78 79 80 114 151 154 178 188 209 238 259 282];
x4 = [1 6 18 19 21 25 26 34 35 46 48 50 63 69 70 74 75 83 84 88 99 112 113 129 137 138 139 153 159 167 206 218 219 221 224 225 227 238 239:241 245 246 253 273 274 275 279 280];
x5 = [1 53 54 64 73 74 88 101 104 105 126 148 152 166 169 170 189 221 263 279 285];
x6 = [31 45 48 61 62 63 68 72 92 145 162 164 165 168 173 223 232 272 273 285 299];
x7 = [1:9 11 12:32 34 35 38 39:59 61 64 66 67 70 73 74:77 79 80:84 88 89:93 95 98 99:151 155 156:217 219 220:241 243 244:256 258 261 262:266 269 270:272 274 276 277:283 287 288 292 293:300];
x8 = [1:3 5 6 9 10 16 17 19 22 27 28 29 32 33 36 37 39 40 43 44 47 51 54 55 57 61 62 67 68:70 73 75 76:78 80 82 83:91 94 95:102 104 107 108 111 112 117 121 123 125 126:129 133 134 137 138:140 143 144:147 149 150:153 155 156:159 161 162 164 165:169 172 173 175 176 180 182:2:186 189 190 192 193:198 200 201:203 205 206 207 209 210 212 214 215:219 222 224 225:231 233 234:246 248 249 250 252 254 255:258 260 261:269 271:2:275 276 279 280:282 286 288 290 291:298];
x9 = [1:4 6 9 19 24 29 31 40 47 52 53 59 60 65 66:68 74 76 77 86 97 108 110 124 125 127 128 129 140 141 143 145 163 169 172 182 183 184 189 196 200 201 203 205 206:209 214 228 236 240 241 251 252 254 260 262 263 267 268 275 285 286:288 290 298 299];

for i = 1:1 % make sure to run this all together (only once)
    x_all = [ones(1,9)*4;zeros(300,9)];
    for ii = 1:numel(x1)
        x_all(x1(ii)+1,1) = 1;
    end
    for ii = 1:numel(x2)
        x_all(x2(ii)+1,2) = 1;
    end
    for ii = 1:numel(x3)
        x_all(x3(ii)+1,3) = 1;
    end
    for ii = 1:numel(x4)
        x_all(x4(ii)+1,4) = 1;
    end
    for ii = 1:numel(x5)
        x_all(x5(ii)+1,5) = 1;
    end
    for ii = 1:numel(x6)
        x_all(x6(ii)+1,6) = 1;
    end
    for ii = 1:numel(x7)
        x_all(x7(ii)+1,7) = 1;
    end
    for ii = 1:numel(x8)
        x_all(x8(ii)+1,8) = 1;
    end
    for ii = 1:numel(x9)
        x_all(x9(ii)+1,9) = 1;
    end
    
    clear totalAccepted targetsAccepted
    % for each one marked as rejected, assign its actual tone label
    for i = 1:9
        for ii = 1:size(x_all,1)
            if x_all(ii,i) == 1
                x_all(ii,i) = codesAll(ii,i);
            end
        end
 totalAccepted(i) = numel(find(codesAll(:,i)))-numel(find(x_all(:,i)));
 targetsAccepted(i) = numel(find(codesAll(:,i)==1))-numel(find(x_all(:,i)==1));

    end
end
RejectedTrials_S012 = array2table(x_all,'VariableNames',{'Sit_A','Sit_B','Sit_C','Stand_A','Stand_B','Stand_C','Walk_A','Walk_B','Walk_C'});

clear targetsAccepted_sit targetsAccepted_stand targetsAccepted_walk targetsAccepted_all
targetsAccepted_sit = sum(targetsAccepted(1:3));
targetsAccepted_stand = sum(targetsAccepted(4:6));
targetsAccepted_walk = sum(targetsAccepted(7:9));
targetsAccepted_all = [targetsAccepted_sit,targetsAccepted_stand,targetsAccepted_walk];
targetsAccepted_all_S012 = [targetsAccepted_sit,targetsAccepted_stand,targetsAccepted_walk,min(targetsAccepted_all)];
totalAccepted_all_S012 = [sum(totalAccepted(1:3)),sum(totalAccepted(4:6)),sum(totalAccepted(7:9))]
codes_all_S012 = codesAll;

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S012'
save('rejectedAcceptedTrials.mat','RejectedTrials_S012','targetsAccepted_all_S012','totalAccepted_all_S012'); % save list of numbers of targets accepted

%% S013
%For every trial, load the ERP file and grab the tone labels
ERP_sit_A = pop_loaderp('filename', 'erpset_S013_sit_stand_walk_A_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S013');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_A = codes;

ERP_sit_B = pop_loaderp('filename', 'erpset_S013_stand_walk_sit_B_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S013');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_B = codes;

ERP_sit_C = pop_loaderp('filename', 'erpset_S013_walk_sit_stand_C_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S013');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_C = codes;

ERP_stand_A = pop_loaderp('filename', 'erpset_S013_sit_stand_walk_A_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S013');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_A = codes;

ERP_stand_B = pop_loaderp('filename', 'erpset_S013_stand_walk_sit_B_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S013');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_B = codes;

ERP_stand_C = pop_loaderp('filename', 'erpset_S013_walk_sit_stand_C_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S013');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_C = codes;

ERP_walk_A = pop_loaderp('filename', 'erpset_S013_sit_stand_walk_A_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S013');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_A = codes;

ERP_walk_B = pop_loaderp('filename', 'erpset_S013_stand_walk_sit_B_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S013');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_B = codes;

ERP_walk_C = pop_loaderp('filename', 'erpset_S013_walk_sit_stand_C_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S013');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_C = codes;

codesAll = [codes_sit_A,codes_sit_B,codes_sit_C,codes_stand_A,codes_stand_B,codes_stand_C,codes_walk_A,codes_walk_B,codes_walk_C];
codes_sit = [codesAll(:,1);codesAll(:,2);codesAll(:,3)];
codes_stand = [codesAll(:,4);codesAll(:,5);codesAll(:,6)];
codes_walk = [codesAll(:,7);codesAll(:,8);codesAll(:,9)];
codesAll_combined = [codes_sit,codes_stand,codes_walk];

% grab the lists of rejected trials (run this for every trial and copy and
% paste the list from the command line into the below variables x1:x9)
info_oneline = cellstr(ERP_walk_C.history); % change the ERP variable here for every trial
rejepoch = strfind(info_oneline,'rejepoch');
rejepochNum = rejepoch{1};
rejepochStart = rejepochNum + strfind(info_oneline{1}(rejepochNum:end),'[');
rejepochEnd = rejepochNum - 2 + strfind(info_oneline{1}(rejepochNum:end),']');
rejectedEpochsChar = info_oneline{1}(rejepochStart:rejepochEnd);
rejectedEpochsChar

x1 = [11 21 22:25 41 65 75 93 95 118 158 159 171 245 250 266 268 277 284 285 286 292 300];
x2 = [13 17 62 63 126 128 129 174 177 187 209 210 240 278 299 300];
x3 = [8 32 69 80 87 99 108 110 111 130 134 172 187 188 202 203 210 221 226 234 242 289];
x4 = [28 30 53 54 71 77 78 98 123 124 158 183 197 227 282 292];
x5 = [14:17 20 36 42 87 88 100 154 162 193 197 204 233 242 259 266 267 295 298];
x6 = [15 19 21 36 68 95 120 121 126 128 129 155 159 176 185 186 206 207 216 220 238 245 289 290];
x7 = [1:4:9 12 16 17 23 24 30 37 48 60 83 87 114 132 137 163 195 220 234 235 240 299 300];
x8 = [5 22 30 37 85 99 104 159 167 178 179 193 210 222 238 239 254 285];
x9 = [5 34 52 55 73 75 76 78 91 111 132 182 184 185 196 225 260 290];

for i = 1:1 % make sure to run this all together (only once)
    x_all = [ones(1,9)*4;zeros(300,9)];
    for ii = 1:numel(x1)
        x_all(x1(ii)+1,1) = 1;
    end
    for ii = 1:numel(x2)
        x_all(x2(ii)+1,2) = 1;
    end
    for ii = 1:numel(x3)
        x_all(x3(ii)+1,3) = 1;
    end
    for ii = 1:numel(x4)
        x_all(x4(ii)+1,4) = 1;
    end
    for ii = 1:numel(x5)
        x_all(x5(ii)+1,5) = 1;
    end
    for ii = 1:numel(x6)
        x_all(x6(ii)+1,6) = 1;
    end
    for ii = 1:numel(x7)
        x_all(x7(ii)+1,7) = 1;
    end
    for ii = 1:numel(x8)
        x_all(x8(ii)+1,8) = 1;
    end
    for ii = 1:numel(x9)
        x_all(x9(ii)+1,9) = 1;
    end
    
    clear totalAccepted targetsAccepted
    % for each one marked as rejected, assign its actual tone label
    for i = 1:9
        for ii = 1:size(x_all,1)
            if x_all(ii,i) == 1
                x_all(ii,i) = codesAll(ii,i);
            end
        end
totalAccepted(i) = numel(find(codesAll(:,i)))-numel(find(x_all(:,i)));
targetsAccepted(i) = numel(find(codesAll(:,i)==1))-numel(find(x_all(:,i)==1));

    end
end
RejectedTrials_S013 = array2table(x_all,'VariableNames',{'Sit_A','Sit_B','Sit_C','Stand_A','Stand_B','Stand_C','Walk_A','Walk_B','Walk_C'});

clear targetsAccepted_sit targetsAccepted_stand targetsAccepted_walk targetsAccepted_all
targetsAccepted_sit = sum(targetsAccepted(1:3));
targetsAccepted_stand = sum(targetsAccepted(4:6));
targetsAccepted_walk = sum(targetsAccepted(7:9));
targetsAccepted_all = [targetsAccepted_sit,targetsAccepted_stand,targetsAccepted_walk];
targetsAccepted_all_S013 = [targetsAccepted_sit,targetsAccepted_stand,targetsAccepted_walk,min(targetsAccepted_all)];
totalAccepted_all_S013 = [sum(totalAccepted(1:3)),sum(totalAccepted(4:6)),sum(totalAccepted(7:9))]
codes_all_S013 = codesAll;

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S013'
save('rejectedAcceptedTrials.mat','RejectedTrials_S013','targetsAccepted_all_S013','totalAccepted_all_S013'); % save list of numbers of targets accepted

%% S014
%For every trial, load the ERP file and grab the tone labels
ERP_sit_A = pop_loaderp('filename', 'erpset_S014_stand_sit_walk_A_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S014');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_A = codes;

ERP_sit_B = pop_loaderp('filename', 'erpset_S014_sit_walk_stand_B_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S014');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_B = codes;

ERP_sit_C = pop_loaderp('filename', 'erpset_S014_walk_stand_sit_C_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S014');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_sit_C = codes;

ERP_stand_A = pop_loaderp('filename', 'erpset_S014_stand_sit_walk_A_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S014');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_A = codes;

ERP_stand_B = pop_loaderp('filename', 'erpset_S014_sit_walk_stand_B_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S014');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_B = codes;

ERP_stand_C = pop_loaderp('filename', 'erpset_S014_walk_stand_sit_C_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S014');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_stand_C = codes;

ERP_walk_A = pop_loaderp('filename', 'erpset_S014_stand_sit_walk_A_0002_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S014');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_A = codes;

ERP_walk_B = pop_loaderp('filename', 'erpset_S014_sit_walk_stand_B_0001_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S014');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_B = codes;

ERP_walk_C = pop_loaderp('filename', 'erpset_S014_walk_stand_sit_C_filt_a_b_2_allTrials_ICA_Num.erp',...
    'filepath', 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S014');
codes = ones(301,1);
for i = 1:numel(codes)
    codes(i) = ERP.EVENTLIST.eventinfo(i).code;
end
codes_walk_C = codes;

codesAll = [codes_sit_A,codes_sit_B,codes_sit_C,codes_stand_A,codes_stand_B,codes_stand_C,codes_walk_A,codes_walk_B,codes_walk_C];
codes_sit = [codesAll(:,1);codesAll(:,2);codesAll(:,3)];
codes_stand = [codesAll(:,4);codesAll(:,5);codesAll(:,6)];
codes_walk = [codesAll(:,7);codesAll(:,8);codesAll(:,9)];
codesAll_combined = [codes_sit,codes_stand,codes_walk];

% grab the lists of rejected trials (run this for every trial and copy and
% paste the list from the command line into the below variables x1:x9)
info_oneline = cellstr(ERP_sit_A.history); %1 change the ERP variable here for every trial
info_oneline = cellstr(ERP_sit_B.history); %2 change the ERP variable here for every trial
info_oneline = cellstr(ERP_sit_C.history); %3 change the ERP variable here for every trial
info_oneline = cellstr(ERP_stand_A.history); %4 change the ERP variable here for every trial
info_oneline = cellstr(ERP_stand_B.history); %5 change the ERP variable here for every trial
info_oneline = cellstr(ERP_stand_C.history); %6 change the ERP variable here for every trial
info_oneline = cellstr(ERP_walk_A.history); %7 change the ERP variable here for every trial
info_oneline = cellstr(ERP_walk_B.history); %8 change the ERP variable here for every trial
info_oneline = cellstr(ERP_walk_C.history); %9 change the ERP variable here for every trial

rejepoch = strfind(info_oneline,'rejepoch');
rejepochNum = rejepoch{1};
rejepochStart = rejepochNum + strfind(info_oneline{1}(rejepochNum:end),'[');
rejepochEnd = rejepochNum - 2 + strfind(info_oneline{1}(rejepochNum:end),']');
rejectedEpochsChar = info_oneline{1}(rejepochStart:rejepochEnd);
rejectedEpochsChar

x1 = [2 32 59 80 86 87 89 106 107:137 142 149 150 151 155 156:159 166 167 176 177 184 186 232 238 244 258 259 262 269 272];
x2 = [2 4 20 21 24 25 30 31:34 37 38:40 45 46 47 50 58 59:61 72 73 74 81 84 89 90:127 138 139 146 147 152 160 161 162 182 185 186 190 194 195:197 199 207 208:212 215 219 221 226 227:229 231 235 237 247 258 259 260 276 288 293];
x3 = [40 45 68 70 72 77 78 94 95 103 104 106 140 156 157 198 201 205 207 210 214 233 246 252 292];
x4 = [1 7 25 66 77 109 113 114 119 122 133 143 165 176 178 186 199 219 223 228 233 276 279];
x5 = [4 7 13 26 33 57 58 61 63 65 66 80 106 114 115 116 118 121 136 137 141 156 159 179 185 208 211 212:270 272 273 286 288 297 298];
x6 = [1:8 14 21 22 25 26 36 38 52 56 63 66 71 72:74 79 80:92 100 101 102 109 113 122 123 135 136 137 140 142 143:154 156 159 161 170 174 183 189 190:192 203 219 220 229 231 232:236 239 245 246 247 249 250 251 272 273 285 286 288 291 292 293 295];
x7 = [4 5 13 14:21 32 42 43 51 58 59:73 78 82 88 89:92 94 95:108 114 116 125 129 144 145 151 157 161 163 165 168 169 172 173 177 185 187 188 190 195 196:199 205 206 213 214 216 220 222 224 225 226 228 232 233 235 236 241 245 247 248 249 251 253 254 258 261 263 264 266 267:269 271 275 276 277 279 280 282 283 284 287 288:292 294 299 300];
x8 = [1:3 5 7 8 10 12 13 16 17:21 23 26 28 30 31:41 43 44 47 51 54 55 56 60 61 62 64 66 67 69 70 72 75 76 78:2:82 83 87 88 90 91 93 96 99 101 102 104 108 109 114 118 119:126 128 129 131 132:135 138 139 146 147 149 150:156 158 159:162 164 165 167 168:178 180 181 182 185 186:189 191 192 197 199 200:203 205 207 208:210 213 217 218:232 234 240 241:248 250 251:262 264 265 267 268 271 272:274 276 277 280 281 284 285:287 289 290:293 295 296:298 300];
x9 = [1 3 4 6 9 11 14 16 24 25:27 32 33:35 38 39 51 52:54 59 60 63 66 67 69 70 73 84 86 87 96 102 105 107 114 119 120 121 123 124 125 129 130:140 142 143 145 146 147 151 152:160 162 163:169 171 172 176 180 183 184 185 198 208 222 226 236 238 239 240 242 247 248 250 252 256 268 271 290];

for i = 1:1 % make sure to run this all together (only once)
    x_all = [ones(1,9)*4;zeros(300,9)];
    for ii = 1:numel(x1)
        x_all(x1(ii)+1,1) = 1;
    end
    for ii = 1:numel(x2)
        x_all(x2(ii)+1,2) = 1;
    end
    for ii = 1:numel(x3)
        x_all(x3(ii)+1,3) = 1;
    end
    for ii = 1:numel(x4)
        x_all(x4(ii)+1,4) = 1;
    end
    for ii = 1:numel(x5)
        x_all(x5(ii)+1,5) = 1;
    end
    for ii = 1:numel(x6)
        x_all(x6(ii)+1,6) = 1;
    end
    for ii = 1:numel(x7)
        x_all(x7(ii)+1,7) = 1;
    end
    for ii = 1:numel(x8)
        x_all(x8(ii)+1,8) = 1;
    end
    for ii = 1:numel(x9)
        x_all(x9(ii)+1,9) = 1;
    end
    
    clear totalAccepted targetsAccepted
    % for each one marked as rejected, assign its actual tone label
    for i = 1:9
        for ii = 1:size(x_all,1)
            if x_all(ii,i) == 1
                x_all(ii,i) = codesAll(ii,i);
            end
        end
totalAccepted(i) = numel(find(codesAll(:,i)))-numel(find(x_all(:,i)));
targetsAccepted(i) = numel(find(codesAll(:,i)==1))-numel(find(x_all(:,i)==1));
    end
end
RejectedTrials_S014 = array2table(x_all,'VariableNames',{'Sit_A','Sit_B','Sit_C','Stand_A','Stand_B','Stand_C','Walk_A','Walk_B','Walk_C'});

clear targetsAccepted_sit targetsAccepted_stand targetsAccepted_walk targetsAccepted_all
targetsAccepted_sit = sum(targetsAccepted(1:3));
targetsAccepted_stand = sum(targetsAccepted(4:6));
targetsAccepted_walk = sum(targetsAccepted(7:9));
targetsAccepted_all = [targetsAccepted_sit,targetsAccepted_stand,targetsAccepted_walk];
targetsAccepted_all_S014 = [targetsAccepted_sit,targetsAccepted_stand,targetsAccepted_walk,min(targetsAccepted_all)];
totalAccepted_all_S014 = [sum(totalAccepted(1:3)),sum(totalAccepted(4:6)),sum(totalAccepted(7:9))]
codes_all_S014 = codesAll;

cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S014'
save('rejectedAcceptedTrials.mat','RejectedTrials_S014','targetsAccepted_all_S014','totalAccepted_all_S014'); % save list of numbers of targets accepted

%% Select minimum number of accepted targets
% do this once after all subjects are done
targetsAccepted_allSubs = [targetsAccepted_all_S003;targetsAccepted_all_S005;targetsAccepted_all_S006;targetsAccepted_all_S007;targetsAccepted_all_S008;targetsAccepted_all_S009;targetsAccepted_all_S010;targetsAccepted_all_S012;targetsAccepted_all_S013;targetsAccepted_all_S014];
TargetsAccepted_allSubs = array2table(targetsAccepted_allSubs,'VariableNames',{'Sit','Stand','Walk','Min'},'RowNames',{'S003','S005','S006','S007','S008','S009','S010','S012','S013','S014'});
totalAccepted_allSubs = [totalAccepted_all_S003;totalAccepted_all_S005;totalAccepted_all_S006;totalAccepted_all_S007;totalAccepted_all_S008;totalAccepted_all_S009;totalAccepted_all_S010;totalAccepted_all_S012;totalAccepted_all_S013;totalAccepted_all_S014];
TotalAccepted_allSubs = array2table(totalAccepted_allSubs,'VariableNames',{'Sit','Stand','Walk'},'RowNames',{'S003','S005','S006','S007','S008','S009','S010','S012','S013','S014'});

targetsNewNum = min(targetsAccepted_allSubs(:))




















% %% This returns the list of rejected epochs from the (pre-loaded) ERP file.
% info_oneline = cellstr(ERP.history);
% rejepoch = strfind(info_oneline,'rejepoch');
% rejepochNum = rejepoch{1};
% rejepochStart = rejepochNum + strfind(info_oneline{1}(rejepochNum:end),'[');
% rejepochEnd = rejepochNum + strfind(info_oneline{1}(rejepochNum:end),']');
% rejectedEpochsChar = info_oneline{1}(rejepochStart:rejepochEnd);
% rejectedEpochs = zeros(300,1);
% rejectedEpochs(1:281) = rejectedEpochsChar(1:end);
% %% graph trial numbers
% 
% x1L = 300-length(x1);
% x2L = 300-length(x2);
% x3L = 300-length(x3);
% x4L = 300-length(x4);
% x5L = 300-length(x5);
% x6L = 300-length(x6);
% x7L = 300-length(x7);
% x8L = 300-length(x8);
% x9L = 300-length(x9);
% l = cell(1,3);
% l{1}='A'; l{2}='B'; l{3}='C'; 
% m = cell(1,3);
% m{1}='Sit'; m{2}='Stand'; m{3}='Walk';
% xL = [x1L x2L x3L;x4L x5L x6L;x7L x8L x9L];
% figure()
% h = bar(xL,'stacked')
% legend(h,l)
% set(gca,'xticklabel', m)
% title('S010')
% ylabel('Number of Trials')
% 
% S003_Sit = S003_sit(2).Position(2);
% S005_Sit = S005_sit(2).Position(2);
% S006_Sit = S006_sit(2).Position(2);
% S007_Sit = S007_sit(2).Position(2);
% S008_Sit = S008_sit(2).Position(2);
% S009_Sit = S009_sit(2).Position(2);
% S010_Sit = S010_sit(2).Position(2);
% S012_Sit = S012_sit(2).Position(2);
% 
% Pilot2_Sit = mean([S003_Sit;S005_Sit;S006_Sit;S007_Sit;S008_Sit;S009_Sit;S010_Sit;S012_Sit]);
% 
% S003_Stand = S003_stand(2).Position(2);
% S005_Stand = S005_stand(2).Position(2);
% S006_Stand = S006_stand(2).Position(2);
% S007_Stand = S007_stand(2).Position(2);
% S008_Stand = S008_stand(2).Position(2);
% S009_Stand = S009_stand(2).Position(2);
% S010_Stand = S010_stand(2).Position(2);
% 
% Pilot2_Stand = mean([S003_Stand;S005_Stand;S006_Stand;S007_Stand;S008_Stand;S009_Stand;S010_Stand]);
% 
% % totals(1,1)=S003_sit(1).Position(2);
% % totals(1,2)=S003_sit(2).Position(2);
% % totals(1,3)=S003_sit(3).Position(2);
% % totals(2,1)=S005_sit(2).Position(2);
% % totals(2,2)=S005_sit(1).Position(2);
% % totals(2,3)=S005_sit(3).Position(2);
% % totals(3,1)=S006_sit(1).Position(2);
% % totals(3,2)=S006_sit(2).Position(2);
% % totals(3,3)=S006_sit(3).Position(2);
% % totals(4,1)=S007_sit(2).Position(2);
% % totals(4,2)=S007_sit(1).Position(2);
% % totals(4,3)=S007_sit(3).Position(2);
% % totals(5,1)=S008_sit(2).Position(2);
% % totals(5,2)=S008_sit(1).Position(2);
% % totals(5,3)=S008_sit(3).Position(2);
% % totals(6,1)=S009_sit(2).Position(2);
% % totals(6,2)=S009_sit(1).Position(2);
% % totals(6,3)=S009_sit(3).Position(2);
% % totals(7,1)=S010_sit(2).Position(2);
% % totals(7,2)=S010_sit(1).Position(2);
% % totals(7,3)=S010_sit(3).Position(2);
% 
% Totals = array2table(totals(1:7,:), 'VariableNames',{'Sit','Stand','Walk'},'RowNames',{'S003','S005','S006','S007','S008','S009','S010'});
% Totals(8,:) = array2table(mean(totals),'RowNames',{'Average'});
% 
% for i = 1:numel(Totals(:,1)); 
%     minTrials(i,1) = min(totals(i,:)); 
% end
% 
% Totals(:,4) = array2table(minTrials,'VariableNames',{'Min'});
% 
% %another option instead of exporting cursor data from graph:
% totals(6,3)=900-numel(find(table2array(S009_rejectedTrials(:,7:9))));
% totals(7,1)=900-numel(find(table2array(S010_rejectedTrials(:,1:3))));
% %etc.
% 
% %% do this only once per subject
% Sn = 5; % subject number
% clear rejectedTrials_new
% rejectedTrials_new = table2array(S008_rejectedTrials);
% 
% clear list s reject newlist b 
% list_rej=find(table2array(S008_rejectedTrials(:,1:3))==0);
% s = RandStream('mlfg6331_64');
% reject = randsample(numel(list_rej),numel(list_rej)-minTrials(Sn));
% newlist=list_rej;
% newlist(reject)=0;
% 
% for i = 1:numel(list_rej)
%     if newlist(i) == 0 && list_rej(i) < 301
%         b = list_rej(i);
%         rejectedTrials_new(b,1)=1;
%     elseif newlist(i) == 0 && list_rej(i) > 600
%         b = list_rej(i)-600;
%         rejectedTrials_new(b,3)=1;
%     elseif newlist(i) == 0 && list_rej(i) < 601 && list_rej(i) > 300
%         b = list_rej(i)-300;
%         rejectedTrials_new(b,2)=1;
%     end
% end
% 
% clear list s reject newlist b 
% list_rej=find(table2array(S008_rejectedTrials(:,4:6))==0);
% s = RandStream('mlfg6331_64');
% reject = randsample(numel(list_rej),numel(list_rej)-minTrials(Sn));
% newlist=list_rej;
% newlist(reject)=0;
% 
% for i = 1:numel(list_rej)
%     if newlist(i) == 0 && list_rej(i) < 301
%         b = list_rej(i);
%         rejectedTrials_new(b,4)=1;
%     elseif newlist(i) == 0 && list_rej(i) > 600
%         b = list_rej(i)-600;
%         rejectedTrials_new(b,6)=1;
%     elseif newlist(i) == 0 && list_rej(i) < 601 && list_rej(i) > 300
%         b = list_rej(i)-300;
%         rejectedTrials_new(b,5)=1;
%     end
% end
% 
% clear list s reject newlist b 
% list_rej=find(table2array(S008_rejectedTrials(:,7:9))==0);
% s = RandStream('mlfg6331_64');
% reject = randsample(numel(list_rej),numel(list_rej)-minTrials(Sn));
% newlist=list_rej;
% newlist(reject)=0;
% 
% for i = 1:numel(list_rej)
%     if newlist(i) == 0 && list_rej(i) < 301
%         b = list_rej(i);
%         rejectedTrials_new(b,7)=1;
%     elseif newlist(i) == 0 && list_rej(i) > 600
%         b = list_rej(i)-600;
%         rejectedTrials_new(b,9)=1;
%     elseif newlist(i) == 0 && list_rej(i) < 601 && list_rej(i) > 300
%         b = list_rej(i)-300;
%         rejectedTrials_new(b,8)=1;
%     end
% end
% 
% newTrials = minTrials(Sn)-[numel(find(rejectedTrials_new(:,1:3)==0)) numel(find(rejectedTrials_new(:,4:6)==0)) numel(find(rejectedTrials_new(:,7:9)==0))]
% %%
% S008_rejectedTrials_new = rejectedTrials_new;
% cd 'Z:\Lab Member Folders\Margaret Swerdloff\EEG-gait\EEG\Matlab_data\Pilot2\S008'; 
% for i = 1:9
%     dlmwrite('S008_rejectedTrials_equalized.txt',find(rejectedTrials_new(:,i)'),'delimiter',' ','newline','pc')
% end