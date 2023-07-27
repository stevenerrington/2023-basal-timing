function [figure_plot_out, figure_plot, figure_plot_b, y_fit_out] = plot_fr_x_uncertainTiming(data_in,plot_trial_types,params,fig_flag,norm_method)

if nargin < 4
    norm_method = 'zscore';
end

plot_time = [-5000:5000];
time_zero = abs(plot_time(1));
x_fit_data = 1:0.1:length(plot_trial_types);
analysis_window = [-500:0];

% Initialize plot data structures
plot_sdf_data = [];
plot_label = [];
fit_label = [];
y_fit_out = [];

   
if any(strcmp('baseline_win',fieldnames(params.sdf)))
    baseline_win = params.sdf.baseline_win;
else
    baseline_win = [-1000:3500];
end    
    


for neuron_i = 1:size(data_in,1)
    
    outcome_time = params.plot.xintercept;
    
    all_prob_trials = [];
    for trial_type_i = 1:length(plot_trial_types)
        all_prob_trials = [all_prob_trials, data_in.trials{neuron_i}.(plot_trial_types{trial_type_i})];
    end
    
    % Normalization
    time_zero = abs(plot_time(1));
    bl_fr_mean = nanmean(nanmean(data_in.sdf{neuron_i}(all_prob_trials,baseline_win+time_zero)));
    bl_fr_std = nanstd(nanmean(data_in.sdf{neuron_i}(all_prob_trials,baseline_win+time_zero)));
    fr_max = max(nanmean(data_in.sdf{neuron_i}(all_prob_trials,baseline_win+time_zero)));
    
    %% Setup figure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Raster & SDF restructuring
    for trial_type_i = 1:length(plot_trial_types)
        trial_type_label = plot_trial_types{trial_type_i};
        trials_in = []; trials_in = data_in.trials{neuron_i}.(trial_type_label);
        n_trls = size(trials_in,2);
        
        if n_trls > 1
            switch norm_method
                case 'zscore'
                    sdf_x = []; sdf_x = (nanmean(data_in.sdf{neuron_i}(trials_in,:))-bl_fr_mean)./bl_fr_std;
                case 'max'
                    sdf_x = []; sdf_x = (nanmean(data_in.sdf{neuron_i}(trials_in,:))./fr_max);
            end
            
            
            plot_label = [plot_label; {[int2str(trial_type_i) '_' (trial_type_label)]}];
            fit_label = [fit_label; trial_type_i];
            plot_sdf_data = [plot_sdf_data; nanmean(sdf_x(:,analysis_window+outcome_time+5001),2)];
        end
    end
    
    
    %% Fit curve to data
    y_fit = []; y_fit = polyfit(fit_label,plot_sdf_data,2);
    
    y_fit_data{neuron_i,1} = polyval(y_fit,x_fit_data);
    y_fit_out(neuron_i,:) = y_fit;
    
end


%% Generate plot
% Generate plot using gramm
clear figure_plot

xlim_input = params.plot.xlim; ylim_input = params.plot.ylim;
color_scheme = params.plot.colormap;

% Raster plot
figure_plot(1,1)=gramm('x',plot_label,'y',plot_sdf_data);
figure_plot(1,1).stat_summary('geom',{'line','point','errorbar'});
figure_plot(1,1).no_legend;
figure_plot(1,1).set_color_options('map',color_scheme);
figure_plot(1,1).axe_property('YLim',[-2.5 5]);

figure_plot_b = [];
% figure_plot_b(1,1)=gramm('x',x_fit_data,'y',y_fit_data);
% figure_plot_b(1,1).stat_summary();
% figure_plot_b(1,1).no_legend;
% figure_plot_b(1,1).axe_property('YLim',[-5 5]);

if fig_flag == 1
    figure_plot_out = figure('Renderer', 'painters', 'Position', [100 100 400 700]);
    figure_plot.draw();
else
    figure_plot_out = [];
end

end
