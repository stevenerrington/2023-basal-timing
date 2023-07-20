function bf_cstime_main(bf_data_CS, bf_datasheet_CS, params)

% Population
plot_trial_types = {'uncertain'};
params.plot.xlim = [0 3500]; params.plot.ylim = [-2 4];
params.plot.colormap = [240 59 59; 0, 198, 165]./255;

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

slope_analysis_1500 = get_slope_ramping_timing(bf_data_CS(strcmp(bf_datasheet_CS.site,'nih'),:),bf_datasheet_CS(strcmp(bf_datasheet_CS.site,'nih'),:),plot_trial_types,params);
slope_analysis_2500 = get_slope_ramping_timing(bf_data_CS(strcmp(bf_datasheet_CS.site,'wustl'),:),bf_datasheet_CS(strcmp(bf_datasheet_CS.site,'wustl'),:),plot_trial_types,params);


%% Structure: organize data for figure
% Basal forebrain ------------------------------------------------------
plot_peak_time_1500 = [];
plot_peak_time_var_1500 = [];
plot_peak_prob_label_1500 = [];
plot_slope_1500 = [];

for trial_type_i = 1:length(plot_trial_types)
    plot_peak_time_1500 = [plot_peak_time_1500; max_ramp_fr_1500.mean_averageSDF.(plot_trial_types{trial_type_i})];
    plot_peak_time_var_1500 = [plot_peak_time_var_1500; max_ramp_fr_1500.var.(plot_trial_types{trial_type_i})];
    plot_peak_prob_label_1500 = [plot_peak_prob_label_1500;...
        repmat({'1_1500'},...
        length(max_ramp_fr_1500.mean_averageSDF.(plot_trial_types{trial_type_i})),1)];
end

for neuron_i = 1:size(slope_analysis_1500.uncert_delivered.slope,2)
    plot_slope_1500 = [plot_slope_1500; nanmean(slope_analysis_1500.uncert_delivered.slope{neuron_i}(:))];
end

% Basal ganglia ------------------------------------------------------
plot_peak_time_2500 = [];
plot_peak_time_var_2500 = [];
plot_peak_prob_label_2500 = [];
plot_slope_2500 = [];

for trial_type_i = 1:length(plot_trial_types)
    plot_peak_time_2500 = [plot_peak_time_2500; max_ramp_fr_2500.mean_averageSDF.(plot_trial_types{trial_type_i})];
    plot_peak_time_var_2500 = [plot_peak_time_var_2500; max_ramp_fr_2500.var.(plot_trial_types{trial_type_i})];
    
    plot_peak_prob_label_2500 = [plot_peak_prob_label_2500;...
        repmat({'2_2500'},...
        length(max_ramp_fr_2500.mean_averageSDF.(plot_trial_types{trial_type_i})),1)];
    
end

for neuron_i = 1:size(slope_analysis_2500.uncert_delivered.slope,2)
    plot_slope_2500 = [plot_slope_2500; nanmean(slope_analysis_2500.uncert_delivered.slope{neuron_i}(:))];
end


%% Generate bar plots

clear bf_timingComp_fig
[~,~,bf_timingComp_fig] =...
    plot_population_neuron_test(bf_data_CS,bf_datasheet_CS,plot_trial_types,params,0);

bar_width = 1;

bf_timingComp_fig(1,2)=gramm('x',[plot_peak_prob_label_1500;plot_peak_prob_label_2500],...
    'y',[plot_peak_time_1500;plot_peak_time_2500],...
    'color',[plot_peak_prob_label_1500;plot_peak_prob_label_2500]);
bf_timingComp_fig(1,2).stat_summary('geom',{'bar','errorbar'},'width',bar_width);
bf_timingComp_fig(1,2).axe_property('YLim',[-100 100]);
bf_timingComp_fig(1,2).no_legend;

bf_timingComp_fig(1,3)=gramm('x',[plot_peak_prob_label_1500;plot_peak_prob_label_2500],...
    'y',[plot_peak_time_var_1500;plot_peak_time_var_2500],...
    'color',[plot_peak_prob_label_1500;plot_peak_prob_label_2500]);
bf_timingComp_fig(1,3).stat_summary('geom',{'bar','errorbar'},'width',bar_width);
bf_timingComp_fig(1,3).axe_property('YLim',[0 300]);
bf_timingComp_fig(1,3).no_legend;

bf_timingComp_fig(1,4)=gramm('x',[plot_peak_prob_label_1500;plot_peak_prob_label_2500],...
    'y',[plot_slope_1500;plot_slope_2500],...
    'color',[plot_peak_prob_label_1500;plot_peak_prob_label_2500]);
bf_timingComp_fig(1,4).stat_summary('geom',{'bar','errorbar'},'width',bar_width);
bf_timingComp_fig(1,4).axe_property('YLim',[0 0.05]);
bf_timingComp_fig(1,4).no_legend;

%% Generate figure
figure('Renderer', 'painters', 'Position', [100 100 800 200]);

bf_timingComp_fig(1,1).set_layout_options...
    ('Position',[0.1 0.2 0.3 0.7],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

bf_timingComp_fig(1,2).set_layout_options...
    ('Position',[0.45 0.2 0.1 0.7],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

bf_timingComp_fig(1,3).set_layout_options...
    ('Position',[0.65 0.2 0.1 0.7],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

bf_timingComp_fig(1,4).set_layout_options...
    ('Position',[0.85 0.2 0.1 0.7],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

bf_timingComp_fig.draw;
