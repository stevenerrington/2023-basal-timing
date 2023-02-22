% Input variables
data_in = []; data_in = bf_data_timingTask;
plot_trial_types = {'fractal6105_1500','fractal6105_2500','fractal6105_3500'};

% Initialize plot data structures
plot_sdf_data_cs = []; plot_fano_data_cs = []; plot_fano_label = []; plot_category_label = [];
plot_label = []; plot_sdf_data_outcome = []; plot_fano_data_outcome = [];

% Get time windows
plot_time = [-5000:5000]; time_zero = abs(plot_time(1));
baseline_win = [-500:200];
outcome_win = [-1000:100];
epoch.outcomeTime = [1500,2500,3500];

% Define figure properties
color_scheme = cool(5); color_scheme = color_scheme([2,3,4],:);
xlim_input_cs = [-500 4000]; ylim_input_cs = [-3 3];
xlim_input_outcome  = [-1000 100]; ylim_input_outcome = [-3 3];

for neuron_i = 1:size(data_in,1)
    all_prob_trials = [];
    for trial_type_i = 1:length(plot_trial_types)
        all_prob_trials = [all_prob_trials, data_in.trials{neuron_i}.(plot_trial_types{trial_type_i})];
    end
    
    bl_fr_mean = nanmean(nanmean(data_in.sdf{neuron_i}(all_prob_trials,baseline_win+time_zero)));
    bl_fr_std = nanstd(nanmean(data_in.sdf{neuron_i}(all_prob_trials,baseline_win+time_zero)));
    
    
    for trial_type_i = 1:length(plot_trial_types)
        trial_type_label = plot_trial_types{trial_type_i};
        trials_in = []; trials_in = data_in.trials{neuron_i}.(trial_type_label);
        n_trls = size(trials_in,2);
        
        outcome_window = []; outcome_window = time_zero + epoch.outcomeTime(trial_type_i) + outcome_win;
        
        sdf_x_cs = []; sdf_x_cs = (nanmean(data_in.sdf{neuron_i}(trials_in,:))-bl_fr_mean)./bl_fr_std;
        sdf_x_outcome = []; sdf_x_outcome = (nanmean(data_in.sdf{neuron_i}(trials_in,outcome_window))-bl_fr_mean)./bl_fr_std;
        
        % If there aren't enough trials, then we will NaN out the SDF
        if any(isinf(sdf_x_cs)) | length(sdf_x_cs) == 1 | any(isinf(sdf_x_outcome)) | length(sdf_x_outcome) == 1 
            sdf_x_cs = nan(1,length(plot_time));
            sdf_x_outcome = nan(1,length(outcome_win));
        end

        plot_sdf_data_cs = [plot_sdf_data_cs ; num2cell(sdf_x_cs,2)];
        plot_sdf_data_outcome = [plot_sdf_data_outcome ; num2cell(sdf_x_outcome,2)];
        plot_label = [plot_label; {[int2str(trial_type_i) '_' (trial_type_label)]}];
        
        plot_fano_data_cs = [plot_fano_data_cs; {data_in.fano(neuron_i).raw.(trial_type_label)}];
        
        fano_outcome_window = [];
        fano_outcome_window = find(ismember(data_in.fano(neuron_i).time,...
            outcome_window-time_zero));
        
        plot_fano_data_outcome = [plot_fano_data_outcome; {data_in.fano(neuron_i).raw.(trial_type_label)(fano_outcome_window)}];
        plot_fano_label = [plot_fano_label; {[int2str(trial_type_i) '_' (trial_type_label)]}];
        
        plot_category_label = [plot_category_label; {bf_datasheet_CS.cluster_label{neuron_i}}];
        
    end
end


%% Figure
% Generate plot using gramm
clear figure_plot

% CS Onset %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spike density function >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
figure_plot(1,1)=gramm('x',plot_time,'y',plot_sdf_data_cs,'color',plot_label);
figure_plot(1,1).stat_summary();
figure_plot(1,1).axe_property('XLim',xlim_input_cs,'YLim',ylim_input_cs);
figure_plot(1,1).set_names('x','Time from CS Onset (ms)','y','Firing rate (z-score)');
figure_plot(1,1).set_color_options('map',color_scheme);
figure_plot(1,1).geom_vline('xintercept',0,'style','k-');
figure_plot(1,1).geom_vline('xintercept',[1500 2500 3500],'style','k-');

% Fano factor >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
figure_plot(2,1)=gramm('x',data_in.fano(1).time,'y',plot_fano_data_cs,'color',plot_fano_label);
figure_plot(2,1).stat_summary();
figure_plot(2,1).axe_property('XLim',xlim_input_cs,'YLim',[0 2]);
figure_plot(2,1).set_names('x','Time from CS Onset (ms)','y','Fano Factor');
figure_plot(2,1).set_color_options('map',color_scheme);
figure_plot(2,1).geom_vline('xintercept',0,'style','k-');
figure_plot(2,1).geom_vline('xintercept',1500,'style','k-');
figure_plot(2,1).geom_hline('yintercept',1,'style','k--');

figure_plot(1,2)=gramm('x',outcome_win,'y',plot_sdf_data_outcome,'color',plot_label);
figure_plot(1,2).stat_summary();
figure_plot(1,2).axe_property('XLim',xlim_input_outcome,'YLim',ylim_input_outcome);
figure_plot(1,2).set_names('x','Time from outcome (ms)','y','Firing rate (z-score)');
figure_plot(1,2).set_color_options('map',color_scheme);
figure_plot(1,2).geom_vline('xintercept',0,'style','k-');

% Fano factor >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
figure_plot(2,2)=gramm('x',outcome_win,'y',plot_fano_data_outcome,'color',plot_fano_label);
figure_plot(2,2).stat_summary();
figure_plot(2,2).axe_property('XLim',xlim_input_outcome,'YLim',[0 2]);
figure_plot(2,2).set_names('x','Time from outcome (ms)','y','Fano Factor');
figure_plot(2,2).set_color_options('map',color_scheme);
figure_plot(2,2).geom_vline('xintercept',0,'style','k-');
figure_plot(2,2).geom_hline('yintercept',1,'style','k--');



figure_plot_out = figure('Renderer', 'painters', 'Position', [100 100 1000 400]);
figure_plot.draw();

%% Output
% Once we're done with a page, save it and close it.
filename = fullfile(dirs.root,'results','sdf_fano_timingtask_figure_population_varTime.pdf');
set(figure_plot_out,'PaperSize',[20 10]); %set the paper size to what you want
print(figure_plot_out,filename,'-dpdf') % then print it
close(figure_plot_out)

