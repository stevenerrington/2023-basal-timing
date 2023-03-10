
%% Setup workspace
% Input variables
data_in = []; data_in = [bf_data_CS(bf_datasheet_CS.cluster_id == 2,:);  bf_data_timingTask; bf_data_traceExp];   

% Initialize plot data structures
plot_sdf_data = []; plot_fano_data = []; plot_fano_label = [];
plot_category_label = []; plot_label = [];
plot_example_sdf_data = []; plot_example_label = [];
plot_example_category_label = []; plot_example_spk_data = [];

% Define times
plot_time = [-5000:5000]; time_zero = abs(plot_time(1));
baseline_win = [-500:200];

% Define example neurons
example_neuron_cs = 16; example_neuron_timing = 6; example_neuron_trace = 8;
example_neuron_list = [example_neuron_cs, example_neuron_timing, example_neuron_trace];

% Define figure details
color_scheme_CS = cool(5); color_scheme_timing = color_scheme_CS(2:4); color_scheme_trace = color_scheme_CS(1:5);

xlim_input = [-500 2500]; ylim_input = [-10 10];

%% Extract: get spiking data
%>>>> Example neuron level extraction: >>>>>>>>>>>>>>>>>>>>>>>>
for example_neuron_i = 1:3
    neuron_i = example_neuron_list(example_neuron_i);

    %>>>> Parameter setup: task switch >>>>>>>>>>>>>>>>>>>>>>>>
    % Get relevant trial types
    plot_trial_types = {};
    switch example_neuron_i
        case 1 % CS
            plot_trial_types = {'prob0','prob25','prob50','prob75','prob100'};
            example_neuron_id = example_neuron_cs;
            data_in_idx = find(strcmp(data_in.filename,bf_data_CS.filename{example_neuron_id}));
        case 2 % CS
            plot_trial_types = {'p25s_75l_short','p50s_50l_short','p75s_25l_short'};
            example_neuron_id = example_neuron_timing;            
            data_in_idx = find(strcmp(data_in.filename,bf_data_timingTask.filename{example_neuron_id}));
        case 3 % CS
            plot_trial_types = {'timingcue_uncertain','notimingcue_uncertain'};
            example_neuron_id = example_neuron_trace;
            data_in_idx = find(strcmp(data_in.filename,bf_data_traceExp.filename{example_neuron_id}));
    end
    
    
    for trial_type_i = 1:length(plot_trial_types)
        % Get trials
        trial_type_label = plot_trial_types{trial_type_i};
        trials_in = []; trials_in = data_in.trials{data_in_idx}.(trial_type_label);
        
        % Spike density function
        sdf_x = []; sdf_x = num2cell(data_in.sdf{data_in_idx}(trials_in,:),2);
        
        % Raster/spike times
        n_trls = size(trials_in,2);
        
        spkTimes = {};
        for trl_i = 1:n_trls
            spkTimes{trl_i,1} = find(data_in.rasters{data_in_idx}(trials_in(trl_i),:) == 1) - time_zero;
            plot_example_label = [plot_example_label; {[int2str(trial_type_i) '_' (trial_type_label)]}];
            plot_example_category_label = [plot_example_category_label; master_datatable_bf.task(data_in_idx)];
        end
        
        plot_example_spk_data = [plot_example_spk_data; spkTimes];
        plot_example_sdf_data = [plot_example_sdf_data ; sdf_x];
    end

end

%>>>> Population level extraction: >>>>>>>>>>>>>>>>>>>>>>>>
% For all neurons in the data_in structure
for neuron_i = 1:size(data_in,1)
    all_prob_trials = []; plot_trial_types = {};
    
    switch master_datatable_bf.task{neuron_i}
        case 'CS'
            plot_trial_types = {'prob0','prob25','prob50','prob75','prob100'};
        case 'Timing'
            plot_trial_types = {'p25s_75l_short','p50s_50l_short','p75s_25l_short'};
        case 'Trace'
            plot_trial_types = {'timingcue_uncertain','notimingcue_uncertain'};
    end
    
    % Find trial types of average over
    for trial_type_i = 1:length(plot_trial_types)
        all_prob_trials = [all_prob_trials, data_in.trials{neuron_i}.(plot_trial_types{trial_type_i})];
    end
    % Get baseline average and STD
    bl_fr_mean = nanmean(nanmean(data_in.sdf{neuron_i}(all_prob_trials,baseline_win+time_zero)));
    bl_fr_std = nanstd(nanmean(data_in.sdf{neuron_i}(all_prob_trials,baseline_win+time_zero)));
    
    % Get average SDF across each trial type
    for trial_type_i = 1:length(plot_trial_types)
        trial_type_label = plot_trial_types{trial_type_i};
        trials_in = []; trials_in = data_in.trials{neuron_i}.(trial_type_label);
        n_trls = size(trials_in,2);
        
        sdf_x = []; sdf_x = (nanmean(data_in.sdf{neuron_i}(trials_in,:))-bl_fr_mean)./bl_fr_std;
        
        % If there aren't enough trials, then we will NaN out the SDF
        if any(isinf(sdf_x)) | length(sdf_x) == 1
            sdf_x = nan(1,length(plot_time));
        end
        
        % Output relevant data into storage arrays
        plot_sdf_data = [plot_sdf_data ; num2cell(sdf_x,2)];
        plot_label = [plot_label; {[int2str(trial_type_i) '_' (trial_type_label)]}];
        plot_fano_data = [plot_fano_data; {data_in.fano(neuron_i).raw.(trial_type_label)}];
        plot_fano_label = [plot_fano_label; {[int2str(trial_type_i) '_' (trial_type_label)]}];
        plot_category_label = [plot_category_label; master_datatable_bf.task(neuron_i)];
        
    end
