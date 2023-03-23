%% Basal forebrain project
% 2023-basal-timing, S P Errington, January 2023
% > Project description will go here


%% Dev notes:
% 2023-03-14: updated CS data to include a trial structure for certain v
%             uncertain


%% Setup workspace
% Clear workspace
clear all; close all; clc; beep off; warning off;

% Define paths & key directories
dirs = get_dirs_bf('home');
params = get_params;
status = get_status(dirs);

%% Analysis
switch status
    case 'data' %(approximately 16GB RAM usage)
        load_proc_data
        get_master_datatable
    case 'extract'
        % Basal forebrain data -------------------------
        pavlovian_bf_master % Pavlovian task data
        timing_bf_master    % Timing task data
        trace_bf_master     % Trace task data
        
        % Striatum data --------------------------------
        pavlovian_striatum_master % Pavlovian task data
        timing_striatum_master
        trace_striatum_master     % Trace task data
end

%% Figures: 
figure_primary
figure_primary_worksheet
