function bfstri_cs_outcome(bf_data_CS,bf_datasheet_CS,striatum_data_CS,striatum_datasheet_CS,params)

bf_color = [247 154 154; 244 107 107; 240 59 59; 230 18 18; 182 14 14]./255;
striatum_color = [221 153 204; 204 85 153; 170 51 102; 85 34 51; 34 17 17]./255;

params.plot.colormap = [0 0 0; bf_color(2,:); 0 0 0; bf_color(3,:); 0 0 0; bf_color(4,:)];
bf_population_CS_outcome = bf_cs_outcome(bf_data_CS,bf_datasheet_CS,params);

params.plot.colormap = [0 0 0; striatum_color(2,:); 0 0 0; striatum_color(3,:); 0 0 0; striatum_color(4,:)];
striatum_population_CS_outcome = bf_cs_outcome(striatum_data_CS,striatum_datasheet_CS,params);
 
figure_data = [bf_population_CS_outcome; striatum_population_CS_outcome];
 
figure_data(1,1).set_layout_options...
    ('Position',[0.05 0.7 0.6 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_data(2,1).set_layout_options...
    ('Position',[0.05 0.55 0.6 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_data(4,1).set_layout_options...
    ('Position',[0.05 0.25 0.6 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_data(5,1).set_layout_options...
    ('Position',[0.05 0.1 0.6 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_data(3,1).set_layout_options...
    ('Position',[0.7 0.6 0.25 0.3],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_data(6,1).axe_property('YLim',[0 1.5]);

figure_data(6,1).set_layout_options...
    ('Position',[0.7 0.1 0.25 0.3],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure('Renderer', 'painters', 'Position', [100 100 500 300]);
figure_data.draw;