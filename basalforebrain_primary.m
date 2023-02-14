%% Basal forebrain project
% 2023-basal-timing, S P Errington, January 2023
% > Project description will go here


%% Setup workspace
% Clear workspace
clear all; close all; clc; beep off; warning off;

% Define paths & key directories
dirs = get_dirs_bf('home');
params = get_params;

%% Analysis
% Pavlovian task data
pavlovian_master
% > Figures: (1), (2), (3), (4), (5)

% Timing task data
timing_master
% > Figures: (6), (7)

% Trace task data
trace_master

%% Figures: 
plot_cs_exampleNeuron_phasic  %(1)
plot_cs_exampleNeuron_ramping %(2)
plot_cs_fanoBar_phasicramping %(3)
plot_cs_fanoSpider            %(4)
plot_cs_rwdOutcomeFanoBoxplot %(5)

plot_timing_exampleNeuron_ramping %(6)
plot_timing_exampleNeuron_ramping %(7)

plot_crosstask_fanofactor %(8)
