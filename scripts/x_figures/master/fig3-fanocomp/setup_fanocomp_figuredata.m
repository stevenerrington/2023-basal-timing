
%% (1) Phasic x ramping ---------------------------------------------
% Define analysis time window 
params.fano.timewindow = 0:500;

% > Define data for comparison
clear input_data input_trials input_labels
input_data = {bf_data_CS(bf_datasheet_CS.cluster_id == 1,:),bf_data_CS(bf_datasheet_CS.cluster_id == 2,:)};
input_trials = {'uncertain','uncertain'};
input_labels = {'1_phasic','2_ramping'};

% > Generate figure
params.plot.ylim = [0 3]; params.plot.colormap = parula(2);
[~,fano_figure_data.bf_phasic_x_ramping] = plot_compare_fano_c(input_data,input_trials,input_labels,params);

%% (2) Certain x Uncertain (BF) ---------------------------------------------
params.fano.timewindow = -500:0;
params.fano.cs_switch = bf_datasheet_CS.site(bf_datasheet_CS.cluster_id == 2,:);

% > Define data for comparison
clear input_data input_trials input_labels
input_data = {bf_data_CS(bf_datasheet_CS.cluster_id == 2,:),bf_data_CS(bf_datasheet_CS.cluster_id == 2,:)};
input_trials = {'certain','uncertain'};
input_labels = {'1_certain','2_uncertain'};

% > Generate figure
params.plot.ylim = [0 3]; params.plot.colormap = parula(2);
[~,fano_figure_data.bf_certain_x_uncertain] = plot_compare_fano_b(input_data,input_trials,input_labels,params);
params.fano = rmfield( params.fano , 'cs_switch' );

%% (3) Delivered x Omitted ---------------------------------------------
params.fano.timewindow = 0:500;
params.fano.cs_switch = bf_datasheet_CS.site(bf_datasheet_CS.cluster_id == 2,:);

% > Define data for comparison
clear input_data input_trials input_labels
input_data = {bf_data_CS(bf_datasheet_CS.cluster_id == 2,:),bf_data_CS(bf_datasheet_CS.cluster_id == 2,:)};
input_trials = {'prob50d','prob50nd'};
input_labels = {'1_delivered','2_nondelivered'};

% > Generate figure
params.plot.ylim = [0 3]; params.plot.colormap = parula(2);
[~,fano_figure_data.bf_delivered_x_nondelivered] = plot_compare_fano_b(input_data,input_trials,input_labels,params);
params.fano = rmfield( params.fano , 'cs_switch' );

%% (4) BF x Striatum ---------------------------------------------
params.fano.timewindow = 0:500;

% > Define data for comparison
clear input_data input_trials input_labels
input_data = {bf_data_CS(bf_datasheet_CS.cluster_id == 2,:),striatum_data_CS};
input_trials = {'uncertain','uncertain'};
input_labels = {'1_bf','2_striatum'};

% > Generate figure
params.plot.ylim = [0 3]; params.plot.colormap = parula(2);
[~,fano_figure_data.bf_x_bg] = plot_compare_fano_c(input_data,input_trials,input_labels,params);

%% (5) Certain x Uncertain (BG) ---------------------------------------------
params.fano.timewindow = 0:500;

% > Define data for comparison
clear input_data input_trials input_labels
input_data = {striatum_data_CS,striatum_data_CS};
input_trials = {'certain','uncertain'};
input_labels = {'1_certain','2_uncertain'};

% > Generate figure
params.plot.ylim = [0 3]; params.plot.colormap = parula(2);
[~,fano_figure_data.bg_certain_x_uncertain] = plot_compare_fano_b(input_data,input_trials,input_labels,params);

%% (6) Delivered x Omitted (BG) ---------------------------------------------
params.fano.timewindow = 0:500;
params.fano.cs_switch = repmat({'wustl'},size(striatum_data_CS,1),1);

% > Define data for comparison
clear input_data input_trials input_labels
input_data = {striatum_data_CS,striatum_data_CS};
input_trials = {'prob50d','prob50nd'};
input_labels = {'1_delivered','2_nondelivered'};

% > Generate figure
params.plot.ylim = [0 3]; params.plot.colormap = parula(2);
[~,fano_figure_data.bg_delivered_x_nondelivered] = plot_compare_fano_b(input_data,input_trials,input_labels,params);
params.fano = rmfield( params.fano , 'cs_switch' );
