clear all; clc
addpath('/Users/stevenerrington/Desktop/mengxi_bf_neurons/code')

dir_in = '/Users/stevenerrington/Desktop/mengxi_bf_neurons/data/';
files_out = dir_mat_files(dir_in);
params = get_params;


%{

Mengxi notes:
fractal ID

cue number 6105
Second digit is block number
Final digit is 1,2,3,4,5 = 100:25:0


fractal number
novel: 7001
familiar: 7112:10:7142; 
second digit = block
third digit = type of fractal
fourth digit = always 2 because familiar

For uncertainty - just look at block four! (no novelty)

%}


parfor file_i= 1:length(files_out)
    filename = files_out{file_i};
    fprintf('Extracting session %s     | %i of %i        \n', filename, file_i, length(files_out));

    % Load the data (PDS structure)
    data_in = load(fullfile(dir_in,filename),'PDS');

    % Get trial indices
    trials = get_trials_fractal(data_in.PDS);

    % Get event aligned rasters
    Rasters = get_raster_fractal(data_in.PDS, trials, params); % Derived from Timing2575Group.m

    % Get event aligned spike-density function
    SDF = plot_mean_psth({Rasters},params.sdf.gauss_ms,1,size(Rasters,2),1);

    table_out(file_i,:) = table(file_i, {filename}, {trials}, {Rasters}, {SDF},...
        'VariableNames', {'file_i','filename','trials','raster','sdf'});
end




trial_type_list = {'fractal_6401','fractal_6402','fractal_6403','fractal_6404','fractal_6405'};
n_colors = cbrewer('seq', 'Reds', length(trial_type_list));

for file_i= 1:length(files_out)
    figuren; hold on

    for trial_type_i = 1:length(trial_type_list)
        trial_type = trial_type_list{trial_type_i};

        plot(-5000:5000, nanmean(table_out(file_i,:).sdf{1}(table_out(file_i,:).trials{1}.(trial_type),:)),'color',n_colors(trial_type_i,:))
    end

    xlim([-500 4000])
    title([int2str(file_i) ' - ' table_out(file_i,:).filename{1}],'Interpreter','none')
    pause
    close all
end
