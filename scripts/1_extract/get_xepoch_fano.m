function fano_analysis = get_xepoch_fano(data_in, plot_trial_types, params)

%% Setup: define parameters
% > Define epochs
clear epoch
epoch.fixation = [0:200]; epoch.preCS = [-200:0]; epoch.postCS = [0:200];
epoch.midCS = [650:850]; epoch.preOutcome = [-200:0]; epoch.postOutcome = [0:200];

epoch_zero.fixation = [-1000]; epoch_zero.preCS = [0]; epoch_zero.postCS = [0];
epoch_zero.midCS = [0]; epoch_zero.preOutcome = [params.plot.xintercept]; epoch_zero.postOutcome = [params.plot.xintercept];

epoch_labels = fieldnames(epoch);
epoch_labels = epoch_labels(2:end); % Remove the fixation period

%% Extract: Get fanos from defined conditions
clear fano_analysis*
fano_analysis.raw = struct();
for neuron_i = 1:size(data_in,1)
        
    for epoch_i = 1:length(epoch_labels)
        
        fano_continuous = [];
        fano_continuous = find(ismember(data_in.fano(neuron_i).time,...
            epoch.(epoch_labels{epoch_i})+epoch_zero.(epoch_labels{epoch_i})));
        
        for trial_type_i = 1:length(plot_trial_types)
            fano_analysis.raw.(plot_trial_types{trial_type_i})(neuron_i,epoch_i) = nanmean(data_in.fano(neuron_i).raw.(plot_trial_types{trial_type_i})(fano_continuous));
        end
    end
    
end

%% Curate: Get average fano rates acroos conditions
fano_analysis.concatenate = [];
for trial_type_i = 1:length(plot_trial_types)
    fano_analysis.mean.(plot_trial_types{trial_type_i}) = nanmean(fano_analysis.raw.(plot_trial_types{trial_type_i}));
    fano_analysis.concatenate = [fano_analysis.concatenate; fano_analysis.mean.(plot_trial_types{trial_type_i})];
end

fano_analysis.epoch_labels = epoch_labels;

end
