function [data_out] = get_fano_ramping(data_in, plot_trial_types, params)
trial_type_out = [];
fano_out = [];

fano_window = params.fano.timewindow + params.plot.xintercept;

for trial_type_i = 1:length(plot_trial_types)
    trial_type_label = plot_trial_types{trial_type_i};
    
    for neuron_i = 1:size(data_in,1)

        fano_continuous = [];
        fano_continuous = find(ismember(data_in.fano(neuron_i).time,fano_window));

        fano_out = ...
            [fano_out;...
            nanmean(data_in.fano(neuron_i).raw.(trial_type_label)(fano_continuous))];
        trial_type_out = [trial_type_out; {[int2str(trial_type_i) '_' trial_type_label]}];
    end
end

data_out.fano_out = fano_out;
data_out.trial_type_out = trial_type_out;

end