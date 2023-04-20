function plot_eyegaze_dev(mean_gaze_array,time_gaze_window,params)



trial_type_list = fieldnames(mean_gaze_array);
data_in = []; label_in = []; mean_gaze_window = [];
for trial_type_i = 1:length(trial_type_list)
    data_in = [data_in; num2cell(mean_gaze_array.(trial_type_list{trial_type_i}),2)];
    label_in = [label_in; repmat({trial_type_list{trial_type_i}},size(mean_gaze_array.(trial_type_list{trial_type_i}),1),1)];
    mean_gaze_window = [mean_gaze_window; nanmean(mean_gaze_array.(trial_type_list{trial_type_i})(:,params.eye.salience_window),2)];
end


for trial_type_i = 1:length(trial_type_list)
    time_data_in = []; time_data_in = time_gaze_window.(trial_type_list{trial_type_i});
    
    time_gaze_array = [];
    for neuron_i = 1:length(time_data_in)
        time_gaze_array =...
            [time_gaze_array; nanmean(time_gaze_window.(trial_type_list{trial_type_i}){neuron_i})];
    end
    
    time_gaze_rocData.(trial_type_list{trial_type_i}) = time_gaze_array;
end

roc_data = [];
for trial_type_i = 1:length(trial_type_list)
    for trial_type_j = 1:length(trial_type_list)
        if trial_type_i ~= trial_type_j && trial_type_j > trial_type_i
            comp_label = [trial_type_list{trial_type_i} '_x_' trial_type_list{trial_type_j}];
            
            roc_data.(comp_label) =...
                roc_curve(time_gaze_rocData.(trial_type_list{trial_type_i}),...
                time_gaze_rocData.(trial_type_list{trial_type_j}), 0, 0);
        end
    end
end

comp_labels = [];
comp_labels = fieldnames(roc_data);
roc_data.plot.data = []; roc_data.plot.label = [];
for comp_labels_i = 1:length(comp_labels)
    roc_data.plot.data = [roc_data.plot.data; roc_data.(comp_labels{comp_labels_i}).param.AROC];
    roc_data.plot.label = [roc_data.plot.label; {[int2str(comp_labels_i) '_' comp_labels{comp_labels_i}]}];
end


clear figure_plot
figure_plot(1,1)=gramm('x',params.eye.alignWin,'y',data_in,'color',label_in);
figure_plot(1,1).stat_summary();
figure_plot(1,1).axe_property('XLim',[-1000 3000],'YLim',[0 1]);
figure_plot(1,1).set_names('x','Time from CS Onset (ms)','y','P(Gaze at CS)');
figure_plot(1,1).geom_vline('xintercept',0,'style','k-');
figure_plot(1,1).geom_vline('xintercept',params.plot.xintercept,'style','k-');

figure_plot(1,2)=gramm('x',label_in,'y',mean_gaze_window,'color',label_in);
figure_plot(1,2).geom_jitter('alpha',0.2);
figure_plot(1,2).stat_summary('geom',{'point','black_errorbar','line'});
figure_plot(1,2).axe_property('YLim',[0 1]);
figure_plot(1,2).set_names('x','Condition','y','P(Gaze at CS)');

figure_plot(1,3)=gramm('x',roc_data.plot.label,...
    'y',roc_data.plot.data,...
    'color',roc_data.plot.label);
figure_plot(1,3).stat_summary('geom',{'bar'},'width',1);
figure_plot(1,3).axe_property('YLim',[0 1]);
figure_plot(1,3).set_names('x','Condition','y','AUROC');
figure_plot(1,3).geom_hline('yintercept',0.5);

figure('Renderer', 'painters', 'Position', [100 100 1200 350]);
figure_plot.draw;