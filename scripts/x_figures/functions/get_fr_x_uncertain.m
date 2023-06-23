function [fr_uncertainty] = get_fr_x_uncertain(data_in,datasheet_in,plot_trial_types,params,fig_flag,norm_method)

if nargin < 4
    fig_flag = 0;
end

if nargin < 5
    norm_method = 'zscore';
end

plot_time = [-5000:5000];
time_zero = abs(plot_time(1));
x_fit_data = 1:0.1:length(plot_trial_types);
analysis_window = params.eye.salience_window;

% Initialize plot data structures
plot_sdf_data = [];
plot_label = [];
fit_label = [];
y_fit_out = [];

for neuron_i = 1:size(data_in,1)
    
    if any(strcmp('site',datasheet_in.Properties.VariableNames))
        % Switch outcome time, depending on exp setup
        switch datasheet_in.site{neuron_i}
            case 'nih'
                outcome_time = 1500;
            case 'wustl'
                outcome_time = 2500;
        end
    else
        outcome_time = 2500;
    end

    all_prob_trials = [];
    for trial_type_i = 1:length(plot_trial_types)
        all_prob_trials = [all_prob_trials, data_in.trials{neuron_i}.(plot_trial_types{trial_type_i})];
    end

    % Normalization
    baseline_win = [-1500:3500];
    time_zero = abs(plot_time(1));
    bl_fr_mean = nanmean(nanmean(data_in.sdf{neuron_i}(all_prob_trials,baseline_win+time_zero)));
    bl_fr_std = nanstd(nanmean(data_in.sdf{neuron_i}(all_prob_trials,baseline_win+time_zero)));
    fr_max = max(nanmean(data_in.sdf{neuron_i}(all_prob_trials,analysis_window+outcome_time+time_zero)));
        
    %% Setup figure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Raster & SDF restructuring
    for trial_type_i = 1:length(plot_trial_types)
        trial_type_label = plot_trial_types{trial_type_i};
        trials_in = []; trials_in = data_in.trials{neuron_i}.(trial_type_label);
        n_trls = size(trials_in,2);
        
        switch norm_method
            case 'zscore'
                sdf_x = []; sdf_x = (nanmean(data_in.sdf{neuron_i}(trials_in,:))-bl_fr_mean)./bl_fr_std;
            case 'max'
                sdf_x = []; sdf_x = (nanmean(data_in.sdf{neuron_i}(trials_in,:))./fr_max);
        end

        
       fr_uncertainty(neuron_i, trial_type_i) = nanmean(sdf_x(:,analysis_window+outcome_time+time_zero),2);
    end
    

end

end
