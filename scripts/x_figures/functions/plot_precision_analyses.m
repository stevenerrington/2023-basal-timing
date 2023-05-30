function [figure_plot] = plot_precision_analyses(slope_analysis, max_ramp_fr, plot_fano_data, params, fig_flag)

trial_type_list = fieldnames(slope_analysis);


max_fr_population_mean = []; fano_population_mean = []; 
slopes_population_mean = []; slopes_population_var = []; trial_type_label = [];
slopes_example = []; max_fr_example = []; example_labels = [];

for trial_type_i = 1:length(trial_type_list)
    trial_type_in = trial_type_list{trial_type_i};

    for neuron_i = 1:size(slope_analysis.(trial_type_in).slope,2)
        slopes_population_mean = [slopes_population_mean; nanmean(nanmean(slope_analysis.(trial_type_in).slope{neuron_i},2))];
        trial_type_label = [trial_type_label; {[int2str(trial_type_i) '_' trial_type_in]}];
    end

    max_fr_population_mean = [max_fr_population_mean; max_ramp_fr.max_fr_out(endsWith(max_ramp_fr.trial_type_out,trial_type_in))];
    fano_population_mean = [fano_population_mean; plot_fano_data.fano_out(endsWith(plot_fano_data.trial_type_out,trial_type_in))];
    
end

%%

clear figure_plot
figure_plot(1,1)=gramm('x',trial_type_label,'y',slopes_population_mean,'color',trial_type_label);
figure_plot(1,1).stat_summary('geom',{'bar','black_errorbar'},'dodge',1,'width',2);
figure_plot(1,1).geom_jitter('alpha',0.1);
figure_plot(1,1).set_names('y','Slope (mean)');
figure_plot(1,1).set_color_options('map',params.plot.colormap);
figure_plot(1,1).no_legend;
figure_plot(1,1).geom_hline('yintercept',0);

figure_plot(2,1)=gramm('x',trial_type_label,'y',max_fr_population_mean,'color',trial_type_label);
figure_plot(2,1).stat_summary('geom',{'bar','black_errorbar'},'dodge',1,'width',2);
figure_plot(2,1).geom_jitter('alpha',0.1);
figure_plot(2,1).set_color_options('map',params.plot.colormap);
figure_plot(2,1).set_names('y','Firing rate (Z-score)');
figure_plot(2,1).no_legend;
figure_plot(2,1).geom_hline('yintercept',0);

figure_plot(3,1)=gramm('x',trial_type_label,'y',fano_population_mean,'color',trial_type_label);
figure_plot(3,1).stat_summary('geom',{'bar','black_errorbar'},'dodge',1,'width',2);
figure_plot(3,1).geom_jitter('alpha',0.1);
figure_plot(3,1).set_color_options('map',params.plot.colormap);
figure_plot(3,1).set_names('y','Fano Factor');
figure_plot(3,1).no_legend;
figure_plot(3,1).geom_hline('yintercept',0);

if fig_flag == 1
    figure('Renderer', 'painters', 'Position', [100 100 600 600]);
    figure_plot.draw;
end

end
