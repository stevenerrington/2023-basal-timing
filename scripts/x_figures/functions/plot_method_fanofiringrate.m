function figure_out = plot_method_fanofiringrate(input_data,input_trials,input_labels,params)

xlim_input = params.plot.xlim; ylim_input = params.plot.ylim;

% Setup data structure
data_in = [];
for comp_i = 1:length(input_data)
    data_in = [data_in; input_data{comp_i}];
end

clear fano_prob*

for neuron_i = 1:size(data_in,1)   
    fano_continuous = [];
    fano_continuous = find(ismember(data_in.fano(neuron_i).time,params.fano.timewindow));
    
    for comp_i = 1:length(input_data)
        try
            fano_cs_onset(neuron_i,1) =  nanmean(data_in.fano(neuron_i).raw.(input_trials{comp_i})(fano_continuous));
            fr_cs_onset(neuron_i,1) =  nanmean(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.(input_trials{comp_i}),params.fano.timewindow+5000)));
            task_id{neuron_i,1} = input_labels{comp_i};
        catch
            continue
        end
    end
end

%% Figure:

clear test_figure condition_label figure_data site_label cluster_label
% Boxplot
fr_x_fano_scatter(1,1)= gramm('x',fr_cs_onset,'y',fano_cs_onset,'color',task_id);
fr_x_fano_scatter(1,1).stat_glm('disp_fit',true);
fr_x_fano_scatter(1,1).geom_point('alpha',0.8);
fr_x_fano_scatter(1,1).facet_grid([],task_id);
fr_x_fano_scatter(1,1).no_legend();
fr_x_fano_scatter(1,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
% Figure parameters & settings
fr_x_fano_scatter.set_names('x','Firing Rate (spk/sec)','y','Fano Factor');

figure_out = figure('Renderer', 'painters', 'Position', [100 100 700 350]);
fr_x_fano_scatter.draw();

end