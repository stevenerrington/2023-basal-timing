% Clear workspace
clear all; close all; clc; beep off;

% Define paths & key directories
dir.root = 'D:\projectCode\2023-basal-timing\';
addpath(genpath(dir.root));

% Define analysis parameters
plot_params.ylim = 150; %PLOT YLIM for spike density functions (PlotYm)

sdf_params.gauss_ms = 100; %for making a spike density function (fits each spike with a 100ms gauss; gauswindow_ms)
stat_params.n_perms = 100; % Number of permutations for permutation tests (NumberofPermutations)
stat_params.corr_thresh = 0.01; % Statistical threshold for correlational analysis (CorTh)
stat_params.stat_bin = 101; % UNKNOWN (2023-01-23; BinForStat)

%% Curation: load in datasheet
% Read in curated neuron datasheet
[~,~,neuronsheet] = xlsread(fullfile(dir.root,'docs','\BF_neuron_sheet'));

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
