%% Extract longer-scale SDF for PCA

clear alt_sdf*

% Basal Forebrain data
for neuron_i = 1:size(bf_datasheet_CS,1)
    
    % Clear variables, console, and figures
    clear REX PDS trials Rasters SDFcs_n fano; clc; close all;
    
    filename = bf_datasheet_CS.file{neuron_i};
    fprintf('Extracting data from neuron %i of %i   |  %s   \n',neuron_i,size(bf_datasheet_CS,1), filename)
    
    switch bf_datasheet_CS.site{neuron_i}
        case 'nih' % NIH data
            % Load the data (REX structure)
            REX = mrdr('-a', '-d', fullfile(bf_datasheet_CS.dir{neuron_i},bf_datasheet_CS.file{neuron_i}));
            alt_sdf_bf{neuron_i,1} = get_alt_sdf(REX, 'REX');
            
        case 'wustl' % WUSTL data
            % Load the data (PDS structure)
            load(fullfile(bf_datasheet_CS.dir{neuron_i},bf_datasheet_CS.file{neuron_i}),'PDS');
            alt_sdf_bf{neuron_i,1} = get_alt_sdf(PDS, 'PDS');
    end
    
end

% Striatum data
for neuron_i = 1:size(striatum_datasheet_CS,1)
    
    % Clear variables, console, and figures
    clear REX PDS trials Rasters SDFcs_n fano; clc; close all;
    
    filename = striatum_datasheet_CS.file{neuron_i};
    fprintf('Extracting data from neuron %i of %i   |  %s   \n',neuron_i,size(striatum_datasheet_CS,1), filename)
    
    % Load the data (PDS structure)
    load(fullfile(striatum_datasheet_CS.dir{neuron_i},striatum_datasheet_CS.file{neuron_i}),'PDS');
    alt_sdf_striatum{neuron_i,1} = get_alt_sdf(PDS, 'PDS');
    
end

%% Overwrite previous SDF for simpler insertion into existing function
bf_data_CS.sdf = alt_sdf_bf;
striatum_data_CS.sdf = alt_sdf_striatum;

%% Check data
% > CS task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
plot_trial_types = {'prob0','prob25','prob50','prob75','prob100'};
params.plot.xlim = [-2000 10000]; params.plot.ylim = [0 60];
params.plot.colormap = [247 154 154; 244 107 107; 240 59 59; 230 18 18; 182 14 14]./255;

% Example
neuron_i = 16;
figure; 
subplot(2,1,1); hold on
plot([-5000:10000],nanmean(bf_data_CS.sdf{neuron_i}(bf_data_CS.trials{neuron_i}.prob0,:)),'color',params.plot.colormap(1,:))
plot([-5000:10000],nanmean(bf_data_CS.sdf{neuron_i}(bf_data_CS.trials{neuron_i}.prob25,:)),'color',params.plot.colormap(2,:))
plot([-5000:10000],nanmean(bf_data_CS.sdf{neuron_i}(bf_data_CS.trials{neuron_i}.prob50,:)),'color',params.plot.colormap(3,:))
plot([-5000:10000],nanmean(bf_data_CS.sdf{neuron_i}(bf_data_CS.trials{neuron_i}.prob75,:)),'color',params.plot.colormap(4,:))
plot([-5000:10000],nanmean(bf_data_CS.sdf{neuron_i}(bf_data_CS.trials{neuron_i}.prob100,:)),'color',params.plot.colormap(5,:))

subplot(2,1,2); hold on
plot([-5000:10000],nanmean(striatum_data_CS.sdf{neuron_i}(striatum_data_CS.trials{neuron_i}.prob0,:)),'color',params.plot.colormap(1,:))
plot([-5000:10000],nanmean(striatum_data_CS.sdf{neuron_i}(striatum_data_CS.trials{neuron_i}.prob25,:)),'color',params.plot.colormap(2,:))
plot([-5000:10000],nanmean(striatum_data_CS.sdf{neuron_i}(striatum_data_CS.trials{neuron_i}.prob50,:)),'color',params.plot.colormap(3,:))
plot([-5000:10000],nanmean(striatum_data_CS.sdf{neuron_i}(striatum_data_CS.trials{neuron_i}.prob75,:)),'color',params.plot.colormap(4,:))
plot([-5000:10000],nanmean(striatum_data_CS.sdf{neuron_i}(striatum_data_CS.trials{neuron_i}.prob100,:)),'color',params.plot.colormap(5,:))

%% Run PCA
params.pca.timewin = [-2000 7500];
params.pca.step = 10;

pca_data_out = bfstri_pca_space(bf_data_CS,bf_datasheet_CS,striatum_data_CS,params);
plot_pca_analysis_fig(pca_data_out);

