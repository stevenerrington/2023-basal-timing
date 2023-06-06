
%% Example neurons
% In this section, we plot example neurons from the basal forebrain 
% phasic and ramping) and the striatum during the CS and trace task.
% The top panel will display the SDF, and the bottom will show the
% averaged fano-factor through time

% > CS task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
plot_trial_types = {'prob0','prob25','prob50','prob75','prob100'};
colors.appetitive = [247 154 154; 244 107 107; 240 59 59; 230 18 18; 182 14 14]./255;
params.plot.colormap = colors.appetitive;
example_neuron_i = 4;

% Spike density function --------------------------------------------
% > Onset -----------------------------------------------------------
params.plot.xlim = [0 2500]; params.plot.ylim = [0 60];

% Example
[~,~,striatum_example_CS_ramping_onset] = plot_example_neuron(striatum_data_CS,plot_trial_types,params,example_neuron_i,0);

% Population
params.plot.ylim = [-2 4];
[~,~,striatum_population_CS_ramping_onset] = plot_population_neuron(striatum_data_CS,plot_trial_types,params,0);

% Uncertainty curves --------------------------------------------------
[~, uncertainty_curve_example_point, uncertainty_curve_example_line] =...
    plot_fr_x_uncertain_example(striatum_data_CS,striatum_datasheet_CS,plot_trial_types,params,16,0);
[~, uncertainty_curve_population_point, uncertainty_curve_population_line] =...
    plot_fr_x_uncertain(striatum_data_CS,striatum_datasheet_CS,plot_trial_types,params,0);

% Uncertainty fano
clear figure_plot fano_x_uncertaintyA
params.plot.ylim = [0 2];
[~, fano_x_uncertainty_example] =...
    plot_fano_x_uncertain(striatum_data_CS,striatum_datasheet_CS,plot_trial_types,params,0);
[~, fano_x_uncertainty_population] =...
    plot_fano_x_uncertain(striatum_data_CS,striatum_datasheet_CS,plot_trial_types,params,0);


%% Generate figure
clear figure_plot
figure_plot = [striatum_example_CS_ramping_onset;...
 striatum_population_CS_ramping_onset;...
 uncertainty_curve_example_point; uncertainty_curve_population_point;...
 fano_x_uncertainty_example; fano_x_uncertainty_population;...
 uncertainty_curve_example_line; uncertainty_curve_population_line]; 

% XXXXXXXXXXXXXX
figure_plot(1,1).set_layout_options('Position',[0.1 0.9 0.3 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(2,1).set_layout_options('Position',[0.1 0.6 0.3 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(3,1).set_layout_options('Position',[0.1 0.5 0.3 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(4,1).set_layout_options('Position',[0.1 0.2 0.3 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(5,1).set_layout_options('Position',[0.1 0.1 0.3 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(6,1).set_layout_options('Position',[0.5 0.75 0.2 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);
figure_plot(8,1).set_layout_options('Position',[0.5 0.6 0.2 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(7,1).set_layout_options('Position',[0.5 0.25 0.2 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);
figure_plot(9,1).set_layout_options('Position',[0.5 0.1 0.2 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(10,1).set_layout_options('Position',[0.75 0.75 0.2 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);
figure_plot(11,1).set_layout_options('Position',[0.75 0.25 0.2 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);


% for i = [6]
%     figure_plot(i,1).axe_property('XTick',[],'XColor',[1 1 1]);
%     figure_plot(i,2).axe_property('XTick',[],'XColor',[1 1 1]);
%     figure_plot(i,2).set_names('x','','y','');
% 
% end



% 
for i = [1,2,3,4, 6, 7, 8]
    figure_plot(i,1).axe_property('XTick',[],'XColor',[1 1 1]);
    figure_plot(i,1).set_names('x','');
end


figure('Renderer', 'painters', 'Position', [100 100 600 400]);
figure_plot.draw;


