%% Fano factor x firing rate relationship
% In this section, we plot the neuron-by-neuron mean firing rate within the time
% window against the mean fano factor during the same period.
params.fano.timewindow = 0:500;

% For ramping neurons in the basal forebrain ---------------------------
clear input_data input_trials input_labels
% > Define parameters for comparison
input_data = {bf_data_CS(bf_datasheet_CS.cluster_id == 2,:),bf_data_timingTask,bf_data_traceExp};
input_trials = {'prob50','p50s_50l_short','timingcue_uncertain'};
input_labels = {'1_CS','2_timing','3_trace'};
% > Generate plot
params.plot.xlim = [0 80]; params.plot.ylim = [0 2];
bf_method_fanoxfr = plot_method_fanofiringrate(input_data,input_trials,input_labels,params);
save_figure(bf_method_fanoxfr,dirs.fig,'bf_method_fanoxfr');

% For ramping neurons in the striatum  ---------------------------------
clear input_data input_trials input_labels
% > Define parameters for comparison
input_data = {striatum_data_CS,striatum_data_traceExp};
input_trials = {'prob50','timingcue_uncertain'};
input_labels = {'1_CS','2_trace'};
% > Generate plot
params.plot.xlim = [0 50]; params.plot.ylim = [0 4];
striatum_method_fanoxfr = plot_method_fanofiringrate(input_data,input_trials,input_labels,params);
save_figure(striatum_method_fanoxfr,dirs.fig,'striatum_method_fanoxfr')
