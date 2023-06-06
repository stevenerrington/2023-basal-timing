%% Curation: generate a datamap
% > Load in a pre-curated sheet of neuron information for upcoming analyses 

striatum_datasheet_traceLearning = readtable(fullfile(dirs.root,'docs','timing_traceLearning_neurontable_striatum.xlsx'));

%% Analysis: Extract relevant neurophys data

striatum_data_traceLearning = table();

for neuron_i = 1:size(striatum_datasheet_traceLearning,1)
    
    % Loop admin
    filename = striatum_datasheet_traceLearning.file{neuron_i};
    fprintf('Extracting data from neuron %i of %i   |  %s   \n',neuron_i,size(striatum_datasheet_traceLearning,1), filename)
    
    % Load experimental data file
    clear PDS
    load(fullfile(striatum_datasheet_traceLearning.dir{neuron_i},filename), 'PDS');
   
    % Get trial indices
    trials = get_trials_traceTask(PDS);
    
    % Get event aligned rasters
    Rasters = get_trace_raster(PDS, trials, params);
    
    % Get event aligned spike-density function
    SDF = plot_mean_psth({Rasters},params.sdf.gauss_ms,1,size(Rasters,2),1);
    
    % Get licking raster
    Licking = get_licking_raster(PDS,params); 
    
    % Output extracted data into a table
    striatum_data_traceLearning(neuron_i,:) = table({filename}, {trials}, {Rasters},{SDF},{Licking},...
        'VariableNames',{'filename','trials','rasters','sdf','licking'});
end


