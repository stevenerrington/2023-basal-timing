%% Analysis: epoched Fano Factor
% In progress - 1539, Feb 1st
clear epoch
epoch.fixation = [0:200]; epoch.preCS = [-200:0]; epoch.postCS = [0:200];
epoch.midCS = [650:850]; epoch.preOutcome = [-200:0]; epoch.postOutcome = [0:200];

epoch_zero.fixation = [-1000 -1000]; epoch_zero.preCS = [0 0]; epoch_zero.postCS = [0 0];
epoch_zero.midCS = [0 0]; epoch_zero.preOutcome = [2500 2500]; epoch_zero.postOutcome = [2500 2500];

epoch_labels = fieldnames(epoch);
epoch_labels = epoch_labels(2:end); % Remove the fixation period

clear fano_prob* sdf_prob*

params.plot.colormap_bf = [247 154 154; 244 107 107; 240 59 59; 230 18 18; 182 14 14]./255;
params.plot.colormap_stri = [221 153 204; 204 85 153; 170 51 102; 85 34 51; 34 17 17]./255;


for area_i = 1:2
    
    clear data_in datasheet_in
    switch area_i
        case 1
            data_in = bf_data_traceExp;
            datasheet_in = bf_datasheet_traceExp;
            site_id = 1;
        case 2
            data_in = striatum_data_traceExp;
            datasheet_in = striatum_datasheet_traceExp;
            site_id = 1;
    end
    
            
    for neuron_i = 1:size(data_in,1)
        
        
        baseline_fr_mean = nanmean(nanmean(data_in.sdf{neuron_i}...
            ([data_in.trials{neuron_i}.uncertain,data_in.trials{neuron_i}.certain, data_in.trials{neuron_i}.notrace_certain, data_in.trials{neuron_i}.notrace_uncertain],...
            5001+[-1000:3500])));
        baseline_fr_std = nanstd(nanmean(data_in.sdf{neuron_i}...
            ([data_in.trials{neuron_i}.uncertain,data_in.trials{neuron_i}.certain, data_in.trials{neuron_i}.notrace_certain, data_in.trials{neuron_i}.notrace_uncertain],...
            5001+[-1000:3500])));
        
        for epoch_i = 1:length(epoch_labels)
            fano_continuous = [];
            fano_continuous = find(ismember(data_in.fano(neuron_i).time,...
                epoch.(epoch_labels{epoch_i})+epoch_zero.(epoch_labels{epoch_i})(site_id)));
            
            
            fano_trace_uncertain(neuron_i,epoch_i,area_i) = nanmean(data_in.fano(neuron_i).raw.uncertain(fano_continuous));
            fano_trace_certain(neuron_i,epoch_i,area_i) = nanmean(data_in.fano(neuron_i).raw.certain(fano_continuous));
            fano_notrace_uncertain(neuron_i,epoch_i,area_i) = nanmean(data_in.fano(neuron_i).raw.notrace_uncertain(fano_continuous));
            fano_notrace_certain(neuron_i,epoch_i,area_i) = nanmean(data_in.fano(neuron_i).raw.notrace_certain(fano_continuous));
            
            sdf_trace_uncertain(neuron_i,epoch_i,area_i) = nanmean(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.uncertain,...
                [5001+epoch.(epoch_labels{epoch_i})+epoch_zero.(epoch_labels{epoch_i})(site_id)])));
            sdf_trace_certain(neuron_i,epoch_i,area_i) = nanmean(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.certain,...
                5001+epoch.(epoch_labels{epoch_i})+epoch_zero.(epoch_labels{epoch_i})(site_id))));
            sdf_notrace_uncertain(neuron_i,epoch_i,area_i) = nanmean(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.notrace_uncertain,...
                5001+epoch.(epoch_labels{epoch_i})+epoch_zero.(epoch_labels{epoch_i})(site_id))));
            sdf_notrace_certain(neuron_i,epoch_i,area_i) = nanmean(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.notrace_certain,...
                5001+epoch.(epoch_labels{epoch_i})+epoch_zero.(epoch_labels{epoch_i})(site_id))));
            
        end
    end
    
end

%% Configure data
% Fano: Basal forebrain
fano_trace_uncertain_bf = nanmean(fano_trace_uncertain(:,:,1));
fano_trace_certain_bf = nanmean(fano_trace_certain(:,:,1));
fano_notrace_uncertain_bf = nanmean(fano_notrace_uncertain(:,:,1));
fano_notrace_certain_bf = nanmean(fano_notrace_certain(:,:,1));
fano_all_bf = [fano_notrace_uncertain_bf; fano_notrace_certain_bf; fano_trace_uncertain_bf; fano_trace_certain_bf];

