%% Compare fano factors across tasks & epochs
% In this section, we plot mean fano-factor average across the defined time
% window and compare this across tasks.

% -------------------------------------------------------------------------
% --------------------- CS onset ------------------------------------------
% -------------------------------------------------------------------------

% Define analysis time window ---------------------------------------------
params.fano.timewindow = 0:500;

% Comparison for basal forebrain ramping neurons --------------------------
% > Define data for comparison
clear input_data input_trials input_labels
input_data = {bf_data_CS(bf_datasheet_CS.cluster_id == 2,:),bf_data_timingTask,bf_data_traceExp};
input_trials = {'prob50','p50s_50l_short','timingcue_uncertain'};
input_labels = {'1_CS','2_timing','3_trace'};
% > Generate figure
params.plot.ylim = [0 3];
plot_compare_fano(input_data,input_trials,input_labels,params)

% Comparison for striatum ramping neurons --------------------------
% > Define data for comparison
clear input_data input_trials input_labels
input_data = {striatum_data_CS,striatum_data_traceExp};
input_trials = {'prob50','timingcue_uncertain'};
input_labels = {'1_CS','2_trace'};
% > Generate figure
params.plot.ylim = [0 3];
plot_compare_fano(input_data,input_trials,input_labels,params)

% -------------------------------------------------------------------------
% --------------------- Outcome  ------------------------------------------
% -------------------------------------------------------------------------
% Comparison for basal forebrain ramping neurons --------------------------
% > > > Side note: just using NIH now due to exp differences

% Define analysis time window 
params.fano.timewindow = 1000:1500;

% > Define data for comparison
clear input_data input_trials input_labels
input_data = {bf_data_CS(bf_datasheet_CS.cluster_id == 2 & strcmp(bf_datasheet_CS.site,'nih'),:),...
    bf_data_CS(bf_datasheet_CS.cluster_id == 2 & strcmp(bf_datasheet_CS.site,'nih'),:)};
input_trials = {'prob50d','prob50nd'};
input_labels = {'prob50d','prob50nd'};

% > Generate figure
params.plot.ylim = [0 3]; params.plot.colormap = [0,0,0;1,0,0];
plot_compare_fano_b(input_data,input_trials,input_labels,params)

% Comparison for striatum ramping neurons --------------------------
% Define analysis time window 
params.fano.timewindow = 2000:2500;

% > Define data for comparison
clear input_data input_trials input_labels
input_data = {striatum_data_CS,striatum_data_CS};
input_trials = {'prob50d','prob50nd'};
input_labels = {'prob50d','prob50nd'};

% > Generate figure
params.plot.ylim = [0 3]; params.plot.colormap = [0,0,0;1,0,0];
plot_compare_fano_b(input_data,input_trials,input_labels,params)