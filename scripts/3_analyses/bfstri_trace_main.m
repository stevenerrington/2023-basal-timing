function bfstri_trace_main (bf_data_traceExp, ...
    striatum_data_traceExp, params)


%% > Trace task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
plot_trial_types = {'notrace_uncertain','notrace_certain','uncertain','certain'};
% params.plot.colormap = [[0 70 67]./255;[242 165 65]./255];
params.plot.colormap = [127 191 185; 8 140 133; 193 140 190; 131 40 133]./255;
params.plot.xlim = [0 2500];

% Plot population averaged ramping neuron activity in the basal forebrain.
params.plot.ylim = [-3 4]; params.plot.xintercept = [2500];
[~, ~, bf_population_trace_ramping] = plot_population_neuron(bf_data_traceExp,plot_trial_types,params,0);
params.plot.ylim = [-1 6]; params.plot.xintercept = [2500];
[~, ~, striatum_population_trace_ramping] = plot_population_neuron(striatum_data_traceExp,plot_trial_types,params,0);

% Gaze
params.plot.xintercept = 2500;
params.eye.salience_window = params.eye.zero+2500+[-200:0];


data_in = []; data_in = [bf_data_traceExp; striatum_data_traceExp];
plot_trial_types = {'notrace_uncertain','notrace_certain','uncertain','certain'};
[~, ~, mean_gaze_array_trace, time_gaze_window_trace]  =...
    get_pgaze_window(data_in, plot_trial_types, params);
[~, eyetrace_figure] = plot_eyegaze(mean_gaze_array_trace,time_gaze_window_trace,params);





%%
clear figure_plot
figure_plot = [eyetrace_figure;...
    bf_population_trace_ramping;
    striatum_population_trace_ramping]; 


% bf_trace_fr_plot


figure_plot(1,1).set_color_options('map',params.plot.colormap);

%% Arrange figure
% Spike density function/activity
figure_plot(1,1).set_layout_options('Position',[0.1 0.9 0.2 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(2,1).set_layout_options('Position',[0.1 0.6 0.2 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(3,1).set_layout_options('Position',[0.1 0.5 0.2 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(4,1).set_layout_options('Position',[0.1 0.2 0.2 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(5,1).set_layout_options('Position',[0.1 0.1 0.2 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);




for i = [1,2,3,4]
    figure_plot(i,1).axe_property('XTick',[],'XColor',[1 1 1]);
end

for i = [1,2,3,4,5]
    figure_plot(i,1).set_line_options('base_size',0.5);
end
%% Plot figure
figure('Renderer', 'painters', 'Position', [100 100 1000 600]);
figure_plot.draw;