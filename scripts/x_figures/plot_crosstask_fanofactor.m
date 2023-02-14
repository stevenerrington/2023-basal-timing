
%% Analysis: epoched Fano Factor
clear epoch
epoch.CSonset = [0 200];
epoch_zero.CSonset = [0];

clear fano_prob*

input_data = [bf_data_CS(bf_datasheet_CS.cluster_id == 2,:); bf_data_timingTask; bf_data_traceExp];

for neuron_i = 1:size(input_data,1)
    fano = struct();
    
    fano = get_fano_window(input_data.rasters{neuron_i},...
        input_data.trials{neuron_i},...
        epoch.CSonset + epoch_zero.CSonset); % @ moment, centers on 0
    
    try
        fano_cs_onset(neuron_i,1) =  fano.window.probAll;
        task_id{neuron_i,1} = '1_CS';
    catch
        try
            fano_cs_onset(neuron_i,1) =  fano.window.fractal6105_1500;
            task_id{neuron_i,1} = '2_Timing';
        catch
            fano_cs_onset(neuron_i,1) =  fano.window.plot_test;
            task_id{neuron_i,1} = '3_Trace';
        end
    end

end


%% Figure: 

clear test_figure condition_label figure_data site_label cluster_label
% Boxplot

test_figure(1,1)= gramm('x',task_id,'y',fano_cs_onset,'color',task_id);
test_figure(1,1).stat_summary('geom',{'bar','black_errorbar'},'width',1);
test_figure(1,1).geom_jitter('alpha',0.2);
test_figure(1,1).no_legend();
test_figure(1,1).facet_grid([],[]);
test_figure(1,1).geom_hline('yintercept',1);
% stoppingBoxplot_Figure(1,1).axe_property('YLim',[0.08 0.16]);

% Figure parameters & settings
test_figure.set_names('y','');

outcome_rwd_fano_out = figure('Renderer', 'painters', 'Position', [100 100 200 200]);
test_figure.draw();


filename = fullfile(dirs.root,'results','bf_ramping_fano_x_task.pdf');
set(outcome_rwd_fano_out,'PaperSize',[20 10]); %set the paper size to what you want
print(outcome_rwd_fano_out,filename,'-dpdf') % then print it
close(outcome_rwd_fano_out)

