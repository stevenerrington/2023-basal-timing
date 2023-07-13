function bfstri_cs_motor(bf_data_CS, bf_datasheet_CS,...
    striatum_data_CS, striatum_datasheet_CS, params)

%% Extract: get SDF and gaze data across trial types
% Define trial types to extract
params.plot.xintercept = 2500;
params.stats.peak_window = [-500:0];
trial_type_list = {'prob0','uncertain'};

% Extract gaze (high/low) SDFs: basal forebrain
[bf_lowgaze_sdf, bf_highgaze_sdf, bf_lowgaze_fano, bf_highgaze_fano, bf_low_high_gaze_ROC] =...
    get_pgaze_sdf(bf_data_CS, bf_datasheet_CS, trial_type_list, params);
% - produces a cell array 2 x n_conditions
%   1st row is onset aligned:  [-250:1000]
%   2nd row is offset aligned: [-1000:0]

% Extract gaze (high/low) SDFs: striatum
[striatum_lowgaze_sdf, striatum_highgaze_sdf, striatum_lowgaze_fano, striatum_highgaze_fano, striatum_low_high_gaze_ROC] =...
    get_pgaze_sdf(striatum_data_CS, striatum_datasheet_CS, trial_type_list, params);
% - produces a cell array 2 x n_conditions
%   1st row is onset aligned:  [-250:1000]
%   2nd row is offset aligned: [-1000:0]

% Combine data across bf/striatum datasets for gaze analyses
data_in = []; data_in = [bf_data_CS; striatum_data_CS];
datasheet_in = []; datasheet_in = [bf_datasheet_CS(:,[1,8]); striatum_datasheet_CS(:,[1,8])];

% Get gaze plots for high and low probability gaze data
[low_pgaze_prob, high_pgaze_prob] = get_pgazeCS_plotdata(data_in,datasheet_in,trial_type_list,params);


%% Curate: restructure data for use with gramm figure
% Initialize array
area_gaze_sdf_onset = []; area_gaze_sdf_offset = [];area_gaze_fano = []; certainty_label = []; area_label = [];

% SDF data
area_gaze_sdf_onset = [bf_lowgaze_sdf{1,1};bf_lowgaze_sdf{1,2};bf_highgaze_sdf{1,1};bf_highgaze_sdf{1,2};...
    striatum_lowgaze_sdf{1,1};striatum_lowgaze_sdf{1,2};striatum_highgaze_sdf{1,1};striatum_highgaze_sdf{1,2}];

area_gaze_sdf_offset = [bf_lowgaze_sdf{2,1};bf_lowgaze_sdf{2,2};bf_highgaze_sdf{2,1};bf_highgaze_sdf{2,2};...
    striatum_lowgaze_sdf{2,1};striatum_lowgaze_sdf{2,2};striatum_highgaze_sdf{2,1};striatum_highgaze_sdf{2,2}];

% Fano data
area_gaze_fano = [bf_lowgaze_fano{1};bf_lowgaze_fano{2};bf_highgaze_fano{1};bf_highgaze_fano{2};...
    striatum_lowgaze_fano{1};striatum_lowgaze_fano{2};striatum_highgaze_fano{1};striatum_highgaze_fano{2}];

% Gaze data
area_gaze_pGaze = [low_pgaze_prob{1};low_pgaze_prob{2};high_pgaze_prob{1};high_pgaze_prob{2}];

% Labels
gaze_label = [repmat({'1_certain_low'},size(low_pgaze_prob{1,1},1),1);...
    repmat({'2_uncertain_low'},size(low_pgaze_prob{1,2},1),1);...
    repmat({'1_certain_high'},size(high_pgaze_prob{1,1},1),1);...
    repmat({'2_uncertain_high'},size(high_pgaze_prob{1,2},1),1)];

certainty_label = ...
    [repmat({'1_certain_low'},size(bf_lowgaze_sdf{1,1},1),1);...
    repmat({'2_uncertain_low'},size(bf_lowgaze_sdf{1,2},1),1);...
    repmat({'1_certain_high'},size(bf_highgaze_sdf{1,1},1),1);...
    repmat({'2_uncertain_high'},size(bf_highgaze_sdf{1,2},1),1);...
    repmat({'1_certain_low'},size(striatum_lowgaze_sdf{1,1},1),1);...
    repmat({'2_uncertain_low'},size(striatum_lowgaze_sdf{1,2},1),1);...
    repmat({'1_certain_high'},size(striatum_highgaze_sdf{1,1},1),1);...
    repmat({'2_uncertain_high'},size(striatum_highgaze_sdf{1,2},1),1)];

area_label = ...
    [repmat({'1_BF'},size([bf_lowgaze_sdf{1,1};bf_lowgaze_sdf{1,2};bf_highgaze_sdf{1,1};bf_highgaze_sdf{1,2}],1),1);...
    repmat({'2_Striatum'},size([striatum_lowgaze_sdf{1,1};striatum_lowgaze_sdf{1,2};striatum_highgaze_sdf{1,1};striatum_highgaze_sdf{1,2}],1),1)];



