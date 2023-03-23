%% Example neurons
% In this section, we plot example neurons from the basal forebrain 
% during the timing uncertainty task. The top panel will display the SDF, 
% and the bottom will show the averaged fano-factor through time

plot_trial_types = {'p25s_75l_short','p50s_50l_short','p75s_25l_short'};

% > Timing task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
params.plot.colormap = cool(length(plot_trial_types));

% > Plot example ramping neuron in the basal forebrain.
params.plot.xlim = [-250 1750]; params.plot.ylim = [0 100];
params.plot.xintercept = 1500;
bf_example_timing_ramping = plot_example_neuron(bf_data_timingTask,plot_trial_types,params,2,1);
save_figure(bf_example_timing_ramping,dirs.fig,'bf_example_timing_ramping')

%% Population
% In this section, we plot population averaged activity from neurons in 
% the basal forebrain during the timing task. The top panel will display the
% average SDF, and the bottom will show the averaged fano-factor through time

% > Timing task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
params.plot.colormap = cool(length(plot_trial_types));

params.plot.xlim = [-250 1750]; params.plot.ylim = [-5 5];
params.plot.xintercept = 1500;
bf_population_timing_ramping = plot_population_neuron(bf_data_timingTask,plot_trial_types,params);
save_figure(bf_population_timing_ramping,dirs.fig,'bf_population_timing_ramping')

%% Outcome
% In this section, we plot population averaged activity from neurons in 
% the basal forebrain during the timing task, following E(outcome) at 1500ms.
% The uncertainty of this outcome (25,50,75%) at 1500 ms is cued by the CS.
% This figure will also plot the fano x time, and the average fano factor

% Define the trial types to compare
plot_trial_types = {'p25s_75l_short','p25s_75l_long',...
    'p50s_50l_short','p50s_50l_long',...
    'p75s_25l_short','p75s_25l_long'};

% Setup figure parameters
params.plot.xlim = [0 1000]; params.plot.ylim = [-20 15];
params.plot.colormap = [0 0 0; 1 0 0];

% Generate & save figure
bf_population_timing_outcome = plot_population_timingoutcome(bf_data_timingTask,plot_trial_types,params);
save_figure(bf_population_timing_outcome,dirs.fig,'bf_population_timing_outcome')



