%% Basal forebrain project
% 2023-basal-timing, S P Errington, January 2023
% > Project description will go here


%% Setup workspace
% > INSERT DESCRIPTION HERE

% Clear workspace
clear all; close all; clc; beep off; warning off;

% Define paths & key directories
dirs = get_dirs_bf('wustl');
params = get_params;

%% Analysis: Pavlovian task data
% > INSERT DESCRIPTION HERE

pavlovian_master

% Figures:
plot_ramping_exampleNeuron
plot_ramping_population % < NEEDS DOING

%% Analysis: Timing task data
% > INSERT DESCRIPTION HERE

timing_master

%% Analysis: Trace task data
% > INSERT DESCRIPTION HERE

trace_master



