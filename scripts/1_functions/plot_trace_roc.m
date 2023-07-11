function [data_out] = plot_trace_roc(data_in,plot_trial_types)


% Initialize plot data structures
plot_time = [-5000:5000];
time_zero = abs(plot_time(1));

baseline_win = [-1000:3500];
max_win = [2000:2500];

for neuron_i = 1:size(data_in,1)
    all_prob_trials = [];
    for trial_type_i = 1:length(plot_trial_types)
        all_prob_trials = [all_prob_trials, data_in.trials{neuron_i}.(plot_trial_types{trial_type_i})];
    end
    
    % Normalization
    bl_fr_mean = nanmean(nanmean(data_in.sdf{neuron_i}(all_prob_trials,baseline_win+time_zero)));
    bl_fr_std = nanstd(nanmean(data_in.sdf{neuron_i}(all_prob_trials,baseline_win+time_zero)));
    max_fr = max(mean(data_in.sdf{neuron_i}(all_prob_trials,max_win+time_zero)));
    

    % Trace: certain x uncertain
    data1 = []; data1 = (nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.certain,time_zero+max_win),2)-bl_fr_mean)./bl_fr_std;
    data2 = []; data2 = (nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.uncertain,time_zero+max_win),2)-bl_fr_mean)./bl_fr_std;
    data_roc_trace = []; data_roc_trace = roc_curve(data1,data2);
    roc_out_trace(neuron_i,1) = data_roc_trace.param.AROC;
    
    % No trace: certain x uncertain
    data1 = []; data1 = (nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.notrace_certain,time_zero+max_win),2)-bl_fr_mean)./bl_fr_std;
    data2 = []; data2 = (nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.notrace_uncertain,time_zero+max_win),2)-bl_fr_mean)./bl_fr_std;
    data_roc_notrace = []; data_roc_notrace = roc_curve(data1,data2);
    roc_out_notrace(neuron_i,1) = data_roc_notrace.param.AROC;    
end


data_out.roc_trace = roc_out_trace;
data_out.roc_notrace = roc_out_notrace;
