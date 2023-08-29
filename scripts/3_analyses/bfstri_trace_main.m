function bfstri_trace_main (bf_data_traceExp, striatum_data_traceExp, params)

%% Extract: get SDF and gaze data across trial types
% Define parameters & trial types to extract
params.plot.xintercept = 2500;
params.stats.peak_window = [-500:0];
plot_trial_types = {'notrace_uncertain','notrace_certain','uncertain','certain'};

% params.plot.colormap = [[0 70 67]./255;[242 165 65]./255];
params.plot.colormap = [127 191 185; 8 140 133; 193 140 190; 131 40 133]./255;
params.plot.xlim = [0 2500];

% Plot population averaged ramping neuron activity in the basal forebrain.
params.plot.ylim = [-3 4]; params.plot.xintercept = [2500];
[~, bf_trace_data, bf_population_trace_ramping] = plot_population_neuron(bf_data_traceExp,plot_trial_types,params,0);
% Plot population averaged ramping neuron activity in the striatum.
params.plot.ylim = [-1 6]; params.plot.xintercept = [2500];
[~, striatum_trace_data, striatum_population_trace_ramping] = plot_population_neuron(striatum_data_traceExp,plot_trial_types,params,0);

% Get average firing rate within window:
[max_ramp_fr_bf] = get_maxFR_z_ramping(bf_trace_data, plot_trial_types, params); % 500ms preoutcome 
[max_ramp_fr_stri] = get_maxFR_z_ramping(striatum_trace_data, plot_trial_types, params); % 500ms preoutcome 


%% Curate: restructure data for use with gramm figure
fr_conditions_data = [max_ramp_fr_bf.max_fr_out; max_ramp_fr_stri.max_fr_out];
fr_conditions_trl_label = [max_ramp_fr_bf.trial_type_out; max_ramp_fr_stri.trial_type_out];
fr_conditions_area_label = [repmat({'1_BF'},length(max_ramp_fr_bf.max_fr_out),1); repmat({'2_Striatum'},length(max_ramp_fr_stri.max_fr_out),1)];

[bf_fr_ROC] = plot_trace_roc(bf_data_traceExp,plot_trial_types);
[striatum_fr_ROC] = plot_trace_roc(striatum_data_traceExp,plot_trial_types);
 
roc_conditions_data = [bf_fr_ROC.roc_trace; bf_fr_ROC.roc_notrace; striatum_fr_ROC.roc_trace; striatum_fr_ROC.roc_notrace];
roc_conditions_label = [repmat({'2_trace'},length(bf_fr_ROC.roc_trace),1);repmat({'1_notrace'},length(bf_fr_ROC.roc_notrace),1);...
    repmat({'2_trace'},length(striatum_fr_ROC.roc_trace),1);repmat({'1_notrace'},length(striatum_fr_ROC.roc_notrace),1)];
roc_conditions_area_label = [repmat({'1_BF'},length([bf_fr_ROC.roc_trace; bf_fr_ROC.roc_notrace]),1); repmat({'2_Striatum'},length([striatum_fr_ROC.roc_trace; striatum_fr_ROC.roc_notrace]),1)];

%% Fano Factor
[fano_trace_bf] = plot_trace_fano(bf_data_traceExp);
[fano_trace_striatum] = plot_trace_fano(striatum_data_traceExp);


%% Figure creation
% Population figures
clear figure_plot
figure_plot = [bf_population_trace_ramping(1);...
    striatum_population_trace_ramping(1)]; 

% Summary plots (Firing rate)
% > Basal forebrain
% >> Mean firing rate
figure_plot(3,1)=gramm('x',fr_conditions_trl_label,'y',fr_conditions_data,'color',fr_conditions_trl_label,'subset',strcmp(fr_conditions_area_label,'1_BF'));
figure_plot(3,1).stat_summary('geom',{'bar','errorbar'},'width',3,'dodge',1);
figure_plot(3,1).axe_property('YLim',[-1 4]);
figure_plot(3,1).set_names('y','');
figure_plot(3,1).no_legend;

% > Striatum
% >> Mean firing rate
figure_plot(4,1)=gramm('x',fr_conditions_trl_label,'y',fr_conditions_data,'color',fr_conditions_trl_label,'subset',strcmp(fr_conditions_area_label,'2_Striatum'));
figure_plot(4,1).stat_summary('geom',{'bar','errorbar'},'width',3,'dodge',1);
figure_plot(4,1).axe_property('YLim',[-1 7]);
figure_plot(4,1).set_names('y','');
figure_plot(4,1).no_legend;

