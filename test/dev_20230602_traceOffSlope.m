

% > Trace task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
plot_trial_types = {'notimingcue_uncertain_nd',...
    'timingcue_uncertain_nd'};
params.plot.xintercept = 2500;
params.stats.peak_window = [-200:0];

slope_analysis_bf = get_slope_ramping_trace(bf_data_traceExp,plot_trial_types,params);
slope_analysis_striatum = get_slope_ramping_trace(striatum_data_traceExp,plot_trial_types,params);

slope = []; label_area = []; label_trial = [];

for neuron_i = 1:size(bf_data_traceExp,1)
    slope = [slope; nanmean(slope_analysis_bf.notimingcue_uncertain_nd.slope{neuron_i} (:))];
    label_area = [label_area; {'1_BF'}];
    label_trial = [label_trial; {'1_notimingcue_uncertain_nd'}];
end

for neuron_i = 1:size(bf_data_traceExp,1)
    slope = [slope; nanmean(slope_analysis_bf.timingcue_uncertain_nd.slope{neuron_i} (:))];
    label_area = [label_area; {'1_BF'}];
    label_trial = [label_trial; {'2_timingcue_uncertain_nd'}];
end

for neuron_i = 1:size(bf_data_traceExp,1)
    slope = [slope; nanmean(slope_analysis_striatum.notimingcue_uncertain_nd.slope{neuron_i} (:))];
    label_area = [label_area; {'2_BG'}];
    label_trial = [label_trial; {'1_notimingcue_uncertain_nd'}];
end

for neuron_i = 1:size(bf_data_traceExp,1)
    slope = [slope; nanmean(slope_analysis_striatum.timingcue_uncertain_nd.slope{neuron_i} (:))];
    label_area = [label_area; {'2_BG'}];
    label_trial = [label_trial; {'2_timingcue_uncertain_nd'}];
end

clear figure_plot
figure_plot(1,1)=gramm('x',label_trial,'y',slope,'color',label_trial);
figure_plot(1,1).stat_summary('geom',{'bar','errorbar'},'width',1,'dodge',1);
% figure_plot(1,1).axe_property('XLim',xlim_input,'YLim',[-2 15]);
% figure_plot(1,1).set_names('x','Time from CS Onset (ms)','y','Lick rate (licks/sec)');
figure_plot(1,1).no_legend
figure_plot(1,1).facet_grid([],label_area);
figure_plot(1,1).geom_hline('yintercept',0)
figure('Renderer', 'painters', 'Position', [100 100 400 300]);
figure_plot.draw();


