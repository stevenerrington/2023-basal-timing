clear figure_plot

%% Basal forebrain | CS task
% Input variables
data_in = []; data_in = bf_data_punish;

trialtype_plot.punish = {'prob0_punish','prob50_punish','prob100_punish'};
trialtype_plot.reward = {'prob0_reward','prob50_reward','prob100_reward'};


% Parameters
xlim_input_CS = [-500 1500]; xlim_input_outcome = [-500 0];
ylim_input = [0 50]; 
color_scheme_punish = [254 216 225; 251 137 166; 247 19 77]./255;
color_scheme_reward = [156 224 245; 56 193 236; 16 131 167]./255;

%% Extract
example_neuron_i = 13;

% Punish data
plot_punish
punish_struct.sdf = plot_sdf_data_pop;
punish_struct.trial_type = plot_label_pop;
punish_struct.fano = plot_fano_data_pop;

% Reward data
plot_reward
reward_struct.sdf = plot_sdf_data_pop;
reward_struct.trial_type = plot_label_pop;
reward_struct.fano = plot_fano_data_pop;


%% Layout
figure_plot(1,1).set_layout_options('Position',[0.025 0.775 0.45 0.1],...
    'legend',false,... 
    'margin_height',[0.02 0.05],...
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(2,1).set_layout_options('Position',[0.025 0.625 0.45 0.15],...
    'legend',false,... 
    'margin_height',[0.02 0.05],...
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(3,1).set_layout_options('Position',[0.025 0.55 0.45 0.05],...
    'legend',false,... 
    'margin_height',[0.02 0.05],...
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(4,1).set_layout_options('Position',[0.025 0.25 0.45 0.2],...
    'legend_pos',[0.25 0.35 0.1 0.1],... 
    'margin_height',[0.02 0.05],...
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(5,1).set_layout_options('Position',[0.025 0.2 0.45 0.05],...
    'legend',false,... 
    'margin_height',[0.02 0.05],...
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(1,2).set_layout_options('Position',[0.5 0.775 0.45 0.1],...
    'legend',false,... 
    'margin_height',[0.02 0.05],...
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(2,2).set_layout_options('Position',[0.5 0.625 0.45 0.15],...
    'legend',false,... 
    'margin_height',[0.02 0.05],...
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(3,2).set_layout_options('Position',[0.5 0.55 0.45 0.05],...
    'legend',false,... 
    'margin_height',[0.02 0.05],...
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(4,2).set_layout_options('Position',[0.5 0.25 0.45 0.2],...
    'legend_pos',[0.75 0.35 0.1 0.1],... 
    'margin_height',[0.02 0.05],...
    'margin_width',[0.1 0.02],...
    'redraw',false);

figure_plot(5,2).set_layout_options('Position',[0.5 0.2 0.45 0.05],...
    'legend',false,... 
    'margin_height',[0.02 0.05],...
    'margin_width',[0.1 0.02],...
    'redraw',false);



%% Plot edits
for plot_i = 1:5
    figure_plot(plot_i,1).geom_vline('xintercept',[0 1500]);
    figure_plot(plot_i,1).set_line_options('base_size', 0.75);
    
    figure_plot(plot_i,2).geom_vline('xintercept',[0 1500]);
    figure_plot(plot_i,2).set_line_options('base_size', 0.75);    
    
end

figure_plot_out = figure('Renderer', 'painters', 'Position', [100 100 500 600]);
figure_plot.draw();
clear figure_plot;



%% Plot slope & fr by punish/reward
analysis_window_fr = 5000+1500+[-50:0];
analysis_window_slope = 5000+1500+[-500:0];

for sample_i = 1:length(punish_struct.sdf)
    mean_fr_punish(sample_i,1) = nanmean(punish_struct.sdf{sample_i}(:,analysis_window_fr));
    slope_punish(sample_i,1) = corr(analysis_window_slope',punish_struct.sdf{sample_i}(:,analysis_window_slope)');
end

for sample_i = 1:length(reward_struct.sdf)
    mean_fr_reward(sample_i,1) = nanmean(reward_struct.sdf{sample_i}(:,analysis_window_fr));
    slope_reward(sample_i,1) = corr(analysis_window_slope',reward_struct.sdf{sample_i}(:,analysis_window_slope)');
end

label_juice = repmat({'1_juice'},length(punish_struct.sdf),1);
label_airpuff = repmat({'2_airpuff'},length(punish_struct.sdf),1);
label_all = [label_juice; label_airpuff];

trial_type_all = [reward_struct.trial_type; punish_struct.trial_type];

data_all.mean_fr = [mean_fr_reward; mean_fr_punish];
data_all.slope = [slope_reward; slope_punish];

bandwidth_input_fr = 0.5;
bandwidth_input_slope = 0.25;

clear figure_slope_fr
figure_slope_fr(1,1)=gramm('x',data_all.mean_fr,'color',trial_type_all);
figure_slope_fr(1,1).stat_density('bandwidth',bandwidth_input_fr);
figure_slope_fr(1,1).facet_grid([],label_all);
figure_slope_fr(1,1).axe_property('YLim',[0 0.8]);

figure_slope_fr(2,1)=gramm('x',data_all.slope,'color',trial_type_all);
figure_slope_fr(2,1).stat_density('bandwidth',bandwidth_input_slope);
figure_slope_fr(2,1).facet_grid([],label_all);
figure_slope_fr(2,1).axe_property('YLim',[0 3]);

figure('Renderer', 'painters', 'Position', [100 100 500 400]);
figure_slope_fr.draw();


% alt example: g(1,1).stat_bin('edges',[-3:0.5:7],'geom','overlaid_bar','fill','face');


%% Plot fano factor differences

analysis_window_fano = [];
analysis_window_fano = find(ismember(bf_data_punish.fano(1,1).time,[0:1500]));

for sample_i = 1:length(punish_struct.sdf)
    mean_fano_punish(sample_i,1) = nanmean(punish_struct.fano{sample_i}(:,analysis_window_fano));
end

for sample_i = 1:length(reward_struct.sdf)
    mean_fano_reward(sample_i,1) = nanmean(reward_struct.fano{sample_i}(:,analysis_window_fano));
end

data_all.mean_fano = [mean_fano_reward; mean_fano_punish]; 
trial_type_all = [reward_struct.trial_type; punish_struct.trial_type];

clear figure_slope_fr
figure_fano_comp(1,1)=gramm('x',trial_type_all,'y',data_all.mean_fano,'color',trial_type_all);
figure_fano_comp(1,1).stat_summary('geom',{'bar','errorbar'},'dodge',5,'width',5);
figure_fano_comp(1,1).geom_jitter('alpha',0.5);
figure_fano_comp(1,1).facet_grid([],label_all);
%figure_fano_comp(1,1).set_color_options('map',[color_scheme_reward';color_scheme_reward']);
figure_fano_comp(1,1).axe_property('YLim',[0 2]);
figure_fano_comp(1,1).geom_hline('yintercept',1);
%figure_fano_comp(1,1).no_legend;

figure('Renderer', 'painters', 'Position', [100 100 600 300]);
figure_fano_comp.draw();




