
%% Outcome aligned spike density function
% SDF parameters
plot_trial_types = {'certain','uncertain'};
params.plot.colormap = [247 154 154; 182 14 14]./255;
params.plot.xlim = [-1000 500]; params.plot.ylim = [-2 5];

% Basal forebrain
[~,~,bf_population_CS] =...
    plot_population_neuron_csOutcome(bf_data_CS,bf_datasheet_CS,plot_trial_types,params,0);
% Striatum
[~,~,striatum_population_CS] =...
    plot_population_neuron_csOutcome(striatum_data_CS,striatum_datasheet_CS,plot_trial_types,params,0);

%% ROC analysis
[roc_data_bf] = plot_cs_roc(bf_data_CS, bf_datasheet_CS);
[roc_data_striatum] = plot_cs_roc(striatum_data_CS, striatum_datasheet_CS);

%% Fano Factor
[fano_cs_bf] = plot_cs_fano(bf_data_CS, bf_datasheet_CS);
[fano_cs_striatum] = plot_cs_fano(striatum_data_CS,striatum_datasheet_CS);

%% Labels
plot_label = [repmat({'1_BF'},size(bf_data_CS,1),1);repmat({'2_Striatum'},size(striatum_data_CS,1),1)];
condition_label = [repmat({'1_Certain'},size(bf_data_CS,1)*2,1);repmat({'2_Uncertain'},size(striatum_data_CS,1)*2,1)];

%% Figure
% Figure data  -----------------------------------------
figure_plot(1,1) = bf_population_CS(1);

figure_plot(2,1) = striatum_population_CS(1);

figure_plot(3,1) = gramm('x',plot_label,'y',[roc_data_bf.roc;roc_data_striatum.roc],'color',plot_label);
figure_plot(3,1).stat_summary('geom',{'bar','errorbar'},'width',1,'dodge',1);
figure_plot(3,1).no_legend;
figure_plot(3,1).axe_property('YLim',[0.5 1.25]);

figure_plot(4,1) = gramm('x',[plot_label;plot_label],...
    'y',[fano_cs_bf.certain;fano_cs_striatum.certain;fano_cs_bf.uncertain;fano_cs_striatum.uncertain],...
    'color',condition_label);
figure_plot(4,1).stat_summary('geom',{'bar','errorbar'},'width',0.75,'dodge',1);
figure_plot(4,1).no_legend;
figure_plot(4,1).axe_property('YLim',[0 2.5]);

% Layout -------------------------------------------------
figure_plot(1,1).set_layout_options('Position',[0.15 0.6 0.175 0.15],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(2,1).set_layout_options('Position',[0.4 0.6 0.175 0.15],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(3,1).set_layout_options('Position',[0.1 0.15 0.5 0.5],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(4,1).set_layout_options('Position',[0.75 0.15 0.2 0.5],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(1,1).set_names('x','','y','');
figure_plot(2,1).set_names('x','','y','');

% Draw ---------------------------------------------------
figure('Renderer', 'painters', 'Position', [100 100 500 300]);
figure_plot.draw
