%% Define saccade parameters
% Note: the lambda is set high to account for blinks that appear
% curved/smooth pursuit like.
params.saccade.fill_missing_data = false;
params.saccade.smoothen = true;
params.saccade.sampling_rate = 1000;
params.saccade.fix_vel_thres = 30;
params.saccade.lambda = 20;
params.saccade.combine_intv_thres = 20;
params.saccade.saccade_dur_thres = 5;
params.saccade.saccade_amp_thres = 0.2;

%% Define input data
data_in = []; data_in = striatum_data_CS;
datasheet_in = []; datasheet_in = striatum_datasheet_CS;

%% Extract saccade raster
for neuron_i = 1:size(data_in,1)
    sacc_raster = zeros(size(data_in.rasters{neuron_i},1),length(params.eye.alignWin));
    filename = data_in.filename{neuron_i};
    fprintf('Extracting saccade information from neuron %i of %i   |  %s   \n',neuron_i,size(data_in,1), filename)
    
    theta_out = [];
    % For each trial, determine the time of saccades
    for trial_i = 1:size(data_in.rasters{neuron_i},1)
        
        % Get eye trace (X,Y)
        eyetrace = [];
        eyetrace = [data_in.eye{neuron_i}.eye_x{1,1}(trial_i,:)',...
            data_in.eye{neuron_i}.eye_y{1,1}(trial_i,:)'];
        
        [theta,~] = cart2pol(eyetrace(:,1), eyetrace(:,2));
        theta_out(trial_i,:) = theta';
        
        % Run saccade extraction
        saccade_info = [];
        [saccade_info,~] = saccade_detector(eyetrace,params);
        
        if ~isempty(saccade_info)
            % Get time of saccade execution
            sacc_times = [];
            sacc_times = saccade_info(:,2);
            
            sacc_raster(trial_i,sacc_times) = 1;
        end
    end
    
    sacc_raster_out{neuron_i,1} = sacc_raster;
    eyepos_theta_out{neuron_i,1} = theta_out;
end

%% Extract saccade x fr correlation
trial_type_list = {'uncertain'};
clear figure_plot

min_trl_n = 3;
p_value_cutoff = 0.05;
plot_roc_label = [];
test = [];
count = 0;

params.eye.window = [5 5]; params.plot.xintercept = 1500;
params.eye.zero = find(params.eye.alignWin == 0);

for i = 1:length(trial_type_list)
    trial_type = trial_type_list{i};
    
    sig_label = []; corr_val_p = []; corr_val_r = [];
    
    for neuron_i = 1:size(data_in,1)
        
        % Data curation -------------------------------------------------------
        % Saccade raster
        sacc_raster_in = [];
        sacc_raster_in = sacc_raster_out{neuron_i,1}(data_in.trials{neuron_i}.(trial_type),:);
        
        sacc_times = [];
        [~,sacc_times] = find(sacc_raster_in == 1);
        sacc_times = sacc_times - find(params.eye.alignWin == 0);
        
        % Spike raster
        spk_raster_in = [];
        spk_raster_in = data_in.rasters{neuron_i}(data_in.trials{neuron_i}.(trial_type),:);
        
        spk_times = [];
        [~,spk_times] = find(spk_raster_in == 1);
        spk_times = spk_times - find([-5000:1:5000] == 0);
        
        % Spike density function
        
        switch datasheet_in.site{neuron_i}
            case 'nih'
                outcome_time = 1500;
            case 'wustl'
                outcome_time = 2500;
        end
        
        timewin_sdf = []; timewin_sdf = [outcome_time-1000:outcome_time]+5001;
        sdf_raster_in = [];
        sdf_raster_in = data_in.sdf{neuron_i}(data_in.trials{neuron_i}.(trial_type),timewin_sdf);
        
        % Theta eye pos
        timewin_eye = []; timewin_eye = [outcome_time-1000:outcome_time]+find(params.eye.alignWin == 0);
        theta_eyepos_in = [];
        theta_eyepos_in = eyepos_theta_out{neuron_i,1}(data_in.trials{neuron_i}.(trial_type),timewin_eye);
        
        
        % Correlation -------------------------------------------------------
        sacc_bin_counts = []; spk_bin_counts = [];
        
        sacc_bin_counts = histcounts(sacc_times, outcome_time-1000:100:outcome_time);
        spk_bin_counts = histcounts(spk_times, outcome_time-1000:100:outcome_time);
        
        
        [corr_val_r(neuron_i,1),...
            corr_val_p(neuron_i,1)] = corr(sacc_bin_counts',spk_bin_counts');
        
        if corr_val_p(neuron_i,1) < p_value_cutoff
            sig_label{neuron_i,1} = '1_significant';
        else
            sig_label{neuron_i,1} = '2_non-significant';
        end
        
    end
    
    %% Figure: Get histogram of r-values, divided by significance
    figure_plot(i,1) = gramm('x',corr_val_r,'color',sig_label);
    figure_plot(i,1).stat_bin('edges',[-1:0.1:1],'geom','overlaid_bar');
    figure_plot(i,1).axe_property('XLim',[-1 1],'YLim',[0 20]);
    figure_plot(i,1).set_names('x','nSaccade x nSpike r-value');
    figure_plot(i,1).no_legend;
    
    %% Extract: Get high and low p(gaze) trials
    
    [p_gaze_window]  = get_pgaze_window_trial(data_in, params);
    low_p_gaze_sdf_out = []; high_p_gaze_sdf_out = [];

    for neuron_i = 1:size(data_in,1)
        count = count + 1;
        
        switch datasheet_in.site{neuron_i}
            case 'nih'
                outcome_time = 1500;
            case 'wustl'
                outcome_time = 2500;
        end
        
        timewin_eye = []; timewin_eye = [0:outcome_time]+find(params.eye.alignWin == 0);
        params.eye.window = [5 5];
        params.plot.xintercept = outcome_time;
        
        trl_in = []; trl_in = data_in.trials{neuron_i}.(trial_type);
        p_gaze_trl = mean(p_gaze_window{neuron_i}(trl_in,timewin_eye),2);
        
        low_p_gaze_trl = []; low_p_gaze_trl = trl_in(find(p_gaze_trl < 0.5));
        high_p_gaze_trl = []; high_p_gaze_trl = trl_in(find(p_gaze_trl > 0.5));

        low_p_gaze_spk = sum(data_in.rasters{neuron_i}(low_p_gaze_trl,5001+[outcome_time-1000:outcome_time]),2);
        high_p_gaze_spk = sum(data_in.rasters{neuron_i}(high_p_gaze_trl,5001+[outcome_time-1000:outcome_time]),2);
        
        sdf_time_window = [-1000:0];
        
        if length(low_p_gaze_trl) > min_trl_n & length(high_p_gaze_trl) > min_trl_n
            low_p_gaze_sdf = nanmean(data_in.sdf{neuron_i}(low_p_gaze_trl,5001+outcome_time+sdf_time_window));
            high_p_gaze_sdf = nanmean(data_in.sdf{neuron_i}(high_p_gaze_trl,5001+outcome_time+sdf_time_window));
            
            ROC_data = roc_curve(low_p_gaze_spk, high_p_gaze_spk, 0, 0);
            test(count,1) = ROC_data.param.AROC;
        else
            low_p_gaze_sdf = nan(1,length(sdf_time_window));
            high_p_gaze_sdf = nan(1,length(sdf_time_window));
            
            test(count,1) = NaN;
        end
        
        low_p_gaze_sdf_out(neuron_i,:) = low_p_gaze_sdf./max(low_p_gaze_sdf);
        high_p_gaze_sdf_out(neuron_i,:) = high_p_gaze_sdf./max(high_p_gaze_sdf);

    end
    
    n_valid_obs(i,1) = sum(~isnan(test));
    
    %%
    plot_time = sdf_time_window;
    plot_sdf = [low_p_gaze_sdf_out;high_p_gaze_sdf_out];
    plot_roc = [low_p_gaze_sdf_out;high_p_gaze_sdf_out];
    plot_label = [repmat({'1_low'},size(low_p_gaze_sdf_out,1),1); repmat({'2_high'},size(high_p_gaze_sdf_out,1),1)];
    plot_roc_label = repmat({'low x high'},size(low_p_gaze_sdf_out,1),1);
    
    % Ramping %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Spike density function
    figure_plot(i,2)=gramm('x',plot_time,'y',plot_sdf,'color',plot_label);
    figure_plot(i,2).stat_summary();
    figure_plot(i,2).axe_property('XLim',[plot_time(1) plot_time(end)],'YLim',[0 1]);
    figure_plot(i,2).set_names('x','Time from CS Onset (ms)','y','Firing rate (Z-score)');
    figure_plot(i,2).no_legend;
    
    figure_plot(i,3)=gramm('x',plot_roc_label,'y',test,'color',plot_roc_label);
    figure_plot(i,3).stat_summary('geom',{'bar','errorbar'});
    figure_plot(i,3).geom_jitter();
    figure_plot(i,3).axe_property('YLim',[0.0 1.0]);
    figure_plot(i,3).geom_hline('yintercept',0.5);
    figure_plot(i,3).no_legend;
    
    
end

figure('Renderer', 'painters', 'Position', [100 100 600 400]);
figure_plot.draw;

stat_text = {['N = ', num2str(n_valid_obs(1))],['Min trl n = ', num2str(min_trl_n)]};
stat_annotation = annotation('textbox',[.5 0.9 .2 .1],'String',stat_text,'FitBoxToText','on','EdgeColor','none');
stat_annotation.FontSize = 8;
% 
% stat_text = {['N = ', num2str(n_valid_obs(2))],['Min trl n = ', num2str(min_trl_n)]};
% stat_annotation = annotation('textbox',[.5 0.4 .2 .1],'String',stat_text,'FitBoxToText','on','EdgeColor','none');
% stat_annotation.FontSize = 8;