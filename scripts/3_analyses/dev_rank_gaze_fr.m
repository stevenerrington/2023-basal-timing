

trial_type_list = {'prob0','prob25','prob50','prob75','prob100'};
params.eye.salience_window = [-200:0];
params.eye.window = [5 5];

[~, p_gaze_uncertainty_bf]  =...
    get_pgaze_uncertainty(bf_data_CS, bf_datasheet_CS, trial_type_list, params);
[~, p_gaze_uncertainty_striatum]  =...
    get_pgaze_uncertainty(striatum_data_CS, striatum_datasheet_CS, trial_type_list, params);

[p_fr_uncertainty_bf] =...
    get_fr_x_uncertain(bf_data_CS, bf_datasheet_CS,trial_type_list,params,0,'zscore');
[p_fr_uncertainty_striatum] =...
    get_fr_x_uncertain(striatum_data_CS, striatum_datasheet_CS,trial_type_list,params,0,'zscore');

rank_gaze_bf = []; rank_neuron_bf = [];
for neuron_i = 1:size(bf_data_CS,1)
    
    rank_gaze_bf(neuron_i,:) = get_array_rank(p_gaze_uncertainty_bf(neuron_i,:));
    rank_neuron_bf(neuron_i,:) = get_array_rank(p_fr_uncertainty_bf(neuron_i,:));
    
    % Kendall Tau, or Rank Based Overlap
    [tau_bf(neuron_i,1)] = corr(rank_gaze_bf(neuron_i,:)',rank_neuron_bf(neuron_i,:)','type','Kendall');
end

rank_gaze_striatum = []; rank_neuron_striatum = [];
for neuron_i = 1:size(striatum_data_CS,1)
    
    rank_gaze_striatum(neuron_i,:) = get_array_rank(p_gaze_uncertainty_striatum(neuron_i,:));
    rank_neuron_striatum(neuron_i,:) = get_array_rank(p_fr_uncertainty_striatum(neuron_i,:));
    
    % Kendall Tau, or Rank Based Overlap
    [tau_bf(neuron_i,1)] = corr(rank_gaze_striatum(neuron_i,:)',rank_neuron_striatum(neuron_i,:)','type','Kendall');
end

figure
heatmap([mean([rank_gaze_bf; rank_gaze_striatum])', mean(rank_neuron_bf)', mean(rank_neuron_striatum)'])
colormap(viridis)
xticklabels({'Gaze','BF','Striatum'})