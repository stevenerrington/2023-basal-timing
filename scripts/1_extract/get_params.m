function params = get_params()

% Define analysis parameters
% % Figures
params.plot.ylim = 150; %PLOT YLIM for spike density functions (PlotYm)

% % SDF
params.sdf.gauss_ms = 100; % for making a spike density function (fits each spike with a 100ms gauss; gauswindow_ms)
params.sdf.window = [-500 1000]; % [min max] window for spike density function
params.raster.cleanFlag = 0;

% % Fano factor
params.fano.bin_size = 100; % Bin size for Fano Factor analysis (get_fano)
params.fano.smooth_bin = 100;

% % Statistics
params.stats.n_perms = 100; % Number of permutations for permutation tests (NumberofPermutations)
params.stats.corr_thresh = 0.01; % Statistical threshold for correlational analysis (CorTh)
params.stats.stat_bin = 101; % UNKNOWN (2023-01-23; BinForStat)

end
