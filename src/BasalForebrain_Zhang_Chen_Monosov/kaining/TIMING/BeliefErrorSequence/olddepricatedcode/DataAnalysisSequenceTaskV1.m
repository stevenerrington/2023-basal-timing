clear all; clc; close all; beep off;
GauSw=101;
addpath('HELPER_GENERAL');

addpath('X:\MONKEYDATA\Batman\SequenceLearning\neurons\');
D=dir ('X:\MONKEYDATA\Batman\SequenceLearning\neurons\S*.mat');

addpath('X:\MONKEYDATA\Robin_ongoing\SequenceLearning\neurons\phasic\');
D1=dir ('X:\MONKEYDATA\Robin_ongoing\SequenceLearning\neurons\phasic\S*.mat');

addpath('X:\MONKEYDATA\Robin_ongoing\OldSequenceLearning\neurons\');
D2=dir ('X:\MONKEYDATA\Robin_ongoing\OldSequenceLearning\neurons\S*.mat');

addpath('X:\MONKEYDATA\ZOMBIE_ongoing\BF_SequenceLearning\Phasic\');
D3=dir ('X:\MONKEYDATA\ZOMBIE_ongoing\BF_SequenceLearning\Phasic\S*.mat');
D=[D; D1; D2; D3];

% 

% addpath('X:\MONKEYDATA\ZOMBIE_ongoing\BF_SequenceLearning\Ramping\');
% D=dir ('X:\MONKEYDATA\ZOMBIE_ongoing\BF_SequenceLearning\Ramping\S*.mat');
% 
% addpath('X:\MONKEYDATA\Robin_ongoing\SequenceLearning\neurons\tonic\');
% D1=dir ('X:\MONKEYDATA\Robin_ongoing\SequenceLearning\neurons\tonic\S*.mat');
% 
% D=[D; D1;];





%
% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


SDFSS=[]; FamSS=[]; NovSS=[]; BEsave=[]; NoBEsave=[]; BEsave_Nov1=[]; noBEsave_Nov1=[]; BEsave_Nov3=[]; noBEsave_Nov3=[];
ROCbe=[]; ROCbeP=[];
SingleBE=[]; NovUseful=[]; NovNotUseful=[]; SetVersusSet2=[];

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
    
    
    ChoiceRTs(PDS.trialnumber)=NaN    ;
    RTproxy=PDS.timeoutcome(find(PDS.chosenwindow==1))' - PDS.timetargeton(find(PDS.chosenwindow==1),1);
    ChoiceRTs(find(PDS.chosenwindow==1)) = RTproxy;
    slowRTsThresh=quantile(RTproxy,0.25);
    fastRTsThresh=quantile(RTproxy,0.25);
    slowRTsTrials=find(ChoiceRTs> slowRTsThresh)
    fastRTsTrials=find(ChoiceRTs< fastRTsThresh)
    slowRTsTrials=intersect(NoBeliefErrors,intersect(slowRTsTrials-1,Set2Trials))
    fastRTsTrials=intersect(NoBeliefErrors,intersect(fastRTsTrials-1,Set2Trials))
    clear ChoiceRTs RTproxy
    
    
    Rasters=[];
    for x=1:length(PDS.timeoutcome)
        CENTER=11001;
        spk=PDS(1).sptimes{x}-PDS(1).timeoutcome(x);
        spk=(spk*1000)+CENTER-1;
        spk=fix(spk);
        %
        spk=spk(find(spk<CENTER*2));
        %
        temp(1:CENTER*2)=0;
        temp(spk)=1;
        Rasters=[Rasters; temp];
        clear temp spk x
    end
    
    Rasters=Rasters(:,11000-5000:11000);
    SDFcs=plot_mean_psth({Rasters},GauSw,1,size(Rasters,2),1); close all;
    
    ztemp=SDFcs(trials,:);
    SDFcs=(SDFcs-nanmean(ztemp(:)));
    SDFcs=SDFcs./nanstd(ztemp(:));
    
    
    figure
    plot(nanmean(SDFcs(trials,:)))
    close all;
    
    SDFcs=SDFcs(:,1000:end);
    

    
    
    Rasters_=Rasters;
    Rasters=Rasters(:,1000:end);
    
    
    FamS=[]; NovS=[];
    if isempty(NoBeliefErrors)==0
        t=NoBeliefErrors;
    else
        t=trials;
    end
    
    for x=1:length(t)
        x=t(x);
        Fam=nanmean([SDFcs(x,2001:3000);
            SDFcs(x,3001:4000)]);
        Nov=SDFcs(x,1001:2000);
        
        Famb=nanmean([SDFcs(x,2000-100:2000);
            SDFcs(x,3000-100:3000)]);
        Novb=SDFcs(x,1000-100:1000);
        
        FamS=[FamS; Fam-nanmean(Famb)];
        NovS=[NovS; Nov-nanmean(Novb)];
        clear Fam Nov x BE_
    end
    %[savestruct(x_file).Nov_r,savestruct(x_file).Nov_p]=rocarea3(nanmean(FamS(:,200:400)')',nanmean(NovS(:,200:400)')')
    
    temp=min([nanmean(FamS)'; nanmean(NovS)']);
    FamS=nanmean(FamS)-temp;
    NovS=nanmean(NovS)-temp;
    temp=max([(FamS)'; (NovS)']);
    FamS=FamS./temp;
    NovS=NovS./temp;
    savestruct(x_file).SDFcs= nanmean(SDFcs(t,:));
    
    if length(slowRTsTrials)>4 & length(fastRTsTrials)>4
     savestruct(x_file).SDFcsSlow= nanmean(SDFcs(slowRTsTrials,:));
       savestruct(x_file).SDFcsFast= nanmean(SDFcs(fastRTsTrials,:));
    else
        temp(1:4002)=NaN;
            savestruct(x_file).SDFcsSlow= temp;
       savestruct(x_file).SDFcsFast= temp;
    end
%        figure;
%        plot( savestruct(x_file).SDFcsSlow , 'b' ); hold on
%         plot( savestruct(x_file).SDFcsFast , 'r' ); hold on
%         xlim([0 4000]); axis square
%         close all;
%        
    
    
    savestruct(x_file).FamSS=FamS;
    savestruct(x_file).NovSS=NovS;
    clear p temp FamS NovS
    
    FamS=[]; NovS=[];  FamSOne=[];  FamSTwo=[];  FamSThree=[];
    for x=1:length(t)
        x=t(x);
        FamThree=nanmean([nansum(Rasters(x,3001+200:3001+400))]);
        FamTwo=nanmean([nansum(Rasters(x,2001+200:2001+400))]);
        Fam=nanmean([nansum(Rasters(x,2001+200:2001+400)) nansum(Rasters(x,3001+200:3001+400))]);
        Nov=nansum(Rasters(x,1001+200:1001+400));
        FamOne=nansum(Rasters_(x,1001+200:1001+400));
        
        FambThree=nanmean([nansum(Rasters(x,3000-100:3000))]);
        FambTwo=nanmean([nansum(Rasters(x,2000-100:2000)) ]);
        Famb=nanmean([nansum(Rasters(x,2000-100:2000)) nansum(Rasters(x,3000-100:3000))]);
        Novb=nansum(Rasters(x,1000-100:1000));
        FamOneb=nansum(Rasters_(x,1000-100:1000));
        
        FamSTwo=[FamSTwo; FamTwo-(FambTwo')];
        FamSThree=[FamSThree; FamThree-(FambThree')];
        FamSOne=[FamSOne; FamOne-(FamOneb')];
        FamS=[FamS; Fam-(Famb')];
        NovS=[NovS; Nov-(Novb')];
        clear Fam Nov x BE_ Famb Novb
    end
    [savestruct(x_file).Nov_r,savestruct(x_file).Nov_p]=rocarea3(FamS, NovS);
    savestruct(x_file).FamSS_=nanmean(FamS);
    savestruct(x_file).NovSS_=nanmean(NovS);
    savestruct(x_file).FamSTwo=nanmean(FamSTwo);
    savestruct(x_file).FamSThree=nanmean(FamSThree);
    savestruct(x_file).FamSOne=nanmean(FamSOne);

    clear FamS NovS FamSOne FamSThree FamSTwo temp x t

    if isempty(Set1Trials)~=1
        
        t1=nanmean(SDFcs(Set2Trials,1001:2000))-nanmean(nanmean(SDFcs(Set2Trials,1000-100:1000)));
        t2=nanmean(SDFcs(Set1Trials,1001:2000))-nanmean(nanmean(SDFcs(Set1Trials,1000-100:1000)));
        t3=nanmean([SDFcs(Set2Trials,2001:3000);
            SDFcs(Set2Trials,3001:4000)]) - nanmean(nanmean([SDFcs(Set2Trials,2000-100:2000);
            SDFcs(Set2Trials,3000-100:3000)]));
        t4=nanmean([SDFcs(Set1Trials,2001:3000);
            SDFcs(Set1Trials,3001:4000)]) - nanmean(nanmean([SDFcs(Set1Trials,2000-100:2000);
            SDFcs(Set1Trials,3000-100:3000)]));
        
        
        
        %normalization
        t1=t1(1:500);
        t2=t2(1:500);
        t3=t3(1:500);
        t4=t4(1:500);
        
        temp=min([t1'; t2'; t3'; t4';]);
        t1=t1-temp;
        t2=t2-temp;
        t3=t3-temp;
        t4=t4-temp;
        
        temp=max([t1'; t2'; t3'; t4';]);
        t1=t1./temp;
        t2=t2./temp;
        t3=t3./temp;
        t4=t4./temp;
        
        savestruct(x_file).NovUseful= t1;
        savestruct(x_file).NovNotUseful= t2;
        savestruct(x_file).NovUsefulFam=t3;
        savestruct(x_file).NovNotUsefulFam=t4;   
        clear t1 t2 t3 t4 temp t5 t6
        
        
        
        t1=nanmean (nansum(Rasters(Set2Trials,1001+200:1001+400)') - nanmean(nansum(Rasters(Set2Trials,1000-100:1000)')));
        t2=nanmean(nansum(Rasters(Set1Trials,1001+200:1001+400)') - nanmean(nansum(Rasters(Set1Trials,1000-100:1000)')));
        t3= nanmean ( nansum([Rasters(Set2Trials,2001+200:2001+400)' Rasters(Set2Trials,3001+200:3001+400)']) ) - nanmean ( nansum([Rasters(Set2Trials,2000-100:2000)' Rasters(Set2Trials,3000-100:3000)']) );
        t4= nanmean ( nansum([Rasters(Set1Trials,2001+200:2001+400)' Rasters(Set1Trials,3001+200:3001+400)']) ) - nanmean ( nansum([Rasters(Set1Trials,2000-100:2000)' Rasters(Set1Trials,3000-100:3000)']) );
        
       
        savestruct(x_file).NovUseful_= t1;
        savestruct(x_file).NovNotUseful_= t2;
        savestruct(x_file).NovUsefulFam_=t3;
        savestruct(x_file).NovNotUsefulFam_=t4;   
        clear t1 t2 t3 t4 temp t5 t6
     
    end
    
    
    
    BEALL=[BEPos1; BEPos2];
    if length(BEALL)>2 & length(BEPos1)>0 & length(BEPos2)>0
        range1=[201:400];
        range2=[2201:2400];
        
        savePs=[];
        for dothis=1:1
            B1=Rasters(BEPos1,range1);%-AveragePreFirstF;
            B2=Rasters(BEPos2,range2);%-nanmean(nanmean(SDFcs(:,2000-100:2000)'));
            BEfiring=([(nansum(B1')) (nansum(B2'))]);
            clear B1 B2
            
            NoBeliefErrors=randperm(length(NoBeliefErrors));
            NoBeliefErrors=randperm(length(NoBeliefErrors));
            NoBeliefErrors=randperm(length(NoBeliefErrors));
            
            %NoBeliefErrors=intersect(find(PDS.WhichSet==2),NoBeliefErrors);
           
            
            trialspos1=NoBeliefErrors(1:round((length(NoBeliefErrors)*length(BEPos1)./(length(BEPos2)+length(BEPos1)))));
            trialspos2=NoBeliefErrors(1:round((length(NoBeliefErrors)*length(BEPos2)./(length(BEPos2)+length(BEPos1)))));
            B1=Rasters(trialspos1,range1);
            B2=Rasters(trialspos2,range2);
            NOBEfiring=([(nansum(B1')) (nansum(B2'))]);
            
            savePs=[savePs; ranksum(BEfiring,NOBEfiring)];
            
            clear B1 B2 trialspos1 trialspos2
            
        end
        savestruct(x_file).PercBeSig=100*(length(find(savePs<0.05))./length(savePs));
        savestruct(x_file).BEfiring=nanmean(BEfiring);
        savestruct(x_file). NOBEfiring= nanmean(NOBEfiring);
        
        
    end
    
    
    
    
    clear NOBEALL BEALL NoBeliefErrors t trials FamS NovS SDFcs Rasters savePs dothis BEfiring
    clear FamS NovS BEPos2 BEPos1 PDS Set1Trials Set2Trials NOBEfiring range1 range2 NoBeliefErrors
    clear B1 B2 trialspos1 trialspos2 tempmin temp BEALLsdf NOBEALLsdf BEfiring
    close all; clc;
end

save savedata.mat savestruct



signrank(nanmean(x(:,1000:2000)'),nanmean(y(:,1000:2000)'))

clear all;