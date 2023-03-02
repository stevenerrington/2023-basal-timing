function Rasters = get_licking_raster(PDS,params)

signal_cutoff = params.licking.signal_cutoff;

% Get event-aligned rasters %%%%%%%%%%%%%%%%%%%%%%%%
% Initialise relevant arrays
Rasters=[];


% Set alignment parameters
event_zero=6001;

nTrls = length(PDS.timetargeton);

for trial_i = 1:nTrls
    
    
    lick_signal_in = []; lick_signal_in = PDS.onlineLickForce{trial_i};
    lick_signal_in(:,2) = lick_signal_in(:,2)-lick_signal_in(1,2);
    
    % Get baseline
    test = lick_signal_in(:,2) - PDS.timetargeton(trial_i);
    baseline_idx = find(test > params.licking.baseline(1)/1000 & test < params.licking.baseline(2)/1000);
    baseline_mean = mean(lick_signal_in(baseline_idx,1));
    baseline_std = std(lick_signal_in(baseline_idx,1));
    lick_threshold = baseline_mean + (baseline_std*signal_cutoff);
    
    abs_lick_time = [];
    [~,abs_lick_time] = findpeaks(lick_signal_in(:,1)','MinPeakHeight',lick_threshold,'MinPeakWidth',15);
    
    lick_times = [];
    lick_times = lick_signal_in(abs_lick_time,2)- PDS.timetargeton(trial_i);
    
    % ---------------------
    
    
    if ~isempty(lick_times)
        % Change timing to ms, rather than sec
        lick_times = (lick_times*1000)+event_zero-1;
        % Make a spike time an integer
        lick_times = fix(lick_times);
        
        % Clean any spike times that occur too late
        lick_times = lick_times(find(lick_times<event_zero*2));
        
        % Convert timings into a 0/1 logical raster array
        clear temp
        temp(1:event_zero*2) = 0;
        temp(lick_times) = 1;
        
        % Add trial raster to session raster
        Rasters(trial_i,:) = temp;
        
        % Clear arrays for next loop
        clear temp lick_times
        
    else
        clear temp
        temp(1:event_zero*2) = 0;
        Rasters(trial_i,:) = temp;
        clear temp lick_times
    end
end




Rasters = Rasters(:,event_zero-5000:event_zero+5000);

