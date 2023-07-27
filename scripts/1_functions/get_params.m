function params = get_params()

% Define analysis parameters
% % Figures
params.plot.ylim = 150; %PLOT YLIM for spike density functions (PlotYm)

% % SDF
params.sdf.gauss_ms = 100; % for making a spike density function (fits each spike with a 100ms gauss; gauswindow_ms)
params.sdf.window = [-500 1000]; % [min max] window for spike density function
params.raster.cleanFlag = 0;

% % Fano factor
params.fano.bin_size = 50; % Bin size for Fano Factor analysis (get_fano)
params.fano.smooth_bin = 100;
params.fano.timewindow = [0:500];

% % Statistics
params.stats.n_perms = 100; % Number of permutations for permutation tests (NumberofPermutations)
params.stats.corr_thresh = 0.01; % Statistical threshold for correlational analysis (CorTh)
params.stats.stat_bin = 101; % UNKNOWN (2023-01-23; BinForStat)
params.stats.peak_window = [-250:250];

% % Licking
params.licking.signal_cutoff = 2; % SD of baseline
params.licking.baseline = [-250 -50]; % Relative to target/CS onset
params.licking.gauss_ms = 10;

% % Eye
params.eye.alignWin = [-1000:3000];
params.eye.zero = find(params.eye.alignWin == 0);
params.eye.window = [5 5];

% % Saccade
params.saccade.fill_missing_data = false;
params.saccade.smoothen = true;
params.saccade.sampling_rate = 1000;
params.saccade.fix_vel_thres = 30;
params.saccade.lambda = 20;
params.saccade.combine_intv_thres = 20;
params.saccade.saccade_dur_thres = 5;
params.saccade.saccade_amp_thres = 0.2;


end
