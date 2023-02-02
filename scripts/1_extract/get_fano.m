function fano = get_fano(Rasters, trials, params)

% Define windows and times
range_window = [-4999 5001]; event_zero = 5000;
analysis_win = event_zero+range_window(1):event_zero+range_window(2);

% Get list of trial types
trial_type_list = fieldnames(trials);

fano = struct();

for trial_type_i = 1:length(trial_type_list)
    trial_type_label = trial_type_list{trial_type_i};
    
    raster_in = [];
    raster_in = Rasters (trials.(trial_type_label),:);
    
    %% Calculate Fano Factor
    
    % For each bin...
    for bin_i = 1:size(raster_in,2)-params.fano.bin_size
        
        % Get the array indices for the bin
        binAnalysis = [bin_i:bin_i+params.fano.bin_size];
        time(bin_i) = median(binAnalysis) - event_zero;
        
        % Find all spikes within the bin window for each trial
        spk_bin = raster_in(:,binAnalysis);
        E_spk_bin = nansum(spk_bin')';
        fano.raw.(trial_type_label)(1,bin_i) = (std(E_spk_bin)^2)./mean(E_spk_bin);
        
    end
    
    
    fano.smooth.(trial_type_label) = smooth(fano.raw.(trial_type_label), params.fano.smooth_bin)';
    
end

fano.time = time;


end


