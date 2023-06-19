function bfstri_pca_explore(bf_data_CS,striatum_data_CS)
%% Example extraction code
% Tidy workspace   
clear timewin 

% Define trials/area/sdf normalization
trial_type_in = 'prob50'; % Corresponds to a trial type in the data_in structure
area_in = 'striatum'; % striatum, bf_nih, bf_wustl
sdf_norm = 'zscore'; % zscore or max

% Switch the inputted dataset based on the area, and define the outcome
% times.

switch area_in
    case 'striatum'
        data_in = []; data_in = striatum_data_CS;
        outcome_time = 2500;
    case 'bf_nih'
        data_in = []; data_in = bf_data_CS(strcmp(bf_datasheet_CS.site,'nih'),:);
        outcome_time = 1500;
    case 'bf_wustl'
        data_in = []; data_in = bf_data_CS(strcmp(bf_datasheet_CS.site,'wustl'),:);
        outcome_time = 2500;
end

% Define the plot window
timewin = [];
timewin = [0:5:outcome_time]; % Denotes the time window to extract the SDF from (rel to CS onset)


%% Get average SDF
% Then for each neuron in the data_in table
clear sdf_50_max sdf_50_z;

for neuron_i = 1:size(data_in,1)
    % Get the mean SDF within the defined window, in the defined trials
    sdf_50_max(neuron_i,:) =...
        nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.(trial_type_in),timewin+5001))./...
        max(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.probAll,timewin+5001)));
    % Note: this is normalized to the max FR across ALL probability trials
    % in the same window.
    
    sdf_50_z(neuron_i,:) =...
        (nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.(trial_type_in),timewin+5001))-...
        mean(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.probAll,timewin+5001))))./...
        std(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.probAll,timewin+5001)));
    % Note: this is z-score normalized across ALL probability trials
    % in the same window.
end


%% Shuffle data:
% Parameterize bootstrap
n_bootstraps = 1000;

% Switch inputted data based on normalization method
switch sdf_norm
    case 'zscore'
        sdf_data_in = []; sdf_data_in = sdf_50_z;
    case 'max'
        sdf_data_in = []; sdf_data_in = sdf_50_max;
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

clear pc1 pc2 pc3
% Get the first 3 principle components
pc1 = score(:, 1); pc2 = score(:, 2); pc3 = score(:, 3);

% Find the index of CS onset and outcome time relative to the SDF we've extracted
onset_time_idx = find(timewin == 0);
outcome_time_idx = find(timewin == outcome_time);

%% Figure generation
% Produce jazzy-high-impact figure that is 100% going to get a Science
% paper.
figure('Renderer', 'painters', 'Position', [100 100 1000 600]);

% Plot the cumulative variability explained
n_pc_plot = 5;
perc_var_explained = []; perc_var_explained = explained([1:n_pc_plot])./sum(explained([1:n_pc_plot])) * 100;

subplot(3,6,[7 8 13 14]); hold on
plot(perc_var_explained,'k','LineWidth',2)
scatter([1:n_pc_plot], perc_var_explained,'ko','filled')
plot(max(var_exp_bootstrap(:,[1:n_pc_plot])),'r-')
% plot(min(var_exp_bootstrap(:,[1:n_pc_plot])),'r-')
xlim([0 6]); ylim([0 100])
xlabel('N Principal Components'); ylabel('% of variance explained')

n_pc_threshold = sum(perc_var_explained' > max(var_exp_bootstrap(:,[1:n_pc_plot])));
title([int2str(n_pc_threshold) ' PCs above shuffled'], 'Interpreter', 'none')

% Plot individual PC's
subplot(3,6,[1 2])
plot(timewin,pc1,'k')
xlabel('Time from CS'); ylabel('PC1')
vline(outcome_time, 'r-')
title([int2str(perc_var_explained(1)) ' % of variance'], 'Interpreter', 'none')

subplot(3,6,[3 4])
plot(timewin,pc2,'k')
xlabel('Time from CS'); ylabel('PC2')
vline(outcome_time, 'r-')
title([int2str(perc_var_explained(2)) ' % of variance'], 'Interpreter', 'none')

subplot(3,6,[5 6])
plot(timewin,pc3,'k')
xlabel('Time from CS'); ylabel('PC3')
vline(outcome_time, 'r-')
title([int2str(perc_var_explained(3)) ' % of variance'])

% Plot PCs in 3D space
subplot(3,6,[9 10 11 12 15 16 17 18]); hold on
color_line3(pc1, pc2, pc3, timewin,'LineWidth',2)
scatter3(pc1(onset_time_idx),pc2(onset_time_idx),pc3(onset_time_idx),75,'k','^','filled')
scatter3(pc1(outcome_time_idx),pc2(outcome_time_idx),pc3(outcome_time_idx),75,'k','v','filled')
xlabel('PC1'); ylabel('PC2'); zlabel('PC3')
view(149.4879,23.6129); colorbar
title([area_in ' - ' sdf_norm ' - ' trial_type_in], 'Interpreter', 'none')

%%