clear out_autocorr_neuron
neuron_i = 16;
clear autocorr_out
for trial_i = 1:size(bf_data_CS.rasters{neuron_i},1)
    clear spikes
    spikes = bf_data_CS.rasters{neuron_i}(trial_i,:);
    sdf = bf_data_CS.sdf{neuron_i}(trial_i,:);

    % Calculate Autocorrelation
    clear autocorr_result*
    autocorr_result = xcorr(spikes,'coeff'); % 'coeff' normalizes the result
    autocorr_result_shuffled = xcorr(spikes(randperm(length(spikes))),'coeff'); % 'coeff' normalizes the result
    autocorr_out(trial_i,:) = autocorr_result;
    autocorr_out_shuffled(trial_i,:) = autocorr_result_shuffled;

end

lags = -length(spikes)+1:length(spikes)-1;

lag_focus = find(lags > -1000 & lags < 1000);

% Plot Autocorrelation
figuren('Renderer', 'painters', 'Position', [100 600 1000 400]); hold on;
line(lags(lag_focus),autocorr_out(:,lag_focus), 'Marker', 'none', 'LineWidth', 0.5,'color',[0 0 0 0.01]);
line(lags(lag_focus),nanmean(autocorr_out(:,lag_focus)), 'Marker', 'none', 'LineWidth', 1.5,'color',[1 0 0]);

std_a = nanstd(nanmean(autocorr_out_shuffled(:,lag_focus)));
mean_a = nanmean(nanmean(autocorr_out_shuffled(:,lag_focus)));

hline([mean_a mean_a+std_a*2],'b-')

axis([-500 500 0 0.5]);
xlabel('Lags');
ylabel('Autocorrelation');

% Display the figure
sgtitle('Autocorrelation of Neuron Spiking Activity');