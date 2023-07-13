%% Load processed data
clc; fprintf('Loading pre-extracted data \n')

switch system_id
    case 'wustl'
        data_dir = fullfile(dirs.root,'data','large');
        
    case 'home'
        data_dir = 'C:\Users\Steven\Box Sync\Research\2023-basal-timing\data';
        
    case 'mac'
        data_dir = '/Users/stevenerrington/Box Sync/Research/2023-basal-timing/data';
end



%% Load data:
% Neurophysiology files
load(fullfile(data_dir,'bf_data_CS_spkRemoved.mat')) %bf_data_CS_spkRemoved
load(fullfile(data_dir,'bf_data_CS2.mat'))
load(fullfile(data_dir,'bf_data_timingTask.mat'))
load(fullfile(data_dir,'bf_data_traceExp.mat'))
load(fullfile(data_dir,'bf_data_punish.mat'))
load(fullfile(data_dir,'striatum_data_CS_spkRemoved.mat'))
load(fullfile(data_dir,'striatum_data_traceExp.mat'))
load(fullfile(data_dir,'striatum_data_timingTask.mat'))

% Datasheet files
load(fullfile(data_dir,'bf_datasheet_CS.mat'))
load(fullfile(data_dir,'bf_datasheet_CS2.mat'))
load(fullfile(data_dir,'bf_datasheet_timingExp.mat'))
load(fullfile(data_dir,'bf_datasheet_traceExp.mat'))
load(fullfile(data_dir,'bf_datasheet_punish.mat'))
load(fullfile(data_dir,'striatum_datasheet_CS.mat'))
load(fullfile(data_dir,'striatum_datasheet_traceExp.mat'))
load(fullfile(data_dir,'striatum_datasheet_timingExp.mat'))

clear data_dir