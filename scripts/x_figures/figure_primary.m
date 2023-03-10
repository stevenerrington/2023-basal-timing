%% Setup directories and master parameters
dirs.fig = fullfile(dirs.root,'results');

%% Plot neural activity (aligned on CS onset)
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


%% Methodological tests
% This script will produce figures demonstrating methodological considerations:
% > the relationship between fano factor and firing rate (scatter plot).
plot_method

%% Comparison of fano-factors
% This script will produce figures demonstrating the fano factor
% across:
%        - different conditions (reward probability, cueing, etc...).
plot_compare_fano_task

%        - different areas      (striatum and basal forebrain).
plot_compare_fano_area

%%
