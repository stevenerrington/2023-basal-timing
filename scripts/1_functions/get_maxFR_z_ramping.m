function [data_out] = get_maxFR_z_ramping(data_in, plot_trial_types, params)
trial_type_out = [];
max_fr_out = [];

for trial_type_i = 1:length(plot_trial_types)
    trial_type_label = plot_trial_types{trial_type_i};
    
    label_idx = []; label_idx = find(endsWith(data_in.plot_label,trial_type_label));
    
    for neuron_i = 1:length(label_idx)
        max_fr_out = ...
            [max_fr_out;...
            nanmean(data_in.plot_sdf_data{label_idx(neuron_i)}...
            (1, params.stats.peak_window + params.plot.xintercept + 5001))];
        trial_type_out = [trial_type_out; data_in.plot_label(label_idx(neuron_i))];
    end
end

data_out.max_fr_out = max_fr_out;
data_out.trial_type_out = trial_type_out;

end