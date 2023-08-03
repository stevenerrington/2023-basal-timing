params.sdf.baseline_win = [-1000:4500];

%% SDF plot: onset

plot_trial_types = {'p25s_75l_all','p50s_50l_all','p75s_25l_all'};
params.plot.colormap = [69, 191, 85; 40, 116, 50; 15, 44, 19]./255;
params.plot.xlim = [0 1500];

% Basal forebrain SDF
params.plot.ylim = [-2 4];
[~,~,bf_timing1500_onset] = plot_population_neuron(bf_data_timingTask,plot_trial_types,params,0);

% Striatum SDF
params.plot.ylim = [-1 4];
[~,~,striatum_timing1500_onset] = plot_population_neuron(striatum_data_timingTask,plot_trial_types,params,0);

%% SDF plot: offset
plot_trial_types = {'p25s_75l_long','p50s_50l_long','p75s_25l_long'};
params.plot.colormap = [69, 191, 85; 40, 116, 50; 15, 44, 19]./255;
params.plot.xlim = [1500 2000];

% Basal forebrain SDF
params.plot.ylim = [-2 4];
[~,~,bf_timing1500_outcome] = plot_population_neuron(bf_data_timingTask,plot_trial_types,params,0);

% Striatum SDF
params.plot.ylim = [-1 4];
[~,~,striatum_timing1500_outcome] = plot_population_neuron(striatum_data_timingTask,plot_trial_types,params,0);

%% SDF plot: late offset
plot_trial_types = {'uncertain_long'};
params.plot.colormap = [69, 191, 85]./255;
params.plot.xlim = [2000 4500];

% Basal forebrain SDF
params.plot.ylim = [-2 4];
[~,~,bf_timing1500_late] = plot_population_neuron(bf_data_timingTask,plot_trial_types,params,0);

% Striatum SDF
params.plot.ylim = [-1 4];
[~,~,striatum_timing1500_late] = plot_population_neuron(striatum_data_timingTask,plot_trial_types,params,0);

plot_trial_types = {'uncertain_long'};


%% SDF plot: outcome difference
params.plot.xlim = [1500 2000];
params.plot.colormap = [69, 191, 85; 40, 116, 50; 15, 44, 19]./255;

plot_trial_types = {{'p25s_75l_short','p25s_75l_long'},...
    {'p50s_50l_short','p50s_50l_long'},...
    {'p75s_25l_short','p75s_25l_long'}};
[~,~,bf_timing1500_diff] = plot_population_neuron_diff(bf_data_timingTask,plot_trial_types,params,0);
[~,~,striatum_timing1500_diff] = plot_population_neuron_diff(striatum_data_timingTask,plot_trial_types,params,0);


%% Tuning curves
plot_trial_types = {'p25s_75l_all','p50s_50l_all','p75s_25l_all'};
% BF 1500 Tuning
params.plot.xintercept = 1500;
[~, uncertainty_curve_population_bf1500, ~] =...
    plot_fr_x_uncertainTiming(bf_data_timingTask,plot_trial_types,params,0,'zscore');
% Striatum 1500 Tuning
[~, uncertainty_curve_population_stri1500, ~] =...
    plot_fr_x_uncertainTiming(striatum_data_timingTask,plot_trial_types,params,0,'zscore');


%% Figure: Input data
figure_plot = [bf_timing1500_onset(1), striatum_timing1500_onset(1),...
    bf_timing1500_outcome(1), striatum_timing1500_outcome(1),...
    bf_timing1500_late(1), striatum_timing1500_late(1),...
    uncertainty_curve_population_bf1500, uncertainty_curve_population_stri1500,...
    bf_timing1500_diff(1), striatum_timing1500_diff(1),...
    bf_timing1500_diff(2), striatum_timing1500_diff(2)];

%% Figure: Properties
figure_plot(1,3).axe_property('XTicks',[1500 1750 2000],'YColor',[1 1 1]);
figure_plot(1,4).axe_property('XTicks',[1500 1750 2000],'YColor',[1 1 1]);
figure_plot(1,3).set_names('y',''); figure_plot(1,4).set_names('y','');
figure_plot(1,5).set_names('y',''); figure_plot(1,6).set_names('y','');

figure_plot(1,5).axe_property('XTicks',[],'YColor',[1 1 1]);
figure_plot(1,6).axe_property('XTicks',[],'YColor',[1 1 1]);
figure_plot(1,7).axe_property('YLim',[0 2.5]);
figure_plot(1,8).axe_property('YLim',[-0.5 3]);
figure_plot(1,9).axe_property('YLim',[-3 2]);
figure_plot(1,10).axe_property('YLim',[-3 5]);
figure_plot(1,11).axe_property('YLim',[-3 2]);
figure_plot(1,12).axe_property('YLim',[-1 3]);

%% Figure: Layout 
figure_plot(1,1).set_layout_options('Position',[0.075 0.6 0.1 0.35],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(1,2).set_layout_options('Position',[0.075 0.1 0.1 0.35],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(1,3).set_layout_options('Position',[0.18 0.6 0.033 0.35],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(1,4).set_layout_options('Position',[0.18 0.1 0.033 0.35],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(1,5).set_layout_options('Position',[0.2280 0.6 0.167 0.35],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(1,6).set_layout_options('Position',[0.2280 0.1 0.167 0.35],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(1,7).set_layout_options('Position',[0.45 0.6 0.1 0.35],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(1,8).set_layout_options('Position',[0.45 0.1 0.1 0.35],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(1,9).set_layout_options('Position',[0.6 0.6 0.15 0.35],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(1,10).set_layout_options('Position',[0.6 0.1 0.15 0.35],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(1,11).set_layout_options('Position',[0.8 0.6 0.15 0.35],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(1,12).set_layout_options('Position',[0.8 0.1 0.15 0.35],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure('Renderer', 'painters', 'Position', [100 100 1000 400]);
figure_plot.draw;