for neuron_i = 1:size(bf_data_CS,1)
    
    figure(neuron_i);
    subplot(2,1,1); hold on
    plot(-5000:5000,nanmean(bf_data_CS.sdf{neuron_i}(bf_data_CS.trials{neuron_i}.prob0,:)))
    plot(-5000:5000,nanmean(bf_data_CS.sdf{neuron_i}(bf_data_CS.trials{neuron_i}.prob25,:)))
    plot(-5000:5000,nanmean(bf_data_CS.sdf{neuron_i}(bf_data_CS.trials{neuron_i}.prob50,:)))
    plot(-5000:5000,nanmean(bf_data_CS.sdf{neuron_i}(bf_data_CS.trials{neuron_i}.prob75,:)))
    plot(-5000:5000,nanmean(bf_data_CS.sdf{neuron_i}(bf_data_CS.trials{neuron_i}.prob100,:)))
    xlim([-1500 3000]); vline(-1000,'k'); vline(0, 'k'); 
    
    if strcmp(bf_data_CSsheet.site{neuron_i},'wustl'); vline(2500,'k'); else; vline(1500,'k'); end
    
    subplot(2,1,2); hold on
    plot(bf_data_CS.fano(neuron_i).time,bf_data_CS.fano(neuron_i).raw.prob0)
    plot(bf_data_CS.fano(neuron_i).time,bf_data_CS.fano(neuron_i).raw.prob25)
    plot(bf_data_CS.fano(neuron_i).time,bf_data_CS.fano(neuron_i).raw.prob50)
    plot(bf_data_CS.fano(neuron_i).time,bf_data_CS.fano(neuron_i).raw.prob75)
    plot(bf_data_CS.fano(neuron_i).time,bf_data_CS.fano(neuron_i).raw.prob100)
    xlim([-1500 3000]); ylim([0 4]); hline(1,'k'), vline(-1000, 'k'); vline(0,'k');
    if strcmp(bf_data_CSsheet.site{neuron_i},'wustl'); vline(2500,'k'); else; vline(1500,'k'); end
    
end

%%

close all
for neuron_i = 16
    
    figure(neuron_i);
    subplot(2,1,1); hold on
    plot(-5000:5000,nanmean(bf_data_CS.sdf{neuron_i}(bf_data_CS.trials{neuron_i}.prob50d,:)))
    plot(-5000:5000,nanmean(bf_data_CS.sdf{neuron_i}(bf_data_CS.trials{neuron_i}.prob50nd,:)))
    xlim([-1500 3000]); vline(-1000,'k'); vline(0, 'k'); 
    
    if strcmp(bf_data_CSsheet.site{neuron_i},'wustl'); vline(2500,'k'); else; vline(1500,'k'); end
    
    subplot(2,1,2); hold on
    plot(bf_data_CS.fano(neuron_i).time,bf_data_CS.fano(neuron_i).raw.prob50d)
    plot(bf_data_CS.fano(neuron_i).time,bf_data_CS.fano(neuron_i).raw.prob50nd)
    xlim([-1500 3000]); ylim([0 4]); hline(1,'k'), vline(-1000, 'k'); vline(0,'k');
    if strcmp(bf_data_CSsheet.site{neuron_i},'wustl'); vline(2500,'k'); else; vline(1500,'k'); end
    
end



