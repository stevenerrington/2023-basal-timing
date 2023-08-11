


% Analysis note: I also tried this same analysis on the CS data and it
% didn't show any meaningful categories

clear pca_sdf_full
%% PCA: Determine the types of post-outcome neurons

% Define parameters for extracting SDF (z-scored)
plot_trial_types = {'p25s_75l_short'};
params.plot.xlim = [0 2500]; params.plot.ylim = [-4 6];
params.plot.colormap = [69, 191, 85; 40, 116, 50; 15, 44, 19]./255;
[~,plot_data,~] = plot_population_neuron(bf_data_timingTask,plot_trial_types,params,0);
rng('default');  % For reproducibility

% Define parameters for PCA
pca_window = [-1500:500]+1500+5001;

% Get SDF's within PCA window
for neuron_i = 1:size(bf_data_timingTask,1)
    pca_sdf_full(neuron_i,:) = plot_data.plot_sdf_data{neuron_i}(:,pca_window);
end

% Run PCA
[pc, zscores, pcvars] = pca(pca_sdf_full); % PCA analysis
VarE=cumsum(pcvars./sum(pcvars) * 100); % Cumulative variance

% Find clusters
meas=zscores(:,[1:10]);
eva = evalclusters(meas,'kmeans','silhouette','KList',[1:6]); % Find clusters
idx3 = kmeans(meas,eva.OptimalK,'Distance','sqeuclidean'); % Run K-means

% Get neurons index for each clusters
cluster_1_idx = find(idx3==1);
cluster_2_idx = find(idx3==2);

%% Figure: Plot PCA in 3D space
figure
hold on; set(gca,'ticklength',2*get(gca,'ticklength'))
scatter3(zscores(cluster_1_idx,1), zscores(cluster_1_idx,2),zscores(cluster_1_idx,3),36,'r','filled')
scatter3(zscores(cluster_2_idx,1), zscores(cluster_2_idx,2),zscores(cluster_2_idx,3),36,'b','filled')

xticks([-50:25:50]); yticks([-50:25:50]); zticks([-50:25:50])

LL=-50; LLL=50;
xlim([LL LLL]); ylim([LL LLL]); zlim([LL LLL])
grid on
view(213.7937, 30.3523)

%% SDF: Get event-aligned activity based on clustering
% Early delivery
plot_trial_types = {'p25s_75l_short','p50s_50l_short','p75s_25l_short'};
params.plot.xlim = [0 2000]; params.plot.ylim = [-4 6];
[~,~,cluster_1_early] = plot_population_neuron(bf_data_timingTask(cluster_1_idx,:),plot_trial_types,params,0);
[~,~,cluster_2_early] = plot_population_neuron(bf_data_timingTask(cluster_2_idx,:),plot_trial_types,params,0);

% Late delivery
plot_trial_types = {'p25s_75l_long','p50s_50l_long','p75s_25l_long'};
% plot_trial_types = {'uncertain_long'};
params.plot.xlim = [3000 5000]; params.plot.ylim = [-4 6];
[~,~,cluster_1_late] = plot_population_neuron(bf_data_timingTask(cluster_1_idx,:),plot_trial_types,params,0);
[~,~,cluster_2_late] = plot_population_neuron(bf_data_timingTask(cluster_2_idx,:),plot_trial_types,params,0);

%% Figure: Setup

figure_plot = [cluster_1_early;cluster_1_late;cluster_2_early;cluster_2_late];

% (1) cluster 1, early sdf; (2) cluster 1, early fano;
% (3) cluster 2, early sdf; (4) cluster 2, early fano;
% (5) cluster 1, late sdf; (6) cluster 1, late fano;
% (7) cluster 2, late sdf; (8) cluster 2, late fano;

figure_plot(1,1).set_layout_options('Position',[0.075 0.65 0.4 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(2,1).set_layout_options('Position',[0.075 0.55 0.4 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(3,1).set_layout_options('Position',[0.55 0.65 0.4 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(4,1).set_layout_options('Position',[0.55 0.55 0.4 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(5,1).set_layout_options('Position',[0.075 0.2 0.4 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(6,1).set_layout_options('Position',[0.075 0.1 0.4 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(7,1).set_layout_options('Position',[0.55 0.2 0.4 0.25],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(8,1).set_layout_options('Position',[0.55 0.1 0.4 0.1],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);

figure_plot(1,1).axe_property('XTicks',[],'XColor',[1 1 1]);
figure_plot(3,1).axe_property('XTicks',[],'XColor',[1 1 1]);
figure_plot(5,1).axe_property('XTicks',[],'XColor',[1 1 1]);
figure_plot(7,1).axe_property('XTicks',[],'XColor',[1 1 1]);

figure('Renderer', 'painters', 'Position', [100 100 500 500]);
figure_plot.draw;

%% Tuning curves
plot_trial_types = {'p25s_75l_short','p50s_50l_short','p75s_25l_short'};

% Early period
params.plot.xintercept = 2000; % 1500 to 2000 ms;
[~, cluster_1_early_tuning, ~] =...
    plot_fr_x_uncertainTiming(bf_data_timingTask(cluster_1_idx,:),plot_trial_types,params,0,'zscore');
[~, cluster_2_early_tuning, ~] =...
    plot_fr_x_uncertainTiming(bf_data_timingTask(cluster_2_idx,:),plot_trial_types,params,0,'zscore');

% Late period
params.plot.xintercept = 5000; % 4500 to 5000 ms;
[~, cluster_1_late_tuning, ~] =...
    plot_fr_x_uncertainTiming(bf_data_timingTask(cluster_1_idx,:),plot_trial_types,params,0,'zscore');
[~, cluster_2_late_tuning, ~] =...
    plot_fr_x_uncertainTiming(bf_data_timingTask(cluster_2_idx,:),plot_trial_types,params,0,'zscore');

%% Figure 2: tuning curves
figure_plot_tuning = [cluster_1_early_tuning; cluster_1_late_tuning;...
    cluster_2_early_tuning;cluster_2_late_tuning];

figure_plot_tuning(1,1).set_layout_options('Position',[0.075 0.65 0.3 0.3],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);
figure_plot_tuning(1,1).axe_property('YLim',[1 3]);

figure_plot_tuning(2,1).set_layout_options('Position',[0.55 0.65 0.3 0.3],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);
figure_plot_tuning(2,1).axe_property('YLim',[-3 -1]);

figure_plot_tuning(3,1).set_layout_options('Position',[0.075 0.1 0.3 0.3],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);
figure_plot_tuning(3,1).axe_property('YLim',[-1 1]);

figure_plot_tuning(4,1).set_layout_options('Position',[0.55 0.1 0.3 0.3],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.00 0.00],...
    'redraw',false);
figure_plot_tuning(4,1).axe_property('YLim',[-3 -1]);

figure('Renderer', 'painters', 'Position', [100 100 500 500]);
figure_plot_tuning.draw;



%% Figure: Plot collapsed groups (for comparison)
% Early delivery
plot_trial_types = {'p25s_75l_short','p50s_50l_short','p75s_25l_short'};
params.plot.xlim = [0 2000]; params.plot.ylim = [-4 6];
[~,~,~] = plot_population_neuron(bf_data_timingTask,plot_trial_types,params,1);

plot_trial_types = {'p25s_75l_long','p50s_50l_long','p75s_25l_long'};
params.plot.xlim = [3000 5000]; params.plot.ylim = [-4 6];
[~,~,~] = plot_population_neuron(bf_data_timingTask,plot_trial_types,params,1);

