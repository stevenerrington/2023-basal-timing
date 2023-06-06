function [p_gaze_window]  =...
    get_pgaze_window_trial(data_in, params)

x_window = params.eye.window(1); y_window = params.eye.window(2);
zero_time = find(params.eye.alignWin == 0);

clear p_gaze_window;

for neuron_i = 1:size(data_in,1)
    
    window_flag = [];
    window_flag = zeros(size(data_in,1),length(params.eye.alignWin));
    
    for trial_i = 1:size(data_in.eye{neuron_i}.targ_location{1},1)
        
        switch data_in.eye{neuron_i}.targ_location{1}{trial_i}
            case 'right'
                x_min = 10 + [-x_window/2 x_window/2];
            case 'left'
                x_min = -10 + [-x_window/2 x_window/2];
            case 'center'
                x_min = 0 + [-x_window/2 x_window/2];
        end
        
        y_min = 0 + [-y_window/2 y_window/2];
        
        
        in_window = [];
        in_window = find(data_in.eye{neuron_i}.eye_x{1,1}(trial_i,:) < x_min(2)...
            & data_in.eye{neuron_i}.eye_x{1,1}(trial_i,:) > x_min(1)...
            & data_in.eye{neuron_i}.eye_y{1,1}(trial_i,:) < y_min(2)...
            & data_in.eye{neuron_i}.eye_y{1,1}(trial_i,:) > y_min(1));
        in_window = in_window(in_window < length(params.eye.alignWin));
        
        window_flag(trial_i,in_window) = 1;
        
    end
    
    p_gaze_window{neuron_i} = window_flag;
end

