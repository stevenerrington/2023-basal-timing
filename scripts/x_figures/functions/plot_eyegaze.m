
function plot_eyegaze(mean_gaze_array,params)

trial_type_list = fieldnames(mean_gaze_array);
data_in = []; label_in = [];
for trial_type_i = 1:length(trial_type_list)
    data_in = [data_in; num2cell(mean_gaze_array.(trial_type_list{trial_type_i}),2)];
    label_in = [label_in; repmat({trial_type_list{trial_type_i}},size(mean_gaze_array.(trial_type_list{trial_type_i}),1),1)];
end

clear figure_plot
figure_plot(1,1)=gramm('x',params.eye.alignWin,'y',data_in,'color',label_in);
figure_plot(1,1).stat_summary();
figure_plot(1,1).axe_property('XLim',[-1000 3000],'YLim',[0 1]);
figure_plot(1,1).set_names('x','Time from CS Onset (ms)','y','P(Gaze at CS)');
figure_plot(1,1).geom_vline('xintercept',0,'style','k-');
figure_plot(1,1).geom_vline('xintercept',params.plot.xintercept,'style','k-');

figure('Renderer', 'painters', 'Position', [100 100 600 500]);
figure_plot.draw;