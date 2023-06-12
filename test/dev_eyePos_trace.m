
params.eye.window = [5 5]; params.plot.xintercept = 1500;
params.eye.zero = find(params.eye.alignWin == 0);


% Basal Forebrain: NIH CS task
trial_type_list = {'notrace_uncertain','uncertain','notrace_certain','certain'};
params.plot.xintercept = 2500;
params.eye.salience_window = params.eye.zero+params.plot.xintercept+[-200:0];

data_in = []; data_in = bf_data_traceExp;
[~, ~, mean_gaze_array_bf_trace, time_gaze_window_trace]  =...
    get_pgaze_window(data_in, trial_type_list, params);
plot_eyegaze(mean_gaze_array_bf_trace,time_gaze_window_trace,params);


data_in = []; data_in = striatum_data_traceExp;
[~, ~, mean_gaze_array_striatum_trace, time_gaze_window_trace]  =...
    get_pgaze_window(data_in, trial_type_list, params);
plot_eyegaze(mean_gaze_array_striatum_trace,time_gaze_window_trace,params);


data_in = []; data_in = [bf_data_traceExp; striatum_data_traceExp];
[~, ~, mean_gaze_array_striatum_trace, time_gaze_window_trace]  =...
    get_pgaze_window(data_in, trial_type_list, params);
plot_eyegaze(mean_gaze_array_striatum_trace,time_gaze_window_trace,params);

