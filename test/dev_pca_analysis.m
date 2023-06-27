%% Extract longer-scale SDF for PCA

for neuron_i = 1:size(bf_datasheet_CS,1)
    
    % Clear variables, console, and figures
    clear REX PDS trials Rasters SDFcs_n fano; clc; close all;
    
    filename = bf_datasheet_CS.file{neuron_i};
    fprintf('Extracting data from neuron %i of %i   |  %s   \n',neuron_i,size(bf_datasheet_CS,1), filename)
    
    switch bf_datasheet_CS.site{neuron_i}
        case 'nih' % NIH data
            % Load the data (REX structure)
            REX = mrdr('-a', '-d', fullfile(bf_datasheet_CS.dir{neuron_i},bf_datasheet_CS.file{neuron_i}));
            alt_sdf{neuron_i,1} = get_alt_sdf(REX, 'REX');
            
        case 'wustl' % WUSTL data
            % Load the data (PDS structure)
            load(fullfile(bf_datasheet_CS.dir{neuron_i},bf_datasheet_CS.file{neuron_i}),'PDS');
            alt_sdf{neuron_i,1} = get_alt_sdf(PDS, 'PDS');
            % ~~~~ DOES NOT WORK FOR PDS DATA!
    end
    
end

%% 

bf_data_CS.alt_sdf = alt_sdf;
