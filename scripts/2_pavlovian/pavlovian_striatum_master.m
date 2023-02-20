%% Curation: load in datasheet
% > INSERT DESCRIPTION HERE

% Import excel datasheets
% XLS Sheet: WUSTL Neurons
clear striatum_datasheet
[~,~,striatum_datasheet] = xlsread(fullfile(dirs.root,'docs','Striatum_neuron_sheet'));

% Create datasheet
clear striatum_datasheet_CS % clear dataframe variable to stop contamination
 
% For each identified datafile
for ii = 2:size(striatum_datasheet,1)
    % clear loop variables to stop contamination
    clear file monkey date ap_loc ml_loc depth area site dir
    
    % get file name and monkey name
    file = {striatum_datasheet{ii,1}};
    monkey = {lower(striatum_datasheet{ii,2})};

    date = {'?'}; % Date of recording
    ap_loc = {'?'}; % AP grid location
    ml_loc = {'?'}; % ML grid location
    depth = {'?'};   % Recording depth
    area = {'icbDS'};   % Recording area
    site = {'wustl'};                         % Institution where data was recorded
    dir = {striatum_datasheet{ii,3}};    % Data storage directory
    
    
    % Save variables to a row in the datatable
    striatum_datasheet_CS(ii-1,:) = table(file, monkey, date, ap_loc, ml_loc, depth, area, site, dir);
    
end

% Clear large preprocessed datafile from workspace.
clear striatum_datasheet

%% Analysis: Extract relevant neurophys data

% 2023-01-23: GroupAnalyses2575 enters a loop on line 112, and calls a
% separate script (Timing2575Group) on line 121. This seems to do the heavy
% lifting for the analysis. The raw data seems to be loaded on line 120.

errorfile=cell(0);
striatum_data_CS = table();

% For each identified neuron meeting the criteria, we will loop through,
% load the experimental data file, and extract the event aligned raster.
for ii = 1:size(striatum_datasheet_CS,1)
    
    % Clear variables, console, and figures
    clear REXPDS trials Rasters SDFcs_n fano; clc; close all;
    
    filename = striatum_datasheet_CS.file{ii};
    fprintf('Extracting data from neuron %i of %i   |  %s   \n',ii,size(striatum_datasheet_CS,1), filename)
    
    % Load the data (PDS structure)
    load(fullfile(striatum_datasheet_CS.dir{ii},striatum_datasheet_CS.file{ii}),'PDS');
    
    % Get trial indices
    trials = get_trials(PDS);
    % Get event aligned rasters
    Rasters = get_raster(PDS, trials, params); % Derived from Timing2575Group.m
    % Get event aligned spike-density function
    SDF = plot_mean_psth({Rasters},params.sdf.gauss_ms,1,size(Rasters,2),1);
    
    
    % Output extracted data into a table
    striatum_data_CS(ii,:) = table({filename}, {trials}, {Rasters},{SDF},...
        'VariableNames',{'filename','trials','rasters','sdf'});
    
end


%% Analysis: Calculate the fano factor for each trial condition

parfor neuron_i = 1:size(striatum_datasheet_CS,1)
    
    fprintf('Calculating Fano Factor for neuron %i of %i   |  %s   \n',...
        neuron_i,size(striatum_datasheet_CS,1), striatum_data_CS.filename{neuron_i})

    % Calculate Fano Factor
    fano(neuron_i) = get_fano(striatum_data_CS.rasters{neuron_i},...
        striatum_data_CS.trials{neuron_i}, params);

end

striatum_data_CS.fano = fano'; clear fano





