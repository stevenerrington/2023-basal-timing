% Input variables
data_in = []; data_in = bf_data_traceExp;
plot_trial_types = {'notimingcue_uncertain','timingcue_uncertain'};

xlim_input = [-500 3500];
ylim_input = [-10 10];

% Initialize plot data structures
plot_sdf_data = [];
plot_fano_data = []; plot_fano_label = [];
plot_category_label = [];
plot_label = [];
plot_time = [-5000:5000];
time_zero = abs(plot_time(1));
color_scheme = [[0 70 67]./255;[242 165 65]./255];
baseline_win = [-500:200];

for neuron_i = 1:size(data_in,1)
    all_prob_trials = [];
    for trial_type_i = 1:length(plot_trial_types)
        all_prob_trials = [all_prob_trials, data_in.trials{neuron_i}.(plot_trial_types{trial_type_i})];
    end
    
    bl_fr_mean = nanmean(nanmean(data_in.sdf{neuron_i}(all_prob_trials,baseline_win+time_zero)));
    bl_fr_std = nanstd(nanmean(data_in.sdf{neuron_i}(all_prob_trials,baseline_win+time_zero)));
    
    
    for trial_type_i = 1:length(plot_trial_types)
        trial_type_label = plot_trial_types{trial_type_i};
        trials_in = []; trials_in = data_in.trials{neuron_i}.(trial_type_label);
        n_trls = size(trials_in,2);
        
        sdf_x = []; sdf_x = (nanmean(data_in.sdf{neuron_i}(trials_in,:))-bl_fr_mean)./bl_fr_std;
        
        % If there aren't enough trials, then we will NaN out the SDF
        if any(isinf(sdf_x)) | length(sdf_x) == 1
            sdf_x = nan(1,length(plot_time));
        end
        
        plot_sdf_data = [plot_sdf_data ; num2cell(sdf_x,2)];
        plot_label = [plot_label; {[int2str(trial_type_i) '_' (trial_type_label)]}];
        
        plot_fano_data = [plot_fano_data; {data_in.fano(neuron_i).raw.(trial_type_label)}];
        plot_fano_label = [plot_fano_label; {[int2str(trial_type_i) '_' (trial_type_label)]}];
        
        
    end
end

% Generate plot using gramm
clear figure_plot

% Ramping %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spike density function
figure_plot(1,1)=gramm('x',plot_time,'y',plot_sdf_data,'color',plot_label);
figure_plot(1,1).stat_summary();
figure_plot(1,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
figure_plot(1,1).set_names('x','Time from CS Onset (ms)','y','Firing rate (spk/sec)');
figure_plot(1,1).set_color_options('map',color_scheme);
figure_plot(1,1).geom_vline('xintercept',0,'style','k-');
figure_plot(1,1).geom_vline('xintercept',2500,'style','k-');
figure_plot(1,1).no_legend;

% Fano factor
figure_plot(2,1)=gramm('x',data_in.fano(1).time,'y',plot_fano_data,'color',plot_fano_label);
figure_plot(2,1).stat_summary();
figure_plot(2,1).axe_property('XLim',xlim_input,'YLim',[0 2]);
figure_plot(2,1).set_names('x','Time from CS Onset (ms)','y','Fano Factor');
figure_plot(2,1).set_color_options('map',color_scheme);
figure_plot(2,1).geom_vline('xintercept',0,'style','k-');
figure_plot(2,1).geom_vline('xintercept',2500,'style','k-');
figure_plot(2,1).geom_hline('yintercept',1,'style','k--');
% figure_plot(2,1).no_legend;

figure_plot_out = figure('Renderer', 'painters', 'Position', [100 100 300 400]);
figure_plot.draw();

%% Output
% Once we're done with a page, save it and close it.
filename = fullfile(dirs.root,'results','sdf_fano_tracetask_figure_populations.pdf');
set(figure_plot_out,'PaperSize',[20 10]); %set the paper size to what you want
print(figure_plot_out,filename,'-dpdf') % then print it
close(figure_plot_out)

