peak_window = [1000:2000];


data_in = []; data_in = bf_data_punish;
trial_type_list = {'prob50_reward','prob50_punish'};

max_ramp_fr = struct();
max_ramp_fr.all = table();
max_ramp_fr.mean = table();
max_ramp_fr.var = table();


for trial_type_i = 1:length(trial_type_list)
    trial_type_in = trial_type_list{trial_type_i};
    max_ramp_fr_collated.(trial_type_in) = [];

    for neuron_i = 1:size(data_in,1)
        
        trials_in = []; trials_in = data_in.trials{neuron_i,1}.(trial_type_in);
        peak_time = [];
        
        for trial_i = 1:length(trials_in)
            trial_j = trials_in(trial_i);
            
            trial_sdf = []; trial_sdf = data_in.sdf{neuron_i,1}(trial_j,:);
            peak_fr = max( trial_sdf(1,5000+peak_window));
            
            if peak_fr > 0
                peak_time(trial_i,1) = find(trial_sdf == peak_fr,1)-5000;
            else
                peak_time(trial_i,1) = NaN;
            end
        end
        
        
        max_ramp_fr.all.(trial_type_in){neuron_i,1} = peak_time;
        max_ramp_fr.mean.(trial_type_in)(neuron_i,1) = nanmean(peak_time);
        max_ramp_fr.var.(trial_type_in)(neuron_i,1) = nanstd(peak_time);
        
        max_ramp_fr_collated.(trial_type_in) = [max_ramp_fr_collated.(trial_type_in);peak_time];
        
    end    
end





%%
clear figure_plot

figure_label = [repmat({'1_punish50%'},size(data_in,1),1);repmat({'2_reward50%'},size(data_in,1),1)];
figure_plot(1,1)=gramm('x',[max_ramp_fr.mean.prob50_punish;max_ramp_fr.mean.prob50_reward],'color',figure_label);
figure_plot(1,1).stat_bin('edges',[1200:50:1700],'geom','line')
figure_plot(1,1).axe_property('XLim',[1200 1700]);
figure_plot(1,1).set_names('x','Time of max firing (ms)','y','Frequency');
figure_plot(1,1).geom_vline('xintercept',1500,'style','k-');

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

