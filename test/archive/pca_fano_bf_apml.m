
%% Analysis: epoched Fano Factor
clear epoch
epoch.CSonset = [0 200];
epoch_zero.CSonset = [0];
fano_timewindow = [0:500];

clear fano_prob*

input_data = [bf_data_CS(bf_datasheet_CS.cluster_id == 2,:)];
input_datasheet = bf_datasheet_CS(bf_datasheet_CS.cluster_id == 2,:);
cs_trial = 'prob50';

clear fano_cs_*
for neuron_i = 1:size(input_data,1)

    fano_continuous = [];
    fano_continuous = find(ismember(input_data.fano(neuron_i).time,fano_timewindow));
    
    fano_cs_onset_25(neuron_i,:) =  input_data.fano(neuron_i).raw.prob25(fano_continuous);
    fano_cs_onset_50(neuron_i,:) =  input_data.fano(neuron_i).raw.prob50(fano_continuous);
    fano_cs_onset_75(neuron_i,:) =  input_data.fano(neuron_i).raw.prob75(fano_continuous);
    fano_cs_onset_all(neuron_i,:) =  input_data.fano(neuron_i).raw.probAll(fano_continuous);
    fano_cs_mean_all(neuron_i,1) =  nanmean(input_data.fano(neuron_i).raw.probAll(fano_continuous));


end


figure;
histogram(fano_cs_mean_all,0:0.1:3)



clear t;
G=fano_cs_onset_all;
%[pc, zscores, pcvars] = pca(G,'VariableWeights','variance');
[pc, zscores, pcvars] = pca(G);
%VarE_=pcvars./sum(pcvars) * 100 %var exp
%VarE=cumsum(pcvars./sum(pcvars) * 100); %cum sum of variance

meas=zscores(:,[1:10])
%rng('default');  % For reproducibility
eva = evalclusters(meas,'kmeans','CalinskiHarabasz','KList',[1:6])
eva = evalclusters(meas,'kmeans','silhouette','KList',[1:6])
idx3 = kmeans(meas,2,'Distance','sqeuclidean');

a = input_datasheet(idx3 == 1,:)
b = input_datasheet(idx3 == 2,:)

mean(fano_cs_mean_all(idx3 == 1,:))
mean(fano_cs_mean_all(idx3 == 2,:))



figure; hold on
scatter3(zscores(find(idx3==1),1), zscores(find(idx3==1),2),zscores(find(idx3==1),3),20,'r','filled')
scatter3(zscores(find(idx3==2),1), zscores(find(idx3==2),2),zscores(find(idx3==2),3),20,'b','filled')


axis square
grid on
view(-10,20)
xlabel('PC1')
ylabel('PC2')
zlabel('PC3')
title('group 1 - red; group 2 - blue')