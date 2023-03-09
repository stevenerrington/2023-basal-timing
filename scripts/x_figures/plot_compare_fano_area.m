params.fano.timewindow = 0:1500;

% > Define data for comparison
clear input_data input_trials input_labels
input_data = {bf_data_CS(bf_datasheet_CS.cluster_id == 2,:),striatum_data_CS};
input_trials = {'prob50','prob50'};
input_labels = {'1_basal_forebrain','2_striatum'};

% > Generate figure
params.plot.ylim = [0 3]; params.plot.colormap = [0,0,0;1,0,0];
plot_compare_fano_c(input_data,input_trials,input_labels,params)

%%% > Note: I need to check plot_compare_fano_c for matching neuron to it's
%%%         label. It seems to work, but I want to check this