%% Load processed data
clc
fprintf('Loading pre-extracted data \n')
% Extracted beh & neurophys
load(fullfile(dirs.root,'data','large','bf_data_CS.mat'))
load(fullfile(dirs.root,'data','large','bf_data_timingTask.mat'))
load(fullfile(dirs.root,'data','large','bf_data_traceExp.mat'))
load(fullfile(dirs.root,'data','large','striatum_data_CS.mat'))
load(fullfile(dirs.root,'data','large','striatum_data_traceExp.mat'))
% Extracted datasheets
load(fullfile(dirs.root,'data','large','bf_datasheet_CS.mat'))
load(fullfile(dirs.root,'data','large','bf_datasheet_timingExp.mat'))
load(fullfile(dirs.root,'data','large','bf_datasheet_traceExp.mat'))
load(fullfile(dirs.root,'data','large','striatum_datasheet_CS.mat'))
load(fullfile(dirs.root,'data','large','striatum_datasheet_traceExp.mat'))