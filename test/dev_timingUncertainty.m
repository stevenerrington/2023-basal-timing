plot_trial_types = {'fractal6105_4500','p25s_75l_short','p50s_50l_short','p75s_25l_short','p100s_0l_short'};
params.plot.colormap = cool(5);
params.plot.xlim = [0 1500];

% Basal forebrain
params.plot.ylim = [-2 2];
[~,~,bf_timing1500] = plot_population_neuron(bf_data_timingTask,plot_trial_types,params,0);

% Striatum
params.plot.ylim = [-1 2];
[~,~,striatum_timing1500] = plot_population_neuron(striatum_data_timingTask,plot_trial_types,params,0);



%% Generate figure
figure_plot = [bf_timing1500(1), striatum_timing1500(1)];

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

figure('Renderer', 'painters', 'Position', [100 100 600 400]);
figure_plot.draw;