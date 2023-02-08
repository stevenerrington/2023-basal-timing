
%% Notes: 
% Inherited scripts that may be useful:
% > SingleVsDoubleOutcomeIlya
% > StructMakerTimingTrace_V01


%% Curation: generate a datamap
% > Load in a pre-curated sheet of neuron information for upcoming analyses 

bf_datasheet_traceExp = readtable(fullfile(dirs.root,'docs','timing_trace_neurontable.xlsx'));

%% Analysis: Extract relevant neurophys data

bf_data_traceExp = table();

for file_i = 1:size(bf_datasheet_traceExp,1)
    
    % Loop admin
    filename = bf_datasheet_traceExp.file{file_i};
    fprintf('Extracting data from neuron %i of %i   |  %s   \n',ii,size(bf_datasheet_traceExp,1), filename)
    
    % Load experimental data file
    clear PDS
    load(fullfile(bf_datasheet_traceExp.dir{file_i},filename), 'PDS');
   
    % Get trial indices
    trials = get_trials_traceTask(PDS);
    % > 2:21pm, Wed Feb 8th 2023. Up to here, translating code from
    % SingleVsDoubleOutcomeIlya into the repository structure.
    
    % Get event aligned rasters
    Rasters = get_trace_raster(PDS, trials, params);
    

end
