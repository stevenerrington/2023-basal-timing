
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
    
    % Get event aligned rasters
    Rasters = get_trace_raster(PDS, trials, params);
    
    % Get event aligned spike-density function
    SDF = plot_mean_psth({Rasters},params.sdf.gauss_ms,1,size(Rasters,2),1);
    
    % Get licking raster
    Licking = get_licking_raster(PDS,params); 
    
    % Output extracted data into a table
    bf_data_traceExp(neuron_i,:) = table({filename}, {trials}, {Rasters},{SDF},{Licking},...
        'VariableNames',{'filename','trials','rasters','sdf','licking'});
end

%% Analysis: calculate running fano factor

clear fano
parfor neuron_i = 1:size(bf_datasheet_traceExp,1)
    
    fprintf('Calculating Fano Factor for neuron %i of %i   |  %s   \n',...
        neuron_i,size(bf_datasheet_traceExp,1), bf_datasheet_traceExp.file{neuron_i})

    % Calculate Fano Factor
    fano(neuron_i) = get_fano(bf_data_traceExp.rasters{neuron_i},...
        bf_data_traceExp.trials{neuron_i}, params);

end

bf_data_traceExp.fano = fano';
clear fano

%% Analysis: Calculate the inter-spike interval distribution for each trial condition

parfor neuron_i = 1:size(bf_datasheet_traceExp,1)
    
    fprintf('Calculating ISI distribution for neuron %i of %i   |  %s   \n',...
        neuron_i,size(bf_datasheet_traceExp,1), bf_datasheet_traceExp.file{neuron_i})
    
    % Calculate Fano Factor
    isi(neuron_i) = get_isi(bf_data_traceExp.rasters{neuron_i},...
        bf_data_traceExp.trials{neuron_i});
    
end

bf_data_traceExp.isi = isi'; clear isi



%% Cuttings 
% Figure: Generate example SDFs & Fano
% 
% for neuron_i = 1:size(bf_datasheet_traceExp,1)
% 
%     figure(neuron_i);
%     subplot(2,1,1); hold on
%     plot(-5000:5000,nanmean(bf_data_traceExp.sdf{neuron_i}(bf_data_traceExp.trials{neuron_i}.notimingcue_uncertain_nd,:)))
%     plot(-5000:5000,nanmean(bf_data_traceExp.sdf{neuron_i}(bf_data_traceExp.trials{neuron_i}.notimingcue_uncertain_d,:)))
%     plot(-5000:5000,nanmean(bf_data_traceExp.sdf{neuron_i}(bf_data_traceExp.trials{neuron_i}.timingcue_uncertain_nd,:)))
%     plot(-5000:5000,nanmean(bf_data_traceExp.sdf{neuron_i}(bf_data_traceExp.trials{neuron_i}.notimingcue_uncertain_nd,:)))
%     xlim([0 3500]); vline(0, 'k'); vline(1000, 'k'); vline(2500, 'k'); 
%         
%     subplot(2,1,2); hold on
%     plot(bf_data_traceExp.fano(neuron_i).time,bf_data_traceExp.fano(neuron_i).raw.notimingcue_uncertain_nd)
%     plot(bf_data_traceExp.fano(neuron_i).time,bf_data_traceExp.fano(neuron_i).raw.notimingcue_uncertain_d)
%     plot(bf_data_traceExp.fano(neuron_i).time,bf_data_traceExp.fano(neuron_i).raw.timingcue_uncertain_nd)
%     plot(bf_data_traceExp.fano(neuron_i).time,bf_data_traceExp.fano(neuron_i).raw.notimingcue_uncertain_nd)
%     xlim([0 3500]); ylim([0 4]); hline(1,'k');  vline(0, 'k'); vline(1000, 'k'); vline(2500, 'k');
%     
%     test_a(neuron_i,:) = nanmean(bf_data_traceExp.sdf{neuron_i}(bf_data_traceExp.trials{neuron_i}.notimingcue_uncertain_nd,:));
%     test_b(neuron_i,:) = nanmean(bf_data_traceExp.sdf{neuron_i}(bf_data_traceExp.trials{neuron_i}.timingcue_uncertain_nd,:));
%     
% end

% 
% figure; hold on
% plot(-5000:5000,nanmean(test_a),'r')
% plot(-5000:5000,nanmean(test_b),'k')
% xlim([0 3500]); vline(0, 'k'); vline(1000, 'k'); vline(2500, 'k');
% 
