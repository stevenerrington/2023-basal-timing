
%% -------------------------------------------------------------
% Set global parameters >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% -------------------------------------------------------------- 
plot_trial_types_CS = {'uncertain','certain'};
plot_trial_types_trace = {'notrace_uncertain','notimingcue_uncertain'};
bf_datasheet_CS_ramping = bf_datasheet_CS(bf_datasheet_CS.cluster_id == 2,:);


%% -------------------------------------------------------------
% Extract example neuron data >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% -------------------------------------------------------------- 
% CS -------------------------------------------------------------------
% Get example ramping neuron activity in the basal forebrain.
example_neuron_i_bf = 16;
[~, bf_plot_data_CS] = plot_example_neuron(bf_data_CS,plot_trial_types_CS,params,example_neuron_i_bf,0);
bf_plot_data_CS.area_label = repmat({'1_bf'},size(bf_plot_data_CS.plot_label,1),1);

% Get example ramping neuron activity in the basal ganglia (striatum).
example_neuron_i_striatum = 10; % 1, 10, 17
[~, striatum_plot_data_CS] = plot_example_neuron(striatum_data_CS,plot_trial_types_CS,params,example_neuron_i_striatum,0);
striatum_plot_data_CS.area_label = repmat({'1_bg'},size(striatum_plot_data_CS.plot_label,1),1);

% Trace ----------------------------------------------------------------
% Get example ramping neuron activity in the basal forebrain.
example_neuron_i_bf = 8; %1, 5, 8
[~, bf_plot_data_trace] = plot_example_neuron(bf_data_traceExp,plot_trial_types_trace,params,example_neuron_i_bf,0);
bf_plot_data_trace.area_label = repmat({'1_bf'},size(bf_plot_data_trace.plot_label,1),1);

% Get example ramping neuron activity in the basal ganglia (striatum).
example_neuron_i_striatum = 8; % 16
[~, striatum_plot_data_trace] = plot_example_neuron(striatum_data_traceExp,plot_trial_types_trace,params,example_neuron_i_striatum,0);
striatum_plot_data_trace.area_label = repmat({'1_bg'},size(striatum_plot_data_trace.plot_label,1),1);


%% -------------------------------------------------------------
% Extract population averaged data >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% -------------------------------------------------------------- 
% CS -------------------------------------------------------------------
% Get population ramping neuron activity in the basal forebrain.
% Plot population averaged ramping neuron activity in the basal forebrain.
[~, bf_plot_population_CS] = plot_population_neuron(bf_data_CS(bf_datasheet_CS.cluster_id == 2,:),plot_trial_types_CS,params,0);
[~, bf_plot_population_CSoutcome] = plot_population_neuron_csOutcome(bf_data_CS(bf_datasheet_CS.cluster_id == 2,:),bf_datasheet_CS,plot_trial_types_CS,params,0);
bf_plot_population_CS.plot_label = strcat(bf_plot_population_CS.plot_label,'_BF');

% Get population ramping neuron activity in the basal ganglia (striatum).
[~, striatum_plot_population_CS] = plot_population_neuron(striatum_data_CS,plot_trial_types_CS,params,0);
striatum_plot_population_CS.plot_label = strcat(striatum_plot_population_CS.plot_label,'_BG');

% Trace -------------------------------------------------------------------
% Get population ramping neuron activity in the basal forebrain.
[~, bf_plot_population_trace] = plot_population_neuron(bf_data_traceExp,plot_trial_types_trace,params,0);
bf_plot_population_trace.plot_label = strcat(bf_plot_population_trace.plot_label,'_BF');
% Get population ramping neuron activity in the basal ganglia (striatum).
[~, striatum_plot_population_trace] = plot_population_neuron(striatum_data_traceExp,plot_trial_types_trace,params,0);
striatum_plot_population_trace.plot_label = strcat(striatum_plot_population_trace.plot_label,'_BG');

