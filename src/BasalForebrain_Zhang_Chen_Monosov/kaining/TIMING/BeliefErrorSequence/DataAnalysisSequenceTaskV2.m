function Converter

clear all; clc; close all; beep off;
GauSw=101;
WindowA_=[201:400];
WindowA2_=[51:400];


addpath('HELPER_GENERAL');

addpath('X:\MONKEYDATA\Batman\SequenceLearning\neurons\');
D=dir ('X:\MONKEYDATA\Batman\SequenceLearning\neurons\S*.mat');
for x=1:size(D,1)
    D(x).TYPE='phasic'
    D(x).monkeyid='b'
end

addpath('X:\MONKEYDATA\Robin_ongoing\SequenceLearning\neurons\phasic\');
D1=dir ('X:\MONKEYDATA\Robin_ongoing\SequenceLearning\neurons\phasic\S*.mat');
for x=1:size(D1,1)
    D1(x).TYPE='phasic'
    D1(x).monkeyid='r'
end

addpath('X:\MONKEYDATA\Robin_ongoing\OldSequenceLearning\neurons\');
D2=dir ('X:\MONKEYDATA\Robin_ongoing\OldSequenceLearning\neurons\S*.mat');
for x=1:size(D2,1)
    D2(x).TYPE='phasic'
    D2(x).monkeyid='r'
end

addpath('X:\MONKEYDATA\ZOMBIE_ongoing\BF_SequenceLearning\Phasic\');
D3=dir ('X:\MONKEYDATA\ZOMBIE_ongoing\BF_SequenceLearning\Phasic\S*.mat');
for x=1:size(D3,1)
    D3(x).TYPE='phasic'
    D3(x).monkeyid='z'
end

addpath('X:\MONKEYDATA\ZOMBIE_ongoing\BF_SequenceLearning\Ramping\');
D4=dir ('X:\MONKEYDATA\ZOMBIE_ongoing\BF_SequenceLearning\Ramping\S*.mat');
for x=1:size(D4,1)
    D4(x).TYPE='tonic'
    D4(x).monkeyid='z'
end

addpath('X:\MONKEYDATA\Robin_ongoing\SequenceLearning\neurons\tonic\');
D5=dir ('X:\MONKEYDATA\Robin_ongoing\SequenceLearning\neurons\tonic\S*.mat');
for x=1:size(D5,1)
    D5(x).TYPE='tonic'
    D5(x).monkeyid='z'
end

D=[D; D1; D2; D3; D4; D5];

SDFSS=[]; FamSS=[]; NovSS=[]; BEsave=[]; NoBEsave=[]; BEsave_Nov1=[]; noBEsave_Nov1=[]; BEsave_Nov3=[]; noBEsave_Nov3=[];
ROCbe=[]; ROCbeP=[];
SingleBE=[]; NovUseful=[]; NovNotUseful=[]; SetVersusSet2=[];

for x_file=1:length(D)
    clc;
    clear PDS;
    load(D(x_file).name,'PDS');
    savestruct(x_file).name=D(x_file).name;
    
     savestruct(x_file).monkeyid=D(x_file).monkeyid;
     savestruct(x_file).TYPE=D(x_file).TYPE;

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
        %spk=PDS(1).sptimes{x}-PDS(1).timeoutcome(x);
        
        spike_times = PDS.sptimes{x}(PDS.spikes{x} == 65535)
        spk=spike_times-PDS(1).timeoutcome(x);
        
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
    SDFcs=SDFcs(:,1000:end);
    
    %1 - box car; 2- gaus; 3 - epsp (causal); specs of kernel are defined in Smooth_Histogram function
    ForwardSDF=Smooth_Histogram(Rasters,3);
    ztemp=ForwardSDF(trials,:);
    ForwardSDF=(ForwardSDF-nanmean(ztemp(:)));
    ForwardSDF=ForwardSDF./nanstd(ztemp(:));
    
    Rasters_=Rasters;
    Rasters=Rasters(:,1000:end);
    %%%
    %%%

    if isempty(NoBeliefErrors)==0
        t=NoBeliefErrors;
    else
        t=trials;
    end
    
    
    FamS=[]; NovS=[];
    FamSa=[];
    for x=1:length(t)
        x=t(x);
        Nov=ForwardSDF(x,2001:3000);
        Novb=ForwardSDF(x,2000-100:2000);
        Fam=nanmean([
            ForwardSDF(x,1001:2000);
            ForwardSDF(x,3001:4000);
            ForwardSDF(x,4001:5000);
            ]);        
        Famb=nanmean([
            ForwardSDF(x,1000-100:1000);
            ForwardSDF(x,3000-100:3000);
            ForwardSDF(x,4000-100:4000)
            ]);
        Fama=nanmean([
            ForwardSDF(x,3001:4000);
            ForwardSDF(x,4001:5000);
            ]);
        Famba=nanmean([
            ForwardSDF(x,3000-100:3000);
            ForwardSDF(x,4000-100:4000)
            ]);  
        FamS=[FamS; Fam-nanmean(Famb)];
        FamSa=[FamSa; Fama-nanmean(Famba)];
        NovS=[NovS; Nov-nanmean(Novb)];
        clear Fam Nov x BE_ Fama Famba
    end
       
%     figure
%     subplot(4,1,1)
%     plot( nanmean(FamS)    ); hold on
%     plot( nanmean(NovS),'r'); hold on
%     subplot(4,1,2)
%     plot(rocarea3(FamS,NovS))
%     subplot(4,1,3)
%     [r,p]=rocarea3(FamS,NovS);
%     plot(-log10(p))
%     subplot(4,1,4)
%     plot(nanmean(ForwardSDF(t,:)))
%     close all;

    FamSa=nanmean(FamSa);
    FamS=nanmean(FamS);
    NovS=nanmean(NovS);
    savestruct(x_file).FamSSa=FamSa;
    savestruct(x_file).FamSS=FamS;
    savestruct(x_file).NovSS=NovS;
    savestruct(x_file).SDFcs= nanmean(SDFcs(t,:));
    

    
  
    if length(slowRTsTrials)>4 & length(fastRTsTrials)>4
        savestruct(x_file).SDFcsSlow= nanmean(SDFcs(slowRTsTrials,:));
        savestruct(x_file).SDFcsFast= nanmean(SDFcs(fastRTsTrials,:));
    else
        temp(1:4002)=NaN;
        savestruct(x_file).SDFcsSlow= temp;
        savestruct(x_file).SDFcsFast= temp;
    end
    
    WindowA2_
    clear p temp FamS NovS
    FamS=[]; NovS=[]; FamSa=[];
    for x=1:length(t)
        x=t(x);
        Fam=nanmean([nansum(Rasters(x,2000+WindowA2_)) nansum(Rasters(x,3000+WindowA2_)) nansum(Rasters(x,0+WindowA2_))]);
        Fama=nanmean([ nansum(Rasters(x,2000+WindowA2_)) nansum(Rasters(x,3000+WindowA2_)) ]);
        Nov=nansum(Rasters(x,1000+WindowA2_));
        
        Famba=nanmean([ nansum(Rasters(x,2000-100:2000)) nansum(Rasters(x,3000-100:3000)) ]);
        Famb=nanmean([nansum(Rasters(x,2000-100:2000)) nansum(Rasters(x,3000-100:3000)) nansum(Rasters_(x,1000-100:1000))]);
        Novb=nansum(Rasters(x,1000-100:1000));

        FamSa=[FamSa; Fama-(Famba')];
        FamS=[FamS; Fam-(Famb')];
        NovS=[NovS; Nov-(Novb')];
        clear Fam Nov x BE_ Famb Novb Fama Famba
    end
    [savestruct(x_file).Nov_ra,savestruct(x_file).Nov_pa]=rocarea3(FamSa, NovS);
    [savestruct(x_file).Nov_r,savestruct(x_file).Nov_p]=rocarea3(FamS, NovS);
    savestruct(x_file).FamSSa_=nanmean(FamSa);
    savestruct(x_file).FamSS_=nanmean(FamS);
    savestruct(x_file).NovSS_=nanmean(NovS);

    clear FamS NovS FamSOne FamSThree FamSTwo temp x t FamSa

    
    
    
    
    if isempty(Set1Trials)~=1
        
        savestruct(x_file).SDFcs1= nanmean(SDFcs((Set1Trials),:));
        savestruct(x_file).SDFcs2= nanmean(SDFcs((Set2Trials),:));

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
 
        t1=nanmean (nansum(Rasters(Set2Trials,1000+WindowA_)') - nanmean(nansum(Rasters(Set2Trials,1000-100:1000)')));
        t2=nanmean(nansum(Rasters(Set1Trials,1000+WindowA_)') - nanmean(nansum(Rasters(Set1Trials,1000-100:1000)')));
        t3= nanmean ( nansum([Rasters(Set2Trials,2000+WindowA_)' Rasters(Set2Trials,3000+WindowA_)']) ) - nanmean ( nansum([Rasters(Set2Trials,2000-100:2000)' Rasters(Set2Trials,3000-100:3000)']) );
        t4= nanmean ( nansum([Rasters(Set1Trials,2000+WindowA_)' Rasters(Set1Trials,3000+WindowA_)']) ) - nanmean ( nansum([Rasters(Set1Trials,2000-100:2000)' Rasters(Set1Trials,3000-100:3000)']) );

        savestruct(x_file).NovUseful_= t1;
        savestruct(x_file).NovNotUseful_= t2;
        savestruct(x_file).NovUsefulFam_=t3;
        savestruct(x_file).NovNotUsefulFam_=t4;   
        clear t1 t2 t3 t4 temp t5 t6
     
    end
 
    BEALL=[BEPos1; BEPos2];
    if length(BEALL)>2 & length(BEPos1)>0 & length(BEPos2)>0
        range1=WindowA_%[201:400];
        range2=WindowA_+2000; %[2201:2400];
        
        savePs=[];
        for dothis=1:1
            B1=Rasters(BEPos1,range1);%-AveragePreFirstF;
            B2=Rasters(BEPos2,range2);%-nanmean(nanmean(SDFcs(:,2000-100:2000)'));
            BEfiring=([(nansum(B1')) (nansum(B2'))]);
            clear B1 B2
            
            NoBeliefErrors=randperm(length(NoBeliefErrors));
            NoBeliefErrors=randperm(length(NoBeliefErrors));
            NoBeliefErrors=randperm(length(NoBeliefErrors));
            
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

save savedataAll.mat savestruct



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%SUBFUNCTION : SMOOTH_IT%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Hist_Smooth=Smooth_Histogram(Hist_Raw,Smoothing)
switch Smoothing
case 1
%   disp('Convolving with BOXCAR of BINSIZE=20ms')
   BinSize=20;
   Half_BW=(round(BinSize)/2);
   BinSize=Half_BW*2;
   Kernel=ones(1,(Half_BW*2)+1);
   Kernel=Kernel.*1000/sum(Kernel);
case 2
%   disp('Convolving with GAUSSIAN of SIGMA=5ms')
   Sigma=100;
   Kernel=[-5*Sigma:5*Sigma];
   BinSize=length(Kernel);
   Half_BW=(BinSize-1)/2;
   Kernel=[-BinSize/2:BinSize/2];   
   Factor=1000/(Sigma*sqrt(2*pi));
   Kernel=Factor*(exp(-(0.5*((Kernel./Sigma).^2))));
case 3
%   disp('Convolving with EPSP of GROWTH=1ms and DECAY=20ms')
   Growth=1;
   Decay=20;
   Half_BW=round(Decay*8);
   BinSize=(Half_BW*2)+1;
   Kernel=[0:Half_BW];
   Half_Kernel=(1-(exp(-(Kernel./Growth)))).*(exp(-(Kernel./Decay)));
   Half_Kernel=Half_Kernel./sum(Half_Kernel);
   Kernel(1:Half_BW)=0;
   Kernel(Half_BW+1:BinSize)=Half_Kernel;
   Kernel=Kernel.*1000;
otherwise
end
Hist_Raw=Hist_Raw';%Make Hist_Raw Rows(which are Trials) to columns
Kernel=Kernel'; %make Kernel to a column vector 
%Now Convolve Hist_raw columns with Column Kernel
Hist_Smooth=convn(Hist_Raw,Kernel,'same');
[mrows mcols]=size(Hist_Smooth);
Hist_Smooth=(Hist_Smooth)';






