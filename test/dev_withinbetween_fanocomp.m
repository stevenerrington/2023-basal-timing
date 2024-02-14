
data_in = bf_data_CS(strcmp(bf_datasheet_CS.site,'wustl'),:);

clear fano* 
fano_out_bf_uncertain = dev_fano_acrossNeuron (data_in, 'uncertain', params);
fano_out_bf_certain = dev_fano_acrossNeuron (data_in, 'certain', params);

color_bf= flipud(cbrewer('seq', 'Reds', 5));
color_striatum = flipud(cbrewer('seq', 'Blues', 5));


for neuron_i = 1:size(data_in,1)
    fano_regular_bf_uncertain(neuron_i,:) = data_in(neuron_i,:) .fano.raw.uncertain;
    fano_regular_bf_certain(neuron_i,:) = data_in(neuron_i,:) .fano.raw.certain;
end

figuren;
subplot(2,1,1); hold on
plot(fano_out_bf_uncertain.time,nanmean(fano_out_bf_uncertain.fano),'color',color_bf(1,:),'LineWidth',2)
plot(fano_out_bf_uncertain.time,nanmean(fano_out_bf_certain.fano),'color',color_striatum(1,:),'LineWidth',2)
xlim([-250 2500])
legend({'BF_uncertain','BF_certain'},'Location','eastoutside','Interpreter','none')
title('Between neuron fano')

subplot(2,1,2); hold on
plot(fano_out_bf_uncertain.time,nanmean(fano_regular_bf_uncertain),'color',color_bf(1,:),'LineWidth',2)
plot(fano_out_bf_uncertain.time,nanmean(fano_regular_bf_certain),'color',color_striatum(1,:),'LineWidth',2)
xlim([-250 2500])
legend({'BF_uncertain','BF_certain'},'Location','eastoutside','Interpreter','none')
title('Within neuron fano')
