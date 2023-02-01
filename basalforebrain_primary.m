% Clear workspace
clear all; close all; clc; beep off; warning off;

% Define paths & key directories
dirs = get_dirs_bf('wustl');

% Define analysis parameters
% % Figures
params.plot.ylim = 150; %PLOT YLIM for spike density functions (PlotYm)
% % SDF
params.sdf.gauss_ms = 100; % for making a spike density function (fits each spike with a 100ms gauss; gauswindow_ms)
params.sdf.window = [-500 1000]; % [min max] window for spike density function
% % Fano factor
params.fano.bin_size = 100; % Bin size for Fano Factor analysis (get_fano)

% % Statistics
params.stats.n_perms = 100; % Number of permutations for permutation tests (NumberofPermutations)
params.stats.corr_thresh = 0.01; % Statistical threshold for correlational analysis (CorTh)
params.stats.stat_bin = 101; % UNKNOWN (2023-01-23; BinForStat)

%% Curation: load in datasheet
% Read in curated neuron datastructs
nih_datastruct = load(fullfile(dirs.root,'data','DATA15.mat'));
wustl_datastruct = load(fullfile(dirs.root,'data','DATA25_V2.mat'));
joint_datastruct = [nih_datastruct.ProbAmtDataStruct wustl_datastruct.ProbAmtDataStruct];

% Import excel datasheets
% XLS Sheet: WUSTL Neurons
[~,~,wustl_neuronsheet] = xlsread(fullfile(dirs.root,'docs','BF_neuron_sheet'));

% XLS Sheet: NIH Neurons
[~,~,nih_neuronsheet] = xlsread(fullfile(dirs.root,'docs','septumprobamt.xls'));

%
clear bf_datasheet

for ii = 1:size(joint_datastruct,2)
    clear file monkey date ap_loc ml_loc depth area site dir

    file = {joint_datastruct(ii).name};
    monkey = {lower(joint_datastruct(ii).monkey)};
    
    % WUSTL Data
    if ~isempty( find(strcmp(wustl_neuronsheet(:,15),file{1}(1:end-4))))
        xls_index = find(strcmp(wustl_neuronsheet(:,15),file{1}(1:end-4)));
        
        date = {wustl_neuronsheet{xls_index,12}};
        ap_loc = wustl_neuronsheet{xls_index,10};
        ml_loc = wustl_neuronsheet{xls_index,11};
        depth = wustl_neuronsheet{xls_index,3};
        area = wustl_neuronsheet(xls_index,14);
        site = {'wustl'};
        dir = wustl_neuronsheet(xls_index,16);
        
    % NIH Data
    elseif ~isempty(find(strcmp(nih_neuronsheet(:,2),file{1}(4:end)))) || ...
            ~isempty(find(strcmp(nih_neuronsheet(:,2),file{1}(5:end))))
        
        xls_index = find(strcmp(nih_neuronsheet(:,2),file{1}(4:end)));
        
        if isempty(xls_index)
            xls_index = find(strcmp(nih_neuronsheet(:,2),file{1}(5:end)));
        end
        
        
        date = {'?'};
        ap_loc = nih_neuronsheet{xls_index,5};
        ml_loc = nih_neuronsheet{xls_index,6};
        depth = nih_neuronsheet{xls_index,4};
        area = {'BF'};
        site = {'nih'};   
        dir = {'X:\MONKEYDATA\NIHBFrampingdata2575\MRDR\'};
        
    else
        continue
    end
    
    
    bf_datasheet(ii,:) = table(file, monkey, date, ap_loc, ml_loc, depth, area, site, dir);
    
end

clear nih_datastruct wustl_datastruct joint_datastruct

%% Analysis: Extract relevant neurophys data

% 2023-01-23: GroupAnalyses2575 enters a loop on line 112, and calls a
% separate script (Timing2575Group) on line 121. This seems to do the heavy
% lifting for the analysis. The raw data seems to be loaded on line 120.

errorfile=cell(0);
bf_data = table();

% For each identified neuron meeting the criteria, we will loop through,
% load the experimental data file, and extract the event aligned raster.
for ii = 1:size(bf_datasheet,1)
    
    % Clear variables, console, and figures
    clear REXPDS trials Rasters SDFcs_n fano; clc; close all;
    
    filename = bf_datasheet.file{ii};
    fprintf('Extracting data from neuron %i of %i   |  %s   \n',ii,size(bf_datasheet,1), filename)
    
    switch bf_datasheet.site{ii}
        case 'nih' % NIH data
            
            % Load the data (REX structure)
            REX = mrdr('-a', '-d', fullfile(bf_datasheet.dir{ii},bf_datasheet.file{ii}));
            
            % Get trial indices
            trials = get_rex_trials(REX);
            % Get event aligned rasters
            Rasters = get_rex_raster(REX, trials, params); % Derived from Timing2575Group.m
            % Get event aligned spike-density function
            SDFcs_n = plot_mean_psth({Rasters},params.sdf.gauss_ms,1,size(Rasters,2),1);
            
            
        case 'wustl' % WUSTL data
            
            % Load the data (PDS structure)
            load(fullfile(bf_datasheet.dir{ii},bf_datasheet.file{ii}),'PDS');
            
            % Get trial indices
            trials = get_trials(PDS);
            % Get event aligned rasters
            Rasters = get_raster(PDS, trials, params); % Derived from Timing2575Group.m
            % Get event aligned spike-density function
            SDFcs_n = plot_mean_psth({Rasters},params.sdf.gauss_ms,1,size(Rasters,2),1);
            
    end
    
    % Output extracted data into a table
    bf_data(ii,:) = table({filename}, {trials}, {Rasters},{SDFcs_n},...
        'VariableNames',{'filename','trials','rasters','sdf'});
    
    
end


%% Analysis: Fano Factor

params.fano.bin_size = 100;

parfor neuron_i = 1:size(bf_datasheet,1)
    
    fprintf('Calculating Fano Factor for neuron %i of %i   |  %s   \n',...
        neuron_i,size(bf_datasheet,1), bf_data.filename{neuron_i})

    % Calculate Fano Factor
    fano(neuron_i) = get_fano(bf_data.rasters{neuron_i},...
        bf_data.trials{neuron_i}, params);

end

bf_data.fano = fano'; clear fano



%% Analysis: epoched Fano Factor
% In progress - 1539, Feb 1st

zero_times.fix = -1000; zero_times.cs = 0; zero_times.outcome = [1500 2500];
zero_align = find(bf_data.fano(neuron_i).time == 0);



epoch_labels = fieldnames(epoch);

for neuron_i = 1:size(bf_data,1)
    for epoch_i = 1:length(epoch_labels)
        epoch_index = [];
        epoch_index = find(ismember(bf_data.fano(neuron_i).time,epoch.(epoch_labels{epoch_i})));

        test(neuron_i,epoch_i) = mean(bf_data.fano(neuron_i).FanoSaveAll(epoch_index))
    end
    
end


