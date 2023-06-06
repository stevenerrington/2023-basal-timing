function [max_ramp_fr] = get_maxFR_ramping_outcome(data_in,datasheet_in,trial_type_list,params)

peak_window = params.stats.peak_window;

max_ramp_fr = struct();
max_ramp_fr.all = table();
max_ramp_fr.mean = table();
max_ramp_fr.var = table();


for neuron_i = 1:size(data_in,1)
    
    switch datasheet_in.site{neuron_i}
        case 'nih'
            params.plot.xintercept = 1500;
        case 'wustl'
            params.plot.xintercept = 2500;
    end
    
    for trial_type_i = 1:length(trial_type_list)
        trial_type_in = trial_type_list{trial_type_i};
        trials_in = []; trials_in = data_in.trials{neuron_i,1}.(trial_type_in);
        ntrls(trial_type_i) = length(trials_in);
    end
    
    if all(ntrls > 3)
        
        for trial_type_i = 1:length(trial_type_list)
            
            trial_type_in = trial_type_list{trial_type_i};
            trials_in = []; trials_in = data_in.trials{neuron_i,1}.(trial_type_in);
            peak_time = [];
            
            if length(trials_in) == 1
                averaged_sdf = []; averaged_sdf = data_in.sdf{neuron_i,1}(trials_in,:);
            else
                averaged_sdf = []; averaged_sdf = nanmean(data_in.sdf{neuron_i,1}(trials_in,:));
            end
            
            peak_fr = []; peak_fr = max( averaged_sdf(1,5000+params.plot.xintercept+peak_window));
            
            
            if peak_fr > 0
                peak_time_avSDF = find(averaged_sdf == peak_fr,1)-5000;
            else
                peak_time_avSDF = NaN;
            end
            
            for trial_i = 1:length(trials_in)
                trial_j = trials_in(trial_i);
                
                trial_sdf = []; trial_sdf = data_in.sdf{neuron_i,1}(trial_j,:);
                peak_fr = []; peak_fr = max( trial_sdf(1,5000+params.plot.xintercept+peak_window));
                
                if peak_fr > 0
                    peak_time(trial_i,1) = find(trial_sdf == peak_fr,1)-5000;
                else
                    peak_time(trial_i,1) = NaN;
                end
            end
            
            
            max_ramp_fr.all.(trial_type_in){neuron_i,1} = peak_time;
            max_ramp_fr.mean.(trial_type_in)(neuron_i,1) = nanmean(peak_time)-params.plot.xintercept;
            max_ramp_fr.mean_averageSDF.(trial_type_in)(neuron_i,1) = peak_time_avSDF-params.plot.xintercept;
            max_ramp_fr.var.(trial_type_in)(neuron_i,1) = nanstd(peak_time);
            
        end
        
    else
        for trial_type_i = 1:length(trial_type_list)
            trial_type_in = trial_type_list{trial_type_i};
            trials_in = []; trials_in = data_in.trials{neuron_i,1}.(trial_type_in);
            
            max_ramp_fr.all.(trial_type_in){neuron_i,1} = NaN;
            max_ramp_fr.mean.(trial_type_in)(neuron_i,1) = NaN;
            max_ramp_fr.mean_averageSDF.(trial_type_in)(neuron_i,1) = NaN;
            max_ramp_fr.var.(trial_type_in)(neuron_i,1) = NaN;
            
        end
        
    end
end

end