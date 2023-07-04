% Population
plot_trial_types = {'uncertain'};
params.plot.xlim = [0 3500]; params.plot.ylim = [-2 4];
params.plot.colormap = [240 59 59; 0, 198, 165]./255;

clear bf_timingComp_fig
[~,~,bf_timingComp_fig] =...
    plot_population_neuron_test([bf_data_CS; bf_data_CS2],[bf_datasheet_CS; bf_datasheet_CS2],plot_trial_types,params,0);


%% Extract: get precision timing analyses
params.stats.peak_window = [-250:250];
plot_trial_types = {'uncert_delivered'};
[max_ramp_fr_1500] = get_maxFR_ramping_outcome...
    (bf_data_CS(strcmp(bf_datasheet_CS.site,'nih'),:),...
    bf_datasheet_CS(strcmp(bf_datasheet_CS.site,'nih'),:),...
    plot_trial_types,params);

[max_ramp_fr_2500] = get_maxFR_ramping_outcome...
    (bf_data_CS(strcmp(bf_datasheet_CS.site,'wustl'),:),...
    bf_datasheet_CS(strcmp(bf_datasheet_CS.site,'wustl'),:),...
    plot_trial_types,params);

%% Structure: organize data for figure
% Basal forebrain ------------------------------------------------------
plot_peak_time_bf = [];
plot_peak_time_var_bf = [];
plot_peak_prob_label_bf = [];
plot_slope_bf = [];

for trial_type_i = 1:length(plot_trial_types)
    plot_peak_time_bf = [plot_peak_time_bf; max_ramp_fr_1500.mean_averageSDF.(plot_trial_types{trial_type_i})];
    plot_peak_time_var_bf = [plot_peak_time_var_bf; max_ramp_fr_1500.var.(plot_trial_types{trial_type_i})];
    plot_peak_prob_label_bf = [plot_peak_prob_label_bf;...
        repmat({'1_1500'},...
        length(max_ramp_fr_1500.mean_averageSDF.(plot_trial_types{trial_type_i})),1)];
    
end

% Basal ganglia ------------------------------------------------------
plot_peak_time_bg = [];
plot_peak_time_var_bg = [];
plot_peak_prob_label_bg = [];
plot_slope_bg = [];

for trial_type_i = 1:length(plot_trial_types)
    plot_peak_time_bg = [plot_peak_time_bg; max_ramp_fr_2500.mean_averageSDF.(plot_trial_types{trial_type_i})];
    plot_peak_time_var_bg = [plot_peak_time_var_bg; max_ramp_fr_2500.var.(plot_trial_types{trial_type_i})];
    
    plot_peak_prob_label_bg = [plot_peak_prob_label_bg;...
        repmat({'2_2500'},...
        length(max_ramp_fr_2500.mean_averageSDF.(plot_trial_types{trial_type_i})),1)];
    
end

%% Generate bar plots

bar_width = 1;

bf_timingComp_fig(1,2)=gramm('x',[plot_peak_prob_label_bf;plot_peak_prob_label_bg],...
    'y',[plot_peak_time_bf;plot_peak_time_bg],...
    'color',[plot_peak_prob_label_bf;plot_peak_prob_label_bg]);
bf_timingComp_fig(1,2).stat_summary('geom',{'bar','errorbar'},'width',bar_width);
bf_timingComp_fig(1,2).axe_property('YLim',[-100 100]);
bf_timingComp_fig(1,2).no_legend;

bf_timingComp_fig(1,3)=gramm('x',[plot_peak_prob_label_bf;plot_peak_prob_label_bg],...
    'y',[plot_peak_time_var_bf;plot_peak_time_var_bg],...
    'color',[plot_peak_prob_label_bf;plot_peak_prob_label_bg]);
bf_timingComp_fig(1,3).stat_summary('geom',{'bar','errorbar'},'width',bar_width);
bf_timingComp_fig(1,3).axe_property('YLim',[0 300]);
bf_timingComp_fig(1,3).no_legend;

%% Generate figure
figure('Renderer', 'painters', 'Position', [100 100 600 200]);

bf_timingComp_fig(1,1).set_layout_options...
    ('Position',[0.1 0.2 0.45 0.7],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

bf_timingComp_fig(1,2).set_layout_options...
    ('Position',[0.65 0.2 0.15 0.7],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

bf_timingComp_fig(1,3).set_layout_options...
    ('Position',[0.85 0.2 0.15 0.7],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

bf_timingComp_fig.draw
