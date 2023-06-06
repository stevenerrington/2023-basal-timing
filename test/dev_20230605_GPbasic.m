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
colors.appetitive = [247 154 154; 244 107 107; 240 59 59; 230 18 18; 182 14 14]./255;


%%
vp_files = [];
vp_files = dir(fullfile('X:\MONKEYDATA\Batman\GP_ApetAver','*.mat'));

%% 

for neuron_i = 2
    filename = vp_files(neuron_i).name;
    load(['X:\MONKEYDATA\Batman\GP_ApetAver\' filename],'PDS')
    
    % Get trial indices
    trials = get_trials(PDS);
    % Get event aligned rasters
    Rasters = get_raster(PDS, trials, params); % Derived from Timing2575Group.m
    % Get event aligned spike-density function
    SDF = plot_mean_psth({Rasters},params.sdf.gauss_ms,1,size(Rasters,2),1);
    
    fano = get_fano(Rasters,trials, params);
    
    figure;
    subplot(2,1,1); hold on
    plot([-5000:5000],nanmean(SDF(trials.prob0,:)),'color',colors.appetitive(1,:))
    plot([-5000:5000],nanmean(SDF(trials.prob25,:)),'color',colors.appetitive(2,:))
    plot([-5000:5000],nanmean(SDF(trials.prob50,:)),'color',colors.appetitive(3,:))
    plot([-5000:5000],nanmean(SDF(trials.prob75,:)),'color',colors.appetitive(4,:))
    plot([-5000:5000],nanmean(SDF(trials.prob100,:)),'color',colors.appetitive(5,:))
    xlim([0 2500])
    title(filename)
    
    subplot(2,1,2); hold on
    plot(fano.time,fano.smooth.prob0,'color',colors.appetitive(1,:))
    plot(fano.time,fano.smooth.prob25,'color',colors.appetitive(2,:))
    plot(fano.time,fano.smooth.prob50,'color',colors.appetitive(3,:))
    plot(fano.time,fano.smooth.prob75,'color',colors.appetitive(4,:))
    plot(fano.time,fano.smooth.prob100,'color',colors.appetitive(5,:))
    hline(1,'k-')
    xlim([0 2500])

end
