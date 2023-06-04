function slope_analysis = get_slope_ramping_trace(data_in,plot_trial_types,params)


for neuron_i = 1:size(data_in,1)
    
    fprintf('Analysing neuron %i of %i | %s    \n',neuron_i,size(data_in,1),data_in.filename{neuron_i});
    
    % Find the appropriate windows
    max_win = params.plot.xintercept + params.stats.peak_window;
    slope_win = params.plot.xintercept + [0:500];
        
    % For each defined trial type inputted
    for trial_type_i = 1:length(plot_trial_types)
        trial_type_label = plot_trial_types{trial_type_i};
        trials_in = []; trials_in = data_in.trials{neuron_i}.(trial_type_label);
        n_trls = size(trials_in,2);
        poly_fitted_trial_fr_norm_out = [];
        slope_out  = [];
        peak_fr = [];

        % Loop through the individual trials
        for trial_i = 1:n_trls
            peak_fr = max(data_in.sdf{neuron_i}(trials_in(trial_i),max_win+5000));
            sdf_x = []; sdf_x = data_in.sdf{neuron_i}(trials_in(trial_i),:);
            
            % Bootstrap the extract polyfit values
            slope = []; poly_intersect = [];
            for bootstrap_i = 1:100
                
                sampletimes = []; sampletimes = sort(datasample(slope_win,250));
                sdf_fr = []; sdf_fr = sdf_x(sampletimes+5001);
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
        
        slope_analysis.(trial_type_label).poly_sdf{neuron_i} = poly_fitted_trial_fr_norm_out;
        slope_analysis.(trial_type_label).slope{neuron_i} = slope_out;
        slope_analysis.(trial_type_label).peak_fr{neuron_i} = peak_fr;
    end
end


end