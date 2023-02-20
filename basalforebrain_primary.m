%% Basal forebrain project
% 2023-basal-timing, S P Errington, January 2023
% > Project description will go here

%% Setup workspace
% Clear workspace
clear all; close all; clc; beep off; warning off;

% Define paths & key directories
dirs = get_dirs_bf('wustl');
params = get_params;

%% Analysis
% Basal forebrain: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
pavlovian_master % Pavlovian task data
timing_master    % Timing task data
trace_master     % Trace task data

% Striatum: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


%% Figures: 
figure_primary