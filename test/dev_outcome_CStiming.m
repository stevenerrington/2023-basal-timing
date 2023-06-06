
params.stats.peak_window = [-250:50];
% plot_trial_types = {'prob25d','prob25nd','prob50d','prob50nd','prob75d','prob75nd'};
plot_trial_types = {'uncert_delivered','uncert_omit'};
[max_ramp_fr_bf] = get_maxFR_ramping_outcome(bf_data_CS,bf_datasheet_CS,plot_trial_types,params);
% slope_analysis_bf = get_slope_ramping_outcome(bf_data_CS,bf_datasheet_CS,plot_trial_types,params);
[max_ramp_fr_bg] = get_maxFR_ramping_outcome(striatum_data_CS,striatum_datasheet_CS,plot_trial_types,params);

plot_peak_time_bf = [];
plot_peak_time_var_bf = [];
plot_peak_prob_label_bf = [];

for trial_type_i = 1:length(plot_trial_types)
    plot_peak_time_bf = [plot_peak_time_bf; max_ramp_fr_bf.mean_averageSDF.(plot_trial_types{trial_type_i})];
    plot_peak_time_var_bf = [plot_peak_time_var_bf; max_ramp_fr_bf.var.(plot_trial_types{trial_type_i})];
    plot_peak_prob_label_bf = [plot_peak_prob_label_bf;...
        repmat({plot_trial_types{trial_type_i}},...
        length(max_ramp_fr_bf.mean_averageSDF.(plot_trial_types{trial_type_i})),1)];
end


plot_peak_time_bg = [];
plot_peak_time_var_bg = [];
plot_peak_prob_label_bg = [];

for trial_type_i = 1:length(plot_trial_types)
    plot_peak_time_bg = [plot_peak_time_bg; max_ramp_fr_bg.mean_averageSDF.(plot_trial_types{trial_type_i})];
    plot_peak_time_var_bg = [plot_peak_time_var_bg; max_ramp_fr_bg.var.(plot_trial_types{trial_type_i})];
    
    plot_peak_prob_label_bg = [plot_peak_prob_label_bg;...
        repmat({plot_trial_types{trial_type_i}},...
        length(max_ramp_fr_bg.mean_averageSDF.(plot_trial_types{trial_type_i})),1)];
end


bar_width = 1;

clear figure_plot
figure_plot(1,1)=gramm('x',plot_peak_prob_label_bf,'y',plot_peak_time_bf,'color',plot_peak_prob_label_bf);
figure_plot(1,1).stat_summary('geom',{'bar','errorbar'},'width',bar_width);
figure_plot(1,1).axe_property('YLim',[-100 150]);

figure_plot(1,2)=gramm('x',plot_peak_prob_label_bg,'y',plot_peak_time_bg,'color',plot_peak_prob_label_bg);
figure_plot(1,2).stat_summary('geom',{'bar','errorbar'},'width',bar_width);
figure_plot(1,2).axe_property('YLim',[-100 150]);

figure_plot(1,3)=gramm('x',plot_peak_prob_label_bf,'y',plot_peak_time_var_bf,'color',plot_peak_prob_label_bf);
figure_plot(1,3).stat_summary('geom',{'bar','errorbar'},'width',bar_width);
figure_plot(1,3).axe_property('YLim',[0 1000]);

figure_plot(1,4)=gramm('x',plot_peak_prob_label_bg,'y',plot_peak_time_var_bg,'color',plot_peak_prob_label_bg);
figure_plot(1,4).stat_summary('geom',{'bar','errorbar'},'width',bar_width);
figure_plot(1,4).axe_property('YLim',[0 1000]);
figure('Renderer', 'painters', 'Position', [100 100 1200 200]);
figure_plot.draw

%%

example_neuron_i = 16;

plot_trial_types = {'uncert_delivered','uncert_omit'};
params.plot.colormap = [1 0 0; 0 0 0];
params.plot.xintercept = 1500;
get_maxFR_ramping_example(bf_data_CS,bf_datasheet_CS,plot_trial_types,example_neuron_i,params)

params.plot.xintercept = 2500;
get_maxFR_ramping_example(striatum_data_CS,striatum_datasheet_CS,plot_trial_types,4,params)

%%



