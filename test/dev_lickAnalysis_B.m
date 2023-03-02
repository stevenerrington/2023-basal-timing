
parfor neuron_i = 1:size(bf_datasheet_CS,1)
    
    if ~isempty(bf_data_CS.licking{neuron_i})
        fprintf('Calculating Fano Factor for neuron %i of %i   |  %s   \n',...
            neuron_i,size(bf_datasheet_CS,1), bf_data_CS.file{neuron_i})
        
        % Calculate Fano Factor
        fano{neuron_i} = get_fano(bf_data_CS.licking{neuron_i},...
            bf_data_CS.trials{neuron_i}, params);
        
        LDF{neuron_i} = plot_mean_psth({bf_data_CS.licking{neuron_i}},...
            params.licking.gauss_ms,1,size(bf_data_CS.licking{neuron_i},2),1);

    else
        fprintf('No licking data for neuron %i of %i   |  %s   \n',...
            neuron_i,size(bf_datasheet_CS,1), bf_data_CS.file{neuron_i})        
        
        fano{neuron_i} = [];
        LDF{neuron_i} = [];
    end
    
end

bf_data_CS.fano_licking = fano';
bf_data_CS.LDF = LDF';


%% Figure
% Input variables
data_in = []; data_in = bf_data_CS(strcmp(bf_datasheet_CS.site,'wustl'),:);
plot_trial_types = {'prob0','prob25','prob50','prob75','prob100'};

xlim_input = [-500 5000];
ylim_input = [-10 10];

% Initialize plot data structures
plot_LDF_data = []; plot_fano_data = []; plot_fano_label = [];
plot_category_label = []; plot_label = [];

plot_time = [-5000:5000];
time_zero = abs(plot_time(1));
color_scheme = cool(length(plot_trial_types));
baseline_win = [-500:200];

for neuron_i = 1:size(data_in,1)
    
    bl_fr_mean = nanmean(nanmean(data_in.LDF{neuron_i}(data_in.trials{neuron_i}.probAll,baseline_win+time_zero)));
    bl_fr_std = nanstd(nanmean(data_in.LDF{neuron_i}(data_in.trials{neuron_i}.probAll,baseline_win+time_zero)));
    
    
    for trial_type_i = 1:length(plot_trial_types)
        trial_type_label = plot_trial_types{trial_type_i};
        trials_in = []; trials_in = data_in.trials{neuron_i}.(trial_type_label);
        n_trls = size(trials_in,2);
        
        LDF_x = []; LDF_x = (nanmean(data_in.LDF{neuron_i}(trials_in,:))-bl_fr_mean)./bl_fr_std;
        
        
        plot_LDF_data = [plot_LDF_data ; num2cell(LDF_x,2)];
        plot_label = [plot_label; {[int2str(trial_type_i) '_' (trial_type_label)]}];
        
        plot_fano_data = [plot_fano_data; {data_in.fano_licking{neuron_i}.raw.(trial_type_label)}];
        plot_fano_label = [plot_fano_label; {[int2str(trial_type_i) '_' (trial_type_label)]}];
        
%         plot_category_label = [plot_category_label; {bf_datasheet_CS.cluster_label{neuron_i}}];
        
    end
end

% Generate plot using gramm
clear figure_plot

% Phasic %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spike density function
figure_plot(1,1)=gramm('x',plot_time,'y',plot_LDF_data,'color',plot_label);
figure_plot(1,1).stat_summary();
figure_plot(1,1).axe_property('XLim',xlim_input,'YLim',[-2 15]);
figure_plot(1,1).set_names('x','Time from CS Onset (ms)','y','Lick rate (licks/sec)');
figure_plot(1,1).set_color_options('map',color_scheme);
% figure_plot(1,1).no_legend;

% Fano factor
figure_plot(2,1)=gramm('x',data_in.fano_licking{1}.time,'y',plot_fano_data,'color',plot_fano_label );
figure_plot(2,1).stat_summary();
figure_plot(2,1).axe_property('XLim',xlim_input,'YLim',[0 2]);
figure_plot(2,1).set_names('x','Time from CS Onset (ms)','y','Fano Factor');
figure_plot(2,1).set_color_options('map',color_scheme);
figure_plot(2,1).geom_vline('xintercept',0,'style','k-');
figure_plot(2,1).geom_vline('xintercept',2500,'style','k-');
figure_plot(2,1).geom_hline('yintercept',1,'style','k--');
% figure_plot(2,1).no_legend;

figure_plot_out = figure('Renderer', 'painters', 'Position', [100 100 800 500]);
figure_plot.draw();

% %% Output
% % Once we're done with a page, save it and close it.
% file = fullfile(dirs.root,'results','LDF_fano_cstask_figure_populations.pdf');
% set(figure_plot_out,'PaperSize',[20 10]); %set the paper size to what you want
% print(figure_plot_out,file,'-dpdf') % then print it
% close(figure_plot_out)


