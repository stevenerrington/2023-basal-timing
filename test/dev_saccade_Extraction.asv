data_in = []; data_in = bf_data_punish;
neuron_i = 16;


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


%% Detect saccades
trial_type_in = {'prob0','prob50','prob100','prob0_punish','prob50_punish','prob100_punish'};
data_sacc_times = []; data_sacc_labels =[];

for trial_type_i = 1:length(trial_type_in)
    
    % Get trial type label and indices
    trial_type_label = trial_type_in{trial_type_i};
    trials_in = []; trials_in = data_in.trials{neuron_i}.(trial_type_label);

    sacc_times_out = {}; sacc_labels_out = {};
    
    % For each trial, determine the time of saccades
    for trial_i = 1:length(trials_in)
        trial_j = trials_in(trial_i);
        
        % Get eye trace (X,Y)
        eyetrace = [];
        eyetrace = [data_in.eye{neuron_i}.eye_x{1,1}(trial_j,:)',...
            data_in.eye{neuron_i}.eye_y{1,1}(trial_j,:)'];
        
        % Run saccade extraction
        saccade_info = [];
        [saccade_info,~] = saccade_detector(eyetrace,params);
        
        % Get time of saccade execution
        sacc_times = []; sacc_times = saccade_info(:,2)-find(params.eye.alignWin == 0);
        
        sacc_times_out{trial_i,1} = sacc_times;
        sacc_labels_out{trial_i,1} = trial_type_label; 
    end
    
    % Concatenate across trials
    data_sacc_times = [data_sacc_times; sacc_times_out];
    data_sacc_labels = [data_sacc_labels; sacc_labels_out];
    
end



%% Raster saccades
clear figure_plot
figure_plot(1,1)=gramm('x',data_sacc_times,'color',data_sacc_labels);
figure_plot(1,1).geom_raster();
figure_plot(1,1).axe_property('XLim',[-1000 2000]);
figure_plot(1,1).set_names('x','Time from CS (ms)','y','Trial');

figure_plot(2,1)=gramm('x',data_sacc_times,'color',data_sacc_labels);
figure_plot(2,1).stat_bin('edges',[-1000:250:2000],'normalization','probability','geom','line');
figure_plot(2,1).axe_property('XLim',[-1000 2000]);
figure_plot(2,1).set_names('x','Time from CS (ms)','y','Trial');

figure_plot_out = figure('Renderer', 'painters', 'Position', [100 100 600 400]);
figure_plot.draw();



%%







figure; hold on
plot(params.eye.alignWin, data_in.eye{neuron_i}.eye_x{1,1}(trial_j,:),'color',[0.75 0 0 1])
plot(params.eye.alignWin, data_in.eye{neuron_i}.eye_y{1,1}(trial_j,:),'color',[0 0 0.75 1])
vline([0 1500], 'k')
vline(sacc_times, 'r')

%%
figure; 

subplot(2,1,1); hold on

for trial_i = 1:length(data_in.trials{neuron_i}.(trial_type_i))
    trial_j = data_in.trials{neuron_i}.(trial_type_i)(trial_i);

    
    
    
    
    
end


vline([0 1500],'k')