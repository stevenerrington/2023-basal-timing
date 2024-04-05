function bfstri_cs_precision(bf_data_CS, bf_datasheet_CS,striatum_data_CS,striatum_datasheet_CS, params)

global dirs

%% Import heatmap colors
load('heatmap_color.mat');

%% Extract: get precision timing analyses
params.stats.peak_window = [-250:250];
plot_trial_types = {'uncert_delivered','uncert_omit'};

% Get peak fr time
[max_ramp_fr_bf] = get_maxFR_ramping_outcome(bf_data_CS,bf_datasheet_CS,plot_trial_types,params);
[max_ramp_fr_bg] = get_maxFR_ramping_outcome(striatum_data_CS,striatum_datasheet_CS,plot_trial_types,params);

% Return to baseline latency
plot_trial_types = {'prob25nd','prob50nd','prob75nd'};
baseline_latency_bf = get_suppression_latency(bf_data_CS,bf_datasheet_CS,plot_trial_types);
baseline_latency_bg = get_suppression_latency(striatum_data_CS,striatum_datasheet_CS,plot_trial_types);

plot_latency_bf = [baseline_latency_bf.prob25nd;baseline_latency_bf.prob50nd;baseline_latency_bf.prob75nd];
plot_latency_bg = [baseline_latency_bg.prob25nd;baseline_latency_bg.prob50nd;baseline_latency_bg.prob75nd];

plot_latency_bf_label = [repmat({'1_bf_prob25'},length(baseline_latency_bf.prob25nd),1);...
    repmat({'2_bf_prob50'},length(baseline_latency_bf.prob50nd),1);...
    repmat({'3_bf_prob75'},length(baseline_latency_bf.prob75nd),1)];

plot_latency_bg_label = [repmat({'4_bg_prob25'},length(baseline_latency_bg.prob25nd),1);...
    repmat({'5_bg_prob50'},length(baseline_latency_bg.prob50nd),1);...
    repmat({'6_bg_prob75'},length(baseline_latency_bg.prob75nd),1)];

% Get offset slope [100:400] post-outcome
slope_analysis_bf = get_slope_ramping_outcome(bf_data_CS,bf_datasheet_CS,plot_trial_types,params);
slope_analysis_bg = get_slope_ramping_outcome(striatum_data_CS,striatum_datasheet_CS,plot_trial_types,params);


%% Structure: organize data for figure
% Timing of peak >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% Basal forebrain ------------------------------------------------------
plot_peak_time_bf = [];
plot_peak_time_var_bf = [];
plot_peak_prob_label_bf = [];
plot_slope_bf = [];
plot_slope_bf_label = [];

plot_trial_types = {'uncert_delivered','uncert_omit'};

for trial_type_i = 1:length(plot_trial_types)
    plot_peak_time_bf = [plot_peak_time_bf; max_ramp_fr_bf.mean_averageSDF.(plot_trial_types{trial_type_i})];
    plot_peak_time_var_bf = [plot_peak_time_var_bf; max_ramp_fr_bf.var.(plot_trial_types{trial_type_i})];
    plot_peak_prob_label_bf = [plot_peak_prob_label_bf;...
        repmat({plot_trial_types{trial_type_i}},...
        length(max_ramp_fr_bf.mean_averageSDF.(plot_trial_types{trial_type_i})),1)];
end

% Basal ganglia ------------------------------------------------------
plot_peak_time_bg = [];
plot_peak_time_var_bg = [];
plot_peak_prob_label_bg = [];
plot_slope_bg = [];
plot_slope_bg_label = [];

for trial_type_i = 1:length(plot_trial_types)
    plot_peak_time_bg = [plot_peak_time_bg; max_ramp_fr_bg.mean_averageSDF.(plot_trial_types{trial_type_i})];
    plot_peak_time_var_bg = [plot_peak_time_var_bg; max_ramp_fr_bg.var.(plot_trial_types{trial_type_i})];
    
    plot_peak_prob_label_bg = [plot_peak_prob_label_bg;...
        repmat({plot_trial_types{trial_type_i}},...
        length(max_ramp_fr_bg.mean_averageSDF.(plot_trial_types{trial_type_i})),1)];
