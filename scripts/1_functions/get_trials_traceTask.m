function trials = get_trials_traceTask(PDS)

%% Get relevant trial indices %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % General: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

try
    PDS.timesoffreeoutcomes_first(find(PDS.timesoffreeoutcomes_first>10))=NaN; %very few trials have a timing bug. just remove them
end

trials.free1_=intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==1)); %reward/juice
trials.free2_=intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==2)); %aifpuff
trials.free34_=intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==34)); %flash.sound combination

% freeOutcomeTimingSeperation = PDS.timesoffreeoutcomes_second - PDS.timesoffreeoutcomes_first;
% averageOutcomeSeperation = fix(1000* mean(freeOutcomeTimingSeperation(freeOutcomeTimingSeperation>0)));

durationsuntilreward=PDS(1).timeoutcome-PDS(1).timetargeton;
durationsuntilreward=round(durationsuntilreward*10)./10;
completedtrial=find(durationsuntilreward>0);
if isfield(PDS, 'deliveredornot')
    deliv=find(PDS(1).deliveredornot==1);
    ndeliv=find(PDS(1).deliveredornot==0);
else
    if isfield(PDS,'rewardDuration')
        deliv=find(PDS(1).rewardDuration>0);
        ndeliv=find(PDS(1).rewardDuration==0);
    else
        deliv=find(PDS(1).rewardduration>0);
        ndeliv=find(PDS(1).rewardduration==0  );
    end
    
end

%% Trials

trials.timingcue_certain=intersect(find(PDS(1).fractals==6253),completedtrial);
trials.timingcue_uncertain=intersect(find(PDS(1).fractals==6254),completedtrial);

trials.notimingcue_certain=intersect(find(PDS(1).fractals==6259),completedtrial);
trials.notimingcue_uncertain=intersect(find(PDS(1).fractals==6260),completedtrial);

trials.notrace_certain=intersect(find(PDS(1).fractals==6300),completedtrial);
trials.notrace_uncertain=intersect(find(PDS(1).fractals==6301),completedtrial);

trials.timingcue_uncertain_d=intersect(trials.timingcue_uncertain,deliv);
trials.timingcue_uncertain_nd=intersect(trials.timingcue_uncertain,ndeliv);

trials.notimingcue_uncertain_d=intersect(trials.notimingcue_uncertain,deliv);
trials.notimingcue_uncertain_nd=intersect(trials.notimingcue_uncertain,ndeliv);

trials.notrace_uncertain_d=intersect(trials.timingcue_uncertain_nd,deliv);
trials.notrace_uncertain_nd=intersect(trials.timingcue_uncertain_nd,ndeliv);


trials.trace_uncertain_d = sort([trials.notimingcue_uncertain_d, trials.timingcue_uncertain_d]);
trials.trace_uncertain_nd = sort([trials.notimingcue_uncertain_nd, trials.timingcue_uncertain_nd]);

% From Ilya:
% trace
%
%timing cue
% 6253   certain
%  6254   uncertain
%no timing cue
%  6259   certain
%  6260   uncertain
%
%  no tace
%
%  6300   certain
%  6301   uncertain

% Other fractals:

trials.fractal6200 = intersect(find(PDS(1).fractals==6200),completedtrial);
trials.fractal6201 = intersect(find(PDS(1).fractals==6201),completedtrial);
trials.fractal6202 = intersect(find(PDS(1).fractals==6202),completedtrial);
trials.fractal6203 = intersect(find(PDS(1).fractals==6203),completedtrial);
trials.fractal6204 = intersect(find(PDS(1).fractals==6204),completedtrial);
trials.fractal6205 = intersect(find(PDS(1).fractals==6205),completedtrial);
trials.fractal6206 = intersect(find(PDS(1).fractals==6206),completedtrial);
trials.fractal6207 = intersect(find(PDS(1).fractals==6207),completedtrial);
trials.fractal6208 = intersect(find(PDS(1).fractals==6208),completedtrial);
trials.fractal6209 = intersect(find(PDS(1).fractals==6209),completedtrial);
trials.fractal6210 = intersect(find(PDS(1).fractals==6210),completedtrial);
trials.fractal6211 = intersect(find(PDS(1).fractals==6211),completedtrial);
trials.fractal6212 = intersect(find(PDS(1).fractals==6212),completedtrial);
trials.fractal6213 = intersect(find(PDS(1).fractals==6213),completedtrial);
trials.fractal6214 = intersect(find(PDS(1).fractals==6214),completedtrial);


trials.fullItiTrials_  = [];
for x=1:length(PDS.fractals)
    if ~isempty(PDS.sptimes{x})
        if PDS.sptimes{x}(end) - PDS.timesoffreeoutcomes_first(x)>2.5
            trials.fullItiTrials_ = [trials.fullItiTrials_ x];
        end
    end
end

trials.uncertain=[trials.timingcue_uncertain, trials.notimingcue_uncertain];
trials.certain=[trials.timingcue_certain, trials.notimingcue_certain];



end
