%%
timewin_eye = []; timewin_eye = [0:1500]+find(params.eye.alignWin == 0);
params.eye.window = [5 5]; params.plot.xintercept = 1500;


% Basal Forebrain: NIH CS task
trial_type_list = {'prob0','prob50','prob100'};
params.plot.xintercept = 1500;
params.eye.salience_window = find(params.eye.alignWin == 0)+[0:1500];

data_in = []; data_in = bf_data_punish;
[p_gaze_window]  = get_pgaze_window_trial(data_in, params);

trial_type = 'prob50';
low_p_gaze_sdf_out = []; high_p_gaze_sdf_out = [];

for neuron_i = 1:size(data_in,1)
    
    trl_in = []; trl_in = data_in.trials{neuron_i}.(trial_type);
    
    p_gaze_trl = mean(p_gaze_window{neuron_i}(trl_in,timewin_eye),2);
    
    low_p_gaze_trl = []; low_p_gaze_trl = trl_in(find(p_gaze_trl < 0.5));
    high_p_gaze_trl = []; high_p_gaze_trl = trl_in(find(p_gaze_trl > 0.5));

    

    low_p_gaze_spk = sum(data_in.rasters{neuron_i}(low_p_gaze_trl,5001+[0:1500]),2);
    high_p_gaze_spk = sum(data_in.rasters{neuron_i}(high_p_gaze_trl,5001+[0:1500]),2);    
    

    if length(low_p_gaze_trl) > 3 & length(high_p_gaze_trl) > 3
        low_p_gaze_sdf = nanmean(data_in.sdf{neuron_i}(low_p_gaze_trl,:));
        high_p_gaze_sdf = nanmean(data_in.sdf{neuron_i}(high_p_gaze_trl,:));
        
        ROC_data = roc_curve(low_p_gaze_spk, high_p_gaze_spk, 0, 0);
        test(neuron_i,1) = ROC_data.param.AROC;
    else
        low_p_gaze_sdf = nan(1,length([-5000:5000]));
        high_p_gaze_sdf = nan(1,length([-5000:5000]));
               
        test(neuron_i,1) = NaN;
    end
    
    low_p_gaze_sdf_out(neuron_i,:) = low_p_gaze_sdf(5001+[0:1500])./max( low_p_gaze_sdf(5001+[0:1500]));
    high_p_gaze_sdf_out(neuron_i,:) = high_p_gaze_sdf(5001+[0:1500])./max(high_p_gaze_sdf(5001+[0:1500]));
    
    
end


%%
plot_time = [0:1500];
plot_sdf = [low_p_gaze_sdf_out;high_p_gaze_sdf_out];
plot_roc = [low_p_gaze_sdf_out;high_p_gaze_sdf_out];
plot_label = [repmat({'1_low'},size(low_p_gaze_sdf_out,1),1); repmat({'2_high'},size(high_p_gaze_sdf_out,1),1)];
plot_roc_label = repmat({'low x high'},size(low_p_gaze_sdf_out,1),1);

clear figure_plot
% Ramping %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spike density function
figure_plot(1,1)=gramm('x',plot_time,'y',plot_sdf,'color',plot_label);
figure_plot(1,1).stat_summary();
figure_plot(1,1).axe_property('XLim',[0 1500],'YLim',[0.3 1]);
figure_plot(1,1).set_names('x','Time from CS Onset (ms)','y','Firing rate (Z-score)');
figure_plot(1,1).no_legend;

figure_plot(1,2)=gramm('x',plot_roc_label,'y',test,'color',plot_roc_label);
figure_plot(1,2).stat_summary('geom',{'bar','errorbar'});
figure_plot(1,2).geom_jitter();
figure_plot(1,2).axe_property('YLim',[0.3 1]);
figure_plot(1,2).geom_hline('yintercept',0.5);
figure_plot(1,2);

figure_plot.draw
