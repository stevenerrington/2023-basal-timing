function [figure_plot] = plot_precision_analyses(slope_analysis, max_ramp_fr, example_neuron_i, fig_flag)

trial_type_list = fieldnames(slope_analysis);


max_fr_population = []; slopes_population = []; trial_type_label = [];
slopes_example = []; max_fr_example = []; example_labels = [];

for trial_type_i = 1:length(trial_type_list)
    trial_type_in = trial_type_list{trial_type_i};
    
    slopes_example = [slopes_example; nanmean(slope_analysis.(trial_type_in).slope{example_neuron_i},2)];
    max_fr_example = [max_fr_example; max_ramp_fr.all.(trial_type_in){example_neuron_i}-1500];
    example_labels = [example_labels; repmat({trial_type_in}, length(max_ramp_fr.all.(trial_type_in){example_neuron_i}), 1)];

    for neuron_i = 1:size(slope_analysis.(trial_type_in).slope,2)
        slopes_population = [slopes_population; std(nanmean(slope_analysis.(trial_type_in).slope{neuron_i},2))];
        trial_type_label = [trial_type_label; {trial_type_in}];
    end

    max_fr_population = [max_fr_population; max_ramp_fr.var.(trial_type_in)];
    
end

%%

clear figure_plot
figure_plot(1,1)=gramm('x',slopes_example,'color',example_labels);
figure_plot(1,1).stat_density();
figure_plot(1,1).set_names('x','Slope (trial)');
figure_plot(1,1).axe_property('XLim',[0 0.05]);
figure_plot(1,1).no_legend;

figure_plot(2,1)=gramm('x',max_fr_example,'color',example_labels);
figure_plot(2,1).stat_density();
figure_plot(2,1).set_names('x','Time of peak firing rate (ms)');
figure_plot(2,1).axe_property('XLim',[-200 200]);
figure_plot(2,1).no_legend;

figure_plot(3,1)=gramm('x',slopes_population,'color',trial_type_label);
figure_plot(3,1).stat_density();
figure_plot(3,1).set_names('x','Std of slopes across trials(ms)');
figure_plot(3,1).axe_property('XLim',[0 0.02]);
figure_plot(3,1).no_legend;

figure_plot(4,1)=gramm('x',max_fr_population,'color',trial_type_label);
figure_plot(4,1).stat_density();
figure_plot(4,1).set_names('x','Std of peak firing rate across trials(ms)');
figure_plot(4,1).axe_property('XLim',[-100 400]);
figure_plot(4,1).no_legend;

if fig_flag == 1
    figure('Renderer', 'painters', 'Position', [100 100 600 600]);
    figure_plot.draw;
end

end
