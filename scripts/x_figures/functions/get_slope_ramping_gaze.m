function slope_analysis = get_slope_ramping_gaze(data_in,datasheet_in,plot_trial_types,params)

[p_gaze_window]  = get_pgaze_window_trial(data_in, params);

for neuron_i = 1:size(data_in,1)
    fprintf('Analysing neuron %i of %i | %s    \n',neuron_i,size(data_in,1),data_in.filename{neuron_i});

    % For each defined trial type inputted
    for trial_type_i = 1:length(plot_trial_types)       
       trial_type = plot_trial_types{trial_type_i};
       
       switch trial_type
           case 'prob0'
               group_label = 'certain';
           case 'prob100'
               group_label = 'certain';   
           otherwise
               group_label = 'uncertain';
       end
       
       
        switch datasheet_in.site{neuron_i}
            case 'wustl'
                outcome_time = 2500;
            case 'nih'
                outcome_time = 1500;                
        end
        
        % Find the appropriate windows
        max_win = outcome_time + params.stats.peak_window;
        slope_win = outcome_time + [-500:0];
    
        timewin_eye = []; timewin_eye = [0:outcome_time]+find(params.eye.alignWin == 0);
        params.eye.window = [5 5];  params.plot.xintercept = outcome_time;
        
        trl_in = []; trl_in = data_in.trials{neuron_i}.(trial_type);
        p_gaze_trl = mean(p_gaze_window{neuron_i}(trl_in,timewin_eye),2);
        
        low_p_gaze_trl = []; low_p_gaze_trl = trl_in(find(p_gaze_trl < 0.5));
        high_p_gaze_trl = []; high_p_gaze_trl = trl_in(find(p_gaze_trl > 0.5));
        
        
        for gaze_p_type = {'low_p_gaze_trl','high_p_gaze_trl'}
            % Loop through the individual trials
            
            trial_type_label = gaze_p_type{1};
            
            switch gaze_p_type{1}
                case 'low_p_gaze_trl'
                    trials_in = []; trials_in = low_p_gaze_trl;
                    trial_type_label_out = [group_label,'_',trial_type_label];
                case 'high_p_gaze_trl'
                    trials_in = []; trials_in = high_p_gaze_trl;
                    trial_type_label_out = [group_label,'_',trial_type_label];
            end
            
            for trial_i = 1:length(trials_in)
                peak_fr = max(data_in.sdf{neuron_i}(trials_in(trial_i),max_win+5000));
                sdf_x = []; sdf_x = data_in.sdf{neuron_i}(trials_in(trial_i),:);
                
                % Bootstrap the extract polyfit values
                slope = []; poly_intersect = [];
                for bootstrap_i = 1:100
                    
                    sampletimes = []; sampletimes = sort(datasample(slope_win,250));
                    sdf_fr = []; sdf_fr = sdf_x(sampletimes+5000);
                    a = []; a = polyfit(sampletimes,sdf_fr,1);
                    
                    slope(bootstrap_i) = a(1);
                    poly_intersect(bootstrap_i) = a(2);
                end
                
                poly_fitted_trial_fr = (median(slope)*[-5000:5000])+median(poly_intersect);
                poly_fitted_trial_fr_norm = poly_fitted_trial_fr./peak_fr;
                poly_fitted_trial_fr_norm([-4999:0,params.plot.xintercept:5001]+5000)= 0;
                
                poly_fitted_trial_fr_norm_out(trial_i,:) = poly_fitted_trial_fr_norm;
                slope_out(trial_i,:) = slope;
            end
            
            slope_analysis.(trial_type_label_out).slope{neuron_i} = slope_out;
            
        end

    end
end


end