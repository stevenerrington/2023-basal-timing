% Working from DataANALYSIS_timingProcedure
clear dir
%% Curation: generate a datamap
% > INSERT DESCRIPTION HERE

count = 0;
striatum_datasheet_timingExp = struct();
striatum_datasheet_timingExp = readtable(fullfile(dirs.root,'docs','timingTask_bg_neurons.xlsx'));

%% Analysis: Extract relevant neurophys data

errorfile=cell(0);
striatum_data_timingTask = table();

% For each identified neuron meeting the criteria, we will loop through,
% load the experimental data file, and extract the event aligned raster.
for ii = 1:size(striatum_datasheet_timingExp,1)
    
    % Clear variables, console, and figures
    clear PDS trials Rasters SDFcs_n fano; clc; close all;
    
    filename = striatum_datasheet_timingExp.file{ii};
    fprintf('Extracting data from neuron %i of %i   |  %s   \n',ii,size(striatum_datasheet_timingExp,1), filename)
    
    % Load the data (PDS structure)
    load(fullfile(striatum_datasheet_timingExp.dir{ii},striatum_datasheet_timingExp.file{ii}),'PDS');
    
    % Get trial indices
    trials = get_trials_timingTask(PDS);
    
    % Get event aligned rasters
    Rasters = get_timing_raster(PDS, trials, params); % Derived from Timing2575Group.m
    
    % Get event aligned spike-density function
    SDF = plot_mean_psth({Rasters},params.sdf.gauss_ms,1,size(Rasters,2),1);
    
    % Get licking data
    Licking = []; 
    %Licking = get_licking_raster(PDS,params); 
    
    % Get eye data
    Eye = get_eye_timing(PDS, params);
    
    % Output extracted data into a table
    striatum_data_timingTask(ii,:) = table({filename}, {trials}, {Rasters},{SDF},{Licking},{Eye},...
        'VariableNames',{'filename','trials','rasters','sdf','licking','eye'});

end

%% Analysis: Extract fano factor

clear fano
parfor neuron_i = 1:size(striatum_datasheet_timingExp,1)
    
    fprintf('Calculating Fano Factor for neuron %i of %i   |  %s   \n',...
        neuron_i,size(striatum_datasheet_timingExp,1), striatum_datasheet_timingExp.file{neuron_i})

    % Calculate Fano Factor
    fano(neuron_i) = get_fano(striatum_data_timingTask.rasters{neuron_i},...
        striatum_data_timingTask.trials{neuron_i}, params);

end

striatum_data_timingTask.fano = fano';
clear fano

%% Analysis: Calculate the inter-spike interval distribution for each trial condition

parfor neuron_i = 1:size(striatum_datasheet_timingExp,1)
    
    fprintf('Calculating ISI distribution for neuron %i of %i   |  %s   \n',...
        neuron_i,size(striatum_datasheet_timingExp,1), striatum_datasheet_timingExp.file{neuron_i})
    
    % Calculate Fano Factor
    isi(neuron_i) = get_isi(striatum_data_timingTask.rasters{neuron_i},...
        striatum_data_timingTask.trials{neuron_i});
    
end

striatum_data_timingTask.isi = isi'; clear isi


%% % Cuttings
% 
% for neuron_i = 1:size(bf_datasheet_timingExp,1)
%     
%     figure(neuron_i);
%     subplot(2,1,1); hold on
%     plot(-5000:5000,nanmean(bf_data_timingTask.sdf{neuron_i}(bf_data_timingTask.trials{neuron_i}.p25s_75l_short,:)))
%     plot(-5000:5000,nanmean(bf_data_timingTask.sdf{neuron_i}(bf_data_timingTask.trials{neuron_i}.p50s_50l_short,:)))
%     plot(-5000:5000,nanmean(bf_data_timingTask.sdf{neuron_i}(bf_data_timingTask.trials{neuron_i}.p75s_25l_short,:)))
%     xlim([-200 2000]); vline(1500,'k'); vline(0, 'k'); 
%         
%     subplot(2,1,2); hold on
%     plot(bf_data_timingTask.fano(neuron_i).time,bf_data_timingTask.fano(neuron_i).raw.p25s_75l_short)
%     plot(bf_data_timingTask.fano(neuron_i).time,bf_data_timingTask.fano(neuron_i).raw.p50s_50l_short)
%     plot(bf_data_timingTask.fano(neuron_i).time,bf_data_timingTask.fano(neuron_i).raw.p75s_25l_short)
%     xlim([-200 2000]); ylim([0 4]); hline(1,'k'), vline(1500, 'k'); vline(0,'k');
%     
% end
% 
% 
