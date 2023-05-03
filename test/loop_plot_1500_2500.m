
for ii = 1:size(bf_data_1500_ramping,1)
    
    % > CS task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    plot_trial_types = {'certain','uncertain'};
    params.plot.colormap = [2, 59, 56; 197, 39, 108]./255;
    
    %% > Plot example ramping neuron in the basal forebrain.
    params.plot.xlim = [-500 3500]; params.plot.ylim = [0 80];
    clear example_neuron    
    params.plot.xintercept = 1500;
    [~, ~,example_neuron] = plot_example_neuron(bf_data_1500_ramping,plot_trial_types,params,ii,0);
    example_neuron.set_title([int2str(ii) ' - ' bf_data_1500_ramping.filename{ii}]);
    figure('Renderer', 'painters', 'Position', [100 100 400 600]);
    example_neuron.draw;
    
    pause;
    close all
end


for ii = 1:size(bf_data_2500_ramping,1)
    
    % > CS task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    plot_trial_types = {'certain','uncertain'};
    params.plot.colormap = [2, 59, 56; 197, 39, 108]./255;
    
    %% > Plot example ramping neuron in the basal forebrain.
    params.plot.xlim = [-500 3500]; params.plot.ylim = [0 80];
    clear example_neuron
    params.plot.xintercept = 2500;
    [~, ~,example_neuron] = plot_example_neuron(bf_data_2500_ramping,plot_trial_types,params,ii,0);
    example_neuron.set_title([int2str(ii) ' - ' bf_data_2500_ramping.filename{ii}]);
    figure('Renderer', 'painters', 'Position', [100 100 700 600]);
    example_neuron.draw;
    
    pause;
    close all
end
