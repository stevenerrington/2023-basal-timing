%% Reward
% Initialize plot data structures
plot_sdf_data = []; plot_spk_data = []; plot_label = [];
plot_fano_data = []; plot_fano_label = [];

plot_time = [-5000:5000];
time_zero = abs(plot_time(1));

plot_trial_types = trialtype_plot.reward;

% Raster & SDF restructuring
for trial_type_i = 1:length(plot_trial_types)
    trial_type_label = plot_trial_types{trial_type_i};
    trials_in = []; trials_in = data_in.trials{example_neuron_i}.(trial_type_label);
    n_trls = size(trials_in,2);
    
    plot_sdf_data = [plot_sdf_data ; num2cell(data_in.sdf{example_neuron_i}(trials_in,:),2)];
    plot_label = [plot_label; repmat({[int2str(trial_type_i) '_' (trial_type_label)]},n_trls,1)];
    
    spkTimes = {};
    for trl_i = 1:n_trls
        spkTimes{trl_i,1} = find(data_in.rasters{example_neuron_i}(trials_in(trl_i),:) == 1) - time_zero;
    end
    
    plot_spk_data = [plot_spk_data; spkTimes];
    
    
    plot_fano_data = [plot_fano_data; {data_in.fano(example_neuron_i).raw.(trial_type_label)}];
    plot_fano_label = [plot_fano_label; {[int2str(trial_type_i) '_' (trial_type_label)]}];
end

% Example neuron %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CS Onset ----------------------------------------------------------------
% Raster plot
figure_plot(1,2)=gramm('x',plot_spk_data,'color',plot_label);
figure_plot(1,2).geom_raster();
figure_plot(1,2).axe_property('XLim',xlim_input_CS,'XTick',[],'YTick',[],'XColor',[1 1 1],'YColor',[1 1 1]);
figure_plot(1,2).set_names('x','','y','');
figure_plot(1,2).set_color_options('map',color_scheme_reward);
figure_plot(1,2).no_legend;

% Spike density function
figure_plot(2,2)=gramm('x',plot_time,'y',plot_sdf_data,'color',plot_label);
figure_plot(2,2).stat_summary();
figure_plot(2,2).axe_property('XLim',xlim_input_CS,'YLim',ylim_input,'XTick',[],'XColor',[1 1 1]);
figure_plot(2,2).set_names('x','','y','');
figure_plot(2,2).set_color_options('map',color_scheme_reward);
figure_plot(2,2).no_legend;

% Fano factor
figure_plot(3,2)=gramm('x',data_in.fano(example_neuron_i).time,'y',plot_fano_data,'color',plot_fano_label);
figure_plot(3,2).geom_line();
figure_plot(3,2).axe_property('XLim',xlim_input_CS,'YLim',[0 2],'XTick',[],'XColor',[1 1 1]);
figure_plot(3,2).set_names('x','','y','');
figure_plot(3,2).set_color_options('map',color_scheme_reward);
figure_plot(3,2).geom_hline('yintercept',1,'style','k--');
figure_plot(3,2).no_legend;

% Population -----------------------------------------------------
% Initialize arrays
plot_sdf_data_pop = []; plot_fano_data_pop = []; plot_fano_label_pop = [];
plot_category_label_pop = []; plot_label_pop = [];

% Define parameters
plot_time = [-5000:5000]; time_zero = abs(plot_time(1));
norm_window = 5000+[-1000:3000];

% For each neuron
for neuron_i = 1:size(data_in,1)
    
    baseline_trials = [];
    for trial_type_i = 1:length(plot_trial_types)
        trial_type_label = plot_trial_types{trial_type_i};        
        baseline_trials = [baseline_trials,data_in.trials{neuron_i}.(trial_type_label)];
    end
    
    % Get the mean and std to normalize
    bl_fr_mean = nanmean(nanmean(data_in.sdf{neuron_i}(baseline_trials,norm_window)));
    bl_fr_std = nanstd(nanmean(data_in.sdf{neuron_i}(baseline_trials,norm_window)));
    
    % For each trial type
    for trial_type_i = 1:length(plot_trial_types)
        trial_type_label = plot_trial_types{trial_type_i};
        trials_in = []; trials_in = data_in.trials{neuron_i}.(trial_type_label);
        
        n_trls = size(trials_in,2);
        
        % Get the normalized SDF
        sdf_x = []; sdf_x = (nanmean(data_in.sdf{neuron_i}(trials_in,:))-bl_fr_mean)./bl_fr_std;
        fano_x = [];
        
        fano_x = data_in.fano(neuron_i).raw.(trial_type_label);
        sdf_out = []; sdf_out = sdf_x;

        plot_sdf_data_pop = [plot_sdf_data_pop ; num2cell(sdf_out,2)];
        plot_label_pop = [plot_label_pop; {[int2str(trial_type_i) '_' (trial_type_label)]}];
        
        plot_fano_data_pop = [plot_fano_data_pop; {fano_x}];
        plot_fano_label_pop = [plot_fano_label_pop; {[int2str(trial_type_i) '_' (trial_type_label)]}];
        
        plot_category_label_pop = [plot_category_label_pop; {bf_datasheet_CS.cluster_label{neuron_i}}];
        
    end
end

% Population neuron %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CS Onset ----------------------------------------------------------------
% Spike density function
figure_plot(4,2)=gramm('x',plot_time,'y',plot_sdf_data_pop,'color',plot_label_pop);
figure_plot(4,2).stat_summary();
figure_plot(4,2).axe_property('XLim',xlim_input_CS,'YLim',[-3 5],'XTick',[],'XColor',[1 1 1]);
figure_plot(4,2).set_names('x','','y','');
figure_plot(4,2).set_color_options('map',color_scheme_reward);
figure_plot(4,2).no_legend;

% Fano factor
figure_plot(5,2)=gramm('x',data_in.fano(example_neuron_i).time,'y',plot_fano_data_pop,'color',plot_fano_label_pop);
figure_plot(5,2).stat_summary();
figure_plot(5,2).axe_property('XLim',xlim_input_CS,'YLim',[0 2]);
figure_plot(5,2).set_names('x','Time from CS Onset (ms)','y','');
figure_plot(5,2).set_color_options('map',color_scheme_reward);
figure_plot(5,2).geom_hline('yintercept',1,'style','k--');
figure_plot(5,2).no_legend;