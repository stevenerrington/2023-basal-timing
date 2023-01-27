clear all; clc; close all; beep off;
addpath('HELPER_GENERAL');

addpath('X:\MONKEYDATA\ZOMBIE_ongoing\BF_SequenceLearning\Behavior_similaritypicture\');
D=dir ('X:\MONKEYDATA\ZOMBIE_ongoing\BF_SequenceLearning\Behavior_similaritypicture\S*.mat');

for x_file=1:length(D)
    clc;
    clear PDS;
    load(D(x_file).name,'PDS');
    savestruct(x_file).name=D(x_file).name;
    
    
    trials=find(PDS.Set(:,1)~=9999 & PDS.Set(:,2)~=9999 & PDS.timeoutcome'>0);
    try
        trials=intersect(find(PDS.timingerr==0),trials);
    end
    
    try
        NoBeliefErrors=intersect(trials,find(PDS.belieferror==0 & PDS.timeoutcome>0 & PDS.chosenwindow==0));
        BeliefErrors=intersect(trials,find(PDS.belieferror==1 & PDS.timeoutcome>0 & PDS.chosenwindow==0));
        BE=PDS.Set(:,1)-PDS.Set(:,3);
        BEPos2=intersect(find(BE==99),BeliefErrors);
        BEPos1=intersect(find(BE==-101),BeliefErrors);
        if length(unique(PDS.WhichSet))>3 %exclude older versions with more than 1 sets from set compare
            Set1Trials=[];
            Set2Trials=[];
            NoBeliefErrors=[];
            BEPos2=[];
            BEPos1=[];
        else
            Set1Trials=intersect(find(PDS.WhichSet==1),NoBeliefErrors);
            Set2Trials=intersect(find(PDS.WhichSet==2),NoBeliefErrors);
            
        end
        
    catch
        NoBeliefErrors=[];
        BEPos2=[];
        BEPos1=[];
        Set1Trials=[];
        Set2Trials=[];
    end
    
    ChoiceRTs=[];
    ChoiceRTs(PDS.trialnumber)=NaN    ;
    RTproxy=PDS.timeoutcome(find(PDS.chosenwindow==1))' - PDS.timetargeton(find(PDS.chosenwindow==1),1);
    ChoiceRTs(find(PDS.chosenwindow==1)) = RTproxy;
    
    
    ImageSim=[];
    for SIM=1:length(PDS.blockid)
        ImageSim=[ImageSim; ssim(PDS.img1{SIM},PDS.img2{SIM})];
    end
    
    
    
    savestruct(x_file).ChoiceRTs=zscore(ChoiceRTs(find(ChoiceRTs>0))');
    savestruct(x_file).ImageSim= zscore(ImageSim(find(ChoiceRTs>0)));
    
    
end

ChoiceRTs=[]
ImageSim=[]
for x=1:2
    ChoiceRTs=[ChoiceRTs; savestruct(x).ChoiceRTs];
    ImageSim=[ImageSim; savestruct(x).ImageSim];
end



figure
[rho,p]=corr(ChoiceRTs,ImageSim);
scatter(ChoiceRTs,ImageSim)
axis([-1 1 -3 3])
axis square
title([' rho= ' mat2str(rho) '   p= ' mat2str(p)])
xlabel('zscore RT')
ylabel('zscore ImageSim (SSIM)')




















