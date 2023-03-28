%% Example neurons
% In this section, we plot example neurons from the basal forebrain 
% phasic and ramping) and the striatum during the CS and trace task.
% The top panel will display the SDF, and the bottom will show the
% averaged fano-factor through time

% > CS task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
plot_trial_types = {'prob0','prob25','prob50','prob75','prob100'};
params.plot.colormap = cool(length(plot_trial_types));

% > Plot example phasic neuron in the basal forebrain.
params.plot.xlim = [-500 2500]; params.plot.ylim = [0 100];
params.plot.xintercept = 1500;
bf_example_CS_phasic = plot_example_neuron(bf_data_CS,plot_trial_types,params,47);
save_figure(bf_example_CS_phasic,dirs.fig,'bf_example_CS_phasic')

% > Plot example ramping neuron in the basal forebrain.
params.plot.xlim = [-500 2500]; params.plot.ylim = [0 80];
bf_example_CS_ramping = plot_example_neuron(bf_data_CS,plot_trial_types,params,16);
save_figure(bf_example_CS_ramping,dirs.fig,'bf_example_CS_ramping')

% > Plot example ramping neuron in the striatum.
params.plot.xlim = [-500 3500]; params.plot.ylim = [0 70];
params.plot.xintercept = 2500;
striatum_example_CS_ramping = plot_example_neuron(striatum_data_CS,plot_trial_types,params,5);
save_figure(striatum_example_CS_ramping,dirs.fig,'striatum_example_CS_ramping')

% > Trace task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
plot_trial_types = {'notimingcue_uncertain','timingcue_uncertain'};
params.plot.colormap = [[0 70 67]./255;[242 165 65]./255];

% > Plot example ramping neuron in the basal forebrain.
params.plot.xlim = [-500 3500]; params.plot.ylim = [0 100];
params.plot.xintercept = 2500;
bf_example_trace_ramping = plot_example_neuron(bf_data_traceExp,plot_trial_types,params,8);
save_figure(bf_example_trace_ramping,dirs.fig,'bf_example_trace_ramping')

% > Plot example ramping neuron in the striatum.
params.plot.xlim = [-500 3500]; params.plot.ylim = [0 100];
params.plot.xintercept = 2500;
striatum_example_trace_ramping = plot_example_neuron(striatum_data_traceExp,plot_trial_types,params,18);
save_figure(striatum_example_trace_ramping,dirs.fig,'striatum_example_trace_ramping')
% > > Note - alternative example striatum neurons: 16, 18, 27, 31, 34

%% Population
% In this section, we plot population averaged activity from neurons in 
% the basal forebrain and the striatum during the CS and trace task.
% The top panel will display the average SDF, and the bottom will show the
% averaged fano-factor through time

% > CS task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
plot_trial_types = {'prob0','prob25','prob50','prob75','prob100'};
params.plot.colormap = cool(length(plot_trial_types));

%  Plot population averaged ramping neuron activity in the basal forebrain (NIH subset).
params.plot.xlim = [-500 2500]; params.plot.ylim = [-10 15]; params.plot.xintercept = [1500];
data_in = bf_data_CS(bf_datasheet_CS.cluster_id == 2 & strcmp(bf_datasheet_CS.site,'nih'),:);
bf_population_CS_ramping = plot_population_neuron(data_in,plot_trial_types,params);
clear data_in
save_figure(bf_population_CS_ramping,dirs.fig,'bf_population_CS_ramping')

%  Plot population averaged phasic neuron activity in the basal forebrain.
params.plot.xlim = [-500 3500]; params.plot.ylim = [-2 6]; params.plot.xintercept = [2500];
data_in = bf_data_CS(bf_datasheet_CS.cluster_id == 1,:);
bf_population_CS_phasic = plot_population_neuron(data_in,plot_trial_types,params);
clear data_in
save_figure(bf_population_CS_phasic,dirs.fig,'bf_population_CS_phasic')

%  Plot population averaged ramping neuron activity in the striatum.
params.plot.xlim = [-500 3500]; params.plot.ylim = [-2 60]; params.plot.xintercept = [2500];
striatum_population_CS_ramping = plot_population_neuron(striatum_data_CS,plot_trial_types,params);
clear data_in
save_figure(striatum_population_CS_ramping,dirs.fig,'striatum_population_CS_ramping')

% > Trace task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
plot_trial_types = {'notimingcue_uncertain','timingcue_uncertain'};
params.plot.colormap = [[0 70 67]./255;[242 165 65]./255];

% Plot population averaged ramping neuron activity in the basal forebrain.
params.plot.xlim = [-500 3500]; params.plot.ylim = [-3 8]; params.plot.xintercept = [2500];
bf_population_trace_ramping = plot_population_neuron(bf_data_traceExp,plot_trial_types,params);
save_figure(bf_population_trace_ramping,dirs.fig,'bf_population_trace_ramping')

% Plot population averaged ramping neuron activity in the striatum.
params.plot.xlim = [-500 3500]; params.plot.ylim = [-5 20]; params.plot.xintercept = [2500];
striatum_population_trace_ramping = plot_population_neuron(striatum_data_traceExp,plot_trial_types,params);
save_figure(striatum_population_trace_ramping,dirs.fig,'striatum_population_trace_ramping')
