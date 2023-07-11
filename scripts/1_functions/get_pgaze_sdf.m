function [low_p_gaze_sdf_out, high_p_gaze_sdf_out,...
    low_p_gaze_fano_out, high_p_gaze_fano_out, low_high_gaze_ROC] =...
    get_pgaze_sdf(data_in, datasheet_in, trial_type_list, params)

min_trl_n  = 3;


for neuron_i = 1:size(data_in,1)
    baseline_trials{neuron_i} = [];
    
    for trial_type_i = 1:length(trial_type_list)
        trial_type = trial_type_list{trial_type_i};
        baseline_trials{neuron_i} = [baseline_trials{neuron_i}, data_in.trials{neuron_i}.(trial_type)];
    end
end

low_p_gaze_sdf_out = {}; high_p_gaze_sdf_out = {};
[p_gaze_window]  = get_pgaze_window_trial(data_in, params);

for trial_type_i = 1:length(trial_type_list)
    trial_type = trial_type_list{trial_type_i};
    
    
    for neuron_i = 1:size(data_in,1)
       fprintf('Analysing neuron %i of %i |   \n', neuron_i, size(data_in,1))
       
       
        switch datasheet_in.site{neuron_i}
            case 'wustl'
                outcome_time = 2500;
            case 'nih'
                outcome_time = 1500;                
        end
        
        timewin_eye = []; timewin_eye = [0:outcome_time]+find(params.eye.alignWin == 0);
        params.eye.window = [5 5];
        params.plot.xintercept = outcome_time;
        
        trl_in = []; trl_in = data_in.trials{neuron_i}.(trial_type);
        p_gaze_trl = mean(p_gaze_window{neuron_i}(trl_in,timewin_eye),2);
        
        low_p_gaze_trl = []; low_p_gaze_trl = trl_in(find(p_gaze_trl < 0.5));
        high_p_gaze_trl = []; high_p_gaze_trl = trl_in(find(p_gaze_trl > 0.5));
        
        mean_bl_fr = nanmean(nanmean(data_in.sdf{neuron_i}(baseline_trials{neuron_i},5001+[-1000:3500])));
        std_bl_fr = nanstd(nanmean(data_in.sdf{neuron_i}(baseline_trials{neuron_i},5001+[-1000:3500])));
        
        [fano_out_low,~] = get_simple_fano(data_in.rasters{neuron_i}(low_p_gaze_trl,:),params);
        [fano_out_high,time] = get_simple_fano(data_in.rasters{neuron_i}(high_p_gaze_trl,:),params);
        
        fano_continuous = [];
        fano_continuous = find(ismember(time,outcome_time+[-1000:0]));       
        
        fano_x_low = []; fano_x_low = fano_out_low(fano_continuous);
        fano_x_high = []; fano_x_high = fano_out_high(fano_continuous);
        low_high_ROC = [];
        
        
        if length(low_p_gaze_trl) > min_trl_n & length(high_p_gaze_trl) > min_trl_n
            low_p_gaze_sdf_onset = nanmean(data_in.sdf{neuron_i}(low_p_gaze_trl,5001+[-250:1000]));
            low_p_gaze_sdf_offset = nanmean(data_in.sdf{neuron_i}(low_p_gaze_trl,5001+outcome_time+[-1000:0]));
            
            high_p_gaze_sdf_onset = nanmean(data_in.sdf{neuron_i}(high_p_gaze_trl,5001+[-250:1000]));
            high_p_gaze_sdf_offset = nanmean(data_in.sdf{neuron_i}(high_p_gaze_trl,5001+outcome_time+[-1000:0]));
            
            temp = []; temp = roc_curve(nanmean(data_in.sdf{neuron_i}(low_p_gaze_trl,5001+outcome_time+[-500:0]),2),...
                nanmean(data_in.sdf{neuron_i}(high_p_gaze_trl,5001+outcome_time+[-500:0]),2));
            
            low_high_ROC = temp.param.AROC;
           
            low_p_gaze_fano = fano_x_low;
            high_p_gaze_fano = fano_x_high;
        else
            low_p_gaze_sdf_onset = nan(1,length(5001+[-250:1000]));
            low_p_gaze_sdf_offset = nan(1,length(5001+outcome_time+[-1000:0]));
            
            high_p_gaze_sdf_onset = nan(1,length(5001+[-250:1000]));
            high_p_gaze_sdf_offset = nan(1,length(5001+outcome_time+[-1000:0]));
            
            low_p_gaze_fano = nan(1,length(fano_continuous));
            high_p_gaze_fano = nan(1,length(fano_continuous));
            
            low_high_ROC = NaN;
        end
        
        low_p_gaze_sdf_out{1,trial_type_i}(neuron_i,:) = (low_p_gaze_sdf_onset-mean_bl_fr)./std_bl_fr;
        low_p_gaze_sdf_out{2,trial_type_i}(neuron_i,:) = (low_p_gaze_sdf_offset-mean_bl_fr)./std_bl_fr;
        
        high_p_gaze_sdf_out{1,trial_type_i}(neuron_i,:) = (high_p_gaze_sdf_onset-mean_bl_fr)./std_bl_fr;
        high_p_gaze_sdf_out{2,trial_type_i}(neuron_i,:) = (high_p_gaze_sdf_offset-mean_bl_fr)./std_bl_fr;
        
        low_p_gaze_fano_out{trial_type_i}(neuron_i,:) = low_p_gaze_fano;
        high_p_gaze_fano_out{trial_type_i}(neuron_i,:) = high_p_gaze_fano;
        
        low_high_gaze_ROC{trial_type_i}(neuron_i,:) = low_high_ROC;
        
        
    end
    
end

end

