function [figure_plot_out, plot_data, figure_plot] = plot_population_neuron_diff(data_in,plot_trial_types,params,fig_flag)

if nargin < 4
    fig_flag = 0;
end

% Initialize plot data structures
plot_sdf_data = []; plot_sdf_mean = [];
plot_fano_data = []; plot_fano_label = [];
plot_category_label = []; plot_label = [];
plot_time_adjust = [];

plot_time = [-5000:5000];
time_zero = abs(plot_time(1));

if any(strcmp('baseline_win',fieldnames(params.sdf)))
    baseline_win = params.sdf.baseline_win;
else
    baseline_win = [-1000:4500];
end

max_win = [2000:2500];
analysis_window = [100:400];
outcome_time = 1500;

for neuron_i = 1:size(data_in,1)
    all_prob_trials = [];
    for trial_type_i = 1:length(plot_trial_types)
        for trial_type_j = 1:length(plot_trial_types{trial_type_i})
            all_prob_trials = [all_prob_trials, data_in.trials{neuron_i}.(plot_trial_types{trial_type_i}{trial_type_j})];
        end
    end
    
    % Normalization
    bl_fr_mean = nanmean(nanmean(data_in.sdf{neuron_i}(all_prob_trials,baseline_win+time_zero)));
    bl_fr_std = nanstd(nanmean(data_in.sdf{neuron_i}(all_prob_trials,baseline_win+time_zero)));
    max_fr = max(mean(data_in.sdf{neuron_i}(all_prob_trials,max_win+time_zero)));
    
    
    for trial_type_i = 1:length(plot_trial_types)
        trial_type_label_a = plot_trial_types{trial_type_i}{1};
        trial_type_label_b = plot_trial_types{trial_type_i}{2};
        
        
        trials_in_a = []; trials_in_a = data_in.trials{neuron_i}.(trial_type_label_a);
        trials_in_b = []; trials_in_b = data_in.trials{neuron_i}.(trial_type_label_b);

        
        sdf_a = []; sdf_a = (nanmean(data_in.sdf{neuron_i}(trials_in_a,:))-bl_fr_mean)./bl_fr_std;
        sdf_b = []; sdf_b = (nanmean(data_in.sdf{neuron_i}(trials_in_b,:))-bl_fr_mean)./bl_fr_std;
        
        % If there aren't enough trials, then we will NaN out the SDF
        if any(isinf(sdf_a)) | length(sdf_a) == 1 | any(isinf(sdf_b)) | length(sdf_b) == 1
            sdf_a = nan(1,length(plot_time));
            sdf_b = nan(1,length(plot_time));
        end
        
        plot_sdf_data = [plot_sdf_data ; num2cell(sdf_a-sdf_b,2)];
        plot_label = [plot_label; {[int2str(trial_type_i) '_' (trial_type_label_a(1:3))]}];
        plot_sdf_mean = [plot_sdf_mean; nanmean(sdf_a(:,analysis_window+outcome_time+5001)-sdf_b(:,analysis_window+outcome_time+5001),2)];

    end
end


%% Output data
plot_data.plot_sdf_data = plot_sdf_data;
plot_data.plot_sdf_mean = plot_sdf_mean;
plot_data.plot_label = plot_label;
plot_data.plot_fano_data = plot_fano_data;
plot_data.plot_fano_label = plot_fano_label;
plot_data.plot_time_adjust = plot_time_adjust;


%% Generate Figure
% Generate plot using gramm
clear figure_plot

xlim_input = params.plot.xlim; ylim_input = params.plot.ylim;
color_scheme = params.plot.colormap;

% Ramping %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spike density function
figure_plot(1,1)=gramm('x',plot_time,'y',plot_sdf_data,'color',plot_label);
figure_plot(1,1).stat_summary();
figure_plot(1,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
figure_plot(1,1).set_names('x','Time from CS Onset (ms)','y','Firing rate (Z-score)');
figure_plot(1,1).set_color_options('map',color_scheme);
figure_plot(1,1).set_line_options('base_size', 0.5);
figure_plot(1,1).no_legend;

% Fano factor
figure_plot(2,1)=gramm('x',plot_label,'y',plot_sdf_mean);
figure_plot(2,1).stat_summary('geom',{'line','point','errorbar'});
figure_plot(2,1).no_legend;
figure_plot(2,1).set_color_options('map',color_scheme);
figure_plot(2,1).axe_property('YLim',[-2.5 5]);


if fig_flag == 1
    figure_plot_out = figure('Renderer', 'painters', 'Position', [100 100 300 400]);
    figure_plot.draw();
else
    figure_plot_out = [];
end
