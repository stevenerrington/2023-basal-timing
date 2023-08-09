%% Analysis: epoched Fano Factor
% In progress - 1539, Feb 1st
clear epoch
epoch.fixation = [0:200]; epoch.preCS = [-200:0]; epoch.postCS = [0:200];
epoch.midCS = [650:850]; epoch.preOutcome = [-200:0]; epoch.postOutcome = [0:200];

epoch_zero.fixation = [-1000 -1000]; epoch_zero.preCS = [0 0]; epoch_zero.postCS = [0 0];
epoch_zero.midCS = [0 0]; epoch_zero.preOutcome = [1500 2500]; epoch_zero.postOutcome = [1500 2500];

epoch_labels = fieldnames(epoch);
epoch_labels = epoch_labels(2:end); % Remove the fixation period

clear fano_prob* sdf_prob*

params.plot.colormap_bf = [247 154 154; 244 107 107; 240 59 59; 230 18 18; 182 14 14]./255;
params.plot.colormap_stri = [221 153 204; 204 85 153; 170 51 102; 85 34 51; 34 17 17]./255;


for area_i = 1:2
    
    clear data_in datasheet_in
    switch area_i
        case 1
            data_in = bf_data_CS;
            datasheet_in = bf_datasheet_CS;
        case 2
            data_in = striatum_data_CS;
            datasheet_in = striatum_datasheet_CS;
    end
    
            
    for neuron_i = 1:size(data_in,1)
        
        switch datasheet_in.site{neuron_i}
            case 'wustl'
                site_id = 2;
            case 'nih'
                site_id = 1;
        end
        
        baseline_fr_mean = nanmean(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.probAll,...
            5001+[-1000:3500])));
        baseline_fr_std = nanstd(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.probAll,...
            5001+[-1000:3500])));
        
        for epoch_i = 1:length(epoch_labels)
            fano_continuous = [];
            fano_continuous = find(ismember(data_in.fano(neuron_i).time,...
                epoch.(epoch_labels{epoch_i})+epoch_zero.(epoch_labels{epoch_i})(site_id)));
            
            
            fano_prob100(neuron_i,epoch_i,area_i) = nanmean(data_in.fano(neuron_i).raw.prob100(fano_continuous));
            fano_prob75(neuron_i,epoch_i,area_i) = nanmean(data_in.fano(neuron_i).raw.prob75(fano_continuous));
            fano_prob50(neuron_i,epoch_i,area_i) = nanmean(data_in.fano(neuron_i).raw.prob50(fano_continuous));
            fano_prob25(neuron_i,epoch_i,area_i) = nanmean(data_in.fano(neuron_i).raw.prob25(fano_continuous));
            fano_prob0(neuron_i,epoch_i,area_i) = nanmean(data_in.fano(neuron_i).raw.prob0(fano_continuous));
            
            sdf_prob100(neuron_i,epoch_i,area_i) = nanmean(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.prob100,...
                [5001+epoch.(epoch_labels{epoch_i})+epoch_zero.(epoch_labels{epoch_i})(site_id)])));
            sdf_prob75(neuron_i,epoch_i,area_i) = nanmean(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.prob75,...
                5001+epoch.(epoch_labels{epoch_i})+epoch_zero.(epoch_labels{epoch_i})(site_id))));
            sdf_prob50(neuron_i,epoch_i,area_i) = nanmean(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.prob50,...
                5001+epoch.(epoch_labels{epoch_i})+epoch_zero.(epoch_labels{epoch_i})(site_id))));
            sdf_prob25(neuron_i,epoch_i,area_i) = nanmean(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.prob25,...
                5001+epoch.(epoch_labels{epoch_i})+epoch_zero.(epoch_labels{epoch_i})(site_id))));
            sdf_prob0(neuron_i,epoch_i,area_i) = nanmean(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.prob0,...
                5001+epoch.(epoch_labels{epoch_i})+epoch_zero.(epoch_labels{epoch_i})(site_id))));
            
        end
    end
    
end

%% Configure data
% Fano: Basal forebrain
fano_100_bf = nanmean(fano_prob100(:,:,1));
fano_75_bf = nanmean(fano_prob75(:,:,1));
fano_50_bf = nanmean(fano_prob50(:,:,1));
fano_25_bf = nanmean(fano_prob25(:,:,1));
fano_0_bf = nanmean(fano_prob0(:,:,1));
fano_all_bf = [fano_100_bf; fano_75_bf; fano_50_bf; fano_25_bf; fano_0_bf];

