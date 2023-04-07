
%% Extract eye positions
eye_pos_table = table();
eye_alignWin = [-2000:3000];

for neuron_i = 1:size(bf_data_punish,1)
    
    % Clear variables, console, and figures
    clear REX PDS trials Rasters SDFcs_n fano; clc; close all;
    
    filename = bf_datasheet_punish.file{neuron_i};
    fprintf('Extracting data from neuron %i of %i   |  %s   \n',neuron_i,size(bf_datasheet_punish,1), filename)
    
    REX = mrdr('-a', '-d', fullfile(bf_datasheet_punish.dir{neuron_i},bf_datasheet_punish.file{neuron_i}));
    
    
    eye_x = []; eye_y = []; location = [];
    
    for trial_i = 1:size(REX,2)
        
        eye_x = REX(trial_i).Signals(1).Signal;
        eye_y = REX(trial_i).Signals(2).Signal;
        
        event_table = []; event_table = struct2table(REX(trial_i).Events);
        
        % 1100 is TARGONCD; 1050 is CUECD (TARGONCD is used for raster align)
        zero_time = double(event_table.Time(event_table.Code == 1100))-double(REX(trial_i).aStartTime);
        
        if length(zero_time) > 1
            zero_time = zero_time(zero_time > 0);
        end
        
        eye_x_trial(trial_i,:) = eye_x(zero_time+eye_alignWin);
        eye_y_trial(trial_i,:) = eye_y(zero_time+eye_alignWin);
        
        % lefttrials=5502; righttrials=4501; centertrials=3500;
        
        % targ location
        if ~isempty(find(event_table.Code == 5502))
            location{trial_i,1} = 'left';
        elseif ~isempty(find(event_table.Code == 4501))
            location{trial_i,1} = 'right';
        elseif ~isempty(find(event_table.Code == 3500))
            location{trial_i,1} = 'center';
        else
            location{trial_i,1} = '?';
        end
        
        
        
    end
    
    eye_pos_table(neuron_i,:) = table({eye_x_trial},{eye_y_trial}, {location},...
        'VariableNames',{'eye_x','eye_y','targ_location'});
    
end

%% Find p(trials) with eye in a defined window (trial-by-trial)

trial_type_list = {'prob0_reward','prob50_reward','prob100_reward',...
    'prob0_punish','prob50_punish','prob100_punish'};
clear p_gaze_window;
x_window = 5; y_window = 5;

for neuron_i = 1:size(bf_data_punish,1)
    
    for trial_type_i = 1:length(trial_type_list)
        trial_type_label = trial_type_list{trial_type_i};
        trials_in = []; trials_in = bf_data_punish.trials{neuron_i}.(trial_type_label);
        
        window_flag = [];
        window_flag = zeros(length(trials_in),length(eye_alignWin));
        
        for trial_i = 1:length(trials_in)
            in_window = [];
            in_window = find(abs(eye_pos_table.eye_x{neuron_i}(trials_in(trial_i),:) < x_window)...
                & abs(eye_pos_table.eye_y{neuron_i}(trials_in(trial_i),:) < y_window));
            
            window_flag(trial_i,in_window) = 1;
            
        end
        
        p_gaze_window.(trial_type_label){neuron_i} = window_flag;
    end
end

%% Concatentate across neurons/get neuron average p(gaze at target)

for trial_type_i = 1:length(trial_type_list)
    trial_type_label = trial_type_list{trial_type_i};

    conc_gaze_array.(trial_type_label) = [];
    
    for neuron_i = 1:size(bf_data_punish,1)
        conc_gaze_array.(trial_type_label) =...
            [conc_gaze_array.(trial_type_label);...
            p_gaze_window.(trial_type_label){neuron_i}];
        
        mean_gaze_array.(trial_type_label)(neuron_i,:) =...
            nanmean(p_gaze_window.(trial_type_label){neuron_i});
        
    end
end


%% Figure

color_scheme_punish = [254 216 225; 251 137 166; 247 19 77]./255;
color_scheme_reward = [156 224 245; 56 193 236; 16 131 167]./255;

clear figure_plot
data_in_reward = [num2cell(mean_gaze_array.prob0_reward,2);...
    num2cell(mean_gaze_array.prob50_reward,2);...
    num2cell(mean_gaze_array.prob100_reward,2)];
data_in_punish = [num2cell(mean_gaze_array.prob0_punish,2);...
    num2cell(mean_gaze_array.prob50_punish,2);...
    num2cell(mean_gaze_array.prob100_punish,2)];

label_in = [repmat({'1_prob0'},size(bf_data_punish,1),1);...
    repmat({'2_prob50'},size(bf_data_punish,1),1);...
    repmat({'3_prob100'},size(bf_data_punish,1),1)];

figure_plot(1,1)=gramm('x',eye_alignWin,'y',data_in_reward,'color',label_in);
figure_plot(1,1).stat_summary();
figure_plot(1,1).axe_property('XLim',[-1000 3000],'YLim',[0 1]);
figure_plot(1,1).set_names('x','Time from CS Onset (ms)','y','P(Gaze at CS)');
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

%% BLINK DETECTION.

neuron_i = 3; 

figure; hold on

for trl_i = 1:length(bf_data_punish.trials{neuron_i}.prob100_punish)
    trl_j = bf_data_punish.trials{neuron_i}.prob100_punish(trl_i);
    plot(eye_alignWin,eye_pos_table.eye_x{neuron_i}(trl_j,:),'k')
end