end


%% Figure: generate figure
% Generate plot using gramm
clear figure_plot

% Example neuron: raster
figure_plot(1,1)=gramm('x',plot_example_spk_data,'color',plot_example_label);
figure_plot(1,1).geom_raster();
figure_plot(1,1).axe_property('XLim',xlim_input);
figure_plot(1,1).set_names('x','Time from CS Onset (ms)','y','Trial');
% figure_plot(1,1).set_color_options('map',{color_scheme_CS, color_scheme_timing, color_scheme_trace});
figure_plot(1,1).geom_vline('xintercept',0,'style','k-');
figure_plot(1,1).geom_vline('xintercept',1500,'style','k-');
figure_plot(1,1).facet_grid([],plot_example_category_label,'scale','free_y');
figure_plot(1,1).no_legend;

% Example neuron: spike density function
figure_plot(2,1)=gramm('x',plot_time,'y',plot_example_sdf_data,'color',plot_example_label);
figure_plot(2,1).stat_summary();
figure_plot(2,1).axe_property('XLim',xlim_input,'YLim',[0 75]);
figure_plot(2,1).set_names('x','Time from CS Onset (ms)','y','Firing rate (spk/sec)');
% figure_plot(2,1).set_color_options('map',color_scheme);
figure_plot(2,1).geom_vline('xintercept',0,'style','k-');
figure_plot(2,1).geom_vline('xintercept',1500,'style','k-');
figure_plot(2,1).facet_grid([],plot_example_category_label);
figure_plot(2,1).no_legend;

% Population: spike density function
figure_plot(3,1)=gramm('x',plot_time,'y',plot_sdf_data,'color',plot_label);
figure_plot(3,1).stat_summary();
figure_plot(3,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
figure_plot(3,1).set_names('x','Time from CS Onset (ms)','y','Firing rate (spk/sec)');
% figure_plot(3,1).set_color_options('map',color_scheme);
figure_plot(3,1).geom_vline('xintercept',0,'style','k-');
figure_plot(3,1).geom_vline('xintercept',1500,'style','k-');
figure_plot(3,1).facet_grid([],plot_category_label);
figure_plot(3,1).no_legend;

% Fano factor
figure_plot(4,1)=gramm('x',data_in.fano(1).time,'y',plot_fano_data,'color',plot_fano_label);
figure_plot(4,1).stat_summary();
figure_plot(4,1).axe_property('XLim',xlim_input,'YLim',[0 2]);
figure_plot(4,1).set_names('x','Time from CS Onset (ms)','y','Fano Factor');
% figure_plot(4,1).set_color_options('map',color_scheme);
figure_plot(4,1).geom_vline('xintercept',0,'style','k-');
figure_plot(4,1).geom_vline('xintercept',1500,'style','k-');
figure_plot(4,1).geom_hline('yintercept',1,'style','k--');
figure_plot(4,1).facet_grid([],plot_category_label);
figure_plot(4,1).no_legend;

figure_plot_out = figure('Renderer', 'painters', 'Position', [100 100 1200 900]);
figure_plot.draw();

% %% Output
% % Once we're done with a page, save it and close it.
% filename = fullfile(dirs.root,'results','sdf_fano_timingtask_figure_populations.pdf');
% set(figure_plot_out,'PaperSize',[20 10]); %set the paper size to what you want
% print(figure_plot_out,filename,'-dpdf') % then print it
% close(figure_plot_out)

