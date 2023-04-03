%% Setup workspace
% Clear workspace
clear all; close all; clc; beep off; warning off;

% Define paths & key directories
dirs = get_dirs_bf('wustl');
params = get_params;
status = get_status(dirs);

load bf_data_CS
load bf_datasheet_CS
load striatum_data_CS
load striatum_datasheet_CS

%           A structure, each element of which contains a field 'spikes' which is a matrix with 1 row
%       per trial and 1 column per millisecond.  Each entry should be a '1' (there was a spike in
%       that ms on that trial) or a '0' (there wasn't).  All data should be time-aligned to some event.
%           For example, suppose you collect 100 trials, each with 200 ms of pre-target
%       data and 800 ms of post-target data. Your 'spikes' matrix would then be 100 by 1000
%       (with one of these for each element of 'data').

clear ramping_neurons_list
ramping_neurons_list = find(bf_datasheet_CS.cluster_id == 1);

clear BFdata_test BGdata_test
for neuron_i = 1:length(ramping_neurons_list)
    
    BFdata_test(neuron_i).spikes = logical(bf_data_CS.rasters{ramping_neurons_list(neuron_i)}...
        (bf_data_CS.trials{ramping_neurons_list(neuron_i)}.uncertain,:));
end

for neuron_i = 1:size(striatum_datasheet_CS,1)
    BGdata_test(neuron_i).spikes = logical(striatum_data_CS.rasters{neuron_i}...
        (striatum_data_CS.trials{neuron_i}.uncertain,:));
end


% target onset is at 5000 ms
clear figureParams fanoParams

times = 4800:25:8000; % from 800 ms before CS onset until 500 ms after reward.
fanoParams.alignTime = 5000; % this time will become zero time
fanoParams.boxWidth = 25; % 50 ms sliding window.
fanoParams.binSpacing = 0.25; % 50 ms sliding window.
figureParams.plotRawF = 1;

Result_BF = VarVsMean(BFdata_test, times, fanoParams);
plotFano(Result_BF,figureParams);

% 21% of datapoints survived matching (~75% in example)








