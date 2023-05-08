
colors.appetitive = [248, 164, 164; 240, 52, 51; 202, 16, 15]./255;
%colors.aversive = [255, 208, 8; 216, 175, 0; 169, 136, 0]./255; %yello
colors.aversive = [128, 128, 128; 102, 103, 106; 69, 71, 75]./255;

example_neuron_appetitive = 30;
example_neuron_aversive = 30;

%% > Plot example ramping neuron in the basal forebrain.
params.plot.xlim = [-500 3500]; params.plot.ylim = [0 100];
plot_trial_types = {'prob0','prob50','prob100'};
params.plot.colormap = colors.appetitive;
params.plot.xlim = [0 1500]; params.plot.xintercept = 1500;
[~, ~,bf_example_CS1500_ramping_appetitive] = plot_example_neuron(bf_data_punish,plot_trial_types,params,example_neuron_appetitive,0);


plot_trial_types = {'prob0_punish','prob50_punish','prob100_punish'};
params.plot.colormap = colors.aversive;
params.plot.xlim = [0 1500]; params.plot.xintercept = 1500;
[~, ~,bf_example_CS1500_ramping_aversive] = plot_example_neuron(bf_data_punish,plot_trial_types,params,example_neuron_aversive,0);

%% > Plot population ramping neurons
%  Plot population averaged ramping neuron activity in the basal forebrain (NIH subset).
params.plot.xlim = [0 1500]; params.plot.ylim = [-2 4]; params.plot.xintercept = 1500;
plot_trial_types = {'prob0','prob50','prob100'};
params.plot.colormap = colors.appetitive;
[~, ~, bf_pop_CS1500_ramping_appetitive] = plot_population_neuron(bf_data_punish,plot_trial_types,params,0);

plot_trial_types = {'prob0_punish','prob50_punish','prob100_punish'};
params.plot.colormap = colors.aversive;
[~, ~, bf_pop_CS1500_ramping_aversive] = plot_population_neuron(bf_data_punish,plot_trial_types,params,0);



%% Plot slopes and peak firing rates of example neuron and population
% 
% clear max_ramp_fr* slope_analysis*
% params.stats.peak_window = [-500:500];
% plot_trial_types = {'prob0','prob50','prob100'};
% [max_ramp_fr_appetitive] = get_maxFR_ramping(bf_data_punish,plot_trial_types,params);
% slope_analysis_appetitive = get_slope_ramping(bf_data_punish,plot_trial_types,params);
% 
% plot_trial_types = {'prob0_punish','prob50_punish','prob100_punish'};
% [max_ramp_fr_aversive] = get_maxFR_ramping(bf_data_punish,plot_trial_types,params);
% slope_analysis_aversive = get_slope_ramping(bf_data_punish,plot_trial_types,params);

params.plot.colormap = colors.appetitive;
[precision_figure_data_appetitive] = plot_precision_analyses(slope_analysis_appetitive, max_ramp_fr_appetitive, params, example_neuron_appetitive,0);
params.plot.colormap = colors.aversive;
[precision_figure_data_aversive] = plot_precision_analyses(slope_analysis_aversive, max_ramp_fr_aversive, params, example_neuron_aversive, 0);

%% Setup figure layout
dev_20230505_layout




%% Plot: Fano factor compass plots

% Set figure parameters
spider_plot_radius = 1;
spider_plot_AxesPrecision = 1;
spider_plot_fill = 'on';
params.plot.xintercept = 1500;
spider_plot_fill_alpha = 0.1;

% Input figure data:
plot_trial_types = {'prob0','prob50','prob100'};
fano_analysis_appetitive = get_xepoch_fano(bf_data_punish, plot_trial_types, params);
plot_trial_types = {'prob0_punish','prob50_punish','prob100_punish'};
fano_analysis_aversive = get_xepoch_fano(bf_data_punish, plot_trial_types, params);

% Generate figure
spider_fano_cstask_figure = figure('Renderer', 'painters', 'Position', [100 100 600 250]);

% > Appetitive
subplot(1,2,1)
spider_plot(fano_analysis_appetitive.concatenate,...
    'AxesInterval', 5,...
    'AxesLabels', fano_analysis_appetitive.epoch_labels,...
    'AxesLimits', [repmat(0,1,length(fano_analysis_appetitive.epoch_labels));...
                repmat(spider_plot_radius,1,length(fano_analysis_appetitive.epoch_labels))],... % [min axes limits; max axes limits]
    'AxesPrecision', repmat(spider_plot_AxesPrecision,1,length(fano_analysis_appetitive.epoch_labels)),...
    'color',colors.appetitive,...
    'FillOption', spider_plot_fill,...
    'FillTransparency', spider_plot_fill_alpha);
spider_plot_legend = legend({'0%','50%','100%'}, 'Location', 'SouthOutside','Orientation','Horizontal');
spider_plot_legend.NumColumns = 3;

% > Aversive
subplot(1,2,2)
spider_plot(fano_analysis_aversive.concatenate,...
    'AxesInterval', 5,...
    'AxesLabels', fano_analysis_aversive.epoch_labels,...
    'AxesLimits', [repmat(0,1,length(fano_analysis_aversive.epoch_labels));...
                repmat(spider_plot_radius,1,length(fano_analysis_aversive.epoch_labels))],... % [min axes limits; max axes limits]
    'AxesPrecision', repmat(spider_plot_AxesPrecision,1,length(fano_analysis_aversive.epoch_labels)),...
    'color',colors.aversive,...
    'FillOption', spider_plot_fill,...
    'FillTransparency', spider_plot_fill_alpha);
spider_plot_legend = legend({'0%','50%','100%'}, 'Location', 'SouthOutside','Orientation','Horizontal');
spider_plot_legend.NumColumns = 3;


