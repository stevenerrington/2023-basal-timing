function bf_appaver_main(bf_data_punish, params)

%% Parameters & setup
colors.appetitive = [248, 164, 164; 240, 52, 51; 202, 16, 15]./255;
colors.aversive = [116, 255, 232; 0, 198, 165; 0, 75, 65]./255;

%% > Plot population ramping neurons
% Appetitive
params.plot.xlim = [0 1500]; params.plot.ylim = [-2 4]; params.plot.xintercept = 1500;
plot_trial_types = {'prob0','prob50','prob100'};
params.plot.colormap = colors.appetitive;
[~, ~, bf_pop_CS1500_ramping_appetitive] = plot_population_neuron(bf_data_punish,plot_trial_types,params,0);

% Aversive
plot_trial_types = {'prob0_punish','prob50_punish','prob100_punish'};
params.plot.colormap = colors.aversive;
[~, ~, bf_pop_CS1500_ramping_aversive] = plot_population_neuron(bf_data_punish,plot_trial_types,params,0);

%% Extract slopes, mean firing rates, and fano of example neuron and population
params.stats.peak_window = [-500:0];
params.plot.xintercept = 1500;
params.fano.timewindow = 0:1500;
% 
% % Appetitive
% plot_trial_types = {'prob0','prob50','prob100'};
% [max_ramp_fr_appetitive] = get_maxFR_z_ramping(plot_data_appetitive, plot_trial_types, params);
% slope_analysis_appetitive = get_slope_ramping(bf_data_punish,plot_trial_types,params);
% [fano_appetitive] = get_fano_ramping(bf_data_punish, plot_trial_types, params);
% 
% % Aversive
% plot_trial_types = {'prob0_punish','prob50_punish','prob100_punish'};
% [max_ramp_fr_aversive] = get_maxFR_z_ramping(plot_data_aversive, plot_trial_types, params);
% slope_analysis_aversive = get_slope_ramping(bf_data_punish,plot_trial_types,params);
% [fano_aversive] = get_fano_ramping(bf_data_punish, plot_trial_types, params);

%% Setup figure data
clear figure_plot
striatum_pop_CS1500_ramping_appetitive = copy(bf_pop_CS1500_ramping_appetitive(1));
striatum_pop_CS1500_ramping_aversive = copy(bf_pop_CS1500_ramping_aversive(1));

figure_plot = [bf_pop_CS1500_ramping_appetitive(1),  bf_pop_CS1500_ramping_aversive(1),...
    striatum_pop_CS1500_ramping_appetitive(1), striatum_pop_CS1500_ramping_aversive(1)];

%% Configure & layout figure
% Basal forebrain
figure_plot(1,1).set_layout_options('Position',[0.075 0.6 0.15 0.15],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(1,2).set_layout_options('Position',[0.075 0.3 0.15 0.15],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% Striatum (place holder atm)
figure_plot(1,3).set_layout_options('Position',[0.3 0.6 0.15 0.15],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(1,4).set_layout_options('Position',[0.3 0.3 0.15 0.15],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure('Renderer', 'painters', 'Position', [100 100 1000 600]);
figure_plot.draw;
