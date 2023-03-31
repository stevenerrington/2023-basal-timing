%% Setup
% Clear workspace
clear all; close all; clc; beep off; warning off;

% Define paths & key directories
dirs = get_dirs_bf('wustl');
params = get_params;
status = get_status(dirs);
count = 0;
params.raster.cleanFlag = 0;

%% Import datamap
nih_datasheet = readtable(fullfile(dirs.root,'docs','nih_test.xlsx'));
nih_datasheet = nih_datasheet(nih_datasheet.task == 1,:);

nih_data_dir = 'Y:\Steven\dataMRDR';
file_out_dir = 'Y:\Steven\dataMRDR\figures';

% dev: find all files in the nih data dir.

fileList = struct2table(dir([nih_data_dir '\*E']));
fileList = fileList.name;

% [42, 86, 161, 196, 214, 259, 263, 269, 361, 697, 1310, 1341, 1342, 1344] % faulty
% skipped 1345 to 1400. TEST 0945 20230331

%% Load example data
for file_i = 1400:size(fileList,1)
%         switch nih_datasheet.monkey(file_i)
%             case 1; monk = 'han';
%             case 2; monk = 'peek';
%             case 3; monk = 'han';
%         end
%         
        %file = [monk nih_datasheet.unit{file_i} 'E'];
        file = fileList{file_i};
        fprintf('Extracting data from %s | %i of %i        \n', file, file_i, size(fileList,1));
    
    try
        clear REX trials Rasters SDF
        
        % Import REX file
        REX = mrdr('-a', '-d', fullfile(nih_data_dir,file));
        
        % Get relevant trials
        data_in.trials = get_rex_trials_punish(REX);
        % Get event aligned rasters
        data_in.rasters = get_rex_raster(REX, data_in.trials, params); % Derived from Timing2575Group.m
        % Get event aligned spike-density function
        data_in.sdf = plot_mean_psth({data_in.rasters},params.sdf.gauss_ms,1,size(data_in.rasters,2),1);
        % Get fano factor
        data_in.fano = get_fano(data_in.rasters,data_in.trials, params);
        
        %% Generate figure
        plot_trial_types_reward = {'prob0_reward','prob50_reward','prob100_reward'};
        plot_trial_types_punish = {'prob0_punish','prob50_punish','prob100_punish'};
        params.plot.colormap = cool(length(plot_trial_types_reward));
        params.plot.xlim = [-500 2000]; params.plot.ylim = [0 80];
        params.plot.xintercept = 1500;
        
        [~, figure_plot_reward, ~] = plot_example_punish(data_in,plot_trial_types_reward,params,1);
        [~, figure_plot_punish, ~] = plot_example_punish(data_in,plot_trial_types_punish,params,1);
        
        figure_plot = [figure_plot_reward,figure_plot_punish];
        figure_plot(1,1).set_title('Reward'); figure_plot(1,2).set_title('Punish'); 

        figure_plot_out = figure('Renderer', 'painters', 'Position', [100 100 1000 700]);
        figure_plot.draw();
    
        save_figure(figure_plot_out,file_out_dir,['bf_punish_' file])
    catch
        file = fileList{file_i};
        count = count + 1;
        errorfile{count,1} = file;
    end

end
% 
% %% Curation: define datamap for ramp specific neurons
% 
% ramp_uncertainty_neuron_index = [369, 709, 725, 1012, 1015, 1071, 1082, 1086, 1092, 2030];
% test = table();
% for neuron_i = 1:length(ramp_uncertainty_neuron_index)
%     nih_datasheet_idx = find(strcmp(nih_datasheet.unit, int2str(ramp_uncertainty_neuron_index(neuron_i))),1);
%     
%     depth = nih_datasheet.depth(nih_datasheet_idx);
%     ap = nih_datasheet.a(nih_datasheet_idx);
%     ml = nih_datasheet.b(nih_datasheet_idx);
%     
%     test(neuron_i,:) = table(depth,ap,ml);
%     
% end
% 
% 









%% Archive
% figure; hold on
% plot([-5000:5000],nanmean(SDF(trials.prob0,:)))
% plot([-5000:5000],nanmean(SDF(trials.prob50d,:)))
% plot([-5000:5000],nanmean(SDF(trials.prob100,:)))
% legend({'0%','50%','100%'}); title(file)
% xlim([-200 2000]); vline([0 1500],'k')
% xlabel('Time from CS (ms)'); ylabel('Firing rate (spks/sec)')
