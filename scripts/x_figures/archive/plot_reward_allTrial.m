clear figure_plot

%% Basal forebrain | CS task
% Input variables
data_in = []; data_in = bf_data_punish;
trialtype_plot.reward =...
    {{'iti_short','iti_long'},...
    {'probAll_reward'},...
    {'prob0_reward','prob50_reward','prob100_reward'},...
    {'prob50_reward_d','prob50_reward_nd'}};

% Parameters
epoch_labels = {'prefix_iti','fix_to_CS','CS_to_outcome','outcome'};
epoch_xlim = {[-1500 -1000],[-1000 0],[0 1500-10],[1500+10 3000]};


ylim_input_example_SDF = [0 75]; ylim_input_fano = [0 2]; ylim_input_pop_SDF = [-3 6];
color_scheme_reward = [156 224 245; 56 193 236; 16 131 167]./255;

%% Reward
% Initialize plot data structures
example_neuron_i = 13;

plot_time = [-5000:5000];
time_zero = abs(plot_time(1));

for epoch_i = 1:length(epoch_labels)
    
    plot_trial_types = []; plot_trial_types = trialtype_plot.reward{epoch_i};
    plot_sdf_data = []; plot_spk_data = []; plot_label = [];
    plot_fano_data = []; plot_fano_label = [];

    % Example -----------------------------------------------------
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
        
        plot_fano_data = [plot_fano_data; {data_in.fano(example_neuron_i).smooth.(trial_type_label)}];
        plot_fano_label = [plot_fano_label; {[int2str(trial_type_i) '_' (trial_type_label)]}];
    end
    
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
        bl_fr_mean = nanmean(nanmean(data_in.sdf{neuron_i}(:,norm_window)));
        bl_fr_std = nanstd(nanmean(data_in.sdf{neuron_i}(:,norm_window)));
        
        % For each trial type
        for trial_type_i = 1:length(plot_trial_types)
            trial_type_label = plot_trial_types{trial_type_i};
            trials_in = []; trials_in = data_in.trials{neuron_i}.(trial_type_label);
            
            n_trls = size(trials_in,2);
            
            % Get the normalized SDF
            if n_trls < 2
                sdf_out = nan(1,10001); fano_x = nan(1,9951);
            else
                sdf_x = []; sdf_x = (nanmean(data_in.sdf{neuron_i}(trials_in,:))-bl_fr_mean)./bl_fr_std;
                fano_x = [];
                
                fano_x = data_in.fano(neuron_i).smooth.(trial_type_label);
                sdf_out = []; sdf_out = sdf_x;
            end
                plot_sdf_data_pop = [plot_sdf_data_pop ; num2cell(sdf_out,2)];
                plot_label_pop = [plot_label_pop; {[int2str(trial_type_i) '_' (trial_type_label)]}];
                
                plot_fano_data_pop = [plot_fano_data_pop; {fano_x}];
                plot_fano_label_pop = [plot_fano_label_pop; {[int2str(trial_type_i) '_' (trial_type_label)]}];
        end
    end
    
    %% Figure: plot figure
    % Example neuron data
    % Raster plot
    figure_plot(1,epoch_i)=gramm('x',plot_spk_data,'color',plot_label);
    figure_plot(1,epoch_i).geom_raster();
    figure_plot(1,epoch_i).no_legend;
    
    % Spike density function
    figure_plot(2,epoch_i)=gramm('x',plot_time,'y',plot_sdf_data,'color',plot_label);
    figure_plot(2,epoch_i).stat_summary();
    figure_plot(2,epoch_i).no_legend;
    
    % Fano factor
    figure_plot(3,epoch_i)=gramm('x',data_in.fano(example_neuron_i).time,'y',plot_fano_data,'color',plot_fano_label);
    figure_plot(3,epoch_i).geom_line();
    figure_plot(3,epoch_i).geom_hline('yintercept',1,'style','k--');
    figure_plot(3,epoch_i).no_legend;
    
    % Population data
    % Spike density function
    figure_plot(4,epoch_i)=gramm('x',plot_time,'y',plot_sdf_data_pop,'color',plot_label_pop);
    figure_plot(4,epoch_i).stat_summary();
    figure_plot(4,epoch_i).no_legend;
    
    % Fano factor
    figure_plot(5,epoch_i)=gramm('x',data_in.fano(example_neuron_i).time,'y',plot_fano_data_pop,'color',plot_fano_label_pop);
    figure_plot(5,epoch_i).stat_summary();
    figure_plot(5,epoch_i).geom_hline('yintercept',1,'style','k--');
    figure_plot(5,epoch_i).no_legend;
    
