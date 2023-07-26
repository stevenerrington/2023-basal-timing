function [baseline_latency, baseline_latency_cdf] = get_suppression_latency(data_in, datasheet_in, plot_trial_types)

baseline_window = [-2000:-1500];

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
            baseline_latency.(plot_trial_types{trial_type_i})(neuron_i,1) = 50+find(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.(plot_trial_types{trial_type_i}),5001+outcome_time+[50:400]))<baseline_fr,1);
        catch
            baseline_latency.(plot_trial_types{trial_type_i})(neuron_i,1) = NaN;
        end
        
    end
end

baseline_latency_cdf.labels = [];

for trial_type_i = 1:size(plot_trial_types,2)
    baseline_latency_cdf.data.(plot_trial_types{trial_type_i}) =...
        getCDF(baseline_latency.(plot_trial_types{trial_type_i})...
        (~isnan(baseline_latency.(plot_trial_types{trial_type_i}))));
    baseline_latency_cdf.labels =...
        [baseline_latency_cdf.labels;...
        repmat(plot_trial_types(trial_type_i),...
        length(baseline_latency_cdf.data.(plot_trial_types{trial_type_i})),...
        1)];
end