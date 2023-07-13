function data_out = get_eyePlot_CS(bf_data_CS, bf_datasheet_CS,...
    striatum_data_CS, striatum_datasheet_CS, params)
%% Set parameters
params.eye.window = [5 5];
params.eye.zero = find(params.eye.alignWin == 0);
trial_type_list = {'prob0','prob25','prob50','prob75','prob100'};

%% Extract data

% Basal Forebrain: NIH CS task
params.plot.xintercept = 1500;
params.eye.salience_window = params.plot.xintercept + [-500:0];
data_in = []; data_in = bf_data_CS(strcmp(bf_datasheet_CS.site,'nih'),:);
[p_gaze_window_nih, ~, mean_gaze_array_nih, ~]  =...
    get_pgaze_window(data_in, trial_type_list, params);

% Basal Forebrain: WUSTL CS task
params.plot.xintercept = 2500;
params.eye.salience_window = params.plot.xintercept + [-500:0];
data_in = []; data_in = bf_data_CS(strcmp(bf_datasheet_CS.site,'wustl'),:);
[p_gaze_window_wustl, ~, mean_gaze_array_wustl, ~]  =...
    get_pgaze_window(data_in, trial_type_list, params);

% Striatum: WUSTL CS task
params.plot.xintercept = 2500;
params.eye.salience_window = params.plot.xintercept + [-500:0];
data_in = []; data_in = striatum_data_CS;
[p_gaze_window_striatum, ~, mean_gaze_array_striatum, ~]  =...
    get_pgaze_window(data_in, trial_type_list, params);

%% Concatenate data
params.eye.salience_window = [-500:0];
% Loop through NIH BF data
params.plot.xintercept = 1500; gaze_time_win = 750;
time_window_analysis = params.eye.zero + params.plot.xintercept + params.eye.salience_window;
mean_gaze_p_all_onset = []; mean_gaze_p_all_offset = []; mean_gaze_p_all_label = [];

for trial_type_i = 1:length(trial_type_list)
    % Get mean p(gaze) at CS
    mean_gaze_p_all_onset =  [mean_gaze_p_all_onset; mean_gaze_array_nih.(trial_type_list{trial_type_i})(:,...
        params.eye.zero + [-200:gaze_time_win])];
    mean_gaze_p_all_offset =  [mean_gaze_p_all_offset; mean_gaze_array_nih.(trial_type_list{trial_type_i})(:,...
        params.eye.zero + params.plot.xintercept + [-gaze_time_win:200])];
    mean_gaze_p_all_label =  [mean_gaze_p_all_label;...
        repmat({[int2str(trial_type_i) '_' trial_type_list{trial_type_i}]},...
        size(mean_gaze_array_nih.(trial_type_list{trial_type_i}),1),1)];
    
    for neuron_i = 1:size(p_gaze_window_nih.(trial_type_list{trial_type_i}),2)
        % Get mean p(gaze) at CS within time window
        p_gaze_a(neuron_i, trial_type_i) = ...
            mean(mean(p_gaze_window_nih.(trial_type_list{trial_type_i})...
            {neuron_i}(:,time_window_analysis),2));
    end
end

% Loop through WUSTL BF data
params.plot.xintercept = 2500;
time_window_analysis = params.eye.zero + params.plot.xintercept + params.eye.salience_window;

for trial_type_i = 1:length(trial_type_list)
    % Get mean p(gaze) at CS
    mean_gaze_p_all_onset =  [mean_gaze_p_all_onset; mean_gaze_array_wustl.(trial_type_list{trial_type_i})(:,...
        params.eye.zero + [-200:gaze_time_win])];
    mean_gaze_p_all_offset =  [mean_gaze_p_all_offset; mean_gaze_array_wustl.(trial_type_list{trial_type_i})(:,...
        params.eye.zero + params.plot.xintercept + [-gaze_time_win:200])];
    mean_gaze_p_all_label =  [mean_gaze_p_all_label;...
        repmat({[int2str(trial_type_i) '_' trial_type_list{trial_type_i}]},...
        size(mean_gaze_array_wustl.(trial_type_list{trial_type_i}),1),1)];
    
    for neuron_i = 1:size(p_gaze_window_wustl.(trial_type_list{trial_type_i}),2)
        % Get mean p(gaze) at CS within time window
        p_gaze_b(neuron_i, trial_type_i) = ...
            mean(mean(p_gaze_window_wustl.(trial_type_list{trial_type_i})...
            {neuron_i}(:,time_window_analysis),2));
    end
end

% Loop through WUSTL Striatum data
params.plot.xintercept = 2500;
time_window_analysis = params.eye.zero + params.plot.xintercept + params.eye.salience_window;

for trial_type_i = 1:length(trial_type_list)
    % Get mean p(gaze) at CS
    mean_gaze_p_all_onset =  [mean_gaze_p_all_onset; mean_gaze_array_striatum.(trial_type_list{trial_type_i})(:,...
        params.eye.zero +  [-200:gaze_time_win])];
    mean_gaze_p_all_offset =  [mean_gaze_p_all_offset; mean_gaze_array_striatum.(trial_type_list{trial_type_i})(:,...
        params.eye.zero + params.plot.xintercept + [-gaze_time_win:200])];
    mean_gaze_p_all_label =  [mean_gaze_p_all_label;...
        repmat({[int2str(trial_type_i) '_' trial_type_list{trial_type_i}]},...
        size(mean_gaze_array_striatum.(trial_type_list{trial_type_i}),1),1)];
    
    for neuron_i = 1:size(p_gaze_window_striatum.(trial_type_list{trial_type_i}),2)
        % Get mean p(gaze) at CS within time window
        p_gaze_c(neuron_i, trial_type_i) = ...
            mean(mean(p_gaze_window_striatum.(trial_type_list{trial_type_i})...
            {neuron_i}(:,time_window_analysis),2));
    end
end

% Collapse data across all tasks/sessions
p_gaze_data_1500 = [p_gaze_a];
p_gaze_data_2500 = [p_gaze_b; p_gaze_c];
p_gaze_data_all = [p_gaze_a; p_gaze_b; p_gaze_c];

% Restructure data and produce labels for plots
plot_gaze_data = []; plot_gaze_data_1500 = []; plot_gaze_data_2500 = []; 
label = []; label_1500 = []; label_2500 = [];

for trial_type_i = 1:length(trial_type_list)
    plot_gaze_data = [plot_gaze_data; p_gaze_data_all(:,trial_type_i)];
    plot_gaze_data_1500 = [plot_gaze_data_1500; p_gaze_data_1500(:,trial_type_i)];
    plot_gaze_data_2500 = [plot_gaze_data_2500; p_gaze_data_2500(:,trial_type_i)];
    
    
    label = [label; repmat({[int2str(trial_type_i) '_' trial_type_list{trial_type_i}]},...
        size(p_gaze_data_all,1),1)];
    label_1500 = [label_1500; repmat({[int2str(trial_type_i) '_' trial_type_list{trial_type_i}]},...
        size(plot_gaze_data_1500,1),1)];    
    label_2500 = [label_2500; repmat({[int2str(trial_type_i) '_' trial_type_list{trial_type_i}]},...
        size(plot_gaze_data_2500,1),1)];
end


data_out.onset_x = [-200:gaze_time_win];
data_out.onset_data = mean_gaze_p_all_onset;
data_out.onset_label = mean_gaze_p_all_label;
data_out.offset_x = [-gaze_time_win:200];
data_out.offset_data = mean_gaze_p_all_offset;
data_out.offset_label = mean_gaze_p_all_label;

