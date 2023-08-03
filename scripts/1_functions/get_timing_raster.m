function Rasters = get_timing_raster(PDS, trials, params)

% This function is derived from the Timing2575Group.m script written by
% Kaining Zhang for Zhang et al., 2019

% Initialise relevant variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ????  <<< UNKNOWN: task relevant measures
n_trls = length(PDS.timetargeton);
params.raster.cleanFlag = 1;
%% Get relevant trial indices %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % General:
try
    deliv=intersect(find(PDS.timeoutcome>0),find( PDS.rewardduration>0)); % Reward delivered
    ndeliv=intersect(find(PDS.timeoutcome>0),find( PDS.rewardduration==0)); % Reward not delivered
catch
    deliv=intersect(find(PDS.timeoutcome>0),find( PDS.rewardDuration>0)); % Reward delivered
    ndeliv=intersect(find(PDS.timeoutcome>0),find( PDS.rewardDuration==0)); % Reward not delivered
end

%% Get event-aligned rasters
% Initialise relevant arrays
Rasters=[];

% Set alignment parameters
event_zero=6001;

% % ///////////////////////////////////////////// %
for trl_i = 1:n_trls
    % Find time of spikes relevant to cue onset
    spk = PDS(1).sptimes{trl_i}(PDS.spikes{trl_i} == 65535)-PDS(1).timetargeton(trl_i);
    % Change timing to ms, rather than sec
    spk = (spk*1000)+event_zero-1;
    % Make a spike time an integer
    spk = fix(spk);
    
    % Clean any spike times that occur too late
    spk = spk(find(spk<event_zero*2));
    
    % Convert timings into a 0/1 logical raster array
    temp(1:event_zero*2) = 0;
    temp(spk) = 1;
    Rasters=[Rasters; temp];
    
    % Clear arrays for next loop
    clear temp spk x
end


%% Generate convolved spike density functions
% Convolve the rasters with a Gaussian
SDFFREE = plot_mean_psth({Rasters},params.sdf.gauss_ms,1,size(Rasters,2),1); %make spike density functions for displaying and average across neurons for displaying
% Cut the SDF to the relevant epoch of interest
SDFFREE = SDFFREE(:,event_zero+params.sdf.window(1):event_zero+params.sdf.window(2));

%% Clean rasters (reward artifact)
if params.raster.cleanFlag == 1
    % % Define periods of interest
    % % Define periods of interest
    %   For uncertain trials (25, 50, 75% probability)
    time_win_contam_a = [event_zero+1500-100 event_zero+1500+100];
    time_win_clean_a = [event_zero+1500-100 event_zero+1500+100];
    
    %   For uncertain trials (25, 50, 75% probability)
    time_win_contam_b = [event_zero+1500-100 event_zero+1500+100];
    time_win_clean_b = [event_zero+1500-100 event_zero+1500+100];
    
    % % Clean trials (reward artifact removal)
    Rasters = clean_spk_artifact(Rasters,trials.p75s_25l_short,trials.p75s_25l_long,time_win_contam_a,time_win_clean_a);
    Rasters = clean_spk_artifact(Rasters,trials.p50s_50l_short,trials.p50s_50l_long,time_win_contam_a,time_win_clean_a);
    Rasters = clean_spk_artifact(Rasters,trials.p25s_75l_short,trials.p25s_75l_long,time_win_contam_a,time_win_clean_a);
    Rasters = clean_spk_artifact(Rasters,trials.prob100,trials.prob100,time_win_contam_b,time_win_clean_b);
    
end
% % Cut raster to period of interest
Rasters = Rasters(:,event_zero-5000:event_zero+5000);


%% Generate refined spike density function

% <<<<< GOT TO HERE - UNCERTAIN WHY THERE ARE TWO SEPARATE APPROACHES FOR
% GENERATING SDF? (i.e. Smooth_Histogram & plot_mean_psth).
% Plotting it, it looks like the smooth histogram is a little noiser.
% 11:11AM: Smooth Histogram in line 150 uses a EPSP filter. The alternative
% plots a Gaussian convolved filter.

Rasterscs=Rasters;

SDFcs_n=[];
for R=1:size(Rasterscs,1)
    sdf=Smooth_Histogram(Rasterscs(R,:),3);
    SDFcs_n=[SDFcs_n; sdf;];
end
SDFcs_nC= SDFcs_n;

SDFcs_n=plot_mean_psth({Rasterscs},params.sdf.gauss_ms,1,size(Rasterscs,2),1); %make spike density functions for displaying and average across neurons for displaying


%% In progress & cuttings:
%%%%%%%%%%%%% <<<<<<<<<<<  BREAK
%PostRasterAnalysis;

% Cut here: line 211 to 523 from the Timing2575Group script.
%   This looks like it was some sort of preliminary analyses
% Cut here: line 526 to 926 from the Timing2575Group script.
%   This looks like it may be figure related code, and scripts to output
%   data in a structure.


% figure;
% plot(nanmean(SDFcs_nC)); hold on
% plot(nanmean(SDFcs_n))
%


end
