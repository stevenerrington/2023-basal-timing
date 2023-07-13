function baseline_latency = get_suppression_latency(data_in, datasheet_in, plot_trial_types, params)

baseline_window = [-1000:0];

for neuron_i = 1:size(data_in,1)
    for trial_type_i = 1:size(plot_trial_types,2)
        
        switch datasheet_in.site{neuron_i}
            case 'wustl'
                outcome_time = 2500;
            case 'nih'
                outcome_time = 1500;
        end
        
        % Get return to baseline latency
        baseline_fr = mean(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.(plot_trial_types{trial_type_i}),baseline_window+5001)));
        try
            baseline_latency.(plot_trial_types{trial_type_i})(neuron_i,1) = find(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.(plot_trial_types{trial_type_i}),5001+outcome_time+[50:1000]))<baseline_fr,1);
        catch
            baseline_latency.(plot_trial_types{trial_type_i})(neuron_i,1) = NaN;
        end
        
    end
end