%% Analysis: Get summary data
% Slope analyses
slope_analysis_CS_bf = get_slope_ramping_gaze(bf_data_CS,bf_datasheet_CS,trial_type_list,params); % 500ms preoutcome
slope_analysis_CS_striatum = get_slope_ramping_gaze(striatum_data_CS,striatum_datasheet_CS,trial_type_list,params); % 500ms preoutcome

[bf_slope_data, bf_slope_label] = get_slope_data_trace(slope_analysis_CS_bf);
[striatum_slope_data, striatum_slope_label] = get_slope_data_trace(slope_analysis_CS_striatum);

% Mean firing rates
mean_fr_outcome = nanmean(area_gaze_sdf_offset(:,1000+[-500:0]),2);

% ROC analyses
% > Compare BF: uncertain high x uncertain low gaze
bf_uncertain_ROC = bf_low_high_gaze_ROC{2};

% > Compare BF: certain high x certain low gaze
bf_certain_ROC = bf_low_high_gaze_ROC{1};

% > Compare Striatum: uncertain high x uncertain low gaze
striatum_uncertain_ROC = striatum_low_high_gaze_ROC{2};

% > Compare Striatum: certain high x certain low gaze
striatum_certain_ROC = striatum_low_high_gaze_ROC{1};

area_gaze_ROC = [bf_uncertain_ROC; bf_certain_ROC; striatum_uncertain_ROC; striatum_certain_ROC];
area_gaze_ROC_label =     [repmat({'1_BF_uncertain'},length(bf_uncertain_ROC),1);...
    repmat({'2_BF_certain'},length(bf_uncertain_ROC),1); repmat({'3_Striatum_uncertain'},length(bf_uncertain_ROC),1);...
    repmat({'4_Striatum_certain'},length(bf_uncertain_ROC),1);];

%% Figure creation
clear figure_plot

xlim_input_onset = [0 750]; xlim_input_offset = [-750 0]; ylim_input = [-2 5];

% Spike density functions
% > Basal forebrain
figure_plot(1,1)=gramm('x',[-250:1000],'y',num2cell(area_gaze_sdf_onset,2),'color',certainty_label,'subset',strcmp(area_label,'1_BF'));
figure_plot(1,1).stat_summary();
figure_plot(1,1).axe_property('XLim',xlim_input_onset,'YLim',ylim_input);
figure_plot(1,1).set_names('x','Time from outcome (ms)','y','Firing rate (Z-score)');
% figure_plot(1,1).no_legend;

figure_plot(1,2)=gramm('x',[-1000:0],'y',num2cell(area_gaze_sdf_offset,2),'color',certainty_label,'subset',strcmp(area_label,'1_BF'));
figure_plot(1,2).stat_summary();
figure_plot(1,2).axe_property('XLim',xlim_input_offset,'YLim',ylim_input);
figure_plot(1,2).set_names('x','Time from outcome (ms)','y','Firing rate (Z-score)');
% figure_plot(1,2).no_legend;

% > Striatum
figure_plot(2,1)=gramm('x',[-250:1000],'y',num2cell(area_gaze_sdf_onset,2),'color',certainty_label,'subset',strcmp(area_label,'1_BF'));
figure_plot(2,1).stat_summary();
figure_plot(2,1).axe_property('XLim',xlim_input_onset,'YLim',ylim_input);
figure_plot(2,1).set_names('x','Time from outcome (ms)','y','Firing rate (Z-score)');
% figure_plot(2,1).no_legend;

figure_plot(2,2)=gramm('x',[-1000:0],'y',num2cell(area_gaze_sdf_offset,2),'color',certainty_label,'subset',strcmp(area_label,'2_Striatum'));
figure_plot(2,2).stat_summary();
figure_plot(2,2).axe_property('XLim',xlim_input_offset,'YLim',ylim_input);
figure_plot(2,2).set_names('x','Time from outcome (ms)','y','Firing rate (Z-score)');
% figure_plot(2,2).no_legend;

% Summary plots (Firing rate)
% > Basal forebrain
% >> Mean firing rate
figure_plot(1,3)=gramm('x',certainty_label,'y',mean_fr_outcome,'color',certainty_label,'subset',strcmp(area_label,'1_BF'));
figure_plot(1,3).stat_summary('geom',{'bar','errorbar'},'width',3,'dodge',1);
figure_plot(1,3).axe_property('YLim',[-1 4]);
figure_plot(1,3).set_names('y','');
figure_plot(1,3).no_legend;

% > Striatum
% >> Mean firing rate
figure_plot(2,3)=gramm('x',certainty_label,'y',mean_fr_outcome,'color',certainty_label,'subset',strcmp(area_label,'2_Striatum'));
figure_plot(2,3).stat_summary('geom',{'bar','errorbar'},'width',3,'dodge',1);
figure_plot(2,3).axe_property('YLim',[-1 4]);
figure_plot(2,3).set_names('y','');
figure_plot(2,3).no_legend;

