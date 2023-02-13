
%% Analysis: epoched Fano Factor
% In progress - 1539, Feb 1st
clear epoch
epoch.postOutcome = [0:200];
epoch_zero.postOutcome = [1500 2500];

clear fano_prob*
fano = struct();
for neuron_i = 1:size(bf_data_CS,1)
    
    switch bf_data_CSsheet.site{neuron_i}
        case 'wustl'
            site_id = 2;
        case 'nih'
            site_id = 1;
    end
        
    fano = get_fano_window(bf_data_CS.rasters{neuron_i},...
        bf_data_CS.trials{neuron_i},...
        epoch.postOutcome + epoch_zero.postOutcome(site_id)); % @ moment, centers on 0
    
    
    fano_rwd_deliv(neuron_i,1) = fano.window.uncert_delivered;
    fano_rwd_omit(neuron_i,1) = fano.window.uncert_omit;
    fano_rwd_site{neuron_i,1} = bf_data_CSsheet.site{neuron_i};
    fano_rwd_class{neuron_i,1} = bf_data_CSsheet.cluster_label{neuron_i};
    
end

%% Figure: 

clear outcome_rwd_fano condition_label figure_data site_label cluster_label
% Boxplot
condition_label = [repmat({'Delivered'},length(fano_rwd_deliv),1); repmat({'Omitted'},length(fano_rwd_omit),1)];
figure_data = [fano_rwd_deliv; fano_rwd_omit];
site_label = [fano_rwd_site; fano_rwd_site];
cluster_label = [fano_rwd_class; fano_rwd_class];

outcome_rwd_fano(1,1)= gramm('x',condition_label,'y',figure_data,'color',condition_label,...
    'subset',strcmp(cluster_label,'Ramping'));
outcome_rwd_fano(1,1).stat_boxplot();
outcome_rwd_fano(1,1).geom_jitter();
outcome_rwd_fano(1,1).no_legend();
outcome_rwd_fano(1,1).facet_grid([],site_label);
outcome_rwd_fano(1,1).geom_hline('yintercept',1);
% stoppingBoxplot_Figure(1,1).axe_property('YLim',[0.08 0.16]);

% Figure parameters & settings
outcome_rwd_fano.set_names('y','');

figure('Position',[100 100 500 350]);
outcome_rwd_fano.draw();
