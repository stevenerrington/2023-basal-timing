function [p_gaze_window, mean_gaze_array]  =...
    get_pgaze_uncertainty(data_in, datasheet_in, trial_type_list, params)

x_window = params.eye.window(1); y_window = params.eye.window(2);
zero_time = find(params.eye.alignWin == 0);

clear p_gaze_window;

for neuron_i = 1:size(data_in,1)
    
    
    for trial_type_i = 1:length(trial_type_list)
        trial_type_label = trial_type_list{trial_type_i};
        trials_in = []; trials_in = data_in.trials{neuron_i}.(trial_type_label);
        
        window_flag = [];
        window_flag = zeros(length(trials_in),length(params.eye.alignWin));
        
        for trial_i = 1:length(trials_in)
            
            switch data_in.eye{neuron_i}.targ_location{1}{trials_in(trial_i)}
                case 'right'
                    x_min = 10 + [-x_window/2 x_window/2];
                case 'left'
                    x_min = -10 + [-x_window/2 x_window/2];
                case 'center'
                    x_min = 0 + [-x_window/2 x_window/2];
            end
            
            y_min = 0 + [-y_window/2 y_window/2];

            
            in_window = [];
            in_window = find(data_in.eye{neuron_i}.eye_x{1,1}(trials_in(trial_i),:) < x_min(2)...
                & data_in.eye{neuron_i}.eye_x{1,1}(trials_in(trial_i),:) > x_min(1)...
                & data_in.eye{neuron_i}.eye_y{1,1}(trials_in(trial_i),:) < y_min(2)...
                & data_in.eye{neuron_i}.eye_y{1,1}(trials_in(trial_i),:) > y_min(1));
            in_window = in_window(in_window < length(params.eye.alignWin));
            
            window_flag(trial_i,in_window) = 1;
            
        end
        
        p_gaze_window.(trial_type_label){neuron_i} = window_flag;
    end
end


for trial_type_i = 1:length(trial_type_list)
    trial_type_label = trial_type_list{trial_type_i};
    
    for neuron_i = 1:size(data_in,1)
        
        gaze_window = [];
        switch datasheet_in.site{neuron_i}
            case 'nih'
                gaze_window = zero_time+params.eye.salience_window+1500;
            case 'wustl'
                gaze_window = zero_time+params.eye.salience_window+2500;
        end
        
        mean_gaze_array(neuron_i,trial_type_i) =...
            nanmean(sum(p_gaze_window.(trial_type_label){neuron_i}(:,gaze_window),2) > 0);
        
    end
end

