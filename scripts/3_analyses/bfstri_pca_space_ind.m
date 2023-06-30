function [n_pc_above_shuffled, observed_var, shuffled_var] = bfstri_pca_space_ind(bf_data_CS,bf_datasheet_CS,striatum_data_CS,params)
%% Example extraction code
% Tidy workspace
clear timewin

% Define trials/area/sdf normalization
trial_type_in = 'prob50'; % Corresponds to a trial type in the data_in structure
sdf_norm = 'zscore'; % zscore or max
area_list = {'striatum_wustl','bf_wustl'}; % striatum, bf_nih, bf_wustl

for area_i = 1:length(area_list)
    area_in = area_list{area_i};
    
    % Switch the inputted dataset based on the area, and define the outcome
    % times.
    
    switch area_in
        case 'striatum_wustl'
            data_in = []; data_in = striatum_data_CS;
            outcome_time = 2500;
        case 'bf_wustl'
            data_in = []; data_in = bf_data_CS(strcmp(bf_datasheet_CS.site,'wustl'),:);
            outcome_time = 2500;
    end
    
    
    % Define the plot window
    timewin = [];
    timewin = [params.pca.timewin(1):params.pca.step:params.pca.timewin(2)+outcome_time]; % Denotes the time window to extract the SDF from (rel to CS onset)
    
    
    %% Get average SDF
    % Then for each neuron in the data_in table
    clear sdf_50_max sdf_50_z;
    
    time_zero_sdf = 5001;
    
    for neuron_i = 1:size(data_in,1)     
        % Get the mean SDF within the defined window, in the defined trials       
        sdf_50_z{neuron_i,:} =...
            (data_in.sdf{neuron_i}(data_in.trials{neuron_i}.(trial_type_in),timewin+time_zero_sdf)-...
            mean(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.(trial_type_in),timewin+time_zero_sdf))))./...
            std(nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.(trial_type_in),timewin+time_zero_sdf)));

        sdf_50_max{neuron_i,:} =...
            data_in.sdf{neuron_i}(data_in.trials{neuron_i}.(trial_type_in),timewin+time_zero_sdf)./...
            max(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.(trial_type_in),timewin+time_zero_sdf),[],2);
        
    end
    
    
    %% Run PCA
    % Parameterize bootstrap
    n_bootstraps = 1000;
    sdf_data_in = []; sdf_data_in = sdf_50_z;
    
    clear shuffled_var
    for neuron_i = 1:size(sdf_data_in,1)
        
        fprintf('Extracting data from neuron %i of %i   |   \n',neuron_i,size(sdf_data_in,1))

        
        % If there are more than 6(?) trials
        if size(sdf_data_in{neuron_i},1) > 6
            
            clear var_exp_bootstrap shuffled_sdf50 explained
            
            %% Run shuffled PCA analysis
            % Run bootstrap and get explained variance
            for bootstrap_i = 1:n_bootstraps
                % For each neuron, shuffled the data in time
                shuffled_sdf50 = [];
                shuffled_sdf50 = sdf_data_in{neuron_i}(:,randperm(size(sdf_data_in{neuron_i},2)));
                
                % Run the PCA and get the explained proportion of variance
                [~,~,~,~,explained,~] =...
                    pca(shuffled_sdf50','Rows','complete'); %lets calculate Principal Comp
                
                % Convert this into a percentage of the total variance
                var_explained_bootstrap_i = [];
                var_explained_bootstrap_i = explained./sum(explained) * 100;
                
                % Save in the loop for future plotting.
                var_exp_bootstrap(bootstrap_i,:) = var_explained_bootstrap_i';
                
            end
            
            shuffled_var{neuron_i,1} = var_exp_bootstrap;
            

            %% Run observed PCA analysis
            % Run PCA on observed data
            [~,~,~,~,explained,~] = pca(sdf_data_in{neuron_i}','Rows','complete');
            % Note: input into pca is flipped - each neuron is a column, and time point
            % is a row.
            observed_var{neuron_i,1} = explained;

            perc_var_explained = [];
            perc_var_explained = explained([1:5])./sum(explained([1:5])) * 100;
           
            perc_var_shuffled = [];
            perc_var_shuffled = max(shuffled_var{neuron_i,1}(:,[1:5]))';
            
            n_pc_above_shuffled.(area_in)(neuron_i,:) = sum(perc_var_explained>perc_var_shuffled);
        else
            n_pc_above_shuffled.(area_in)(neuron_i,:) = NaN;
        end
        
    end
    
    
end