function [max_ramp_fr] = get_maxFRtime_ramping(data_in,trial_type_list,params)

peak_window = params.stats.peak_window;

max_ramp_fr = struct();
max_ramp_fr.all = table();
max_ramp_fr.mean = table();
max_ramp_fr.var = table();


for neuron_i = 1:size(data_in,1)

    for trial_type_i = 1:length(trial_type_list)

        trial_type_in = trial_type_list{trial_type_i};
        trials_in = []; trials_in = data_in.trials{neuron_i,1}.(trial_type_in);
        peak_time = [];
        
        for trial_i = 1:length(trials_in)
            trial_j = trials_in(trial_i);
            
            trial_sdf = []; trial_sdf = data_in.sdf{neuron_i,1}(trial_j,:);
            peak_fr = max( trial_sdf(1,5000+params.plot.xintercept+peak_window));
            
            if peak_fr > 0
                peak_time(trial_i,1) = find(trial_sdf == peak_fr,1)-5000;
            else
                peak_time(trial_i,1) = NaN;
            end
        end
        
        
        max_ramp_fr.all.(trial_type_in){neuron_i,1} = peak_time;
        max_ramp_fr.mean.(trial_type_in)(neuron_i,1) = nanmean(peak_time);
        max_ramp_fr.var.(trial_type_in)(neuron_i,1) = nanstd(peak_time);
                
    end
end

end