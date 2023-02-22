
%% Analysis: epoched Fano Factor
% In progress - 1539, Feb 1st
clear epoch
epoch.fano_window = {[0:500],[-500:0]};
epoch.alignZero = {[0 0], [1500 2500]};

clear fano_prob*
fano = struct(); count = 0;
cond_list = {'prob0','prob25','prob50','prob75','prob100'};

clear fano_x fano_condition fano_site fano_class

for neuron_i = 1:size(bf_data_CS,1)
    
    switch bf_datasheet_CS.site{neuron_i}
        case 'wustl'
            site_id = 2;
        case 'nih'
            site_id = 1;
    end
    
    for epoch_i = 1:2
        
        if epoch_i == 1
           epoch_label = 'Early';
        else
            epoch_label = 'Late';            
        end
        
        fano_continuous = [];
        fano_continuous = find(ismember(bf_data_CS.fano(neuron_i).time,...
            epoch.fano_window{epoch_i}+epoch.alignZero{epoch_i}(site_id)));

        for cond_i = 1:length(cond_list)
            count = count + 1;
            cond = cond_list{cond_i};
            
            fano_mean =  nanmean(bf_data_CS.fano(neuron_i).raw.(cond)(fano_continuous));
            
            
            fano_x(count,1) = fano_mean;
            fano_condition{count,1} = [int2str(cond_i) '_' cond];
            fano_epoch{count,1} = epoch_label;
            fano_site{count,1} = bf_datasheet_CS.site{neuron_i};
            fano_class{count,1} = bf_datasheet_CS.cluster_label{neuron_i};
        end

    end
end

%% Figure: 
color_scheme = cool(length(cond_list));

clear epoch_fano_class condition_label figure_data site_label cluster_label
% Boxplot
condition_label = fano_condition;
figure_data = fano_x;
site_label = fano_site;
cluster_label = fano_class;

epoch_fano_class(1,1)= gramm('x',condition_label,'y',fano_x,'color',condition_label);
epoch_fano_class(1,1).stat_summary('geom',{'bar','black_errorbar'},'width',3);
epoch_fano_class(1,1).geom_jitter('alpha',0.2);
epoch_fano_class(1,1).no_legend();
epoch_fano_class(1,1).facet_grid(fano_epoch,cluster_label);
epoch_fano_class(1,1).geom_hline('yintercept',1);
epoch_fano_class(1,1).axe_property('YLim',[0 5]);
epoch_fano_class(1,1).set_color_options('map',color_scheme);

% Figure parameters & settings
epoch_fano_class.set_names('y','');

epoch_fano_class_out = figure('Renderer', 'painters', 'Position', [100 100 400 400]);
epoch_fano_class.draw();

%%
filename = fullfile(dirs.root,'results','bf_phasicramping_fanocomp.pdf');
set(epoch_fano_class_out,'PaperSize',[20 10]); %set the paper size to what you want
print(epoch_fano_class_out,filename,'-dpdf') % then print it
close(epoch_fano_class_out)
