
%% Analysis: epoched Fano Factor
clear epoch
epoch.CSonset = [0 200];
epoch_zero.CSonset = [0];

clear fano_prob*

input_data = [bf_data_CS(bf_datasheet_CS.cluster_id == 2,:); bf_data_timingTask; bf_data_traceExp];

cs_trial = 'prob50'; timing_trial = 'p50s_50l_short'; trace_trial = 'timingcue_uncertain';

for neuron_i = 1:size(input_data,1)

    fano_continuous = [];
    fano_continuous = find(ismember(input_data.fano(neuron_i).time,params.fano.timewindow));
    
    try
        fano_cs_onset(neuron_i,1) =  nanmean(input_data.fano(neuron_i).raw.(cs_trial)(fano_continuous));
        task_id{neuron_i,1} = '1_CS';
    catch
        try
            fano_cs_onset(neuron_i,1) =  nanmean(input_data.fano(neuron_i).raw.(timing_trial)(fano_continuous));
            task_id{neuron_i,1} = '2_Timing';
        catch
            fano_cs_onset(neuron_i,1) =  nanmean(input_data.fano(neuron_i).raw.(trace_trial)(fano_continuous));
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
test_figure(1,1).axe_property('YLim',[0 2]);

% Figure parameters & settings
test_figure.set_names('y','');

outcome_rwd_fano_out = figure('Renderer', 'painters', 'Position', [100 100 200 350]);
test_figure.draw();


filename = fullfile(dirs.root,'results','bf_ramping_fano_x_task.pdf');
set(outcome_rwd_fano_out,'PaperSize',[20 10]); %set the paper size to what you want
print(outcome_rwd_fano_out,filename,'-dpdf') % then print it
close(outcome_rwd_fano_out)

