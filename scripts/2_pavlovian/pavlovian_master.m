%% Curation: load in datasheet
% > INSERT DESCRIPTION HERE

% Read in curated neuron datastructs
nih_datastruct = load(fullfile(dirs.root,'data','DATA15.mat'));
wustl_datastruct = load(fullfile(dirs.root,'data','DATA25_V2.mat'));
joint_datastruct = [nih_datastruct.ProbAmtDataStruct wustl_datastruct.ProbAmtDataStruct];

% Import excel datasheets
% XLS Sheet: WUSTL Neurons
[~,~,wustl_neuronsheet] = xlsread(fullfile(dirs.root,'docs','BF_neuron_sheet'));

% XLS Sheet: NIH Neurons
[~,~,nih_neuronsheet] = xlsread(fullfile(dirs.root,'docs','septumprobamt.xls'));

% Create datasheet
clear bf_datasheet_CS % clear dataframe variable to stop contamination
 
% For each identified datafile
for ii = 1:size(joint_datastruct,2)
    % clear loop variables to stop contamination
    clear file monkey date ap_loc ml_loc depth area site dir

    % get file name and monkey name
    file = {joint_datastruct(ii).name};
    monkey = {lower(joint_datastruct(ii).monkey)};
    
    % Extract data: WUSTL
    if ~isempty( find(strcmp(wustl_neuronsheet(:,15),file{1}(1:end-4))))
        xls_index = find(strcmp(wustl_neuronsheet(:,15),file{1}(1:end-4))); % Spreadsheet location
        
        date = {wustl_neuronsheet{xls_index,12}}; % Date of recording
        ap_loc = wustl_neuronsheet{xls_index,10}; % AP grid location
        ml_loc = wustl_neuronsheet{xls_index,11}; % ML grid location
        depth = wustl_neuronsheet{xls_index,3};   % Recording depth
        area = wustl_neuronsheet(xls_index,14);   % Recording area
        site = {'wustl'};                         % Institution where data was recorded
        dir = wustl_neuronsheet(xls_index,16);    % Data storage directory
        
    % NIH Data
    elseif ~isempty(find(strcmp(nih_neuronsheet(:,2),file{1}(4:end)))) || ...
            ~isempty(find(strcmp(nih_neuronsheet(:,2),file{1}(5:end))))
        
        xls_index = find(strcmp(nih_neuronsheet(:,2),file{1}(4:end)));  % Spreadsheet location
        
        if isempty(xls_index)
            xls_index = find(strcmp(nih_neuronsheet(:,2),file{1}(5:end)));
        end
        
        
        date = {'?'};                              % Date of recording
        ap_loc = nih_neuronsheet{xls_index,5};     % AP grid location 
        ml_loc = nih_neuronsheet{xls_index,6};     % ML grid location 
        depth = nih_neuronsheet{xls_index,4};      % Recording depth 
        area = {'BF'};                             % Recording area
        site = {'nih'};                            % Institution where data was recorded   
        dir = {'X:\MONKEYDATA\NIHBFrampingdata2575\MRDR\'}; % Data storage directory
        
    else
        continue
    end
    
    % Save variables to a row in the datatable
    bf_datasheet_CS(ii,:) = table(file, monkey, date, ap_loc, ml_loc, depth, area, site, dir);
    
end

% Clear large preprocessed datafile from workspace.
clear nih_datastruct wustl_datastruct joint_datastruct

%% Analysis: Extract relevant neurophys data

% 2023-01-23: GroupAnalyses2575 enters a loop on line 112, and calls a
% separate script (Timing2575Group) on line 121. This seems to do the heavy
% lifting for the analysis. The raw data seems to be loaded on line 120.

errorfile=cell(0);
bf_data_CS = table();

% For each identified neuron meeting the criteria, we will loop through,
% load the experimental data file, and extract the event aligned raster.
for ii = 1:size(bf_datasheet_CS,1)
    
    % Clear variables, console, and figures
    clear REXPDS trials Rasters SDFcs_n fano; clc; close all;
    
    filename = bf_datasheet_CS.file{ii};
    fprintf('Extracting data from neuron %i of %i   |  %s   \n',ii,size(bf_datasheet_CS,1), filename)
    
    switch bf_datasheet_CS.site{ii}
        case 'nih' % NIH data
            
            % Load the data (REX structure)
            REX = mrdr('-a', '-d', fullfile(bf_datasheet_CS.dir{ii},bf_datasheet_CS.file{ii}));
            
            % Get trial indices
            trials = get_rex_trials(REX);
            % Get event aligned rasters
            Rasters = get_rex_raster(REX, trials, params); % Derived from Timing2575Group.m
            % Get event aligned spike-density function
            SDF = plot_mean_psth({Rasters},params.sdf.gauss_ms,1,size(Rasters,2),1);
            
            
        case 'wustl' % WUSTL data
            
            % Load the data (PDS structure)
            load(fullfile(bf_datasheet_CS.dir{ii},bf_datasheet_CS.file{ii}),'PDS');
            
            % Get trial indices
            trials = get_trials(PDS);
            % Get event aligned rasters
            Rasters = get_raster(PDS, trials, params); % Derived from Timing2575Group.m
            % Get event aligned spike-density function
            SDF = plot_mean_psth({Rasters},params.sdf.gauss_ms,1,size(Rasters,2),1);
            
    end
    
    % Output extracted data into a table
    bf_data_CS(ii,:) = table({filename}, {trials}, {Rasters},{SDF},...
        'VariableNames',{'filename','trials','rasters','sdf'});
    
    
end

%% Analysis: Categorize neurons as ramping or phasic.
% Load in previously calculated cluster labels for BF neurons (phasic or
% ramping)
load(fullfile(dirs.root,'data','cluster_labels.mat'))

category_label = {'Phasic','Ramping'};

% For each neuron
for neuron_i = 1:size(bf_datasheet_CS)

    file = bf_datasheet_CS.file{neuron_i};
    bf_datasheet_CS.cluster_id(neuron_i) = ...
        cluster_labels.cluster(strcmp(cluster_labels.file, file));
    
    bf_datasheet_CS.cluster_label{neuron_i} = ...
        category_label{bf_datasheet_CS.cluster_id(neuron_i)};
    
end

%% Analysis: Calculate the fano factor for each trial condition

parfor neuron_i = 1:size(bf_datasheet_CS,1)
    
    fprintf('Calculating Fano Factor for neuron %i of %i   |  %s   \n',...
        neuron_i,size(bf_datasheet_CS,1), bf_data_CS.filename{neuron_i})

    % Calculate Fano Factor
    fano(neuron_i) = get_fano(bf_data_CS.rasters{neuron_i},...
        bf_data_CS.trials{neuron_i}, params);

end

bf_data_CS.fano = fano'; clear fano
