function bf_population_CS_outcome = bf_cs_outcome(data_CS,datasheet_CS,params)

plot_trial_types = {'prob25nd','prob25d','prob50nd','prob50d','prob75nd','prob75d'};

% > Plot outcome-aligned population activity for ramping neurons in the
%   basal forebrain.
params.plot.xlim = [0 750]; params.plot.ylim = [-2 4];

% bf_population_CS_outcome = plot_population_CSoutcome(data_CS,datasheet_CS, plot_trial_types,params);

bf_population_CS_outcome = plot_population_CSoutcome_alt(data_CS,datasheet_CS, plot_trial_types,params);
