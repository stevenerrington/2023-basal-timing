%% Parameters
clear figure_plot motor_fr_behavior
trial_type_list = {'uncertain'};
min_trl_n = 3; % Minimum number of trials to include neuron
p_value_cutoff = 0.05; % P-value threshold for significance
params.eye.zero = find(params.eye.alignWin == 0);

analysis_window = [-1000:500];
roc_analysis_window = [-500:0];

%% Define input data
for dataset_in = {'striatum', 'bf'}
    
    switch dataset_in{1}
        case 'striatum'
            data_in = []; data_in = striatum_data_CS;
            datasheet_in = []; datasheet_in = striatum_datasheet_CS;
        case 'bf'
            data_in = []; data_in = bf_data_CS;
            datasheet_in = []; datasheet_in = bf_datasheet_CS;
    end

    % Initialize arrays
    plot_roc_label = []; ROC_out = []; count = 0;

    
    for trial_type_i = 1:length(trial_type_list)
        % Get trial type label
        trial_type = trial_type_list{trial_type_i};
        
        % Get high and low p(gaze) trials
        [p_gaze_window]  = get_pgaze_window_trial(data_in, params);
        
        % Initialize/clean out arrays for loop
        low_p_gaze_sdf_out = []; high_p_gaze_sdf_out = [];
        
        % For each neuron
        for neuron_i = 1:size(data_in,1)
            count = count + 1; % Increase the loop count
            
            % Determine outcome time, based on dataset
            switch datasheet_in.site{neuron_i}
                case 'nih'
                    outcome_time = 1500;
                case 'wustl'
                    outcome_time = 2500;
            end
            
            % Define time window to look for eye position
            timewin_eye = []; timewin_eye = find(params.eye.alignWin == 0)+[0:outcome_time];
            params.eye.window = [5 5]; params.plot.xintercept = outcome_time;
            
            % Get trial indices for trial type of interest
            trl_in = []; trl_in = data_in.trials{neuron_i}.(trial_type);
            % Get the average p(gaze | window) across these trials
            p_gaze_trl = mean(p_gaze_window{neuron_i}(trl_in,timewin_eye),2);
            
            % Find trials with low and high p(gaze)
            low_p_gaze_trl = []; low_p_gaze_trl = trl_in(find(p_gaze_trl < 0.5));
            high_p_gaze_trl = []; high_p_gaze_trl = trl_in(find(p_gaze_trl > 0.5));
            
            % Count the number of spikes within the analysis window
            low_p_gaze_spk = sum(data_in.rasters{neuron_i}(low_p_gaze_trl,5001+[roc_analysis_window+outcome_time]),2);
            high_p_gaze_spk = sum(data_in.rasters{neuron_i}(high_p_gaze_trl,5001+[roc_analysis_window+outcome_time]),2);
            
            % If there are enough trials in each condition, get the average SDF
            if length(low_p_gaze_trl) > min_trl_n & length(high_p_gaze_trl) > min_trl_n
                low_p_gaze_sdf = nanmean(data_in.sdf{neuron_i}(low_p_gaze_trl,5001+[analysis_window+outcome_time]));
                high_p_gaze_sdf = nanmean(data_in.sdf{neuron_i}(high_p_gaze_trl,5001+[analysis_window+outcome_time]));
                
                low_p_gaze_sdf_mean = mean(nanmean(data_in.sdf{neuron_i}(low_p_gaze_trl,5001+[roc_analysis_window+outcome_time])));
                high_p_gaze_sdf_mean = mean(nanmean(data_in.sdf{neuron_i}(high_p_gaze_trl,5001+[roc_analysis_window+outcome_time])));
                
