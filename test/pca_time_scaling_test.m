clear timewin_1500 sdf_1500_z sdf_2500_z

% Define trials/area/sdf normalization
trial_type_in = 'prob50'; % Corresponds to a trial type in the data_in structure
sdf_norm = 'zscore'; % zscore or max
area_list = {'striatum_wustl','bf_wustl'}; % striatum, bf_nih, bf_wustl

data_in_1500 = []; data_in_1500 = bf_data_CS(strcmp(bf_datasheet_CS.site,'nih'),:);
data_in_2500 = []; data_in_2500 = bf_data_CS(strcmp(bf_datasheet_CS.site,'wustl'),:);
data_in = []; data_in = bf_data_CS;


min_neuron_n = min([size(data_in_1500,1),size(data_in_2500,1)]);

time_zero_sdf = 5001;
timewin_1500 = [-500:5:2000];
timewin_2500 = [-500:5:3000];

for neuron_i = 1:min_neuron_n

    sdf_1500_z(neuron_i,:) =...
        (nanmean(data_in_1500.sdf{neuron_i}(data_in_1500.trials{neuron_i}.(trial_type_in),timewin_1500+time_zero_sdf))-...
        mean(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.probAll,timewin_1500+time_zero_sdf))))./...
        std(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.probAll,timewin_1500+time_zero_sdf)));

    sdf_2500_z(neuron_i,:) =...
        (nanmean(data_in_2500.sdf{neuron_i}(data_in_2500.trials{neuron_i}.(trial_type_in),timewin_2500+time_zero_sdf))-...
        mean(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.probAll,timewin_2500+time_zero_sdf))))./...
        std(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.probAll,timewin_2500+time_zero_sdf)));

end


sdf_array = [sdf_1500_z, sdf_2500_z];

%% Run PCA analysis
% Run PCA on observed data
[coeff,score,latent,tsquared,explained,mu] = pca(sdf_array');
% Note: input into pca is flipped - each neuron is a column, and time point
% is a row.

clear pc1 pc2 pc3
% Get the first 3 principle components
pc1 = score(:, 1); pc2 = score(:, 2); pc3 = score(:, 3);

%%
idx_1500 = 1:length(timewin_1500);
idx_2500 = length(timewin_1500)+1:length(timewin_1500)+length(timewin_2500);

figuren; 
nsubplot(2,1,1,1); hold on
plot(timewin_1500,pc1(idx_1500))
plot(timewin_2500,pc1(idx_2500))

nsubplot(2,1,2,1); hold on
plot(timewin_1500,pc2(idx_1500))
plot(timewin_2500,pc2(idx_2500))

% Absolute sampling
count = 0;
for i = 1:length(idx_1500)
X = [pc1(idx_1500(i)),pc2(idx_1500(i));...
    pc1(idx_2500(i)),pc2(idx_2500(i))];

count = count + 1;
d(count) = pdist(X,'euclidean');
end

% Relative sampling

[1:1500]/1500
[1:2500]/2500

figure;
plot(timewin_1500,d)