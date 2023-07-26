function expo_fit_data = get_slope_ramping_outcome(data_in,datasheet_in,plot_trial_types,params)


for neuron_i = 1:size(data_in,1)
    
    fprintf('Analysing neuron %i of %i | %s    \n',neuron_i,size(data_in,1),data_in.filename{neuron_i});
    
    if any(strcmp('site',datasheet_in.Properties.VariableNames))
        % Switch outcome time, depending on exp setup
        switch datasheet_in.site{neuron_i}
            case 'nih'
                params.plot.xintercept = 1500;
            case 'wustl'
                params.plot.xintercept = 2500;
        end
    else
        params.plot.xintercept = 2500;
    end
    
    % Find the appropriate windows
    max_win = params.plot.xintercept + params.stats.peak_window;
    slope_win = params.plot.xintercept + [100:600] + 5001;
    
    
    % For each defined trial type inputted
    for trial_type_i = 1:length(plot_trial_types)
        trial_type_label = plot_trial_types{trial_type_i};
        trials_in = []; trials_in = data_in.trials{neuron_i}.(trial_type_label);
        if length(trials_in) > 1
            sdf_x = []; sdf_x = nanmean(data_in.sdf{neuron_i}(trials_in,slope_win))./...
                max(nanmean(data_in.sdf{neuron_i}(trials_in,slope_win)));
        else
            sdf_x = nan(1,length(slope_win));
        end
        lambda = [];
        
        for bootstrap_i = 1:100
            bootstrap_times = []; bootstrap_times = sort(datasample(1:length([100:600]),100));
            sdf_x_bootstrap = [];
            sdf_x_bootstrap = sdf_x(:,bootstrap_times);
            
            % Convert X and Y into a table, which is the form fitnlm() likes the input data to be in.
            clear tbl mdl
            tbl = table(bootstrap_times', sdf_x_bootstrap');
            % Define the model as Y = a + exp(-b*x)
            % Note how this "x" of modelfun is related to big X and big Y.
            % x((:, 1) is actually X and x(:, 2) is actually Y - the first and second columns of the table.
            modelfun = @(b,x) b(1) * exp(-b(2)*x(:, 1)) + b(3);
            beta0 = [0, .06, 0]; % Guess values to start with.  Just make your best guess.
            % Now the next line is where the actual model computation is done.
            try
                mdl = lsqcurvefit(modelfun, beta0, tbl.Var1,tbl.Var2,[0 0 0],[3 0.06 3]);
%                 mdl = fitnlm(tbl, modelfun, beta0);
                % Now the model creation is done and the coefficients have been determined.
                % Export coefficient
%                 coefficients = mdl.Coefficients{:, 'Estimate'};
                lambda(bootstrap_i,1) = mdl(2);
            catch
                lambda(bootstrap_i,1) = NaN;
            end
        end
        
        expo_fit_data.raw.(trial_type_label){neuron_i} = lambda;
        expo_fit_data.average.(trial_type_label)(neuron_i,1) = nanmean(lambda);
        
    end
    
    
end