%                 ROC_data = roc_curve(low_p_gaze_spk, high_p_gaze_spk, 0, 0);
                 ROC_data = roc_curve(low_p_gaze_sdf_mean, high_p_gaze_sdf_mean, 0, 0);
                ROC_out(count,1) = ROC_data.param.AROC;
                
            else
                % Otherwise, NaN it out
                low_p_gaze_sdf = nan(1,length(analysis_window));
                high_p_gaze_sdf = nan(1,length(analysis_window));
                
                ROC_out(count,1) = NaN;
            end
            
            % Output the gaze probability, normalized across all trial types
            low_p_gaze_sdf_out(neuron_i,:) = low_p_gaze_sdf./max([low_p_gaze_sdf,high_p_gaze_sdf]);
            high_p_gaze_sdf_out(neuron_i,:) = high_p_gaze_sdf./max([low_p_gaze_sdf,high_p_gaze_sdf]);
            
        end
        
        n_valid_obs.(dataset_in{1}) = sum(~isnan(ROC_out));
        
        %%
        motor_fr_behavior.(dataset_in{1}).plot_time = analysis_window;
        motor_fr_behavior.(dataset_in{1}).plot_sdf = [low_p_gaze_sdf_out;high_p_gaze_sdf_out];
        motor_fr_behavior.(dataset_in{1}).plot_roc = ROC_out;
        motor_fr_behavior.(dataset_in{1}).plot_label = [repmat({'1_low'},size(low_p_gaze_sdf_out,1),1); repmat({'2_high'},size(high_p_gaze_sdf_out,1),1)];
        motor_fr_behavior.(dataset_in{1}).plot_roc_label = repmat({'low x high'},size(ROC_out,1),1);
        
    end
end


%% Figure
clear figure_plot
% Ramping %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spike density function
figure_plot(1,1)=gramm('x',analysis_window,'y',num2cell(motor_fr_behavior.bf.plot_sdf,2),'color',motor_fr_behavior.bf.plot_label);
figure_plot(1,1).stat_summary();
figure_plot(1,1).axe_property('XLim',[plot_time(1) plot_time(end)],'YLim',[0 1]);
figure_plot(1,1).set_names('x','Time from CS Onset (ms)','y','Firing rate (Z-score)');
figure_plot(1,1).no_legend;

figure_plot(1,2)=gramm('x',analysis_window,'y',num2cell(motor_fr_behavior.striatum.plot_sdf,2),'color',motor_fr_behavior.striatum.plot_label);
figure_plot(1,2).stat_summary();
figure_plot(1,2).axe_property('XLim',[plot_time(1) plot_time(end)],'YLim',[0 1]);
figure_plot(1,2).set_names('x','Time from CS Onset (ms)','y','Firing rate (Z-score)');
figure_plot(1,2).no_legend;

clear roc_label roc_data roc_site
roc_label = [motor_fr_behavior.bf.plot_roc_label; motor_fr_behavior.striatum.plot_roc_label];
roc_data = [motor_fr_behavior.bf.plot_roc; motor_fr_behavior.striatum.plot_roc];
roc_site = [repmat({'1_BF'},length(motor_fr_behavior.bf.plot_roc_label),1);...
    repmat({'2_Striatum'},length(motor_fr_behavior.striatum.plot_roc_label),1)];

figure_plot(1,3)=gramm('x',roc_label,'y',roc_data,'color',roc_site);
figure_plot(1,3).stat_summary('geom',{'bar','errorbar'});
figure_plot(1,3).axe_property('YLim',[0.0 1.0]);
figure_plot(1,3).geom_hline('yintercept',0.5);
figure_plot(1,3).no_legend;

figure('Renderer', 'painters', 'Position', [100 100 600 200]);
figure_plot.draw;
% 
% stat_text = {['N = ', num2str(n_valid_obs(1))],['Min trl n = ', num2str(min_trl_n)]};
% stat_annotation = annotation('textbox',[.5 0.9 .2 .1],'String',stat_text,'FitBoxToText','on','EdgeColor','none');
% stat_annotation.FontSize = 8;
% %
% stat_text = {['N = ', num2str(n_valid_obs(2))],['Min trl n = ', num2str(min_trl_n)]};
% stat_annotation = annotation('textbox',[.5 0.4 .2 .1],'String',stat_text,'FitBoxToText','on','EdgeColor','none');
% stat_annotation.FontSize = 8;