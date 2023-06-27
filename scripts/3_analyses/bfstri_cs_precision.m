function bfstri_cs_precision(bf_data_CS, bf_datasheet_CS,...
    striatum_data_CS,striatum_datasheet_CS, params)

%% Extract: get precision timing analyses
params.stats.peak_window = [-250:250];
plot_trial_types = {'uncert_delivered','uncert_omit'};
[max_ramp_fr_bf] = get_maxFR_ramping_outcome(bf_data_CS,bf_datasheet_CS,plot_trial_types,params);
slope_analysis_bf = get_slope_ramping_outcome(bf_data_CS,bf_datasheet_CS,plot_trial_types,params);
[max_ramp_fr_bg] = get_maxFR_ramping_outcome(striatum_data_CS,striatum_datasheet_CS,plot_trial_types,params);
slope_analysis_bg = get_slope_ramping_outcome(striatum_data_CS,striatum_datasheet_CS,plot_trial_types,params);

%% Structure: organize data for figure
% Basal forebrain ------------------------------------------------------
plot_peak_time_bf = [];
plot_peak_time_var_bf = [];
plot_peak_prob_label_bf = [];
plot_slope_bf = [];

for trial_type_i = 1:length(plot_trial_types)
    plot_peak_time_bf = [plot_peak_time_bf; max_ramp_fr_bf.mean_averageSDF.(plot_trial_types{trial_type_i})];
    plot_peak_time_var_bf = [plot_peak_time_var_bf; max_ramp_fr_bf.var.(plot_trial_types{trial_type_i})];
    plot_peak_prob_label_bf = [plot_peak_prob_label_bf;...
        repmat({plot_trial_types{trial_type_i}},...
        length(max_ramp_fr_bf.mean_averageSDF.(plot_trial_types{trial_type_i})),1)];
    
    for neuron_i = 1:size(bf_data_CS,1)
           plot_slope_bf = [plot_slope_bf; nanmean(slope_analysis_bf.(plot_trial_types{trial_type_i}).slope{neuron_i}(:))];    
    end
end

% Basal ganglia ------------------------------------------------------
plot_peak_time_bg = [];
plot_peak_time_var_bg = [];
plot_peak_prob_label_bg = [];
plot_slope_bg = [];

for trial_type_i = 1:length(plot_trial_types)
    plot_peak_time_bg = [plot_peak_time_bg; max_ramp_fr_bg.mean_averageSDF.(plot_trial_types{trial_type_i})];
    plot_peak_time_var_bg = [plot_peak_time_var_bg; max_ramp_fr_bg.var.(plot_trial_types{trial_type_i})];
    
    plot_peak_prob_label_bg = [plot_peak_prob_label_bg;...
        repmat({plot_trial_types{trial_type_i}},...
        length(max_ramp_fr_bg.mean_averageSDF.(plot_trial_types{trial_type_i})),1)];
    
    for neuron_i = 1:size(striatum_data_CS,1)
        plot_slope_bg = [plot_slope_bg; nanmean(slope_analysis_bg.(plot_trial_types{trial_type_i}).slope{neuron_i}(:))];
    end
end

%% Figure: Generate bar plots

bar_width = 1;

clear figure_plot
figure_plot(1,1)=gramm('x',plot_peak_prob_label_bf,'y',plot_peak_time_bf,'color',plot_peak_prob_label_bf);
figure_plot(1,1).stat_summary('geom',{'bar','errorbar'},'width',bar_width);
figure_plot(1,1).axe_property('YLim',[-100 150]);
figure_plot(1,1).no_legend;

figure_plot(1,2)=gramm('x',plot_peak_prob_label_bf,'y',plot_peak_time_var_bf,'color',plot_peak_prob_label_bf);
figure_plot(1,2).stat_summary('geom',{'bar','errorbar'},'width',bar_width);
figure_plot(1,2).axe_property('YLim',[0 1000]);
figure_plot(1,2).no_legend;

figure_plot(1,3)=gramm('x',plot_peak_prob_label_bf,'y',plot_slope_bf,'color',plot_peak_prob_label_bf);
figure_plot(1,3).stat_summary('geom',{'bar','errorbar'},'width',bar_width);
figure_plot(1,3).axe_property('YLim',[-0.2 0]);
figure_plot(1,3).no_legend;

figure_plot(2,1)=gramm('x',plot_peak_prob_label_bg,'y',plot_peak_time_bg,'color',plot_peak_prob_label_bg);
figure_plot(2,1).stat_summary('geom',{'bar','errorbar'},'width',bar_width);
figure_plot(2,1).axe_property('YLim',[-100 150]);
figure_plot(2,1).no_legend;

figure_plot(2,2)=gramm('x',plot_peak_prob_label_bg,'y',plot_peak_time_var_bg,'color',plot_peak_prob_label_bg);
figure_plot(2,2).stat_summary('geom',{'bar','errorbar'},'width',bar_width);
figure_plot(2,2).axe_property('YLim',[0 1000]);
figure_plot(2,2).no_legend;

figure_plot(2,3)=gramm('x',plot_peak_prob_label_bg,'y',plot_slope_bg,'color',plot_peak_prob_label_bg);
figure_plot(2,3).stat_summary('geom',{'bar','errorbar'},'width',bar_width);
figure_plot(2,3).axe_property('YLim',[-0.2 0]);
figure_plot(2,3).no_legend;

