%% Basal forebrain project
% 2023-basal-timing, S P Errington, January 2023
% > Project description will go here

%% Dev notes:
%   2023-06-02: Continuing development.

%% Setup workspace
% Clear workspace
clear all; close all; clc; beep off; warning off;

% Define paths & key directories
system_id = 'mac';
dirs = get_dirs_bf(system_id); params = get_params; status = get_status(dirs);

%% Data extraction
switch status
    case 'data' %(approximately 16GB RAM usage)
        load_proc_data; curate_proc_data;
    case 'extract'
        run_primary_extraction
end

%% Analyses
bf_analyses_map