%% -------------------------------------------------------------
% Define master figure params >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% --------------------------------------------------------------  
params.plot.xlim = [-500 3500];
params.plot.xlim_CSonset = [0 750];
params.plot.xlim_outcome = [-750 0];

params.plot.ylim_example_sdf = [0 85];

params.plot.xintercept = 2500;

params.plot.colormap = [0.9490,0.6471,0.2549;... % Certain (yellow)
                        0,0.2745,0.2627];        % Uncertain (blue)
                    
%params.plot.colormap = cool(2);        
                    
params.plot.colormap_bf_bg = [171 52 40; 45 114 143] ./ 255;

%% -------------------------------------------------------------
% Generate master figure >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% -------------------------------------------------------------- 
% Layout note: 'Position',[L B W H] = [Left Bottom Width Height]
clear figure_plot

%% Column 1: CS task -----------------------------------------------------
% Basal forebrain examples %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ---------------- Raster -----------------------------------------------
figure_plot(1,1)=gramm('x',[bf_plot_data_CS.plot_spk_data],...
    'color',[bf_plot_data_CS.plot_label]);
figure_plot(1,1).geom_raster();
figure_plot(1,1).axe_property('XLim',params.plot.xlim_CSonset,'XTick',{},'XTickLabels',{},'YTick',[]);
figure_plot(1,1).set_names('x','','y','');
figure_plot(1,1).set_color_options('map',params.plot.colormap);

