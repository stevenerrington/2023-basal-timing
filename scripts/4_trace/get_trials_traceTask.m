function trials = get_trials_traceTask(PDS)

%% Get relevant trial indices %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % General: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PDS.timesoffreeoutcomes_first(find(PDS.timesoffreeoutcomes_first>10))=NaN; %very few trials have a timing bug. just remove them
trials.free1_=intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==1)); %reward/juice
trials.free2_=intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==2)); %aifpuff
trials.free34_=intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==34)); %flash.sound combination

 freeOutcomeTimingSeperation =PDS.timesoffreeoutcomes_second - PDS.timesoffreeoutcomes_first;
    averageOutcomeSeperation = fix(1000* mean(freeOutcomeTimingSeperation(freeOutcomeTimingSeperation>0)));
    
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
trials.fractal6253=intersect(find(PDS(1).fractals==6253),completedtrial);
trials.fractal6254=intersect(find(PDS(1).fractals==6254),completedtrial);
trials.fractal6259=intersect(find(PDS(1).fractals==6259),completedtrial);
trials.fractal6260=intersect(find(PDS(1).fractals==6260),completedtrial);
trials.fractal6300=intersect(find(PDS(1).fractals==6300),completedtrial);
trials.fractal6301=intersect(find(PDS(1).fractals==6301),completedtrial);
trials.fractal6254d=intersect(trials.fractal6254,deliv);
trials.fractal6260d=intersect(trials.fractal6260,deliv);
trials.fractal6301d=intersect(trials.fractal6301,deliv);
trials.fractal6254nd=intersect(trials.fractal6254,ndeliv);
trials.fractal6260nd=intersect(trials.fractal6260,ndeliv);
trials.fractal6301nd=intersect(trials.fractal6301,ndeliv);

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
    if PDS.sptimes{x}(end) - PDS.timesoffreeoutcomes_first(x)>2.5
        trials.fullItiTrials_ = [trials.fullItiTrials_ x];
    end
end


    
trials.plot_test = intersect(trials.fullItiTrials_,trials.free1_);

end
