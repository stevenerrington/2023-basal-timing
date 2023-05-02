function [figure_plot_out, plot_data, figure_plot] = plot_example_neuron(data_in,plot_trial_types,params,neuron_i,fig_flag)

if nargin < 5
    fig_flag = 0;
end

% Input variables
example_neuron_i = neuron_i;

% Initialize plot data structures
plot_sdf_data = []; plot_spk_data = [];
plot_fano_data = []; plot_fano_label = [];
plot_label = [];

plot_time = [-5000:5000];
time_zero = abs(plot_time(1));


%% Setup figure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Raster & SDF restructuring
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

%% Output data
plot_data.plot_sdf_data = plot_sdf_data;
plot_data.plot_label = plot_label;
plot_data.plot_spk_data = plot_spk_data;
plot_data.plot_fano_data = plot_fano_data;
plot_data.plot_fano_label = plot_fano_label;


%% Generate plot

% Generate plot using gramm
clear figure_plot

xlim_input = params.plot.xlim; ylim_input = params.plot.ylim;
color_scheme = params.plot.colormap;

% Raster plot
figure_plot(1,1)=gramm('x',plot_spk_data,'color',plot_label);
figure_plot(1,1).geom_raster();
figure_plot(1,1).axe_property('XLim',xlim_input);
figure_plot(1,1).set_names('x','Time from CS Onset (ms)','y','Trial');
figure_plot(1,1).set_color_options('map',color_scheme);
figure_plot(1,1).geom_vline('xintercept',0,'style','k-');
figure_plot(1,1).geom_vline('xintercept',params.plot.xintercept,'style','k-');
figure_plot(1,1).no_legend;

% Spike density function
figure_plot(2,1)=gramm('x',plot_time,'y',plot_sdf_data,'color',plot_label);
figure_plot(2,1).stat_summary();
figure_plot(2,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
figure_plot(2,1).set_names('x','Time from CS Onset (ms)','y','Firing rate (spk/sec)');
figure_plot(2,1).set_color_options('map',color_scheme);
figure_plot(2,1).geom_vline('xintercept',0,'style','k-');
figure_plot(2,1).geom_vline('xintercept',params.plot.xintercept,'style','k-');
figure_plot(2,1).no_legend;

% Fano factor
figure_plot(3,1)=gramm('x',data_in.fano(example_neuron_i).time,'y',plot_fano_data,'color',plot_fano_label);
figure_plot(3,1).geom_line();
figure_plot(3,1).axe_property('XLim',xlim_input,'YLim',[0 2]);
figure_plot(3,1).set_names('x','Time from CS Onset (ms)','y','Fano Factor');
figure_plot(3,1).set_color_options('map',color_scheme);
figure_plot(3,1).geom_vline('xintercept',0,'style','k-');
figure_plot(3,1).geom_vline('xintercept',params.plot.xintercept,'style','k-');
figure_plot(3,1).geom_hline('yintercept',1,'style','k--');
figure_plot(3,1).no_legend;

if fig_flag == 1
    figure_plot_out = figure('Renderer', 'painters', 'Position', [100 100 400 700]);
    figure_plot.draw();
    
else
    figure_plot_out = [];
end

end
