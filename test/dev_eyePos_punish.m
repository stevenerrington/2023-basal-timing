
%% Extract gaze data
% Punish trials
trial_type_list = {'prob0_punish','prob50_punish','prob100_punish'};
params.plot.xintercept = 1500;
params.eye.salience_window = params.eye.zero+params.plot.xintercept+[-200:0];

data_in = []; data_in = bf_data_punish;
[~, ~, mean_gaze_array_bf_punish, time_gaze_window_punish]  =...
    get_pgaze_window(data_in, trial_type_list, params);

plot_data_punish = plot_eyegaze(mean_gaze_array_bf_punish,time_gaze_window_punish,params);
close all;

% Reward trials
trial_type_list = {'prob0','prob50','prob100'};
params.plot.xintercept = 1500;
params.eye.salience_window = params.eye.zero+params.plot.xintercept+[-200:0];

data_in = []; data_in = bf_data_punish;
[~, ~, mean_gaze_array_bf_reward, time_gaze_window_reward]  =...
    get_pgaze_window(data_in, trial_type_list, params);

plot_data_reward = plot_eyegaze(mean_gaze_array_bf_reward,time_gaze_window_reward,params);
close all;

%% Figure: Generate plot

% Define plot parameters/colors
colors.appetitive = [248, 164, 164; 240, 52, 51; 202, 16, 15]./255;
colors.aversive = [116, 255, 232; 0, 198, 165; 0, 75, 65]./255;

% Input data into gramm
clear figure_plot
figure_plot(1,1)=gramm('x',plot_data_reward.label_in,'y',plot_data_reward.mean_gaze_window,'color',plot_data_reward.label_in);
figure_plot(1,1).stat_summary('geom',{'bar','errorbar'},'width',2);
figure_plot(1,1).axe_property('YLim',[0 1]);
figure_plot(1,1).set_names('x','Condition','y','P(Gaze at CS)');
figure_plot(1,1).set_color_options('map',colors.appetitive);
figure_plot(1,1).no_legend;

figure_plot(1,2)=gramm('x',plot_data_punish.label_in,'y',plot_data_punish.mean_gaze_window,'color',plot_data_punish.label_in);
figure_plot(1,2).stat_summary('geom',{'bar','errorbar'},'width',2);
figure_plot(1,2).axe_property('YLim',[0 1]);
figure_plot(1,2).set_names('x','Condition','y','P(Gaze at CS)');
figure_plot(1,2).set_color_options('map',colors.aversive);
figure_plot(1,2).no_legend;

figure('Renderer', 'painters', 'Position', [100 100 400 150]);
figure_plot.draw