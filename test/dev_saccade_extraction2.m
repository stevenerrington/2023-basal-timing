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
data_in = []; data_in = bf_data_punish;

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


%%

trial_type_in = 'prob50';

sig_label = []; corr_val_p = []; corr_val_r = [];

for neuron_i = 1:size(data_in,1)
    
    % Data curation -------------------------------------------------------
    % Saccade raster
    sacc_raster_in = [];
    sacc_raster_in = sacc_raster_out{neuron_i,1}(data_in.trials{neuron_i}.(trial_type_in),:);
    
    sacc_times = [];
    [~,sacc_times] = find(sacc_raster_in == 1);
    sacc_times = sacc_times - find(params.eye.alignWin == 0);
    
    % Spike raster
    spk_raster_in = [];
    spk_raster_in = data_in.rasters{neuron_i}(data_in.trials{neuron_i}.(trial_type_in),:);
    
    spk_times = [];
    [~,spk_times] = find(spk_raster_in == 1);
    spk_times = spk_times - find([-5000:1:5000] == 0);

    % Spike density function
    
    timewin_sdf = []; timewin_sdf = [0:1500]+5001;
    sdf_raster_in = [];
    sdf_raster_in = data_in.sdf{neuron_i}(data_in.trials{neuron_i}.(trial_type_in),timewin_sdf);
        
    % Theta eye pos
    timewin_eye = []; timewin_eye = [0:1500]+find(params.eye.alignWin == 0);
    theta_eyepos_in = [];
    theta_eyepos_in = eyepos_theta_out{neuron_i,1}(data_in.trials{neuron_i}.(trial_type_in),timewin_eye);
            
    % Correlation -------------------------------------------------------
    sacc_bin_counts = []; spk_bin_counts = [];
    sacc_bin_counts = histcounts(sacc_times, -1000:100:2000);
    spk_bin_counts = histcounts(spk_times, -1000:100:2000);

    [corr_val_r(neuron_i,1),...
        corr_val_p(neuron_i,1)] = corr(sacc_bin_counts',spk_bin_counts');
    
    if corr_val_p(neuron_i,1) < 0.05
        sig_label{neuron_i,1} = '1_significant';
    else
        sig_label{neuron_i,1} = '2_non-significant';
    end
    
end

%% Figure: Histogram of correlation values

clear motor_corr_histogram
motor_corr_histogram(1,1) = gramm('x',corr_val_r,'color',sig_label);
motor_corr_histogram(1,1).stat_bin('edges',[-1:0.1:1],'geom','overlaid_bar');
motor_corr_histogram(1,1).axe_property('XLim',[-1 1],'YLim',[0 20]);
motor_corr_histogram(1,1).set_names('x','nSaccade x nSpike r-value');
figure;
motor_corr_histogram.draw
