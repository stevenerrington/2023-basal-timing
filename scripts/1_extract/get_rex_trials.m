function trials = get_rex_trials(REX)

d = REX; 

% ana_fractal_set=3; %1 is set 1 only; 2 is set 2 only; %3 is all sets
% threshfix=4; %window size

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%event codes used in C NIH system (REX); also find trials
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lefttrials=5502; righttrials=4501; centertrials=3500;

prob100=2011; prob75rew=2016; prob50rew=2014; prob25rew=2012; prob0=2018;
prob75norew=2017; prob50norew=2015; prob25norew=2013;
amount100=2021; amount75=2022; amount50=2023; amount25=2024; amount0=2025;

all_fractal_codes = [prob100, prob75rew, prob50rew, prob25rew, prob0,...
    prob75norew, prob50norew, prob25norew, amount100, amount75, amount50, amount25, amount0];

TRIALSTART=1001;
CUECD	=		1050;
REWCD=			1030;
AIRCD=			1990;
TARGONCD	=	1100;
TARGOFFCD	=	1101;
REWOFFCD=		1037;
EYEIN = 5555;
EYEATSTIM = 6666;

rwd = []; endtrial = []; fractal = [];

for trl = 1:size(REX,2)
    eventcodes = [];
    eventcodes = vertcat(REX(trl).Events.Code);
    
    
    rwd(trl) = ~isempty(find(eventcodes == REWCD));
    endtrial(trl) = ~isempty(find(eventcodes == TARGOFFCD));
    
    
    fractal(trl) = eventcodes(find(ismember(eventcodes,all_fractal_codes)));

end


%% Get relevant trial indices %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % General:
completedtrial = []; 
completedtrial=find(endtrial>0); % Completed trials
deliv=intersect(find(endtrial>0),find( rwd >0)); % Reward delivered
ndeliv=intersect(find(endtrial>0),find( rwd==0)); % Reward not delivered

% % Reward delivery (0:25:100% probability of reward)
trials.prob100=intersect(completedtrial,find(fractal==prob100));
trials.prob75=intersect(completedtrial,find(fractal==prob75norew | fractal==prob75rew));
trials.prob50=intersect(completedtrial,find(fractal==prob50norew | fractal==prob50rew));
trials.prob25=intersect(completedtrial,find(fractal==prob25norew | fractal==prob25rew));
trials.prob0=intersect(completedtrial,find(fractal==prob0));

% % Reward amount (0:25:100% reward amount)
trials.a100=intersect(completedtrial,find(fractal==amount100));
trials.a75=intersect(completedtrial,find(fractal==amount75));
trials.a50=intersect(completedtrial,find(fractal==amount50));
trials.a25=intersect(completedtrial,find(fractal==amount25));
trials.a0=intersect(completedtrial,find(fractal==amount0));

% % Probability x outcome
trials.prob75d=intersect(trials.prob75,deliv); % 75% probability, delivered
trials.prob75nd=intersect(trials.prob75,ndeliv); % 75% probability, not-delivered
trials.prob50d=intersect(trials.prob50,deliv); % 50% probability, delivered
trials.prob50nd=intersect(trials.prob50,ndeliv); % 50% probability, not-delivered
trials.prob25d=intersect(trials.prob25,deliv); % 25% probability, delivered
trials.prob25nd=intersect(trials.prob25,ndeliv); % 25% probability, not-delivered

trials.probAll = [trials.prob0, trials.prob25, trials.prob50, trials.prob75, trials.prob100];
trials.aAll = [trials.a0, trials.a25, trials.a50, trials.a75, trials.a100];

end