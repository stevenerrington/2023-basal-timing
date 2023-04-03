clear gramm_pri_fig_data

%% Get figure data
setup_fanocomp_figuredata

gramm_pri_fig_data = [fano_figure_data.bf_phasic_x_ramping;...
    fano_figure_data.bf_certain_x_uncertain;...
    fano_figure_data.bf_delivered_x_nondelivered;...
    fano_figure_data.bf_x_bg;...
    fano_figure_data.bg_certain_x_uncertain;...
    fano_figure_data.bg_delivered_x_nondelivered];

%% Set colors
gramm_pri_fig_data(1,1).set_color_options('map',[144 76 119; 99 176 205]./255)
gramm_pri_fig_data(2,1).set_color_options('map',[137 04 161; 255 200 87]./255)
gramm_pri_fig_data(3,1).set_color_options('map',[23 126 137; 99 176 205]./255)
gramm_pri_fig_data(4,1).set_color_options('map',[117 70 104; 20 89 29]./255)
gramm_pri_fig_data(5,1).set_color_options('map',[137 04 161; 255 200 87]./255)
gramm_pri_fig_data(6,1).set_color_options('map',[23 126 137; 99 176 205]./255)

%% Set figure layout
% Basal Forebrain: Phasic x ramping comparison
gramm_pri_fig_data(1,1).set_layout_options('Position',[0.3 0.1 0.2 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% Basal Forebrain: Certain x uncertain comparison
gramm_pri_fig_data(2,1).set_layout_options('Position',[0.3 0.75 0.2 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% Basal Forebrain: Delivered x undelivered comparison
gramm_pri_fig_data(3,1).set_layout_options('Position',[0.55 0.75 0.2 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% Basal Forebrain x Basal Ganglia comparison
gramm_pri_fig_data(4,1).set_layout_options('Position',[0.55 0.1 0.2 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% Basal Ganglia: Certain x uncertain comparison
gramm_pri_fig_data(5,1).set_layout_options('Position',[0.3 0.45 0.2 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% Basal Forebrain: Delivered x undelivered comparison
gramm_pri_fig_data(6,1).set_layout_options('Position',[0.55 0.45 0.2 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

%% Generate figure
figure_plot_out = figure('Renderer', 'painters', 'Position', [100 100 800 700]);
gramm_pri_fig_data.draw;
