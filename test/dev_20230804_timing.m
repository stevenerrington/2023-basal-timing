% > CS task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% Spike density function --------------------------------------------
for example_neuron_i = 1:size(bf_data_timingTask,1)
    % > Onset -----------------------------------------------------------
    params.plot.colormap = cool(3);
    close all
    % Example
    params.plot.xlim = [0 2000]; params.plot.ylim = [0 100];
    [~,~,bf_example_CS_ramping_preCS] = plot_example_neuron(bf_data_timingTask,...
        {'p25s_75l_short','p50s_50l_short','p75s_25l_short'},...
        params,example_neuron_i,1);
    params.plot.xlim = [3000 5000]; params.plot.ylim = [0 100];
    [~,~,bf_example_CS_ramping_preCS] = plot_example_neuron(bf_data_timingTask,...
        {'p25s_75l_long','p50s_50l_long','p75s_25l_long'},...
        params,example_neuron_i,1);
    pause
end


% > CS task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% Spike density function --------------------------------------------
for example_neuron_i = [1 3 4 8 10 12 16 17 18 19 20 22 24 25 26 28 30 31 32 33]
    example_neuron_i
    % > Onset -----------------------------------------------------------
    params.plot.colormap = cool(3);
    close all
    % Example
    params.plot.xlim = [0 2000]; params.plot.ylim = [10 60];
    [~,~,bf_example_CS_ramping_preCS] = plot_example_neuron(bf_data_timingTask,...
        {'p25s_75l_all','p50s_50l_all','p75s_25l_all'},...
        params,example_neuron_i,1);
    pause
end

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% > CS task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
% Spike density function --------------------------------------------
for example_neuron_i = 1:size(striatum_data_timingTask,1)
    % > Onset -----------------------------------------------------------
    example_neuron_i
    % > Onset -----------------------------------------------------------
    params.plot.colormap = cool(3);
    close all
    % Example
    params.plot.xlim = [0 2000]; params.plot.ylim = [0 20];
    [~,~,bf_example_CS_ramping_preCS] = plot_example_neuron(striatum_data_timingTask,...
        {'p25s_75l_all','p50s_50l_all','p75s_25l_all'},...
        params,example_neuron_i,1);
    pause
end
