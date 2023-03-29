function Rasters = get_rex_raster(REX, trials, params)

% This function is derived from the Timing2575Group.m script written by
% Kaining Zhang for Zhang et al., 2019

% Initialise relevant variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ????  <<< UNKNOWN: task relevant measures

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%event codes used in C NIH system (REX); also find trials
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lefttrials=5502; righttrials=4501; centertrials=3500;

prob100=2011; prob75rew=2016; prob50rew=2014; prob25rew=2012; prob0=2018;
prob75norew=2017; prob50norew=2015; prob25norew=2013;
amount100=2021; amount75=2022; amount50=2023; amount25=2024; amount0=2025;

all_fractal_codes = [prob100, prob75rew, prob50rew, prob25rew, prob0,...
    prob75norew, prob50norew, prob25norew, amount100, amount75, amount50, amount25, amount0];

TRIALSTART=1001; CUECD = 1050; REWCD = 1030;
AIRCD = 1990; TARGONCD = 1100; TARGOFFCD = 1101;
REWOFFCD = 1037; EYEIN = 5555; EYEATSTIM = 6666;


%%
reward_on = nan(size(REX,2),1); trialstart_on = nan(size(REX,2),1); target_on = nan(size(REX,2),1);
rwd = nan(size(REX,2),1); endtrial = nan(size(REX,2),1); 

for trl_i = 1:size(REX,2)
    eventcodes = []; times = [];
    eventcodes = vertcat(REX(trl_i).Events.Code);
    times = vertcat(REX(trl_i).Events.Time);
    
    rwd(trl_i,1) = ~isempty(find(eventcodes == REWCD));
    endtrial(trl_i,1) = ~isempty(find(eventcodes == TARGOFFCD));
    
    if ~isempty(find(eventcodes == TARGOFFCD,1)) | ~isempty(find(eventcodes == TARGONCD,1))
    reward_on(trl_i,1) = double(times(find(eventcodes == TARGOFFCD,1)));
    trialstart_on(trl_i,1) = double(times(find(eventcodes == CUECD,1)));
    target_on(trl_i,1) = double(times(find(eventcodes == TARGONCD,1)));
    else
        continue
    end
end


% > SOME TIME SAME EVENT CODE IS SENT TWICE? JUST TAKING FIRST INSTANCES


%% Get relevant trial indices %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % General:
completedtrial = []; 
completedtrial=find(endtrial>0); % Completed trials
deliv=intersect(find(endtrial>0),find(rwd >0)); % Reward delivered
ndeliv=intersect(find(endtrial>0),find(rwd == 0)); % Reward not delivered

%% Get event-aligned rasters
% Initialise relevant arrays
Rasters=[]; 

% Set alignment parameters
event_zero=6001;

% % ///////////////////////////////////////////// %
for trl_i = 1:size(REX,2)
    % Find time of spikes relevant to cue onset
    
    spk_times = []; spk_times = REX(trl_i).Units.Times;
    spk = spk_times - target_on(trl_i,1) + event_zero;
    
    % Make a spike time an integer
    spk = double(fix(spk));
    
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
    %   For uncertain trials (25, 50, 75% probability)
    time_win_contam_a = [7500-45 7500+15];
    time_win_clean_a = [7500-45 7500+15];
    
    %   For uncertain trials (25, 50, 75% probability)
    time_win_contam_b = [7500-15 7500+15];
    time_win_clean_b = [7500-15-30 7500-15];
    
    % % Define trials (reward artifact removal)
%     cleanreward75n = intersect(trials.prob75,ndeliv); cleanreward75 = intersect(trials.prob75,deliv);
    cleanreward50n = intersect(trials.prob50_reward,ndeliv); cleanreward50 = intersect(trials.prob50_reward,deliv);
%     cleanreward25n = intersect(trials.prob25,ndeliv); cleanreward25 = intersect(trials.prob25,deliv);
    
    % % Clean trials (reward artifact removal)
    Rasters = clean_spk_artifact(Rasters,cleanreward75n,cleanreward75,time_win_contam_a,time_win_clean_a);
    Rasters = clean_spk_artifact(Rasters,cleanreward50n,cleanreward50,time_win_contam_a,time_win_clean_a);
    Rasters = clean_spk_artifact(Rasters,cleanreward25n,cleanreward25,time_win_contam_a,time_win_clean_a);
    Rasters = clean_spk_artifact(Rasters,trials.prob100,trials.prob100,time_win_contam_b,time_win_clean_b);
    Rasters = clean_spk_artifact(Rasters,trials.a100,trials.a100,time_win_contam_b,time_win_clean_b);
    Rasters = clean_spk_artifact(Rasters,trials.a75,trials.a75,time_win_contam_b,time_win_clean_b);
    Rasters = clean_spk_artifact(Rasters,trials.a50,trials.a50,time_win_contam_b,time_win_clean_b);
    Rasters = clean_spk_artifact(Rasters,trials.a25,trials.a25,time_win_contam_b,time_win_clean_b);
    
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
