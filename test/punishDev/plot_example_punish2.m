% > CS task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
plot_trial_types.punish = {'prob0_punish','prob50_punish','prob100_punish'};
plot_trial_types.reward = {'prob0_reward','prob50_reward','prob100_reward'};
params.plot.colormap = cool(length(plot_trial_types.punish));

% > Plot example ramping neuron in the basal forebrain.
params.plot.xlim = [-500 2500]; params.plot.ylim = [0 80]; params.plot.xintercept = [1500];
bf_example_punish_ramping = plot_example_neuron(bf_data_punish,plot_trial_types.punish,params,45,1);
bf_example_reward_ramping = plot_example_neuron(bf_data_punish,plot_trial_types.reward,params,45,1);

% > CS task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
%  Plot population averaged ramping neuron activity in the basal forebrain (NIH subset).
params.plot.xlim = [-500 2500]; params.plot.ylim = [-5 5]; params.plot.xintercept = [1500];
bf_population_punish_ramping = plot_population_neuron(bf_data_punish,plot_trial_types.punish,params,1);
bf_population_reward_ramping = plot_population_neuron(bf_data_punish,plot_trial_types.reward,params,1);