% Fano: Striatum
fano_100_striatum = nanmean(fano_prob100(:,:,2));
fano_75_striatum = nanmean(fano_prob75(:,:,2));
fano_50_striatum = nanmean(fano_prob50(:,:,2));
fano_25_striatum = nanmean(fano_prob25(:,:,2));
fano_0_striatum = nanmean(fano_prob0(:,:,2));
fano_all_striatum = [fano_100_striatum; fano_75_striatum; fano_50_striatum; fano_25_striatum; fano_0_striatum];

% SDF: Basal forebrain
sdf_100_bf = nanmean(sdf_prob100(:,:,1));
sdf_75_bf = nanmean(sdf_prob75(:,:,1));
sdf_50_bf = nanmean(sdf_prob50(:,:,1));
sdf_25_bf = nanmean(sdf_prob25(:,:,1));
sdf_0_bf = nanmean(sdf_prob0(:,:,1));
sdf_all_bf = [sdf_100_bf; sdf_75_bf; sdf_50_bf; sdf_25_bf; sdf_0_bf];

% SDF: Striatum
sdf_100_striatum = nanmean(sdf_prob100(:,:,2));
sdf_75_striatum = nanmean(sdf_prob75(:,:,2));
sdf_50_striatum = nanmean(sdf_prob50(:,:,2));
sdf_25_striatum = nanmean(sdf_prob25(:,:,2));
sdf_0_striatum = nanmean(sdf_prob0(:,:,2));
sdf_all_striatum = [sdf_100_striatum; sdf_75_striatum; sdf_50_striatum; sdf_25_striatum; sdf_0_striatum];


%% Generate figure space
spider_fano_cstask_figure = figure('Renderer', 'painters', 'Position', [100 100 600 600]);

AxesPrecision = 0;
MarkerSize_p = 10;

subplot(2,2,1)
spider_plot(sdf_all_bf,...
    'AxesLabels', epoch_labels,...
    'AxesLimits', [repmat(0,1,length(epoch_labels)); repmat(80,1,length(epoch_labels))],... % [min axes limits; max axes limits]
    'AxesPrecision', repmat(AxesPrecision,1,length(epoch_labels)),...
    'AxesInterval', 4, 'Color',flipud(params.plot.colormap_bf), 'LineWidth', 0.5, 'FillOption', 'on', 'MarkerSize', MarkerSize_p);
spider_plot_legend = legend({'100%','75%','50%','25%','0%'}, 'Location', 'SouthOutside','Orientation','Horizontal');
spider_plot_legend.NumColumns = 3;
title('SDF: BF')

subplot(2,2,2)
spider_plot(fano_all_bf,...
    'AxesLabels', epoch_labels,...
    'AxesLimits', [repmat(0,1,length(epoch_labels)); repmat(3,1,length(epoch_labels))],... % [min axes limits; max axes limits]
    'AxesPrecision', repmat(AxesPrecision,1,length(epoch_labels)),...
    'AxesInterval', 3, 'Color',flipud(params.plot.colormap_bf), 'LineWidth', 0.5, 'FillOption', 'on', 'MarkerSize', MarkerSize_p);
spider_plot_legend = legend({'100%','75%','50%','25%','0%'}, 'Location', 'SouthOutside','Orientation','Horizontal');
spider_plot_legend.NumColumns = 3;
title('Fano: BF')

subplot(2,2,3)
spider_plot(sdf_all_striatum,...
    'AxesLabels', epoch_labels,...
    'AxesLimits', [repmat(0,1,length(epoch_labels)); repmat(80,1,length(epoch_labels))],... % [min axes limits; max axes limits]
    'AxesPrecision', repmat(AxesPrecision,1,length(epoch_labels)),...
    'AxesInterval', 4, 'Color',flipud(params.plot.colormap_stri), 'LineWidth', 0.5, 'FillOption', 'on', 'MarkerSize', MarkerSize_p);
spider_plot_legend = legend({'100%','75%','50%','25%','0%'}, 'Location', 'SouthOutside','Orientation','Horizontal');
spider_plot_legend.NumColumns = 3;
title('FR: Striatum')

subplot(2,2,4)
spider_plot(fano_all_striatum,...
    'AxesLabels', epoch_labels,...
    'AxesLimits', [repmat(0,1,length(epoch_labels)); repmat(3,1,length(epoch_labels))],... % [min axes limits; max axes limits]
    'AxesPrecision', repmat(AxesPrecision,1,length(epoch_labels)),...
    'AxesInterval', 3, 'Color',flipud(params.plot.colormap_stri), 'LineWidth', 0.5, 'FillOption', 'on', 'MarkerSize', MarkerSize_p);
spider_plot_legend = legend({'100%','75%','50%','25%','0%'}, 'Location', 'SouthOutside','Orientation','Horizontal');
spider_plot_legend.NumColumns = 3;
title('Fano: Striatum')

