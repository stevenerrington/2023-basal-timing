function isi = get_isi(Rasters, trials)

% Define windows and times
range_window = [-4999 5001]; event_zero = 5000;
baseline_win = [-750:-250]; ramp_win = [0:1000];

% Get list of trial types
trial_type_list = fieldnames(trials);

isi = struct();


for trial_type_i = 1:length(trial_type_list)
    trial_type_label = trial_type_list{trial_type_i};
    try
        raster_in = [];
        raster_in = Rasters (trials.(trial_type_label),:);
        
        isi_array_overall = [];
        isi_array_baseline = [];
        isi_array_ramp = [];
        
        for trl_i = 1:length(trials.(trial_type_label))
            isi_array_overall = [isi_array_overall, diff(find(raster_in(trl_i,:) == 1))];
            isi_array_baseline = [isi_array_overall, diff(find(raster_in(trl_i,baseline_win+event_zero) == 1))];
            isi_array_ramp = [isi_array_overall, diff(find(raster_in(trl_i,ramp_win+event_zero) == 1))];
        end
        
        isi.overall.(trial_type_label) = isi_array_overall;
        isi.baseline.(trial_type_label) = isi_array_baseline;
        isi.ramp.(trial_type_label) = isi_array_ramp;
    catch
        isi.overall.(trial_type_label) = [];
        isi.baseline.(trial_type_label) = [];
        isi.ramp.(trial_type_label) = [];
    end
end

end


