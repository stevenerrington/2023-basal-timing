dir_data = 'X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\ProbAmt';

S = dir(fullfile(dir_data,'ProbAmtIsoLum_V3_*'));
N = {S.name};

for file_i = 1:length(N)
    
    clear c PDS
    load(fullfile(dir_data,N{file_i}),'c','PDS')
    filename = N{file_i}
    fprintf('Extracting data from neuron %i of %i   |  %s   \n',file_i,length(N), filename)
    
    if c.CS_dur == 2.5
        count = count + 1;

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
        
        
        bf_data_CS2(count,:) = table({filename}, {trials}, {Rasters},{SDF},{Licking},{Eye},...
            'VariableNames',{'filename','trials','rasters','sdf','licking','eye'});
    else
        continue
    end
    
    
end