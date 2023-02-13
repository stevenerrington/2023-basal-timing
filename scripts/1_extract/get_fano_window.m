function fano = get_fano_window(Rasters, trials, window)

% Define windows and times
event_zero = 5000;
analysis_win = event_zero+window(1):event_zero+window(2);

% Get list of trial types
trial_type_list = fieldnames(trials);

fano = struct();

for trial_type_i = 1:length(trial_type_list)
    trial_type_label = trial_type_list{trial_type_i};
    
    raster_in = [];
    raster_in = Rasters (trials.(trial_type_label),:);
    
    %% Calculate Fano Factor
    
    % Find all spikes within the bin window for each trial
    spk_bin = raster_in(:,analysis_win);
    E_spk_bin = nansum(spk_bin')';
    fano.window.(trial_type_label) = (std(E_spk_bin)^2)./mean(E_spk_bin);
        
end

end


