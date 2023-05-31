function [figure_plot_out, figure_plot, figure_plot_b] = plot_fr_x_uncertain(data_in,datasheet_in,plot_trial_types,params,fig_flag)

if nargin < 4
    fig_flag = 0;
end

plot_time = [-5000:5000];
time_zero = abs(plot_time(1));
x_fit_data = 1:0.1:length(plot_trial_types);
analysis_window = [-500:0];

% Initialize plot data structures
plot_sdf_data = [];
plot_label = [];
fit_label = [];

for neuron_i = 1:size(data_in,1)
    
    % Switch outcome time, depending on exp setup
    switch datasheet_in.site{neuron_i}
        case 'nih'
            outcome_time = 1500;
        case 'wustl'
            outcome_time = 2500;
    end

    all_prob_trials = [];
    for trial_type_i = 1:length(plot_trial_types)
        all_prob_trials = [all_prob_trials, data_in.trials{neuron_i}.(plot_trial_types{trial_type_i})];
    end

    % Normalization
    baseline_win = [-1000:3500];
    time_zero = abs(plot_time(1));
    bl_fr_mean = nanmean(nanmean(data_in.sdf{neuron_i}(all_prob_trials,baseline_win+time_zero)));
    bl_fr_std = nanstd(nanmean(data_in.sdf{neuron_i}(all_prob_trials,baseline_win+time_zero)));
        
    %% Setup figure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Raster & SDF restructuring
    for trial_type_i = 1:length(plot_trial_types)
        trial_type_label = plot_trial_types{trial_type_i};
        trials_in = []; trials_in = data_in.trials{neuron_i}.(trial_type_label);
        n_trls = size(trials_in,2);
        
        sdf_x = []; sdf_x = (nanmean(data_in.sdf{neuron_i}(trials_in,:))-bl_fr_mean)./bl_fr_std;

        
        plot_label = [plot_label; {[int2str(trial_type_i) '_' (trial_type_label)]}];
        fit_label = [fit_label; trial_type_i];
        plot_sdf_data = [plot_sdf_data; nanmean(sdf_x(:,analysis_window+outcome_time+5001),2)];
    end
    
    
    %% Fit curve to data
    y_fit = []; y_fit = polyfit(fit_label,plot_sdf_data,2);
    y_fit_data{neuron_i,1} = polyval(y_fit,x_fit_data);
    
end


%% Generate plot
% Generate plot using gramm
clear figure_plot

xlim_input = params.plot.xlim; ylim_input = params.plot.ylim;
color_scheme = params.plot.colormap;

% Raster plot
figure_plot(1,1)=gramm('x',plot_label,'y',plot_sdf_data,'color',plot_label);
figure_plot(1,1).geom_jitter('alpha',0.2);
figure_plot(1,1).geom_line('alpha',0.1);
figure_plot(1,1).no_legend;
figure_plot(1,1).set_color_options('map',color_scheme);
figure_plot(1,1).axe_property('YLim',[-5 5]);

figure_plot_b(1,1)=gramm('x',x_fit_data,'y',y_fit_data);
figure_plot_b(1,1).stat_summary();
figure_plot_b(1,1).no_legend;
figure_plot_b(1,1).axe_property('YLim',[-5 5]);

if fig_flag == 1
    figure_plot_out = figure('Renderer', 'painters', 'Position', [100 100 400 700]);
    figure_plot_b.draw();
else
    figure_plot_out = [];
end

end
