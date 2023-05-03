%% Generate test data
% Define the parameters
Fs = 1000; % Sampling rate
f = 40; % Frequency of oscillation
t = 0:1/Fs:(10000-1)/Fs; % Time vector
x = sin(2*pi*f*t); % Sine wave with 40 Hz frequency
y = x > 0; % Convert the sine wave to a binary process
% Plot the binary process
figure
plot(t, y);
xlabel('Time (s)');
ylabel('Amplitude');
title('Binary Process with 40 Hz Oscillation');
p = 0.5; % probability of 1
%%x = rand(1,N) < p; % binary process
xlim([0 1])

%% Import observed data
neuron_i = 17;
baseline_window = [-2000:0];
load('C:\Users\Steven\Documents\GitHub\2023-basal-timing\data\large\bf_data_CS')

Fs = 1000; % sampling frequency
amplitudes_out = []; raster_out = [];

for trial_i = 1:length(bf_data_CS.trials{neuron_i,1}.probAll)
    
    input_raster = [];
    input_raster = bf_data_CS.rasters{neuron_i,1}(bf_data_CS.trials{neuron_i,1}.probAll(trial_i),baseline_window+5000);
    
    clear y x N xdft psdx freq frequencies amplitudes
    y=input_raster;
    x=y;
    N = length(input_raster); % number of samples
    
    
    % Compute and plot PSD
    xdft = fft(x);
    xdft = xdft(1:N/2+1);
    psdx = (1/(Fs*N)) * abs(xdft).^2;
    psdx(2:end-1) = 2*psdx(2:end-1);
    freq = 0:Fs/N:Fs/2;
    
    % Compute the Fourier transform of the binary process
    N = length(y);
    Y = fft(y)/N;
    frequencies = linspace(0, Fs/2, N/2+1);
    amplitudes = 2*abs(Y(1:N/2+1));
    
    amplitudes_out(trial_i,:) = amplitudes;
    raster_out(trial_i,:) = input_raster;
end



% Plot the power spectrum
figure; hold on
for trial_i = 1:length(bf_data_CS.trials{neuron_i,1}.probAll)
    subplot(2,1,1); hold on
    plot(baseline_window,raster_out(trial_i,:),'color',[0 0 0 0.01])
    
    subplot(2,1,2); hold on
    plot(frequencies, amplitudes_out(trial_i,:),'color',[0 0 0 0.2]);
end
subplot(2,1,1); plot(baseline_window, mean(raster_out),'color','r');
subplot(2,1,2); plot(frequencies, mean(amplitudes_out),'color','r');

xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Power Spectrum of Binary Process');
xlim([0 100]); ylim([0 0.02])

% Identify significant oscillations
Num_=2;
threshold = mean(amplitudes) + std(amplitudes)*Num_;
significant_frequencies = frequencies(amplitudes > threshold);
fprintf('Significant frequencies: %s\n', num2str(significant_frequencies));