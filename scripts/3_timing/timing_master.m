% Working from DataANALYSIS_timingProcedure

%% Curation: generate a datamap
% > INSERT DESCRIPTION HERE

count = 0;
bf_datasheet_timingExp = struct();

% Monkey W %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_dir.wolverine = 'X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingProcedure\BFramping\';
data_dir_info = []; data_dir_info = dir (fullfile(data_dir.wolverine, '*.mat'));

for file_i = 1:size(data_dir_info,1)
    count = count + 1;
    
    bf_datasheet_timingExp(count).dir = data_dir.wolverine;
    bf_datasheet_timingExp(count).file = data_dir_info(file_i).name;
    bf_datasheet_timingExp(count).monkey = 'wolverine';
    bf_datasheet_timingExp(count).area = 'bf';
    bf_datasheet_timingExp(count).site = 'wustl';
    bf_datasheet_timingExp(count).type = 'tonic';
end

% Monkey B %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_dir.batman = 'X:\MONKEYDATA\Batman\Timingprocedure_Basilforebrain\BFtonic\';
data_dir_info = []; data_dir_info = dir (fullfile(data_dir.batman, '*.mat'));

for file_i = 1:size(data_dir_info,1)
    count = count + 1;
    
    bf_datasheet_timingExp(count).dir = data_dir.batman;
    bf_datasheet_timingExp(count).file = data_dir_info(file_i).name;
    bf_datasheet_timingExp(count).monkey = 'batman';
    bf_datasheet_timingExp(count).area = 'bf';
    bf_datasheet_timingExp(count).site = 'wustl';
    bf_datasheet_timingExp(count).type = 'tonic';
end

% Monkey R %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_dir.robin = 'X:\MONKEYDATA\Robin_ongoing\TimingProcedureBF\BFtonic\';
data_dir_info = []; data_dir_info = dir (fullfile(data_dir.robin, '*.mat'));

for file_i = 1:size(data_dir_info,1)
    count = count + 1;
    
    bf_datasheet_timingExp(count).dir = data_dir.robin;
    bf_datasheet_timingExp(count).file = data_dir_info(file_i).name;
    bf_datasheet_timingExp(count).monkey = 'robin';
    bf_datasheet_timingExp(count).area = 'bf';
    bf_datasheet_timingExp(count).site = 'wustl';
    bf_datasheet_timingExp(count).type = 'tonic';
end

% Monkey Z %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
data_dir.zombie = 'X:\MONKEYDATA\ZOMBIE_ongoing\BF_timingprocejure\Ramping\';
data_dir_info = []; data_dir_info = dir (fullfile(data_dir.zombie, '*.mat'));

for file_i = 1:size(data_dir_info,1)
    count = count + 1;
    
    bf_datasheet_timingExp(count).dir = data_dir.zombie;
    bf_datasheet_timingExp(count).file = data_dir_info(file_i).name;
    bf_datasheet_timingExp(count).monkey = 'zombie';
    bf_datasheet_timingExp(count).area = 'bf';
    bf_datasheet_timingExp(count).site = 'wustl';
    bf_datasheet_timingExp(count).type = 'tonic';
end

bf_datasheet_timingExp = struct2table(bf_datasheet_timingExp);


%% Analysis: Extract relevant neurophys data

errorfile=cell(0);
bf_data_timingTask = table();

% For each identified neuron meeting the criteria, we will loop through,
% load the experimental data file, and extract the event aligned raster.
for ii = 1:size(bf_datasheet_timingExp,1)
    
    % Clear variables, console, and figures
    clear REXPDS trials Rasters SDFcs_n fano; clc; close all;
    
    filename = bf_datasheet_timingExp.file{ii};
    fprintf('Extracting data from neuron %i of %i   |  %s   \n',ii,size(bf_datasheet_timingExp,1), filename)
    
    % Load the data (PDS structure)
    load(fullfile(bf_datasheet_timingExp.dir{ii},bf_datasheet_timingExp.file{ii}),'PDS');
    
    % Get trial indices
    trials = get_trials_timingTask(PDS);
    
    % Get event aligned rasters
    Rasters = get_timing_raster(PDS, trials, params); % Derived from Timing2575Group.m
    
    % Get event aligned spike-density function
    SDF = plot_mean_psth({Rasters},params.sdf.gauss_ms,1,size(Rasters,2),1);
    
    % Output extracted data into a table
    bf_data_timingTask(ii,:) = table({filename}, {trials}, {Rasters},{SDF},...
        'VariableNames',{'filename','trials','rasters','sdf'});

