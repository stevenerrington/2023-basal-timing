%% Setup: define parameters and input
% Figure parameters:
params.plot.xlim = [-100 500]; params.plot.ylim = [-2 4];
%params.plot.colormap = [0 0 0; 1 0 0]; % black and red
params.plot.colormap = [101 142 156; 239 35 60]./255;

% Layout positions:
popSDF_bf_start_height = 0.65; popSDF_height = 0.25;
fano_bf_start_height = 0.55; fano_height = 0.08;

popSDF_bg_start_height = 0.20;
fano_bg_start_height = 0.10; 

% Layout note: 'Position',[L B W H] = [Left Bottom Width Height]
CS_column_refpos = 0.1; cs_column_width = 0.4;
trace_column_refpos = 0.60; trace_column_width = 0.3;

% Trial types:
clear plot_trial_types
plot_trial_types.cs = {'prob25nd','prob25d','prob50nd','prob50d','prob75nd','prob75d'};
plot_trial_types.trace = {'notimingcue_uncertain_nd','notimingcue_uncertain_d',...
    'timingcue_uncertain_nd','timingcue_uncertain_d'};

%% Analysis: figure data extraction
clear figure_plot

% Basal forebrain: CS task
figure_plot_bf_cs = plot_population_CSoutcome(bf_data_CS(bf_datasheet_CS.cluster_id == 2,:),bf_datasheet_CS, plot_trial_types.cs,params,[1 2]);
% Basal ganglia: CS task
figure_plot_bg_cs = plot_population_CSoutcome(striatum_data_CS,striatum_datasheet_CS, plot_trial_types.cs,params,[1 2]);
% Basal forebrain: trace task
figure_plot_bf_trace = plot_population_traceoutcome(bf_data_traceExp, plot_trial_types.trace,params);
% Basal ganglia: CS task
figure_plot_bg_trace = plot_population_traceoutcome(striatum_data_traceExp, plot_trial_types.trace,params);


figure_plot = [figure_plot_bf_cs;figure_plot_bg_cs; figure_plot_bf_trace; figure_plot_bg_trace];

%% Figure: Setup figure layout (move to separate script when done)
% CS task/basal forebrain - SDF ----------------------
figure_plot(1,1).set_layout_options('Position',[CS_column_refpos popSDF_bf_start_height cs_column_width popSDF_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% CS task/basal forebrain - Fano ----------------------
figure_plot(2,1).set_layout_options('Position',[CS_column_refpos fano_bf_start_height cs_column_width fano_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.0],...
    'redraw',false);

% CS task/basal ganglia - SDF ----------------------
figure_plot(3,1).set_layout_options('Position',[CS_column_refpos popSDF_bg_start_height cs_column_width popSDF_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% CS task/basal ganglia - Fano ----------------------
figure_plot(4,1).set_layout_options('Position',[CS_column_refpos fano_bg_start_height cs_column_width fano_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.0],...
    'redraw',false);

% Trace task/basal forebrain - Fano ----------------------
figure_plot(5,1).set_layout_options('Position',[trace_column_refpos popSDF_bf_start_height trace_column_width popSDF_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% Trace task/basal forebrain - Fano ----------------------
figure_plot(6,1).set_layout_options('Position',[trace_column_refpos fano_bf_start_height trace_column_width fano_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.0],...
    'redraw',false);

% CS task/basal ganglia - SDF ----------------------
figure_plot(7,1).set_layout_options('Position',[trace_column_refpos popSDF_bg_start_height trace_column_width popSDF_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% CS task/basal ganglia - Fano ----------------------
figure_plot(8,1).set_layout_options('Position',[trace_column_refpos fano_bg_start_height trace_column_width fano_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.0],...
    'redraw',false);

for subplot_i = [2 6]
    figure_plot(subplot_i,1).axe_property('XTick',[],'XColor',[1 1 1]);
end


%% Generate: Create figure

figure_plot_out = figure('Renderer', 'painters', 'Position', [100 100 1000 600]);
figure_plot.draw;

% Output: save figure
filename = fullfile(dirs.root,'results','master_fig2_trace_cs_bf_bg.pdf');
set(figure_plot_out,'PaperSize',[20 10]); %set the paper size to what you want
print(figure_plot_out,filename,'-dpdf') % then print it
close(figure_plot_out)