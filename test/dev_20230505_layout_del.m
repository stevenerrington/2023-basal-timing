clear figure_plot
figure_plot = [bf_example_CS1500_ramping_appetitive;...
 bf_pop_CS1500_ramping_appetitive;...
 precision_figure_data_appetitive]; 
%% Gramm mapping
%{
(1,1) Raster: appetitive data
(2,1) Example SDF: appetitive data
(3,1) Example Fano: appetitive data
(4,1) Population SDF: appetitive data
(5,1) Population Fano: appetitive data

(1,2) Raster: appetitive data
(2,2) Example SDF: appetitive data
(3,2) Example Fano: appetitive data
(4,2) Population SDF: appetitive data
(5,2) Population Fano: appetitive data


(6,1) Slopes (trial): appetitive
(7,1) Max FR (trial): appetitive
(8,1) Slopes (variance): appetitive
(9,1) Max FR (variance): appetitive

(6,2) Slopes (trial): aversive
(7,2) Max FR (trial): aversive
(8,2) Slopes (variance): aversive
(9,2) Max FR (variance): aversive
%}


%% Arrange figure
% Appetitive spike data
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







% Appetitive precision
figure_plot(6,1).set_layout_options('Position',[0.625 0.8 0.15 0.15],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(7,1).set_layout_options('Position',[0.625 0.3 0.15 0.15],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(8,1).set_layout_options('Position',[0.625 0.6 0.15 0.15],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(9,1).set_layout_options('Position',[0.625 0.1 0.15 0.15],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);


%% Arrange labels

for i = [1,2,3,4 6 7 8 9]
    figure_plot(i,1).axe_property('XTick',[],'XColor',[1 1 1]);
end


figure_plot(6,1).axe_property('YLim',[-0.01 0.06]);

figure_plot(8,1).axe_property('YLim',[0.0 0.03]);

figure_plot(7,1).axe_property('YLim',[-600 200]);

figure_plot(9,1).axe_property('YLim',[0 1000]);


%% Plot figure
figure('Renderer', 'painters', 'Position', [100 100 1000 600]);
figure_plot.draw;