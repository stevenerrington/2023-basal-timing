function trials = get_trials_2500CS(PDS)

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
trials.prob100=intersect(completedtrial,find(PDS.fractals==6300 | PDS.fractals==6306));
trials.prob50=intersect(completedtrial,find(PDS.fractals==6301 | PDS.fractals==6307));
trials.prob0=intersect(completedtrial,find(PDS.fractals==6302 | PDS.fractals==6308));

% % Reward amount (0:25:100% reward amount)
trials.a100=intersect(completedtrial,find(PDS.fractals==6303 | PDS.fractals==6309));
trials.a50=intersect(completedtrial,find(PDS.fractals==6304 | PDS.fractals==6310));
trials.a0=intersect(completedtrial,find(PDS.fractals==6305 | PDS.fractals==6311));

% % Probability x outcome
trials.prob50d=intersect(trials.prob50,deliv); % 50% probability, delivered
trials.prob50nd=intersect(trials.prob50,ndeliv); % 50% probability, not-delivered


trials.probAll = [trials.prob0, trials.prob50, trials.prob100];
trials.aAll = [trials.a0, trials.a50, trials.a100];

trials.uncert_delivered = [trials.prob50d];
trials.uncert_omit = [trials.prob50nd];

trials.uncertain = [trials.prob50];
trials.certain = [trials.prob0, trials.prob100];
end