end

%%
params.fano.bin_size = 25;
clear fano
parfor neuron_i = 1:size(bf_datasheet_timingExp,1)
    
    fprintf('Calculating Fano Factor for neuron %i of %i   |  %s   \n',...
        neuron_i,size(bf_datasheet_timingExp,1), bf_datasheet_timingExp.file{neuron_i})

    % Calculate Fano Factor
    fano(neuron_i) = get_fano(bf_data_timingTask.rasters{neuron_i},...
        bf_data_timingTask.trials{neuron_i}, params);

end


for neuron_i = 1:size(bf_datasheet_timingExp,1)
    
    figure(neuron_i);
    subplot(2,1,1); hold on
    plot(-5000:5000,nanmean(bf_data_timingTask.sdf{neuron_i}(bf_data_timingTask.trials{neuron_i}.fractal6201_d,:)))
    plot(-5000:5000,nanmean(bf_data_timingTask.sdf{neuron_i}(bf_data_timingTask.trials{neuron_i}.fractal6201_nd,:)))
    xlim([-200 2000]); vline(1500,'k'); vline(0, 'k'); 
        
    subplot(2,1,2); hold on
    plot(fano(neuron_i).time,fano(neuron_i).raw.fractal6201_d)
    plot(fano(neuron_i).time,fano(neuron_i).raw.fractal6201_nd)
    xlim([-200 2000]); ylim([0 4]); hline(1,'k'), vline(1500, 'k'); vline(0,'k');
    
end


%% Analysis: epoched Fano Factor
% In progress - 1539, Feb 1st
clear epoch
epoch.fixation = [0 200]; epoch.preCS = [-200 0]; epoch.postCS = [0 200];
epoch.midCS = [650 850]; epoch.preOutcome = [-200 0]; epoch.postOutcome = [0 200];

epoch_zero.fixation = [-1000]; epoch_zero.preCS = [0]; epoch_zero.postCS = [0];
epoch_zero.midCS = [0]; epoch_zero.preOutcome = [1500]; epoch_zero.postOutcome = [1500];

epoch_labels = fieldnames(epoch);

fano = struct();
for neuron_i = 1:size(bf_datasheet_timingExp,1)
    
    for epoch_i = 1:length(epoch_labels)
        
        fano_windowed = get_fano_window(bf_data_timingTask.rasters{neuron_i},...
            bf_data_timingTask.trials{neuron_i},...
            epoch.(epoch_labels{epoch_i}) + epoch_zero.(epoch_labels{epoch_i})); % @ moment, centers on 0

        test_prob75(neuron_i,epoch_i) = fano_windowed.window.p75s_25l_short;
        test_prob50(neuron_i,epoch_i) = fano_windowed.window.p50s_50l_short;
        test_prob25(neuron_i,epoch_i) = fano_windowed.window.p25s_75l_short;

    end
    
end


figure('Renderer', 'painters', 'Position', [100 100 800 800])
subplot(1,1,1)
% Initialize data points
D1 = nanmean(test_prob75);
D2 = nanmean(test_prob50);
D3 = nanmean(test_prob25);
P = [D1; D2; D3];

AxesPrecision = 0;

% Spider plot
spider_plot(P,...
    'AxesLabels', {'Fixation', 'Pre-CS', 'Post-CS', 'Mid', 'Pre-outcome', 'Post-outcome'},...
    'AxesLimits', [0, 0, 0, 0, 0, 0; 4, 4, 4, 4, 4, 4],... % [min axes limits; max axes limits]
    'AxesPrecision', [AxesPrecision, AxesPrecision, AxesPrecision, AxesPrecision, AxesPrecision, AxesPrecision]);

My_LGD = legend({'75%','50%','25%'}, 'Location', 'SouthOutside','Orientation','Horizontal');
My_LGD.NumColumns = 3;

title('Ramping Neurons (Timing Task)')



