%
% trialNum: N x S x D
% firingRates: N x S x D x T x maxTrialNum
% firingRatesAverage: N x S x D x T
%
% N is the number of neurons
% S is the number of stimuli conditions (F1 frequencies in Romo's task)
% D is the number of decisions (D=2)
% T is the number of time-points (note that all the trials should have the
% same length in time!)
bf_data_CS = bf_data_CS(strcmp(bf_datasheet_CS.site,'wustl'),:);

for neuron_i = 1:size(bf_data_CS,1)

    trialNum(neuron_i,1) = length(bf_data_CS.trials{neuron_i}.prob25);
    trialNum(neuron_i,2) =  length(bf_data_CS.trials{neuron_i}.prob50);
    trialNum(neuron_i,3) =  length(bf_data_CS.trials{neuron_i}.prob75);
    
end

maxTrialNum = max(trialNum(:));
nNeurons = size(bf_data_CS,1);


firingRates = zeros(nNeurons,3,length([-500:4000]),maxTrialNum);

trial_list = {'prob25','prob50','prob75'};

for neuron_i = 1:size(bf_data_CS,1)
    for trial_type_i = 1:length(trial_list)
        trials_in = [];
        trials_in = bf_data_CS.trials{neuron_i}.(trial_list{trial_type_i});
        
        for trial_i = 1:length(trials_in)
            
            firingRates(neuron_i,trial_type_i,:,trial_i) =...
                bf_data_CS.sdf{neuron_i}...
                (trials_in(trial_i),5001+[-500:4000]);
            
        end
        
    end
    
end

firingRatesAverage = nanmean(firingRates,4);

time = [-500:4000];
% Time events of interest (e.g. stimulus onset/offset, cues etc.)
% They are marked on the plots with vertical lines
timeEvents = time(round(length(time)/2));

% check consistency between trialNum and firingRates
for n = 1:size(firingRates,1)
    for s = 1:size(firingRates,2)
            assert(isempty(find(isnan(firingRates(n,s,:,1:trialNum(n,s))), 1)), 'Something is wrong!')
    end
end

combinedParams = {{1, [1 2]}};
margNames = {'Timing'};
margColours = [23 100 171]/256;

%% Step 1: PCA of the dataset

X = firingRatesAverage(:,:);
X = bsxfun(@minus, X, mean(X,2));

[W,~,~] = svd(X, 'econ');
W = W(:,1:12);

% minimal plotting
dpca_plot(firingRatesAverage, W, W, @dpca_plot_default);

% computing explained variance
explVar = dpca_explainedVariance(firingRatesAverage, W, W, ...
    'combinedParams', combinedParams);

% a bit more informative plotting
dpca_plot(firingRatesAverage, W, W, @dpca_plot_default, ...
    'explainedVar', explVar, ...
    'time', time,                        ...
    'timeEvents', timeEvents,               ...
    'marginalizationNames', margNames, ...
    'marginalizationColours', margColours);


%% Step 2: PCA in each marginalization separately

dpca_perMarginalization(firingRatesAverage, @dpca_plot_default, ...
   'combinedParams', combinedParams);

%% Step 3: dPCA without regularization and ignoring noise covariance

% This is the core function.
% W is the decoder, V is the encoder (ordered by explained variance),
% whichMarg is an array that tells you which component comes from which
% marginalization

tic
[W,V,whichMarg] = dpca(firingRatesAverage, 5, ...
    'combinedParams', combinedParams);
toc

explVar = dpca_explainedVariance(firingRatesAverage, W, V, ...
    'combinedParams', combinedParams);

dpca_plot(firingRatesAverage, W, V, @dpca_plot_default, ...
    'explainedVar', explVar, ...
    'marginalizationNames', margNames, ...
    'marginalizationColours', margColours, ...
    'whichMarg', whichMarg,                 ...
    'time', time,                        ...
    'timeEvents', timeEvents,               ...
    'timeMarginalization', 3, ...
    'legendSubplot', 16);
