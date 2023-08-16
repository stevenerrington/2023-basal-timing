function plot_pca_analysis_fig(pca_data_out)

figure('Renderer', 'painters', 'Position', [100 100 600 400]);
n_pc_plot = 5;

outcome_time = 1500;
timewin = pca_data_out{1}.timewin;
% Find the index of CS onset and outcome time relative to the SDF we've extracted
fix_time_idx = find(timewin == -1000);
onset_time_idx = find(timewin == 0);
outcome_time_idx = find(timewin == outcome_time);

% STRIATUM DATA >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
area_i = 1;

subplot(2,2,area_i,'Position',[0.1 0.75 0.3 0.2]); hold on
bar(pca_data_out{area_i}.perc_var_explained,'k');
plot(max(pca_data_out{area_i}.var_exp_bootstrap(:,[1:n_pc_plot])),'r--');
xlim([0 6]); ylim([0 100])
xlabel('N Principal Components'); ylabel('% Var')

n_pc_threshold = sum(pca_data_out{area_i}.perc_var_explained' > max(pca_data_out{area_i}.var_exp_bootstrap(:,[1:n_pc_plot])));
title([int2str(n_pc_threshold) ' PCs above shuffled'], 'Interpreter', 'none')

% Plot PCs in 3D space
subplot(2,2,area_i+2,'Position',[0.1 0.05 0.3 0.6]); hold on
color_line3(pca_data_out{area_i}.pcs.pc1, pca_data_out{area_i}.pcs.pc2, pca_data_out{area_i}.pcs.pc3, timewin,'LineWidth',2);
scatter3(pca_data_out{area_i}.pcs.pc1(fix_time_idx),pca_data_out{area_i}.pcs.pc2(fix_time_idx),pca_data_out{area_i}.pcs.pc3(fix_time_idx),75,'k','o','filled');
scatter3(pca_data_out{area_i}.pcs.pc1(onset_time_idx),pca_data_out{area_i}.pcs.pc2(onset_time_idx),pca_data_out{area_i}.pcs.pc3(onset_time_idx),75,'k','^','filled');
scatter3(pca_data_out{area_i}.pcs.pc1(outcome_time_idx),pca_data_out{area_i}.pcs.pc2(outcome_time_idx),pca_data_out{area_i}.pcs.pc3(outcome_time_idx),75,'k','v','filled');
xlabel('PC1'); ylabel('PC2'); zlabel('PC3')
view(143.2141,15.2454); colorbar('location','SouthOutside')
xlim([-40 40]); ylim([-40 40]); zlim([-40 40]);
grid on

% BF DATA >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
area_i = 2;

subplot(2,2,area_i,'Position',[0.55 0.75 0.3 0.2]); hold on
bar(pca_data_out{area_i}.perc_var_explained,'k')
plot(max(pca_data_out{area_i}.var_exp_bootstrap(:,[1:n_pc_plot])),'r--')
xlim([0 6]); ylim([0 100])
xlabel('N Principal Components'); ylabel('% Var')

n_pc_threshold = sum(pca_data_out{area_i}.perc_var_explained' > max(pca_data_out{area_i}.var_exp_bootstrap(:,[1:n_pc_plot])));
title([int2str(n_pc_threshold) ' PCs above shuffled'], 'Interpreter', 'none')

% Plot PCs in 3D space
subplot(2,2,area_i+2,'Position',[0.55 0.05 0.3 0.6]); hold on
color_line3(pca_data_out{area_i}.pcs.pc1, pca_data_out{area_i}.pcs.pc2, pca_data_out{area_i}.pcs.pc3, timewin,'LineWidth',2)
scatter3(pca_data_out{area_i}.pcs.pc1(fix_time_idx),pca_data_out{area_i}.pcs.pc2(fix_time_idx),pca_data_out{area_i}.pcs.pc3(fix_time_idx),75,'k','o','filled');
scatter3(pca_data_out{area_i}.pcs.pc1(onset_time_idx),pca_data_out{area_i}.pcs.pc2(onset_time_idx),pca_data_out{area_i}.pcs.pc3(onset_time_idx),75,'k','^','filled')
scatter3(pca_data_out{area_i}.pcs.pc1(outcome_time_idx),pca_data_out{area_i}.pcs.pc2(outcome_time_idx),pca_data_out{area_i}.pcs.pc3(outcome_time_idx),75,'k','v','filled')
xlabel('PC1'); ylabel('PC2'); zlabel('PC3')
view(143.2141,15.2454); colorbar('location','SouthOutside')
xlim([-40 40]); ylim([-40 40]); zlim([-40 40]);
grid on

end