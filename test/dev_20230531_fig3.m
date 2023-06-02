
% > Trace task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
plot_trial_types = {'notrace_uncertain','notrace_certain','uncertain','certain'};
% params.plot.colormap = [[0 70 67]./255;[242 165 65]./255];
params.plot.colormap = [127 191 185; 8 140 133; 193 140 190; 131 40 133]./255;

% > Plot example ramping neuron in the basal forebrain.
params.plot.xlim = [0 2500]; params.plot.ylim = [20 80];
params.plot.xintercept = 2500;
[~, ~, bf_example_trace_ramping] = plot_example_neuron(bf_data_traceExp,plot_trial_types,params,8,0);
params.plot.xlim = [0 2500]; params.plot.ylim = [0 80];
[~, ~, striatum_example_trace_ramping] = plot_example_neuron(striatum_data_traceExp,plot_trial_types,params,18,0);


% Plot population averaged ramping neuron activity in the basal forebrain.
params.plot.ylim = [-3 4]; params.plot.xintercept = [2500];
[~, ~, bf_population_trace_ramping] = plot_population_neuron(bf_data_traceExp,plot_trial_types,params,0);
params.plot.ylim = [-1 6]; params.plot.xintercept = [2500];
[~, ~, striatum_population_trace_ramping] = plot_population_neuron(striatum_data_traceExp,plot_trial_types,params,0);

params.plot.ylim = [-1 5];
[~, bf_trace_fr_plot] =...
    plot_fr_x_trace(bf_data_traceExp,bf_datasheet_traceExp,plot_trial_types,params,0);
[~, striatum_trace_fr_plot] =...
    plot_fr_x_trace(striatum_data_traceExp,striatum_datasheet_traceExp,plot_trial_types,params,0);


% Get fano factor
params.plot.ylim = [0 2];
% Basal forebrain
[~, bf_trace_fano_plot] =...
    plot_fano_x_uncertain(bf_data_traceExp,bf_datasheet_traceExp,plot_trial_types,params,0);
% Striatum
[~, striatum_trace_fano_plot] =...
    plot_fano_x_uncertain(striatum_data_traceExp,striatum_datasheet_traceExp,plot_trial_types,params,0);



%%
clear figure_plot
figure_plot = [bf_example_trace_ramping, striatum_example_trace_ramping;...
    bf_population_trace_ramping, striatum_population_trace_ramping;...
    bf_trace_fr_plot, striatum_trace_fr_plot;...
    bf_trace_fano_plot, striatum_trace_fano_plot]; 

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


figure_plot(1,2).set_layout_options('Position',[0.4 0.9 0.2 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(2,2).set_layout_options('Position',[0.4 0.6 0.2 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(3,2).set_layout_options('Position',[0.4 0.5 0.2 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(4,2).set_layout_options('Position',[0.4 0.2 0.2 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(5,2).set_layout_options('Position',[0.4 0.1 0.2 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);


for i = [1,2,3,4]
    figure_plot(i,1).axe_property('XTick',[],'XColor',[1 1 1]);
    figure_plot(i,2).axe_property('XTick',[],'XColor',[1 1 1]);
    figure_plot(i,2).set_names('x','','y','');
end

% Average activity (fr and fano) bar plots

figure_plot(6,1).set_layout_options('Position',[0.65 0.6 0.15 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(6,2).set_layout_options('Position',[0.82 0.6 0.15 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(7,1).set_layout_options('Position',[0.65 0.3 0.15 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(7,2).set_layout_options('Position',[0.82 0.3 0.15 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

for i = [6]
    figure_plot(i,1).axe_property('XTick',[],'XColor',[1 1 1]);
    figure_plot(i,2).axe_property('XTick',[],'XColor',[1 1 1]);
    figure_plot(i,2).set_names('x','','y','');
end

%% Plot figure
figure('Renderer', 'painters', 'Position', [100 100 1000 600]);
figure_plot.draw;