end

% Slope analyses >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
plot_trial_types = {'prob25nd','prob50nd','prob75nd'};

% Basal forebrain
for trial_type_i = 1:length(plot_trial_types)
    for neuron_i = 1:size(bf_data_CS,1)
           plot_slope_bf = [plot_slope_bf; nanmean(slope_analysis_bf.raw.(plot_trial_types{trial_type_i}){neuron_i}(:))];
           plot_slope_bf_label = [plot_slope_bf_label; {['1_bf_' int2str(trial_type_i) '_' plot_trial_types{trial_type_i} ]}];
    end
end

% Basal ganglia
for trial_type_i = 1:length(plot_trial_types) 
    for neuron_i = 1:size(bf_data_CS,1)
           plot_slope_bg = [plot_slope_bg; nanmean(slope_analysis_bg.raw.(plot_trial_types{trial_type_i}){neuron_i}(:))];    
           plot_slope_bg_label = [plot_slope_bg_label; {['2_bg_' int2str(trial_type_i) '_' plot_trial_types{trial_type_i} ]}];
    end
end

plot_peak_prob_label_bf = strcat('1_BF_', plot_peak_prob_label_bf);
plot_peak_prob_label_bg = strcat('2_BG_', plot_peak_prob_label_bg);


%% Figure: Generate bar plots

bar_width = 2;

clear figure_plot

figure_plot(1,1)=gramm('x',[plot_peak_prob_label_bf;plot_peak_prob_label_bg],...
'y',[plot_peak_time_bf; plot_peak_time_bg],'color',[plot_peak_prob_label_bf;plot_peak_prob_label_bg]);
figure_plot(1,1).stat_summary('geom',{'bar','errorbar'},'width',bar_width);
figure_plot(1,1).axe_property('YLim',[-75 75]);
figure_plot(1,1).set_names('y','Mean peak time (ms)');
figure_plot(1,1).no_legend;

figure_plot(1,2)=gramm('x',[plot_peak_prob_label_bf;plot_peak_prob_label_bg],...
'y',[plot_peak_time_var_bf; plot_peak_time_var_bg],...
'color',[plot_peak_prob_label_bf;plot_peak_prob_label_bg]);
figure_plot(1,2).stat_summary('geom',{'bar','errorbar'},'width',bar_width);
figure_plot(1,2).axe_property('YLim',[0 800]);
figure_plot(1,2).set_names('y','Var peak time (ms)');
figure_plot(1,2).no_legend;

figure_plot(1,3)=gramm('x',[plot_latency_bf_label;plot_latency_bg_label],...
'y',[plot_latency_bf; plot_latency_bg],...
'color',[plot_latency_bf_label;plot_latency_bg_label]);
figure_plot(1,3).stat_summary('geom',{'bar','errorbar'},'width',bar_width+2);
figure_plot(1,3).axe_property('YLim',[0 500]);
figure_plot(1,3).set_names('y','Suppression latency (ms)');
figure_plot(1,3).no_legend;

figure('Renderer', 'painters', 'Position', [100 100 900 300]);
figure_plot.draw;

%% Statistics: Export analysis table

anova_table = table();

% Area label (independent groups)
anova_table.area = [repmat({'Basal Forebrain'},size(bf_data_CS,1),1);...
    repmat({'Striatum'},size(striatum_data_CS,1),1)];

% Latency
anova_table.prob25_latency = [plot_latency_bf(endsWith(plot_latency_bf_label,'prob25'));...
    plot_latency_bg(endsWith(plot_latency_bg_label,'prob25'))];
anova_table.prob50_latency = [plot_latency_bf(endsWith(plot_latency_bf_label,'prob50'));...
    plot_latency_bg(endsWith(plot_latency_bg_label,'prob50'))];
