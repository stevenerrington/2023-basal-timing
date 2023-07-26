function bfstri_trace_cue(bf_data_traceExp, bf_datasheet_traceExp, params)

% > Trace task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
plot_trial_types = {'notimingcue_uncertain_nd',...
    'timingcue_uncertain_nd','notimingcue_uncertain_d'};
% params.plot.colormap = [118 175 218; 11 28 41]./255;
params.plot.colormap = cool(length(plot_trial_types));
params.stats.peak_window = [-250:250];
slope_analysis_cued = get_slope_ramping_outcome(bf_data_traceExp,bf_datasheet_traceExp,plot_trial_types,params);
[max_ramp_fr_bf] = get_maxFR_ramping_outcome(bf_data_traceExp,bf_datasheet_traceExp,plot_trial_types,params);

% > Plot outcome-aligned population activity for ramping neurons in the
%   basal forebrain.
params.plot.xlim = [-200 600]; params.plot.ylim = [-2 3]; params.stats.peak_window = [-500:500];
[~, bf_population_trace_outcome_cued] = plot_population_traceoutcome(bf_data_traceExp,plot_trial_types,params);

slope_uncertain_notiming = []; slope_uncertain_timing = []; slope_uncertain_notiming_d = [];
time_uncertain_notiming = []; time_uncertain_timing = []; time_uncertain_notiming_d = []; 


for neuron_i = 1:size(bf_data_traceExp,1)
    slope_uncertain_notiming(neuron_i,1) = nanmean(slope_analysis_cued.notimingcue_uncertain_nd.slope{neuron_i}(:));
    slope_uncertain_timing(neuron_i,1) = nanmean(slope_analysis_cued.timingcue_uncertain_nd.slope{neuron_i}(:));
    slope_uncertain_notiming_d(neuron_i,1) = nanmean(slope_analysis_cued.notimingcue_uncertain_d.slope{neuron_i}(:));

    time_uncertain_notiming(neuron_i,1) = max_ramp_fr_bf.mean_averageSDF.notimingcue_uncertain_nd(neuron_i);
    time_uncertain_timing(neuron_i,1) = max_ramp_fr_bf.mean_averageSDF.timingcue_uncertain_nd(neuron_i);
    time_uncertain_notiming_d(neuron_i,1) = max_ramp_fr_bf.mean_averageSDF.notimingcue_uncertain_d(neuron_i);
    
    slope_label_notiming{neuron_i,1} = '1_notiming';
    slope_label_timing{neuron_i,1} = '2_timing';
    slope_label_notiming_d{neuron_i,1} = '3_notiming_del';
    
end

clear figure_plot
figure_plot = [bf_population_trace_outcome_cued];

figure_plot(1,2)=gramm('x',[slope_label_notiming;slope_label_timing;slope_label_notiming_d],...
'y',[slope_uncertain_notiming; slope_uncertain_timing;slope_uncertain_notiming_d],...
'color',[slope_label_notiming;slope_label_timing;slope_label_notiming_d]);
figure_plot(1,2).stat_summary('geom',{'bar','errorbar'},'width',2.5);
figure_plot(1,2).axe_property('YLim',[-0.15 0.0],'XTickLabel',[]);
figure_plot(1,2).set_names('y','Suppression slope (ms)');
figure_plot(1,2).set_color_options('map',params.plot.colormap);

figure_plot(1,3)=gramm('x',[slope_label_notiming;slope_label_timing;slope_label_notiming_d],...
'y',[time_uncertain_notiming; time_uncertain_timing; time_uncertain_notiming_d],...
'color',[slope_label_notiming;slope_label_timing;slope_label_notiming_d]);
figure_plot(1,3).stat_summary('geom',{'bar','errorbar'},'width',2.5);
figure_plot(1,3).axe_property('YLim',[-200 200],'XTickLabel',[]);
figure_plot(1,3).set_names('y','Peak time var (ms)');
figure_plot(1,3).set_color_options('map',params.plot.colormap);


figure_plot(1,1).set_layout_options('Position',[0.2 0.6 0.6 0.3],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',true,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

% figure_plot(1,2).set_layout_options('Position',[0.1 0.3 0.3 0.2],... %Set the position in the figure (as in standard 'Position' axe property)
%     'legend',false,... % No need to display legend for side histograms
%     'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
%     'margin_width',[0.00 0.00],...
%     'redraw',false);

figure_plot(1,2).set_layout_options('Position',[0.2 0.1 0.2 0.3],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(1,3).set_layout_options('Position',[0.6 0.1 0.2 0.3],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure('Renderer', 'painters', 'Position', [100 100 400 400]);
figure_plot.draw();

