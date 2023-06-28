function smooth_sdf = get_alt_sdf(in_data, data_type)

switch data_type
    case 'REX'
        raw_spk_times = [];
        for trial_i = 1:size(in_data,2)
            try
                trial_spk_times = []; trial_spk_times = double(in_data(trial_i).Units.Times);
                raw_spk_times = [raw_spk_times, trial_spk_times];
            end
        end
        
        % convolve whole spike train
        SessionSDF = SpkConvolver (raw_spk_times, double(in_data(size(in_data,2)).aEndTime)+20000, 'Gauss');
        
        for trl_i = 1:size(in_data,2)
            eventcodes = []; times = [];
            eventcodes = vertcat(in_data(trl_i).Events.Code);
            times = vertcat(in_data(trl_i).Events.Time);
            
            target_on = [];
            if ~isempty(find(eventcodes == 1101,1)) | ~isempty(find(eventcodes == 1100,1))
                target_on = double(times(find(eventcodes == 1100,1)));
                smooth_sdf(trl_i,:) = SessionSDF(target_on+[-5000:10000]);
           else
                smooth_sdf(trl_i,:) = NaN(1,length([-5000:10000]));
            end
            
        end
        
        
    case 'PDS'
        raw_spk_times = [];
        for trial_i = 1:size(in_data.trialstarttime,1)
            trial_spk_times = []; trial_spk_times = round(double(in_data.sptimes{trial_i}*1000));
            trial_start_time = []; trial_start_time = round(in_data.datapixxtime(trial_i)*1000);
            raw_spk_times = [raw_spk_times, trial_start_time+trial_spk_times];
        end
        
        SessionSDF = SpkConvolver (raw_spk_times, round(in_data.datapixxtime(end)*1000)+20000, 'Gauss');
        
        
        for trial_i = 1:size(in_data.trialstarttime,1)
            raw_targ_time = round(in_data.datapixxtime(trial_i)*1000)+...
                round(in_data.timetargeton(trial_i)*1000);
            
            if ~isnan(raw_targ_time)
                smooth_sdf(trial_i,:) = SessionSDF(raw_targ_time+[-5000:10000]);
            else
                smooth_sdf(trial_i,:) = NaN(1,length([-5000:10000]));
            end
        end
        
        
end

