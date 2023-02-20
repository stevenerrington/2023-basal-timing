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
pavlovian_bf_master % Pavlovian task data
timing_bf_master    % Timing task data
trace_bf_master     % Trace task data

% Striatum: >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
pavlovian_striatum_master

%% Figures: 
figure_primary