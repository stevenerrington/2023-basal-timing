function figure_out = plot_compare_fano(input_data,input_trials,input_labels,params)

ylim_input = params.plot.ylim;

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
            task_id{neuron_i,1} = input_labels{comp_i};
        catch
            continue
        end
    end
end

%% Figure:

clear test_figure condition_label figure_data site_label cluster_label
% Boxplot

figure_gramm(1,1)= gramm('x',task_id,'y',fano_cs_onset,'color',task_id);
figure_gramm(1,1).stat_summary('geom',{'bar','black_errorbar'},'width',1);
figure_gramm(1,1).geom_jitter('alpha',0.2);
figure_gramm(1,1).no_legend();
figure_gramm(1,1).facet_grid([],[]);
figure_gramm(1,1).geom_hline('yintercept',1);
figure_gramm(1,1).axe_property('YLim',ylim_input);

% Figure parameters & settings
figure_gramm.set_names('x','Task','y','Fano Factor');

figure_out = figure('Renderer', 'painters', 'Position', [100 100 200 350]);
figure_gramm.draw();

end