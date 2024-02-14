function [autocorr, lag] = compute_autocorrelation(spike_times, time_window, bin_size)
    % Compute autocorrelation for spike times.
    % Inputs:
    % spike_times - Array of spike times
    % time_window - Total time duration of the spike train
    % bin_size - Size of the time bins for histogram

    edges = 0:bin_size:time_window;
    spike_train = histcounts(spike_times, edges);

    length_train = length(spike_train);
    lag =0:length_train - 1;
    autocorr = xcorr(spike_train, spike_train, 'coeff');
    autocorr = autocorr(length_train:end);

end
