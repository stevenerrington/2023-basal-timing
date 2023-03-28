%% Population outcome activity
% In this section, we plot the population averaged (Z-scored) activity from
% neurons in the basal forebrain and the striatum

% > CS task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
plot_trial_types = {'prob25nd','prob25d','prob50nd','prob50d','prob75nd','prob75d'};
params.plot.colormap = cool(length(plot_trial_types));

% > Plot outcome-aligned population activity for ramping neurons in the
%   basal forebrain.
params.plot.xlim = [-100 500]; params.plot.ylim = [-30 30];
params.plot.colormap = [0 0 0; 1 0 0];
bf_population_CS_outcome = plot_population_CSoutcome(bf_data_CS(bf_datasheet_CS.cluster_id == 2,:),bf_datasheet_CS, plot_trial_types,params);
save_figure(bf_population_CS_outcome,dirs.fig,'bf_population_CS_outcome')

% > Plot outcome-aligned population activity for ramping neurons in the
%   striatum
params.plot.xlim = [-100 500]; params.plot.ylim = [-10 100];
params.plot.colormap = [0 0 0; 1 0 0];
striatum_population_CS_outcome = plot_population_CSoutcome(striatum_data_CS,striatum_datasheet_CS, plot_trial_types,params);
save_figure(striatum_population_CS_outcome,dirs.fig,'striatum_population_CS_outcome')

% > Trace task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
plot_trial_types = {'notimingcue_uncertain_nd','notimingcue_uncertain_d',...
    'timingcue_uncertain_nd','timingcue_uncertain_d'};
params.plot.colormap = [[0 70 67]./255;[242 165 65]./255];

% > Plot outcome-aligned population activity for ramping neurons in the
%   basal forebrain.
params.plot.xlim = [-100 500]; params.plot.ylim = [-10 20];
params.plot.colormap = [0 0 0; 1 0 0];
bf_population_trace_outcome = plot_population_traceoutcome(bf_data_traceExp,plot_trial_types,params);
save_figure(bf_population_trace_outcome,dirs.fig,'bf_population_trace_outcome')

% > Plot outcome-aligned population activity for ramping neurons in the
%   striatum.
params.plot.xlim = [-100 500]; params.plot.ylim = [-10 60];
params.plot.colormap = [0 0 0; 1 0 0];
striatum_population_trace_outcome = plot_population_traceoutcome(striatum_data_traceExp,plot_trial_types,params);
save_figure(striatum_population_trace_outcome,dirs.fig,'striatum_population_trace_outcome')








