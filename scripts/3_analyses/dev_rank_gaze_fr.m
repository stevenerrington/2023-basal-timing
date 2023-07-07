
%% Parameter
trial_type_list = {'prob0','prob25','prob50','prob75','prob100'};
params.eye.salience_window = [-500:0];
params.eye.window = [5 5];

%% Extract
% Gaze tuning curves
[~, p_gaze_uncertainty_bf]  =...
    get_pgaze_uncertainty(bf_data_CS, bf_datasheet_CS, trial_type_list, params);
[~, p_gaze_uncertainty_striatum]  =...
    get_pgaze_uncertainty(striatum_data_CS, striatum_datasheet_CS, trial_type_list, params);

% Basal forebrain tuning curves
[p_fr_uncertainty_bf] =...
    get_fr_x_uncertain(bf_data_CS, bf_datasheet_CS,trial_type_list,params,0,'zscore');

% Striatum tuning curves
[p_fr_uncertainty_striatum] =...
    get_fr_x_uncertain(striatum_data_CS, striatum_datasheet_CS,trial_type_list,params,0,'zscore');

%% Analyse
% Get ranks for firing rate to uncertainty level
% For basal forebrain:
rank_gaze_bf = []; rank_neuron_bf = [];
for neuron_i = 1:size(bf_data_CS,1)
    
    rank_gaze_bf(neuron_i,:) = get_array_rank(p_gaze_uncertainty_bf(neuron_i,:));
    rank_neuron_bf(neuron_i,:) = get_array_rank(p_fr_uncertainty_bf(neuron_i,:));
    label_bf{neuron_i,1} = '1_BF';
    % Kendall Tau, or Rank Based Overlap
    [tau_bf(neuron_i,1)] = corr(rank_gaze_bf(neuron_i,:)',rank_neuron_bf(neuron_i,:)','type','Kendall');
end

% For striatum:
rank_gaze_striatum = []; rank_neuron_striatum = [];
for neuron_i = 1:size(striatum_data_CS,1)
    
    rank_gaze_striatum(neuron_i,:) = get_array_rank(p_gaze_uncertainty_striatum(neuron_i,:));
    rank_neuron_striatum(neuron_i,:) = get_array_rank(p_fr_uncertainty_striatum(neuron_i,:));
    label_striatum{neuron_i,1} = '2_Striatum';
    
    % Kendall Tau, or Rank Based Overlap
    [tau_bf(neuron_i,1)] = corr(rank_gaze_striatum(neuron_i,:)',rank_neuron_striatum(neuron_i,:)','type','Kendall');
end

%% Figure

clear figure_plot
figure_plot(1,1)=gramm('x',1:5,...
    'y',[p_fr_uncertainty_bf;p_fr_uncertainty_striatum;p_gaze_uncertainty_bf;p_gaze_uncertainty_striatum],...
    'color',[label_bf;label_striatum;repmat({'3_Gaze'},length([p_gaze_uncertainty_bf;p_gaze_uncertainty_striatum]),1)]);
figure_plot(1,1).stat_summary('geom',{'point','errorbar','line'});
figure_plot(1,1).set_names('y','');


figure_plot.draw





figure
heatmap([mean([rank_gaze_bf; rank_gaze_striatum])', mean(rank_neuron_bf)', mean(rank_neuron_striatum)'])
colormap(viridis)
