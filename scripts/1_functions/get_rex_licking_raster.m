function Rasters = get_rex_licking_raster(REX,params)

signal_cutoff = params.licking.signal_cutoff;

% Get event-aligned rasters %%%%%%%%%%%%%%%%%%%%%%%%
% Initialise relevant arrays
Rasters=[];

% Set alignment parameters
event_zero=5001;

nTrls = length(PDS.timetargeton);

for trial_i = 1:nTrls
    
    lick_signal_in = []; lick_signal_in = PDS.onlineLickForce{trial_i};
    lick_signal_in(:,2) = lick_signal_in(:,2)-lick_signal_in(1,2);
    
    smoothed_lick_signal = [];
    smoothed_lick_signal = smooth(lick_signal_in(:,1),10);
    
    abs_lick_time = [];
    [~,abs_lick_time] = findpeaks(smoothed_lick_signal,'MinPeakHeight',signal_cutoff,'MinPeakWidth',20);
    
    lick_times = [];
    lick_times = abs_lick_time-PDS.timetargeton(trial_i);
    
    if ~isempty(lick_times)
        % Change timing to ms, rather than sec
        lick_times = (lick_times)+event_zero-1;
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
        
    end
end
