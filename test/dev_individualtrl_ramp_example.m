% Initialize plot data structures
plot_trial_types = {'certain','uncertain'};
params.plot.colormap = [2, 59, 56; 197, 39, 108]./255;
plot_time = [-5000:5000]; max_fr_window = [-250:250];
time_zero = abs(plot_time(1));
neuron_examples = [16, 35];
smooth_factor = 1;

datasheet_in = [bf_datasheet_CS;bf_datasheet_CS2];
data_in = [bf_data_CS;bf_data_CS2];
ramp_idx = find(datasheet_in.cluster_id==2);
datasheet_in = datasheet_in(ramp_idx,:);
data_in = data_in(ramp_idx,:);

baseline_win = [-1000:3500];

clear figure_plot

for neuron_j = 1:length(neuron_examples)
    neuron_i = neuron_examples(neuron_j);
    
    switch datasheet_in.site{neuron_i}
        case 'nih'
            params.plot.xintercept = 1500;
            max_win = params.plot.xintercept + max_fr_window;
            slope_win = params.plot.xintercept + [-params.plot.xintercept+500:0];
            
        case 'wustl'
            params.plot.xintercept = 2500;
            max_win = params.plot.xintercept + max_fr_window;
            slope_win = params.plot.xintercept + [-params.plot.xintercept+500:0];
    end
    
    plot_sdf_data = []; plot_label = []; plot_slope = []; plot_max_fr = [];
    plot_fitted_fr = [];
    
    for trial_type_i = 1:length(plot_trial_types)
        trial_type_label = plot_trial_types{trial_type_i};
        trials_in = []; trials_in = data_in.trials{neuron_i}.(trial_type_label);
        n_trls = size(trials_in,2);
        
        for trial_i = 1:n_trls
            baseline_fr = nanmean(data_in.sdf{neuron_i}(trials_in(trial_i),baseline_win+time_zero));
            peak_fr = max(data_in.sdf{neuron_i}(trials_in(trial_i),max_win+time_zero));
            sdf_x = []; sdf_x = data_in.sdf{neuron_i}(trials_in(trial_i),:);
            sdf_x_norm = []; sdf_x_norm = sdf_x./peak_fr;
            
            slope = []; poly_intersect = [];
            for bootstrap_i = 1:250
                
                sampletimes = []; sampletimes = sort(datasample(slope_win,250));
                sdf_fr = []; sdf_fr = sdf_x(sampletimes+time_zero);
                a = []; a = polyfit(sampletimes,sdf_fr,1);
                
                slope(bootstrap_i) = a(1);
                poly_intersect(bootstrap_i) = a(2);
            end
            
            poly_fitted_trial_fr = (median(slope)*plot_time)+median(poly_intersect);
            poly_fitted_trial_fr_norm = poly_fitted_trial_fr./peak_fr;
            poly_fitted_trial_fr_norm([-4999:0,params.plot.xintercept:5001]+5000)= 0;
            
            plot_fitted_fr = [plot_fitted_fr; num2cell(poly_fitted_trial_fr_norm,2)];
                
            plot_slope = [plot_slope; median(slope)];
            plot_max_fr = [plot_max_fr; peak_fr];
            
            sdf_plot_x = []; sdf_plot_x = smooth(sdf_x_norm,smooth_factor)';
            
            plot_sdf_data = [plot_sdf_data ; num2cell(sdf_plot_x,2)];
            plot_label = [plot_label; {[int2str(trial_type_i) '_' (trial_type_label)]}];
        end
    
    
    end
    
    xlim_input = params.plot.xlim; ylim_input = [-0.5 1.5];
    color_scheme = params.plot.colormap;
    % Spike density function
    figure_plot(1,neuron_j)=gramm('x',plot_time,'y',plot_sdf_data,'color',plot_label,'subset',strcmp(plot_label,'2_uncertain'));
    figure_plot(1,neuron_j).geom_line('alpha',0.1);
    figure_plot(1,neuron_j).stat_summary();
    figure_plot(1,neuron_j).axe_property('XLim',xlim_input,'YLim',ylim_input);
    figure_plot(1,neuron_j).set_names('x','Time from CS Onset (ms)','y','Firing rate (Z-score)');
    figure_plot(1,neuron_j).set_color_options('map',color_scheme);
    figure_plot(1,neuron_j).geom_vline('xintercept',0,'style','k-');
    figure_plot(1,neuron_j).geom_vline('xintercept',params.plot.xintercept,'style','k-');
    figure_plot(1,neuron_j).no_legend;
    
    figure_plot(2,neuron_j)=gramm('x',plot_time,'y',plot_fitted_fr,'color',plot_label,'subset',strcmp(plot_label,'2_uncertain'));
    figure_plot(2,neuron_j).geom_line('alpha',0.1);
    figure_plot(2,neuron_j).stat_summary();
    figure_plot(2,neuron_j).axe_property('XLim',xlim_input,'YLim',[0 1]);
    figure_plot(2,neuron_j).set_names('x','Time from CS Onset (ms)','y','Firing rate (Z-score)');
    figure_plot(2,neuron_j).set_color_options('map',color_scheme);
    figure_plot(2,neuron_j).geom_vline('xintercept',0,'style','k-');
    figure_plot(2,neuron_j).geom_vline('xintercept',params.plot.xintercept,'style','k-');
    figure_plot(2,neuron_j).no_legend;
    
    %
    %
    %     figure_plot(3,neuron_j)=gramm('x',plot_label,'y',plot_slope,'color',plot_label,'subset',strcmp(plot_label,'2_uncertain'));
    %     figure_plot(3,neuron_j).stat_boxplot();
    %     figure_plot(3,neuron_j).geom_jitter();
    %     figure_plot(3,neuron_j).axe_property('YLim',[-0.05 0.075]);
    %
    %     figure_plot(4,neuron_j)=gramm('x',plot_label,'y',plot_max_fr,'color',plot_label,'subset',strcmp(plot_label,'2_uncertain'));
    %     figure_plot(4,neuron_j).stat_boxplot();
    %     figure_plot(4,neuron_j).geom_jitter();
    %     figure_plot(4,neuron_j).axe_property('YLim',[20 120]);
end

figure('Renderer', 'painters', 'Position', [100 100 800 600]);
figure_plot.draw;