end

%% Figure properties

figure_plot(1,1).axe_property('XLim',epoch_xlim{1},'XTick',[],'XColor',[1 1 1],'YTick',[],'YColor',[1 1 1]);
figure_plot(2,1).axe_property('XLim',epoch_xlim{1},'YLim',ylim_input_example_SDF,'XTick',[],'XColor',[1 1 1]);
figure_plot(3,1).axe_property('XLim',epoch_xlim{1},'YLim',ylim_input_fano,'XTick',[],'XColor',[1 1 1]);
figure_plot(4,1).axe_property('XLim',epoch_xlim{1},'YLim',ylim_input_pop_SDF,'XTick',[],'XColor',[1 1 1]);
figure_plot(5,1).axe_property('XLim',epoch_xlim{1},'YLim',ylim_input_fano);

for epoch_i = 2:4
    figure_plot(1,epoch_i).axe_property('XLim',epoch_xlim{epoch_i},'XTick',[],'XColor',[1 1 1],'YTick',[],'YColor',[1 1 1]);
    figure_plot(2,epoch_i).axe_property('XLim',epoch_xlim{epoch_i},'YLim',ylim_input_example_SDF,'XTick',[],'XColor',[1 1 1],'YTick',[],'YColor',[1 1 1]);
    figure_plot(3,epoch_i).axe_property('XLim',epoch_xlim{epoch_i},'YLim',ylim_input_fano,'XTick',[],'XColor',[1 1 1],'YTick',[],'YColor',[1 1 1]);
    figure_plot(4,epoch_i).axe_property('XLim',epoch_xlim{epoch_i},'YLim',ylim_input_pop_SDF,'XTick',[],'XColor',[1 1 1],'YTick',[],'YColor',[1 1 1]);
    figure_plot(5,epoch_i).axe_property('XLim',epoch_xlim{epoch_i},'YLim',ylim_input_fano,'YTick',[],'YColor',[1 1 1]);
end

input_colormap = {[242 193 45; 179 89 195]./255, [0.5 0.5 0.5], color_scheme_reward, [13 105 134; 255 36 103]./255};

for epoch_i = 1:length(epoch_labels)
    figure_plot(:,epoch_i).set_color_options('map',input_colormap{epoch_i});
    figure_plot(:,epoch_i).set_names('x','','y','');
end

%% Layout
epoch_widths = [0.1 0.2 0.3 0.3];
epoch_widthref = [0.1 0.21 0.45 0.76];
plot_heights = [0.1 0.2 0.1 0.3 0.1];
plot_heightref = [0.89 0.675 0.55 0.22 0.1];

for i = 1:4
    for j = 1:5
        figure_plot(j,i).set_layout_options('Position',[epoch_widthref(i) plot_heightref(j) epoch_widths(i) plot_heights(j)],... %Set the position in the figure (as in standard 'Position' axe property)
            'legend',false,... % No need to display legend for side histograms
            'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
            'margin_width',[0.0 0.00],...
            'redraw',false);
    end
end

figure_plot(1,1).set_names('x','','y','Trials');
figure_plot(2,1).set_names('x','','y','Firing Rate (spk/sec)');
figure_plot(3,1).set_names('x','','y','Fano');
figure_plot(4,1).set_names('x','','y','Firing Rate (Z-score)');
figure_plot(5,1).set_names('x','','y','FF');

figure_plot(5,3).set_names('x','Time from CS (ms)');

figure('Renderer', 'painters', 'Position', [100 100 600 500]);
figure_plot.draw;