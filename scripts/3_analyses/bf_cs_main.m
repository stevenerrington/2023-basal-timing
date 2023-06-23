function bf_cs_main(bf_data_CS, bf_datasheet_CS, params)

%% Parameters & setup
% % Load in spike removed data
% load(fullfile(dirs.root,'data','large','bf_data_CS_spkRemoved.mat'))
% load(fullfile(dirs.root,'data','large','bf_datasheet_CS.mat'))
% % Clean up to just include ramping neurons
% bf_data_CS = bf_data_CS(bf_datasheet_CS.cluster_id == 2,:);
% bf_datasheet_CS = bf_datasheet_CS(bf_datasheet_CS.cluster_id == 2,:);

%% Example neurons
% In this section, we plot example neurons from the basal forebrain 
% phasic and ramping) and the striatum during the CS and trace task.
% The top panel will display the SDF, and the bottom will show the
% averaged fano-factor through time

% > CS task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% Spike density function --------------------------------------------
example_neuron_i = 16;

% > Onset -----------------------------------------------------------
plot_trial_types = {'probAll'};
params.plot.xlim = [-500 0]; params.plot.ylim = [0 60];
params.plot.colormap = [182 14 14]./255;

% Example
[~,~,bf_example_CS_ramping_preCS] = plot_example_neuron(bf_data_CS,plot_trial_types,params,example_neuron_i,0);

% Population
params.plot.ylim = [-2 4];
[~,~,bf_population_CS_ramping_preCS] = plot_population_neuron(bf_data_CS,plot_trial_types,params,0);


plot_trial_types = {'prob0','prob25','prob50','prob75','prob100'};

% > Onset -----------------------------------------------------------
plot_trial_types = {'prob0','prob25','prob50','prob75','prob100'};
colors.appetitive = [247 154 154; 244 107 107; 240 59 59; 230 18 18; 182 14 14]./255;
params.plot.colormap = colors.appetitive;

params.plot.xlim = [0 500]; params.plot.ylim = [0 60];

% Example
[~,~,bf_example_CS_ramping_onset] = plot_example_neuron(bf_data_CS,plot_trial_types,params,example_neuron_i,0);

% Population
params.plot.ylim = [-2 4];
[~,~,bf_population_CS_ramping_onset] = plot_population_neuron(bf_data_CS,plot_trial_types,params,0);

% > Offset -----------------------------------------------------------
params.plot.xlim = [1000 1500]; params.plot.ylim = [0 60];
% Example
[~,~,bf_example_CS_ramping_offset] = plot_example_neuron(bf_data_CS,plot_trial_types,params,example_neuron_i,0);

% Population
params.plot.xlim = [-500 0]; params.plot.ylim = [-2 4];
[~,~,bf_population_CS_ramping_offset] = plot_population_neuron_csOutcome(bf_data_CS,bf_datasheet_CS,plot_trial_types,params,0);

% Uncertainty curves --------------------------------------------------
[~, uncertainty_curve_example_point, ~] =...
    plot_fr_x_uncertain_example(bf_data_CS,bf_datasheet_CS,plot_trial_types,params,example_neuron_i,0);
[~, uncertainty_curve_population_point, ~] =...
    plot_fr_x_uncertain(bf_data_CS,bf_datasheet_CS,plot_trial_types,params,0,'zscore');

% Uncertainty fano
clear figure_plot fano_x_uncertaintyA
params.plot.ylim = [0 2];
[~, fano_x_uncertainty_example] =...
    plot_fano_x_uncertain(bf_data_CS,bf_datasheet_CS,plot_trial_types,params,0);
[~, fano_x_uncertainty_population] =...
    plot_fano_x_uncertain(bf_data_CS,bf_datasheet_CS,plot_trial_types,params,0);


%% Generate figure
clear figure_plot
figure_plot = [bf_example_CS_ramping_preCS; bf_population_CS_ramping_preCS;...
    bf_example_CS_ramping_onset; bf_population_CS_ramping_onset;...
    bf_example_CS_ramping_offset; bf_population_CS_ramping_offset;...
    uncertainty_curve_example_point; fano_x_uncertainty_example;...
    uncertainty_curve_population_point; fano_x_uncertainty_population];
    
% Pre-CS: Raster, SDF, Fano (Example)
figure_plot(1,1).set_layout_options('Position',[0.1 0.9 0.1 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(2,1).set_layout_options('Position',[0.1 0.6 0.1 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(3,1).set_layout_options('Position',[0.1 0.5 0.1 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% Pre-CS: SDF, Fano (Population)
figure_plot(4,1).set_layout_options('Position',[0.1 0.2 0.1 0.3],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(5,1).set_layout_options('Position',[0.1 0.1 0.1 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% Post CS -------------------------------------------------------------
figure_plot(6,1).set_layout_options('Position',[0.22 0.9 0.1 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(7,1).set_layout_options('Position',[0.22 0.6 0.1 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(8,1).set_layout_options('Position',[0.22 0.5 0.1 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(9,1).set_layout_options('Position',[0.22 0.2 0.1 0.3],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(10,1).set_layout_options('Position',[0.22 0.1 0.1 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% Pre Outcome -------------------------------------------------------------
figure_plot(11,1).set_layout_options('Position',[0.34 0.9 0.1 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(12,1).set_layout_options('Position',[0.34 0.6 0.1 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(13,1).set_layout_options('Position',[0.34 0.5 0.1 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(14,1).set_layout_options('Position',[0.34 0.2 0.1 0.3],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(15,1).set_layout_options('Position',[0.34 0.1 0.1 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% Tuning -------------------------------------------------------------

figure_plot(16,1).set_layout_options('Position',[0.55 0.72 0.25 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(17,1).set_layout_options('Position',[0.55 0.6 0.25 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(18,1).set_layout_options('Position',[0.55 0.22 0.25 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(19,1).set_layout_options('Position',[0.55 0.1 0.25 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);


for i = [1 2 3 4 6 7 8 9 11 12 13 14 16 18]
    figure_plot(i,1).axe_property('XTick',[],'XColor','None');
end

for i = 1:size(figure_plot,1)
    figure_plot(i,1).set_line_options('base_size',0.5);
end

for i = [6 7 8 9 10 11 12 13 14 15]
    figure_plot(i,1).axe_property('YTick',[],'YColor','None');
end


figure_plot(5,1).axe_property('XTick',[-1000:250:0]);
figure_plot(10,1).axe_property('XTick',[0:250:750]);
figure_plot(15,1).axe_property('XTick',[-750:250:0]);


figure('Renderer', 'painters', 'Position', [100 100 600 400]);
figure_plot.draw;


