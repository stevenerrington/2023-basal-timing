
%% Set parameters
params.eye.window = [5 5];
params.eye.zero = find(params.eye.alignWin == 0);
trial_type_list = {'prob0','prob25','prob50','prob75','prob100'};

%% Extract data
% Basal Forebrain: NIH CS task
params.plot.xintercept = 1500;
params.eye.salience_window = params.eye.zero + params.plot.xintercept + [-200:0];
data_in = []; data_in = bf_data_CS(strcmp(bf_datasheet_CS.site,'nih'),:);
[p_gaze_window_nih, ~, mean_gaze_array_nih, ~]  =...
    get_pgaze_window(data_in, trial_type_list, params);

% Basal Forebrain: WUSTL CS task
params.plot.xintercept = 2500;
params.eye.salience_window = params.eye.zero + params.plot.xintercept + [-200:0];
data_in = []; data_in = bf_data_CS(strcmp(bf_datasheet_CS.site,'wustl'),:);
[p_gaze_window_wustl, ~, mean_gaze_array_wustl, ~]  =...
    get_pgaze_window(data_in, trial_type_list, params);

% Striatum: WUSTL CS task
params.plot.xintercept = 2500;
params.eye.salience_window = params.eye.zero + params.plot.xintercept + [-200:0];
data_in = []; data_in = striatum_data_CS;
[p_gaze_window_striatum, ~, mean_gaze_array_striatum, ~]  =...
    get_pgaze_window(data_in, trial_type_list, params);

%% Concatenate data
% Loop through NIH BF data
params.plot.xintercept = 1500; gaze_time_win = 750;
time_window_analysis = params.eye.zero + params.plot.xintercept + [-200:0];
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
time_window_analysis = params.eye.zero + params.plot.xintercept + [-200:0];

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
time_window_analysis = params.eye.zero + params.plot.xintercept + [-200:0];

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
p_gaze_data = [p_gaze_a; p_gaze_b; p_gaze_c];

% Restructure data and produce labels for plots
plot_gaze_data = []; label = [];

for trial_type_i = 1:length(trial_type_list)
    plot_gaze_data = [plot_gaze_data; p_gaze_data(:,trial_type_i)];
    label = [label; repmat({[int2str(trial_type_i) '_' trial_type_list{trial_type_i}]},...
        size(p_gaze_data,1),1)];
end

% Fit a curve to p(gaze at CS) in window across probabilities for each
% session
for neuron_i = 1:size(p_gaze_data,1)
    y_fit = []; y_fit = polyfit([1:5],p_gaze_data(neuron_i,:),2);
    y_fit_data{neuron_i,1} = polyval(y_fit,[1:0.1:5]);
end


%% Figure: Create plot
% Set plot parameters
colors.appetitive = [247 154 154; 244 107 107; 240 59 59; 230 18 18; 182 14 14]./255;
params.plot.colormap = colors.appetitive;

% Generate gramm figure
clear figure_plot

% Point and error bar - gaze x uncertainty
figure_plot(1,1)=gramm('x',label,'y',plot_gaze_data,'color',label);
figure_plot(1,1).stat_summary('geom',{'point','errorbar'});
figure_plot(1,1).set_color_options('map',params.plot.colormap);
figure_plot(1,1).no_legend;
figure_plot(1,1).axe_property('YLim',[0 1]);

% Fitted curve - gaze x uncertainty
figure_plot(1,2)=gramm('x',[1:0.1:5],'y',y_fit_data);
figure_plot(1,2).stat_summary();
figure_plot(1,2).axe_property('YLim',[0 1]);

% Gaze through time (onset)
figure_plot(1,3)=gramm('x', [-200:gaze_time_win],'y',num2cell(mean_gaze_p_all_onset,2),'color',mean_gaze_p_all_label);
figure_plot(1,3).stat_summary();
figure_plot(1,3).axe_property('YLim',[0 1]);
figure_plot(1,3).set_color_options('map',params.plot.colormap);
figure_plot(1,3).no_legend;

% Gaze through time (offset)
figure_plot(1,4)=gramm('x', [-gaze_time_win:200],'y',num2cell(mean_gaze_p_all_offset,2),'color',mean_gaze_p_all_label);
figure_plot(1,4).stat_summary();
figure_plot(1,4).axe_property('YLim',[0 1]);
figure_plot(1,4).set_color_options('map',params.plot.colormap);
figure_plot(1,4).no_legend;


% Organize figure ------------------------------------------
figure_plot(1,1).set_layout_options('Position',[0.05 0.2 0.2 0.75],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);

figure_plot(1,2).set_layout_options('Position',[0.3 0.2 0.2 0.75],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);

figure_plot(1,3).set_layout_options('Position',[0.6 0.2 0.2 0.75],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);
figure_plot(1,3).axe_property('XLim',[-200, gaze_time_win],'YLim',[0 1]);

figure_plot(1,4).set_layout_options('Position',[0.82 0.2 0.2 0.75],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);
figure_plot(1,4).axe_property('XLim',[-gaze_time_win, 200],'YLim',[0 1],'YTick',[],'YColor',[1 1 1]);

% Create figure --------------------------------------------
figure('Renderer', 'painters', 'Position', [100 100 1000 200]);
figure_plot.draw


