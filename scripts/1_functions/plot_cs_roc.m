function [data_out] = plot_cs_roc(data_in, datasheet_in)


% Initialize plot data structures
plot_time = [-5000:5000];
time_zero = abs(plot_time(1));

baseline_win = [-1000:3500];

for neuron_i = 1:size(data_in,1)
    
    switch datasheet_in.site{neuron_i}
        case 'nih'
            outcome_time = 1500;
            max_win = [outcome_time-1000:outcome_time];

        case 'wustl'
            outcome_time = 2500;
            max_win = [outcome_time-1000:outcome_time];
    end
    
    % CS: certain x uncertain
    data1 = []; data1 = nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.certain,time_zero+max_win),2);
    data2 = []; data2 = nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.uncertain,time_zero+max_win),2);
    data_roc = []; data_roc = roc_curve(data1,data2);
    roc_out(neuron_i,1) = data_roc.param.AROC;
    
end


data_out.roc = roc_out;