% Summary plots (ROC)
 % > Basal forebrain & Striatum
% >> ROC
figure_plot(5,1)=gramm('x',roc_conditions_area_label,'y',roc_conditions_data,'color',roc_conditions_label);
figure_plot(5,1).stat_summary('geom',{'bar','errorbar'});
figure_plot(5,1).axe_property('YLim',[0 1]);
figure_plot(5,1).set_names('y','AUROC');
% figure_plot(5,1).no_legend;

plot_trial_types = {'notrace_uncertain','notrace_certain','uncertain','certain'};

% Summary plots (Fano)
 % > Basal forebrain & Striatum
condition_label = [repmat({'1_notrace_uncertain'},size(bf_data_traceExp,1),1);...
    repmat({'2_notrace_certain'},size(bf_data_traceExp,1),1);...
    repmat({'3_uncertain'},size(bf_data_traceExp,1),1);...
    repmat({'4_certain'},size(bf_data_traceExp,1),1);...
    repmat({'1_notrace_uncertain'},size(striatum_data_traceExp,1),1);...
    repmat({'2_notrace_certain'},size(striatum_data_traceExp,1),1);...
    repmat({'3_uncertain'},size(striatum_data_traceExp,1),1);...
    repmat({'4_certain'},size(striatum_data_traceExp,1),1)];

plot_label = [repmat({'1_BF'},size(bf_data_traceExp,1)*4,1);...
    repmat({'2_Striatum'},size(striatum_data_traceExp,1)*4,1)];

figure_plot(6,1) = gramm('x',[plot_label],...
    'y',[fano_trace_bf.uncertain_notrace; fano_trace_bf.certain_notrace;...
    fano_trace_bf.uncertain_trace; fano_trace_bf.certain_trace;...
    fano_trace_striatum.uncertain_notrace; fano_trace_striatum.certain_notrace;...
    fano_trace_striatum.uncertain_trace; fano_trace_striatum.certain_trace],...
    'color',condition_label);
figure_plot(6,1).stat_summary('geom',{'bar','errorbar'});
figure_plot(6,1).no_legend;
figure_plot(6,1).axe_property('YLim',[0 2]);
figure_plot(6,1).set_names('y','Fano');

% bf_trace_fr_plot
figure_plot(1,1).set_color_options('map',params.plot.colormap);
figure_plot(2,1).set_color_options('map',params.plot.colormap);
figure_plot(3,1).set_color_options('map',params.plot.colormap);
figure_plot(4,1).set_color_options('map',params.plot.colormap);
figure_plot(5,1).set_color_options('map',params.plot.colormap([2,4],:));
figure_plot(6,1).set_color_options('map',[params.plot.colormap;params.plot.colormap]);

%% Configure & layout figure
% Spike density function/activity
figure_plot(1,1).set_layout_options('Position',[0.075 0.6 0.21 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend_position',[0.075 0.3 0.1 0.2],... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(2,1).set_layout_options('Position',[0.325 0.6 0.21 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend_position',[0.375 0.3 0.1 0.2],... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);


% Summary plots
% > BF (Firing rate, inset)
figure_plot(3,1).set_layout_options('Position',[0.095 0.725 0.06 0.06],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% > Striatum (Firing rate, inset)
figure_plot(4,1).set_layout_options('Position',[0.355 0.725 0.06 0.06],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% > BF & Striatum (ROC)
figure_plot(5,1).set_layout_options('Position',[0.625 0.6 0.15 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend_position',[0.625 0.3 0.1 0.2],... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(6,1).set_layout_options('Position',[0.82 0.6 0.15 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend_position',[0.85 0.3 0.1 0.2],... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);


for i = [1,2]
    figure_plot(i,1).set_line_options('base_size',0.5);
end

figure_plot(2,1).set_names('y','');

figure_plot(3,1).axe_property('XTick',[],'XColor',[1 1 1]);
figure_plot(4,1).axe_property('XTick',[],'XColor',[1 1 1]);

figure_plot(5,1).geom_hline('yintercept',0.5);
figure_plot(6,1).geom_hline('yintercept',1);


%% Plot figure
figure('Renderer', 'painters', 'Position', [100 100 1000 600]);
figure_plot.draw;