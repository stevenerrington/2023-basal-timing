bf_datasheet_CS2 = readtable(fullfile(dirs.root,'docs','Wolverine_Filelist_ActiveSheet.xls'));
bf_datasheet_CS2_raw = bf_datasheet_CS2;
% Get ramping cells only
bf_datasheet_CS2 = bf_datasheet_CS2(bf_datasheet_CS2.Type2Cells == 1 & bf_datasheet_CS2.uncertiantySleectivity == 1,:);
% Get ProbAmtIso sessions only
IndexC = regexp(bf_datasheet_CS2.Filename, regexptranslate('wildcard', 'ProbAmtIsoLum_V3*'));
Index = find(not(cellfun('isempty',IndexC)));
bf_datasheet_CS2 = bf_datasheet_CS2(Index,:);
bf_datasheet_CS2import = bf_datasheet_CS2;
dir_data = 'X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\ProbAmt';

%% Tidy: reformat datasheet for merge with other data
bf_datasheet_CStemp = table();
% For each identified datafile
for neuron_i = 1:size(bf_datasheet_CS2,1)
    % clear loop variables to stop contamination
    clear file monkey date ap_loc ml_loc depth area site dir
    
    % get file name and monkey name
    file = bf_datasheet_CS2.Filename(neuron_i);
    monkey = {'Wolverine'};
    
    date = bf_datasheet_CS2.Date_yy_mm_dd_(neuron_i); % Date of recording
    ap_loc = bf_datasheet_CS2.APlocation(neuron_i); % AP grid location
    ml_loc = bf_datasheet_CS2.MLlocation(neuron_i); % ML grid location
    depth = bf_datasheet_CS2.Depth(neuron_i);   % Recording depth
    area = {'BF'};   % Recording area
    site = {'wustl'};                         % Institution where data was recorded
    dir = {dir_data};    % Data storage directory
    cluster_id = 2;    % Data storage directory
    cluster_label = {'Ramping'};    % Data storage directory
    
    
    % Save variables to a row in the datatable
    bf_datasheet_CStemp(neuron_i,:) = table(file, monkey, date, ap_loc, ml_loc, depth, area, site, dir,cluster_id,cluster_label);
    
end

clear bf_datasheet_CS2
bf_datasheet_CS2 = bf_datasheet_CStemp; clear bf_datasheet_CStemp




%% Extract: get data from files
bf_data_CS2 = table();
for neuron_i = 1:size(bf_datasheet_CS2,1)
    
    clear c PDS
    load(fullfile(dir_data,bf_datasheet_CS2.file{neuron_i}),'c','PDS')
    filename = bf_datasheet_CS2.file{neuron_i};
    fprintf('Extracting data from neuron %i of %i   |  %s   \n',neuron_i,size(bf_datasheet_CS2,1), filename)

    % Get trial indices
    trials = get_trials_2500CS(PDS);
    % Get event aligned rasters
    Rasters = get_raster(PDS, trials, params); % Derived from Timing2575Group.m
    % Get event aligned spike-density function
    SDF = plot_mean_psth({Rasters},params.sdf.gauss_ms,1,size(Rasters,2),1);
    % Get licking raster
    Licking = [];
    % Get eye position
    Eye = get_eye_CS(PDS, params);
    
    bf_data_CS2(neuron_i,:) = table({filename}, {trials}, {Rasters},{SDF},{Licking},{Eye},...
        'VariableNames',{'filename','trials','rasters','sdf','licking','eye'});
    
end


%% Analysis: Calculate the fano factor for each trial condition

parfor neuron_i = 1:size(bf_datasheet_CS2,1)
    
    fprintf('Calculating Fano Factor for neuron %i of %i   |  %s   \n',...
        neuron_i,size(bf_datasheet_CS2,1), bf_data_CS2.filename{neuron_i})
    
    % Calculate Fano Factor
    fano(neuron_i) = get_fano(bf_data_CS2.rasters{neuron_i},...
        bf_data_CS2.trials{neuron_i}, params);
    
end

bf_data_CS2.fano = fano'; clear fano

%% Analysis: Calculate the inter-spike interval distribution for each trial condition

