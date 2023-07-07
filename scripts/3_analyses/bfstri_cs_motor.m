function bfstri_cs_motor(bf_data_CS, bf_datasheet_CS,...
    striatum_data_CS, striatum_datasheet_CS, params)

%% Extract data (2-3 minutes)
trial_type_list = {'certain','uncertain'};
[bf_lowgaze_sdf, bf_highgaze_sdf, bf_lowgaze_fano, bf_highgaze_fano] =...
    get_pgaze_sdf(bf_data_CS, bf_datasheet_CS, trial_type_list, params);
[striatum_lowgaze_sdf, striatum_highgaze_sdf, striatum_lowgaze_fano, striatum_highgaze_fano] =...
    get_pgaze_sdf(striatum_data_CS, striatum_datasheet_CS, trial_type_list, params);

data_in = []; data_in = [bf_data_CS; striatum_data_CS];
datasheet_in = []; datasheet_in = [bf_datasheet_CS(:,[1,8]); striatum_datasheet_CS(:,[1,8])];

[low_pgaze_prob, high_pgaze_prob] = get_pgazeCS_plotdata(data_in,datasheet_in,trial_type_list,params);

%% Data restructure
area_gaze_sdf = []; area_gaze_fano = []; certainty_label = []; area_label = [];

area_gaze_sdf = [bf_lowgaze_sdf{1};bf_lowgaze_sdf{2};bf_highgaze_sdf{1};bf_highgaze_sdf{2};...
    striatum_lowgaze_sdf{1};striatum_lowgaze_sdf{2};striatum_highgaze_sdf{1};striatum_highgaze_sdf{2}];

area_gaze_fano = [bf_lowgaze_fano{1};bf_lowgaze_fano{2};bf_highgaze_fano{1};bf_highgaze_fano{2};...
    striatum_lowgaze_fano{1};striatum_lowgaze_fano{2};striatum_highgaze_fano{1};striatum_highgaze_fano{2}];

area_gaze_pGaze = [low_pgaze_prob{1};low_pgaze_prob{2};high_pgaze_prob{1};high_pgaze_prob{2}];

gaze_label = [repmat({'1_certain_low'},size(low_pgaze_prob{1},1),1);...
    repmat({'2_uncertain_low'},size(low_pgaze_prob{2},1),1);...
    repmat({'1_certain_high'},size(high_pgaze_prob{1},1),1);...
    repmat({'2_uncertain_high'},size(high_pgaze_prob{2},1),1)];

certainty_label = ...
    [repmat({'1_certain_low'},size(bf_lowgaze_sdf{1},1),1);...
    repmat({'2_uncertain_low'},size(bf_lowgaze_sdf{2},1),1);...
    repmat({'1_certain_high'},size(bf_highgaze_sdf{1},1),1);...
    repmat({'2_uncertain_high'},size(bf_highgaze_sdf{2},1),1);...    
    repmat({'1_certain_low'},size(striatum_lowgaze_sdf{1},1),1);...
    repmat({'2_uncertain_low'},size(striatum_lowgaze_sdf{2},1),1);...
    repmat({'1_certain_high'},size(striatum_highgaze_sdf{1},1),1);...
    repmat({'2_uncertain_high'},size(striatum_highgaze_sdf{2},1),1)];

area_label = ...
    [repmat({'1_BF'},size([bf_lowgaze_sdf{1};bf_lowgaze_sdf{2};bf_highgaze_sdf{1};bf_highgaze_sdf{2}],1),1);...
    repmat({'2_Striatum'},size([striatum_lowgaze_sdf{1};striatum_lowgaze_sdf{2};striatum_highgaze_sdf{1};striatum_highgaze_sdf{2}],1),1)];


%% Figure creation
clear figure_plot

xlim_input = [-750 0]; ylim_input = [-2 5];

figure_plot(1,1)=gramm('x',[-1000:0],'y',num2cell(area_gaze_pGaze,2),'color',gaze_label);
figure_plot(1,1).stat_summary();
figure_plot(1,1).axe_property('XLim',xlim_input,'YLim',[0 1]);
figure_plot(1,1).set_names('x','Time from outcome (ms)','y','P(Gaze)');
figure_plot(1,1).no_legend;

figure_plot(2,1)=gramm('x',[-1000:0],'y',num2cell(area_gaze_sdf,2),'color',certainty_label,'subset',strcmp(area_label,'1_BF'));
figure_plot(2,1).stat_summary();
figure_plot(2,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
figure_plot(2,1).set_names('x','Time from outcome (ms)','y','Firing rate (Z-score)');
% figure_plot(2,1).no_legend;

figure_plot(3,1)=gramm('x',[-1000:0],'y',num2cell(area_gaze_fano,2),'color',certainty_label,'subset',strcmp(area_label,'1_BF'));
figure_plot(3,1).stat_summary();
figure_plot(3,1).axe_property('XLim',xlim_input,'YLim',[0 2.5]);
figure_plot(3,1).set_names('x','Time from outcome (ms)','y','Fano factor');
% figure_plot(3,1).no_legend;

figure_plot(4,1)=gramm('x',[-1000:0],'y',num2cell(area_gaze_sdf,2),'color',certainty_label,'subset',strcmp(area_label,'2_Striatum'));
figure_plot(4,1).stat_summary();
figure_plot(4,1).axe_property('XLim',xlim_input,'YLim',ylim_input);
figure_plot(4,1).set_names('x','Time from outcome (ms)','y','Firing rate (Z-score)');
% figure_plot(4,1).no_legend;

figure_plot(5,1)=gramm('x',[-1000:0],'y',num2cell(area_gaze_fano,2),'color',certainty_label,'subset',strcmp(area_label,'2_Striatum'));
figure_plot(5,1).stat_summary();
figure_plot(5,1).axe_property('XLim',xlim_input,'YLim',[0 2.5]);
figure_plot(5,1).set_names('x','Time from outcome (ms)','y','Fano factor');
% figure_plot(5,1).no_legend;


%% Colors

bf_colors = [179 23 23;... % Certain high
    156 76 76;... % Certain low
    230 64 64;... % Uncertain high
    177 96 96]./255; % Uncertain low
striatum_colors = [93 33 58;... % Certain high
    120 78 96;... % Certain low
    170 51 102;... % Uncertain high
    147 95 117]./255; % Uncertain low

params.plot.colormap = [247 154 154; 244 107 107; 240 59 59; 230 18 18; 182 14 14]./255;

% figure_plot(1,1).set_color_options('map',color_scheme);
figure_plot(2,1).set_color_options('map',bf_colors);
figure_plot(3,1).set_color_options('map',bf_colors);
figure_plot(4,1).set_color_options('map',striatum_colors);
figure_plot(5,1).set_color_options('map',striatum_colors);



for i = [1,2,3,4,5]
    figure_plot(i,1).set_line_options('base_size',0.5);
end


%% Configure & layout figure
figure_plot(1,1).set_layout_options('Position',[0.1 0.9 0.1 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',true,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(2,1).set_layout_options('Position',[0.1 0.6 0.1 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',true,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(3,1).set_layout_options('Position',[0.1 0.5 0.1 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',true,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(4,1).set_layout_options('Position',[0.1 0.2 0.1 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',true,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(5,1).set_layout_options('Position',[0.1 0.1 0.1 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend_pos',[0.4 0.1 0.2 0.2],... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);


for i = [1,2,3,4]
    figure_plot(i,1).axe_property('XTick',[],'XColor',[1 1 1]);
end

figure('Renderer', 'painters', 'Position', [100 100 1000 600]);
figure_plot.draw