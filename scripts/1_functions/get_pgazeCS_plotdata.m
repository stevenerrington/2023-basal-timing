function [low_pgaze_prob, high_pgaze_prob] = get_pgazeCS_plotdata(data_in,datasheet_in,trial_type_list,params)

[p_gaze_window]  = get_pgaze_window_trial(data_in, params);

for neuron_i = 1:size(data_in,1)
    fprintf('Analysing neuron %i of %i |   \n', neuron_i, size(data_in,1))
    
    switch datasheet_in.site{neuron_i}
        case 'wustl'
            outcome_time = 2500;
        case 'nih'
            outcome_time = 1500;
    end
    
    timewin_eye = []; timewin_eye = [0:outcome_time]+find(params.eye.alignWin == 0);
    params.eye.window = [5 5];
    
    
    for trial_type_i = 1:length(trial_type_list)
        trial_type = trial_type_list{trial_type_i};
        trl_in = []; trl_in = data_in.trials{neuron_i}.(trial_type);
        p_gaze_trl = mean(p_gaze_window{neuron_i}(trl_in,timewin_eye),2);
        
        low_p_gaze_trl = []; low_p_gaze_trl = trl_in(find(p_gaze_trl < 0.5));
        high_p_gaze_trl = []; high_p_gaze_trl = trl_in(find(p_gaze_trl > 0.5));
        
        
        min_trl_n  = 3;
        plot_time = [outcome_time-1000:outcome_time]+find(params.eye.alignWin == 0);
        
        if length(low_p_gaze_trl) > min_trl_n & length(high_p_gaze_trl) > min_trl_n
            low_pgaze_prob{trial_type_i}(neuron_i,:) = nanmean(p_gaze_window{neuron_i}(low_p_gaze_trl,...
                plot_time));
            high_pgaze_prob{trial_type_i}(neuron_i,:) = nanmean(p_gaze_window{neuron_i}(high_p_gaze_trl,...
                plot_time));
            
        else
            low_pgaze_prob{trial_type_i}(neuron_i,:) = nan(1,length(plot_time));
            high_pgaze_prob{trial_type_i}(neuron_i,:) = nan(1,length(plot_time));
        end
        
    end
end

end