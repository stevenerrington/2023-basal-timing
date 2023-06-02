%% Curation: generate a datamap
% > Load in a pre-curated sheet of neuron information for upcoming analyses 

striatum_datasheet_traceExp = readtable(fullfile(dirs.root,'docs','timing_trace_neurontable_striatum.xlsx'));

%% Analysis: Extract relevant neurophys data

striatum_data_traceExp = table();

for neuron_i = 1:size(striatum_datasheet_traceExp,1)
    
    % Loop admin
    filename = striatum_datasheet_traceExp.file{neuron_i};
    fprintf('Extracting data from neuron %i of %i   |  %s   \n',neuron_i,size(striatum_datasheet_traceExp,1), filename)
    
    % Load experimental data file
    clear PDS
    load(fullfile(striatum_datasheet_traceExp.dir{neuron_i},filename), 'PDS');
   
    % Get trial indices
    trials = get_trials_traceTask(PDS);
    
    % Get event aligned rasters
    Rasters = get_trace_raster(PDS, trials, params);
    
    % Get event aligned spike-density function
    SDF = plot_mean_psth({Rasters},params.sdf.gauss_ms,1,size(Rasters,2),1);
    
    % Get licking raster
    Licking = get_licking_raster(PDS,params); 
    
    % Output extracted data into a table
    striatum_data_traceExp(neuron_i,:) = table({filename}, {trials}, {Rasters},{SDF},{Licking},...
        'VariableNames',{'filename','trials','rasters','sdf','licking'});
end


%% Analysis: calculate running fano factor

clear fano
parfor neuron_i = 1:size(striatum_datasheet_traceExp,1)
    
    fprintf('Calculating Fano Factor for neuron %i of %i   |  %s   \n',...
        neuron_i,size(striatum_datasheet_traceExp,1), striatum_datasheet_traceExp.file{neuron_i})

    % Calculate Fano Factor
    fano(neuron_i) = get_fano(striatum_data_traceExp.rasters{neuron_i},...
        striatum_data_traceExp.trials{neuron_i}, params);

end

striatum_data_traceExp.fano = fano';
clear fano

%% Analysis: Calculate the inter-spike interval distribution for each trial condition

parfor neuron_i = 1:size(striatum_datasheet_traceExp,1)
    
    fprintf('Calculating ISI distribution for neuron %i of %i   |  %s   \n',...
        neuron_i,size(striatum_datasheet_traceExp,1), striatum_datasheet_traceExp.file{neuron_i})
    
    % Calculate Fano Factor
    isi(neuron_i) = get_isi(striatum_data_traceExp.rasters{neuron_i},...
        striatum_data_traceExp.trials{neuron_i});
    
end

striatum_data_traceExp.isi = isi'; clear isi

