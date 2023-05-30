
parfor neuron_i = 1:size(bf_datasheet_CS,1)
    
    fprintf('Calculating ISI distribution for neuron %i of %i   |  %s   \n',...
        neuron_i,size(bf_datasheet_CS,1), bf_data_CS.filename{neuron_i})
    
    % Calculate ISI
    isi(neuron_i) = get_isi(bf_data_CS.rasters{neuron_i},...
        bf_data_CS.trials{neuron_i});
    
end

bf_data_CS.isi = isi';
clear isi

allISI_ramping = []; allISI_phasic = [];
CV_phasic = []; CV_ramping = [];

for neuron_i = 1:size(bf_datasheet_CS,1)
    
    switch bf_datasheet_CS.cluster_label{neuron_i}
        case 'Phasic'
            allISI_phasic =  [allISI_phasic, bf_data_CS.isi(neuron_i).overall.probAll];
            
            CV_phasic     =  [CV_phasic,...
                nanstd(bf_data_CS.isi(neuron_i).overall.probAll)./...
                nanmean(bf_data_CS.isi(neuron_i).overall.probAll)];
            
       case 'Ramping'
            allISI_ramping =  [allISI_ramping, bf_data_CS.isi(neuron_i).overall.probAll];
            
            CV_ramping     =  [CV_ramping,...
                nanstd(bf_data_CS.isi(neuron_i).overall.probAll)./...
                nanmean(bf_data_CS.isi(neuron_i).overall.probAll)];
    end
end


figure; hold on
subplot(2,1,1)
histogram(allISI_phasic, 2:2:100)
subplot(2,1,2)
histogram(allISI_ramping, 2:2:100)


bin_edges = [2:5:100];



%% ISI 
clear g

% ISI (histogram)
g(1,1)=gramm('x',allISI_phasic);
g(1,1).stat_bin('edges',bin_edges,'normalization','probability');
g(1,1).set_title('Phasic');

g(2,1)=gramm('x',allISI_ramping);
g(2,1).stat_bin('edges',bin_edges,'normalization','probability');
g(2,1).set_title('Ramping');

% ISI (n, n+1)
g(1,2)=gramm('x',allISI_phasic(1:end-1)','y',allISI_phasic(2:end)');
g(1,2).stat_bin2d('edges',{bin_edges bin_edges});
g(1,2).set_title('Phasic');

g(2,2)=gramm('x',allISI_ramping(1:end-1)','y',allISI_ramping(2:end)');
g(2,2).stat_bin2d('edges',{bin_edges bin_edges});
g(2,2).set_title('Ramping');

figure('Position',[100 100 800 600])
g.draw();

%% CV
data_in = [CV_phasic'; CV_ramping'];
label = [repmat({'Phasic'},length(CV_phasic),1);repmat({'Ramping'},length(CV_ramping),1)];


clear epoch_fano_class
epoch_fano_class(1,1)= gramm('x',label,'y',data_in,'color',label);
epoch_fano_class(1,1).stat_summary('geom',{'lines','black_errorbar'},'width',1);
epoch_fano_class(1,1).geom_jitter('alpha',0.2);
epoch_fano_class(1,1).no_legend();
epoch_fano_class(1,1).geom_hline('yintercept',1);


% Figure parameters & settings
epoch_fano_class.set_names('y','Coefficient of variation');

epoch_fano_class_out = figure('Renderer', 'painters', 'Position', [100 100 400 400]);
epoch_fano_class.draw();