

params.eye.window = [5 5]; params.plot.xintercept = 1500;
params.eye.zero = find(params.eye.alignWin == 0);

%%
% Basal forebrain: timing task
trial_type_list = {'p50s_50l_short','p50s_50l_long'};
params.plot.xintercept = 1500;
params.eye.salience_window = params.eye.zero+1500+[-200:0];

data_in = []; data_in = bf_data_timingTask;
[~, ~, mean_gaze_array_bf_nih, time_gaze_window_wustl]  =...
    get_pgaze_window(data_in, trial_type_list, params);
plot_eyegaze(mean_gaze_array_bf_nih,time_gaze_window_wustl,params);


% Basal Forebrain: NIH CS task
trial_type_list = {'prob0','prob50','prob100'};
params.plot.xintercept = 1500;
params.eye.salience_window = params.eye.zero+1500+[-200:0];

data_in = []; data_in = bf_data_CS(strcmp(bf_datasheet_CS.site,'nih'),:);
[~, ~, mean_gaze_array_bf_nih, time_gaze_window_nih]  =...
    get_pgaze_window(data_in, trial_type_list, params);
plot_eyegaze(mean_gaze_array_bf_nih,time_gaze_window_nih,params);


% Basal Forebrain: WUSTL CS task
trial_type_list = {'prob0','prob50','prob100'};
params.plot.xintercept = 2500;
params.eye.salience_window = params.eye.zero+2500+[-200:0];

data_in = []; data_in = bf_data_CS(strcmp(bf_datasheet_CS.site,'wustl'),:);
[~, ~, mean_gaze_array_bf_wustl, time_gaze_window_wustl]  =...
    get_pgaze_window(data_in, trial_type_list, params);
plot_eyegaze(mean_gaze_array_bf_wustl,time_gaze_window_wustl,params);


%% dev idea: plot by monkey
% Basal Forebrain: NIH CS task
trial_type_list = {'prob0','prob50','prob100'};
params.plot.xintercept = 1500;
params.eye.salience_window = params.eye.zero+params.plot.xintercept+[-200:0];

% 'han','peek'
data_in = []; data_in = bf_data_CS(strcmp(bf_datasheet_CS.monkey,'han'),:);
[~, ~, mean_gaze_array_bf_nih, time_gaze_window_nih]  =...
    get_pgaze_window(data_in, trial_type_list, params);
plot_eyegaze(mean_gaze_array_bf_nih,time_gaze_window_nih,params);

% % Basal Forebrain: WUSTL CS task
% params.plot.xintercept = 2500;
% params.eye.salience_window = params.eye.zero+params.plot.xintercept+[-200:0];
% 
% % 'batman','zombie'
% data_in = []; data_in = bf_data_CS(strcmp(bf_datasheet_CS.monkey,'batman'),:);
% [~, ~, mean_gaze_array_bf_nih, time_gaze_window_nih]  =...
%     get_pgaze_window(data_in, trial_type_list, params);
% plot_eyegaze(mean_gaze_array_bf_nih,time_gaze_window_nih,params);

%% dev ideas: combined data

params.plot.xintercept = 1500;
params.eye.salience_window = params.eye.zero+params.plot.xintercept+[-200:0];
% NIH data ---------------------------------------------------------
trial_type_list = {'prob0','prob50','prob100'};
params.plot.xintercept = 1500;
params.eye.salience_window = params.eye.zero+1500+[-200:0];

data_in = []; data_in = bf_data_CS(strcmp(bf_datasheet_CS.site,'nih'),:);
[~, ~, mean_gaze_array_bf_nih, time_gaze_window_nih]  =...
    get_pgaze_window(data_in, trial_type_list, params);
plot_eyegaze(mean_gaze_array_bf_nih,time_gaze_window_nih,params);
out_data_nih = plot_eyegaze(mean_gaze_array_bf_nih,time_gaze_window_nih,params);


% WUSTL data ---------------------------------------------------------
params.plot.xintercept = 2500;
params.eye.salience_window = params.eye.zero+2500+[-200:0];

data_in = []; data_in = bf_data_CS(strcmp(bf_datasheet_CS.site,'wustl') & strcmp(bf_datasheet_CS.cluster_label,'Ramping'),:);
[~, ~, mean_gaze_array_bf_wustl, time_gaze_window_wustl]  =...
    get_pgaze_window(data_in, trial_type_list, params);
out_data_wustl = plot_eyegaze(mean_gaze_array_bf_wustl,time_gaze_window_wustl,params);


% Concatenated
data_in = []; data_in = [out_data_nih.mean_gaze_window;out_data_wustl.mean_gaze_window];
data_in_b = []; data_in_b = [out_data_nih.p_gaze_array;out_data_wustl.p_gaze_array];
label_in = []; label_in = [out_data_nih.label_in;out_data_wustl.label_in];
site_label_in = []; site_label_in = [repmat({'1_NIH'},length(out_data_nih.mean_gaze_window),1);...
    repmat({'2_WUSTL'},length(out_data_wustl.mean_gaze_window),1)];



clear figure_plot
figure_plot(1,1)=gramm('x',label_in,'y',data_in,'color',label_in);
figure_plot(1,1).stat_summary('geom',{'bar','black_errorbar'},'width',1);
figure_plot(1,1).axe_property('YLim',[0 1]);
figure_plot(1,1).set_names('x','Condition','y','P(Gaze at CS)');
figure_plot(1,1).facet_grid([],site_label_in);
figure_plot(1,1).no_legend();

figure('Renderer', 'painters', 'Position', [100 100 500 250]);
figure_plot.draw;


%% Extract eye positions
eye_pos_table = table();
params.eye.alignWin = [-2000:3000];

