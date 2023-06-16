% Basal Forebrain: WUSTL CS task
params.plot.xintercept = 2500;
params.eye.zero = find(params.eye.alignWin == 0);
params.eye.salience_window = params.eye.zero+2500+[-200:0];

data_in = []; data_in = [bf_data_traceExp; striatum_data_traceExp];

% > Trace task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
plot_trial_types = {'notrace_uncertain','notrace_certain','uncertain','certain'};
% params.plot.colormap = [[0 70 67]./255;[242 165 65]./255];
params.plot.colormap = [127 191 185; 8 140 133; 193 140 190; 131 40 133]./255;
[~, ~, mean_gaze_array_trace, time_gaze_window_trace]  =...
    get_pgaze_window(data_in, plot_trial_types, params);
trace_eyegaze_data = plot_eyegaze(mean_gaze_array_trace,time_gaze_window_trace,params);
close all

%% Figure: Generate Figure
clear figure_plot
figure_plot(1,1)=gramm('x',params.eye.alignWin,'y',trace_eyegaze_data.data_in,'color',trace_eyegaze_data.label_in);
figure_plot(1,1).stat_summary();
figure_plot(1,1).axe_property('XLim',[-1000 3000],'YLim',[0 1]);
figure_plot(1,1).set_names('x','Time from CS Onset (ms)','y','P(Gaze at CS)');
figure_plot(1,1).geom_vline('xintercept',0,'style','k-');
figure_plot(1,1).geom_vline('xintercept',params.plot.xintercept,'style','k-');
figure_plot(1,1).set_color_options('map',params.plot.colormap)
figure_plot(1,1).no_legend()

figure_plot(1,2)=gramm('x',trace_eyegaze_data.label_in,'y',trace_eyegaze_data.mean_gaze_window,'color',trace_eyegaze_data.label_in);
figure_plot(1,2).stat_summary('geom',{'bar','errorbar'},'width',3);
figure_plot(1,2).axe_property('YLim',[0 1]);
figure_plot(1,2).set_names('x','Condition','y','P(Gaze at CS)');
figure_plot(1,2).set_color_options('map',params.plot.colormap)
figure_plot(1,2).no_legend()

figure_plot(1,1).set_layout_options('Position',[0.1 0.2 0.5 0.7],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);
figure_plot(1,2).set_layout_options('Position',[0.7 0.2 0.2 0.7],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure('Renderer', 'painters', 'Position', [100 100 800 300]);
figure_plot.draw