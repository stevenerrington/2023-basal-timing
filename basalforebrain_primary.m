% Clear workspace
clear all; close all; clc; beep off;

% Define paths & key directories
dirs.root = 'D:\projectCode\2023-basal-timing\';
addpath(genpath(dirs.root));

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
[~,~,neuronsheet] = xlsread(fullfile(dirs.root,'docs','\BF_neuron_sheet'));

% Find relevant columns from datasheet
excel_celltype = find(strcmp(neuronsheet(1,:),'Cell Type'));
excel_Area = find(strcmp(neuronsheet(1,:),'Area'));
excel_monkeyid = find(strcmp(neuronsheet(1,:),'Monkey'));
excel_ProbAmt = find(strcmp(neuronsheet(1,:),'ProbAmt2575'));
excel_ProbAmtdir = find(strcmp(neuronsheet(1,:),'ProbAmt2575dir'));
excel_TimingP = find(strcmp(neuronsheet(1,:),'Timingprocedure'));
excel_TimingPdir = find(strcmp(neuronsheet(1,:),'Timingproceduredir'));

%% Curation: extract relevant neurons from datasheet
DDD = []; errorDDD = [];

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
        addpath(tp.folder);
        if exist(tp.name)
            DDD = [DDD,tp];
        else
            errorDDD = [errorDDD,tp]; % but log if an error occurs.
        end
        clear tp;
    end
end

%% Analysis:

% 2023-01-23: GroupAnalyses2575 enters a loop on line 112, and calls a
% separate script (Timing2575Group) on line 121. This seems to do the heavy
% lifting for the analysis. The raw data seems to be loaded on line 120.

errorfile=cell(0);

% For each identified neuron meeting the criteria, we will loop through,
% load the experimental data file, and extract the event aligned raster.
for ii = 1%:length(DDD)
    
    % Clear variables, console, and figures
    clear PDS ; clc; close all;
    
    % If the processed experimental file can be found
    if exist(DDD(ii).name)
        
        % Load the data (PDS structure)
        load(DDD(ii).name,'PDS'); 
        
        % Get trial indices
        trials = get_trials(PDS);
        
        % Get event aligned rasters
        Rasters = get_raster(PDS, trials, params); % Derived from Timing2575Group.m

        SDFcs_n = plot_mean_psth({Rasters},params.sdf.gauss_ms,1,size(Rasters,2),1); 
        
        fano = get_fano(Rasters, trials, params);
        
    else
        errorfile{end+1,1}=DDD(ii).name;
    end

end









%%
Timing2575Group

%xxx=xxx+1;
%ProbAmtDataStruct(xxx) = savestruct(1); %if you want to add

%clear savestruct
%% Get averaged spike density functions
% If there are enough trials (4), then calculate the average spike density
% % functions for the conditions
% 
% if isempty(find(trialtypes_all < 4))==1
%     
%     %savestruct(1).filename=D(1).name;
%     fano(1).SDF75omit = nanmean(SDFcs_n(trials.prob75nd,analysis_win));
%     fano(1).SDF50omit = nanmean(SDFcs_n(trials.prob50nd,analysis_win));
%     fano(1).SDF25omit = nanmean(SDFcs_n(trials.prob25nd,analysis_win));
%     fano(1).SDF0omit = nanmean(SDFcs_n(trials.prob0,analysis_win));
%     
%     fano(1).AllSDFomit = nanmean(SDFcs_n([trials.prob25nd trials.prob50nd trials.prob75nd],analysis_win));
%     
%     fano(1).SDF100= nanmean(SDFcs_n(trials.prob100,analysis_win));
%     fano(1).SDF75= nanmean(SDFcs_n(trials.prob75,analysis_win));
%     fano(1).SDF50= nanmean(SDFcs_n(trials.prob50,analysis_win));
%     fano(1).SDF25= nanmean(SDFcs_n(trials.prob25,analysis_win));
%     fano(1).SDF0= nanmean(SDFcs_n(trials.prob0,analysis_win));
%     
%     fano(1).AllSDF= nanmean(SDFcs_n([trials.prob25 trials.prob50 trials.prob75],analysis_win));
%     
% end
% 
% 
% 
% 
% 








