

% Eye Position


%% -------------------------------------------------------------
% Extract example neuron data >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% -------------------------------------------------------------- 
% Trace -------------------------------------------------------------------
plot_trial_types = {'notimingcue_certain','notimingcue_uncertain'};

% Get example ramping neuron activity in the basal forebrain.
example_neuron_i_bf = 8;
[~, bf_plot_data_trace] = plot_example_neuron(bf_data_traceExp,plot_trial_types,params,example_neuron_i_bf,0);
bf_plot_data_trace.area_label = repmat({'1_bf'},size(bf_plot_data_trace.plot_label,1),1);

% Get example ramping neuron activity in the basal ganglia (striatum).
example_neuron_i_striatum = 18;
[~, striatum_plot_data_trace] = plot_example_neuron(striatum_data_traceExp,plot_trial_types,params,example_neuron_i_striatum,0);
striatum_plot_data_trace.area_label = repmat({'1_bg'},size(striatum_plot_data_trace.plot_label,1),1);

% No trace ----------------------------------------------------------------
plot_trial_types = {'notrace_certain','notrace_uncertain'};
% Get example ramping neuron activity in the basal forebrain.
example_neuron_i_bf = 8;
[~, bf_plot_data_notrace] = plot_example_neuron(bf_data_traceExp,plot_trial_types,params,example_neuron_i_bf,0);
bf_plot_data_notrace.area_label = repmat({'1_bf'},size(bf_plot_data_notrace.plot_label,1),1);

% Get example ramping neuron activity in the basal ganglia (striatum).
example_neuron_i_striatum = 16;
[~, striatum_plot_data_notrace] = plot_example_neuron(striatum_data_traceExp,plot_trial_types,params,example_neuron_i_striatum,0);
striatum_plot_data_notrace.area_label = repmat({'1_bg'},size(striatum_plot_data_notrace.plot_label,1),1);


%% -------------------------------------------------------------
% Extract population data >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% -------------------------------------------------------------- 

% Trace -------------------------------------------------------------------
% Get population ramping neuron activity in the basal forebrain.
plot_trial_types = {'notimingcue_uncertain','timingcue_uncertain'};
% Plot population averaged ramping neuron activity in the basal forebrain.
[~, bf_plot_population_trace] = plot_population_neuron(bf_data_traceExp,plot_trial_types,params,0);
bf_plot_population_trace.plot_label = strcat(bf_plot_population_trace.plot_label,'_BF');

% Plot population averaged ramping neuron activity in the basal ganglia (striatum).
[~, striatum_plot_population_trace] = plot_population_neuron(striatum_data_traceExp,plot_trial_types,params,0);
striatum_plot_population_trace.plot_label = strcat(striatum_plot_population_trace.plot_label,'_BG');

% No Trace -------------------------------------------------------------------
% Get population ramping neuron activity in the basal forebrain.
plot_trial_types = {'notrace_certain','notrace_uncertain'};
% Plot population averaged ramping neuron activity in the basal forebrain.
[~, bf_plot_population_notrace] = plot_population_neuron(bf_data_traceExp,plot_trial_types,params,0);
bf_plot_population_notrace.plot_label = strcat(bf_plot_population_notrace.plot_label,'_BF');
% Plot population averaged ramping neuron activity in the basal ganglia (striatum).
[~, striatum_plot_population_notrace] = plot_population_neuron(striatum_data_traceExp,plot_trial_types,params,0);
striatum_plot_population_notrace.plot_label = strcat(striatum_plot_population_notrace.plot_label,'_BG');

%% -------------------------------------------------------------
% Define master figure params >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% --------------------------------------------------------------  
params.plot.xlim = [-500 3500];
params.plot.xintercept = 2500;

params.plot.colormap = [0.9490,0.6471,0.2549;... % Certain (yellow)
                        0,0.2745,0.2627];        % Uncertain (blue)
