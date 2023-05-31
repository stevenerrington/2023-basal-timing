function [figure_plot_out, figure_plot, figure_plot_b] = plot_fr_x_uncertain_example(data_in,datasheet_in,plot_trial_types,params,neuron_i,fig_flag)

if nargin < 5
    fig_flag = 0;
end

% Input variables
example_neuron_i = neuron_i;

% Initialize plot data structures
plot_sdf_data = [];
plot_label = [];
fit_label = [];

plot_time = [-5000:5000];
time_zero = abs(plot_time(1));

analysis_window = [-500:0];

switch datasheet_in.site{neuron_i}
    case 'nih'
        outcome_time = 1500;
    case 'wustl'
        outcome_time = 2500;
end


%% Setup figure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Raster & SDF restructuring
for trial_type_i = 1:length(plot_trial_types)
    trial_type_label = plot_trial_types{trial_type_i};
    trials_in = []; trials_in = data_in.trials{example_neuron_i}.(trial_type_label);
    n_trls = size(trials_in,2);

    plot_label = [plot_label; repmat({[int2str(trial_type_i) '_' (trial_type_label)]},n_trls,1)];
    fit_label = [fit_label; repmat(trial_type_i,n_trls,1)];
    plot_sdf_data = [plot_sdf_data; nanmean(data_in.sdf{example_neuron_i}(trials_in,analysis_window+outcome_time+5001),2)];
end


%% Fit curve to data
y_fit = polyfit(fit_label,plot_sdf_data,2);
x_fit_data = 1:0.1:length(plot_trial_types);
y_fit_data = polyval(y_fit,x_fit_data);



%% Generate plot
% Generate plot using gramm
clear figure_plot

xlim_input = params.plot.xlim; ylim_input = params.plot.ylim;
color_scheme = params.plot.colormap;

% Raster plot
figure_plot(1,1)=gramm('x',plot_label,'y',plot_sdf_data,'color',plot_label);
figure_plot(1,1).geom_jitter('alpha',0.2);
figure_plot(1,1).stat_summary('geom',{'point','errorbar'});
figure_plot(1,1).set_color_options('map',color_scheme);
figure_plot(1,1).no_legend;
figure_plot(1,1).axe_property('YLim',[0 60]);

figure_plot_b(1,1)=gramm('x',x_fit_data,'y',y_fit_data);
figure_plot_b(1,1).geom_line();
figure_plot_b(1,1).no_legend;
figure_plot_b(1,1).axe_property('YLim',[0 60]);


if fig_flag == 1
    figure_plot_out = figure('Renderer', 'painters', 'Position', [100 100 400 700]);
    figure_plot.draw();
    
else
    figure_plot_out = [];
end

end