for neuron_i = 1:size(bf_data_punish,1)
    
    % Clear variables, console, and figures
    clear REX PDS trials Rasters SDFcs_n fano; clc; close all;
    
    filename = bf_datasheet_punish.file{neuron_i};
    fprintf('Extracting data from neuron %i of %i   |  %s   \n',neuron_i,size(bf_datasheet_punish,1), filename)
    
    REX = mrdr('-a', '-d', fullfile(bf_datasheet_punish.dir{neuron_i},bf_datasheet_punish.file{neuron_i}));
    
    eye_pos_table(neuron_i,:) = get_rex_eye(REX,params);
    
end

%% Find p(trials) with eye in a defined window (trial-by-trial)

data_in = []; data_in = bf_data_CS;
trial_type_list = {'prob0','prob50','prob100'};
clear p_gaze_window;
x_window = 3; y_window = 3;

for neuron_i = 1:size(data_in,1)
    
    for trial_type_i = 1:length(trial_type_list)
        trial_type_label = trial_type_list{trial_type_i};
        trials_in = []; trials_in = data_in.trials{neuron_i}.(trial_type_label);
        
        window_flag = [];
        window_flag = zeros(length(trials_in),length(params.eye.alignWin));
        
        for trial_i = 1:length(trials_in)
            in_window = [];
            in_window = find(abs(bf_data_CS.eye{neuron_i}.eye_x{1,1}(trials_in(trial_i),:) < x_window)...
                & abs(bf_data_CS.eye{neuron_i}.eye_y{1,1}(trials_in(trial_i),:) < y_window));
            
            window_flag(trial_i,in_window) = 1;
            
        end
        
        p_gaze_window.(trial_type_label){neuron_i} = window_flag;
    end
end

%% Concatentate across neurons/get neuron average p(gaze at target)

for trial_type_i = 1:length(trial_type_list)
    trial_type_label = trial_type_list{trial_type_i};

    conc_gaze_array.(trial_type_label) = [];
    
    for neuron_i = 1:size(data_in,1)
        conc_gaze_array.(trial_type_label) =...
            [conc_gaze_array.(trial_type_label);...
            p_gaze_window.(trial_type_label){neuron_i}];
        
        mean_gaze_array_bf_nih.(trial_type_label)(neuron_i,:) =...
            nanmean(p_gaze_window.(trial_type_label){neuron_i});
        
    end
end
















%%
% Basal Forebrain: NIH CS task
trial_type_list = {'prob0_punish','prob50_punish','prob100_punish'};
params.plot.xintercept = 1500;
params.eye.salience_window = params.eye.zero+params.plot.xintercept+[-200:0];

data_in = []; data_in = bf_data_punish;
[~, ~, mean_gaze_array_bf_punish, time_gaze_window_punish]  =...
    get_pgaze_window(data_in, trial_type_list, params);
plot_eyegaze(mean_gaze_array_bf_punish,time_gaze_window_punish,params);







%% Figure

color_scheme_punish = [254 216 225; 251 137 166; 247 19 77]./255;
color_scheme_reward = [156 224 245; 56 193 236; 16 131 167]./255;

clear figure_plot
data_in_reward = [num2cell(mean_gaze_array_bf_nih.prob0_reward,2);...
    num2cell(mean_gaze_array_bf_nih.prob50_reward,2);...
    num2cell(mean_gaze_array_bf_nih.prob100_reward,2)];
data_in_punish = [num2cell(mean_gaze_array_bf_nih.prob0_punish,2);...
    num2cell(mean_gaze_array_bf_nih.prob50_punish,2);...
    num2cell(mean_gaze_array_bf_nih.prob100_punish,2)];

label_in = [repmat({'1_prob0'},size(bf_data_punish,1),1);...
    repmat({'2_prob50'},size(bf_data_punish,1),1);...
    repmat({'3_prob100'},size(bf_data_punish,1),1)];

figure_plot(1,1)=gramm('x',eye_alignWin,'y',data_in_reward,'color',label_in);
figure_plot(1,1).stat_summary();
figure_plot(1,1).axe_property('XLim',[-1000 3000],'YLim',[0 1]);
figure_plot(1,1).set_names3('x','Time from CS Onset (ms)','y','P(Gaze at CS)');
figure_plot(1,1).set_color_options('map',color_scheme_reward);
figure_plot(1,1).geom_vline('xintercept',0,'style','k-');
figure_plot(1,1).geom_vline('xintercept',1500,'style','k-');

figure_plot(2,1)=gramm('x',eye_alignWin,'y',data_in_punish,'color',label_in);
figure_plot(2,1).stat_summary();
figure_plot(2,1).axe_property('XLim',[-1000 3000],'YLim',[0 1]);
figure_plot(2,1).set_names('x','Time from CS Onset (ms)','y','P(Gaze at CS)');
figure_plot(2,1).set_color_options('map',color_scheme_punish);
figure_plot(2,1).geom_vline('xintercept',0,'style','k-');
figure_plot(2,1).geom_vline('xintercept',1500,'style','k-');

figure('Renderer', 'painters', 'Position', [100 100 600 500]);
figure_plot.draw;

%% BLINK DETECTION. In progress (23-04-07; 16h00)

neuron_i = 3; 

figure; hold on

for trl_i = 1:length(bf_data_punish.trials{neuron_i}.prob100_punish)
    trl_j = bf_data_punish.trials{neuron_i}.prob100_punish(trl_i);
    
    plot(eye_alignWin,bf_data_CS.eye{neuron_i}.eye_x{1,1}  {neuron_i}(trl_j,:),'k')
end

hline([-x_window x_window],'r-')