params.plot.colormap_bf_bg = [255 181 0; 255 218 19; 95 124 161; 39 53 80] ./ 255;


%% -------------------------------------------------------------
% Generate master figure >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% -------------------------------------------------------------- 
% Layout note: 'Position',[L B W H] = [Left Bottom Width Height]
clear figure_plot

% Trace conditions ------------------------------------------------------
% Basal forebrain >>>>>>>>>>>>>>>
% Raster plot 
figure_plot(1,1)=gramm('x',[bf_plot_data_trace.plot_spk_data],...
    'color',[bf_plot_data_trace.plot_label]);
figure_plot(1,1).geom_raster();
figure_plot(1,1).axe_property('XLim',params.plot.xlim,'XTickLabels',{});
figure_plot(1,1).set_names('x','','y','Trial');
figure_plot(1,1).set_color_options('map',params.plot.colormap);
figure_plot(1,1).geom_vline('xintercept',0,'style','k-');
figure_plot(1,1).geom_vline('xintercept',params.plot.xintercept,'style','k-');
figure_plot(1,1).set_layout_options('Position',[0.05 0.8 0.4 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);
% figure_plot(1,1).no_legend;

% Fano factor
figure_plot(2,1)=gramm('x',bf_data_CS.fano(example_neuron_i_bf).time,...
    'y',[bf_plot_data_trace.plot_fano_data],'color',[bf_plot_data_trace.plot_fano_label]);
figure_plot(2,1).geom_line();
figure_plot(2,1).axe_property('XLim',params.plot.xlim,'YLim',[0 6],'XTickLabels',{});
figure_plot(2,1).set_names('x','','y','Fano Factor');
figure_plot(2,1).set_color_options('map',params.plot.colormap);
figure_plot(2,1).geom_vline('xintercept',0,'style','k-');
figure_plot(2,1).geom_vline('xintercept',params.plot.xintercept,'style','k-');
figure_plot(2,1).geom_hline('yintercept',1,'style','k--');
figure_plot(2,1).no_legend;
figure_plot(2,1).set_layout_options('Position',[0.05 0.725 0.4 0.05],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% Striatum >>>>>>>>>>>>>>>
% Raster plot 
figure_plot(3,1)=gramm('x',[striatum_plot_data_trace.plot_spk_data],...
    'color',[striatum_plot_data_trace.plot_label]);
figure_plot(3,1).geom_raster();
figure_plot(3,1).axe_property('XLim',params.plot.xlim,'XTickLabels',{});
figure_plot(3,1).set_names('x','','y','Trial');
figure_plot(3,1).set_color_options('map',params.plot.colormap);
figure_plot(3,1).geom_vline('xintercept',0,'style','k-');
figure_plot(3,1).geom_vline('xintercept',params.plot.xintercept,'style','k-');
figure_plot(3,1).set_layout_options('Position',[0.05 0.6 0.4 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);
figure_plot(1,1).no_legend;

% Fano factor
figure_plot(4,1)=gramm('x',striatum_data_traceExp.fano(example_neuron_i_bf).time,...
    'y',[striatum_plot_data_trace.plot_fano_data],'color',[striatum_plot_data_trace.plot_fano_label]);
figure_plot(4,1).geom_line();
figure_plot(4,1).axe_property('XLim',params.plot.xlim,'YLim',[0 6],'XTickLabels',{});
figure_plot(4,1).set_names('x','','y','Fano Factor');
figure_plot(4,1).set_color_options('map',params.plot.colormap);
figure_plot(4,1).geom_vline('xintercept',0,'style','k-');
figure_plot(4,1).geom_vline('xintercept',params.plot.xintercept,'style','k-');
figure_plot(4,1).geom_hline('yintercept',1,'style','k--');
figure_plot(4,1).no_legend;
figure_plot(4,1).set_layout_options('Position',[0.05 0.525 0.4 0.05],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% Population spike density function
figure_plot(5,1)=gramm('x',[-5000:5000],...
    'y',[bf_plot_population_trace.plot_sdf_data;striatum_plot_population_trace.plot_sdf_data],...
    'color',[bf_plot_population_trace.plot_label;striatum_plot_population_trace.plot_label]);
figure_plot(5,1).stat_summary();
figure_plot(5,1).axe_property('XLim',params.plot.xlim,'YLim',[-0.5 2.5],'XTickLabels',{});
figure_plot(5,1).set_names('x','','y','Firing rate (Z-score)');
figure_plot(5,1).set_color_options('map',params.plot.colormap_bf_bg);
figure_plot(5,1).geom_vline('xintercept',0,'style','k-');
figure_plot(5,1).geom_vline('xintercept',params.plot.xintercept,'style','k-');
figure_plot(5,1).no_legend;
figure_plot(5,1).set_layout_options('Position',[0.05 0.2 0.4 0.3],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% Population fano factor
figure_plot(6,1)=gramm('x',striatum_data_traceExp.fano(example_neuron_i_bf).time,...
    'y',[bf_plot_population_trace.plot_fano_data;striatum_plot_population_trace.plot_fano_data],...
    'color',[bf_plot_population_trace.plot_label;striatum_plot_population_trace.plot_label]);
figure_plot(6,1).stat_summary();
figure_plot(6,1).axe_property('XLim',params.plot.xlim,'YLim',[0 2.5]);
figure_plot(6,1).set_names('x','Time from CS onset (ms)','y','Fano Factor');
figure_plot(6,1).set_color_options('map',params.plot.colormap_bf_bg);
figure_plot(6,1).geom_vline('xintercept',0,'style','k-');
figure_plot(6,1).geom_vline('xintercept',params.plot.xintercept,'style','k-');
figure_plot(6,1).geom_hline('yintercept',1,'style','k--');
figure_plot(6,1).no_legend;
figure_plot(6,1).set_layout_options('Position',[0.05 0.075 0.4 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% No trace conditions ------------------------------------------------------
% Basal forebrain >>>>>>>>>>>>>>>
% Raster plot 
figure_plot(1,2)=gramm('x',[bf_plot_data_notrace.plot_spk_data],...
    'color',[bf_plot_data_notrace.plot_label]);
figure_plot(1,2).geom_raster();
figure_plot(1,2).axe_property('XLim',params.plot.xlim,'XTickLabels',{});
figure_plot(1,2).set_names('x','','y','Trial');
figure_plot(1,2).set_color_options('map',params.plot.colormap);
figure_plot(1,2).geom_vline('xintercept',0,'style','k-');
figure_plot(1,2).geom_vline('xintercept',params.plot.xintercept,'style','k-');
figure_plot(1,2).set_layout_options('Position',[0.55 0.8 0.4 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);
figure_plot(1,2).no_legend;

% Fano factor
figure_plot(2,2)=gramm('x',bf_data_CS.fano(example_neuron_i_bf).time,...
    'y',[bf_plot_data_notrace.plot_fano_data],'color',[bf_plot_data_notrace.plot_fano_label]);
figure_plot(2,2).geom_line();
figure_plot(2,2).axe_property('XLim',params.plot.xlim,'YLim',[0 6],'XTickLabels',{});
figure_plot(2,2).set_names('x','','y','Fano Factor');
figure_plot(2,2).set_color_options('map',params.plot.colormap);
figure_plot(2,2).geom_vline('xintercept',0,'style','k-');
figure_plot(2,2).geom_vline('xintercept',params.plot.xintercept,'style','k-');
figure_plot(2,2).geom_hline('yintercept',1,'style','k--');
figure_plot(2,2).no_legend;
figure_plot(2,2).set_layout_options('Position',[0.55 0.725 0.4 0.05],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... 
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% Striatum >>>>>>>>>>>>>>>
% Raster plot 
figure_plot(3,2)=gramm('x',[striatum_plot_data_notrace.plot_spk_data],...
    'color',[striatum_plot_data_notrace.plot_label]);
figure_plot(3,2).geom_raster();
figure_plot(3,2).axe_property('XLim',params.plot.xlim,'XTickLabels',{});
figure_plot(3,2).set_names('x','','y','Trial');
figure_plot(3,2).set_color_options('map',params.plot.colormap);
figure_plot(3,2).geom_vline('xintercept',0,'style','k-');
figure_plot(3,2).geom_vline('xintercept',params.plot.xintercept,'style','k-');
figure_plot(3,2).set_layout_options('Position',[0.55 0.6 0.4 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);
figure_plot(1,2).no_legend;

% Fano factor
figure_plot(4,2)=gramm('x',striatum_data_traceExp.fano(example_neuron_i_bf).time,...
    'y',[striatum_plot_data_notrace.plot_fano_data],'color',[striatum_plot_data_notrace.plot_fano_label]);
figure_plot(4,2).geom_line();
figure_plot(4,2).axe_property('XLim',params.plot.xlim,'YLim',[0 6],'XTickLabels',{});
figure_plot(4,2).set_names('x','','y','Fano Factor');
figure_plot(4,2).set_color_options('map',params.plot.colormap);
figure_plot(4,2).geom_vline('xintercept',0,'style','k-');
figure_plot(4,2).geom_vline('xintercept',params.plot.xintercept,'style','k-');
figure_plot(4,2).geom_hline('yintercept',1,'style','k--');
figure_plot(4,2).no_legend;
figure_plot(4,2).set_layout_options('Position',[0.55 0.525 0.4 0.05],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% Population spike density function
figure_plot(5,2)=gramm('x',[-5000:5000],...
    'y',[bf_plot_population_notrace.plot_sdf_data;striatum_plot_population_notrace.plot_sdf_data],...
    'color',[bf_plot_population_notrace.plot_label;striatum_plot_population_notrace.plot_label]);
figure_plot(5,2).stat_summary();
figure_plot(5,2).axe_property('XLim',params.plot.xlim,'YLim',[-0.5 2.5],'XTickLabels',{});
figure_plot(5,2).set_names('x','','y','Firing rate (Z-score)');
figure_plot(5,2).set_color_options('map',params.plot.colormap_bf_bg);
figure_plot(5,2).geom_vline('xintercept',0,'style','k-');
figure_plot(5,2).geom_vline('xintercept',params.plot.xintercept,'style','k-');
figure_plot(5,2).set_text_options('legend_scaling',0.75,...
    'legend_title_scaling',0.01);
figure_plot(5,2).set_layout_options('Position',[0.55 0.2 0.4 0.3],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend_pos',[0.6 0.3 0.2 0.2],... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

% Population fano factor
figure_plot(6,2)=gramm('x',striatum_data_traceExp.fano(example_neuron_i_bf).time,...
    'y',[bf_plot_population_notrace.plot_fano_data;striatum_plot_population_notrace.plot_fano_data],...
    'color',[bf_plot_population_notrace.plot_label;striatum_plot_population_notrace.plot_label]);
figure_plot(6,2).stat_summary();
figure_plot(6,2).axe_property('XLim',params.plot.xlim,'YLim',[0 2.5]);
figure_plot(6,2).set_names('x','Time from CS onset (ms)','y','Fano Factor');
figure_plot(6,2).set_color_options('map',params.plot.colormap_bf_bg);
figure_plot(6,2).geom_vline('xintercept',0,'style','k-');
figure_plot(6,2).geom_vline('xintercept',params.plot.xintercept,'style','k-');
figure_plot(6,2).geom_hline('yintercept',1,'style','k--');
figure_plot(6,2).set_layout_options('Position',[0.55 0.075 0.4 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.02 0.05],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(1,1).set_title('Trace');
figure_plot(1,2).set_title('No trace');


figure_plot_out = figure('Renderer', 'painters', 'Position', [100 100 800 900]);
figure_plot.draw();








