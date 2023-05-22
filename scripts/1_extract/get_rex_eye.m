function eye_pos_table = get_rex_eye(REX, params)
    eye_x_trial = []; eye_y_trial = []; location = [];
    
    eye_alignWin = params.eye.alignWin;
    
    for trial_i = 1:size(REX,2)
        try
            eye_x = []; eye_y = [];
            eye_x = REX(trial_i).Signals(1).Signal;
            eye_y = REX(trial_i).Signals(2).Signal;
            
            event_table = []; event_table = struct2table(REX(trial_i).Events);
            
            % 1100 is TARGONCD; 1050 is CUECD (TARGONCD is used for raster align)
            zero_time = double(event_table.Time(event_table.Code == 1100))-double(REX(trial_i).aStartTime);
            
            if length(zero_time) > 1
                zero_time = zero_time(zero_time > 0);
            end
            
            eye_x_trial(trial_i,:) = eye_x(zero_time+eye_alignWin);
            eye_y_trial(trial_i,:) = eye_y(zero_time+eye_alignWin);
            
            
        catch
            eye_x_trial(trial_i,:) = nan(1,length(eye_alignWin));
            eye_y_trial(trial_i,:) = nan(1,length(eye_alignWin));
        end
        
        % Get target location
        % lefttrials=5502; righttrials=4501; centertrials=3500;
        % targ location        
        if ~isempty(find(event_table.Code == 5502))
            location{trial_i,1} = 'left';
        elseif ~isempty(find(event_table.Code == 4501))
            location{trial_i,1} = 'right';
        elseif ~isempty(find(event_table.Code == 3500))
            location{trial_i,1} = 'center';
        else
            location{trial_i,1} = '?';
        end
        
    end
    
    eye_pos_table = table({eye_x_trial},{eye_y_trial}, {location},...
        'VariableNames',{'eye_x','eye_y','targ_location'});
    
end
