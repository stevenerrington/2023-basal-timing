function trials = get_trials_traceTask(PDS)

%% Get relevant trial indices %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % General: %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PDS.timesoffreeoutcomes_first(find(PDS.timesoffreeoutcomes_first>10))=NaN; %very few trials have a timing bug. just remove them
free1_=intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==1)); %reward/juice
free2_=intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==2)); %aifpuff
free34_=intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==34)); %flash.sound combination

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
trials6253=intersect(find(PDS(1).fractals==6253),completedtrial);
trials6254=intersect(find(PDS(1).fractals==6254),completedtrial);
trials6259=intersect(find(PDS(1).fractals==6259),completedtrial);
trials6260=intersect(find(PDS(1).fractals==6260),completedtrial);
trials6300=intersect(find(PDS(1).fractals==6300),completedtrial);
trials6301=intersect(find(PDS(1).fractals==6301),completedtrial);
trials6254d=intersect(trials6254,deliv);
trials6260d=intersect(trials6260,deliv);
trials6301d=intersect(trials6301,deliv);
trials6254nd=intersect(trials6254,ndeliv);
trials6260nd=intersect(trials6260,ndeliv);
trials6301nd=intersect(trials6301,ndeliv);

trials6200 = intersect(find(PDS(1).fractals==6200),completedtrial);
trials6201 = intersect(find(PDS(1).fractals==6201),completedtrial);
trials6202 = intersect(find(PDS(1).fractals==6202),completedtrial);
trials6203 = intersect(find(PDS(1).fractals==6203),completedtrial);
trials6204 = intersect(find(PDS(1).fractals==6204),completedtrial);
trials6205 = intersect(find(PDS(1).fractals==6205),completedtrial);
trials6206 = intersect(find(PDS(1).fractals==6206),completedtrial);
trials6207 = intersect(find(PDS(1).fractals==6207),completedtrial);
trials6208 = intersect(find(PDS(1).fractals==6208),completedtrial);
trials6209 = intersect(find(PDS(1).fractals==6209),completedtrial);
trials6210 = intersect(find(PDS(1).fractals==6210),completedtrial);
trials6211 = intersect(find(PDS(1).fractals==6211),completedtrial);
trials6212 = intersect(find(PDS(1).fractals==6212),completedtrial);
trials6213 = intersect(find(PDS(1).fractals==6213),completedtrial);
trials6214 = intersect(find(PDS(1).fractals==6214),completedtrial);


end
