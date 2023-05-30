%% Basal forebrain project
% 2023-basal-timing, S P Errington, January 2023
% > Project description will go here

%% Dev notes:
% None (2023-05-23)

%% Setup workspace
% Clear workspace
clear all; close all; clc; beep off; warning off;

% Define paths & key directories
dirs = get_dirs_bf('wustl');
params = get_params;
status = get_status(dirs);

%% Data extraction
switch status
    case 'data' %(approximately 16GB RAM usage)
        load_proc_data
        get_master_datatable
    case 'extract'
        % Basal forebrain data -------------------------
        pavlovian_bf_master % Pavlovian task data
        pavlovian_bf_master2 % Pavlovian task data
        punish_bf_master    % Punish task data
        timing_bf_master    % Timing task data
        trace_bf_master     % Trace task data
        
        % Striatum data --------------------------------
        pavlovian_striatum_master % Pavlovian task data
        timing_striatum_master
        trace_striatum_master     % Trace task data
end

%% Analyses:
bf_analyses_map

%% Figures:
figure_primary
