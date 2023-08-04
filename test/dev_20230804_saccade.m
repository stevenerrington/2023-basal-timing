data_in = bf_data_CS;
datasheet_in = bf_datasheet_CS;

for neuron_i = 1:size(data_in,1)
    
    clear nTrls saccade_raster 
    fprintf('Analysing neuron %i of %i | %s    \n',neuron_i,size(data_in,1),data_in.filename{neuron_i});    
    nTrls = size(data_in.sdf{neuron_i},1);
    saccade_raster = zeros(nTrls,length(params.eye.alignWin));
    
    switch datasheet_in.site{neuron_i}
        case 'nih'
            outcome_time = 1500;
            
        case 'wustl'
            outcome_time = 2500;
    end
    
    
    for trial_i = 1:nTrls
        
        % Get eye trace (X,Y)
        eyetrace = [];
        eyetrace = [data_in.eye{neuron_i}.eye_x{1,1}(trial_i,:)',...
            data_in.eye{neuron_i}.eye_y{1,1}(trial_i,:)'];
        
        % Run saccade extraction
        saccade_info = [];
        [saccade_info,~] = saccade_detector(eyetrace,params);
        
        if ~isempty(saccade_info)
            % Get time of saccade execution
            saccade_raster(trial_i,saccade_info(:,2)) = 1;
            sacc_times = saccade_info(:,2)-1000;
            sacc_times = sacc_times(sacc_times > 0 & sacc_times < outcome_time);
            pseudo_sacc_times = [];
            pseudo_sacc_times = sort(datasample([500:outcome_time],length(sacc_times)));

            if sacc_times > 1
                
                
                for sacc_i = 1:length(sacc_times)
                    test(sacc_i,:) = data_in.sdf{neuron_i}(trial_i,5001+sacc_times(sacc_i)+[-500:500]);
                    psuedo_test(sacc_i,:) = data_in.sdf{neuron_i}(trial_i,5001+pseudo_sacc_times(sacc_i)+[-500:500]);
                end
                
                test_out(trial_i,:) = nanmean(test);
                test_out_b(trial_i,:) = nanmean(psuedo_test);
            end
        else
                test_out(trial_i,:) = nan(1,length([-500:500]));
                test_out_b(trial_i,:) = nan(1,length([-500:500]));
       end
        
    end
    
    sacc_trig_sdf{neuron_i,1} = test_out; clear test_out
    sacc_trig_sdf{neuron_i,2} = test_out_b; clear test_out_b
    saccade_raster_out{neuron_i,1} = saccade_raster;
    
end

for neuron_i = 1:size(data_in)
    
%     M(neuron_i,:) = movsum(mean(saccade_raster_out{neuron_i,1}(data_in.trials{neuron_i}.uncertain,:)),[25 25]);
%     M2(neuron_i,:) = movsum(mean(saccade_raster_out{neuron_i,1}(data_in.trials{neuron_i}.certain,:)),[25 25]);
%     
%     M(neuron_i,1:50) = NaN; M2(neuron_i,1:50) = NaN;
%     M(neuron_i,end-50:end) = NaN; M2(neuron_i,end-50:end) = NaN;
%     
%     N(neuron_i,:) = nanmean(p_gaze_window{neuron_i}(data_in.trials{neuron_i}.uncertain,:));
%     N2(neuron_i,:) = nanmean(p_gaze_window{neuron_i}(data_in.trials{neuron_i}.certain,:));
%     
    O(neuron_i,:) = nanmean(sacc_trig_sdf{neuron_i,1}(data_in.trials{neuron_i}.uncertain,:))...
        ./ nanmean(sacc_trig_sdf{neuron_i,1}(data_in.trials{neuron_i}.uncertain,500));
    O2(neuron_i,:) = nanmean(sacc_trig_sdf{neuron_i,2}(data_in.trials{neuron_i}.uncertain,:))...
        ./ nanmean(sacc_trig_sdf{neuron_i,2}(data_in.trials{neuron_i}.uncertain,500));
end



figure; hold on
plot([-500:500],nanmean(O)); 
plot([-500:500],nanmean(O2)); 






wustl_idx = strcmp(bf_datasheet_CS.site,'wustl');
nih_idx = strcmp(bf_datasheet_CS.site,'nih');

figure; 
subplot(2,2,1); hold on
plot(params.eye.alignWin,nanmean(M(nih_idx,:))); 
plot(params.eye.alignWin,nanmean(M2(nih_idx,:))); 
vline(0,'k');
vline(1500,'k--');

subplot(2,2,2); hold on
plot(params.eye.alignWin,nanmean(M(wustl_idx,:))); 
plot(params.eye.alignWin,nanmean(M2(wustl_idx,:))); 
vline(0,'k');
vline(2500,'k--');

subplot(2,2,3); hold on
plot(params.eye.alignWin,nanmean(N(nih_idx,:))); 
plot(params.eye.alignWin,nanmean(N2(nih_idx,:))); 
vline(0,'k');
vline(1500,'k--');

subplot(2,2,4); hold on
plot(params.eye.alignWin,nanmean(N(wustl_idx,:))); 
plot(params.eye.alignWin,nanmean(N2(wustl_idx,:))); 
vline(0,'k');
vline(2500,'k--');