% Fano: Striatum
fano_trace_uncertain_stri = nanmean(fano_trace_uncertain(:,:,2));
fano_trace_certain_stri = nanmean(fano_trace_certain(:,:,2));
fano_notrace_uncertain_stri = nanmean(fano_notrace_uncertain(:,:,2));
fano_notrace_certain_stri = nanmean(fano_notrace_certain(:,:,2));
fano_all_striatum = [fano_notrace_uncertain_stri; fano_notrace_certain_stri; fano_trace_uncertain_stri; fano_trace_certain_stri];

% SDF: Basal forebrain
sdf_trace_uncertain_bf = nanmean(sdf_trace_uncertain(1:9,:,1));
sdf_trace_certain_bf = nanmean(sdf_trace_certain(1:9,:,1));
sdf_notrace_uncertain_bf = nanmean(sdf_notrace_uncertain(1:9,:,1));
sdf_notrace_certain_bf = nanmean(sdf_notrace_certain(1:9,:,1));
sdf_all_bf = [sdf_trace_uncertain_bf; sdf_trace_certain_bf; sdf_notrace_uncertain_bf; sdf_notrace_certain_bf];

% SDF: Striatum
sdf_trace_uncertain_striatum = nanmean(sdf_trace_uncertain(:,:,2));
sdf_trace_certain_striatum = nanmean(sdf_trace_certain(:,:,2));
sdf_notrace_uncertain_striatum = nanmean(sdf_notrace_uncertain(:,:,2));
sdf_notrace_certain_striatum = nanmean(sdf_notrace_certain(:,:,2));
sdf_all_striatum = [sdf_trace_uncertain_striatum; sdf_trace_certain_striatum; sdf_notrace_uncertain_striatum; sdf_notrace_certain_striatum];


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
spider_plot_legend = legend({'trace_uncertain','trace_certain','notrace_uncertain','notrace_certain'}, 'Location', 'SouthOutside','Orientation','Horizontal');
spider_plot_legend.NumColumns = 3;
title('SDF: BF')

subplot(2,2,2)
spider_plot(fano_all_bf,...
    'AxesLabels', epoch_labels,...
    'AxesLimits', [repmat(0,1,length(epoch_labels)); repmat(3,1,length(epoch_labels))],... % [min axes limits; max axes limits]
    'AxesPrecision', repmat(AxesPrecision,1,length(epoch_labels)),...
    'AxesInterval', 3, 'Color',flipud(params.plot.colormap_bf), 'LineWidth', 0.5, 'FillOption', 'on', 'MarkerSize', MarkerSize_p);
spider_plot_legend = legend({'trace_uncertain','trace_certain','notrace_uncertain','notrace_certain'}, 'Location', 'SouthOutside','Orientation','Horizontal');
spider_plot_legend.NumColumns = 3;
title('Fano: BF')

subplot(2,2,3)
spider_plot(sdf_all_striatum,...
    'AxesLabels', epoch_labels,...
    'AxesLimits', [repmat(0,1,length(epoch_labels)); repmat(80,1,length(epoch_labels))],... % [min axes limits; max axes limits]
    'AxesPrecision', repmat(AxesPrecision,1,length(epoch_labels)),...
    'AxesInterval', 4, 'Color',flipud(params.plot.colormap_stri), 'LineWidth', 0.5, 'FillOption', 'on', 'MarkerSize', MarkerSize_p);
spider_plot_legend = legend({'trace_uncertain','trace_certain','notrace_uncertain','notrace_certain'}, 'Location', 'SouthOutside','Orientation','Horizontal');
spider_plot_legend.NumColumns = 3;
title('FR: Striatum')

subplot(2,2,4)
spider_plot(fano_all_striatum,...
    'AxesLabels', epoch_labels,...
    'AxesLimits', [repmat(0,1,length(epoch_labels)); repmat(3,1,length(epoch_labels))],... % [min axes limits; max axes limits]
    'AxesPrecision', repmat(AxesPrecision,1,length(epoch_labels)),...
    'AxesInterval', 3, 'Color',flipud(params.plot.colormap_stri), 'LineWidth', 0.5, 'FillOption', 'on', 'MarkerSize', MarkerSize_p);
spider_plot_legend = legend({'trace_uncertain','trace_certain','notrace_uncertain','notrace_certain'}, 'Location', 'SouthOutside','Orientation','Horizontal');
spider_plot_legend.NumColumns = 3;
title('Fano: Striatum')