parfor neuron_i = 1:size(bf_datasheet_CS2,1)
    
    fprintf('Calculating ISI distribution for neuron %i of %i   |  %s   \n',...
        neuron_i,size(bf_datasheet_CS2,1), bf_data_CS2.filename{neuron_i})
    
    % Calculate Fano Factor
    isi(neuron_i) = get_isi(bf_data_CS2.rasters{neuron_i},...
        bf_data_CS2.trials{neuron_i});
    
end

bf_data_CS2.isi = isi'; clear isi




%% Cuttings

% %% 
% 
% close all; clc
% plot_trial_types = {'prob0','prob50','prob100'};
% params.plot.colormap = [0 0 1 ; 1 0 0; 0 0 0];
% 
% for neuron_i = 1:size(bf_datasheet_CS2,1)
%     % > Plot example ramping neuron in the basal forebrain.
%     params.plot.xlim = [-500 3500]; params.plot.ylim = [0 120]; params.plot.xintercept = [2500];
%     bf_example_CS_ramping = plot_example_neuron(bf_data_CS2,plot_trial_types,params,neuron_i,1);
%     pause
%     close all
% end
% 
% params.plot.xlim = [-1000 3500]; params.plot.ylim = [-5 5]; params.plot.xintercept = [2500];
% 
% plot_population_neuron(bf_data_CS2([2,5,6,9,10,11,13,14,15,16,17],:),plot_trial_types,params,1);
% 

% Extract: find corresponding timing task files for recorded CS neurons
% 
% timing_files = bf_datasheet_CS2_raw.Filename(bf_datasheet_CS2import.PairedRowIDFile2_procedure_(~isnan(bf_datasheet_CS2import.PairedRowIDFile2_procedure_)));
% IndexC = []; IndexC = regexp(timing_files, regexptranslate('wildcard', 'TimingProc*'));
% Index = []; Index = find(not(cellfun('isempty',IndexC)));
% timing_files = timing_files(Index,:);
% 
% clear bf_data_timing2
% for neuron_i = 1:size(timing_files,1)
%     
%     clear c PDS
%     filename = timing_files{neuron_i};
%     load(fullfile('X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingProcedure\AllCombined',filename),'PDS')
%     fprintf('Extracting data from neuron %i of %i   |  %s   \n',neuron_i,size(timing_files,1), filename)
% 
%     % Get trial indices
%     trials = get_trials_timingTask(PDS);
%     % Get event aligned rasters
%     Rasters = get_timing_raster(PDS, trials, params); % Derived from Timing2575Group.m
%     % Get event aligned spike-density function
%     SDF = plot_mean_psth({Rasters},params.sdf.gauss_ms,1,size(Rasters,2),1);
%     % Get licking raster
%     Licking = [];
%     % Get eye position
%     Eye = get_eye_timing(PDS, params);
%     
%     bf_data_timing2(neuron_i,:) = table({filename}, {trials}, {Rasters},{SDF},{Licking},{Eye},...
%         'VariableNames',{'filename','trials','rasters','sdf','licking','eye'});
%     
% end
% 
% parfor neuron_i = 1:size(bf_data_timing2,1)
%     
%     fprintf('Calculating Fano Factor for neuron %i of %i   |  %s   \n',...
%         neuron_i,size(bf_data_timing2,1), bf_data_timing2.filename{neuron_i})
%     
%     % Calculate Fano Factor
%     fano(neuron_i) = get_fano(bf_data_timing2.rasters{neuron_i},...
%         bf_data_timing2.trials{neuron_i}, params);
%     
% end
% 
% bf_data_timing2.fano = fano'; clear fano
% 
% % 
% % 
% % 
% % close all; clc
% % plot_trial_types = {'p50s_50l_short','p100s_0l_short'};
% % params.plot.colormap = [0 0 1 ; 1 0 0; 0 0 0];
% % 
% % for neuron_i = 1:size(bf_data_timing2,1)
% %     % > Plot example ramping neuron in the basal forebrain.
%     params.plot.xlim = [-500 2000]; params.plot.ylim = [0 80]; params.plot.xintercept = [1500];
%     bf_example_CS_ramping = plot_example_neuron(bf_data_timing2,plot_trial_types,params,neuron_i,1);
% end
% 
% params.plot.xlim = [-1000 2000]; params.plot.ylim = [-5 5]; params.plot.xintercept = [1500];
% plot_population_neuron(bf_data_timing2,plot_trial_types,params,1);
% 

