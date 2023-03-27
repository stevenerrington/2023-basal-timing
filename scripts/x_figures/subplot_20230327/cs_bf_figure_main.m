clear figure_plot

cs_bf_figure_sub1
trace_bf_figure_sub2


% Layout note: 'Position',[L B W H] = [Left Bottom Width Height]

eRaster_start_height = 0.8; eRaster_height = 0.1;
eSDF_start_height = 0.7; eSDF_height = 0.1;
eFano_start_height = 0.6; eFano_height = 0.05;
popSDF_start_height = 0.35; popSDF_height = 0.2;
popFano_start_height = 0.25; popFano_height = 0.075;

%% CS Task (BF)
cs_subcolumn_leftRef = 0.05; cs_subcolumn_width = 0.1; cs_subcolumn_gap = 0.005;

% Raster ----------------------
figure_plot(1,1).set_layout_options('Position',[cs_subcolumn_leftRef eRaster_start_height cs_subcolumn_width eRaster_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);

figure_plot(1,2).set_layout_options('Position',[cs_subcolumn_leftRef+cs_subcolumn_width+cs_subcolumn_gap eRaster_start_height cs_subcolumn_width eRaster_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);

% Example neuron SDF ----------------------
figure_plot(2,1).set_layout_options('Position',[cs_subcolumn_leftRef eSDF_start_height cs_subcolumn_width eSDF_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);

figure_plot(2,2).set_layout_options('Position',[cs_subcolumn_leftRef+cs_subcolumn_width+cs_subcolumn_gap eSDF_start_height cs_subcolumn_width eSDF_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);

% Example neuron fabo ----------------------
figure_plot(3,1).set_layout_options('Position',[cs_subcolumn_leftRef eFano_start_height cs_subcolumn_width eFano_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(3,2).set_layout_options('Position',[cs_subcolumn_leftRef+cs_subcolumn_width+cs_subcolumn_gap eFano_start_height cs_subcolumn_width eFano_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);

% Population SDF ----------------------
figure_plot(4,1).set_layout_options('Position',[cs_subcolumn_leftRef popSDF_start_height cs_subcolumn_width popSDF_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(4,2).set_layout_options('Position',[cs_subcolumn_leftRef+cs_subcolumn_width+cs_subcolumn_gap popSDF_start_height cs_subcolumn_width popSDF_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);

% Population Fano ----------------------
figure_plot(5,1).set_layout_options('Position',[cs_subcolumn_leftRef popFano_start_height cs_subcolumn_width popFano_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend_pos',[cs_subcolumn_leftRef 0.075 cs_subcolumn_width 0.1],... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.0],...
    'redraw',false);
figure_plot(5,1).set_text_options('legend_scaling',0.9,...
    'legend_title_scaling',0.01);

figure_plot(5,2).set_layout_options('Position',[cs_subcolumn_leftRef+cs_subcolumn_width+cs_subcolumn_gap popFano_start_height cs_subcolumn_width popFano_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);



%% Trace Task (BF)
trace_subcolumn_leftRef = 0.05; trace_subcolumn_width = (cs_subcolumn_width*2)+cs_subcolumn_gap;

trace_subcolumn_leftRef = 0.3;

% Raster ----------------------
figure_plot(6,1).set_layout_options('Position',[trace_subcolumn_leftRef eRaster_start_height trace_subcolumn_width eRaster_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);

% Example neuron SDF ----------------------
figure_plot(7,1).set_layout_options('Position',[trace_subcolumn_leftRef eSDF_start_height trace_subcolumn_width eSDF_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);

% Example neuron fabo ----------------------
figure_plot(8,1).set_layout_options('Position',[trace_subcolumn_leftRef eFano_start_height trace_subcolumn_width eFano_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% Population SDF ----------------------
figure_plot(9,1).set_layout_options('Position',[trace_subcolumn_leftRef popSDF_start_height trace_subcolumn_width popSDF_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% Population Fano ----------------------
figure_plot(10,1).set_layout_options('Position',[trace_subcolumn_leftRef popFano_start_height trace_subcolumn_width popFano_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend_pos',[trace_subcolumn_leftRef 0.075 trace_subcolumn_width 0.1],... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.0],...
    'redraw',false);
figure_plot(10,1).set_text_options('legend_scaling',0.9,...
    'legend_title_scaling',0.01);

%%
figure_plot_out = figure('Renderer', 'painters', 'Position', [100 100 1500 800]);
figure_plot.draw();
