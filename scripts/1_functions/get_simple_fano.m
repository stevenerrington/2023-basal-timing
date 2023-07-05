function [fano_out,time] = get_simple_fano(data_in,params)
% Define windows and times
range_window = [-4999 5001]; event_zero = 5000;
analysis_win = event_zero+range_window(1):event_zero+range_window(2);

raster_in = data_in;

%% Calculate Fano Factor

% For each bin...
for bin_i = 1:size(raster_in,2)-params.fano.bin_size
    
    % Get the array indices for the bin
    binAnalysis = [bin_i:bin_i+params.fano.bin_size];
    time(bin_i) = median(binAnalysis) - event_zero;
    
    % Find all spikes within the bin window for each trial
    spk_bin = raster_in(:,binAnalysis);
    E_spk_bin = nansum(spk_bin')';
    fano_out(1,bin_i) = (std(E_spk_bin)^2)./mean(E_spk_bin);
    
end

end