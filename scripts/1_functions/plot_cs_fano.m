function [data_out] = plot_cs_fano(data_in, datasheet_in)

% Initialize plot data structures
plot_time = [-5000:5000];
time_zero = abs(plot_time(1));

baseline_win = [-1000:3500];

fano_out_uncertain = [];
fano_out_certain = [];

for neuron_i = 1:size(data_in,1)
    
    switch datasheet_in.site{neuron_i}
        case 'nih'
            outcome_time = 1500;
            fano_window = [outcome_time-1000:outcome_time];
            
        case 'wustl'
            outcome_time = 2500;
            fano_window = [outcome_time-1000:outcome_time];
    end

    fano_continuous = [];
    fano_continuous = find(ismember(data_in.fano(neuron_i).time,fano_window));
    
    fano_out_uncertain = ...
        [fano_out_uncertain;...
        nanmean(data_in.fano(neuron_i).raw.uncertain(fano_continuous))];
    
    fano_out_certain = ...
        [fano_out_certain;...
        nanmean(data_in.fano(neuron_i).raw.certain(fano_continuous))];    
end


data_out.uncertain = fano_out_uncertain;
data_out.certain = fano_out_certain;
