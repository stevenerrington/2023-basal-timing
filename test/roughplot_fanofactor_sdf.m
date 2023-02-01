for neuron_i = 1:size(bf_data,1)
    
    figure(neuron_i);
    subplot(2,1,1); hold on
    plot(-5000:5000,nanmean(bf_data.sdf{neuron_i}(bf_data.trials{neuron_i}.prob0,:)))
    plot(-5000:5000,nanmean(bf_data.sdf{neuron_i}(bf_data.trials{neuron_i}.prob25,:)))
    plot(-5000:5000,nanmean(bf_data.sdf{neuron_i}(bf_data.trials{neuron_i}.prob50,:)))
    plot(-5000:5000,nanmean(bf_data.sdf{neuron_i}(bf_data.trials{neuron_i}.prob75,:)))
    plot(-5000:5000,nanmean(bf_data.sdf{neuron_i}(bf_data.trials{neuron_i}.prob100,:)))
    xlim([-500 3000]); vline(0, 'k'); vline(1000,'k'); vline(1000+1500,'k')
    
    subplot(2,1,2); hold on
    plot(bf_data.fano(neuron_i).time,bf_data.fano(neuron_i).FanoSave100)
    plot(bf_data.fano(neuron_i).time,bf_data.fano(neuron_i).FanoSave75)
    plot(bf_data.fano(neuron_i).time,bf_data.fano(neuron_i).FanoSave50)
    plot(bf_data.fano(neuron_i).time,bf_data.fano(neuron_i).FanoSave25)
    plot(bf_data.fano(neuron_i).time,bf_data.fano(neuron_i).FanoSave0)
    xlim([-500 3000]); ylim([0 4]); hline(1,'k'), vline(-1000, 'k'); vline(0,'k'); vline(1000+1500,'k')
    
end


