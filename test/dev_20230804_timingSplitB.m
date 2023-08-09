plot_trial_types = {'p25s_75l_long','p50s_50l_long','p75s_25l_long'};


for neuron_i = 1:size(bf_data_timingTask,1)
    
    
    figure('Renderer', 'painters', 'Position', [100 100 1200 800]); 
    subplot(2,3,1); hold on
    plot(-5000:5000,...
        nanmean(bf_data_timingTask.sdf{neuron_i}(bf_data_timingTask.trials{neuron_i}.p25s_75l_long,:)),'k')
    plot(-5000:5000,...
        nanmean(bf_data_timingTask.sdf{neuron_i}(bf_data_timingTask.trials{neuron_i}.p25s_75l_short,:)),'r')  
    xlim([0 2000]); vline(1500,'k--')
    title('p(r | 1500 ms) = 25%')
    
    subplot(2,3,2); hold on
    plot(-5000:5000,...
        nanmean(bf_data_timingTask.sdf{neuron_i}(bf_data_timingTask.trials{neuron_i}.p50s_50l_long,:)),'k')
    plot(-5000:5000,...
        nanmean(bf_data_timingTask.sdf{neuron_i}(bf_data_timingTask.trials{neuron_i}.p50s_50l_short,:)),'r')  
    xlim([0 2000]); vline(1500,'k--')    
    title('p(r | 1500 ms) = 50%')
    
    subplot(2,3,3); hold on
    plot(-5000:5000,...
        nanmean(bf_data_timingTask.sdf{neuron_i}(bf_data_timingTask.trials{neuron_i}.p75s_25l_long,:)),'k')
    plot(-5000:5000,...
        nanmean(bf_data_timingTask.sdf{neuron_i}(bf_data_timingTask.trials{neuron_i}.p75s_25l_short,:)),'r')  
    xlim([0 2000]); vline(1500,'k--')      
    title('p(r | 1500 ms) = 75%')
    
    
    subplot(2,3,4); hold on
    plot(-5000:5000,...
        nanmean(bf_data_timingTask.sdf{neuron_i}(bf_data_timingTask.trials{neuron_i}.p75s_25l_long,:)),'r')
    xlim([3000 5000]); vline(4500,'k--')

    subplot(2,3,5); hold on
    plot(-5000:5000,...
        nanmean(bf_data_timingTask.sdf{neuron_i}(bf_data_timingTask.trials{neuron_i}.p50s_50l_long,:)),'r')
    xlim([3000 5000]); vline(4500,'k--')
    
    subplot(2,3,6); hold on
    plot(-5000:5000,...
        nanmean(bf_data_timingTask.sdf{neuron_i}(bf_data_timingTask.trials{neuron_i}.p25s_75l_long,:)),'r')
    xlim([3000 5000]); vline(4500,'k--')
    
    sgtitle(['Neuron ' int2str(neuron_i)]) 
    pause
    close all

end

plot_trial_types = {'p25s_75l_short','p25s_75l_long'};
post_outcome_fac_neurons = [1 5 7 12 13 14 15 20]; % Basal forebrain SDF
params.plot.xlim = [0 2500];
params.plot.ylim = [-4 6];
[~,~,bf_timing1500_outcome] = plot_population_neuron(bf_data_timingTask(post_outcome_fac_neurons,:),plot_trial_types,params,1);

post_outcome_nonfac_neurons = [2 3 4 6 8 9 10 11 16 17 18 19 21 22]; % Basal forebrain SDF
params.plot.xlim = [0 2500];
params.plot.ylim = [-4 2];
[~,~,bf_timing1500_outcome] = plot_population_neuron(bf_data_timingTask(post_outcome_nonfac_neurons,:),plot_trial_types,params,1);


plot_trial_types = {'p25s_75l_long'};
params.plot.xlim = [3000 5000];
params.plot.ylim = [-4 6];
[~,~,bf_timing1500_outcome] = plot_population_neuron(bf_data_timingTask(post_outcome_fac_neurons,:),plot_trial_types,params,1);
[~,~,bf_timing1500_outcome] = plot_population_neuron(bf_data_timingTask(post_outcome_nonfac_neurons,:),plot_trial_types,params,1);


