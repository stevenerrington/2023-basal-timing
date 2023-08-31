function bfstri_pca_dimension(bf_data_CS,bf_datasheet_CS,striatum_data_CS)
%% Example extraction code
% Tidy workspace
clear timewin

% Define trials/area/sdf normalization
trial_type_in = 'prob50'; % Corresponds to a trial type in the data_in structure
sdf_norm = 'zscore'; % zscore or max
clear sdf_50_max sdf_50_z;

pre_outcome_ext = 1000;
post_outcome_ext = 500;

for area_in = {'striatum', 'bf_nih', 'bf_wustl'}
    
    % Switch the inputted dataset based on the area, and define the outcome
    % times.
    
    time_step = 10;
    timewin = [];
    
    switch area_in{1}
        case 'striatum'
            data_in = []; data_in = striatum_data_CS;
            outcome_time = 2500;
%             timewin = [0:5:750,outcome_time-750:5:outcome_time+post_outcome_ext]; % Denotes the time window to extract the SDF from (rel to CS onset)
            timewin = [outcome_time-pre_outcome_ext:time_step:outcome_time+post_outcome_ext]; % Denotes the time window to extract the SDF from (rel to CS onset)
       case 'bf_nih'
            data_in = []; data_in = bf_data_CS(strcmp(bf_datasheet_CS.site,'nih'),:);
            outcome_time = 1500;
            timewin = [outcome_time-pre_outcome_ext:time_step:outcome_time+post_outcome_ext]; % Denotes the time window to extract the SDF from (rel to CS onset)
        case 'bf_wustl'
            data_in = []; data_in = bf_data_CS(strcmp(bf_datasheet_CS.site,'wustl'),:);
            outcome_time = 2500;
            timewin = [outcome_time-pre_outcome_ext:time_step:outcome_time+post_outcome_ext]; % Denotes the time window to extract the SDF from (rel to CS onset)
    end
    
    %% Get average SDF
    % Then for each neuron in the data_in table
    
    for neuron_i = 1:size(data_in,1)
        % Get the mean SDF within the defined window, in the defined trials
        sdf_50_max.(area_in{1})(neuron_i,:) =...
            nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.(trial_type_in),timewin+5001))./...
            max(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.probAll,timewin+5001)));
        % Note: this is normalized to the max FR across ALL probability trials
        % in the same window.
        
        sdf_50_z.(area_in{1})(neuron_i,:) =...
            (nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.(trial_type_in),timewin+5001))-...
            mean(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.probAll,timewin+5001))))./...
            std(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.probAll,timewin+5001)));
        % Note: this is z-score normalized across ALL probability trials
        % in the same window.
    end
    
end


sdf_data_bf = [sdf_50_z.bf_nih;sdf_50_z.bf_wustl];
sdf_data_striatum = [sdf_50_z.striatum];


