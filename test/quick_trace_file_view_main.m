file_dir = 'X:\MONKEYDATA\BatmanLedbetteretalandWhiteMonosovandChen(olddata)\Batman\TimingTrace';
filename = 'TimingTrace_V7_07_07_2015_11_55';

quick_trace_file_view(filename, file_dir, params)


plot_trial_types = {'notrace_uncertain','notrace_certain','uncertain','certain'};

params.plot.xlim = [0 3000]; params.plot.ylim = [0 100];
params.plot.colormap = cool(length(plot_trial_types));
[~,~,~] = plot_example_neuron(bf_data_traceExp,plot_trial_types,params,1,1);