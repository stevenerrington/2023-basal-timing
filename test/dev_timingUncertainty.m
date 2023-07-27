plot_trial_types = {'p25s_75l_long','p50s_50l_long','p75s_25l_long'};
params.plot.colormap = [69, 191, 85; 40, 116, 50; 15, 44, 19]./255;

params.plot.xlim = [0 4500];
params.sdf.baseline_win = [-1000:4500];

% Basal forebrain SDF
params.plot.ylim = [-2 2];
[~,~,bf_timing1500] = plot_population_neuron(bf_data_timingTask,plot_trial_types,params,0);

% Striatum SDF
params.plot.ylim = [-1 2];
[~,~,striatum_timing1500] = plot_population_neuron(striatum_data_timingTask,plot_trial_types,params,0);


% BF 1500 Tuning
params.plot.xintercept = 1500;
[~, uncertainty_curve_population_bf1500, ~] =...
    plot_fr_x_uncertainTiming(bf_data_timingTask,plot_trial_types,params,0,'zscore');
% Striatum 1500 Tuning
[~, uncertainty_curve_population_stri1500, ~] =...
    plot_fr_x_uncertainTiming(striatum_data_timingTask,plot_trial_types,params,0,'zscore');

params.plot.xintercept = 4500;
[~, uncertainty_curve_population_bf4500, ~] =...
    plot_fr_x_uncertainTiming(bf_data_timingTask,plot_trial_types,params,0,'zscore');
% Striatum 1500 Tuning
[~, uncertainty_curve_population_stri4500, ~] =...
    plot_fr_x_uncertainTiming(striatum_data_timingTask,plot_trial_types,params,0,'zscore');

%% Figure: Input data
figure_plot = [bf_timing1500(1), striatum_timing1500(1),...
    uncertainty_curve_population_bf1500, uncertainty_curve_population_stri1500,...
    uncertainty_curve_population_bf4500, uncertainty_curve_population_stri4500];

%% Figure: Properties
figure_plot(1,1).geom_vline('xintercept',1500)
figure_plot(1,2).geom_vline('xintercept',1500)

figure_plot(1,3).axe_property('YLim',[-1 1.5])
figure_plot(1,4).axe_property('YLim',[-1 1.5])

figure_plot(1,5).axe_property('YLim',[-1 1.5])
figure_plot(1,6).axe_property('YLim',[-1 1.5])

%% Figure: Layout 
% Basal forebrain
figure_plot(1,1).set_layout_options('Position',[0.075 0.6 0.5 0.35],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(1,2).set_layout_options('Position',[0.075 0.1 0.5 0.35],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(1,3).set_layout_options('Position',[0.6 0.6 0.15 0.35],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(1,4).set_layout_options('Position',[0.6 0.1 0.15 0.35],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(1,5).set_layout_options('Position',[0.8 0.6 0.15 0.35],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(1,6).set_layout_options('Position',[0.8 0.1 0.15 0.35],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);


figure('Renderer', 'painters', 'Position', [100 100 600 400]);
figure_plot.draw;