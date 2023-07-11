function [data_out, label_out] = get_slope_data_trace(data_in)
data_out = []; label_out = [];
trial_types = fieldnames(data_in);

for cond_i = 1:size(trial_types)
    
    mean_slope = cellfun(@nanmean,data_in.(trial_types{cond_i}).slope,'UniformOutput',false);
    mean_slope = cell2mat(cellfun(@nanmean,mean_slope,'UniformOutput',false))';
    
    data_out = [data_out; mean_slope];
    label_out = [label_out; repmat({[int2str(cond_i) '_' trial_types{cond_i}]},length(mean_slope),1)];
end

end