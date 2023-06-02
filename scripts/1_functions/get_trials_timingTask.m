function trials = get_trials_timingTask(PDS)

% This function is derived from the Timing2575Group.m script written by
% Kaining Zhang for Zhang et al., 2019

% Initialise relevant variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ????  <<< UNKNOWN: task relevant measures
durationsuntilreward=PDS(1).timeoutcome-PDS(1).timetargeton;
durationsuntilreward=round(durationsuntilreward*10)./10;

%% Get relevant trial indices %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % General: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
completedtrial=find(durationsuntilreward>0); % Completed trials

try
    deliv=intersect(find(PDS.timeoutcome>0),find( PDS.rewardDuration>0)); % Reward delivered
    ndeliv=intersect(find(PDS.timeoutcome>0),find( PDS.rewardDuration == 0)); % Reward not delivered
catch
   deliv=intersect(find(PDS.timeoutcome>0),find( PDS.deliveredornot>0)); % Reward delivered
    ndeliv=intersect(find(PDS.timeoutcome>0),find( PDS.deliveredornot == 0)); % Reward not delivered 
end

% % Split by probability: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Trials: UNKNOWN <<<?
trials6201=(find(PDS(1).fractals==6201));
trials.fractal6201 = intersect(trials6201,completedtrial);
trials.fractal6201_d = intersect(trials6201,deliv);
trials.fractal6201_nd = intersect(trials6201,ndeliv);

% Trials: p(long) = 50%; p(short) = 50%
trials6102=intersect(find(PDS(1).fractals==6102),completedtrial);
trials.p50s_50l_short = intersect(find(durationsuntilreward==1.5),trials6102);
trials.p50s_50l_long = intersect(find(durationsuntilreward==4.5),trials6102);

% Trials: p(long) = 75%; p(short) = 25%
trials6101=intersect(find(PDS(1).fractals==6101),completedtrial);
trials.p25s_75l_short = intersect(find(durationsuntilreward==1.5),trials6101);
trials.p25s_75l_long = intersect(find(durationsuntilreward==4.5),trials6101);

% Trials: p(long) = 25%; p(short) = 75%
trials6103=intersect(find(PDS(1).fractals==6103),completedtrial);
trials.p75s_25l_short = intersect(find(durationsuntilreward==1.5),trials6103);
trials.p75s_25l_long = intersect(find(durationsuntilreward==4.5),trials6103);

% Trials: p(long) = 0%; p(short) = 100%
trials.p100s_0l_short = intersect(find(PDS(1).fractals==6104),completedtrial);


% Trials: UNKNOWN <<<?
trials6105 = intersect(find(PDS(1).fractals==6105),completedtrial);
trials.fractal6105_1500 = intersect(find(durationsuntilreward==1.5),trials6105);
trials.fractal6105_2500 = intersect(find(durationsuntilreward==2.5),trials6105);
trials.fractal6105_3500 = intersect(find(durationsuntilreward==3.5),trials6105);
trials.fractal6105_4500 = intersect(find(durationsuntilreward==4.5),trials6105);


trials.uncertain = [trials.p50s_50l_short,trials.p50s_50l_long,...
    trials.p75s_25l_short,trials.p75s_25l_long,...
    trials.p50s_50l_short,trials.p50s_50l_long];
trials.certain = [trials.p100s_0l_short];

trials.prob0 = 0;
trials.prob50 = [trials.p50s_50l_short,trials.p50s_50l_long];
trials.prob100 = trials.p100s_0l_short;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INHERITED FROM get_trials CODE.
% 
% % % Reward delivery (0:25:100% probability of reward)
% trials.prob100=intersect(completedtrial,find(PDS.fractals==9800));
% trials.prob75=intersect(completedtrial,find(PDS.fractals==9801));
% trials.prob50=intersect(completedtrial,find(PDS.fractals==9802));
% trials.prob25=intersect(completedtrial,find(PDS.fractals==9803));
% trials.prob0=intersect(completedtrial,find(PDS.fractals==9804));
% 
% % % Reward amount (0:25:100% reward amount)
% trials.a100=intersect(completedtrial,find(PDS.fractals==9805));
% trials.a75=intersect(completedtrial,find(PDS.fractals==9806));
% trials.a50=intersect(completedtrial,find(PDS.fractals==9807));
% trials.a25=intersect(completedtrial,find(PDS.fractals==9808));
% trials.a0=intersect(completedtrial,find(PDS.fractals==9809));
% 
% % % Probability x outcome
% trials.prob75d=intersect(trials.prob75,deliv); % 75% probability, delivered
% trials.prob75nd=intersect(trials.prob75,ndeliv); % 75% probability, not-delivered
% trials.prob50d=intersect(trials.prob50,deliv); % 50% probability, delivered
% trials.prob50nd=intersect(trials.prob50,ndeliv); % 50% probability, not-delivered
% trials.prob25d=intersect(trials.prob25,deliv); % 25% probability, delivered
% trials.prob25nd=intersect(trials.prob25,ndeliv); % 25% probability, not-delivered
% 
% 
% trials.probAll = [trials.prob0, trials.prob25, trials.prob50, trials.prob75, trials.prob100];
% trials.aAll = [trials.a0, trials.a25, trials.a50, trials.a75, trials.a100];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end
