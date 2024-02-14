function fano_struct = dev_fano_acrossNeuron (data_in, trial_type, params)

n_neurons = size(data_in,1);

% Find lowest trial n
for neuron_i = 1:n_neurons
    trial_n(neuron_i) = length(data_in(neuron_i,:).trials{1}.(trial_type));
end

trial_n_min = min(trial_n);

% Sample the corresponding number of trials for each neuron
for neuron_i = 1:n_neurons
    trial_subsample{neuron_i} = datasample(data_in(neuron_i,:).trials{1}.(trial_type),trial_n_min,'Replace',false);
end

% Restructure the raster from trial x time, to be neuron x time x trial
for trial_i = 1:trial_n_min
    for neuron_i = 1:n_neurons
        raster_restruct(neuron_i,:,trial_i) = data_in(neuron_i,:).rasters{1}(trial_subsample{neuron_i}(trial_i),:);
    end
end

% Define parameters for raster
range_window = [-4999 5001]; event_zero = 5000;
event_zero = 5000;

% For each trial
for trial_i = 1:trial_n_min
    % Get the raster
    raster_in = raster_restruct(:,:,trial_i);
    % ...and a shuffled version
    raster_shuffle = raster_restruct(:,randperm(size(raster_restruct,2)),trial_i);

    % then calculate fano
    % for each bin...
    for bin_i = 1:size(raster_in,2)-params.fano.bin_size

        % Get the array indices for the bin
        binAnalysis = [bin_i:bin_i+params.fano.bin_size];
        time(bin_i) = median(binAnalysis) - event_zero;

        % Find all spikes within the bin window for each trial
        spk_bin = raster_in(:,binAnalysis);
        spk_bin_shuffle = raster_shuffle(:,binAnalysis);

        E_spk_bin = nansum(spk_bin')';
        E_spk_bin_shuffle = nansum(spk_bin_shuffle')';

        fano_out(trial_i,bin_i) = (std(E_spk_bin)^2)./mean(E_spk_bin);
        fano_shuffle_out(trial_i,bin_i) = (std(E_spk_bin_shuffle)^2)./mean(E_spk_bin_shuffle);

    end
end

% Output the structure
fano_struct.fano = fano_out;
fano_struct.fano_shuffle = fano_shuffle_out;
fano_struct.time = time;