figure_plot(1,1).set_layout_options('Position',[0.1 0.8 0.15 0.05],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(2,1)=gramm('x',[bf_plot_data_CS.plot_spk_data],...
    'color',[bf_plot_data_CS.plot_label]);
figure_plot(2,1).geom_raster();
figure_plot(2,1).axe_property('XLim',params.plot.xlim_outcome+1500,'XTick',{},'XTickLabels',{},'YTick',[]);
figure_plot(2,1).set_names('x','','y','');
figure_plot(2,1).set_color_options('map',params.plot.colormap);
figure_plot(2,1).set_layout_options('Position',[0.25 0.8 0.15 0.05],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% ---------------- SDF ---------------------------------------------------
figure_plot(3,1)=gramm('x',[-5000:5000],...
    'y',[bf_plot_data_CS.plot_sdf_data],...
    'color',[bf_plot_data_CS.plot_label]);
figure_plot(3,1).stat_summary();
figure_plot(3,1).axe_property('XLim',params.plot.xlim_CSonset,'XTick',{},'XTickLabels',{},'YLim',params.plot.ylim_example_sdf);
figure_plot(3,1).set_names('x','','y','Basal Forebrain');
figure_plot(3,1).set_line_options('base_size', 0.5);
figure_plot(3,1).set_color_options('map',params.plot.colormap);
figure_plot(3,1).set_layout_options('Position',[0.1 0.7 0.15 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(4,1)=gramm('x',[-5000:5000],...
    'y',[bf_plot_data_CS.plot_sdf_data],...
    'color',[bf_plot_data_CS.plot_label]);
figure_plot(4,1).stat_summary();
figure_plot(4,1).axe_property('XLim',params.plot.xlim_outcome+1500,'XTick',{},'XTickLabels',{},'YTick',[],'YLim',params.plot.ylim_example_sdf);
figure_plot(4,1).set_names('x','','y','');
figure_plot(4,1).set_line_options('base_size', 0.5);
figure_plot(4,1).set_color_options('map',params.plot.colormap);
figure_plot(4,1).set_text_options('legend_scaling',0.75,...
    'legend_title_scaling',0.01);
figure_plot(4,1).set_layout_options('Position',[0.25 0.7 0.15 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend_pos',[0.4 0.7 0.1 0.1],... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);



% Basal ganglia examples %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---------------- Raster -----------------------------------------------
figure_plot(5,1)=gramm('x',[striatum_plot_data_CS.plot_spk_data],...
    'color',[striatum_plot_data_CS.plot_label]);
figure_plot(5,1).geom_raster();
figure_plot(5,1).axe_property('XLim',params.plot.xlim_CSonset,'XTick',{},'XTickLabels',{},'YTick',[]);
figure_plot(5,1).set_names('x','','y','');
figure_plot(5,1).set_color_options('map',params.plot.colormap);
figure_plot(5,1).set_layout_options('Position',[0.1 0.65 0.15 0.05],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(6,1)=gramm('x',[striatum_plot_data_CS.plot_spk_data],...
    'color',[striatum_plot_data_CS.plot_label]);
figure_plot(6,1).geom_raster();
figure_plot(6,1).axe_property('XLim',params.plot.xlim_outcome+2500,'XTick',{},'XTickLabels',{},'YTick',[]);
figure_plot(6,1).set_names('x','','y','');
figure_plot(6,1).set_color_options('map',params.plot.colormap);
figure_plot(6,1).set_layout_options('Position',[0.25 0.65 0.15 0.05],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% ---------------- SDF ---------------------------------------------------
figure_plot(7,1)=gramm('x',[-5000:5000],...
    'y',[striatum_plot_data_CS.plot_sdf_data],...
    'color',[striatum_plot_data_CS.plot_label]);
figure_plot(7,1).stat_summary();
figure_plot(7,1).axe_property('XLim',params.plot.xlim_CSonset,'XTick',{},'XTickLabels',{},'YLim',[0 50]);
figure_plot(7,1).set_names('x','','y','Basal Ganglia');
figure_plot(7,1).set_line_options('base_size', 0.5);
figure_plot(7,1).set_color_options('map',params.plot.colormap);
figure_plot(7,1).set_layout_options('Position',[0.1 0.55 0.15 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(8,1)=gramm('x',[-5000:5000],...
    'y',[striatum_plot_data_CS.plot_sdf_data],...
    'color',[striatum_plot_data_CS.plot_label]);
figure_plot(8,1).stat_summary();
figure_plot(8,1).axe_property('XLim',params.plot.xlim_outcome+2500,'XTick',{},'XTickLabels',{},'YTick',[],'YLim',[0 50]);
figure_plot(8,1).set_names('x','','y','');
figure_plot(8,1).set_line_options('base_size', 0.5);
figure_plot(8,1).set_color_options('map',params.plot.colormap);
figure_plot(8,1).set_layout_options('Position',[0.25 0.55 0.15 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% Example neuron fano factor comparison %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure_plot(9,1)=gramm('x',{bf_data_CS.fano(example_neuron_i_bf).time;...
    bf_data_CS.fano(example_neuron_i_bf).time},...
    'y',[bf_plot_data_CS.plot_fano_data(1);striatum_plot_data_CS.plot_fano_data(1)],...
    'color',[append(bf_plot_data_CS.plot_fano_label(1),'_BF');append(striatum_plot_data_CS.plot_fano_label(1),'_BG')]);
figure_plot(9,1).geom_line();
figure_plot(9,1).axe_property('XLim',params.plot.xlim_CSonset,'XTick',{},'XTickLabels',{},'YLim',[0 3]);
figure_plot(9,1).set_names('x','','y','Fano');
figure_plot(9,1).set_color_options('map',params.plot.colormap_bf_bg);
figure_plot(9,1).set_line_options('base_size', 0.5);
figure_plot(9,1).geom_hline('yintercept',1,'style','k--');
figure_plot(9,1).set_layout_options('Position',[0.1 0.475 0.15 0.05],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(10,1)=gramm('x',{bf_data_CS.fano(example_neuron_i_bf).time+1000;...
    bf_data_CS.fano(example_neuron_i_bf).time},...
    'y',[bf_plot_data_CS.plot_fano_data(1);striatum_plot_data_CS.plot_fano_data(1)],...
    'color',[append(bf_plot_data_CS.plot_fano_label(1),'_BF');append(striatum_plot_data_CS.plot_fano_label(1),'_BG')]);
figure_plot(10,1).geom_line();
figure_plot(10,1).axe_property('XLim',params.plot.xlim_outcome+2500,'XTick',{},'XTickLabels',{},'YTick',[],'YLim',[0 3]);
figure_plot(10,1).set_names('x','','y','');
figure_plot(10,1).set_color_options('map',params.plot.colormap_bf_bg);
figure_plot(10,1).set_line_options('base_size', 0.5);
figure_plot(10,1).set_text_options('legend_scaling',0.75,...
    'legend_title_scaling',0.01);
figure_plot(10,1).geom_hline('yintercept',1,'style','k--');
figure_plot(10,1).set_layout_options('Position',[0.25 0.475 0.15 0.05],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend_pos',[0.4 0.46 0.1 0.1],... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% Population spike density function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------- Basal Forebrain  ----------------------------------------------
figure_plot(11,1)=gramm('x',[-5000:5000],'y',bf_plot_population_CS.plot_sdf_data,'color',bf_plot_population_CS.plot_label);
figure_plot(11,1).stat_summary();
figure_plot(11,1).axe_property('XLim',params.plot.xlim_CSonset,'XTick',{},'XTickLabels',{},'YLim',[-1 4]);
figure_plot(11,1).set_names('x','','y','Basal Forebrain (Z)');
figure_plot(11,1).set_color_options('map',params.plot.colormap);
figure_plot(11,1).set_line_options('base_size', 0.75);
figure_plot(11,1).set_layout_options('Position',[0.1 0.3 0.15 0.10],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(12,1)=gramm('x',bf_plot_population_CSoutcome.plot_time_adjust,'y',bf_plot_population_CSoutcome.plot_sdf_data,'color',bf_plot_population_CSoutcome.plot_label);
figure_plot(12,1).stat_summary();
figure_plot(12,1).axe_property('XLim',params.plot.xlim_outcome,'XTick',{},'XTickLabels',{},'YTick',[],'YLim',[-1 4]);
figure_plot(12,1).set_names('x','','y','');
figure_plot(12,1).set_color_options('map',params.plot.colormap);
figure_plot(12,1).set_line_options('base_size', 0.75);
figure_plot(12,1).set_layout_options('Position',[0.25 0.3 0.15 0.10],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% --------- Striatum  ----------------------------------------------
figure_plot(13,1)=gramm('x',[-5000:5000],'y',striatum_plot_population_CS.plot_sdf_data,'color',striatum_plot_population_CS.plot_label);
figure_plot(13,1).stat_summary();
figure_plot(13,1).axe_property('XLim',params.plot.xlim_CSonset,'XTick',{},'XTickLabels',{},'YLim',[-1 4]);
figure_plot(13,1).set_names('x','','y','Basal Ganglia (Z)');
figure_plot(13,1).set_color_options('map',params.plot.colormap);
figure_plot(13,1).set_line_options('base_size', 0.75);
figure_plot(13,1).set_layout_options('Position',[0.1 0.175 0.15 0.10],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(14,1)=gramm('x',[-5000:5000],'y',striatum_plot_population_CS.plot_sdf_data,'color',striatum_plot_population_CS.plot_label);
figure_plot(14,1).stat_summary();
figure_plot(14,1).axe_property('XLim',params.plot.xlim_outcome+2500,'XTick',{},'XTickLabels',{},'YTick',[],'YLim',[-1 4]);
figure_plot(14,1).set_names('x','','y','');
figure_plot(14,1).set_color_options('map',params.plot.colormap);
figure_plot(14,1).set_line_options('base_size', 0.75);
figure_plot(14,1).set_layout_options('Position',[0.25 0.175 0.15 0.10],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% Population fano factor %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure_plot(15,1)=gramm('x',bf_data_CS.fano(example_neuron_i_bf).time,...
    'y',[bf_plot_population_CS.plot_fano_data(1:2:end); striatum_plot_population_CS.plot_fano_data(1:2:end)],...
    'color',[append(bf_plot_population_CS.plot_fano_label(1:2:end),'_bf'); append(striatum_plot_population_CS.plot_fano_label(1:2:end),'_bg')]);
figure_plot(15,1).stat_summary();
figure_plot(15,1).axe_property('XLim',params.plot.xlim_CSonset,'XTick',[0,250,500,750],'XTickLabels',{'0','250','500','750'},'YLim',[0 2.5]);
figure_plot(15,1).set_names('x','Time from CS onset','y','Fano');
figure_plot(15,1).set_color_options('map',params.plot.colormap_bf_bg);
figure_plot(15,1).set_line_options('base_size', 0.75);
figure_plot(15,1).geom_hline('yintercept',1,'style','k--');
figure_plot(15,1).set_layout_options('Position',[0.1 0.075 0.15 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);


fano_outcome_time = [];
for neuron_i = 1:size(bf_plot_population_CS.plot_fano_data,1)/2
    switch bf_datasheet_CS_ramping.site{neuron_i}
        case 'nih'
            fano_outcome_time = [fano_outcome_time; repmat({bf_data_CS.fano(example_neuron_i_bf).time+1000},1,1)];
        case 'wustl'
            fano_outcome_time = [fano_outcome_time; repmat({bf_data_CS.fano(example_neuron_i_bf).time},1,1)];  
    end
    
end


outcome_time_in = []; outcome_time_in = [fano_outcome_time;repmat({bf_data_CS.fano(example_neuron_i_bf).time},length(striatum_plot_population_CS.plot_fano_label(1:2:end)),1)];
outcome_fano_in = []; outcome_fano_in = [bf_plot_population_CS.plot_fano_data(1:2:end); striatum_plot_population_CS.plot_fano_data(1:2:end)];
outcome_label_in = []; outcome_label_in = [append(bf_plot_population_CS.plot_fano_label(1:2:end),'_bf'); append(striatum_plot_population_CS.plot_fano_label(1:2:end),'_bg')];

figure_plot(16,1)=gramm('x',outcome_time_in,'y',outcome_fano_in,'color',outcome_label_in);
figure_plot(16,1).stat_summary();
figure_plot(16,1).axe_property('XLim',params.plot.xlim_outcome+2500,...
    'XTick',[1750,2000,2250,2500],...
    'XTickLabels',{'-750','500','-250','0'},...
    'YTick',[],'YLim',[0 2.5]);
figure_plot(16,1).set_names('x','Time from outcome (ms)','y','');
figure_plot(16,1).set_color_options('map',params.plot.colormap_bf_bg);
figure_plot(16,1).set_line_options('base_size', 0.75);
figure_plot(16,1).geom_hline('yintercept',1,'style','k--');
figure_plot(16,1).set_layout_options('Position',[0.25 0.075 0.15 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

%% Column 2: Trace task -------------------------------------------------
% Basal forebrain examples %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% ---------------- Raster -----------------------------------------------
figure_plot(1,2)=gramm('x',[bf_plot_data_trace.plot_spk_data],...
    'color',[bf_plot_data_trace.plot_label]);
figure_plot(1,2).geom_raster();
figure_plot(1,2).axe_property('XLim',params.plot.xlim_CSonset,'XTick',{},'XTickLabels',{},'YTick',[]);
figure_plot(1,2).set_names('x','','y','');
figure_plot(1,2).set_color_options('map',params.plot.colormap);
figure_plot(1,2).set_layout_options('Position',[0.55 0.8 0.15 0.05],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(2,2)=gramm('x',[bf_plot_data_trace.plot_spk_data],...
    'color',[bf_plot_data_trace.plot_label]);
figure_plot(2,2).geom_raster();
figure_plot(2,2).axe_property('XLim',params.plot.xlim_outcome+2500,'XTick',{},'XTickLabels',{},'YTick',[]);
figure_plot(2,2).set_names('x','','y','');
figure_plot(2,2).set_color_options('map',params.plot.colormap);
figure_plot(2,2).set_layout_options('Position',[0.7 0.8 0.15 0.05],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% ---------------- SDF ---------------------------------------------------
figure_plot(3,2)=gramm('x',[-5000:5000],...
    'y',[bf_plot_data_trace.plot_sdf_data],...
    'color',[bf_plot_data_trace.plot_label]);
figure_plot(3,2).stat_summary();
figure_plot(3,2).axe_property('XLim',params.plot.xlim_CSonset,'XTick',{},'XTickLabels',{},'YLim',params.plot.ylim_example_sdf);
figure_plot(3,2).set_names('x','','y','');
figure_plot(3,2).set_line_options('base_size', 0.5);
figure_plot(3,2).set_color_options('map',params.plot.colormap);
figure_plot(3,2).set_layout_options('Position',[0.55 0.7 0.15 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(4,2)=gramm('x',[-5000:5000],...
    'y',[bf_plot_data_trace.plot_sdf_data],...
    'color',[bf_plot_data_trace.plot_label]);
figure_plot(4,2).stat_summary();
figure_plot(4,2).axe_property('XLim',params.plot.xlim_outcome+2500,'XTick',{},'XTickLabels',{},'YTick',[],'YLim',params.plot.ylim_example_sdf);
figure_plot(4,2).set_names('x','','y','');
figure_plot(4,2).set_line_options('base_size', 0.5);
figure_plot(4,2).set_color_options('map',params.plot.colormap);
figure_plot(4,2).set_text_options('legend_scaling',0.75,...
    'legend_title_scaling',0.01);
figure_plot(4,2).set_layout_options('Position',[0.7 0.7 0.15 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend_pos',[0.85 0.7 0.1 0.1],... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);


% Basal ganglia examples %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ---------------- Raster -----------------------------------------------
figure_plot(5,2)=gramm('x',[striatum_plot_data_trace.plot_spk_data],...
    'color',[striatum_plot_data_trace.plot_label]);
figure_plot(5,2).geom_raster();
figure_plot(5,2).axe_property('XLim',params.plot.xlim_CSonset,'XTick',{},'XTickLabels',{},'YTick',[]);
figure_plot(5,2).set_names('x','','y','');
figure_plot(5,2).set_color_options('map',params.plot.colormap);
figure_plot(5,2).set_layout_options('Position',[0.55 0.65 0.15 0.05],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(6,2)=gramm('x',[striatum_plot_data_trace.plot_spk_data],...
    'color',[striatum_plot_data_trace.plot_label]);
figure_plot(6,2).geom_raster();
figure_plot(6,2).axe_property('XLim',params.plot.xlim_outcome+2500,'XTick',{},'XTickLabels',{},'YTick',[]);
figure_plot(6,2).set_names('x','','y','');
figure_plot(6,2).set_color_options('map',params.plot.colormap);
figure_plot(6,2).set_layout_options('Position',[0.7 0.65 0.15 0.05],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% ---------------- SDF ---------------------------------------------------
figure_plot(7,2)=gramm('x',[-5000:5000],...
    'y',[striatum_plot_data_trace.plot_sdf_data],...
    'color',[striatum_plot_data_trace.plot_label]);
figure_plot(7,2).stat_summary();
figure_plot(7,2).axe_property('XLim',params.plot.xlim_CSonset,'XTick',{},'XTickLabels',{},'YLim',[0 50]);
figure_plot(7,2).set_names('x','','y','');
figure_plot(7,2).set_line_options('base_size', 0.5);
figure_plot(7,2).set_color_options('map',params.plot.colormap);
figure_plot(7,2).set_layout_options('Position',[0.55 0.55 0.15 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(8,2)=gramm('x',[-5000:5000],...
    'y',[striatum_plot_data_trace.plot_sdf_data],...
    'color',[striatum_plot_data_trace.plot_label]);
figure_plot(8,2).stat_summary();
figure_plot(8,2).axe_property('XLim',params.plot.xlim_outcome+2500,'XTick',{},'XTickLabels',{},'YTick',[],'YLim',[0 50]);
figure_plot(8,2).set_names('x','','y','');
figure_plot(8,2).set_line_options('base_size', 0.5);
figure_plot(8,2).set_color_options('map',params.plot.colormap);
figure_plot(8,2).set_layout_options('Position',[0.7 0.55 0.15 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% Example neuron fano factor comparison %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure_plot(9,2)=gramm('x',{bf_data_traceExp.fano(example_neuron_i_bf).time;...
    bf_data_traceExp.fano(example_neuron_i_bf).time},...
    'y',[bf_plot_data_trace.plot_fano_data(1);striatum_plot_data_trace.plot_fano_data(1)],...
    'color',[append(bf_plot_data_trace.plot_fano_label(1),'_BF');append(striatum_plot_data_trace.plot_fano_label(1),'_BG')]);
figure_plot(9,2).geom_line();
figure_plot(9,2).axe_property('XLim',params.plot.xlim_CSonset,'XTick',{},'XTickLabels',{},'YLim',[0 3]);
figure_plot(9,2).set_names('x','','y','');
figure_plot(9,2).set_color_options('map',params.plot.colormap_bf_bg);
figure_plot(9,2).set_line_options('base_size', 0.5);
figure_plot(9,2).geom_hline('yintercept',1,'style','k--');
figure_plot(9,2).set_layout_options('Position',[0.55 0.475 0.15 0.05],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(10,2)=gramm('x',{bf_data_traceExp.fano(example_neuron_i_bf).time+1000;...
    bf_data_traceExp.fano(example_neuron_i_bf).time},...
    'y',[bf_plot_data_trace.plot_fano_data(1);striatum_plot_data_trace.plot_fano_data(1)],...
    'color',[append(bf_plot_data_trace.plot_fano_label(1),'_BF');append(striatum_plot_data_trace.plot_fano_label(1),'_BG')]);
figure_plot(10,2).geom_line();
figure_plot(10,2).axe_property('XLim',params.plot.xlim_outcome+2500,'XTick',{},'XTickLabels',{},'YTick',[],'YLim',[0 3]);
figure_plot(10,2).set_names('x','','y','');
figure_plot(10,2).set_color_options('map',params.plot.colormap_bf_bg);
figure_plot(10,2).set_line_options('base_size', 0.5);
figure_plot(10,2).set_text_options('legend_scaling',0.75,...
    'legend_title_scaling',0.01);
figure_plot(10,2).geom_hline('yintercept',1,'style','k--');
figure_plot(10,2).set_layout_options('Position',[0.7 0.475 0.15 0.05],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend_pos',[0.85 0.46 0.1 0.1],... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);


% Population spike density function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------- Basal Forebrain  ----------------------------------------------
figure_plot(11,2)=gramm('x',[-5000:5000],'y',bf_plot_population_trace.plot_sdf_data,'color',bf_plot_population_trace.plot_label);
figure_plot(11,2).stat_summary();
figure_plot(11,2).axe_property('XLim',params.plot.xlim_CSonset,'XTick',{},'XTickLabels',{},'YLim',[-2 3]);
figure_plot(11,2).set_names('x','','y','');
figure_plot(11,2).set_color_options('map',params.plot.colormap);
figure_plot(11,2).set_line_options('base_size', 0.75);
figure_plot(11,2).set_layout_options('Position',[0.55 0.3 0.15 0.10],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(12,2)=gramm('x',bf_plot_population_trace.plot_time_adjust,'y',bf_plot_population_trace.plot_sdf_data,'color',bf_plot_population_trace.plot_label);
figure_plot(12,2).stat_summary();
figure_plot(12,2).axe_property('XLim',params.plot.xlim_outcome+2500,'XTick',{},'XTickLabels',{},'YTick',[],'YLim',[-2 3]);
figure_plot(12,2).set_names('x','','y','');
figure_plot(12,2).set_color_options('map',params.plot.colormap);
figure_plot(12,2).set_line_options('base_size', 0.75);
figure_plot(12,2).set_layout_options('Position',[0.7 0.3 0.15 0.10],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);


% --------- Striatum  ----------------------------------------------
figure_plot(13,2)=gramm('x',[-5000:5000],'y',striatum_plot_population_trace.plot_sdf_data,'color',striatum_plot_population_trace.plot_label);
figure_plot(13,2).stat_summary();
figure_plot(13,2).axe_property('XLim',params.plot.xlim_CSonset,'XTick',{},'XTickLabels',{},'YLim',[-2 3]);
figure_plot(13,2).set_names('x','','y','');
figure_plot(13,2).set_color_options('map',params.plot.colormap);
figure_plot(13,2).set_line_options('base_size', 0.75);
figure_plot(13,2).set_layout_options('Position',[0.55 0.175 0.15 0.10],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(14,2)=gramm('x',[-5000:5000],'y',striatum_plot_population_trace.plot_sdf_data,'color',striatum_plot_population_trace.plot_label);
figure_plot(14,2).stat_summary();
figure_plot(14,2).axe_property('XLim',params.plot.xlim_outcome+2500,'XTick',{},'XTickLabels',{},'YTick',[],'YLim',[-2 3]);
figure_plot(14,2).set_names('x','','y','');
figure_plot(14,2).set_color_options('map',params.plot.colormap);
figure_plot(14,2).set_line_options('base_size', 0.75);
figure_plot(14,2).set_layout_options('Position',[0.7 0.175 0.15 0.10],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);


% Population fano factor %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure_plot(15,2)=gramm('x',bf_data_traceExp.fano(example_neuron_i_bf).time,...
    'y',[bf_plot_population_trace.plot_fano_data(1:2:end); striatum_plot_population_trace.plot_fano_data(1:2:end)],...
    'color',[append(bf_plot_population_trace.plot_fano_label(1:2:end),'_bf'); append(striatum_plot_population_trace.plot_fano_label(1:2:end),'_bg')]);
figure_plot(15,2).stat_summary();
figure_plot(15,2).axe_property('XLim',params.plot.xlim_CSonset,'XTick',[0,250,500,750],'XTickLabels',{'0','250','500','750'},'YLim',[0 2.5]);
figure_plot(15,2).set_names('x','Time from CS onset','y','');
figure_plot(15,2).set_color_options('map',params.plot.colormap_bf_bg);
figure_plot(15,2).set_line_options('base_size', 0.75);
figure_plot(15,2).geom_hline('yintercept',1,'style','k--');
figure_plot(15,2).set_layout_options('Position',[0.55 0.075 0.15 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(16,2)=gramm('x',bf_data_traceExp.fano(example_neuron_i_bf).time,...
    'y',[bf_plot_population_trace.plot_fano_data(1:2:end); striatum_plot_population_trace.plot_fano_data(1:2:end)],...
    'color',[append(bf_plot_population_trace.plot_fano_label(1:2:end),'_bf'); append(striatum_plot_population_trace.plot_fano_label(1:2:end),'_bg')]);
figure_plot(16,2).stat_summary();
figure_plot(16,2).axe_property('XLim',params.plot.xlim_outcome+2500,'XTick',[1750,2000,2250,2500],'XTickLabels',{'-750','-500','-250','0'},'YLim',[0 2.5],'YTick',[]);
figure_plot(16,2).set_names('x','Time from outcome (ms)','y','');
figure_plot(16,2).set_color_options('map',params.plot.colormap_bf_bg);
figure_plot(16,2).set_line_options('base_size', 0.75);
figure_plot(16,2).geom_hline('yintercept',1,'style','k--');
figure_plot(16,2).set_layout_options('Position',[0.7 0.075 0.15 0.075],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);


%% Generate figure:
figure_plot_out = figure('Renderer', 'painters', 'Position', [100 100 800 900]);
figure_plot.draw();


