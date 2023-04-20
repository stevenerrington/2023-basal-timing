

data_in = []; data_in = bf_data_CS(strcmp(bf_datasheet_CS.site,'nih'),:);
trial_type_list = {'prob50'};


peak_window = [1000:2000];
[max_ramp_fr, max_ramp_fr_collated] = get_maxFR_ramping(data_in,trial_type_list,peak_window);


figure_label = []; figure_data = [];
for trial_type_i = 1:length(trial_type_list)
    figure_label = [figure_label; repmat({[int2str(trial_type_i) '_' trial_type_list{trial_type_i}]},size(data_in,1),1)];
    figure_data = [figure_data ; max_ramp_fr.mean.(trial_type_list{trial_type_i})];
end

clear figure_plot
figure;
figure_plot(1,1)=gramm('x',figure_data,'color',figure_label);
figure_plot(1,1).stat_bin('edges',[1200:50:1700],'geom','line')
figure_plot(1,1).axe_property('XLim',[1200 1700]);
figure_plot(1,1).set_names('x','Time of max firing (ms)','y','Frequency');
figure_plot(1,1).geom_vline('xintercept',1500,'style','k-');
figure_plot.draw


peak_window = [2000:3000];
data_in = []; data_in = bf_data_CS(strcmp(bf_datasheet_CS.site,'wustl') & strcmp(bf_datasheet_CS.cluster_label,'Ramping'),:);
[max_ramp_fr, max_ramp_fr_collated] = get_maxFR_ramping(data_in,trial_type_list,peak_window);


figure_label = []; figure_data = [];
for trial_type_i = 1:length(trial_type_list)
    figure_label = [figure_label; repmat({[int2str(trial_type_i) '_' trial_type_list{trial_type_i}]},size(data_in,1),1)];
    figure_data = [figure_data ; max_ramp_fr.mean.(trial_type_list{trial_type_i})];
end

clear figure_plot
figure;
figure_plot(1,1)=gramm('x',figure_data,'color',figure_label);
figure_plot(1,1).stat_bin('edges',[2200:50:2700],'geom','line')
figure_plot(1,1).axe_property('XLim',[2200 2700]);
figure_plot(1,1).set_names('x','Time of max firing (ms)','y','Frequency');
figure_plot(1,1).geom_vline('xintercept',2500,'style','k-');
figure_plot.draw







%%
clear figure_plot

figure_label_conc = [repmat({'1_punish50%'},size(max_ramp_fr_collated.prob50_reward,1),1);repmat({'2_reward50%'},size(max_ramp_fr_collated.prob50_punish,1),1)];
figure_plot(1,2)=gramm('x',[max_ramp_fr_collated.prob50_punish;max_ramp_fr_collated.prob50_reward],'color',figure_label_conc);
figure_plot(1,2).stat_bin('edges',[1200:50:1700],'geom','line')
figure_plot(1,2).axe_property('XLim',[1200 1700]);
figure_plot(1,2).set_names('x','Time of max firing (ms)','y','Frequency');
figure_plot(1,2).geom_vline('xintercept',1500,'style','k-');
figure_plot.draw





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

