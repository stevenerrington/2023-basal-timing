function bfstri_gaze_fr_tuning(bf_data_CS, bf_datasheet_CS,...
    striatum_data_CS, striatum_datasheet_CS, params)
%% Parameter
trial_type_list = {'prob0','prob25','prob50','prob75','prob100'};
params.eye.salience_window = [-500:0];
params.eye.window = [5 5];

%% Extract
data_in_bf = []; datasheet_in_bf = [];
data_in_bf = bf_data_CS;
datasheet_in_bf = bf_datasheet_CS;

% Gaze x time plot
gaze_time_plot = get_eyePlot_CS(data_in_bf,datasheet_in_bf,...
    striatum_data_CS,striatum_datasheet_CS,params);

clear p_*
% Gaze tuning curves
[~, p_gaze_uncertainty_bf]  =...
    get_pgaze_uncertainty(data_in_bf, datasheet_in_bf, trial_type_list, params);
[~, p_gaze_uncertainty_striatum]  =...
    get_pgaze_uncertainty(striatum_data_CS, striatum_datasheet_CS, trial_type_list, params);

% Basal forebrain tuning curves
[p_fr_uncertainty_bf] =...
    get_fr_x_uncertain(data_in_bf, datasheet_in_bf,trial_type_list,params,0,'max');

% Striatum tuning curves
[p_fr_uncertainty_striatum] =...
    get_fr_x_uncertain(striatum_data_CS, striatum_datasheet_CS,trial_type_list,params,0,'max');

%% Analyse
% Get ranks for firing rate to uncertainty level
% For basal forebrain:
rank_gaze_bf = []; rank_neuron_bf = [];
clear label*
for neuron_i = 1:size(data_in_bf,1)
    
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

% Correlate activity by gaze

count = 0;
for neuron_i = 1:size(data_in_bf,1)
    count = count + 1;
    test_r(count,1) = corr(p_gaze_uncertainty_bf(neuron_i,:)', p_fr_uncertainty_bf(neuron_i,:)');
    corr_label{count,1} = '1_BF';
end

for neuron_i = 1:size(striatum_data_CS,1)
    count = count + 1;
    test_r(count,1) = corr(p_gaze_uncertainty_striatum(neuron_i,:)', p_fr_uncertainty_striatum(neuron_i,:)');
    corr_label{count,1} = '2_Striatum';
end

%% Figure

clear figure_plot

% Gaze through time (onset)
figure_plot(1,1)=gramm('x', gaze_time_plot.onset_x,'y',gaze_time_plot.onset_data,'color',gaze_time_plot.onset_label);
figure_plot(1,1).stat_summary();
figure_plot(1,1).axe_property('XLim',[0 750],'YLim',[0 1]);
%figure_plot(1,1).set_color_options('map',params.plot.colormap);
figure_plot(1,1).no_legend;

% Gaze through time (offset)
figure_plot(1,2)=gramm('x', gaze_time_plot.offset_x,'y',gaze_time_plot.offset_data,'color',gaze_time_plot.offset_label);
figure_plot(1,2).stat_summary();
figure_plot(1,2).axe_property('XLim',[-750 0],'YLim',[0 1]);
%figure_plot(1,2).set_color_options('map',params.plot.colormap);
figure_plot(1,2).no_legend;

figure_plot(1,3)=gramm('x',1:5,...
    'y',[p_fr_uncertainty_bf;p_fr_uncertainty_striatum;p_gaze_uncertainty_bf;p_gaze_uncertainty_striatum],...
    'color',[label_bf;label_striatum;repmat({'3_Gaze'},length([p_gaze_uncertainty_bf;p_gaze_uncertainty_striatum]),1)]);
figure_plot(1,3).stat_summary('geom',{'point','errorbar','line'});
figure_plot(1,3).axe_property('YLim',[0 1]);
figure_plot(1,3).set_names('y','');
figure_plot(1,3).no_legend();

figure_plot(1,4)=gramm('x',corr_label,'y',test_r,'color',corr_label);
figure_plot(1,4).stat_summary('geom',{'bar','errorbar'},'width',1);
figure_plot(1,4).axe_property('YLim',[0.5 1.000001]);
figure_plot(1,4).no_legend();

% Layout >>>>>>>>>>>>>>>>>>>
figure_plot(1,1).set_layout_options('Position',[0.05 0.2 0.2 0.75],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);

figure_plot(1,2).set_layout_options('Position',[0.27 0.2 0.2 0.75],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);
figure_plot(1,2).axe_property('YTick',[],'YColor',[1 1 1]);

figure_plot(1,3).set_layout_options('Position',[0.55 0.2 0.2 0.75],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);

figure_plot(1,4).set_layout_options('Position',[0.62 0.32 0.075 0.20],... %Set the position in the figure (as in standard 'Position' axe property)
    'legend',false,... % No need to display legend for side histograms
    'margin_height',[0.00 0.00],... %We set custom margins, values must be coordinated between the different elements so that alignment is maintained
    'margin_width',[0.0 0.00],...
    'redraw',false);
figure_plot(1,4).set_names('y','');

figure('Renderer', 'painters', 'Position', [100 100 800 200]);
figure_plot.draw;
% 
% figure
% heatmap([mode([rank_gaze_bf; rank_gaze_striatum])', mode(rank_neuron_bf)', mode(rank_neuron_striatum)'])
% colormap(viridis)
