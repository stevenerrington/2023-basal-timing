function eye_pos_table = get_eye_CS(PDS, params)
    eye_x_trial = []; eye_y_trial = []; eye_pupil_trial = []; location = [];
    
    
    eye_alignWin = params.eye.alignWin;
    
    for trial_i = 1:size(PDS.goodtrial,2)
        try
            eye_x = []; eye_y = []; eye_pupil = [];
            
            eye_x = PDS.onlineEye{trial_i}(:,1)';
            eye_y = PDS.onlineEye{trial_i}(:,2)';
            eye_pupil = PDS.onlineEye{trial_i}(:,3)';
            
            
            %% UP TO HERE>>>>>>>>
            rel_time = PDS.onlineEye{trial_i}(:,4)-PDS(1).trialstarttime(trial_i);

            interpolate_eye_x = []; interpolate_eye_y = []; interpolate_eye_pupil = []; interpolate_time =[];
            interpolate_time = [0: 0.001  : rel_time(end)];
            interpolate_eye_x = interp1(  rel_time , PDS.onlineEye{trial_i}(:,1) , interpolate_time  );
            interpolate_eye_y = interp1(  rel_time , PDS.onlineEye{trial_i}(:,2) , interpolate_time  );
            interpolate_eye_pupil = interp1(  rel_time , PDS.onlineEye{trial_i}(:,3) , interpolate_time  );


            
            zero_time = round((PDS(1).timetargeton(trial_i)*1000));
            
            
            eye_x_trial(trial_i,:) = interpolate_eye_x(zero_time+eye_alignWin);
            eye_y_trial(trial_i,:) = interpolate_eye_y(zero_time+eye_alignWin);
            eye_pupil_trial(trial_i,:) = interpolate_eye_pupil(zero_time+eye_alignWin);
            
            
        catch
            eye_x_trial(trial_i,:) = nan(1,length(eye_alignWin));
            eye_y_trial(trial_i,:) = nan(1,length(eye_alignWin));
            eye_pupil_trial(trial_i,:) = nan(1,length(eye_alignWin));
        end
        
        % Get target location
        % lefttrials=5502; righttrials=4501; centertrials=3500;
        % targ location        
        if PDS.targAngle(trial_i) == 180
            location{trial_i,1} = 'left';
        elseif PDS.targAngle(trial_i) == 0
            location{trial_i,1} = 'right';
        elseif PDS.targAngle(trial_i) == -1
            location{trial_i,1} = 'center';
        else
            location{trial_i,1} = '?';
        end
        
    end
    
    eye_pos_table = table({eye_x_trial},{eye_y_trial},{eye_pupil_trial},{location},...
        'VariableNames',{'eye_x','eye_y','eye_pupil','targ_location'});
    
end
