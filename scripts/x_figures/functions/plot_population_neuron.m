function [figure_plot_out, plot_data, figure_plot] = plot_population_neuron(data_in,plot_trial_types,params,fig_flag)

if nargin < 4
    fig_flag = 0;
end

% Initialize plot data structures
plot_sdf_data = [];
plot_fano_data = []; plot_fano_label = [];
plot_category_label = []; plot_label = [];
plot_time_adjust = [];

plot_time = [-5000:5000];
time_zero = abs(plot_time(1));

baseline_win = [-1000:3500];
max_win = [2000:2500];

for neuron_i = 1:size(data_in,1)
    all_prob_trials = [];
    for trial_type_i = 1:length(plot_trial_types)
        all_prob_trials = [all_prob_trials, data_in.trials{neuron_i}.(plot_trial_types{trial_type_i})];
    end
    
    % Normalization
    bl_fr_mean = nanmean(nanmean(data_in.sdf{neuron_i}(all_prob_trials,baseline_win+time_zero)));
    bl_fr_std = nanstd(nanmean(data_in.sdf{neuron_i}(all_prob_trials,baseline_win+time_zero)));
    max_fr = max(mean(data_in.sdf{neuron_i}(all_prob_trials,max_win+time_zero)));
    
    
    for trial_type_i = 1:length(plot_trial_types)
        trial_type_label = plot_trial_types{trial_type_i};
        trials_in = []; trials_in = data_in.trials{neuron_i}.(trial_type_label);
        n_trls = size(trials_in,2);
        
        sdf_x = []; sdf_x = (nanmean(data_in.sdf{neuron_i}(trials_in,:))-bl_fr_mean)./bl_fr_std;
        %sdf_x = []; sdf_x = nanmean(data_in.sdf{neuron_i}(trials_in,:))./max_fr;
        
        % If there aren't enough trials, then we will NaN out the SDF
        if any(isinf(sdf_x)) | length(sdf_x) == 1
            sdf_x = nan(1,length(plot_time));
        end
        
        plot_sdf_data = [plot_sdf_data ; num2cell(sdf_x,2)];
        plot_label = [plot_label; {[int2str(trial_type_i) '_' (trial_type_label)]}];
        
        plot_fano_data = [plot_fano_data; {data_in.fano(neuron_i).smooth.(trial_type_label)}];
        plot_fano_label = [plot_fano_label; {[int2str(trial_type_i) '_' (trial_type_label)]}];
        
        plot_time_adjust = [plot_time_adjust; {plot_time}];
        
    end
end


%% Output data
plot_data.plot_sdf_data = plot_sdf_data;
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
figure_plot(1,1).geom_vline('xintercept',0,'style','k-');
figure_plot(1,1).geom_vline('xintercept',params.plot.xintercept,'style','k-');
figure_plot(1,1).no_legend;

% Fano factor
figure_plot(2,1)=gramm('x',data_in.fano(1).time,'y',plot_fano_data,'color',plot_fano_label);
figure_plot(2,1).stat_summary();
figure_plot(2,1).axe_property('XLim',xlim_input,'YLim',[0 2]);
figure_plot(2,1).set_names('x','Time from CS Onset (ms)','y','Fano Factor');
figure_plot(2,1).set_color_options('map',color_scheme);
figure_plot(2,1).geom_vline('xintercept',0,'style','k-');
figure_plot(2,1).geom_vline('xintercept',params.plot.xintercept,'style','k-');
figure_plot(2,1).geom_hline('yintercept',1,'style','k--');
figure_plot(2,1).no_legend;


if fig_flag == 1
    figure_plot_out = figure('Renderer', 'painters', 'Position', [100 100 300 400]);
    figure_plot.draw();
else
    figure_plot_out = [];
end
