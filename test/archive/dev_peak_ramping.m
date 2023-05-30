

data_in = []; data_in = bf_data_CS(strcmp(bf_datasheet_CS.site,'nih'),:);
trial_type_list = {'prob50'};

peak_window = [1000:2000];
[max_ramp_fr, max_ramp_fr_collated] = get_maxFR_ramping(data_in,trial_type_list,peak_window);

figure_label_nih = []; figure_data_nih_mean = []; figure_data_nih_var = []; site_label_nih = [];
for trial_type_i = 1:length(trial_type_list)
    figure_label_nih = [figure_label_nih; repmat({[int2str(trial_type_i) '_' trial_type_list{trial_type_i}]},size(data_in,1),1)];
    figure_data_nih_mean = [figure_data_nih_mean ;max_ramp_fr.mean.(trial_type_list{trial_type_i})-1500];
    figure_data_nih_var = [figure_data_nih_var ;max_ramp_fr.var.(trial_type_list{trial_type_i})];
    site_label_nih = [site_label_nih; repmat({'1_1500'},size(data_in,1),1)];
end

peak_window = [2000:3000];
data_in = []; data_in = bf_data_CS(strcmp(bf_datasheet_CS.site,'wustl') & strcmp(bf_datasheet_CS.cluster_label,'Ramping'),:);
[max_ramp_fr, max_ramp_fr_collated] = get_maxFR_ramping(data_in,trial_type_list,peak_window);


figure_label_wustl = []; figure_data_wustl_mean = []; figure_data_wustl_var = []; site_label_wustl = [];
for trial_type_i = 1:length(trial_type_list)
    figure_label_wustl = [figure_label_wustl; repmat({[int2str(trial_type_i) '_' trial_type_list{trial_type_i}]},size(data_in,1),1)];
    figure_data_wustl_mean = [figure_data_wustl_mean ; max_ramp_fr.mean.(trial_type_list{trial_type_i})-2500];
    figure_data_wustl_var = [figure_data_wustl_var ;max_ramp_fr.var.(trial_type_list{trial_type_i})];
    site_label_wustl = [site_label_wustl; repmat({'2_2500'},size(data_in,1),1)];
end

clear figure_plot
figure_plot(1,1)=gramm('x',[figure_data_nih_mean; figure_data_wustl_mean],'color',[site_label_nih; site_label_wustl]);
figure_plot(1,1).stat_bin('edges',[-500:50:500],'geom','overlaid_bar','normalization','probability')
figure_plot(1,1).axe_property('XLim',[-500 500],'YLim',[0 0.5]);
figure_plot(1,1).set_names('x','Mean time of max firing (ms, relative to outcome)','y','Frequency');

figure_plot(1,2)=gramm('x',[figure_data_nih_var; figure_data_wustl_var],'color',[site_label_nih; site_label_wustl]);
figure_plot(1,2).stat_bin('edges',[0:25:300],'geom','overlaid_bar','normalization','probability')
figure_plot(1,2).axe_property('XLim',[0 300],'YLim',[0 0.5]);
figure_plot(1,2).set_names('x','Var in time of max firing (ms, relative to outcome)','y','Frequency');
figure('Renderer', 'painters', 'Position', [100 100 650 300]);
figure_plot.draw;

clear figure_plot
figure_plot(1,1)=gramm('x',[site_label_nih; site_label_wustl],'y',[figure_data_nih_mean; figure_data_wustl_mean],'color',[site_label_nih; site_label_wustl]);
figure_plot(1,1).stat_summary('geom',{'bar','black_errorbar'})
figure_plot(1,1).set_names('x','Mean time of max firing (ms, relative to outcome)','y','Frequency');
figure_plot(1,2)=gramm('x',[site_label_nih; site_label_wustl],'y',[figure_data_nih_var; figure_data_wustl_var],'color',[site_label_nih; site_label_wustl]);
figure_plot(1,2).stat_summary('geom',{'bar','black_errorbar'})
figure_plot(1,2).set_names('x','Var in time of max firing (ms, relative to outcome)','y','Frequency');

figure('Renderer', 'painters', 'Position', [100 100 650 300]);
figure_plot.draw;






%% %%
% clear figure_plot
% 
% figure_label_conc = [repmat({'1_punish50%'},size(max_ramp_fr_collated.prob50_reward,1),1);repmat({'2_reward50%'},size(max_ramp_fr_collated.prob50_punish,1),1)];
% figure_plot(1,2)=gramm('x',[max_ramp_fr_collated.prob50_punish;max_ramp_fr_collated.prob50_reward],'color',figure_label_conc);
% figure_plot(1,2).stat_bin('edges',[1200:50:1700],'geom','line')
% figure_plot(1,2).axe_property('XLim',[1200 1700]);
% figure_plot(1,2).set_names('x','Time of max firing (ms)','y','Frequency');
% figure_plot(1,2).geom_vline('xintercept',1500,'style','k-');
% figure_plot.draw
% 
% 



%%
% 
% 
% neuron_i = 3;

% figure;
% 
% trials_in = []; trials_in = bf_data_CS.trials{neuron_i,1}.prob50;
% 
% for trial_i = 1:length(trials_in)
%     trial_j = trials_in(trial_i);
%     
%     trial_sdf = []; trial_sdf = bf_data_CS.sdf{neuron_i,1}(trial_i,:);
%     plot(-5000:5000, trial_sdf,'k-')
%     xlim([-100 2000])
%     
%     
%     peak_fr = max( trial_sdf(1,5000+peak_window));
%     
%     if peak_fr > 0
%        peak_time(trial_i,1) = find(trial_sdf == peak_fr)-5000;
%     else
%        peak_time(trial_i,1) = NaN;     
%     end
%     
%     vline(peak_time(trial_i,1),'r')
%     
%     pause
% 
%     
% end
% 
% figure;
% histogram(peak_time-1500,10)

