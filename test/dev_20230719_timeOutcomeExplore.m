plot_trial_types = {'p50s_50l_short','p50s_50l_long'};
% plot_trial_types = {'fractal6105_1500','fractal6105_2500','fractal6105_3500'};

params.plot.colormap = cool(length(plot_trial_types));
outcome_times = [1500, 1499];
% % Population
% params.plot.xlim = [0 2500]; params.plot.ylim = [-2 5];
% [~,~,bf_population_timing_ramping] = plot_population_neuron(bf_data_timingTask,plot_trial_types,params,1);
% [~,~,striatum_population_timing_ramping] = plot_population_neuron(striatum_data_timingTask,plot_trial_types,params,1);

data_in = bf_data_timingTask;

plot_win = [-1000:500];

for neuron_i = 1:size(data_in,1)
    
    baseline_trials = [];
    for trial_type_i = 1:length(plot_trial_types)
        baseline_trials = [baseline_trials, data_in.trials{neuron_i}.(plot_trial_types{trial_type_i})];
    end
    
    baseline_mean_fr = mean(nanmean(data_in.sdf{neuron_i}...
    (baseline_trials,+5001+[-1000:4500])));
    baseline_std_fr = std(nanmean(data_in.sdf{neuron_i}...
    (baseline_trials,+5001+[-1000:4500])));
    
for trial_type_i = 1:length(plot_trial_types)
    if length(data_in.trials{neuron_i}.(plot_trial_types{trial_type_i})) > 3
    sdf_out.(plot_trial_types{trial_type_i}){neuron_i,1} = ...
        (nanmean(data_in.sdf{neuron_i}...
        (data_in.trials{neuron_i}.(plot_trial_types{trial_type_i}),...
        5001+outcome_times(trial_type_i)+plot_win))-baseline_mean_fr)./...
        baseline_std_fr;
    
    else
         sdf_out.(plot_trial_types{trial_type_i}){neuron_i,1} = NaN(1,length(plot_win));
    end
    
    
    sdf_label{neuron_i,trial_type_i} = [int2str(trial_type_i) '_' plot_trial_types{trial_type_i}];
end

end


clear figure_plot

xlim_input = [-1000 400]; ylim_input = [-2 4];

% Ramping %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spike density function

figure_plot(1,1)=gramm('x',plot_win,...
    'y',[sdf_out.p50s_50l_long; sdf_out.p50s_50l_short],...
    'color',[sdf_label(:,1);sdf_label(:,2)]);
figure_plot(1,1).stat_summary();
figure_plot(1,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
figure_plot(1,1).set_names('x','Time from outcome (ms)','y','Firing rate (Z-score)');
figure_plot(1,1).set_color_options('map',params.plot.colormap);

figure('Renderer', 'painters', 'Position', [100 100 500 600]);
figure_plot.draw