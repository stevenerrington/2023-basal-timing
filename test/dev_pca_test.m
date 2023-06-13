
%% Example extraction code
data_in = []; data_in = bf_data_CS(strcmp(bf_datasheet_CS.site,'nih'),:); 
%data_in = []; data_in = striatum_data_CS; 
    % Note: here I'm just including NIH data whilst troubleshooting as the
    % data is neater and it saves me having to deal with variable outcome
    % times (i.e. 1500ms v 2500 ms)
    
clear timewin 
trial_type_in = 'prob50'; % Corresponds to a trial type in the data_in structure
timewin = [0:5:1500+500]; % Denotes the time window to extract the SDF from (rel to CS onset)

clear sdf_00 sdf_50;

%% Get average SDF
% Then for each neuron in the data_in table
for neuron_i = 1:size(data_in,1)
    % Get the mean SDF within the defined window, in the defined trials
    
    sdf_00(neuron_i,:) =...
        nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.('prob0'),timewin+5001))./...
        max(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.probAll,timewin+5001)));
    
    sdf_50(neuron_i,:) =...
        nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.(trial_type_in),timewin+5001))./...
        max(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.probAll,timewin+5001)));
    % Note: this is normalized to the max FR across ALL probability trials
    % in the same window.
end


%% Shuffle data:
n_bootstraps = 1000;

for bootstrap_i = 1:n_bootstraps
    shuffled_sdf50 = [];
    
    for neuron_i = 1:size(sdf_50,1)
        shuffled_sdf50(neuron_i,:) = sdf_50(neuron_i,randperm(size(sdf_50,2)));
    end
    
    [~,~,~,~,explained,~] =...
        pca(shuffled_sdf50,'Rows','pairwise'); %lets calculate Principal Comp
    
    var_explained_bootstrap_i = [];
    var_explained_bootstrap_i = explained./sum(explained) * 100;
    
    var_exp_bootstrap(bootstrap_i,:) = var_explained_bootstrap_i';
end



%% Run PCA analysis
[coeff,score,latent,tsquared,explained,mu] = pca(sdf_50');
% Note: input into pca is flipped - each neuron is a column, and time point
% is a row.

% Plot the cumulative variability explained
figure; hold on
plot(explained./sum(explained) * 100)
plot(max(var_exp_bootstrap),'r--')
plot(min(var_exp_bootstrap),'r--')
xlim([1 5])


% Get the first 3 principle components
pc1 = score(:, 1);
pc2 = score(:, 2);
pc3 = score(:, 3);

% Find the index of CS onset and outcome time relative to the SDF we've extracted
onset_time_idx = find(timewin == 0);
outcome_time_idx = find(timewin == 1500);

% Produce jazzy-high-impact figure that is 100% going to get a Science
% paper.
figure; hold on
color_line3(pc1, pc2, pc3, timewin)
scatter3(pc1(onset_time_idx),pc2(onset_time_idx),pc3(onset_time_idx),'ko','filled')
scatter3(pc1(outcome_time_idx),pc2(outcome_time_idx),pc3(outcome_time_idx),'ko','filled')
colorbar