function bfstri_cs_outcome(bf_data_CS,bf_datasheet_CS,striatum_data_CS,striatum_datasheet_CS,params)

bf_color = [247 154 154; 244 107 107; 240 59 59; 230 18 18; 182 14 14]./255;
striatum_color = [221 153 204; 204 85 153; 170 51 102; 85 34 51; 34 17 17]./255;
plot_trial_types = {'prob25nd','prob50nd','prob75nd'};

% Basal forebrain
params.plot.colormap = [bf_color(2,:); bf_color(3,:); bf_color(4,:)];
[~, cdf_latency_bf] = get_suppression_latency(bf_data_CS,bf_datasheet_CS,plot_trial_types);
expo_fit_data_bf = get_slope_ramping_outcome(bf_data_CS,bf_datasheet_CS,plot_trial_types,params);

% Striatum
params.plot.colormap = [striatum_color(2,:); striatum_color(3,:); striatum_color(4,:)];
[~, cdf_latency_bg] = get_suppression_latency(striatum_data_CS,striatum_datasheet_CS,plot_trial_types);
expo_fit_data_bg = get_slope_ramping_outcome(striatum_data_CS,striatum_datasheet_CS,plot_trial_types,params);

%% Setup figure
% SDF
params.plot.colormap = [bf_color(2,:); bf_color(3,:); bf_color(4,:)];
bf_population_CS_outcome = bf_cs_outcome(bf_data_CS,bf_datasheet_CS,params);
params.plot.colormap = [striatum_color(2,:); striatum_color(3,:); striatum_color(4,:)];
striatum_population_CS_outcome = bf_cs_outcome(striatum_data_CS,striatum_datasheet_CS,params);

figure_data = [bf_population_CS_outcome; striatum_population_CS_outcome];
figure_data = [figure_data(1); figure_data(4); figure_data(3); figure_data(6); figure_data(2); figure_data(5)];

% CDF latency
figure_data(7,1) = gramm('x',{cdf_latency_bf.data.prob25nd(:,1);cdf_latency_bf.data.prob50nd(:,1);cdf_latency_bf.data.prob75nd(:,1)},...
    'y',{cdf_latency_bf.data.prob25nd(:,2)';cdf_latency_bf.data.prob50nd(:,2)';cdf_latency_bf.data.prob75nd(:,2)'},...
    'color',plot_trial_types);
figure_data(7,1).geom_line;
figure_data(7,1).set_names('x','Time from Outcome (ms)','y','CDF');
figure_data(7,1).set_color_options('map',bf_color([2,3,4],:));
figure_data(7,1).no_legend;

figure_data(8,1) = gramm('x',{cdf_latency_bg.data.prob25nd(:,1);cdf_latency_bg.data.prob50nd(:,1);cdf_latency_bg.data.prob75nd(:,1)},...
    'y',{cdf_latency_bg.data.prob25nd(:,2)';cdf_latency_bg.data.prob50nd(:,2)';cdf_latency_bg.data.prob75nd(:,2)'},...
    'color',plot_trial_types);
figure_data(8,1).geom_line;
figure_data(8,1).set_names('x','Time from Outcome (ms)','y','CDF');
figure_data(8,1).set_color_options('map',striatum_color([2,3,4],:));
figure_data(8,1).no_legend;

% Lambda
cond_label_bf = [repmat({'1_prob25'},length(expo_fit_data_bf.average.prob25nd),1);...
    repmat({'2_prob50'},length(expo_fit_data_bf.average.prob50nd),1);...
    repmat({'3_prob75'},length(expo_fit_data_bf.average.prob75nd),1)];

cond_label_bg = [repmat({'1_prob25'},length(expo_fit_data_bg.average.prob25nd),1);...
    repmat({'2_prob50'},length(expo_fit_data_bg.average.prob50nd),1);...
    repmat({'3_prob75'},length(expo_fit_data_bg.average.prob75nd),1)];

figure_data(9,1)=gramm('x',cond_label_bf,...
    'y',[expo_fit_data_bf.average.prob25nd;expo_fit_data_bf.average.prob50nd;expo_fit_data_bf.average.prob75nd],...
    'color',cond_label_bf);
figure_data(9,1).stat_summary('geom',{'bar','errorbar'},'width',2,'dodge',1);
figure_data(9,1).no_legend;
figure_data(9,1).set_color_options('map',bf_color([2,3,4],:));
figure_data(9,1).axe_property('YLim',[0 0.03]);
figure_data(9,1).set_names('y','Lambda');

figure_data(10,1)=gramm('x',cond_label_bg,...
    'y',[expo_fit_data_bg.average.prob25nd;expo_fit_data_bg.average.prob50nd;expo_fit_data_bg.average.prob75nd],...
    'color',cond_label_bg);
figure_data(10,1).stat_summary('geom',{'bar','errorbar'},'width',2,'dodge',1);
figure_data(10,1).no_legend;
figure_data(10,1).set_color_options('map',striatum_color([2,3,4],:));
figure_data(10,1).axe_property('YLim',[0 0.05]);
figure_data(10,1).set_names('y','Lambda');

%% Define figure properties
figure_data(1,1).axe_property('XColor',[1 1 1]);
figure_data(2,1).axe_property('XTicks',[0 250 400 600],'XColor',[1 1 1],'XTicks',[]);
figure_data(3,1).axe_property('XColor',[1 1 1],'XTicks',[]);
figure_data(4,1).axe_property('YLim',[0 2],'XColor',[1 1 1],'XTicks',[]);

figure_data(7,1).axe_property('XLim',[50 400],'YLim',[0 1]);
figure_data(8,1).axe_property('XLim',[50 400],'YLim',[0 1]);
figure_data(9,1).axe_property('XColor',[1 1 1]);
figure_data(10,1).axe_property('XColor',[1 1 1]);

% BF SDF
figure_data(1,1).set_layout_options...
    ('Position',[0.075 0.65 0.3 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% Striatum SDF
figure_data(2,1).set_layout_options...
    ('Position',[0.075 0.2 0.3 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% BF Summary
figure_data(3,1).set_layout_options...
    ('Position',[0.3 0.77 0.07 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% Striatum Summary
figure_data(4,1).set_layout_options...
    ('Position',[0.3 0.325 0.07 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% BF Fano
figure_data(5,1).set_layout_options...
    ('Position',[0.075 0.55 0.3 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% Striatum Fano
figure_data(6,1).set_layout_options...
    ('Position',[0.075 0.1 0.3 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% Basal forebrain lambda
figure_data(9,1).set_layout_options...
    ('Position',[0.42 0.55 0.2 0.35],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% Striatum lambda
figure_data(10,1).set_layout_options...
    ('Position',[0.42 0.1 0.2 0.35],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% Basal forebrain latency
figure_data(7,1).set_layout_options...
    ('Position',[0.52 0.82 0.1 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% Striatum latency
figure_data(8,1).set_layout_options...
    ('Position',[0.52 0.375 0.1 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure('Renderer', 'painters', 'Position', [100 100 1000 600]);
figure_data.draw;