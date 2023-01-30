% Clear workspace
clear all; close all; clc; beep off;

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
% Read in curated neuron datasheet
[~,~,neuronsheet] = xlsread(fullfile(dirs.root,'docs','BF_neuron_sheet'));

% Find relevant columns from datasheet
excel_celltype = find(strcmp(neuronsheet(1,:),'Cell Type'));
excel_Area = find(strcmp(neuronsheet(1,:),'Area'));
excel_monkeyid = find(strcmp(neuronsheet(1,:),'Monkey'));
excel_ProbAmt = find(strcmp(neuronsheet(1,:),'ProbAmt2575'));
excel_ProbAmtdir = find(strcmp(neuronsheet(1,:),'ProbAmt2575dir'));
excel_TimingP = find(strcmp(neuronsheet(1,:),'Timingprocedure'));
excel_TimingPdir = find(strcmp(neuronsheet(1,:),'Timingproceduredir'));

%% Curation: extract relevant neurons from datasheet
datamap = []; datamap_error = [];

% For each neuron
for ii = 2:size(neuronsheet,1)
    % If the neuron is: 
    if strcmp(neuronsheet{ii,excel_Area},'BF') && ... % in the basal forebrain (BF)...
            strcmp(neuronsheet{ii,excel_celltype},'Ramping') && ...  % and is identified as a ramping neuron (Zhang et al., 2019)
            length(neuronsheet{ii,excel_ProbAmt})>1 % and has a relevant datafile
        
        % Collate information
        tp.name = [neuronsheet{ii,excel_ProbAmt},'.mat'];
        tp.folder = neuronsheet{ii,excel_ProbAmtdir};
        tp.celltype = neuronsheet{ii,excel_celltype};
        tp.MONKEYID = neuronsheet{ii,excel_monkeyid};
        
        % Add the raw data directory to the matlab path for future calls
        addpath(fullfile(tp.folder));
        
        if exist(tp.name)
            datamap = [datamap,tp];
        else
            datamap_error = [datamap_error,tp]; % but log if an error occurs.
        end
        clear tp;
    end
end

%% Analysis:

% 2023-01-23: GroupAnalyses2575 enters a loop on line 112, and calls a
% separate script (Timing2575Group) on line 121. This seems to do the heavy
% lifting for the analysis. The raw data seems to be loaded on line 120.

errorfile=cell(0);
test = table();

% For each identified neuron meeting the criteria, we will loop through,
% load the experimental data file, and extract the event aligned raster.
for ii = 1:length(datamap)
    
    % Clear variables, console, and figures
    clear PDS trials Rasters SDFcs_n fano; clc; close all;
    filename = datamap(ii).name;
    fprintf('Extracting data from neuron %i of %i   |  %s   \n',ii,length(datamap), filename)
    
    % If the processed experimental file can be found
    if exist(filename)
        
        % Load the data (PDS structure)
        load(filename,'PDS'); 
        
        % Get trial indices
        trials = get_trials(PDS);
        
        % Get event aligned rasters
        Rasters = get_raster(PDS, trials, params); % Derived from Timing2575Group.m

        % Get event aligned spike-density function
        SDFcs_n = plot_mean_psth({Rasters},params.sdf.gauss_ms,1,size(Rasters,2),1); 
        
        % Calculate Fano Factor
        fano = get_fano(Rasters, trials, params);
        
        % Output extracted data into a table
        test(ii,:) = table({filename}, {trials}, {Rasters},{SDFcs_n},fano,...
            'VariableNames',{'filename','trials','rasters','sdf','fano'});
        
    else
        errorfile{end+1,1}=datamap(ii).name;
    end

end


%%






