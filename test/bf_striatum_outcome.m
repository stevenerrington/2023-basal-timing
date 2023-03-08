
%% Analysis: epoched Fano Factor
clear epoch
epoch.fano_window = {[-500:0],[0:500]};
epoch.alignZero = {[1500 2500], [1500 2500]};
cond_list_CS = {'uncert_delivered','uncert_omit'};
count = 0;
clear fano_prob* fano_x fano_condition fano_area fano_class fano_epoch

% > Basal forebrain | CS task ----------------------------------------
for neuron_i = 1:size(bf_data_CS,1)
    
    switch bf_datasheet_CS.site{neuron_i}
        case 'wustl'
            site_id = 2;
        case 'nih'
            site_id = 1;
    end
    
    for epoch_i = 1:2
        
        if epoch_i == 1
           epoch_label = '1_Pre-outcome';
        else
            epoch_label = '2_Post-outcome';            
        end
        
        fano_continuous = [];
        fano_continuous = find(ismember(bf_data_CS.fano(neuron_i).time,...
            epoch.fano_window{epoch_i}+epoch.alignZero{epoch_i}(site_id)));

        for cond_i = 1:length(cond_list_CS)
            count = count + 1;
            cond = cond_list_CS{cond_i};
            
            fano_mean =  nanmean(bf_data_CS.fano(neuron_i).raw.(cond)(fano_continuous));
            
            
            fano_x(count,1) = fano_mean;
            fano_condition{count,1} = [int2str(cond_i) '_' cond];
            fano_epoch{count,1} = epoch_label;
            fano_area{count,1} = 'BF';
            fano_class{count,1} = bf_datasheet_CS.cluster_label{neuron_i};
        end

    end
end

% > Striatum | CS task ---------------------------------------------------

for neuron_i = 1:size(striatum_data_CS,1)
    site_id = 2;
    
    for epoch_i = 1:2
        
        if epoch_i == 1
           epoch_label = '1_Pre-outcome';
        else
            epoch_label = '2_Post-outcome';            
        end
        
        fano_continuous = [];
        fano_continuous = find(ismember(striatum_data_CS.fano(neuron_i).time,...
            epoch.fano_window{epoch_i}+epoch.alignZero{epoch_i}(site_id)));

        for cond_i = 1:length(cond_list_CS)
            count = count + 1;
            cond = cond_list_CS{cond_i};
            
            fano_mean =  nanmean(striatum_data_CS.fano(neuron_i).raw.(cond)(fano_continuous));
            
            
            fano_x(count,1) = fano_mean;
            fano_condition{count,1} = [int2str(cond_i) '_' cond];
            fano_epoch{count,1} = epoch_label;
            fano_area{count,1} = 'Striatum';
            fano_class{count,1} = 'Ramping';
        end

    end
end







% > Striatum | CS task ---------------------------------------------------












%% Figure: 
color_scheme = cool(length(cond_list_CS));

clear epoch_fano_class condition_label figure_data site_label cluster_label
% Boxplot
condition_label = fano_condition;
figure_data = fano_x;
site_label = fano_area;
cluster_label = fano_class;

epoch_fano_class(1,1)= gramm('x',fano_epoch,'y',fano_x,...
    'color',condition_label,'subset',strcmp(fano_class,'Ramping'));
% epoch_fano_class(1,1).geom_jitter('alpha',0.1,'width',0.1);
epoch_fano_class(1,1).stat_summary('geom',{'bar','black_errorbar'});
epoch_fano_class(1,1).no_legend();
epoch_fano_class(1,1).geom_hline('yintercept',1);
epoch_fano_class(1,1).facet_grid([],fano_area);
epoch_fano_class(1,1).axe_property('YLim',[0 2]);
epoch_fano_class(1,1).set_color_options('map',color_scheme);

% Figure parameters & settings
epoch_fano_class.set_names('y','');

epoch_fano_class_out = figure('Renderer', 'painters', 'Position', [100 100 400 400]);
epoch_fano_class.draw();

