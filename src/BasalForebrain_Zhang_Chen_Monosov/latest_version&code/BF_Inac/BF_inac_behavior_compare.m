clear all; close all;
addpath('X:\Kaining\HELPER_GENERAL');
%pre-inactivation data
load('X:\MONKEYDATA\ZOMBIE_ongoing\BF_inac\Inactivation_4conditions\BFnovelinac_18_05_2018_15_02.mat','PDS');
PDSpre = PDS;
%post-inactivation data
load('X:\MONKEYDATA\ZOMBIE_ongoing\BF_inac\Inactivation_4conditions\BFnovelinac_18_05_2018_postcombined.mat','PDS');
PDSpost = PDS;
clear PDS

ifchangefractal =0;

PDS = PDSpre;
if ifchangefractal==1
    trialtype = sort(unique(PDS.TrialTypeSave));
    trialtype = trialtype(3:4);
else
    trialtype = sort(unique(PDS.TrialTypeSave));
end


Preinject.type1trial = find(PDS.goodtrial & (PDS.TrialTypeSave == trialtype(1)))%& PDS.trialnumber>length(PDS.trialnumber)-80);
Preinject.type2trial = find(PDS.goodtrial & (PDS.TrialTypeSave == trialtype(2)))%& PDS.trialnumber>length(PDS.trialnumber)-80);


Preinject.type1trial_l = intersect(Preinject.type1trial,find(PDS.targAngle == 180));
Preinject.type2trial_l = intersect(Preinject.type2trial,find(PDS.targAngle == 180));
Preinject.type1trial_r = intersect(Preinject.type1trial,find(PDS.targAngle == 0));
Preinject.type2trial_r = intersect(Preinject.type2trial,find(PDS.targAngle == 0));

Preinject.reacttime = PDS.FEEDbacktime - PDS.timefpoff;


PDS = PDSpost;
if ifchangefractal==1
    trialtype = sort(unique(PDS.TrialTypeSave));
    trialtype = trialtype(3:4);
else
    trialtype = sort(unique(PDS.TrialTypeSave));
end

Postinject.type1trial = find(PDS.goodtrial & (PDS.TrialTypeSave == trialtype(1)));
Postinject.type2trial = find(PDS.goodtrial & (PDS.TrialTypeSave == trialtype(2)));


Postinject.type1trial_l = intersect(Postinject.type1trial,find(PDS.targAngle == 180));
Postinject.type2trial_l = intersect(Postinject.type2trial,find(PDS.targAngle == 180));
Postinject.type1trial_r = intersect(Postinject.type1trial,find(PDS.targAngle == 0));
Postinject.type2trial_r = intersect(Postinject.type2trial,find(PDS.targAngle == 0));

Postinject.reacttime = PDS.FEEDbacktime - PDS.timefpoff;



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
figure;
nsubplot(3,7,1:2,1:3)
errorbar(predatamean(1:2),postdatamean(1:2),postdataerr(1:2),'b.');
errorbar(predatamean(1:2),postdatamean(1:2),predataerr(1:2),'b.','horizontal');
hold on;
line(axLimit,axLimit);
xlim(axLimit);
ylim(axLimit);
xlabel('preinject reaction time');
ylabel('postinject reaction time');
title('contralateral')

nsubplot(3,7,1:2,5:7)
errorbar(predatamean(3:4),postdatamean(3:4),postdataerr(3:4),'b.');
errorbar(predatamean(3:4),postdatamean(3:4),predataerr(3:4),'b.','horizontal');
hold on;
line(axLimit,axLimit);
xlim(axLimit);
ylim(axLimit);
xlabel('preinject reaction time');
ylabel('postinject reaction time');
title('ipsilateral')




% 
% 
% figure;
% reacttime = PDS.FEEDbacktime - PDS.timefpoff;
% datamean(1,1) = nanmean(reacttime(type1trial_l));
% datamean(1,2) = nanmean(reacttime(type2trial_l));
% datamean(1,3) = nanmean(reacttime(type3trial_l));
% datamean(1,4) = nanmean(reacttime(type4trial_l));
% datamean(1,5) = nanmean(reacttime(type1trial_r));
% datamean(1,6) = nanmean(reacttime(type2trial_r));
% datamean(1,7) = nanmean(reacttime(type3trial_r));
% datamean(1,8) = nanmean(reacttime(type4trial_r));
% 
% dataerr(1,1) = nanstd(reacttime(type1trial_l))/sqrt(length(type1trial_l));
% dataerr(1,2) = nanstd(reacttime(type2trial_l))/sqrt(length(type2trial_l));
% dataerr(1,3) = nanstd(reacttime(type3trial_l))/sqrt(length(type3trial_l));
% dataerr(1,4) = nanstd(reacttime(type4trial_l))/sqrt(length(type4trial_l));
% dataerr(1,5) = nanstd(reacttime(type1trial_r))/sqrt(length(type1trial_r));
% dataerr(1,6) = nanstd(reacttime(type2trial_r))/sqrt(length(type2trial_r));
% dataerr(1,7) = nanstd(reacttime(type3trial_r))/sqrt(length(type3trial_r));
% dataerr(1,8) = nanstd(reacttime(type4trial_r))/sqrt(length(type4trial_r));
% 
% 
% bar(datamean);hold on;
% errorbar(datamean,dataerr,'.');
% set(gca,'xticklabel',{'1L' '2L' '3L' '4L' '1R' '2R' '3R' '4R'});
% p = ranksum(reacttime(type1trial_l),reacttime(type2trial_l))
% 
% clear datamean dataerr
% 
% figure;
% reacttime = PDS.FEEDbacktime - PDS.timefpoff;
% datamean(1,1) = nanmean(reacttime(type1trial));
% datamean(1,2) = nanmean(reacttime(type2trial));
% datamean(1,3) = nanmean(reacttime(type3trial));
% datamean(1,4) = nanmean(reacttime(type4trial));
% 
% 
% dataerr(1,1) = nanstd(reacttime(type1trial))/sqrt(length(type1trial));
% dataerr(1,2) = nanstd(reacttime(type2trial))/sqrt(length(type2trial));
% dataerr(1,3) = nanstd(reacttime(type3trial))/sqrt(length(type3trial));
% dataerr(1,4) = nanstd(reacttime(type4trial))/sqrt(length(type4trial));
% 
% bar(datamean);hold on;
% errorbar(datamean,dataerr,'.');
% set(gca,'xticklabel',{'1' '2' '3' '4' });
% p = ranksum(reacttime(type1trial),reacttime(type2trial))
% %p = ranksum(reacttime(type3trial),reacttime(type4trial))
% clear datamean dataerr
% figure;
% Fractal = unique(PDS.fractals);
% for i = 1: length(Fractal)
%     datamean(1,i) = nanmean(reacttime(PDS.fractals == Fractal(i)));
%     dataerr(1,i) = nanstd(reacttime(PDS.fractals == Fractal(i)));
% end
% bar(datamean);hold on;
% errorbar(datamean,dataerr,'.');
% set(gca,'xticklabel',Fractal);
% 
% 
