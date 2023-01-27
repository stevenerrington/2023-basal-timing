clear all; close all;
addpath('X:\Kaining\HELPER_GENERAL');
load('X:\MONKEYDATA\ZOMBIE_ongoing\BF_inac\Behavior_4conditions\BFnovelinac_27_04_2018_14_27.mat','PDS');

trialtype = sort(unique(PDS.TrialTypeSave));


type1trial = find(PDS.goodtrial & (PDS.TrialTypeSave == trialtype(1)));
type2trial = find(PDS.goodtrial & (PDS.TrialTypeSave == trialtype(2)));
type3trial = find(PDS.goodtrial & (PDS.TrialTypeSave == trialtype(3)));
type4trial = find(PDS.goodtrial & (PDS.TrialTypeSave == trialtype(4)));

type1trial_l = intersect(type1trial,find(PDS.targAngle == 180));
type2trial_l = intersect(type2trial,find(PDS.targAngle == 180));
type3trial_l = intersect(type3trial,find(PDS.targAngle == 180));
type4trial_l = intersect(type4trial,find(PDS.targAngle == 180));
type1trial_r = intersect(type1trial,find(PDS.targAngle == 0));
type2trial_r = intersect(type2trial,find(PDS.targAngle == 0));
type3trial_r = intersect(type3trial,find(PDS.targAngle == 0));
type4trial_r = intersect(type4trial,find(PDS.targAngle == 0));

figure;
reacttime = PDS.FEEDbacktime - PDS.timefpoff;
datamean(1,1) = nanmean(reacttime(type1trial_l));
datamean(1,2) = nanmean(reacttime(type2trial_l));
datamean(1,3) = nanmean(reacttime(type3trial_l));
datamean(1,4) = nanmean(reacttime(type4trial_l));
datamean(1,5) = nanmean(reacttime(type1trial_r));
datamean(1,6) = nanmean(reacttime(type2trial_r));
datamean(1,7) = nanmean(reacttime(type3trial_r));
datamean(1,8) = nanmean(reacttime(type4trial_r));

dataerr(1,1) = nanstd(reacttime(type1trial_l))/sqrt(length(type1trial_l));
dataerr(1,2) = nanstd(reacttime(type2trial_l))/sqrt(length(type2trial_l));
dataerr(1,3) = nanstd(reacttime(type3trial_l))/sqrt(length(type3trial_l));
dataerr(1,4) = nanstd(reacttime(type4trial_l))/sqrt(length(type4trial_l));
dataerr(1,5) = nanstd(reacttime(type1trial_r))/sqrt(length(type1trial_r));
dataerr(1,6) = nanstd(reacttime(type2trial_r))/sqrt(length(type2trial_r));
dataerr(1,7) = nanstd(reacttime(type3trial_r))/sqrt(length(type3trial_r));
dataerr(1,8) = nanstd(reacttime(type4trial_r))/sqrt(length(type4trial_r));


bar(datamean);hold on;
errorbar(datamean,dataerr,'.');
set(gca,'xticklabel',{'1L' '2L' '3L' '4L' '1R' '2R' '3R' '4R'});
p = ranksum(reacttime(type1trial_l),reacttime(type2trial_l))

clear datamean dataerr

figure;
reacttime = PDS.FEEDbacktime - PDS.timefpoff;
datamean(1,1) = nanmean(reacttime(type1trial));
datamean(1,2) = nanmean(reacttime(type2trial));
datamean(1,3) = nanmean(reacttime(type3trial));
datamean(1,4) = nanmean(reacttime(type4trial));


dataerr(1,1) = nanstd(reacttime(type1trial))/sqrt(length(type1trial));
dataerr(1,2) = nanstd(reacttime(type2trial))/sqrt(length(type2trial));
dataerr(1,3) = nanstd(reacttime(type3trial))/sqrt(length(type3trial));
dataerr(1,4) = nanstd(reacttime(type4trial))/sqrt(length(type4trial));

bar(datamean);hold on;
errorbar(datamean,dataerr,'.');
set(gca,'xticklabel',{'1' '2' '3' '4' });
p = ranksum(reacttime(type1trial),reacttime(type2trial))
p = ranksum(reacttime(type3trial),reacttime(type4trial))
clear datamean dataerr
figure;
Fractal = unique(PDS.fractals);
for i = 1: length(Fractal)
    datamean(1,i) = nanmean(reacttime(PDS.fractals == Fractal(i)));
    dataerr(1,i) = nanstd(reacttime(PDS.fractals == Fractal(i)));
end
bar(datamean);hold on;
errorbar(datamean,dataerr,'.');
set(gca,'xticklabel',Fractal);


