
%% > Plot example ramping neuron in the basal forebrain.
params.plot.xlim = [-500 3500]; params.plot.ylim = [0 60];
plot_trial_types = {'prob0','prob50','prob100'};
params.plot.colormap = cool(length(plot_trial_types));
params.plot.xlim = [0 1500]; params.plot.xintercept = 1500;
[~, ~,bf_example_CS1500_ramping_appetitive] = plot_example_neuron(bf_data_1500_ramping,plot_trial_types,params,16,0);


plot_trial_types = {'prob0_punish','prob50_punish','prob100_punish'};
params.plot.colormap = cool(length(plot_trial_types));
params.plot.xlim = [0 1500]; params.plot.xintercept = 1500;
[~, ~,bf_example_CS1500_ramping_aversive] = plot_example_neuron(bf_data_punish,plot_trial_types,params,2,0);

%% > Plot population ramping neurons
%  Plot population averaged ramping neuron activity in the basal forebrain (NIH subset).
params.plot.xlim = [0 1500]; params.plot.ylim = [-2 4]; params.plot.xintercept = 1500;
plot_trial_types = {'prob0','prob50','prob100'};
params.plot.colormap = cool(length(plot_trial_types));
[~, ~, bf_pop_CS1500_ramping_appetitive] = plot_population_neuron(bf_data_1500_ramping,plot_trial_types,params,0);

plot_trial_types = {'prob0_punish','prob50_punish','prob100_punish'};
params.plot.colormap = cool(length(plot_trial_types));
[~, ~, bf_pop_CS1500_ramping_aversive] = plot_population_neuron(bf_data_punish,plot_trial_types,params,0);



%% Plot slopes and peak firing rates of example neuron and population

clear max_ramp_fr* slope_analysis*
params.stats.peak_window = [1000:2000];
plot_trial_types = {'prob0','prob50','prob100'};
[max_ramp_fr_appetitive] = get_maxFR_ramping(bf_data_1500_ramping,plot_trial_types,params);
slope_analysis_appetitive = get_slope_ramping(bf_data_1500_ramping,plot_trial_types,params);

plot_trial_types = {'prob0_punish','prob50_punish','prob100_punish'};
[max_ramp_fr_aversive] = get_maxFR_ramping(bf_data_punish,plot_trial_types,params);
slope_analysis_aversive = get_slope_ramping(bf_data_punish,plot_trial_types,params);

[precision_figure_data_appetitive] = plot_precision_analyses(slope_analysis_appetitive, max_ramp_fr_appetitive, 16,1);
[precision_figure_data_aversive] = plot_precision_analyses(slope_analysis_aversive, max_ramp_fr_aversive, 16, 0);

%% Setup figure layout
dev_20230505_layout



