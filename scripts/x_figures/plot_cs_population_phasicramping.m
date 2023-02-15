% Input variables
data_in = []; data_in = bf_data_CS;
example_neuron_i = 47; %49
plot_trial_types = {'prob0','prob25','prob50','prob75','prob100'};

xlim_input = [-500 2500];
ylim_input = [-10 10];

% Initialize plot data structures
plot_sdf_data = [];
plot_fano_data = []; plot_fano_label = [];
plot_category_label = [];
plot_label = [];
plot_time = [-5000:5000];
time_zero = abs(plot_time(1));
color_scheme = cool(length(plot_trial_types));
baseline_win = [-500:200];

for neuron_i = 1:size(data_in,1)
    
    bl_fr_mean = nanmean(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.probAll,baseline_win+time_zero)));
    bl_fr_std = nanstd(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.probAll,baseline_win+time_zero)));
    
    
    for trial_type_i = 1:length(plot_trial_types)
        trial_type_label = plot_trial_types{trial_type_i};
        trials_in = []; trials_in = data_in.trials{neuron_i}.(trial_type_label);
        n_trls = size(trials_in,2);
        
        sdf_x = []; sdf_x = (nanmean(data_in.sdf{neuron_i}(trials_in,:))-bl_fr_mean)./bl_fr_std;
        
        
        plot_sdf_data = [plot_sdf_data ; num2cell(sdf_x,2)];
        plot_label = [plot_label; {[int2str(trial_type_i) '_' (trial_type_label)]}];
        
        plot_fano_data = [plot_fano_data; {data_in.fano(neuron_i).raw.(trial_type_label)}];
        plot_fano_label = [plot_fano_label; {[int2str(trial_type_i) '_' (trial_type_label)]}];
        
        plot_category_label = [plot_category_label; {bf_datasheet_CS.cluster_label{neuron_i}}];
        
    end
end

% Generate plot using gramm
clear figure_plot

% Phasic %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spike density function
figure_plot(1,1)=gramm('x',plot_time,'y',plot_sdf_data,'color',plot_label,'subset',strcmp(plot_category_label,'Phasic'));
figure_plot(1,1).stat_summary();
figure_plot(1,1).axe_property('XLim',xlim_input,'YLim',[-2 7]);
figure_plot(1,1).set_names('x','Time from CS Onset (ms)','y','Firing rate (spk/sec)');
figure_plot(1,1).set_color_options('map',color_scheme);
figure_plot(1,1).geom_vline('xintercept',0,'style','k-');
figure_plot(1,1).geom_vline('xintercept',1500,'style','k-');
figure_plot(1,1).no_legend;

% Fano factor
figure_plot(2,1)=gramm('x',data_in.fano(1).time,'y',plot_fano_data,'color',plot_fano_label,'subset',strcmp(plot_category_label,'Phasic'));
figure_plot(2,1).stat_summary();
figure_plot(2,1).axe_property('XLim',xlim_input,'YLim',[0 6]);
figure_plot(2,1).set_names('x','Time from CS Onset (ms)','y','Fano Factor');
figure_plot(2,1).set_color_options('map',color_scheme);
figure_plot(2,1).geom_vline('xintercept',0,'style','k-');
figure_plot(2,1).geom_vline('xintercept',1500,'style','k-');
figure_plot(2,1).geom_hline('yintercept',1,'style','k--');
figure_plot(2,1).no_legend;

% Ramping %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spike density function
figure_plot(1,2)=gramm('x',plot_time,'y',plot_sdf_data,'color',plot_label,'subset',strcmp(plot_category_label,'Ramping'));
figure_plot(1,2).stat_summary();
figure_plot(1,2).axe_property('XLim',xlim_input,'YLim',ylim_input);
figure_plot(1,2).set_names('x','Time from CS Onset (ms)','y','Firing rate (spk/sec)');
figure_plot(1,2).set_color_options('map',color_scheme);
figure_plot(1,2).geom_vline('xintercept',0,'style','k-');
figure_plot(1,2).geom_vline('xintercept',1500,'style','k-');
figure_plot(1,2).no_legend;

% Fano factor
figure_plot(2,2)=gramm('x',data_in.fano(1).time,'y',plot_fano_data,'color',plot_fano_label,'subset',strcmp(plot_category_label,'Ramping'));
figure_plot(2,2).stat_summary();
figure_plot(2,2).axe_property('XLim',xlim_input,'YLim',[0 6]);
figure_plot(2,2).set_names('x','Time from CS Onset (ms)','y','Fano Factor');
figure_plot(2,2).set_color_options('map',color_scheme);
figure_plot(2,2).geom_vline('xintercept',0,'style','k-');
figure_plot(2,2).geom_vline('xintercept',1500,'style','k-');
figure_plot(2,2).geom_hline('yintercept',1,'style','k--');
figure_plot(2,2).no_legend;

figure_plot_out = figure('Renderer', 'painters', 'Position', [100 100 800 300]);
figure_plot.draw();

%% Output
% Once we're done with a page, save it and close it.
filename = fullfile(dirs.root,'results','sdf_fano_cstask_figure_populations.pdf');
set(figure_plot_out,'PaperSize',[20 10]); %set the paper size to what you want
print(figure_plot_out,filename,'-dpdf') % then print it
close(figure_plot_out)

