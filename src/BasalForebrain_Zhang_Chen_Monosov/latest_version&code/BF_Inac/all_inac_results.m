clear all; close all; clc;
load('X:\MONKEYDATA\ZOMBIE_ongoing\BF_inac\Inactivation_2conditions\BFnovelinac_06_04_2018_postcombined.mat','PDS');
PostPDSgroup{1}= PDS;
load('X:\MONKEYDATA\ZOMBIE_ongoing\BF_inac\Inactivation_2conditions\BFnovelinac_13_04_2018_postcombined.mat','PDS');
PostPDSgroup{2} = PDS;
load('X:\MONKEYDATA\ZOMBIE_ongoing\BF_inac\Inactivation_2conditions\BFnovelinac_30_03_2018_postcombined.mat','PDS');
PostPDSgroup{3} = PDS;
load('X:\MONKEYDATA\ZOMBIE_ongoing\BF_inac\Inactivation_4conditions\BFnovelinac_04_05_2018_postcombined.mat','PDS');
PostPDSgroup{4} = PDS;
load('X:\MONKEYDATA\ZOMBIE_ongoing\BF_inac\Inactivation_4conditions\BFnovelinac_11_05_2018_postcombined.mat','PDS');
PostPDSgroup{5} = PDS;

load('X:\MONKEYDATA\ZOMBIE_ongoing\BF_inac\Inactivation_2conditions\BFnovelinac_06_04_2018_14_43.mat','PDS');
PrePDSgroup{1}= PDS;
load('X:\MONKEYDATA\ZOMBIE_ongoing\BF_inac\Inactivation_2conditions\BFnovelinac_13_04_2018_14_51.mat','PDS');
PrePDSgroup{2} = PDS;
load('X:\MONKEYDATA\ZOMBIE_ongoing\BF_inac\Inactivation_2conditions\BFnovelinac_30_03_2018_15_59.mat','PDS');
PrePDSgroup{3} = PDS;
load('X:\MONKEYDATA\ZOMBIE_ongoing\BF_inac\Inactivation_4conditions\BFnovelinac_04_05_2018_15_33.mat','PDS');
PrePDSgroup{4} = PDS;
load('X:\MONKEYDATA\ZOMBIE_ongoing\BF_inac\Inactivation_4conditions\BFnovelinac_11_05_2018_15_50.mat','PDS');
PrePDSgroup{5} = PDS;

ifchangefractal =0;
fig = figure();
ax_contraside = nsubplot(3,7,1:2,1:3);
ax_ipsiside = nsubplot(3,7,1:2,5:7);


AllPrereacttime.type1trial_l = [];
AllPrereacttime.type2trial_l = [];
AllPrereacttime.type1trial_r = [];
AllPrereacttime.type2trial_r = [];
AllPostreacttime.type1trial_l = [];
AllPostreacttime.type2trial_l = [];
AllPostreacttime.type1trial_r = [];
AllPostreacttime.type2trial_r = [];

