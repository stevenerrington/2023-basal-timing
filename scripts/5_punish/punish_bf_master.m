
%% Curation: load in datasheet
% > INSERT DESCRIPTION HERE

% XLS Sheet: NIH Neurons
nih_neuronsheet = readtable(fullfile(dirs.root,'docs','punishTask_bf_neurons.xlsx'));
nih_neuronsheet = nih_neuronsheet(nih_neuronsheet.inc == 1,:);
% Create datasheet
clear bf_datasheet_punish % clear dataframe variable to stop contamination

% For each identified datafile
for neuron_i = 1:size(nih_neuronsheet,1)
    % clear loop variables to stop contamination
    clear file monkey date ap_loc ml_loc depth area site dir
    
    % get file name and monkey name
    file = nih_neuronsheet.file(neuron_i);
    monkey = nih_neuronsheet.monkey(neuron_i);
    
    date = {'?'};                              % Date of recording
    ap_loc = nih_neuronsheet.ap(neuron_i);     % AP grid location
    ml_loc = nih_neuronsheet.ml(neuron_i);     % ML grid location
    depth = nih_neuronsheet.depth(neuron_i);      % Recording depth
    area = {'BF'};                             % Recording area
    site = {'nih'};                            % Institution where data was recorded
    dir = nih_neuronsheet.dir(neuron_i); % Data storage directory
    cluster_id = 2; % Data storage directory
    cluster_label = {'Ramping'}; % Data storage directory
   
    % Save variables to a row in the datatable
    bf_datasheet_punish(neuron_i,:) = table(file, monkey, date, ap_loc, ml_loc, depth, area, site, dir,cluster_id,cluster_label);
    
end

% Clear large preprocessed datafile from workspace.
clear nih_datastruct

%% Analysis: Extract relevant neurophys data

% 2023-01-23: GroupAnalyses2575 enters a loop on line 112, and calls a
% separate script (Timing2575Group) on line 121. This seems to do the heavy
% lifting for the analysis. The raw data seems to be loaded on line 120.

errorfile=cell(0);
bf_data_punish = table();

% For each identified neuron meeting the criteria, we will loop through,
% load the experimental data file, and extract the event aligned raster.
for neuron_i = 1:size(bf_datasheet_punish,1)
    
    % Clear variables, console, and figures
    clear REX PDS trials Rasters SDFcs_n fano; clc; close all;
    
    filename = bf_datasheet_punish.file{neuron_i};
    fprintf('Extracting data from neuron %i of %i   |  %s   \n',neuron_i,size(bf_datasheet_punish,1), filename)
    
    try
        % Load the data (REX structure)
        REX = mrdr('-a', '-d', fullfile(bf_datasheet_punish.dir{neuron_i},bf_datasheet_punish.file{neuron_i}));
        
        % Get trial indices
        trials = get_rex_trials_punish(REX);
        % Get event aligned rasters
        Rasters = get_rex_raster(REX, trials, params); % Derived from Timing2575Group.m
        % Get event aligned spike-density function
        SDF = plot_mean_psth({Rasters},params.sdf.gauss_ms,1,size(Rasters,2),1);
        % Get licking beh raster
        Licking = [];
        % Get eye position
        Eye = get_rex_eye(REX,params);

        
        % Output extracted data into a table
        bf_data_punish(neuron_i,:) = table({filename}, {trials}, {Rasters},{SDF},{Licking},{Eye},...
            'VariableNames',{'filename','trials','rasters','sdf','licking','eye'});
    catch
        fprintf('!Error: neuron %i of %i   |  %s   \n',neuron_i,size(bf_datasheet_punish,1), filename)
        bf_data_punish(neuron_i,:) = table({filename}, {[]}, {[]},{[]},{[]},...
            'VariableNames',{'filename','trials','rasters','sdf','licking'});        
    end
    
    
end

%% Analysis: Calculate the fano factor for each trial condition

parfor neuron_i = 1:size(bf_datasheet_punish,1)
    
    fprintf('Calculating Fano Factor for neuron %i of %i   |  %s   \n',...
        neuron_i,size(bf_datasheet_punish,1), bf_data_punish.filename{neuron_i})
    
    % Calculate Fano Factor
    fano(neuron_i) = get_fano(bf_data_punish.rasters{neuron_i},...
        bf_data_punish.trials{neuron_i}, params);
    
end

bf_data_punish.fano = fano'; clear fano

%% Analysis: Calculate the inter-spike interval distribution for each trial condition

parfor neuron_i = 1:size(bf_datasheet_punish,1)
    
    fprintf('Calculating ISI distribution for neuron %i of %i   |  %s   \n',...
        neuron_i,size(bf_datasheet_punish,1), bf_data_punish.filename{neuron_i})
    
    % Calculate Fano Factor
    isi(neuron_i) = get_isi(bf_data_punish.rasters{neuron_i},...
        bf_data_punish.trials{neuron_i});
    
end

bf_data_punish.isi = isi'; clear isi
% 
% %% Analysis: Extract trial event times for each neuron/session
% 
% clear TrialEventTimes
% for neuron_i = 1:size(bf_datasheet_punish,1)
%     
%     fprintf('Extracting trial event times for neuron %i of %i   |  %s   \n',...
%         neuron_i,size(bf_datasheet_punish,1), bf_data_punish.filename{neuron_i})
%     
%     REX = mrdr('-a', '-d', fullfile(bf_datasheet_punish.dir{neuron_i},bf_datasheet_punish.file{neuron_i}));
%     
%     % Calculate Fano Factor
%     TrialEventTimes{neuron_i,1} = dev_extractTrialEventTimes(REX);
% 
% end