anova_table.prob75_latency = [plot_latency_bf(endsWith(plot_latency_bf_label,'prob75'));...
    plot_latency_bg(endsWith(plot_latency_bg_label,'prob75'))];

% Peak times (mean)
anova_table.uncertain_omitted_peakMean= [plot_peak_time_bf(endsWith(plot_peak_prob_label_bf,'uncert_omit'));...
    plot_peak_time_bg(endsWith(plot_peak_prob_label_bg,'uncert_omit'))];
anova_table.uncertain_delivered_peakMean= [plot_peak_time_bf(endsWith(plot_peak_prob_label_bf,'uncert_delivered'));...
    plot_peak_time_bg(endsWith(plot_peak_prob_label_bg,'uncert_delivered'))];

% Peak times (var)
anova_table.uncertain_omitted_peakVar= [plot_peak_time_var_bf(endsWith(plot_peak_prob_label_bf,'uncert_omit'));...
    plot_peak_time_var_bg(endsWith(plot_peak_prob_label_bg,'uncert_omit'))];
anova_table.uncertain_delivered_peakVar= [plot_peak_time_var_bf(endsWith(plot_peak_prob_label_bf,'uncert_delivered'));...
    plot_peak_time_var_bg(endsWith(plot_peak_prob_label_bg,'uncert_delivered'))];

% Slope
anova_table.prob25_slope = [plot_slope_bf(endsWith(plot_slope_bf_label,'prob25nd'));...
    plot_slope_bg(endsWith(plot_slope_bg_label,'prob25nd'))];
anova_table.prob50_slope = [plot_slope_bf(endsWith(plot_slope_bf_label,'prob50nd'));...
    plot_slope_bg(endsWith(plot_slope_bg_label,'prob50nd'))];
anova_table.prob75_slope = [plot_slope_bf(endsWith(plot_slope_bf_label,'prob75nd'));...
    plot_slope_bg(endsWith(plot_slope_bg_label,'prob75nd'))];

writetable(anova_table,fullfile(dirs.root,'results','statistics','csv','bfstri_outcome_precision.csv'),'WriteRowNames',true)