% Summary plots (ROC)
figure_plot(1,4)=gramm('x',area_gaze_ROC_label,'y',area_gaze_ROC,'color',area_gaze_ROC_label);
figure_plot(1,4).stat_summary('geom',{'bar','errorbar'},'width',2.5,'dodge',1);
figure_plot(1,4).axe_property('YLim',[0.5 1]);
figure_plot(1,4).geom_hline('yintercept',0.5);
figure_plot(1,4).set_names('y','');
% figure_plot(1,4).no_legend;

% Summary plots (Slope)
 % > Basal forebrain
% >> Slope
figure_plot(2,4)=gramm('x',bf_slope_label,'y',bf_slope_data,'color',bf_slope_label);
figure_plot(2,4).stat_summary('geom',{'bar','errorbar'},'width',3,'dodge',1);
figure_plot(2,4).axe_property('YLim',[0.00 0.03]);
figure_plot(2,4).set_names('y','');
% figure_plot(2,4).no_legend;

% > Striatum
% >> Slope
figure_plot(2,5)=gramm('x',striatum_slope_label,'y',striatum_slope_data,'color',striatum_slope_label);
figure_plot(2,5).stat_summary('geom',{'bar','errorbar'},'width',3,'dodge',1);
figure_plot(2,5).axe_property('YLim',[0.00 0.03]);
figure_plot(2,5).set_names('y','');
% figure_plot(2,5).no_legend;


% Figure setup ------------------------------------------------------
% Colors --------------
bf_colors = [179 23 23;... % Certain high
    156 76 76;... % Certain low
    230 64 64;... % Uncertain high
    177 96 96]./255; % Uncertain low
striatum_colors = [93 33 58;... % Certain high
    120 78 96;... % Certain low
    170 51 102;... % Uncertain high
    147 95 117]./255; % Uncertain low

figure_plot(1,1).set_color_options('map',bf_colors);
figure_plot(1,2).set_color_options('map',bf_colors);
figure_plot(2,1).set_color_options('map',striatum_colors);
figure_plot(2,2).set_color_options('map',striatum_colors);
figure_plot(1,3).set_color_options('map',bf_colors);
figure_plot(2,3).set_color_options('map',striatum_colors);
figure_plot(1,4).set_color_options('map',[230 64 64; 179 23 23; 170 51 102; 93 33 58]./255);
figure_plot(2,4).set_color_options('map',bf_colors);
figure_plot(2,5).set_color_options('map',striatum_colors);

% Line styling
for i = [1,2]
    figure_plot(i,1).set_line_options('base_size',0.5);
    figure_plot(i,2).set_line_options('base_size',0.5);
    figure_plot(i,1).axe_property('XTick',[0 250 750]);
    figure_plot(i,2).axe_property('YTick',[],'YColor',[1 1 1]);
    figure_plot(i,2).set_names('x','');
end

% Axes
figure_plot(1,1).axe_property('XTick',[0 250 500 750]);
figure_plot(1,2).axe_property('XTick',[-500 -250 0]);
figure_plot(2,1).axe_property('XTick',[0 250 500 750]);
figure_plot(2,2).axe_property('XTick',[-500 -250 0]);
figure_plot(1,3).axe_property('XTick',[],'XColor',[1 1 1]);
figure_plot(2,3).axe_property('XTick',[],'XColor',[1 1 1]);
figure_plot(1,4).axe_property('XTick',[],'XColor',[1 1 1]);
figure_plot(2,4).axe_property('XTick',[],'XColor',[1 1 1]);
figure_plot(2,5).axe_property('XTick',[],'XColor',[1 1 1],'YTick',[],'YColor',[1 1 1]);


%% Configure & layout figure

% Spike density function
% > BF (Onset)
figure_plot(1,1).set_layout_options('Position',[0.075 0.6 0.1 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend_position',[0.075 0.1 0.2 0.2],... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% > BF (Offset)
figure_plot(1,2).set_layout_options('Position',[0.185 0.6 0.1 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% > Striatum (Onset)
figure_plot(2,1).set_layout_options('Position',[0.375 0.6 0.1 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend_position',[0.375 0.1 0.2 0.2],... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% > Striatum (Offset)
figure_plot(2,2).set_layout_options('Position',[0.4850 0.6 0.1 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% Summary plots
% > BF
figure_plot(1,3).set_layout_options('Position',[0.105 0.725 0.06 0.06],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% > Striatum
figure_plot(2,3).set_layout_options('Position',[0.405 0.725 0.06 0.06],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% > ROC
figure_plot(1,4).set_layout_options('Position',[0.85 0.6 0.12 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend_position',[0.85 0.1 0.1 0.2],... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% > BF (Slope)
figure_plot(2,4).set_layout_options('Position',[0.66 0.6 0.08 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend_position',[0.60 0.3 0.1 0.2],... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% > Striatum (Slope)
figure_plot(2,5).set_layout_options('Position',[0.75 0.6 0.08 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend_position',[0.75 0.3 0.1 0.2],... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure('Renderer', 'painters', 'Position', [100 100 1000 600]);
figure_plot.draw;