function pca_data_out = bfstri_pca_space(bf_data_CS,bf_datasheet_CS,striatum_data_CS)
%% Example extraction code
% Tidy workspace
clear timewin

% Define trials/area/sdf normalization
trial_type_in = 'prob50'; % Corresponds to a trial type in the data_in structure
sdf_norm = 'zscore'; % zscore or max
area_list = {'striatum_wustl','bf_wustl'}; % striatum, bf_nih, bf_wustl

for area_i = 1:length(area_list)
    area_in = area_list{area_i};
    
    % Switch the inputted dataset based on the area, and define the outcome
    % times.
    
    switch area_in
        case 'striatum_wustl'
            data_in = []; data_in = striatum_data_CS;
            outcome_time = 2500;
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
    
    time_zero_sdf = 5001;
    
    for neuron_i = 1:size(data_in,1)
        % Get the mean SDF within the defined window, in the defined trials
        sdf_50_max(neuron_i,:) =...
            nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.(trial_type_in),timewin+time_zero_sdf))./...
            max(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.probAll,timewin+time_zero_sdf)));
        % Note: this is normalized to the max FR across ALL probability trials
        % in the same window.
        
        sdf_50_z(neuron_i,:) =...
            (nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.(trial_type_in),timewin+time_zero_sdf))-...
            mean(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.probAll,timewin+time_zero_sdf))))./...
            std(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.probAll,timewin+time_zero_sdf)));
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
    % Plot the cumulative variability explained
    n_pc_plot = 5;
    perc_var_explained = []; perc_var_explained = explained([1:n_pc_plot])./sum(explained([1:n_pc_plot])) * 100;
    
    pca_data_out{area_i}.perc_var_explained = perc_var_explained;
    pca_data_out{area_i}.var_exp_bootstrap = var_exp_bootstrap;
    pca_data_out{area_i}.pcs.pc1 = pc1;
    pca_data_out{area_i}.pcs.pc2 = pc2;
    pca_data_out{area_i}.pcs.pc3 = pc3;
    pca_data_out{area_i}.pcs.onset_time_idx = onset_time_idx;
    pca_data_out{area_i}.pcs.outcome_time_idx = outcome_time_idx;
    pca_data_out{area_i}.timewin = timewin;
    
    
end