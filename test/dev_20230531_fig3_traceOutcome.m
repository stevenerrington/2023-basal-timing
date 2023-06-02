
% > Trace task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
plot_trial_types = {'notimingcue_uncertain_d',...
    'notimingcue_uncertain_nd'};
params.plot.colormap = [255 0 0; 0 0 0]./255;

% > Plot outcome-aligned population activity for ramping neurons in the
%   basal forebrain.
params.plot.xlim = [-1000 1000]; params.plot.ylim = [-2 3];
[~, bf_population_trace_outcome] = plot_population_traceoutcome(bf_data_traceExp,plot_trial_types,params);

% > Plot outcome-aligned population activity for ramping neurons in the
%   striatum.
params.plot.ylim = [-2 3];
[~, striatum_population_trace_outcome] = plot_population_traceoutcome(striatum_data_traceExp,plot_trial_types,params);

clear figure_plot
figure_plot = [bf_population_trace_outcome, striatum_population_trace_outcome];

figure_plot(1,1).set_layout_options('Position',[0.1 0.2 0.35 0.7],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(1,2).set_layout_options('Position',[0.55 0.2 0.35 0.7],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(1,2).axe_property('YTick',[],'YColor',[1 1 1]);

figure('Renderer', 'painters', 'Position', [100 100 400 200]);
figure_plot.draw()

