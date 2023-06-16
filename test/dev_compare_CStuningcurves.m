
load(fullfile(dirs.root,'data','large','bf_data_CS_spkRemoved.mat'))
load(fullfile(dirs.root,'data','large','bf_datasheet_CS.mat'))


plot_trial_types = {'prob0','prob25','prob50','prob75','prob100'};
colors.appetitive = [247 154 154; 244 107 107; 240 59 59; 230 18 18; 182 14 14]./255;
params.plot.colormap = colors.appetitive;
params.plot.xlim = [0:2500];

% Get spike x prob curves (BF: NIH)
site = 'nih';
data_in = []; datasheet_in = [];
data_in = bf_data_CS(bf_datasheet_CS.cluster_id == 2 & strcmp(bf_datasheet_CS.site,site),:);
datasheet_in = bf_datasheet_CS(bf_datasheet_CS.cluster_id == 2 & strcmp(bf_datasheet_CS.site,site),:);

[~, ~, ~, bf_nih_yfit_out] =...
    plot_fr_x_uncertain(data_in,datasheet_in,plot_trial_types,params,0);

% Get spike x prob curves (BF: WUSTL)
site = 'wustl';
data_in = []; datasheet_in = [];
data_in = bf_data_CS(bf_datasheet_CS.cluster_id == 2 & strcmp(bf_datasheet_CS.site,site),:);
datasheet_in = bf_datasheet_CS(bf_datasheet_CS.cluster_id == 2 & strcmp(bf_datasheet_CS.site,site),:);

[~, ~, ~, bf_wustl_yfit_out] =...
    plot_fr_x_uncertain(data_in,datasheet_in,plot_trial_types,params,0);

% Get spike x prob curves (Striatum)
site = 'wustl';
data_in = []; datasheet_in = [];
data_in = striatum_data_CS;
datasheet_in = striatum_datasheet_CS;

[~, ~, ~, striatum_yfit_out] =...
    plot_fr_x_uncertain(data_in,datasheet_in,plot_trial_types,params,0);

% Get p(gaze | prob) curves
dev_eyePos_CSall
eye_yfit_out_1500 = y_fit_out_1500;
eye_yfit_out_2500 = y_fit_out_2500;


fit_data = [];
for dataset = 1:5
    switch dataset
        case 1
            for trl_i = 1:size(bf_nih_yfit_out,1)
                fit_data = [fit_data; polyval(bf_nih_yfit_out(trl_i,:),[1:0.1:5])];
            end
        case 2
            for trl_i = 1:size(bf_wustl_yfit_out,1)
                fit_data = [fit_data; polyval(bf_wustl_yfit_out(trl_i,:),[1:0.1:5])];
            end
        case 3
            for trl_i = 1:size(striatum_yfit_out,1)
                fit_data = [fit_data; polyval(striatum_yfit_out(trl_i,:),[1:0.1:5])];
            end
        case 4
            for trl_i = 1:size(eye_yfit_out_1500,1)
                fit_data = [fit_data; polyval(eye_yfit_out_1500(trl_i,:),[1:0.1:5])];
            end
        case 5
            for trl_i = 1:size(eye_yfit_out_2500,1)
                fit_data = [fit_data; polyval(eye_yfit_out_2500(trl_i,:),[1:0.1:5])];
            end
    end
end


%% Figure: plot data
clear site_label data_plot color_label
site_label = [repmat({'1_BF:NIH'},length(bf_nih_yfit_out),1);...
    repmat({'2_BF:WUSTL'},length(bf_wustl_yfit_out),1);...
    repmat({'3_Striatum'},length(striatum_yfit_out),1);...
    repmat({'4_Gaze1500'},length(eye_yfit_out_1500),1);...
    repmat({'5_Gaze2500'},length(eye_yfit_out_2500),1)];
data_plot = [bf_nih_yfit_out(:,1); bf_wustl_yfit_out(:,1); striatum_yfit_out(:,1); eye_yfit_out_1500(:,1); eye_yfit_out_2500(:,1)];
color_label = [repmat({'1_param1'},length(site_label),1)];

clear figure_plot
figure_plot(1,1)=gramm('x',site_label,'y',data_plot);
figure_plot(1,1).stat_summary('geom',{'bar','black_errorbar'},'width',0.5);
figure_plot(1,1).axe_property('YLim',[-0.5 0]);
figure_plot(1,1).set_names('x','Dataset','y','Param value');

figure('Renderer', 'painters', 'Position', [100 100 800 400]);
figure_plot.draw;

clear figure_plot
figure_plot(1,1)=gramm('x',[1:0.1:5],'y',num2cell(fit_data,2));
figure_plot(1,1).stat_summary();
figure_plot(1,1).geom_line('alpha',0.1);
figure_plot(1,1).axe_property('XLim',[0 6],'XTick',[1 2 3 4 5],'XTickLabel',{'0%','25%','50%','75%','100%'},'YLim',[0 1.5]);
figure_plot(1,1).set_names('x','Dataset','y','p(event)');
figure_plot(1,1).facet_grid([],site_label);

figure('Renderer', 'painters', 'Position', [100 100 800 200]);
figure_plot.draw;
