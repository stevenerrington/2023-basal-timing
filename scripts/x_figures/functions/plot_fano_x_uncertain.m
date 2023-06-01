function [figure_plot_out, figure_plot] = plot_fano_x_uncertain(data_in,datasheet_in,plot_trial_types,params,fig_flag)

if nargin < 4
    fig_flag = 0;
end

plot_time = [-5000:5000];
time_zero = abs(plot_time(1));
x_fit_data = 1:0.1:length(plot_trial_types);
analysis_window = [-500:0];

% Initialize plot data structures
plot_fano_data = [];
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
    
    fano_continuous = [];
    fano_continuous = find(ismember(data_in.fano(neuron_i).time,analysis_window+outcome_time));
    
    %% Setup figure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %  Raster & SDF restructuring
    for trial_type_i = 1:length(plot_trial_types)
        trial_type_label = plot_trial_types{trial_type_i};
        trials_in = []; trials_in = data_in.trials{neuron_i}.(trial_type_label);
        n_trls = size(trials_in,2);
        
        fano_x = []; fano_x = nanmean(data_in.fano(neuron_i).raw.(trial_type_label)(fano_continuous),2);
        
        plot_label = [plot_label; {[int2str(trial_type_i) '_' (trial_type_label)]}];
        fit_label = [fit_label; trial_type_i];
        plot_fano_data = [plot_fano_data; fano_x];
    end

end


%% Generate plot
% Generate plot using gramm
clear figure_plot

xlim_input = params.plot.xlim; ylim_input = params.plot.ylim;
color_scheme = params.plot.colormap;

% Raster plot
figure_plot(1,1)=gramm('x',plot_label,'y',plot_fano_data,'color',plot_label);
% figure_plot(1,1).geom_jitter('alpha',0.2);
figure_plot(1,1).stat_summary('geom',{'bar','errorbar'},'width',2.5,'dodge',1);
figure_plot(1,1).no_legend;
figure_plot(1,1).set_color_options('map',color_scheme);
figure_plot(1,1).axe_property('YLim',params.plot.ylim);

if fig_flag == 1
    figure_plot_out = figure('Renderer', 'painters', 'Position', [100 100 400 700]);
    figure_plot.draw();
else
    figure_plot_out = [];
end

end
