% Parameters
sampling_rate = 1000; % Sampling rate in Hz
time_duration = 10; % Duration of the SDF in seconds
t = 0:1/sampling_rate:time_duration - 1/sampling_rate; % Time vector

% Create a synthetic SDF with a 40 Hz component
sdf_base = 10; % Baseline firing rate in Hz
sdf_amplitude = 30; % Amplitude of the sinusoidal component in Hz
sdf_frequency = 40; % Frequency of the sinusoidal component in Hz
sdf = sdf_base + sdf_amplitude * sin(2*pi*sdf_frequency*t);

%%
time_window = [-2000:-1000];

sdf_in = sdf(5000+time_window);

% Create a sample input signal (you can replace this with your convolved spike train or any other data)
sampling_rate = 1000; % Sampling rate in Hz

% Calculate autocorrelation of the input signal
max_lag = round(sampling_rate); % Maximum lag for autocorrelation
autocorr = xcorr(sdf_in, max_lag, 'coeff'); % Calculate normalized autocorrelation

% Perform FFT on the autocorrelation function
autocorr_fft = fft(autocorr);

% Calculate the power spectral density (PSD)
psd = abs(autocorr_fft).^2 / length(autocorr);

% Generate frequency axis
nyquist_frequency = sampling_rate / 2;
frequency_resolution = sampling_rate / length(autocorr);
frequency_axis = 0:frequency_resolution:nyquist_frequency;

% Define the exponential decay function
exp_decay_func = @(params, x) params(1) * exp(-params(2) * x);

% Initial guess for fitting parameters [amplitude, decay rate]
initial_params = [max(psd), 0.01];

% Perform the fit using nonlinear least squares
fit_params = lsqcurvefit(exp_decay_func, initial_params, frequency_axis, 10*log10(psd(1:length(frequency_axis)))+100);

% Calculate the fitted PSD using the fitted parameters
fitted_psd = exp_decay_func(fit_params, frequency_axis);


%% Figure: plot data
% Plot the input signal, autocorrelation, and PSD
figure('Renderer', 'painters', 'Position', [100 100 400 800]);
subplot(3, 1, 1);
plot(time_window, sdf_in);
xlabel('Time (s)');
ylabel('Amplitude');
title('Input Signal');
grid on;
xlim([min(time_window) max(time_window)])

lags = (-max_lag:max_lag) / sampling_rate;
subplot(3, 1, 2);
stem(lags, autocorr, 'Marker', 'none');
xlabel('Lag (s)');
ylabel('Normalized Autocorrelation');
title('Autocorrelation of Input Signal');
grid on;

subplot(3, 1, 3); hold on
plot(frequency_axis, 10*log10(psd(1:length(frequency_axis))));
plot(frequency_axis, fitted_psd-100, 'r','LineWidth',2)
% plot(frequency_axis, , 'r')
xlabel('Frequency (Hz)');
ylabel('Power/Frequency (dB/Hz)');
title('Power Spectral Density (PSD)');
grid on;
xlim([0 140])
