
parfor neuron_i = 1:size(bf_datasheet_CS,1)
    
    fprintf('Calculating ISI distribution for neuron %i of %i   |  %s   \n',...
        neuron_i,size(bf_datasheet_CS,1), bf_data_CS.filename{neuron_i})
    
    % Calculate Fano Factor
    isi(neuron_i) = get_isi(bf_data_CS.rasters{neuron_i},...
        bf_data_CS.trials{neuron_i});
    
end

bf_data_CS.isi = isi';
clear isi

allISI_ramping = []; allISI_phasic = [];

for neuron_i = 1:size(bf_datasheet_CS,1)
    
    switch bf_datasheet_CS.cluster_label{neuron_i}
        case 'Phasic'
            allISI_phasic =  [allISI_phasic, bf_data_CS.isi(neuron_i).overall.probAll];
       case 'Ramping'
            allISI_ramping =  [allISI_ramping, bf_data_CS.isi(neuron_i).overall.probAll];
    end
end


figure; hold on
subplot(2,1,1)
histogram(allISI_phasic, 2:2:100)
subplot(2,1,2)
histogram(allISI_ramping, 2:2:100)