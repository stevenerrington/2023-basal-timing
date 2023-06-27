function get_maxFR_ramping_example(data_in,datasheet_in,trial_type_list,example_neuron_i,params,subplot_idx)

peak_window = params.stats.peak_window;

max_ramp_fr = struct();
max_ramp_fr.all = table();
max_ramp_fr.mean = table();
max_ramp_fr.var = table();


neuron_i = example_neuron_i;

switch datasheet_in.site{neuron_i}
    case 'nih'
        params.plot.xintercept = 1500;
    case 'wustl'
        params.plot.xintercept = 2500;
end

plot_sdf = [];
plot_peak_fr = [];
plot_peak_fr_time = [];
plot_trl_label = [];


for trial_type_i = 1:length(trial_type_list)
    trial_type_in = trial_type_list{trial_type_i};
    trials_in = []; trials_in = data_in.trials{neuron_i,1}.(trial_type_in);
    peak_time = [];
    
    
    averaged_sdf = []; averaged_sdf = nanmean(data_in.sdf{neuron_i,1}(trials_in,:));
    peak_fr = []; peak_fr = max( averaged_sdf(1,5000+params.plot.xintercept+peak_window));
    
    
    if peak_fr > 0
        peak_time_avSDF = find(averaged_sdf == peak_fr,1)-5000;
    else
        peak_time_avSDF = NaN;
    end
    
    
    for trial_i = 1:length(trials_in)
        trial_j = trials_in(trial_i);
        
        trial_sdf = []; trial_sdf = data_in.sdf{neuron_i,1}(trial_j,:);
        peak_fr = []; peak_fr = max( trial_sdf(1,5000+params.plot.xintercept+peak_window));
        
        if peak_fr > 0
            peak_time{trial_i,1} = find(trial_sdf == peak_fr,1)-5000;
        else
            peak_time{trial_i,1} = NaN;
        end
        
        
        plot_sdf = [plot_sdf; trial_sdf];
        plot_peak_fr = [plot_peak_fr; peak_fr];
        plot_peak_fr_time = [plot_peak_fr_time; peak_time{trial_i,1}];
        plot_trl_label = [plot_trl_label; {trial_type_in}];
    end
    
end

%% Figure

omit_trls = find(strcmp(plot_trl_label,'uncert_omit'));
del_trls = find(strcmp(plot_trl_label,'uncert_delivered'));

subplot(2,2,subplot_idx(1)); hold on
imagesc('XData',[-5000:5000],'YData',1:size(omit_trls,1),'CData',plot_sdf(omit_trls,:))
vline(params.plot.xintercept,'w')
scatter(plot_peak_fr_time(omit_trls),1:size(omit_trls,1),'ko','filled')
xlim([params.plot.xintercept-500 params.plot.xintercept+500]); ylim([1 size(omit_trls,1)]); caxis([0 80])
ylabel('Omitted')
colormap(gca, params.plot.colormap);
colorbar;

subplot(2,2,subplot_idx(2)); hold on
imagesc('XData',[-5000:5000],'YData',1:size(del_trls,1),'CData',plot_sdf(del_trls,:))
vline(params.plot.xintercept,'w')
scatter(plot_peak_fr_time(del_trls),1:size(del_trls,1),'ko','filled')
xlim([params.plot.xintercept-500 params.plot.xintercept+500]); ylim([1 size(del_trls,1)]); caxis([0 80])
ylabel('Delivered')
colormap(gca, params.plot.colormap);
colorbar

%% % figure gen
% clear figure_plot
% 
% Spike density function >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% figure_plot(1,1)=gramm('x',plot_peak_fr_time,'color',plot_trl_label);
% figure_plot(1,1).geom_raster();
% figure_plot(1,1).axe_property('XLim',[0 params.plot.xintercept+500]);
% figure_plot(1,1).set_names('x','Time from Outcome (ms)','y','Firing rate (spk/sec)');
% figure_plot(1,1).geom_vline('xintercept',1500,'style','k-');
% figure_plot(1,1).set_color_options('map',params.plot.colormap);
% figure_plot(1,1).no_legend;
% 
% figure_plot(2,1)=gramm('x',[-5000:5000],'y',plot_sdf,'color',plot_trl_label);
% figure_plot(2,1).geom_line('alpha',0.05);
% figure_plot(2,1).axe_property('XLim',[0 params.plot.xintercept+500],'YLim',[0 100]);
% figure_plot(2,1).set_names('x','Time from Outcome (ms)','y','Firing rate (spk/sec)');
% figure_plot(2,1).set_color_options('map',params.plot.colormap);
% figure_plot(2,1).geom_vline('xintercept',1500,'style','k-');
% figure_plot(2,1).no_legend;
% 
% figure_plot(3,1)=gramm('x',plot_peak_fr_time,'y',plot_peak_fr,'color',plot_trl_label);
% figure_plot(3,1).geom_point;
% figure_plot(3,1).axe_property('XLim',[0 params.plot.xintercept+500],'YLim',[0 100]);
% figure_plot(3,1).set_names('x','Time from Outcome (ms)','y','Firing rate (spk/sec)');
% figure_plot(3,1).set_color_options('map',params.plot.colormap);
% figure_plot(3,1).geom_vline('xintercept',1500,'style','k-');
% figure_plot(3,1).no_legend;
% 
% figure_plot(1,1).set_layout_options...
%     ('Position',[0.1 0.85 0.4 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
%     'legend',false,... % No need to display legend for side histograms
%     'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
%     'margin_width',[0.1 0.02],...
%     'redraw',false);
% 
% figure_plot(2,1).set_layout_options...
%     ('Position',[0.1 0.1 0.4 0.6],... %Set the position in the figure (as in standard 'Position' axe property)
%     'legend',false,... % No need to display legend for side histograms
%     'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
%     'margin_width',[0.1 0.02],...
%     'redraw',false);
% 
% figure_plot(3,1).set_layout_options...
%     ('Position',[0.55 0.1 0.4 0.6],... %Set the position in the figure (as in standard 'Position' axe property)
%     'legend',false,... % No need to display legend for side histograms
%     'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
%     'margin_width',[0.1 0.02],...
%     'redraw',false);
% 
% figure('Renderer', 'painters', 'Position', [100 100 600 200]);
% 
% figure_plot.draw()
% 
% 



end