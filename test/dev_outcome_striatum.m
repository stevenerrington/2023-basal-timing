plot_trial_types = {'prob25nd','prob25d','prob50nd','prob50d','prob75nd','prob75d'};

% > Plot outcome-aligned population activity for ramping neurons in the
%   basal forebrain.
params.plot.xlim = [0 500]; params.plot.ylim = [-2 3];
params.plot.colormap = [0 0 0; 1, 0, 0; 0 0 0; 1, 0, 0; 0 0 0; 1, 0, 0];

striatum_population_CS_outcome = plot_population_CSoutcome(striatum_data_CS,striatum_datasheet_CS, plot_trial_types,params);

striatum_population_CS_outcome(1,1).set_layout_options...
    ('Position',[0.05 0.45 0.6 0.35],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

striatum_population_CS_outcome(2,1).set_layout_options...
    ('Position',[0.05 0.325 0.6 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

striatum_population_CS_outcome(3,1).set_layout_options...
    ('Position',[0.7 0.6 0.25 0.3],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);


striatum_population_CS_outcome(4,1).set_layout_options...
    ('Position',[0.7 0.2 0.25 0.3],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);


figure('Renderer', 'painters', 'Position', [100 100 600 400])
striatum_population_CS_outcome.draw