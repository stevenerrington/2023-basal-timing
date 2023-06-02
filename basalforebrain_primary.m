%% Basal forebrain project
% 2023-basal-timing, S P Errington, January 2023
% > Project description will go here

%% Dev notes:
%   2023-06-02: Continuing development.

%% Setup workspace
% Clear workspace
clear all; close all; clc; beep off; warning off;

% Define paths & key directories
dirs = get_dirs_bf('wustl'); params = get_params; status = get_status(dirs);

%% Data extraction
switch status
    case 'data' %(approximately 16GB RAM usage)
        load_proc_data; curate_proc_data;
    case 'extract'
        run_primary_extraction
end

%% Analyses
% 1 | Basal forebrain neurons ramp to salient events (appetetive and
%     aversive)



%% Worksheet
bf_analyses_map