for area_in = {'striatum', 'bf'}
 
    %% Shuffle data:
    % Parameterize bootstrap
    n_bootstraps = 1000;
    
    % Switch inputted data based on normalization method
    switch area_in{1}
        case 'bf'
            sdf_data_in = []; sdf_data_in = sdf_data_bf;
        case 'striatum'
            sdf_data_in = []; sdf_data_in = sdf_data_striatum;
    end
    
    % Run bootstrap and get explained variance
    clear var_exp_bootstrap
    for bootstrap_i = 1:n_bootstraps
        shuffled_sdf50 = [];
        
        % For each neuron, shuffled the data in time
        for neuron_i = 1:size(sdf_data_in,1)
            shuffled_sdf50(neuron_i,:) = sdf_data_in(neuron_i,randperm(size(sdf_data_in,2)));
        end
        
        % Run the PCA and get the explained proportion of variance
        [~,~,~,~,explained,~] =...
            pca(shuffled_sdf50,'Rows','pairwise'); %lets calculate Principal Comp
        
        % Convert this into a percentage of the total variance
        var_explained_bootstrap_i = [];
        var_explained_bootstrap_i = explained./sum(explained) * 100;
        
        % Save in the loop for future plotting.
        var_exp_bootstrap(bootstrap_i,:) = var_explained_bootstrap_i';
    end
    
    
    %% Run PCA analysis
    % Run PCA on observed data
    [coeff,score,latent,tsquared,explained,mu] = pca(sdf_data_in');
    % Note: input into pca is flipped - each neuron is a column, and time point
    % is a row.
    
    clear pc1 pc2 pc3 perc_var_explained
    % Get the first 3 principle components
    pc1 = score(:, 1); pc2 = score(:, 2); pc3 = score(:, 3);
    
    % Find the index of CS onset and outcome time relative to the SDF we've extracted
    onset_time_idx = find(timewin == 0);
    outcome_time_idx = find(timewin == outcome_time);
    
    % Plot the cumulative variability explained
    n_pc_plot = 5;
    perc_var_explained = []; perc_var_explained = explained([1:n_pc_plot])./sum(explained([1:n_pc_plot])) * 100;
    
    
    pca_var_out.(area_in{1}).perc_var_explained = perc_var_explained;
    pca_var_out.(area_in{1}).var_exp_bootstrap = var_exp_bootstrap;
    pca_var_out.(area_in{1}).pc1 = pc1;
    pca_var_out.(area_in{1}).pc2 = pc2;
    pca_var_out.(area_in{1}).pc3 = pc3;
    
end

%% Figure: Generate figure
% Generate plot using gramm
clear figure_plot

custom_statfun = @(y)([max(y);zeros(1,5);max(y)]); 
% Spike density function >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
figure_plot(1,2)=gramm('x',[1:5],'y',pca_var_out.striatum.var_exp_bootstrap(:,1:5));
figure_plot(1,2).stat_summary('type', custom_statfun,'geom',{'area'});
figure_plot(1,2).axe_property('XLim',[0 6],'XTick',[1:1:5],'YLim',[0 100]);
figure_plot(1,2).set_names('x','Principal Components','y','Proportion of variance explained');

figure_plot(2,2)=gramm('x',[1:5],'y',pca_var_out.striatum.perc_var_explained(1:5));
figure_plot(2,2).stat_summary('geom',{'bar'});
figure_plot(2,2).axe_property('XLim',[0 6],'XTick',[1:1:5],'YLim',[0 100]);
figure_plot(2,2).set_names('x','Principal Components','y','Proportion of variance explained');

figure_plot(1,1)=gramm('x',[1:5],'y',pca_var_out.bf.var_exp_bootstrap(:,1:5));
figure_plot(1,1).stat_summary('type', custom_statfun,'geom',{'area'});
figure_plot(1,1).axe_property('XLim',[0 6],'XTick',[1:1:5],'YLim',[0 100]);
figure_plot(1,1).set_names('x','Principal Components','y','Proportion of variance explained');

figure_plot(2,1)=gramm('x',[1:5],'y',pca_var_out.bf.perc_var_explained(1:5));
figure_plot(2,1).stat_summary('geom',{'bar'});
figure_plot(2,1).axe_property('XLim',[0 6],'XTick',[1:1:5],'YLim',[0 100]);
figure_plot(2,1).set_names('x','Principal Components','y','Proportion of variance explained');

figure_plot(1,1).set_layout_options('Position',[0.1 0.15 0.3 0.3],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);
figure_plot(1,2).set_layout_options('Position',[0.6 0.15 0.3 0.3],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);
figure_plot(2,1).set_layout_options('Position',[0.1 0.65 0.3 0.3],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);
figure_plot(2,2).set_layout_options('Position',[0.6 0.65 0.3 0.3],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure('Renderer', 'painters', 'Position', [100 100 400 400]);
figure_plot.draw;

%% PC: 3D space plot

timewin = -pre_outcome_ext:time_step:0+post_outcome_ext;
axis_lim = 20;

outcome_time_idx = find(timewin == 0);

figure('Renderer', 'painters', 'Position', [100 50 900 900]); 
subplot(3,2,1); hold on
plot(timewin,nanmean(sdf_data_bf))
ylim([-3 4])

subplot(3,2,2); hold on
plot(timewin,nanmean(sdf_data_striatum))
ylim([-3 4])


subplot(3,2,[3 5]); hold on
color_line3(pca_var_out.bf.pc1, pca_var_out.bf.pc2, pca_var_out.bf.pc3, timewin,'LineWidth',2);
scatter3(pca_var_out.bf.pc1(outcome_time_idx),pca_var_out.bf.pc2(outcome_time_idx),pca_var_out.bf.pc3(outcome_time_idx),75,'k','v','filled')
xlabel('PC1'); ylabel('PC2'); zlabel('PC3')
view(143.2141,15.2454); colorbar('location','SouthOutside')
xlim([-axis_lim axis_lim]); ylim([-axis_lim axis_lim]); zlim([-axis_lim axis_lim]);
grid on

subplot(3,2,[4 6]); hold on
color_line3(pca_var_out.striatum.pc1, pca_var_out.striatum.pc2, pca_var_out.striatum.pc3, timewin,'LineWidth',2);
scatter3(pca_var_out.striatum.pc1(outcome_time_idx),pca_var_out.striatum.pc2(outcome_time_idx),pca_var_out.striatum.pc3(outcome_time_idx),75,'k','v','filled')
xlabel('PC1'); ylabel('PC2'); zlabel('PC3')
view(143.2141,15.2454); colorbar('location','SouthOutside')
xlim([-axis_lim axis_lim]); ylim([-axis_lim axis_lim]); zlim([-axis_lim axis_lim]);
grid on
