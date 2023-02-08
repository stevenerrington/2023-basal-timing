
%% Notes: 
% Inherited scripts that may be useful:
% > SingleVsDoubleOutcomeIlya
% > StructMakerTimingTrace_V01


%% Curation: generate a datamap
% > Load in a pre-curated sheet of neuron information for upcoming analyses 

bf_datasheet_traceExp = readtable(fullfile(dirs.root,'docs','timing_trace_neurontable.xlsx'));

%% Analysis: Extract relevant neurophys data

bf_data_traceExp = table();

for neuron_i = 1:size(bf_datasheet_traceExp,1)
    
    % Loop admin
    filename = bf_datasheet_traceExp.file{neuron_i};
    fprintf('Extracting data from neuron %i of %i   |  %s   \n',neuron_i,size(bf_datasheet_traceExp,1), filename)
    
    % Load experimental data file
    clear PDS
    load(fullfile(bf_datasheet_traceExp.dir{neuron_i},filename), 'PDS');
   
    % Get trial indices
    trials = get_trials_traceTask(PDS);
    % > 2:21pm, Wed Feb 8th 2023. Up to here, translating code from
    % SingleVsDoubleOutcomeIlya into the repository structure.
    
    % Get event aligned rasters
    Rasters = get_trace_raster(PDS, trials, params);
    
    % Get event aligned spike-density function
    SDF = plot_mean_psth({Rasters},params.sdf.gauss_ms,1,size(Rasters,2),1);
    
    % Output extracted data into a table
    bf_data_traceExp(neuron_i,:) = table({filename}, {trials}, {Rasters},{SDF},...
        'VariableNames',{'filename','trials','rasters','sdf'});
end

%%

params.fano.bin_size = 25;
clear fano
parfor neuron_i = 1:size(bf_datasheet_traceExp,1)
    
    fprintf('Calculating Fano Factor for neuron %i of %i   |  %s   \n',...
        neuron_i,size(bf_datasheet_traceExp,1), bf_datasheet_traceExp.file{neuron_i})

    % Calculate Fano Factor
    fano(neuron_i) = get_fano(bf_data_traceExp.rasters{neuron_i},...
        bf_data_traceExp.trials{neuron_i}, params);

end


for neuron_i = 1:size(bf_datasheet_traceExp,1)

    
    figure(neuron_i);
    subplot(2,1,1); hold on
    plot(-5000:5000,nanmean(bf_data_traceExp.sdf{neuron_i}(bf_data_traceExp.trials{neuron_i}.plot_test,:)))
    xlim([-200 2000]); vline(1500,'k'); vline(0, 'k'); 
        
    subplot(2,1,2); hold on
    plot(fano(neuron_i).time,fano(neuron_i).raw.plot_test)
    xlim([-200 2000]); ylim([0 4]); hline(1,'k'), vline(1500, 'k'); vline(0,'k');
    
end

