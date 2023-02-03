%% Basal forebrain project
% 2023-basal-timing, S P Errington, January 2023
% > Project description will go here


%% Setup workspace
% > INSERT DESCRIPTION HERE

% Clear workspace
clear all; close all; clc; beep off; warning off;

% Define paths & key directories
dirs = get_dirs_bf('wustl');
params = get_params;

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
clear bf_datasheet % clear dataframe variable to stop contamination
 
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
    bf_datasheet(ii,:) = table(file, monkey, date, ap_loc, ml_loc, depth, area, site, dir);
    
end

% Clear large preprocessed datafile from workspace.
clear nih_datastruct wustl_datastruct joint_datastruct

%% Analysis: Pavlovian task data
% > INSERT DESCRIPTION HERE

pavlovian_master

%% Analysis: Timing task data
% > INSERT DESCRIPTION HERE

timing_master

%% Analysis: Trace task data
% > INSERT DESCRIPTION HERE

trace_master