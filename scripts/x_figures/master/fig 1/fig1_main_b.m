clear figure_plot

%% Parameter: define figure parameters
% Trial types to plot:
trialtype_plot.cs = {'prob0_punish','prob50_punish','prob100_punish'};
% trialtype_plot.cs = {'uncertain','certain'};
trialtype_plot.trace = {'timingcue_uncertain','notrace_uncertain','timingcue_certain','notrace_certain'};
% trialtype_plot.trace = {'notrace_uncertain','notrace_certain'};

% Colors for plot:
colors.cs_task = cool(length(trialtype_plot.cs));
colors.trace_task = winter(length(trialtype_plot.trace));

% Layout positions:
eRaster_start_height = 0.8; eRaster_height = 0.1;
eSDF_start_height = 0.7; eSDF_height = 0.1;
eFano_start_height = 0.6; eFano_height = 0.05;
popSDF_start_height = 0.35; popSDF_height = 0.2;
popFano_start_height = 0.25; popFano_height = 0.075;
% Layout note: 'Position',[L B W H] = [Left Bottom Width Height]

cs_subcolumn_leftRef_bf = 0.05; cs_subcolumn_width_bf = 0.1; cs_subcolumn_gap = 0.005;
trace_subcolumn_leftRef = 0.275; trace_subcolumn_width = (cs_subcolumn_width_bf*2)+cs_subcolumn_gap;
cs_bg_subcolumn_leftRef = 0.55; cs_bg_subcolumn_width = (cs_subcolumn_width_bf*2)+cs_subcolumn_gap;
trace_bg_subcolumn_leftRef = 0.775; trace_bg_subcolumn_width = (cs_subcolumn_width_bf*2)+cs_subcolumn_gap;

%% Analysis: figure data extraction
fig1_cs_basalforebrain
fig1_trace_basalforebrain
fig1_cs_basalganglia
fig1_trace_basalganglia

%% Figure: Setup figure layout
fig1_format

%% Generate: create figure
figure_plot_out = figure('Renderer', 'painters', 'Position', [100 100 1000 600]);
figure_plot.draw();

% Output: save figure
filename = fullfile(dirs.root,'results','master_fig1_trace_cs_bf_bg.pdf');
set(figure_plot_out,'PaperSize',[20 10]); %set the paper size to what you want
print(figure_plot_out,filename,'-dpdf') % then print it
close(figure_plot_out)