for iii = 1:length(PrePDSgroup)
    clear Preinject Postinject
    PDS = PrePDSgroup{iii};
    if ifchangefractal==1
        try
            trialtype = sort(unique(PDS.TrialTypeSave));
            trialtype = trialtype(3:4);
        catch
            trialtype = [NaN NaN];
        end
    else
        trialtype = sort(unique(PDS.TrialTypeSave));
        trialtype = trialtype(1:2);
    end
    
    
    Preinject.type1trial = find(PDS.goodtrial & (PDS.TrialTypeSave == trialtype(1)))%& PDS.trialnumber>length(PDS.trialnumber)-80);
    Preinject.type2trial = find(PDS.goodtrial & (PDS.TrialTypeSave == trialtype(2)))%& PDS.trialnumber>length(PDS.trialnumber)-80);
    
    
    Preinject.type1trial_l = intersect(Preinject.type1trial,find(PDS.targAngle == 180));
    Preinject.type2trial_l = intersect(Preinject.type2trial,find(PDS.targAngle == 180));
    Preinject.type1trial_r = intersect(Preinject.type1trial,find(PDS.targAngle == 0));
    Preinject.type2trial_r = intersect(Preinject.type2trial,find(PDS.targAngle == 0));
    
    Preinject.reacttime = PDS.FEEDbacktime - PDS.timefpoff;
    
    
    PDS = PostPDSgroup{iii};
    if ifchangefractal==1
        try
            trialtype = sort(unique(PDS.TrialTypeSave));
            trialtype = trialtype(3:4);
        catch
            trialtype = [NaN NaN];
        end
    else
        trialtype = sort(unique(PDS.TrialTypeSave));
        trialtype = trialtype(1:2);
    end
    
    Postinject.type1trial = find(PDS.goodtrial & (PDS.TrialTypeSave == trialtype(1)));
    Postinject.type2trial = find(PDS.goodtrial & (PDS.TrialTypeSave == trialtype(2)));
    
    
    Postinject.type1trial_l = intersect(Postinject.type1trial,find(PDS.targAngle == 180));
    Postinject.type2trial_l = intersect(Postinject.type2trial,find(PDS.targAngle == 180));
    Postinject.type1trial_r = intersect(Postinject.type1trial,find(PDS.targAngle == 0));
    Postinject.type2trial_r = intersect(Postinject.type2trial,find(PDS.targAngle == 0));
    
    Postinject.reacttime = PDS.FEEDbacktime - PDS.timefpoff;
    
    %%%%%%% combine reacttime as a big matrix
    
    AllPrereacttime.type1trial_l = horzcat(AllPrereacttime.type1trial_l,Preinject.reacttime(Preinject.type1trial_l));
    AllPrereacttime.type2trial_l = horzcat(AllPrereacttime.type2trial_l,Preinject.reacttime(Preinject.type2trial_l));
    AllPrereacttime.type1trial_r = horzcat(AllPrereacttime.type1trial_r,Preinject.reacttime(Preinject.type1trial_r));
    AllPrereacttime.type2trial_r = horzcat(AllPrereacttime.type2trial_r,Preinject.reacttime(Preinject.type2trial_r));
    
    AllPostreacttime.type1trial_l = horzcat(AllPostreacttime.type1trial_l,Postinject.reacttime(Postinject.type1trial_l));
    AllPostreacttime.type2trial_l = horzcat(AllPostreacttime.type2trial_l,Postinject.reacttime(Postinject.type2trial_l));
    AllPostreacttime.type1trial_r = horzcat(AllPostreacttime.type1trial_r,Postinject.reacttime(Postinject.type1trial_r));
    AllPostreacttime.type2trial_r = horzcat(AllPostreacttime.type2trial_r,Postinject.reacttime(Postinject.type2trial_r));
    
    predatamean(1) = nanmean(Preinject.reacttime(Preinject.type1trial_l));
    predatamean(2) = nanmean(Preinject.reacttime(Preinject.type2trial_l));
    predatamean(3) = nanmean(Preinject.reacttime(Preinject.type1trial_r));
    predatamean(4) = nanmean(Preinject.reacttime(Preinject.type2trial_r));
    
    postdatamean(1) = nanmean(Postinject.reacttime(Postinject.type1trial_l));
    postdatamean(2) = nanmean(Postinject.reacttime(Postinject.type2trial_l));
    postdatamean(3) = nanmean(Postinject.reacttime(Postinject.type1trial_r));
    postdatamean(4) = nanmean(Postinject.reacttime(Postinject.type2trial_r));
    
    SEM = @(x) nanstd(x)/sqrt(length(find(~isnan(x))));
    
    predataerr(1) = SEM(Preinject.reacttime(Preinject.type1trial_l));
    predataerr(2) = SEM(Preinject.reacttime(Preinject.type2trial_l));
    predataerr(3) = SEM(Preinject.reacttime(Preinject.type1trial_r));
    predataerr(4) = SEM(Preinject.reacttime(Preinject.type2trial_r));
    
    postdataerr(1) = SEM(Postinject.reacttime(Postinject.type1trial_l));
    postdataerr(2) = SEM(Postinject.reacttime(Postinject.type2trial_l));
    postdataerr(3) = SEM(Postinject.reacttime(Postinject.type1trial_r));
    postdataerr(4) = SEM(Postinject.reacttime(Postinject.type2trial_r));
    
    axLimit = [0,0.8];
    axes(ax_contraside)
    plot(predatamean(1:2),postdatamean(1:2),'b'); hold on;
%     errorbar(predatamean(1:2),postdatamean(1:2),postdataerr(1:2),'b');
%     errorbar(predatamean(1:2),postdatamean(1:2),predataerr(1:2),'b','horizontal');
    
    axes(ax_ipsiside)
    plot(predatamean(3:4),postdatamean(3:4),'b'); hold on;
%     errorbar(predatamean(3:4),postdatamean(3:4),postdataerr(3:4),'b');
%     errorbar(predatamean(3:4),postdatamean(3:4),predataerr(3:4),'b','horizontal');
    
end


%%%%%all data combined
predatamean(1) = nanmean(AllPrereacttime.type1trial_l);
predatamean(2) = nanmean(AllPrereacttime.type2trial_l);
predatamean(3) = nanmean(AllPrereacttime.type1trial_r);
predatamean(4) = nanmean(AllPrereacttime.type2trial_r);

postdatamean(1) = nanmean(AllPostreacttime.type1trial_l);
postdatamean(2) = nanmean(AllPostreacttime.type2trial_l);
postdatamean(3) = nanmean(AllPostreacttime.type1trial_r);
postdatamean(4) = nanmean(AllPostreacttime.type2trial_r);

SEM = @(x) nanstd(x)/sqrt(length(find(~isnan(x))));

predataerr(1) = SEM(AllPostreacttime.type1trial_l);
predataerr(2) = SEM(AllPostreacttime.type2trial_l);
predataerr(3) = SEM(AllPostreacttime.type1trial_r);
predataerr(4) = SEM(AllPostreacttime.type2trial_r);

postdataerr(1) = SEM(AllPostreacttime.type1trial_l);
postdataerr(2) = SEM(AllPostreacttime.type2trial_l);
postdataerr(3) = SEM(AllPostreacttime.type1trial_r);
postdataerr(4) = SEM(AllPostreacttime.type2trial_r);

axes(ax_contraside)
errorbar(predatamean(1:2),postdatamean(1:2),postdataerr(1:2),'r','linewidth',2);
errorbar(predatamean(1:2),postdatamean(1:2),predataerr(1:2),'r','horizontal','linewidth',2);
hold on;
line(axLimit,axLimit);
xlim(axLimit);
ylim(axLimit);
xlabel('preinject reaction time');
ylabel('postinject reaction time');
title('contralateral')

axes(ax_ipsiside)
errorbar(predatamean(3:4),postdatamean(3:4),postdataerr(3:4),'r','linewidth',2);
errorbar(predatamean(3:4),postdatamean(3:4),predataerr(3:4),'r','horizontal','linewidth',2);
hold on;
line(axLimit,axLimit);
xlim(axLimit);
ylim(axLimit);
xlabel('preinject reaction time');
ylabel('postinject reaction time');
title('ipsilateral')
