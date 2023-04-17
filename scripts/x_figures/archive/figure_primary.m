%% Setup directories and master parameters
dirs.fig = fullfile(dirs.root,'results');

%% Worksheet:
% Plot activity in the punish/reward data across the WHOLE trial from ITI,
% to CS onset to outcome to ITI
plot_reward_allTrial

% Plot activity in the punish/reward data from the CS to outcome period:
% split by punish and rewrad
plot_punish_reward

% Plot neural activity (aligned on CS onset) ---------------------
% This script will produce figures that shows example and population
% average activity, demonstrating phasic responses to the CS onset and
% ramping activity between the CS and outcome. 
plot_neural_activity

% This script will produce figures that shows population 
% averaged activity, distinguishing between delivered and omitted reward.
plot_outcome_activity

% This script will produce figures that shows examine activity solely during
% the timing task. 
plot_timingTask_activity


% Methodological tests ------------------------------------------------
% This script will produce figures demonstrating methodological considerations:
% > the relationship between fano factor and firing rate (scatter plot).
plot_method

% Comparison of fano-factors -------------------------------------------
% This script will produce figures demonstrating the fano factor
% across:
%        - different conditions (reward probability, cueing, etc...).
plot_compare_fano_task

%        - different areas      (striatum and basal forebrain).
plot_compare_fano_area


% Working plots ------------------------------------------------
% Basal forebrain >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% > Example neurons and population SDF
plot_bf_exampleNeuron_phasicramping  
plot_bf_population_phasicramping     

% > Phasic x ramping fano comparison
plot_bf_fanoBar_phasicramping
plot_bf_fanoSpider                   

% > Reward omitted x reward delivered comparison
plot_bf_outcome

% > Population SDF and fano factor for ramping neurons in timing task
plot_bf_population_timingramping
plot_bf_population_timingramping_varTime

% > Population SDF and fano factor for ramping neurons in trace task
plot_bf_population_traceramping

% > Across task fano-factor
plot_bf_crosstask_fanofactor

% Striatum >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
plot_striatum_population_ramping

% Archive ------------------------------------------------
plot_timing_exampleNeuron_ramping
figure_bf_rampingNeurons_Task
fig1_main
fig2_main

