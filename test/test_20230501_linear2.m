% > CS task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
plot_trial_types = {'certain','uncertain'};
params.plot.colormap = [2, 59, 56; 197, 39, 108]./255;

%% > Plot example ramping neuron in the basal forebrain.
params.plot.xlim = [-500 3500]; params.plot.ylim = [0 60];

params.plot.xlim = [0 1500]; params.plot.xintercept = 1500;
[~, ~,bf_example_CS1500_ramping] = plot_example_neuron(bf_data_1500_ramping,plot_trial_types,params,16,0);

params.plot.xlim = [0 2500]; params.plot.xintercept = 2500;
[~, ~, bf_example_CS2500_ramping] = plot_example_neuron(bf_data_2500_ramping,plot_trial_types,params,5,0);

%% > Plot population ramping neurons
%  Plot population averaged ramping neuron activity in the basal forebrain (NIH subset).

params.plot.xlim = [-100 1500]; params.plot.ylim = [-2 4]; params.plot.xintercept = 1500;
data_in_plot = []; data_in_plot = bf_data_1500_ramping;
[~, ~, bf_pop_CS1500_ramping] = plot_population_neuron(data_in_plot,plot_trial_types,params,0);

params.plot.xlim = [-100 2500]; params.plot.ylim = [-2 4]; params.plot.xintercept = 2500;
data_in_plot = []; data_in_plot = bf_data_2500_ramping;
[~, ~, bf_pop_CS2500_ramping] = plot_population_neuron(data_in_plot,plot_trial_types,params,0);


%% Generate master figure (w/layout)

figure_data = [bf_example_CS1500_ramping; bf_pop_CS1500_ramping; bf_example_CS2500_ramping; bf_pop_CS2500_ramping];

figure_data(1,1).set_layout_options('Position',[0.1 0.9 0.3 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_data(2,1).set_layout_options('Position',[0.1 0.7 0.3 0.175],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_data(3,1).set_layout_options('Position',[0.1 0.6 0.3 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_data(4,1).set_layout_options('Position',[0.99 0.2 0.4 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_data(5,1).set_layout_options('Position',[0.99 0.1 0.5 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_data(6,1).set_layout_options('Position',[0.1 0.5 0.5 0.025],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_data(7,1).set_layout_options('Position',[0.1 0.3 0.5 0.175],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_data(8,1).set_layout_options('Position',[0.1 0.2 0.5 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_data(9,1).set_layout_options('Position',[0.99 0.2 0.4 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_data(10,1).set_layout_options('Position',[0.99 0.1 0.4 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

for i = [1:4,6:9]
    figure_data(i,1).axe_property('XTick',[],'XColor',[1 1 1]);
    if i > 5
        figure_data(i,1).axe_property('YTick',[],'YColor',[1 1 1]);
    end
            figure_data(10,1).axe_property('YTick',[],'YColor',[1 1 1]);

end
%%
figure('Renderer', 'painters', 'Position', [100 100 600 600]);
figure_data.draw




