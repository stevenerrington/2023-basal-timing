
function quick_trace_file_view(filename, file_dir, params)

neuron_i = 1;

% Loop admin
fprintf('Extracting data from:  %s   \n', filename)

% Load experimental data file
clear PDS
load(fullfile(file_dir,filename), 'PDS');

% Get trial indices
trials = get_trials_traceTask(PDS);

% Get event aligned rasters
Rasters = get_trace_raster(PDS, trials, params);

% Get event aligned spike-density function
SDF = plot_mean_psth({Rasters},params.sdf.gauss_ms,1,size(Rasters,2),1);

% Get licking raster
Licking = get_licking_raster(PDS,params);

% Eyes
Eye = get_eye_CS(PDS, params);

% Fano
Fano = get_fano(Rasters, trials, params);


% Output extracted data into a table
bf_data_traceExp = table({filename}, {trials}, {Rasters},{SDF},{Licking},{Eye},{Fano},...
    'VariableNames',{'filename','trials','rasters','sdf','licking','eye','fano'});

end