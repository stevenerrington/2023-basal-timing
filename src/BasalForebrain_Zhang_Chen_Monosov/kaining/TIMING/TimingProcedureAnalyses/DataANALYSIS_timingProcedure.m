clc; clear all; close all;

str='BFphas'
CENTER=6001;
shuffletime=100;
gauswindow_ms=100;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath('C:\Users\Ilya\Dropbox\HELPER\HELPER_GENERAL');
addpath('C:\Users\Ilya Monosov\Dropbox\HELPER\HELPER_GENERAL');

addpath('C:\Users\Ilya\Desktop\BF\Timing\Robin\BFtonic\');
addpath('C:\Users\Ilya\Desktop\BF\Timing\Wolverine\tonic\');
addpath('C:\Users\Ilya\Desktop\BF\Timing\Batman\tonic\');


addpath('C:\Users\Ilya\Desktop\BF\Timing\Robin\BFphasic\');
addpath('C:\Users\Ilya\Desktop\BF\Timing\Batman\phasic\');

addpath('X:\MONKEYDATA\Batman\Timingprocedure_Basilforebrain\BFphasic\');
addpath('X:\MONKEYDATA\Robin_ongoing\TimingProcedureBF\BFphasic\');
addpath('X:\MONKEYDATA\Robin_ongoing\TimingProcedureBF\BFtonic\');
addpath('X:\Charlie\TimingProcedureWBF\TimingProcedure\');


addpath('X:\MONKEYDATA\Batman\Timingprocedure_Basilforebrain\BFphasic\');
addpath('X:\MONKEYDATA\Robin_ongoing\TimingProcedureBF\BFtonic\');
addpath('C:\Users\Ilya Monosov\Desktop\BFtonic\');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if strcmpi(str,'BF')
    
    addpath('X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingProcedure\BFramping\');
    D=dir ('X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingProcedure\BFramping\*.mat');
    for x=1:size(D,1)
        D(x).MONKEYID='wolverine'
    end
    
    addpath('X:\MONKEYDATA\Batman\Timingprocedure_Basilforebrain\BFtonic\');
    D1=dir ('X:\MONKEYDATA\Batman\Timingprocedure_Basilforebrain\BFtonic\*.mat');
    for x=1:size(D1,1)
        D1(x).MONKEYID='batman'
    end
    
    addpath('X:\MONKEYDATA\Robin_ongoing\TimingProcedureBF\BFtonic\');
    D2=dir ('X:\MONKEYDATA\Robin_ongoing\TimingProcedureBF\BFtonic\*.mat');
    for x=1:size(D2,1)
        D2(x).MONKEYID='robin'
    end
    
    addpath('Y:\MONKEYDATA\ZOMBIE_ongoing\BF_timingprocejure\Ramping\');
    D3=dir ('Y:\MONKEYDATA\ZOMBIE_ongoing\BF_timingprocejure\Ramping\*.mat');
    for x=1:size(D3,1)
        D3(x).MONKEYID='zombie'
    end
    D=[D; D1; D2; D3;]; clear D1 D2 D3 
    
    
elseif strcmpi(str,'BG')
    
    D=dir ('\\128.252.37.174\Share1\Charlie\TimingProcedureWBG\TimingProcedure*.mat');
    D1=dir ('\\128.252.37.174\Share1\Charlie\TimingProcedureBBG\TimingProcedure*.mat');
    D2=dir ('\\128.252.37.174\Share1\Charlie\TimingProcedureRBG\TimingProcedure*.mat');
    D=[D; D1; D2;]; clear D1 D2

elseif strcmpi(str,'BFphas')
    
    D=dir ('X:\MONKEYDATA\Robin_ongoing\TimingProcedureBF\BFphasic\*.mat');
    for x=1:size(D,1)
        D(x).MONKEYID='robin'
    end
    
    D1=dir ('X:\MONKEYDATA\Batman\Timingprocedure_Basilforebrain\BFphasic\*.mat');
    for x=1:size(D1,1)
        D1(x).MONKEYID='batman'
    end
    
    D2=dir ('X:\MONKEYDATA\ZOMBIE_ongoing\BF_timingprocejure\Phasic\*.mat');
    addpath('X:\MONKEYDATA\ZOMBIE_ongoing\BF_timingprocejure\Phasic\');
    for x=1:size(D2,1)
        D2(x).MONKEYID='zombie'
    end
       
    D=[D; D1; D2]; clear D1 D2 D3  
    
 
else
    error('Inputs must be ''BF'' or ''BG'' (case insensitive)')
end

  for xzv=1:length(D)

    
    load(D(xzv).name,'PDS');
    savestruct(xzv).filename=D(xzv).name;
    savestruct(xzv).filename=D(xzv).MONKEYID;
    
    durationsuntilreward=PDS(1).timeoutcome-PDS(1).timetargeton;
    durationsuntilreward=round(durationsuntilreward*10)./10;
    completedtrial=find(PDS.timetargeton>0);
    
    try
        deliv=find(PDS.rewardDuration>0);
        ndeliv=find(PDS.rewardDuration==0);
    catch
        deliv=find(PDS.deliveredornot>0);
        ndeliv=find(PDS.deliveredornot==0);  
    end
    
    
    %organize trial types into indices
    trials6201=(find(PDS(1).fractals==6201));
    trials6201=intersect(trials6201,completedtrial);
    trials6201n=intersect(trials6201,deliv);
    trials6201nd=intersect(trials6201,ndeliv);
    
    %
    trials6102=intersect(find(PDS(1).fractals==6102),completedtrial); %50% LONG 50 SHORT
    trials6102_50s=intersect(find(durationsuntilreward==1.5),trials6102);
    trials6102_50l=intersect(find(durationsuntilreward==4.5),trials6102);
    %
    trials6101=intersect(find(PDS(1).fractals==6101),completedtrial); %25SHORT
    trials6101_25s=intersect(find(durationsuntilreward==1.5),trials6101);
    trials6101_75l=intersect(find(durationsuntilreward==4.5),trials6101);
    %
    trials6103=intersect(find(PDS(1).fractals==6103),completedtrial);%25LONG
    trials6103_75s=intersect(find(durationsuntilreward==1.5),trials6103);
    trials6103_25l=intersect(find(durationsuntilreward==4.5),trials6103);
    %
    trials6104=intersect(find(PDS(1).fractals==6104),completedtrial); %SHORT
    %
    trials6105=intersect(find(PDS(1).fractals==6105),completedtrial);
    trials6105_25s=intersect(find(durationsuntilreward==1.5),trials6105);
    trials6105_25ms=intersect(find(durationsuntilreward==2.5),trials6105);
    trials6105_25ml=intersect(find(durationsuntilreward==3.5),trials6105);
    trials6105_25l=intersect(find(durationsuntilreward==4.5),trials6105);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %CLEAR REWARD NOISE
%     CLEAN=[trials6101 trials6102 trials6103 trials6104 trials6105];
%     for x=1:length(CLEAN)
%         x=CLEAN(x);
%         spk=PDS(1).sptimes{x};
%         spk1=spk(find(spk<PDS.timeoutcome(x)));
%         spk2=spk(find(spk>PDS.timeoutcome(x)+10/1000));
%         spk=[spk1 spk2]; clear spk1 spk2
%         %
%         try
%             no_noise=find(spk>(PDS.timeoutcome(x)+(10/1000)) & spk<(PDS.timeoutcome(x)+(20/1000)));
%             no_noise=length(no_noise); %this many spikes in the window  so insert that many spikes in the deleted time range
%             grabnumbers=PDS.timeoutcome(x)+randperm(10)/1000;
%             grabnumbers=grabnumbers(no_noise);
%             spk=[spk grabnumbers];
%         end
%         PDS(1).sptimes{x}=sort(spk);
%         %
%         clear y spk spk1 spk2 x
%     end
%     
%     
%     
%     
%     
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    try
    millisecondResolution=0.001;
    Lick=[];
    for x=1:length(PDS.fractals)
        
        temp = PDS.onlineLickForce{x};
        relatveTimePDS = temp(:,2)-temp(1,2);
        regularTimeVectorForPdsInterval = [0: millisecondResolution  : temp(end,2)-temp(1,2)];
        regularPdsData = interp1(  relatveTimePDS , temp(:,1) , regularTimeVectorForPdsInterval  );
        %
        regularPdsData=abs(regularPdsData);
        [bb,aa]=butter(8,10/500,'low');
        regularPdsData=filtfilt(bb,aa,regularPdsData);
        %
        regularPdsData(length(regularPdsData)+1:12000)=NaN;
        Lick=[Lick; regularPdsData(1:12000)];
        clear regularPdsData regularTimeVectorForPdsInterval temp relatveTimePDS   %
    end
    
    Lick_=[];
    GoodTrials=[];
    targon_=fix(PDS.timetargeton*1000);
    targrange=[targon_'-1500 targon_'+2000];
    for b=1:length(PDS.timetargeton)
        try
            t=Lick(b,[targrange(b,1):targrange(b,2)]);
            GoodTrials=[GoodTrials; b];
        catch
            t(1:3501)=NaN;
            
        end
        Lick_=[Lick_; t]; clear t
    end

    
    
    Lickdetect=[];
    numberofstd=2;
    baseline=Lick_(GoodTrials,1:400); %baseline from completed trials with outcomes
    baseline=baseline(:);
    baseline=baseline(find(isnan(baseline)==0));
    baselinemean=mean(baseline(:));
    rangemax=baselinemean+(std(baseline)*numberofstd);
    Savelicks=[];
    for x=1:length(PDS.fractals)
        x=Lick_(x,:);
        x(find(x>rangemax))=999999;
        x(find(x~=999999))=0;
        x(find(x==999999))=1;
        Lickdetect=[Lickdetect; x]; clear x;
    end
%     figure; imagesc(Lickdetect)
%     figure;plot(nanmean(Lickdetect))
%     close all;
        

        
    %save sessions with reasonable licking signal
    savestruct(x_file).included=0;
    test=Lickdetect([prob100],:);
    test=nansum(test)./size(test,1);
    if length(find(test>0.5))>50       
        savestruct(xzv).lick50risk=Lickdetect([trials6201],:);
        savestruct(xzv).lick=Lickdetect([trials6104],:);
        savestruct(xzv).lick75=Lickdetect([trials6103],:);
        savestruct(xzv).lick50=Lickdetect([trials6102],:);
       savestruct(xzv).lick25=Lickdetect([trials6101],:);
      
        
        
        
    end
    catch
            savestruct(xzv).included=0;
    end

    
    
    
    
    
    
    
    
    
    
    Rasters=[];
    for x=1:length(durationsuntilreward)
        %
        spk=PDS(1).sptimes{x}-PDS(1).timetargeton(x);
        spk=(spk*1000)+CENTER-1;
        spk=fix(spk);
        %
        spk=spk(find(spk<CENTER*2));
        %
        temp(1:CENTER*2)=0;
        temp(spk)=1;
        Rasters=[Rasters; temp];
        %
        clear temp spk x
    end
    
    
%     %outcometime=13500; %switch this to the time of outcome in your task
%     outcometime=7500;
%     cleanreward50n=intersect(trials6201,ndeliv); %prob50 are the 6201 trials
%     cleanreward50=intersect(trials6201,deliv);
%     
%     for x=1:length(cleanreward50)
%         spk_dirty=Rasters(cleanreward50(x),:);
%         
%         cleanreward50n=cleanreward50n(randperm(length(cleanreward50n)));
%         spk_clean=Rasters(cleanreward50n(1),:);
%         
%         spk_dirty(outcometime-25:outcometime+25)=spk_clean(outcometime-25:outcometime+25);
%         Rasters(cleanreward50(x),:)=spk_dirty;
%         clear spk_dirty spk_clean x
%     end
    
    
    Rasters_=Rasters;
    SDFtiming=plot_mean_psth({Rasters},gauswindow_ms,1,(CENTER*2)-2,1);
    Rasters_timing=Rasters; clear Rasters
    %Rasters_=Rasters_([trials6101 trials6102 trials6103 trials6104],:);
    %Rasters_=Rasters_'; Rasters_=Rasters_(:);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    trialsTrials=[trials6101 trials6102 trials6103 trials6104 trials6105 trials6201];
    ITIfiringrate=SDFtiming(trialsTrials,4050:4750);
    ITIfiringrate=nanmean(ITIfiringrate);
    ITIfiringrate=nanmean(ITIfiringrate,2);
    savestruct(xzv).ITIfiringrate=ITIfiringrate;

    %%%%%%%%%%
    %%%%%%%%%%
    
    norm=nanmean(SDFtiming(trials6101_75l,6000:9000));
    A1=SDFtiming(trials6101_25s,6000:9000);
    ch4 = A1 - norm(ones(size(A1,1),1),:);
    
    norm=nanmean(SDFtiming(trials6102_50l,6000:9000));
    A1=SDFtiming(trials6102_50s,6000:9000);
    ch3 = A1 - norm(ones(size(A1,1),1),:);
    
    norm=nanmean(SDFtiming(trials6103_25l,6000:9000));
    A1=SDFtiming(trials6103_75s,6000:9000);
    ch2 = A1 - norm(ones(size(A1,1),1),:);

    
    
%     RunningROC=[];
%     RunningROCP=[];
%     RunningROCrpe=[];
%     RunningROCPrpe=[];
%     v1=SDFtiming(trials6102_50s,6000:9000);
%     v2=SDFtiming(trials6102_50l,6000:9000);
%     v3=SDFtiming(trials6201n,6000:9000);
%     v4=SDFtiming(trials6201nd,6000:9000);
%     for x = 1:size(ch2,2)-100
%         binAnalysis=[x:x+100];
%         
%         t2=v1(:,binAnalysis);
%         t2=nanmean(t2')';
%         t4=v2(:,binAnalysis);
%         t4=nanmean(t4')';
%         
%         t5=v3(:,binAnalysis);
%         t5=nanmean(t5')';
%         t6=v4(:,binAnalysis);
%         t6=nanmean(t6')';
%         
%         [r,p]=rocarea3(t4,t2);
%         RunningROC=[RunningROC; r];
%         RunningROCP=[ RunningROCP; p];
%         
%         [r,p]=rocarea3(t6,t5);
%         RunningROCrpe=[RunningROCrpe; r];
%         RunningROCPrpe=[ RunningROCPrpe; p];
%         
%         clear P t1 t2 t3 t4 t5 t6 temp PlotPvalue pval r t2 t5 t4 t6
%     end
% 
%     savestruct(xzv).RunningROC=RunningROC;
%     savestruct(xzv).RunningROCP=RunningROCP;
%     savestruct(xzv).RunningROCrpe=RunningROCrpe;
%     savestruct(xzv).RunningROCPrpe=RunningROCPrpe;
    
    
    PvalueSave=[];
    PvalueSaveCor=[];
    SaveCor=[];
    for x = 1:size(ch2,2)-100
        binAnalysis=[x:x+100];
        %        t1=ch1(:,x);%-ch1mean(x);
        %        t1(1:length(t1),2)=coeffofvariationCh1; %1;
        t2=ch2(:,binAnalysis); t2=nanmean(t2')';
        t4=ch4(:,binAnalysis); t4=nanmean(t4')';
        t3=ch3(:,binAnalysis); t3=nanmean(t3')';
        
        t2(1:length(t2),2)=0.25; %2;
        t3(1:length(t3),2)=0.5; %3;
        t4(1:length(t4),2)=0.75; %4;
        temp=[t2; t3; t4;];
        P=kruskalwallis(temp(:,1),temp(:,2),'off');
        [pval, r]=permutation_pair_test_fast(temp(:,1),temp(:,2),shuffletime,'corr'); %rankcorr for non parametric rank based; corr is linear
        %
        if pval==0
            pval=0.000000001;
        end
        if P==0
            pval=0.000000001;
        end
        PvalueSaveCor=[PvalueSaveCor; -log10(pval)];
        PvalueSave=[PvalueSave; -log10(P)];
        SaveCor=[SaveCor; r];
        clear P t1 t2 t3 t4 t5 t6 temp PlotPvalue pval r
    end
    savestruct(xzv).LOGPvalueSaveCor=PvalueSaveCor;
    savestruct(xzv).LOGPvalueSave=PvalueSave;
    savestruct(xzv).SaveCor=SaveCor;
    clear SaveCor PvalueSave PvalueSaveCor
    
    
    [r,p]=rocarea3(SDFtiming(trials6201nd,6000:9000),SDFtiming(trials6201n,6000:9000));
    savestruct(xzv).Roc_RPE=r; savestruct(xzv).LOGRoc_RPEp=-log10(p);
  
    sizeval=min([length(trials6103_25l) length(trials6101_25s)]);
    [r,p]=rocarea3(SDFtiming([trials6101_75l(1:sizeval) trials6102_50l(1:sizeval) trials6103_25l(1:sizeval)],6000:9000),SDFtiming([trials6101_25s(1:sizeval) trials6102_50s(1:sizeval) trials6103_75s(1:sizeval)],6000:9000));
    savestruct(xzv).tRoc_RPE=r; savestruct(xzv).LOGtRoc_RPEp=-log10(p);
    
    
    normtemp=[SDFtiming;];
    normtemp=nanmean(nanmean(normtemp(:,5000-500:5000-100)));
    SavingLim=[6000:12000];
    %normtemp=0;
    
    tt=    trials6104;
    if length(tt)==1
        tt=[tt; tt];
    end
    savestruct(xzv).s6104=nanmean(SDFtiming(tt,SavingLim))-normtemp;
    
    tt=    trials6201n;
    if length(tt)==1
        tt=[tt; tt];
    end
    savestruct(xzv).s6201d=nanmean(SDFtiming(tt,SavingLim))-normtemp;
    
    tt=    trials6201nd;
    if length(tt)==1
        tt=[tt; tt];
    end
    savestruct(xzv).s6201nd=nanmean(SDFtiming(tt,SavingLim))-normtemp;
    
    
%     savestruct(xzv).sTimingD=nanmean(SDFtiming([trials6101_25s trials6102_50s trials6103_75s],SavingLim))-normtemp;
%     savestruct(xzv).sTimingND=nanmean(SDFtiming([trials6101_75l trials6102_50l trials6103_25l],SavingLim))-normtemp;
%     
%     tempvals=(savestruct(xzv).sTimingD-savestruct(xzv).sTimingND);
%     tempvals=tempvals-min(tempvals);
%     tempvals=tempvals./max(tempvals);
%     savestruct(xzv).sTimingDelVNotDel=tempvals(1:2000);
%     clear tempvals
    
    
    tt=    trials6101_25s;
    if length(tt)==1
        tt=[tt; tt];
    end
    savestruct(xzv).s6101_25s=nanmean(SDFtiming(tt,SavingLim))-normtemp;
    
    tt=    trials6102_50s;
    if length(tt)==1
        tt=[tt; tt];
    end
    savestruct(xzv).s6102_50s=nanmean(SDFtiming(tt,SavingLim))-normtemp;
    
    tt=    trials6103_75s;
    if length(tt)==1
        tt=[tt; tt];
    end
    savestruct(xzv).s6103_75s=nanmean(SDFtiming(tt,SavingLim))-normtemp;
    
    
    tt=    trials6101_75l;
    if length(tt)==1
        tt=[tt; tt];
    end
    savestruct(xzv).s6101_75l=nanmean(SDFtiming(tt,SavingLim))-normtemp;
    
    tt=    trials6102_50l;
    if length(tt)==1
        tt=[tt; tt];
    end
    savestruct(xzv).s6102_50l=nanmean(SDFtiming(tt,SavingLim))-normtemp;
    
    tt=    trials6103_25l;
    if length(tt)==1
        tt=[tt; tt];
    end
    savestruct(xzv).s6103_25l=nanmean(SDFtiming(tt,SavingLim))-normtemp;
    
    
    tt=    trials6105_25s;
    if length(tt)==1
        tt=[tt; tt];
    end
    savestruct(xzv).s6105_25s=nanmean(SDFtiming(tt,SavingLim))-normtemp;
    
    tt=    trials6105_25ms;
    if length(tt)==1
        tt=[tt; tt];
    end
    savestruct(xzv).s6105_25ms=nanmean(SDFtiming(tt,SavingLim))-normtemp;
    
    
    tt=    trials6105_25ml;
    if length(tt)==1
        tt=[tt; tt];
    end
    savestruct(xzv).s6105_25ml=nanmean(SDFtiming(tt,SavingLim))-normtemp;
    
    
    tt=    trials6105_25l;
    if length(tt)==1
        tt=[tt; tt];
    end
    savestruct(xzv).s6105_25l=nanmean(SDFtiming(tt,SavingLim))-normtemp;
    

    
    
    norm=nanmean(SDFtiming(trials6101_75l,6000:9000));
    A1=SDFtiming(trials6101_25s,6000:9000);
    ch4 = A1 - norm(ones(size(A1,1),1),:);
    ch44=SDFtiming([trials6101_25s trials6101_75l],6300:7500);
    %
    norm=nanmean(SDFtiming(trials6102_50l,6000:9000));
    A1=SDFtiming(trials6102_50s,6000:9000);
    ch3 = A1 - norm(ones(size(A1,1),1),:);
    ch33=SDFtiming([trials6102_50s trials6102_50l],6300:7500);
    
    %
    norm=nanmean(SDFtiming(trials6103_25l,6000:9000));
    A1=SDFtiming(trials6103_75s,6000:9000);
    ch2 = A1 - norm(ones(size(A1,1),1),:);
    ch22=SDFtiming([trials6103_75s trials6103_25l],6300:7500);
    
    
    
    region=[1600:1850];
    response25=nanmean(ch4(:,region)');
    response50=nanmean(ch3(:,region)');
    response75=nanmean(ch2(:,region)');
    
    %regionrr=[300:1500];
    response25rr=nanmean(ch44');
    response50rr=nanmean(ch33');
    response75rr=nanmean(ch22');
    
    %    region2=[100:350];
    %    response25_long=nanmean(ch5(:,region2)')
    %    response50_long=nanmean(ch6(:,region2)')
    %    response75_long=nanmean(ch7(:,region2)')
    
    try
        savestruct(xzv).ranksum75v50=ranksum(response75,response50);
        savestruct(xzv).ranksum25v50=ranksum(response25,response50);
        
        savestruct(xzv).rocarea375v50=rocarea3(response75',response50');
        savestruct(xzv).rocarea325v50=rocarea3(response50',response25');
        
        savestruct(xzv).rocarea375v50rr=rocarea3(response75rr',response50rr');
        savestruct(xzv).rocarea325v50rr=rocarea3(response50rr',response25rr');
        
        savestruct(xzv).response25rr=(response25rr);
        savestruct(xzv).response50rr=(response50rr);
        savestruct(xzv).response75rr=(response75rr);
        
                
        savestruct(xzv).response25=(response25);
        savestruct(xzv).response50=(response50);
        savestruct(xzv).response75=(response75);
        
    catch
        savestruct(xzv).ranksum75v50=NaN;
        savestruct(xzv).ranksum25v50=NaN;
        
        
        savestruct(xzv).rocarea375v50=NaN;
        savestruct(xzv).rocarea325v50=NaN;
    end
    
    try
        t2=response75';
        t3=response50';
        t4=response25';
        t2(1:length(t2),2)=0.25; %put in value to run correlation
        t3(1:length(t3),2)=0.5;
        t4(1:length(t4),2)=0.75;
        temp=[t2; t3; t4;];
        savestruct(xzv).Pacrossresponses=kruskalwallis(temp(:,1),temp(:,2),'off');
        [pval, r]=permutation_pair_test_fast(temp(:,1),temp(:,2),shuffletime,'corr'); %rankcorr for non parametric rank based; corr is linear
        savestruct(xzv).Pc=pval;
        savestruct(xzv).Rc=r;
        clear r pval t2 t3 t4 temp
    catch
        savestruct(xzv).Pacrossresponses=NaN;
        savestruct(xzv).Pc=NaN;
        savestruct(xzv).Rc=NaN;
    end
    
    
    
    try
        t2=response75rr';
        t3=response50rr';
        t4=response25rr';
        t2(1:length(t2),2)=0.25; %put in value to run correlation
        t3(1:length(t3),2)=0.5;
        t4(1:length(t4),2)=0.75;
        temp=[t2; t3; t4;];
        savestruct(xzv).Pacrossresponses_rr=kruskalwallis(temp(:,1),temp(:,2),'off');
        [pval, r]=permutation_pair_test_fast(temp(:,1),temp(:,2),shuffletime,'corr'); %rankcorr for non parametric rank based; corr is linear
        savestruct(xzv).Pc_rr=pval;
        savestruct(xzv).Rc_rr=r;
        clear r pval t2 t3 t4 temp
    catch
        savestruct(xzv).Pacrossresponses_rr=NaN;
        savestruct(xzv).Pc_rr=NaN;
        savestruct(xzv).Rc_rr=NaN;
    end
    %{
   try
        t2=response75_long';
        t3=response50_long';
        t4=response25_long';
        t2(1:length(t2),2)=0.25; %put in value to run correlation
        t3(1:length(t3),2)=0.5;
        t4(1:length(t4),2)=0.75;
        temp=[t2; t3; t4;];
        savestruct(xzv).Pacrossresponses_long=kruskalwallis(temp(:,1),temp(:,2),'off');
        [pval, r]=permutation_pair_test_fast(temp(:,1),temp(:,2),shuffletime,'corr'); %rankcorr for non parametric rank based; corr is linear
        savestruct(xzv).Pc_long=pval;
        savestruct(xzv).Rc_long=r;
        clear r pval t2 t3 t4 temp
    catch
        savestruct(xzv).Pacrossresponse_longs=NaN;
        savestruct(xzv).Pc_long=NaN;
        savestruct(xzv).Rc_long=NaN;
    end
    %}
    
    
    
    
    
    %{
    savestruct(xzv).RunningROC=RunningROC;
    savestruct(xzv).RunningROCP=RunningROCP;
    savestruct(xzv).RunningROCrpe=RunningROCrpe;
    savestruct(xzv).RunningROCPrpe=RunningROCPrpe;
    %}
    %
    %
    %
    %     region=[1600:1850]
    %     response25=nanmean(ch4(:,region)');
    %     response50=nanmean(ch3(:,region)');
    %     response75=nanmean(ch2(:,region)');
    %
    %
    %
    %     try
    %         savestruct(xzv).ranksum75v50=ranksum(response75,response50);
    %         savestruct(xzv).ranksum25v50=ranksum(response25,response50);
    %
    %         savestruct(xzv).rocarea375v50=rocarea3(response75',response50');
    %         savestruct(xzv).rocarea325v50=rocarea3(response50',response25');
    %
    %     catch
    %         savestruct(xzv).ranksum75v50=NaN;
    %         savestruct(xzv).ranksum25v50=NaN;
    %
    %
    %         savestruct(xzv).rocarea375v50=NaN;
    %         savestruct(xzv).rocarea325v50=NaN;
    %
    %     end
    %
    %     try
    %         t2=response75';
    %         t3=response50';
    %         t4=response25';
    %         t2(1:length(t2),2)=0.25; %put in value to run correlation
    %         t3(1:length(t3),2)=0.5;
    %         t4(1:length(t4),2)=0.75;
    %         temp=[t2; t3; t4;];
    %         savestruct(xzv).Pacrossresponses=kruskalwallis(temp(:,1),temp(:,2),'off');
    %         [pval, r]=permutation_pair_test_fast(temp(:,1),temp(:,2),shuffletime,'corr'); %rankcorr for non parametric rank based; corr is linear
    %         savestruct(xzv).Pc=pval;
    %         savestruct(xzv).Rc=r;
    %         clear r pval t2 t3 t4 temp
    %     catch
    %         savestruct(xzv).Pacrossresponses=NaN;
    %         savestruct(xzv).Pc=NaN;
    %         savestruct(xzv).Rc=NaN;
    %     end
    %
    
    close all;
    clear PDS roc proc A1 A2 ch1 ch2 ch3 ch3 p r 
    
    
  end
  if strcmpi(str,'BFphas')
      save timingproceduresummary3monksBF_phasic.mat savestruct
  elseif strcmpi(str,'BF')
      save timingproceduresummary3monksBF_tonic.mat savestruct
  elseif strcmpi(str,'BG')
      save timingproceduresummary3monksBG.mat savestruct
  end