%% Statistics:
% 
% stat_function_name = 'ranksum'; 
% stat_function = str2func(stat_function_name);
% 
% % Compare mean peak time for del x omit in basal forebrain
% stat_data_a = []; stat_data_b = [];
% stat_data_a = plot_peak_time_bf(strcmp(plot_peak_prob_label_bf,'uncert_delivered'));
% stat_data_b = plot_peak_time_bf(strcmp(plot_peak_prob_label_bf,'uncert_omit'));
% 
% [p,h,stats] = stat_function(stat_data_a, stat_data_b);
% 
% statistics_data = [];
% statistics_data.stat_function_name = stat_function_name;
% statistics_data.stat_data_a = stat_data_a;
% statistics_data.stat_data_b = stat_data_b;
% statistics_data.output = stats;
% statistics_data.p = p;
% 
% print_stats(statistics_data, [0.10 0.90]);
% 
% % Compare variance peak time for del x omit in basal forebrain
% stat_data_a = []; stat_data_b = [];
% stat_data_a = plot_peak_time_var_bf(strcmp(plot_peak_prob_label_bf,'uncert_delivered'));
% stat_data_b = plot_peak_time_var_bf(strcmp(plot_peak_prob_label_bf,'uncert_omit'));
% 
% [p,h,stats] = stat_function(stat_data_a, stat_data_b);
% 
% statistics_data = [];
% statistics_data.stat_function_name = stat_function_name;
% statistics_data.stat_data_a = stat_data_a;
% statistics_data.stat_data_b = stat_data_b;
% statistics_data.output = stats;
% statistics_data.p = p;
% 
% print_stats(statistics_data, [0.45 0.90]);
% 
% % Compare variance peak time for del x omit in basal forebrain
% stat_data_a = []; stat_data_b = [];
% stat_data_a = plot_slope_bf(strcmp(plot_peak_prob_label_bf,'uncert_delivered'));
% stat_data_b = plot_slope_bf(strcmp(plot_peak_prob_label_bf,'uncert_omit'));
% 
% [p,h,stats] = stat_function(stat_data_a, stat_data_b);
% 
% statistics_data = [];
% statistics_data.stat_function_name = stat_function_name;
% statistics_data.stat_data_a = stat_data_a;
% statistics_data.stat_data_b = stat_data_b;
% statistics_data.output = stats;
% statistics_data.p = p;
% 
% print_stats(statistics_data, [0.78 0.90]);
% 
% % Compare mean peak time for del x omit in basal forebrain
% stat_data_a = []; stat_data_b = [];
% stat_data_a = plot_peak_time_bg(strcmp(plot_peak_prob_label_bg,'uncert_delivered'));
% stat_data_b = plot_peak_time_bg(strcmp(plot_peak_prob_label_bg,'uncert_omit'));
% 
% [p,h,stats] = stat_function(stat_data_a, stat_data_b);
% 
% statistics_data = [];
% statistics_data.stat_function_name = stat_function_name;
% statistics_data.stat_data_a = stat_data_a;
% statistics_data.stat_data_b = stat_data_b;
% statistics_data.output = stats;
% statistics_data.p = p;
% 
% print_stats(statistics_data, [0.10 0.40]);
% 
% % Compare variance peak time for del x omit in basal forebrain
% stat_data_a = []; stat_data_b = [];
% stat_data_a = plot_peak_time_var_bg(strcmp(plot_peak_prob_label_bg,'uncert_delivered'));
% stat_data_b = plot_peak_time_var_bg(strcmp(plot_peak_prob_label_bg,'uncert_omit'));
% 
% [p,h,stats] = stat_function(stat_data_a, stat_data_b);
% 
% statistics_data = [];
% statistics_data.stat_function_name = stat_function_name;
% statistics_data.stat_data_a = stat_data_a;
% statistics_data.stat_data_b = stat_data_b;
% statistics_data.output = stats;
% statistics_data.p = p;
% 
% print_stats(statistics_data, [0.45 0.40]);
% 
% % Compare variance peak time for del x omit in basal forebrain
% stat_data_a = []; stat_data_b = [];
% stat_data_a = plot_slope_bg(strcmp(plot_peak_prob_label_bg,'uncert_delivered'));
% stat_data_b = plot_slope_bg(strcmp(plot_peak_prob_label_bg,'uncert_omit'));
% 
% [p,h,stats] = stat_function(stat_data_a, stat_data_b);
% 
% statistics_data = [];
% statistics_data.stat_function_name = stat_function_name;
% statistics_data.stat_data_a = stat_data_a;
% statistics_data.stat_data_b = stat_data_b;
% statistics_data.output = stats;
% statistics_data.p = p;
% 
% print_stats(statistics_data, [0.78 0.40]);
% 


%% Figure: plot heatmaps and peak
example_neuron_i = 16;

bf_color = [247 154 154; 244 107 107; 240 59 59; 230 18 18; 182 14 14]./255;
striatum_color = [221 153 204; 204 85 153; 170 51 102; 85 34 51; 34 17 17]./255;

figure('Renderer', 'painters', 'Position', [100 100 700 400]);

plot_trial_types = {'uncert_delivered','uncert_omit'};
params.plot.colormap = bf_colormap;
params.plot.xintercept = 1500;
get_maxFR_ramping_example(bf_data_CS,bf_datasheet_CS,plot_trial_types,example_neuron_i,params,[1, 3]);

params.plot.colormap = striatum_colormap;
params.plot.xintercept = 2500;
get_maxFR_ramping_example(striatum_data_CS,striatum_datasheet_CS,plot_trial_types,4,params, [2, 4]);

