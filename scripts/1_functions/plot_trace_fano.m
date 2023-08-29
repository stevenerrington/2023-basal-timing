function [data_out] = plot_trace_fano(data_in)

% Initialize plot data structures
plot_time = [-5000:5000];
time_zero = abs(plot_time(1));

baseline_win = [-1000:3500];

fano_out_notrace_certain = [];
fano_out_notrace_uncertain = [];
fano_out_trace_certain = [];
fano_out_trace_uncertain = [];

for neuron_i = 1:size(data_in,1)
    
    
    
    outcome_time = 2500;
    fano_window = [outcome_time-1000:outcome_time];
    
    fano_continuous = [];
    fano_continuous = find(ismember(data_in.fano(neuron_i).time,fano_window));
    
    fano_out_notrace_certain = ...
        [fano_out_notrace_certain;...
        nanmean(data_in.fano(neuron_i).raw.notrace_certain(fano_continuous))];
    
    fano_out_notrace_uncertain = ...
        [fano_out_notrace_uncertain;...
        nanmean(data_in.fano(neuron_i).raw.notrace_uncertain(fano_continuous))];    

    fano_out_trace_certain = ...
        [fano_out_trace_certain;...
        nanmean(data_in.fano(neuron_i).raw.certain(fano_continuous))];
    
    fano_out_trace_uncertain = ...
        [fano_out_trace_uncertain;...
        nanmean(data_in.fano(neuron_i).raw.uncertain(fano_continuous))];  


end


data_out.uncertain_trace = fano_out_trace_uncertain;
data_out.uncertain_notrace = fano_out_notrace_uncertain;
data_out.certain_trace = fano_out_trace_certain;
data_out.certain_notrace = fano_out_notrace_certain;
