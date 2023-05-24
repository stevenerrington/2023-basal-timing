function figure_plot = plot_population_traceoutcome(data_in,plot_trial_types,params)

% Input variables
xlim_input = params.plot.xlim; ylim_input = params.plot.ylim;
plot_time = [-5000:5000]; time_zero = abs(plot_time(1));
color_scheme = params.plot.colormap;

% Initialize plot data structures
plot_sdf_data = []; plot_spk_data = [];
plot_fano_data = []; plot_fano_label = []; 
plot_label = [];


%% Setup: get parameters
% Initialize plot data structures
plot_sdf_data = []; plot_fano_data = []; plot_fano_label = [];
plot_category_label = []; plot_group = []; plot_fano_window_data = [];
plot_fanogroup_label = []; plot_label_rwd = [];

% Timing parameters
plot_time = [-1000:2000]; time_zero = 5000; baseline_win = [-1000:3500];
epoch.postOutcome = [0 200]; epoch_zero.postOutcome = [1500 2500];


%% Extract: get relevant data
for neuron_i = 1:size(data_in,1)
    
    baseline_trials = [];
    % Get all inputted trials
    for trial_type_i = 1:length(plot_trial_types)
        baseline_trials = [baseline_trials, data_in.trials{neuron_i}.(plot_trial_types{trial_type_i})];
    end
    
    % Get baseline activity (mean and SD)
    bl_fr_mean = nanmean(nanmean(data_in.sdf{neuron_i}(baseline_trials,baseline_win+time_zero)));
    bl_fr_std = nanstd(nanmean(data_in.sdf{neuron_i}(baseline_trials,baseline_win+time_zero)));
    
    % Get alignment times for different outcome times between exps
    sdf_timewindow = plot_time + time_zero + 2500;
    fano_timewindow = plot_time + 2500;
    site_id = 2;

    % For each trial type
    for trial_type_i = 1:length(plot_trial_types)
        trial_type_label = plot_trial_types{trial_type_i};
        
        % Get the relevant trial indices
        trials_in = []; trials_in = data_in.trials{neuron_i}.(trial_type_label);
        n_trls = size(trials_in,2);
        
        % Get the normalized (Z-scored) SDF for these trials
        sdf_x = []; sdf_x = (nanmean(data_in.sdf{neuron_i}(trials_in,sdf_timewindow))-bl_fr_mean)./bl_fr_std;
        
        % If there aren't enough trials, then we will NaN out the SDF
        if any(isinf(sdf_x)) | length(sdf_x) == 1
            sdf_x = nan(1,length(plot_time));
        end
        
        % Add the information to the output array for plotting
        plot_sdf_data = [plot_sdf_data ; num2cell(sdf_x,2)]; % num2cell(sdf_x,2)];
        
        % Then we will look at the Fano factor
        % - as a continuous plot
        fano_continuous = find(ismember(data_in.fano(neuron_i).time,fano_timewindow));
        plot_fano_data = [plot_fano_data; {data_in.fano(neuron_i).raw.(trial_type_label)(fano_continuous)}];
        plot_fano_label = [plot_fano_label; {[int2str(trial_type_i) '_' (trial_type_label)]}];  
       
        switch trial_type_label
            case {'notimingcue_uncertain_nd' , 'notimingcue_uncertain_d'}; plot_group = [plot_group; {'1_no_timing_cue'}];
            case {'timingcue_uncertain_nd' , 'timingcue_uncertain_d'}; plot_group = [plot_group; {'2_timing_cue'}];
        end
        
        if endsWith( trial_type_label , 'nd' )
            plot_label_rwd = [ plot_label_rwd; {'1_omitted'} ];
        else
            plot_label_rwd = [ plot_label_rwd; {'2_delivered'} ];
        end
        
        
        % - and within a given window
        fano_window = get_fano_window(data_in.rasters{neuron_i},...
            data_in.trials{neuron_i},...
            epoch.postOutcome + epoch_zero.postOutcome(site_id));

        test_fano = mean(data_in.fano(neuron_i).raw.(trial_type_label)...
            (fano_continuous(1001+[epoch.postOutcome(1):epoch.postOutcome(2)])));
        
        plot_fano_window_data = [plot_fano_window_data; test_fano]; % fano_window.window.(trial_type_label)];
                

    end
end


%% Figure: Generate figure
% Generate plot using gramm
clear figure_plot

% Spike density function >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
figure_plot(1,1)=gramm('x',plot_time,'y',plot_sdf_data,'color',plot_label_rwd);
figure_plot(1,1).stat_summary();
figure_plot(1,1).axe_property('XLim',xlim_input,'YLim',ylim_input,'XTick',[],'XColor',[1 1 1]);
figure_plot(1,1).set_names('x','Time from Outcome (ms)','y','Firing rate (Z-score)');
figure_plot(1,1).set_color_options('map',color_scheme);
figure_plot(1,1).geom_vline('xintercept',0,'style','k-');
% figure_plot(1,1).no_legend;
figure_plot(1,1).facet_grid([],plot_group);
% 
% % Fano factor >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% figure_plot(2,1)=gramm('x',plot_time,'y',plot_fano_data,'color',plot_label_rwd);
% figure_plot(2,1).stat_summary();
% figure_plot(2,1).axe_property('XLim',xlim_input,'YLim',[0 2]);
% figure_plot(2,1).set_names('x','Time from Outcome (ms)','y','Fano Factor');
% figure_plot(2,1).set_color_options('map',color_scheme);
% figure_plot(2,1).geom_vline('xintercept',0,'style','k-');
% figure_plot(2,1).geom_hline('yintercept',1,'style','k--');
% figure_plot(2,1).no_legend;
% figure_plot(2,1).facet_grid([],plot_group,'column_labels',false,'row_labels',false);
% 
% % Bar Plot >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% figure_plot(3,1)=gramm('x',plot_group,'y',plot_fano_window_data,'color',plot_label_rwd);
% figure_plot(3,1).stat_summary('geom',{'bar','black_errorbar'},'width',0.2);
% figure_plot(3,1).geom_jitter('alpha',0.2,'dodge',0.5,'width',0.1);
% figure_plot(3,1).set_color_options('map',color_scheme);
% figure_plot(3,1).geom_hline('yintercept',1);
% figure_plot(3,1).axe_property('YLim',[0 2]);
% 
% 
% figure_plot_out = figure('Renderer', 'painters', 'Position', [100 100 600 600]);
% figure_plot.draw();