figure('Renderer', 'painters', 'Position', [100 100 600 400]);
figure_plot.draw

%% Statistics:

stat_function_name = 'ranksum'; 
stat_function = str2func(stat_function_name);

% Compare mean peak time for del x omit in basal forebrain
stat_data_a = []; stat_data_b = [];
stat_data_a = plot_peak_time_bf(strcmp(plot_peak_prob_label_bf,'uncert_delivered'));
stat_data_b = plot_peak_time_bf(strcmp(plot_peak_prob_label_bf,'uncert_omit'));

[p,h,stats] = stat_function(stat_data_a, stat_data_b);

statistics_data = [];
statistics_data.stat_function_name = stat_function_name;
statistics_data.stat_data_a = stat_data_a;
statistics_data.stat_data_b = stat_data_b;
statistics_data.output = stats;
statistics_data.p = p;

print_stats(statistics_data, [0.10 0.90]);

% Compare variance peak time for del x omit in basal forebrain
stat_data_a = []; stat_data_b = [];
stat_data_a = plot_peak_time_var_bf(strcmp(plot_peak_prob_label_bf,'uncert_delivered'));
stat_data_b = plot_peak_time_var_bf(strcmp(plot_peak_prob_label_bf,'uncert_omit'));

[p,h,stats] = stat_function(stat_data_a, stat_data_b);

statistics_data = [];
statistics_data.stat_function_name = stat_function_name;
statistics_data.stat_data_a = stat_data_a;
statistics_data.stat_data_b = stat_data_b;
statistics_data.output = stats;
statistics_data.p = p;

print_stats(statistics_data, [0.45 0.90]);

% Compare variance peak time for del x omit in basal forebrain
stat_data_a = []; stat_data_b = [];
stat_data_a = plot_slope_bf(strcmp(plot_peak_prob_label_bf,'uncert_delivered'));
stat_data_b = plot_slope_bf(strcmp(plot_peak_prob_label_bf,'uncert_omit'));

[p,h,stats] = stat_function(stat_data_a, stat_data_b);

statistics_data = [];
statistics_data.stat_function_name = stat_function_name;
statistics_data.stat_data_a = stat_data_a;
statistics_data.stat_data_b = stat_data_b;
statistics_data.output = stats;
statistics_data.p = p;

print_stats(statistics_data, [0.78 0.90]);

% Compare mean peak time for del x omit in basal forebrain
stat_data_a = []; stat_data_b = [];
stat_data_a = plot_peak_time_bg(strcmp(plot_peak_prob_label_bg,'uncert_delivered'));
stat_data_b = plot_peak_time_bg(strcmp(plot_peak_prob_label_bg,'uncert_omit'));

[p,h,stats] = stat_function(stat_data_a, stat_data_b);

statistics_data = [];
statistics_data.stat_function_name = stat_function_name;
statistics_data.stat_data_a = stat_data_a;
statistics_data.stat_data_b = stat_data_b;
statistics_data.output = stats;
statistics_data.p = p;

print_stats(statistics_data, [0.10 0.40]);

% Compare variance peak time for del x omit in basal forebrain
stat_data_a = []; stat_data_b = [];
stat_data_a = plot_peak_time_var_bg(strcmp(plot_peak_prob_label_bg,'uncert_delivered'));
stat_data_b = plot_peak_time_var_bg(strcmp(plot_peak_prob_label_bg,'uncert_omit'));

[p,h,stats] = stat_function(stat_data_a, stat_data_b);

statistics_data = [];
statistics_data.stat_function_name = stat_function_name;
statistics_data.stat_data_a = stat_data_a;
statistics_data.stat_data_b = stat_data_b;
statistics_data.output = stats;
statistics_data.p = p;

print_stats(statistics_data, [0.45 0.40]);

% Compare variance peak time for del x omit in basal forebrain
stat_data_a = []; stat_data_b = [];
stat_data_a = plot_slope_bg(strcmp(plot_peak_prob_label_bg,'uncert_delivered'));
stat_data_b = plot_slope_bg(strcmp(plot_peak_prob_label_bg,'uncert_omit'));

[p,h,stats] = stat_function(stat_data_a, stat_data_b);

statistics_data = [];
statistics_data.stat_function_name = stat_function_name;
statistics_data.stat_data_a = stat_data_a;
statistics_data.stat_data_b = stat_data_b;
statistics_data.output = stats;
statistics_data.p = p;

print_stats(statistics_data, [0.78 0.40]);



%% Figure: plot heatmaps and peak
example_neuron_i = 16;

bf_color = [247 154 154; 244 107 107; 240 59 59; 230 18 18; 182 14 14]./255;
striatum_color = [221 153 204; 204 85 153; 170 51 102; 85 34 51; 34 17 17]./255;



figure('Renderer', 'painters', 'Position', [100 100 700 400]);

plot_trial_types = {'uncert_delivered','uncert_omit'};
params.plot.colormap = [1 0 0; 0 0 0];
params.plot.xintercept = 1500;
get_maxFR_ramping_example(bf_data_CS,bf_datasheet_CS,plot_trial_types,example_neuron_i,params,[1, 3]);

params.plot.xintercept = 2500;
get_maxFR_ramping_example(striatum_data_CS,striatum_datasheet_CS,plot_trial_types,4,params, [2, 4]);

%%



