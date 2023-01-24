function fano = get_fano(Rasters, trials, params)

% Define windows and times
Rasterscs = Rasters;
range_window = [-1500 2500]; event_zero = 5000;
analysis_win = event_zero+range_window(1):event_zero+range_window(2);

% Clip the raster to the appropriate analysis window
RastersFano = Rasterscs(:,analysis_win);

% Define trials of interest
trialtypes_all = [ length(trials.prob50), length(trials.prob75), length(trials.prob25)];

%% Stratify rasters for appropriate conditions
% % For all uncertainty trials:
fano100inc = RastersFano (trials.prob100,:);
fano75inc = RastersFano (trials.prob75,:);
fano50inc = RastersFano (trials.prob50,:);
fano25inc = RastersFano (trials.prob25,:);
fano0inc = RastersFano (trials.prob0,:);
fanoAllinc = RastersFano ([trials.prob25 trials.prob50 trials.prob75],:);

% % For unrewarded trials:
fano75nd= RastersFano (trials.prob75nd,:);
fano50nd= RastersFano (trials.prob50nd,:);
fano25nd= RastersFano (trials.prob25nd,:);
fano0nd= RastersFano (trials.prob0,:);
fanoAll= RastersFano ([trials.prob25nd trials.prob50nd trials.prob75nd],:); %%%%75 50 25 long dilivery.


%% Calculate Fano Factor
% Initialise relevant arrays
FanoSave0=[];  FanoSave25=[];  FanoSave50=[];  FanoSave75=[]; FanoSave100=[]; FanoSaveAll=[]; 
FanoSaveAllinc=[]; FanoSave25inc=[];  FanoSave50inc=[];  FanoSave75inc=[];

% For each bin...
for x = 1:size(RastersFano,2)-params.fano.bin_size
    
    % Get the array indices for the bin
    binAnalysis=[x:x+params.fano.bin_size];
    
    % Find all spikes within the bin window for each trial
    % % On non-delivered trials -------------------------
    % > All trials
    t = fanoAll(:,binAnalysis); t =nansum(t')';
    FanoSaveAll = [ FanoSaveAll; (std(t)^2)./mean(t)]; clear t
    
    % > 0% Probability
    t = fano0nd(:,binAnalysis); t =nansum(t')';
    FanoSave0 = [ FanoSave0; (std(t)^2)./mean(t)]; clear t
    
    % > 25% Probability
    t = fano25nd(:,binAnalysis); t =nansum(t')';
    FanoSave25 = [ FanoSave25; (std(t)^2)./mean(t)]; clear t
    
    % > 50% Probability
    t = fano50nd(:,binAnalysis); t =nansum(t')';
    FanoSave50 = [ FanoSave50; (std(t)^2)./mean(t)]; clear t    
    
    % > 75% Probability
    t = fano75nd(:,binAnalysis); t =nansum(t')';
    FanoSave75 = [ FanoSave75; (std(t)^2)./mean(t)]; clear t
    
    % % On all trials ------------------------- 
    % > All trials
    t = fanoAllinc(:,binAnalysis); t =nansum(t')';
    FanoSaveAllinc=[ FanoSaveAllinc; (std(t)^2)./mean(t)]; clear t
    
    % > 0% Probability
    t = fano25inc(:,binAnalysis); t =nansum(t')';
    FanoSave25inc=[ FanoSave25inc; (std(t)^2)./mean(t)]; clear t

    
    % > 50% Probability
    t = fano50inc(:,binAnalysis); t =nansum(t')';
    FanoSave50inc=[ FanoSave50inc; (std(t)^2)./mean(t)]; clear t
    
    % > 75% Probability    
    t = fano75inc(:,binAnalysis); t =nansum(t')';
    FanoSave75inc=[ FanoSave75inc; (std(t)^2)./mean(t)]; clear t
    
    % > 100% Probability
    t = fano100inc(:,binAnalysis); t =nansum(t')';
    FanoSave100=[ FanoSave100; (std(t)^2)./mean(t)]; clear t
    
end

% This analysis produces an array that houses the Fano factor for the given
% timebin across trials. NOTE: The array is flipped (bin_i x 1, rather than
% 1 x bin_i).

%% Smooth Fano Factor

SmoothBin=1;
fano(1).FanoSaveAllomit = smooth(FanoSaveAll',SmoothBin)';
fano(1).FanoSave0=  smooth(FanoSave0',SmoothBin)';
fano(1).FanoSave75omit =  smooth(FanoSave75',SmoothBin)';
fano(1).FanoSave50omit =  smooth(FanoSave50',SmoothBin)';
fano(1).FanoSave25omit =  smooth(FanoSave25',SmoothBin)';
fano(1).FanoSaveAll= smooth(FanoSaveAllinc',SmoothBin)';
fano(1).FanoSave75=  smooth(FanoSave75inc',SmoothBin)';
fano(1).FanoSave50=  smooth(FanoSave50inc',SmoothBin)';
fano(1).FanoSave25=  smooth(FanoSave25inc',SmoothBin)';
fano(1).FanoSave100=  smooth(FanoSave100',SmoothBin)';

%Raw data
fano(1).raw_FanoSaveAllomit = FanoSaveAll';
fano(1).raw_FanoSave0= FanoSave0';
fano(1).raw_FanoSave75omit = FanoSave75';
fano(1).raw_FanoSave50omit = FanoSave50';
fano(1).raw_FanoSave25omit = FanoSave25';
fano(1).raw_FanoSaveAll= FanoSaveAllinc';
fano(1).raw_FanoSave75= FanoSave75inc';
fano(1).raw_FanoSave50= FanoSave50inc';
fano(1).raw_FanoSave25= FanoSave25inc';

end


