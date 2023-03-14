function trials = get_trials(PDS)

% This function is derived from the Timing2575Group.m script written by
% Kaining Zhang for Zhang et al., 2019

% Initialise relevant variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ????  <<< UNKNOWN: task relevant measures
durationsuntilreward=PDS(1).timeoutcome-PDS(1).timetargeton;
durationsuntilreward=round(durationsuntilreward*10)./10;

%% Get relevant trial indices %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % General:
completedtrial=find(durationsuntilreward>0); % Completed trials
deliv=intersect(find(PDS.timeoutcome>0),find( PDS.rewardduration>0)); % Reward delivered
ndeliv=intersect(find(PDS.timeoutcome>0),find( PDS.rewardduration==0)); % Reward not delivered

% % Reward delivery (0:25:100% probability of reward)
trials.prob100=intersect(completedtrial,find(PDS.fractals==9800));
trials.prob75=intersect(completedtrial,find(PDS.fractals==9801));
trials.prob50=intersect(completedtrial,find(PDS.fractals==9802));
trials.prob25=intersect(completedtrial,find(PDS.fractals==9803));
trials.prob0=intersect(completedtrial,find(PDS.fractals==9804));

% % Reward amount (0:25:100% reward amount)
trials.a100=intersect(completedtrial,find(PDS.fractals==9805));
trials.a75=intersect(completedtrial,find(PDS.fractals==9806));
trials.a50=intersect(completedtrial,find(PDS.fractals==9807));
trials.a25=intersect(completedtrial,find(PDS.fractals==9808));
trials.a0=intersect(completedtrial,find(PDS.fractals==9809));

% % Probability x outcome
trials.prob75d=intersect(trials.prob75,deliv); % 75% probability, delivered
trials.prob75nd=intersect(trials.prob75,ndeliv); % 75% probability, not-delivered
trials.prob50d=intersect(trials.prob50,deliv); % 50% probability, delivered
trials.prob50nd=intersect(trials.prob50,ndeliv); % 50% probability, not-delivered
trials.prob25d=intersect(trials.prob25,deliv); % 25% probability, delivered
trials.prob25nd=intersect(trials.prob25,ndeliv); % 25% probability, not-delivered


trials.probAll = [trials.prob0, trials.prob25, trials.prob50, trials.prob75, trials.prob100];
trials.aAll = [trials.a0, trials.a25, trials.a50, trials.a75, trials.a100];

trials.uncert_delivered = [trials.prob25d, trials.prob50d, trials.prob75d];
trials.uncert_omit = [trials.prob25nd, trials.prob50nd, trials.prob75nd];

trials.uncertain = [trials.prob25, trials.prob50, trials.prob75];
trials.certain = [trials.prob0, trials.prob100];
end
