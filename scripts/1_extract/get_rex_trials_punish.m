function trials = get_rex_trials_punish(REX)

d = REX; 

% ana_fractal_set=3; %1 is set 1 only; 2 is set 2 only; %3 is all sets
% threshfix=4; %window size

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%event codes used in C NIH system (REX); also find trials
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lefttrials=5502; righttrials=4501; centertrials=3500;

prob100_punish=2091; prob75_punish=2016; prob50_punish=2094; prob25_punish=2012; prob0_punish=2098;
prob75norew=2017; prob50norew=2015; prob25norew=2013;
prob100_reward=2011; prob75_reward=2022; prob50_reward=2014; prob25_reward=2024; prob0_reward=2018;

all_fractal_codes = [prob100_punish, prob75_punish, prob50_punish, prob25_punish, prob0_punish,...
    prob75norew, prob50norew, prob25norew, prob100_reward, prob75_reward, prob50_reward, prob25_reward, prob0_reward];

% %
% saveshit=[];
% for x=1:length(REX)
%     temp=[REX(x).Events.Code];
% saveshit=[saveshit; temp(3) ];
% end
% unique(saveshit);

TRIALSTART  =   1001;
CUECD	    =	1050;
REWCD=			1030;
AIRCD=			1990;
TARGONCD	=	1100;
TARGOFFCD	=	1101;
REWOFFCD=		1037;
EYEIN = 5555;
EYEATSTIM = 6666;

punish = []; endtrial = []; fractal = [];

for trl = 1:size(REX,2)
    eventcodes = [];
    eventcodes = vertcat(REX(trl).Events.Code);
    
    
    punish(trl) = ~isempty(find(eventcodes == AIRCD));
    reward(trl) = ~isempty(find(eventcodes == REWCD));
    endtrial(trl) = ~isempty(find(eventcodes == TARGOFFCD));
    
    if ~isempty(eventcodes(find(ismember(eventcodes,all_fractal_codes))))
        fractal(trl) = eventcodes(find(ismember(eventcodes,all_fractal_codes)));
    else
        fractal(trl) = NaN;
    end
    
    
end


%% Get relevant trial indices %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % General:
completedtrial = []; 
completedtrial=find(endtrial>0); % Completed trials
deliv_punish=intersect(find(endtrial>0),find( punish >0)); % punish delivered
ndeliv_punish=intersect(find(endtrial>0),find( punish==0)); % punish not delivered

deliv_reward=intersect(find(endtrial>0),find( reward >0)); % Reward delivered
ndeliv_reward=intersect(find(endtrial>0),find( reward==0)); % Reward not delivered

% % Punish trials
trials.prob100_punish=intersect(completedtrial,find(fractal==prob100_punish));
trials.prob50_punish=intersect(completedtrial,find(fractal==prob50_punish));
trials.prob0_punish=intersect(completedtrial,find(fractal==prob0_punish));

% % Reward amount (0:25:100% reward amount)
trials.prob100_reward=intersect(completedtrial,find(fractal==prob100_reward));
trials.prob50_reward=intersect(completedtrial,find(fractal==prob50_reward));
trials.prob0_reward=intersect(completedtrial,find(fractal==prob0_reward));

% % Probability x outcome
trials.prob50_punish_d=intersect(trials.prob50_punish,deliv_punish); % 50% probability, delivered (punish)
trials.prob50_punish_nd=intersect(trials.prob50_punish,ndeliv_punish); % 50% probability, not-delivered  (punish)

trials.prob50_reward_d=intersect(trials.prob50_reward,deliv_reward); % 50% probability, delivered  (reward)
trials.prob50_reward_nd=intersect(trials.prob50_reward,ndeliv_reward); % 50% probability, not-delivered (reward)

trials.probAll_punish = [trials.prob0_punish,trials.prob50_punish,trials.prob100_punish];
trials.probAll_reward = [trials.prob0_reward,trials.prob50_reward,trials.prob100_reward];
trials.probAll_all = [trials.probAll_punish,trials.probAll_reward];

%%
TrialEventTimes = dev_extractTrialEventTimes(REX);
[short_iti_trls, long_iti_trls] = dev_findITItrials(TrialEventTimes);

trials.iti_short = short_iti_trls';
trials.iti_long = long_iti_trls';


end