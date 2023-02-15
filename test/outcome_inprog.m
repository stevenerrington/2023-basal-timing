% Input variables
data_in = []; data_in = bf_data_CS;
plot_trial_types = {'prob25d','prob25nd','prob50d','prob50nd','prob75d','prob75nd'};

xlim_input = [-100 500];
ylim_input = [-20 30];

% Initialize plot data structures
plot_sdf_data = []; plot_fano_data = []; plot_fano_label = []; plot_category_label = []; plot_label = [];
plot_time = [-1000:2000];
time_zero = 5000;
color_scheme = cool(length(plot_trial_types));
baseline_win = [-500:-250];

for neuron_i = 1:size(data_in,1)
    
    bl_fr_mean = nanmean(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.probAll,baseline_win+time_zero)));
    bl_fr_std = nanstd(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.probAll,baseline_win+time_zero)));
    
    
    for trial_type_i = 1:length(plot_trial_types)
        trial_type_label = plot_trial_types{trial_type_i};
        trials_in = []; trials_in = data_in.trials{neuron_i}.(trial_type_label);
        n_trls = size(trials_in,2);
        
        switch bf_datasheet_CS.site{neuron_i}
            case 'wustl'
                sdf_timewindow = plot_time + time_zero + 2500;
            case 'nih'
                sdf_timewindow = plot_time + time_zero + 1500;
        end
       
        
        sdf_x = []; sdf_x = (nanmean(data_in.sdf{neuron_i}(trials_in,sdf_timewindow))-bl_fr_mean)./bl_fr_std;
        
        if any(isinf(sdf_x)) | length(sdf_x) == 1 
            sdf_x = nan(1,length(plot_time));
        end
            
        plot_sdf_data = [plot_sdf_data ; num2cell(sdf_x,2)]; % num2cell(sdf_x,2)];
        plot_label = [plot_label; {[int2str(trial_type_i) '_' (trial_type_label)]}];
        
        fano_window = find(ismember(data_in.fano(neuron_i).time,sdf_timewindow));
        
        plot_fano_data = [plot_fano_data; {data_in.fano(neuron_i).raw.(trial_type_label)(fano_window)}];
        plot_fano_label = [plot_fano_label; {[int2str(trial_type_i) '_' (trial_type_label)]}];
        
        plot_category_label = [plot_category_label; {bf_datasheet_CS.cluster_label{neuron_i}}];
        
    end
end

% Generate plot using gramm
clear figure_plot

% Ramping %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spike density function
figure_plot(1,1)=gramm('x',plot_time,'y',plot_sdf_data,'color',plot_label,'subset',strcmp(plot_category_label,'Ramping'));
figure_plot(1,1).stat_summary();
figure_plot(1,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
figure_plot(1,1).set_names('x','Time from CS Onset (ms)','y','Firing rate (spk/sec)');
% figure_plot(1,1).set_color_options('map',color_scheme);
figure_plot(1,1).geom_vline('xintercept',0,'style','k-');
figure_plot(1,1).geom_vline('xintercept',1500,'style','k-');
figure_plot(1,1).no_legend;


% > DIVIDE BY P HERE (2 x 3; SDF/Fano x Probs)
% Fano factor
figure_plot(1,2)=gramm('x',plot_time,'y',plot_fano_data,'color',plot_fano_label,'subset',strcmp(plot_category_label,'Ramping'));
figure_plot(1,2).stat_summary();
figure_plot(1,2).axe_property('XLim',xlim_input,'YLim',[0 6]);
figure_plot(1,2).set_names('x','Time from CS Onset (ms)','y','Fano Factor');
% figure_plot(1,2).set_color_options('map',color_scheme);
figure_plot(1,2).geom_vline('xintercept',0,'style','k-');
figure_plot(1,2).geom_vline('xintercept',1500,'style','k-');
figure_plot(1,2).geom_hline('yintercept',1,'style','k--');
figure_plot(1,2).no_legend;

figure_plot_out = figure('Renderer', 'painters', 'Position', [100 100 800 300]);
figure_plot.draw();

% %% Output
% % Once we're done with a page, save it and close it.
% filename = fullfile(dirs.root,'results','test.pdf');
% set(figure_plot_out,'PaperSize',[20 10]); %set the paper size to what you want
% print(figure_plot_out,filename,'-dpdf') % then print it
% close(figure_plot_out)

