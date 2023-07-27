%% Basal forebrain project

% Scripts are written as functions in order to reduce clutter in the
% variable workspace

%% Completed
% Figure 1 ------------------------------------------------------------
% Plot BF activity in reward uncertainty task (0%, 25%, 50%, 75%, 100%)
% > i   | Example SDF, example fano, population SDF, population fano
% > ii  | Example uncertainty curve, population uncertainty curve
% > iii | Fano across uncertainty condtions
bf_cs_main(bf_data_CS, bf_datasheet_CS, params);

% Plot Striatum activity in reward uncertainty task (0%, 25%, 50%, 75%, 100%)
% > i   | Example SDF, example fano, population SDF, population fano
% > ii  | Example uncertainty curve, population uncertainty curve
% > iii | Fano across uncertainty condtions
striatum_cs_main(striatum_data_CS, striatum_datasheet_CS, params);

% Plot activity of BF neurons post-outcome in uncertain conditions
% > i   | SDF of activity in delivered/omitted conditions
% > ii  | Summary mean activity across conditions
bfstri_cs_outcome(bf_data_CS,bf_datasheet_CS,striatum_data_CS,striatum_datasheet_CS,params)

% Plot precision of BF and striatum neurons post-outcome in uncertain
% conditions
% > i   | Show average peak time, peak time variability, and offset slope
% > ii  | Show heatmap of activity and peak detection for example neurons
bfstri_cs_precision(bf_data_CS, bf_datasheet_CS,...
    striatum_data_CS,striatum_datasheet_CS, params);

% Figure 2 ------------------------------------------------------------
% Plot BF, Striatum, and gaze activity in reward uncertainty task (0%, 25%, 50%, 75%, 100%)
bfstri_gaze_fr_tuning(bf_data_CS, bf_datasheet_CS,...
    striatum_data_CS, striatum_datasheet_CS, params)

% Plot BF and Striatum activity split by high/low gaze percentage at CS in the 
% reward uncertainty task (0%, 25%, 50%, 75%, 100%)
bfstri_cs_motor(bf_data_CS, bf_datasheet_CS,...
    striatum_data_CS, striatum_datasheet_CS, params)

% Plot BF & Striatum activity in trace task (trace/no trace; certain/uncertain)
% > i   | Example SDF, example fano, population SDF, population fano
% > ii  | Average firing rates and fano factors across conditions
bfstri_trace_main (bf_data_traceExp, striatum_data_traceExp, params);

% Plot outcome in the trace task, based on cued/no cued outcome
bfstri_trace_cue(bf_data_traceExp, bf_datasheet_traceExp, params);

% Plot appetitive and aversive data
% > i   | Example SDF, example fano, population SDF, population fano
% > ii  | Slope, average uncertainty FR, average fano
% > iii | Fano across epochs 
bf_appaver_main(bf_data_punish, params);


% Figure 3 ------------------------------------------------------------
% Plot 1500 ms and 2500 ms CS dataset ramping
bf_cstime_main(bf_data_CS, bf_datasheet_CS, params)

% Plot timing task data
dev_timingUncertainty


%% In development
% Explore principle components across the bf and striatum during ramping
% > i  | Plot PCA in space.
% > ii | Plot P(var) explained
% ! NOTE: This will need to be manipulated manually to see each dataset
params.pca.timewin = [0 0]; params.pca.step = 1;
pca_data_out = bfstri_pca_space(bf_data_CS,bf_datasheet_CS,striatum_data_CS,params);
plot_pca_analysis_fig(pca_data_out);

%(!) REPEAT FOR BF AND STRIATUM - MAKE ONE FIGURE
dev_motor_ramping_relationship_CStask; % Plot relationship between gaze and fr

% Plot dimensionality plot from PCA, for BF and striatum data
bfstri_pca_dimension(bf_data_CS,bf_datasheet_CS,striatum_data_CS);



% Plot outcome in the trace task, based on delivered/omitted outcome
bfstri_trace_outcome(bf_data_traceExp, striatum_data_traceExp, params);

% Plot gaze and fr activity across uncertainty conditions
% > i   | Show curves for each condition (p(gaze)
% > ii  | Plot first parameters of curve fit (denotes "curviness")
bfstri_cs_tuning(bf_data_CS,bf_datasheet_CS,...
    striatum_data_CS, striatum_datasheet_CS, params);
% ! CHECK CALL TO dev_eyePos_CSall (line 38)

%% Workspace %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot/exploration code
loop_plot_1500_2500 % Loop through neurons in bf (1500, 2500) data and plot individual SDF.
dev_20230605_VPbasic % Basic plot some VP neurons in CS task I found on the server (for high FR comparisons).

% Eye gaze
dev_eyePos % Plot p(gaze) at CS across datasets (1500, 2500).
dev_eyePos_CSall % Plot p(gaze) at CS across datasets (1500, 2500) - collapsed.
dev_eyePos_punish % Plot p(gaze) in reward/punish.
dev_eyePos_trace % Plot p(gaze) in trace task.
dev_individualtrl_ramp_example % Plot example neuron with fitted linear slope.
dev_eye_pupilCS_rough  % Consider blinks through time x prob (outcome)

% Motor analyses
dev_motor_pSaccXfr % Extract the p(gaze) across time and corr with fr (incomplete)
dev_saccade_extraction  % Extract saccade raster (legacy).
dev_saccade_extraction2 % Extract saccade raster (current) and correlate motor activity against spikes.
dev_motor_ramping_relationship % Plot relationship between gaze and fr
dev_motor_bf_striatum % Plot relationship between gaze and fr between bf and striatum
dev_compare_CStuningcurves % Plot curves across all data to compare gaze and neural activity

% Method testing
mmff_test % Developing the mean-matched fano factor analysis.
dev_isiAnalysis % Plot ISI distribution and coefficient of variation.

% Legacy
test_20230501         % Plot certain v uncertain activity (raster, sdf; pop and example) [Layout 1].
test_20230501_linear2 % Plot certain v uncertain activity (raster, sdf; pop and example) [Layout 2].
dev_20230505          % Plot main ramping activity and bar plots with precision of ramping (legacy).
dev_outcome_punish % Plot outcome for delivered omitted for punish and reward.
bf_striatum_outcome % Plot pre-and-post- outcome fano factor for basal ganglia data.

% Explore principle components across the bf and striatum during ramping
% > i  | Plot PCA [1,2,3] individually, and in space.
% > ii | Plot P(var) explained
% ! NOTE: This will need to be manipulated manually to see each dataset
bfstri_pca_explore(bf_data_CS,bf_datasheet_CS,striatum_data_CS);
