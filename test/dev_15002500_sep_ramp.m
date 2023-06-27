% Population
plot_trial_types = {'uncertain'};
params.plot.xlim = [0 3500]; params.plot.ylim = [-2 5];
params.plot.colormap = [240 59 59; 0, 198, 165]./255;

[~,~,bf_population_CS_ramping_onset] = plot_population_neuron_test(bf_data_CS2,bf_datasheet_CS2,plot_trial_types,params,1);
