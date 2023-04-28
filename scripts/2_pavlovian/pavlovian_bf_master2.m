bf_datasheet_CS2 = readtable(fullfile(dirs.root,'docs','Wolverine_Filelist_ActiveSheet.xls'));

% Get ramping cells only
bf_datasheet_CS2 = bf_datasheet_CS2(bf_datasheet_CS2.Type2Cells == 1 a& bf_datasheet_CS2.uncertiantySleectivity == 1,:);
% Get ProbAmtIso sessions only
IndexC = regexp(bf_datasheet_CS2.Filename, regexptranslate('wildcard', 'ProbAmtIsoLum_V3*'));
Index = find(not(cellfun('isempty',IndexC)));
bf_datasheet_CS2 = bf_datasheet_CS2(Index,:);

dir_data = 'X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\ProbAmt';

for neuron_i = 1:size(bf_datasheet_CS2,1)
    
    clear c PDS
    load(fullfile(dir_data,bf_datasheet_CS2.Filename{neuron_i}),'c','PDS')
    filename = bf_datasheet_CS2.Filename{neuron_i};
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

%%