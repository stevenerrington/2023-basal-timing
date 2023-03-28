% CS Task (BF) -----------------------------------------------------------
% Raster ----------------------
figure_plot(1,1).set_layout_options('Position',[cs_subcolumn_leftRef_bf eRaster_start_height cs_subcolumn_width_bf eRaster_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);

figure_plot(1,2).set_layout_options('Position',[cs_subcolumn_leftRef_bf+cs_subcolumn_width_bf+cs_subcolumn_gap eRaster_start_height cs_subcolumn_width_bf eRaster_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);

% Example neuron SDF ----------------------
figure_plot(2,1).set_layout_options('Position',[cs_subcolumn_leftRef_bf eSDF_start_height cs_subcolumn_width_bf eSDF_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);

figure_plot(2,2).set_layout_options('Position',[cs_subcolumn_leftRef_bf+cs_subcolumn_width_bf+cs_subcolumn_gap eSDF_start_height cs_subcolumn_width_bf eSDF_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);

% Example neuron fabo ----------------------
figure_plot(3,1).set_layout_options('Position',[cs_subcolumn_leftRef_bf eFano_start_height cs_subcolumn_width_bf eFano_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(3,2).set_layout_options('Position',[cs_subcolumn_leftRef_bf+cs_subcolumn_width_bf+cs_subcolumn_gap eFano_start_height cs_subcolumn_width_bf eFano_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);

% Population SDF ----------------------
figure_plot(4,1).set_layout_options('Position',[cs_subcolumn_leftRef_bf popSDF_start_height cs_subcolumn_width_bf popSDF_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(4,2).set_layout_options('Position',[cs_subcolumn_leftRef_bf+cs_subcolumn_width_bf+cs_subcolumn_gap popSDF_start_height cs_subcolumn_width_bf popSDF_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);

% Population Fano ----------------------
figure_plot(5,1).set_layout_options('Position',[cs_subcolumn_leftRef_bf popFano_start_height cs_subcolumn_width_bf popFano_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend_pos',[cs_subcolumn_leftRef_bf 0.075 cs_subcolumn_width_bf 0.1],... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.0],...
    'redraw',false);
figure_plot(5,1).set_text_options('legend_scaling',0.9,...
    'legend_title_scaling',0.01);

figure_plot(5,2).set_layout_options('Position',[cs_subcolumn_leftRef_bf+cs_subcolumn_width_bf+cs_subcolumn_gap popFano_start_height cs_subcolumn_width_bf popFano_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);


% Trace Task (BF) ---------------------------------------------------------
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


% CS Task (BG) -----------------------------------------------------------
% Raster ----------------------
figure_plot(11,1).set_layout_options('Position',[cs_bg_subcolumn_leftRef eRaster_start_height cs_bg_subcolumn_width eRaster_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);

% Example neuron SDF ----------------------
figure_plot(12,1).set_layout_options('Position',[cs_bg_subcolumn_leftRef eSDF_start_height cs_bg_subcolumn_width eSDF_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);

% Example neuron fabo ----------------------
figure_plot(13,1).set_layout_options('Position',[cs_bg_subcolumn_leftRef eFano_start_height cs_bg_subcolumn_width eFano_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% Population SDF ----------------------
figure_plot(14,1).set_layout_options('Position',[cs_bg_subcolumn_leftRef popSDF_start_height cs_bg_subcolumn_width popSDF_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% Population Fano ----------------------
figure_plot(15,1).set_layout_options('Position',[cs_bg_subcolumn_leftRef popFano_start_height cs_bg_subcolumn_width popFano_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend_pos',[cs_bg_subcolumn_leftRef 0.075 cs_bg_subcolumn_width 0.1],... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.0],...
    'redraw',false);
figure_plot(15,1).set_text_options('legend_scaling',0.9,...
    'legend_title_scaling',0.01);


% Trace Task (BG) -----------------------------------------------------------
% Raster ----------------------
figure_plot(16,1).set_layout_options('Position',[trace_bg_subcolumn_leftRef eRaster_start_height trace_bg_subcolumn_width eRaster_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);

% Example neuron SDF ----------------------
figure_plot(17,1).set_layout_options('Position',[trace_bg_subcolumn_leftRef eSDF_start_height trace_bg_subcolumn_width eSDF_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);

% Example neuron fabo ----------------------
figure_plot(18,1).set_layout_options('Position',[trace_bg_subcolumn_leftRef eFano_start_height trace_bg_subcolumn_width eFano_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% Population SDF ----------------------
figure_plot(19,1).set_layout_options('Position',[trace_bg_subcolumn_leftRef popSDF_start_height trace_bg_subcolumn_width popSDF_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% Population Fano ----------------------
figure_plot(20,1).set_layout_options('Position',[trace_bg_subcolumn_leftRef popFano_start_height trace_bg_subcolumn_width popFano_height],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend_pos',[trace_bg_subcolumn_leftRef 0.075 trace_bg_subcolumn_width 0.1],... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.0],...
    'redraw',false);
figure_plot(20,1).set_text_options('legend_scaling',0.9,...
    'legend_title_scaling',0.01);


%% Format: format line style
for subplot_i = 1:20
    figure_plot(subplot_i,:).set_line_options('base_size', 0.1);
end
