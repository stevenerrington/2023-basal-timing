% > CS task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
plot_trial_types = {'certain','uncertain'};
params.plot.colormap = [2, 59, 56; 197, 39, 108]./255;

%% > Plot example ramping neuron in the basal forebrain.
params.plot.xlim = [-500 3500]; params.plot.ylim = [0 60];

params.plot.xlim = [0 1500]; params.plot.xintercept = 1500;
[~, ~,bf_example_CS1500_ramping] = plot_example_neuron(bf_data_1500_ramping,plot_trial_types,params,16,0);

%% > Plot population ramping neurons
%  Plot population averaged ramping neuron activity in the basal forebrain (NIH subset).
params.plot.xlim = [0 1500]; params.plot.ylim = [-2 4]; params.plot.xintercept = 1500;
[~, ~, bf_pop_CS1500_ramping] = plot_population_neuron(bf_data_1500_ramping,plot_trial_types,params,0);

%% Plot slopes and peak firing rates of example neuron and population

params.stats.peak_window = [1000:2000];
[max_ramp_fr] = get_maxFR_ramping(bf_data_1500_ramping,plot_trial_types,params);
slope_analysis = get_slope_ramping(bf_data_1500_ramping,plot_trial_types,params);

[precision_figure_data] = plot_precision_analyses(slope_analysis, max_ramp_fr, 16, 0);

%% Setup figure layout
dev_20230505_layout



