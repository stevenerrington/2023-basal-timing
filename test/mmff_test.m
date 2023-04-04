%% Setup workspace
% Clear workspace
clear all; close all; clc; beep off; warning off;

% Define paths & key directories
dirs = get_dirs_bf('wustl');
params = get_params;
status = get_status(dirs);

load bf_data_CS
load bf_datasheet_CS
load striatum_data_CS
load striatum_datasheet_CS

%           A structure, each element of which contains a field 'spikes' which is a matrix with 1 row
%       per trial and 1 column per millisecond.  Each entry should be a '1' (there was a spike in
%       that ms on that trial) or a '0' (there wasn't).  All data should be time-aligned to some event.
%           For example, suppose you collect 100 trials, each with 200 ms of pre-target
%       data and 800 ms of post-target data. Your 'spikes' matrix would then be 100 by 1000
%       (with one of these for each element of 'data').

clear ramping_neurons_list phasic_neurons_list
ramping_neurons_list = find(bf_datasheet_CS.cluster_id == 2);
phasic_neurons_list = find(bf_datasheet_CS.cluster_id == 1);


% Fano parameters -----------------
times = 4500:50:7500; % from 800 ms before CS onset until 500 ms after reward.

fanoParams = [];
fanoParams.alignTime = 5000; % this time will become zero time
fanoParams.boxWidth = 25; % 50 ms sliding window.
fanoParams.binSpacing = 0.5; % 50 ms sliding window.

figureParams.plotRawF = 1;

clear mmff_bf
for neuron_i = 1:length(ramping_neurons_list)
    if strcmp(bf_datasheet_CS.site{ramping_neurons_list(neuron_i)},'wustl')
        timecut = [1:5750,6250:10001];
        zeropad = zeros(length(bf_data_CS.trials{ramping_neurons_list(neuron_i)}.uncertain),10001-length(timecut));
        
        mmff_bf.data.ramping(neuron_i).spikes = [logical(bf_data_CS.rasters{ramping_neurons_list(neuron_i)}...
        (bf_data_CS.trials{ramping_neurons_list(neuron_i)}.uncertain,timecut)),zeropad];
    
    else
        mmff_bf.data.ramping(neuron_i).spikes = logical(bf_data_CS.rasters{ramping_neurons_list(neuron_i)}...
        (bf_data_CS.trials{ramping_neurons_list(neuron_i)}.uncertain,:));
    end
    

end

for neuron_i = 1:length(phasic_neurons_list)
    mmff_bf.data.phasic(neuron_i).spikes = logical(bf_data_CS.rasters{phasic_neurons_list(neuron_i)}...
        (bf_data_CS.trials{phasic_neurons_list(neuron_i)}.uncertain,:));
end



mmff_bf.fano.ramping = VarVsMean(mmff_bf.data.ramping, times, fanoParams);
mmff_bf.fano.phasic = VarVsMean(mmff_bf.data.phasic, times, fanoParams);

%% 
figure('Renderer', 'painters', 'Position', [100 100 800 600]);
subplot(2,2,1); hold on
plot(mmff_bf.fano.ramping.times',mmff_bf.fano.ramping.meanRateAll','color',[0.5 0.5 0.5],'LineWidth',2);
plot(mmff_bf.fano.ramping.times',mmff_bf.fano.ramping.meanRateSelect','k','LineWidth',1);
xlim([-500 2000]); vline([0 1500],'k-')

title('Ramping')

subplot(2,2,2); hold on
plot(mmff_bf.fano.phasic.times',mmff_bf.fano.phasic.meanRateAll','color',[0.5 0.5 0.5],'LineWidth',2);
plot(mmff_bf.fano.phasic.times',mmff_bf.fano.phasic.meanRateSelect','k','LineWidth',1);
xlim([-500 2000]); vline([0 1500],'k-')

title('Phasic')

subplot(2,2,3); hold on

plot_ci(mmff_bf.fano.ramping.times,...
    [mmff_bf.fano.ramping.FanoFactor';... % mean
    mmff_bf.fano.ramping.Fano_95CIs(:,1)';...
    mmff_bf.fano.ramping.Fano_95CIs(:,2)'],...
    'MainLineColor','r','PatchColor', 'r', 'PatchAlpha', 0.2,'LineColor','k');
xlim([-500 2000]); ylim([0 3]); vline([0 1500],'k-')

plot_ci(mmff_bf.fano.ramping.times,...
    [mmff_bf.fano.ramping.FanoFactorAll';... % mean
    mmff_bf.fano.ramping.FanoAll_95CIs(:,1)';...
    mmff_bf.fano.ramping.FanoAll_95CIs(:,2)'],...
    'MainLineColor',[0.5 0.5 0.5],'PatchColor',[0.5 0.5 0.5], 'PatchAlpha', 0.1,'LineColor','k');
xlim([-500 2000]); ylim([0 3]); vline([0 1500],'k-')

subplot(2,2,4); hold on

plot_ci(mmff_bf.fano.phasic.times,...
    [mmff_bf.fano.phasic.FanoFactor';... % mean
    mmff_bf.fano.phasic.Fano_95CIs(:,1)';...
    mmff_bf.fano.phasic.Fano_95CIs(:,2)'],...
    'MainLineColor','b','PatchColor', 'b', 'PatchAlpha', 0.2,'LineColor','k');
xlim([-500 2000]); ylim([0 3]); vline([0 1500],'k-')

plot_ci(mmff_bf.fano.phasic.times,...
    [mmff_bf.fano.phasic.FanoFactorAll';... % mean
    mmff_bf.fano.phasic.FanoAll_95CIs(:,1)';...
    mmff_bf.fano.phasic.FanoAll_95CIs(:,2)'],...
    'MainLineColor',[0.5 0.5 0.5],'PatchColor',[0.5 0.5 0.5], 'PatchAlpha', 0.1,'LineColor','k');
xlim([-500 2000]); ylim([0 3]); vline([0 1500],'k-')

%%



%%
% n_neuron_bootstrap_sample = 25;
% 
% % Bootstrapped Fano Extraction ----------------
% for bootstrap_i = 1:50
%     bootstrap_i
%     bootstrap_neuron_list = [];
%     bootstrap_neuron_list = randsample(ramping_neurons_list,35);
%     
%     clear mmff_bf.ramping
%     
%     % Extract raster for bootstrapped neurons
%     for neuron_i = 1:length(bootstrap_neuron_list)
%         mmff_bf.ramping(neuron_i).spikes = logical(bf_data_CS.rasters{bootstrap_neuron_list(neuron_i)}...
%             (bf_data_CS.trials{bootstrap_neuron_list(neuron_i)}.uncertain,:));
%     end
%     
%     clear Result_BF
%     Result_BF = VarVsMean(mmff_bf.ramping, times, fanoParams);
%     
%     fano_test(bootstrap_i,:) = Result_BF.FanoFactor';
%     fano_time_test(bootstrap_i,:) = Result_BF.times';
%     
% 
% end
% 
% fano_test;
% 
% % target onset is at 5000 ms
% clear figureParams fanoParams
% 
% 
% 
% 
% 
% 
% % 21% of datapoints survived matching (~75% in example)
% 
% 
% 
% 
