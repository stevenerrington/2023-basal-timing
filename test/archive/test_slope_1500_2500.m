plot_trial_types = {'prob50'};
params.plot.xintercept = 1500;
slope_analysis_1500 = get_slope_ramping(bf_data_1500_ramping,plot_trial_types,params);
params.plot.xintercept = 2500;
slope_analysis_2500 = get_slope_ramping(bf_data_2500_ramping(1:22,:),plot_trial_types,params);

label = [];
slope = [];

for neuron_i = 1:length(slope_analysis_1500.prob50.slope)
    label = [label; {'1_1500'}];
    slope = [slope; nanmean(slope_analysis_1500.prob50.slope{neuron_i}(:))];
end

for neuron_i = 1:length(slope_analysis_2500.prob50.slope)
    label = [label; {'2_2500'}];
    slope = [slope; nanmean(slope_analysis_2500.prob50.slope{neuron_i}(:))];
end

clear figure_plot
figure_plot(1,1)=gramm('x',label,'y',slope,'color',label);
figure_plot(1,1).stat_summary('geom',{'bar','black_errorbar'})
% figure_plot(1,1).geom_jitter('alpha',0.1)

figure_plot(1,1).axe_property('YLim',[0 0.025]);
figure_plot(1,1).set_names('x','Outcome time (ms)','y','Slope');
figure_plot(1,1).no_legend;
figure('Renderer', 'painters', 'Position', [100 100 700 400])
figure_plot.draw

p = anova1(slope,label)
