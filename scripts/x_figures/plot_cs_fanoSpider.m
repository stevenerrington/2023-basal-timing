
%% Analysis: epoched Fano Factor
% In progress - 1539, Feb 1st
clear epoch
epoch.fixation = [0 200]; epoch.preCS = [-200 0]; epoch.postCS = [0 200];
epoch.midCS = [650 850]; epoch.preOutcome = [-200 0]; epoch.postOutcome = [0 200];

epoch_zero.fixation = [-1000 -1000]; epoch_zero.preCS = [0 0]; epoch_zero.postCS = [0 0];
epoch_zero.midCS = [0 0]; epoch_zero.preOutcome = [1500 2500]; epoch_zero.postOutcome = [1500 2500];

epoch_labels = fieldnames(epoch);
epoch_labels = epoch_labels(2:end); % Remove the fixation period

clear fano_prob*
fano = struct();
for neuron_i = 1:size(bf_data_CS,1)
    
    switch bf_data_CSsheet.site{neuron_i}
        case 'wustl'
            site_id = 2;
        case 'nih'
            site_id = 1;
    end
    
    for epoch_i = 1:length(epoch_labels)
        
        fano = get_fano_window(bf_data_CS.rasters{neuron_i},...
            bf_data_CS.trials{neuron_i},...
            epoch.(epoch_labels{epoch_i}) + epoch_zero.(epoch_labels{epoch_i})(site_id)); % @ moment, centers on 0
        
        fano_prob100(neuron_i,epoch_i) = fano.window.prob100;
        fano_prob75(neuron_i,epoch_i) = fano.window.prob75;
        fano_prob50(neuron_i,epoch_i) = fano.window.prob50;
        fano_prob25(neuron_i,epoch_i) = fano.window.prob25;
        fano_prob0(neuron_i,epoch_i) = fano.window.prob0;
    end
    
end

%%
AxesPrecision = 0;

% CS (NIH) data:
fano_100_nih = nanmean(fano_prob100(bf_data_CSsheet.cluster_id == 2  & strcmp(bf_data_CSsheet.site,'nih'),:));
fano_75_nih = nanmean(fano_prob75(bf_data_CSsheet.cluster_id == 2 & strcmp(bf_data_CSsheet.site,'nih'),:));
fano_50_nih = nanmean(fano_prob50(bf_data_CSsheet.cluster_id == 2 & strcmp(bf_data_CSsheet.site,'nih'),:));
fano_25_nih = nanmean(fano_prob25(bf_data_CSsheet.cluster_id == 2 & strcmp(bf_data_CSsheet.site,'nih'),:));
fano_0_nih = nanmean(fano_prob0(bf_data_CSsheet.cluster_id == 2 & strcmp(bf_data_CSsheet.site,'nih'),:));
fano_all_nih = [fano_100_nih; fano_75_nih; fano_50_nih; fano_25_nih; fano_0_nih];

% CS (WUSTL) data:
fano_100_wustl_cs = nanmean(fano_prob100(bf_data_CSsheet.cluster_id == 2 & strcmp(bf_data_CSsheet.site,'wustl'),:));
fano_75_wustl_cs = nanmean(fano_prob75(bf_data_CSsheet.cluster_id == 2 & strcmp(bf_data_CSsheet.site,'wustl'),:));
fano_50_wustl_cs = nanmean(fano_prob50(bf_data_CSsheet.cluster_id == 2 & strcmp(bf_data_CSsheet.site,'wustl'),:));
fano_25_wustl_cs = nanmean(fano_prob25(bf_data_CSsheet.cluster_id == 2 & strcmp(bf_data_CSsheet.site,'wustl'),:));
fano_0_wustl_cs = nanmean(fano_prob0(bf_data_CSsheet.cluster_id == 2 & strcmp(bf_data_CSsheet.site,'wustl'),:));
fano_all_wustl = [fano_100_wustl_cs; fano_75_wustl_cs; fano_50_wustl_cs; fano_25_wustl_cs; fano_0_wustl_cs];


%% Generate figure space
spider_fano_cstask_figure = figure('Renderer', 'painters', 'Position', [100 100 800 800]);

% Anteromedial recordings (NIH)
% Spider plot
subplot(2,2,1)
spider_plot(fano_all_nih,...
    'AxesLabels', epoch_labels,...
    'AxesLimits', [repmat(0,1,length(epoch_labels)); repmat(4,1,length(epoch_labels))],... % [min axes limits; max axes limits]
    'AxesPrecision', repmat(AxesPrecision,1,length(epoch_labels)));
spider_plot_legend = legend({'100%','75%','50%','25%','0%'}, 'Location', 'SouthOutside','Orientation','Horizontal');
spider_plot_legend.NumColumns = 3;

title('Anteromedial BF')

% Bar plot
subplot(2,2,3)
bar_plot_fano_nih = [fano_100_nih; fano_75_nih; fano_50_nih; fano_25_nih; fano_0_nih]';
bar(bar_plot_fano_nih)
set(gca,'xticklabel',epoch_labels); set(gca,'TickDir','out');
hline(1, 'k'); ylim([0 4])
spider_plot_legend = legend({'100%','75%','50%','25%','0%'}, 'Location', 'SouthOutside','Orientation','Horizontal');
spider_plot_legend.NumColumns = 3;
xtickangle(45)

% Posterolateral recordings (NIH)
% Spider plot
subplot(2,2,2)
spider_plot(fano_all_wustl,...
    'AxesLabels', epoch_labels,...
    'AxesLimits', [repmat(0,1,length(epoch_labels)); repmat(4,1,length(epoch_labels))],... % [min axes limits; max axes limits]
    'AxesPrecision', repmat(AxesPrecision,1,length(epoch_labels)));
title('Posterolateral BF')
spider_plot_legend = legend({'100%','75%','50%','25%','0%'}, 'Location', 'SouthOutside','Orientation','Horizontal');
spider_plot_legend.NumColumns = 3;

% Bar plot
bar_plot_fano_wustl = [fano_100_wustl_cs; fano_75_wustl_cs; fano_50_wustl_cs; fano_25_wustl_cs; fano_0_wustl_cs]';
subplot(2,2,4)
bar(bar_plot_fano_wustl)
set(gca,'xticklabel',epoch_labels); set(gca,'TickDir','out');
hline(1, 'k'); ylim([0 4])
spider_plot_legend = legend({'100%','75%','50%','25%','0%'}, 'Location', 'SouthOutside','Orientation','Horizontal');
spider_plot_legend.NumColumns = 3;
xtickangle(45)

%%
% Once we're done with a page, save it and close it.
filename = fullfile(dirs.root,'results','spider_fano_cstask_figure.pdf');
set(spider_fano_cstask_figure,'PaperSize',[20 10]); %set the paper size to what you want
print(spider_fano_cstask_figure,filename,'-dpdf') % then print it
close(spider_fano_cstask_figure)

