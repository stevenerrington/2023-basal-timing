clear all; close all; clc; beep off;
addpath('HELPER_GENERAL');

for i = 1:2
    switch i;
        case 1
            str='BFRamping'
        case 2
            str='BFphas'
    end
    
    
    CENTER=6001;
    shuffletime=100;
    gauswindow_ms=100;
    %%%%%%%%%Use excelsheet to load neuron
    if strcmpi(str, 'BFphas')
        str_celltype = 'Phasic'
    elseif strcmpi(str, 'BFramping')
        str_celltype = 'Ramping'
    else
        error('Inputs must be ''BFphas'' or ''BFramping'' (case insensitive)')
    end
    
    [~,~,neuronsheet] = xlsread('X:\Kaining\BF_neuron_sheet');
    excel_celltype = find(strcmp(neuronsheet(1,:),'Cell Type'));
    excel_Area = find(strcmp(neuronsheet(1,:),'Area'));
    excel_monkeyid = find(strcmp(neuronsheet(1,:),'Monkey'));
    excel_ProbAmt = find(strcmp(neuronsheet(1,:),'ProbAmt2575'));
    excel_ProbAmtdir = find(strcmp(neuronsheet(1,:),'ProbAmt2575dir'));
    excel_TimingP = find(strcmp(neuronsheet(1,:),'Timingprocedure'));
    excel_TimingPdir = find(strcmp(neuronsheet(1,:),'Timingproceduredir'));
    
    DDD = [];
    errorDDD = [];
    for i = 2 : size(neuronsheet,1)
        if strcmp(neuronsheet{i,excel_Area},'BF') && (strcmp(neuronsheet{i,excel_celltype},str_celltype))...
                && length(neuronsheet{i,excel_TimingP})>1% && length(neuronsheet{i,excel_ProbAmt})<=1
            tp.name = [neuronsheet{i,excel_TimingP},'.mat'];
            tp.folder = neuronsheet{i,excel_TimingPdir};
            if strcmpi(neuronsheet{i,excel_celltype},'Negphasic')
                tp.MONKEYID = [neuronsheet{i,excel_monkeyid},'_'];
            else
                tp.MONKEYID = neuronsheet{i,excel_monkeyid};
            end
            
            addpath(tp.folder);
            if exist(tp.name)
                DDD = [DDD;tp];
            else
                errorDDD = [errorDDD,tp];
            end
            clear tp;
            
        end
    end
    D=DDD;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % addpath('C:\Users\Ilya\Dropbox\HELPER\HELPER_GENERAL');
    % addpath('C:\Users\Ilya Monosov\Dropbox\HELPER\HELPER_GENERAL');
    %
    %
    %
    % addpath('C:\Users\Ilya\Desktop\BF\Timing\Robin\BFtonic\');
    % addpath('C:\Users\Ilya\Desktop\BF\Timing\Wolverine\tonic\');
    % addpath('C:\Users\Ilya\Desktop\BF\Timing\Batman\tonic\');
    %
    %
    % addpath('C:\Users\Ilya\Desktop\BF\Timing\Robin\BFphasic\');
    % addpath('C:\Users\Ilya\Desktop\BF\Timing\Batman\phasic\');
    %
    % addpath('X:\MONKEYDATA\Batman\Timingprocedure_Basilforebrain\BFphasic\');
    % addpath('X:\MONKEYDATA\Robin_ongoing\TimingProcedureBF\BFphasic\');
    % addpath('X:\MONKEYDATA\Robin_ongoing\TimingProcedureBF\BFtonic\');
    % addpath('X:\Charlie\TimingProcedureWBF\TimingProcedure\');
    %
    %
    % addpath('X:\MONKEYDATA\Batman\Timingprocedure_Basilforebrain\BFphasic\');
    % addpath('X:\MONKEYDATA\Robin_ongoing\TimingProcedureBF\BFtonic\');
    % addpath('C:\Users\Ilya Monosov\Desktop\BFtonic\');
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % if strcmpi(str,'BFramping')
    %
    %     addpath('X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingProcedure\BFramping\');
    %     D=dir ('X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingProcedure\BFramping\*.mat');
    %     for x=1:size(D,1)
    %         D(x).MONKEYID='wolverine'
    %     end
    %
    %     addpath('X:\MONKEYDATA\Batman\Timingprocedure_Basilforebrain\BFtonic\');
    %     D1=dir ('X:\MONKEYDATA\Batman\Timingprocedure_Basilforebrain\BFtonic\*.mat');
    %     for x=1:size(D1,1)
    %         D1(x).MONKEYID='batman'
    %     end
    %
    %     addpath('X:\MONKEYDATA\Robin_ongoing\TimingProcedureBF\BFtonic\');
    %     D2=dir ('X:\MONKEYDATA\Robin_ongoing\TimingProcedureBF\BFtonic\*.mat');
    %     for x=1:size(D2,1)
    %         D2(x).MONKEYID='robin'
    %     end
    %
    %     addpath('Y:\MONKEYDATA\ZOMBIE_ongoing\BF_timingprocejure\Ramping\');
    %     D3=dir ('Y:\MONKEYDATA\ZOMBIE_ongoing\BF_timingprocejure\Ramping\*.mat');
    %     for x=1:size(D3,1)
    %         D3(x).MONKEYID='zombie'
    %     end
    %     D=[D; D1; D2; D3;]; clear D1 D2 D3
    %
    %
    % elseif strcmpi(str,'BG')
    %
    %     D=dir ('\\128.252.37.174\Share1\Charlie\TimingProcedureWBG\TimingProcedure*.mat');
    %     D1=dir ('\\128.252.37.174\Share1\Charlie\TimingProcedureBBG\TimingProcedure*.mat');
    %     D2=dir ('\\128.252.37.174\Share1\Charlie\TimingProcedureRBG\TimingProcedure*.mat');
    %     D=[D; D1; D2;]; clear D1 D2
    %
    % elseif strcmpi(str,'BFphas')
    %
    %     D=dir ('X:\MONKEYDATA\Robin_ongoing\TimingProcedureBF\BFphasic\*.mat');
    %     for x=1:size(D,1)
    %         D(x).MONKEYID='robin'
    %     end
    %
    %     D1=dir ('X:\MONKEYDATA\Batman\Timingprocedure_Basilforebrain\BFphasic\*.mat');
    %     for x=1:size(D1,1)
    %         D1(x).MONKEYID='batman'
    %     end
    %
    %     D2=dir ('X:\MONKEYDATA\ZOMBIE_ongoing\BF_timingprocejure\Phasic\*.mat');
    %     addpath('X:\MONKEYDATA\ZOMBIE_ongoing\BF_timingprocejure\Phasic\');
    %     for x=1:size(D2,1)
    %         D2(x).MONKEYID='zombie'
    %     end
    %
    %     D=[D; D1; D2]; clear D1 D2 D3
    %
    %
    % else
    %     error('Inputs must be ''BF'' or ''BG'' (case insensitive)')
    % end
    
    
    savestruct = [];
    
    for xzv=1:length(D)
        
        load(D(xzv).name,'PDS');
        savestruct(xzv).name=D(xzv).name;
        savestruct(xzv).monkey=D(xzv).MONKEYID;
        
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
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             %CLEAR REWARD NOISE
%             CLEAN=[trials6101 trials6102 trials6103 trials6104 trials6105];
%             for x=1:length(CLEAN)
%                 x=CLEAN(x);
%                 %spk=PDS(1).sptimes{x};
%                 
%                 spk = PDS.sptimes{x}(PDS.spikes{x} == 65535)
%    %spk=spike_times-PDS(1).timeoutcome(x);
%                 
%                 spk1=spk(find(spk<PDS.timeoutcome(x)));
%                 spk2=spk(find(spk>PDS.timeoutcome(x)+10/1000));
%                 spk=[spk1 spk2]; clear spk1 spk2
%                 %
%                 try
%                     no_noise=find(spk>(PDS.timeoutcome(x)+(10/1000)) & spk<(PDS.timeoutcome(x)+(20/1000)));
%                     no_noise=length(no_noise); %this many spikes in the window  so insert that many spikes in the deleted time range
%                     grabnumbers=PDS.timeoutcome(x)+randperm(10)/1000;
%                     grabnumbers=grabnumbers(no_noise);
%                     spk=[spk grabnumbers];
%                 end
%                 PDS(1).sptimes{x}=sort(spk);
%                 %
%                 clear y spk spk1 spk2 x
%             end
%         
%         
%         
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Rasters=[];
        for x=1:length(durationsuntilreward)
            %

          %  try
           spk = PDS.sptimes{x}(PDS.spikes{x} == 65535);
           % catch
           %      spk=[];    
           % end
             spk=spk-PDS(1).timetargeton(x);

           
 
            
   
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
        
        
            %outcometime=13500; %switch this to the time of outcome in your task
            outcometime=7500;
            cleanreward50n=intersect(trials6201,ndeliv); %prob50 are the 6201 trials
            cleanreward50=intersect(trials6201,deliv);
        
            for x=1:length(cleanreward50)
                spk_dirty=Rasters(cleanreward50(x),:);
        
                cleanreward50n=cleanreward50n(randperm(length(cleanreward50n)));
                spk_clean=Rasters(cleanreward50n(1),:);
        
                spk_dirty(outcometime-25:outcometime+25)=spk_clean(outcometime-25:outcometime+25);
                Rasters(cleanreward50(x),:)=spk_dirty;
                clear spk_dirty spk_clean x
            end
        
        
        %Rasters_=Rasters;
        Rasterscs = Rasters(:,CENTER-5000:end);
        SDFtiming=plot_mean_psth({Rasterscs},gauswindow_ms,1,size(Rasterscs,2)-1,1);
        clear Rasters
        %Rasters_=Rasters_([trials6101 trials6102 trials6103 trials6104],:);
        %Rasters_=Rasters_'; Rasters_=Rasters_(:);
        
        %Average rasters in Bins
        binwindow = [0:50];
        binstep = 20;
        BinRasters = [];
        Bintime = [];
        
        for i = 1: floor((length(Rasterscs)-length(binwindow))/binstep)+1
            iii = (i-1)*binstep+1;
            BinRasters(:,i) = sum(Rasterscs(:, iii+binwindow),2)./length(binwindow)*1000;
            Bintime(1,i) = iii+median(binwindow)/2-5000; % align 0 on the appearing of fractals
        end
        
        
        
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        trialsTrials=[trials6101 trials6102 trials6103 trials6104 trials6105 trials6201];
        ITIfiringrate=SDFtiming(trialsTrials,3050:3750);
        ITIfiringrate=nanmean(ITIfiringrate);
        ITIfiringrate=nanmean(ITIfiringrate,2);
        savestruct(xzv).ITIfiringrate=ITIfiringrate;
        
        %%%%%%%%%%
        %%%%%%%%%%
        
        
        
        
        %     PvalueSave=[];
        %     PvalueSaveCor=[];
        %     SaveCor=[];
        %
        %
        %
        %
        %     savestruct(xzv).LOGPvalueSaveCor=PvalueSaveCor;
        %     savestruct(xzv).LOGPvalueSave=PvalueSave;
        %     savestruct(xzv).SaveCor=SaveCor;
        %     clear SaveCor PvalueSave PvalueSaveCor
        
        
        normtemp=[SDFtiming;];
        normtemp=nanmean(nanmean(normtemp(:,4000-500:4000-100)));
        savestruct(xzv).baseline = normtemp;
        SavingLim=[3500:11000];
        %normtemp=0;
        
        tt=    trials6104;
        if length(tt)==1
            tt=[];
        end
        savestruct(xzv).s6104=nanmean(SDFtiming(tt,SavingLim));
        
        tt=    trials6201;
        if length(tt)==1
            tt=[];
        end
        savestruct(xzv).s6201=nanmean(SDFtiming(tt,SavingLim));
        
        tt=    trials6101;
        if length(tt)==1
            tt=[];
        end
        savestruct(xzv).s6101=nanmean(SDFtiming(tt,SavingLim));
        
        tt=    trials6102;
        if length(tt)==1
            tt=[];
        end
        savestruct(xzv).s6102=nanmean(SDFtiming(tt,SavingLim));
        
        tt=    trials6103;
        if length(tt)==1
            tt=[];
        end
        savestruct(xzv).s6103=nanmean(SDFtiming(tt,SavingLim));
        
        tt=    trials6105;
        if length(tt)==1
            tt=[];
        end
        savestruct(xzv).s6105=nanmean(SDFtiming(tt,SavingLim));
        
        tt=    trials6201n;
        if length(tt)==1
            tt=[];
        end
        savestruct(xzv).s6201d=nanmean(SDFtiming(tt,SavingLim));
        
        tt=    trials6201nd;
        if length(tt)==1
            tt=[];
        end
        savestruct(xzv).s6201nd=nanmean(SDFtiming(tt,SavingLim));
        
        
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
            tt=[];
        end
        savestruct(xzv).s6101_25s=nanmean(SDFtiming(tt,SavingLim));
        
        tt=    trials6102_50s;
        if length(tt)==1
            tt=[];
        end
        savestruct(xzv).s6102_50s=nanmean(SDFtiming(tt,SavingLim));
        
        tt=    trials6103_75s;
        if length(tt)==1
            tt=[];
        end
        savestruct(xzv).s6103_75s=nanmean(SDFtiming(tt,SavingLim));
        
        
        tt=    trials6101_75l;
        if length(tt)==1
            tt=[];
        end
        savestruct(xzv).s6101_75l=nanmean(SDFtiming(tt,SavingLim));
        
        tt=    trials6102_50l;
        if length(tt)==1
            tt=[];
        end
        savestruct(xzv).s6102_50l=nanmean(SDFtiming(tt,SavingLim));
        
        tt=    trials6103_25l;
        if length(tt)==1
            tt=[];
        end
        savestruct(xzv).s6103_25l=nanmean(SDFtiming(tt,SavingLim));
        
        
        tt=    trials6105_25s;
        if length(tt)==1
            tt=[];
        end
        savestruct(xzv).s6105_25s=nanmean(SDFtiming(tt,SavingLim));
        
        tt=    trials6105_25ms;
        if length(tt)==1
            tt=[];
        end
        savestruct(xzv).s6105_25ms=nanmean(SDFtiming(tt,SavingLim));
        
        
        tt=    trials6105_25ml;
        if length(tt)==1
            tt=[];
        end
        savestruct(xzv).s6105_25ml=nanmean(SDFtiming(tt,SavingLim));
        
        
        tt=    trials6105_25l;
        if length(tt)==1
            tt=[];
        end
        savestruct(xzv).s6105_25l=nanmean(SDFtiming(tt,SavingLim));
        
        %trial by trial sDFcs front fractal appearing-1000 to 1000+trialend
        popwindow = [5000-1000:11000];
        savestruct(xzv).raw_SDFcs_actp100R=SDFtiming(trials6104,popwindow);
        savestruct(xzv).raw_SDFcs_actp75R=SDFtiming(trials6103,popwindow);
        savestruct(xzv).raw_SDFcs_actp75dR=SDFtiming(trials6103_75s,popwindow);
        savestruct(xzv).raw_SDFcs_actp75ndR=SDFtiming(trials6103_25l,popwindow);
        savestruct(xzv).raw_SDFcs_actp50R=SDFtiming(trials6102,popwindow);
        savestruct(xzv).raw_SDFcs_actp50dR=SDFtiming(trials6102_50s,popwindow);
        savestruct(xzv).raw_SDFcs_actp50ndR=SDFtiming(trials6102_50l,popwindow);
        savestruct(xzv).raw_SDFcs_actp25R=SDFtiming(trials6101,popwindow);
        savestruct(xzv).raw_SDFcs_actp25dR=SDFtiming(trials6101_25s,popwindow);
        savestruct(xzv).raw_SDFcs_actp25ndR=SDFtiming(trials6101_75l,popwindow);
        savestruct(xzv).raw_SDFcs_actp50dR2=SDFtiming(trials6201n,popwindow);
        savestruct(xzv).raw_SDFcs_actp50ndR2=SDFtiming(trials6201nd,popwindow);
        
        %%%% calculate the raster spike
        popwindow=[5000-1000:11000];
        savestruct(xzv).raster_actp100R=nanmean(Rasterscs(trials6104,popwindow));
        savestruct(xzv).raster_actp75R=nanmean(Rasterscs(trials6103,popwindow));
        savestruct(xzv).raster_actp75dR=nanmean(Rasterscs(trials6103_75s,popwindow));
        savestruct(xzv).raster_actp75ndR=nanmean(Rasterscs(trials6103_25l,popwindow));
        savestruct(xzv).raster_actp50R=nanmean(Rasterscs(trials6102,popwindow));
        savestruct(xzv).raster_actp50dR=nanmean(Rasterscs(trials6102_50s,popwindow));
        savestruct(xzv).raster_actp50ndR=nanmean(Rasterscs(trials6102_50l,popwindow));
        savestruct(xzv).raster_actp25R=nanmean(Rasterscs(trials6101,popwindow));
        savestruct(xzv).raster_actp25dR=nanmean(Rasterscs(trials6101_25s,popwindow));
        savestruct(xzv).raster_actp25ndR=nanmean(Rasterscs(trials6101_75l,popwindow));
        savestruct(xzv).raster_actp50dR2=nanmean(Rasterscs(trials6201n,popwindow));
        savestruct(xzv).raster_actp50ndR2=nanmean(Rasterscs(trials6201nd,popwindow));
        
        %raw raster spike
        %front trial start-1000 to trialend+1000
        popwindow = [5000-1000:11000];
        savestruct(xzv).raw_raster_actp100R=Rasterscs(trials6104,popwindow);
        savestruct(xzv).raw_raster_actp75R=Rasterscs(trials6103,popwindow);
        savestruct(xzv).raw_raster_actp75dR=Rasterscs(trials6103_75s,popwindow);
        savestruct(xzv).raw_raster_actp75ndR=Rasterscs(trials6103_25l,popwindow);
        savestruct(xzv).raw_raster_actp50R=Rasterscs(trials6102,popwindow);
        savestruct(xzv).raw_raster_actp50dR=Rasterscs(trials6102_50s,popwindow);
        savestruct(xzv).raw_raster_actp50ndR=Rasterscs(trials6102_50l,popwindow);
        savestruct(xzv).raw_raster_actp25R=Rasterscs(trials6101,popwindow);
        savestruct(xzv).raw_raster_actp25dR=Rasterscs(trials6101_25s,popwindow);
        savestruct(xzv).raw_raster_actp25ndR=Rasterscs(trials6101_75l,popwindow);
        savestruct(xzv).raw_raster_actp50dR2=Rasterscs(trials6201n,popwindow);
        savestruct(xzv).raw_raster_actp50ndR2=Rasterscs(trials6201nd,popwindow);
        
        %Spike density in time bin
        %front trial start-1000 to trialend+1000
        popwindow = find (Bintime>=-1000 & Bintime<=4500+1500);
        savestruct(xzv).bin_time = Bintime(1,popwindow);
        savestruct(xzv).bin_actp100R=nanmean(BinRasters(trials6104,popwindow),1);
        savestruct(xzv).bin_actp75R=nanmean(BinRasters(trials6103,popwindow),1);
        savestruct(xzv).bin_actp75dR=nanmean(BinRasters(trials6103_75s,popwindow),1);
        savestruct(xzv).bin_actp75ndR=nanmean(BinRasters(trials6103_25l,popwindow),1);
        savestruct(xzv).bin_actp50R=nanmean(BinRasters(trials6102,popwindow),1);
        savestruct(xzv).bin_actp50dR=nanmean(BinRasters(trials6102_50s,popwindow),1);
        savestruct(xzv).bin_actp50ndR=nanmean(BinRasters(trials6102_50l,popwindow),1);
        savestruct(xzv).bin_actp25R=nanmean(BinRasters(trials6101,popwindow),1);
        savestruct(xzv).bin_actp25dR=nanmean(BinRasters(trials6101_25s,popwindow),1);
        savestruct(xzv).bin_actp25ndR=nanmean(BinRasters(trials6101_75l,popwindow),1);
        savestruct(xzv).bin_actp50dR2=nanmean(BinRasters(trials6201n,popwindow),1);
        savestruct(xzv).bin_actp50ndR2=nanmean(BinRasters(trials6201nd,popwindow),1);
        
        
        %Spike density in time bin(raw)
        %front trial start-1000 to trialend+1000
        popwindow = find (Bintime>=-1000 & Bintime<=4500+1500);
        savestruct(xzv).bin_time = Bintime(1,popwindow);
        savestruct(xzv).raw_bin_actp100R=BinRasters(trials6104,popwindow);
        savestruct(xzv).raw_bin_actp75R=BinRasters(trials6103,popwindow);
        savestruct(xzv).raw_bin_actp75dR=BinRasters(trials6103_75s,popwindow);
        savestruct(xzv).raw_bin_actp75ndR=BinRasters(trials6103_25l,popwindow);
        savestruct(xzv).raw_bin_actp50R=BinRasters(trials6102,popwindow);
        savestruct(xzv).raw_bin_actp50dR=BinRasters(trials6102_50s,popwindow);
        savestruct(xzv).raw_bin_actp50ndR=BinRasters(trials6102_50l,popwindow);
        savestruct(xzv).raw_bin_actp25R=BinRasters(trials6101,popwindow);
        savestruct(xzv).raw_bin_actp25dR=BinRasters(trials6101_25s,popwindow);
        savestruct(xzv).raw_bin_actp25ndR=BinRasters(trials6101_75l,popwindow);
        savestruct(xzv).raw_bin_actp50dR2=BinRasters(trials6201n,popwindow);
        savestruct(xzv).raw_bin_actp50ndR2=BinRasters(trials6201nd,popwindow);
        
        %%% z-score value
        popwindow = [5000-1000:5000+2500];
        savestruct(xzv).mean_for_zscore =  nanmean(nansum(Rasterscs(:,popwindow)'))./length(popwindow).*1000;
        savestruct(xzv).std_for_zscore = nanstd(nansum(Rasterscs(:,popwindow)'))./length(popwindow).*1000;
        
        
        %%%%%%Fanofactor
        
        RangeAn=[3500:10000];
        RastersFano=Rasterscs(:,RangeAn);
        trialtypesall=[ length(trials6102_50l)
            length(trials6103_25l)
            length(trials6101_75l)
            length(trials6201)
            ];
        fano6103inc= RastersFano (trials6103,:);
        fano6102inc= RastersFano (trials6102,:);
        fano6101inc= RastersFano (trials6101,:);
        fano6201inc= RastersFano (trials6201,:);
        fanoAllinc= RastersFano ([trials6101 trials6102 trials6103],:);
        
        fano6105= RastersFano (trials6105_25l,:);
        fano6103= RastersFano (trials6103_25l,:);
        fano6102= RastersFano (trials6102_50l,:);
        fano6101= RastersFano (trials6101_75l,:);
        fano6104= RastersFano (trials6104,:);
        fano6201= RastersFano (trials6201nd,:);
        fanoAll= RastersFano ([trials6101_75l trials6102_50l trials6103_25l],:); %%%%75 50 25 long dilivery.
        
        
        FanoSaveAll=[];
        FanoSaveAllinc=[];
        for x = 1:size(RastersFano,2)-100
            binAnalysis=[x:x+100];
            
            t= fanoAll(:,binAnalysis); t=nansum(t')';
            FanoSaveAll=[ FanoSaveAll; (std(t)^2)./mean(t)]; clear t
            
            
            t= fanoAllinc(:,binAnalysis); t=nansum(t')';
            FanoSaveAllinc=[ FanoSaveAllinc; (std(t)^2)./mean(t)]; clear t
            
        end
        savestruct(xzv). All_FanoSaveAllomit= FanoSaveAll';
        savestruct(xzv). All_FanoSaveAll= FanoSaveAllinc';
        
        if isempty(find(trialtypesall<4))==1
            
            %savestruct(xzv).filename=D(xzv).name;
            savestruct(xzv).l6103omit= nanmean(SDFtiming(trials6103_25l,RangeAn));
            savestruct(xzv).l6102omit= nanmean(SDFtiming(trials6102_50l,RangeAn));
            savestruct(xzv).l6101omit= nanmean(SDFtiming(trials6101_75l,RangeAn));
            savestruct(xzv).l6105omit= nanmean(SDFtiming(trials6105_25l,RangeAn));
            savestruct(xzv).l6201omit= nanmean(SDFtiming(trials6201nd,RangeAn));
            
            savestruct(xzv).AllSDFomit= nanmean(SDFtiming([trials6101_75l trials6102_50l trials6103_25l],RangeAn));
            savestruct(xzv).l6105= nanmean(SDFtiming(trials6105,RangeAn));
            savestruct(xzv).l6104= nanmean(SDFtiming(trials6104,RangeAn));
            savestruct(xzv).l6103= nanmean(SDFtiming(trials6103,RangeAn));
            savestruct(xzv).l6102= nanmean(SDFtiming(trials6102,RangeAn));
            savestruct(xzv).l6101= nanmean(SDFtiming(trials6101,RangeAn));
            savestruct(xzv).l6201= nanmean(SDFtiming(trials6201,RangeAn));
            savestruct(xzv).AllSDF= nanmean(SDFtiming([trials6101 trials6102 trials6103],RangeAn));
            
            
            
            FanoSave6101=[];  FanoSave6102=[];  FanoSave6103=[];  FanoSave6105=[]; FanoSave6104=[]; FanoSave6201=[]; FanoSaveAll=[];
            FanoSaveAllinc=[]; FanoSave6101inc=[];  FanoSave6102inc=[];  FanoSave6103inc=[]; FanoSave6201inc=[];
            for x = 1:size(RastersFano,2)-100
                binAnalysis=[x:x+100];
                
                t= fanoAll(:,binAnalysis); t=nansum(t')';
                FanoSaveAll=[ FanoSaveAll; (std(t)^2)./mean(t)]; clear t
                
                t= fano6104(:,binAnalysis); t=nansum(t')';
                FanoSave6104=[ FanoSave6104; (std(t)^2)./mean(t)]; clear t
                
                t= fano6103(:,binAnalysis); t=nansum(t')';
                FanoSave6103=[ FanoSave6103; (std(t)^2)./mean(t)]; clear t
                
                t= fano6102(:,binAnalysis); t=nansum(t')';
                FanoSave6102=[ FanoSave6102; (std(t)^2)./mean(t)]; clear t
                
                t= fano6101(:,binAnalysis); t=nansum(t')';
                FanoSave6101=[ FanoSave6101; (std(t)^2)./mean(t)]; clear t
                
                t= fano6105(:,binAnalysis); t=nansum(t')';
                FanoSave6105=[ FanoSave6105; (std(t)^2)./mean(t)]; clear t
                
                t= fano6201(:,binAnalysis); t=nansum(t')';
                FanoSave6201=[ FanoSave6201; (std(t)^2)./mean(t)]; clear t
                
                t= fanoAllinc(:,binAnalysis); t=nansum(t')';
                FanoSaveAllinc=[ FanoSaveAllinc; (std(t)^2)./mean(t)]; clear t
                
                t= fano6103inc(:,binAnalysis); t=nansum(t')';
                FanoSave6103inc=[ FanoSave6103inc; (std(t)^2)./mean(t)]; clear t
                
                t= fano6102inc(:,binAnalysis); t=nansum(t')';
                FanoSave6102inc=[ FanoSave6102inc; (std(t)^2)./mean(t)]; clear t
                
                t= fano6101inc(:,binAnalysis); t=nansum(t')';
                FanoSave6101inc=[ FanoSave6101inc; (std(t)^2)./mean(t)]; clear t
                
                t= fano6201inc(:,binAnalysis); t=nansum(t')';
                FanoSave6201inc=[ FanoSave6201inc; (std(t)^2)./mean(t)]; clear t
            end
            
            SmoothBin=1;
            savestruct(xzv). FanoSaveAllomit= smooth(FanoSaveAll',SmoothBin)';
            savestruct(xzv). FanoSave6104=  smooth(FanoSave6104',SmoothBin)';
            savestruct(xzv). FanoSave6103omit=  smooth(FanoSave6103',SmoothBin)';
            savestruct(xzv). FanoSave6102omit=  smooth(FanoSave6102',SmoothBin)';
            savestruct(xzv). FanoSave6101omit=  smooth(FanoSave6101',SmoothBin)';
            savestruct(xzv). FanoSave6105omit=  smooth(FanoSave6105',SmoothBin)';
            savestruct(xzv). FanoSave6201omit=  smooth(FanoSave6201',SmoothBin)';
            savestruct(xzv). FanoSaveAll= smooth(FanoSaveAllinc',SmoothBin)';
            savestruct(xzv). FanoSave6103=  smooth(FanoSave6103inc',SmoothBin)';
            savestruct(xzv). FanoSave6102=  smooth(FanoSave6102inc',SmoothBin)';
            savestruct(xzv). FanoSave6101=  smooth(FanoSave6101inc',SmoothBin)';
            savestruct(xzv). FanoSave6201=  smooth(FanoSave6201inc',SmoothBin)';
            
            %Raw data
            savestruct(xzv). raw_FanoSaveAllomit= FanoSaveAll';
            savestruct(xzv). raw_FanoSave6104= FanoSave6104';
            savestruct(xzv). raw_FanoSave6103omit= FanoSave6103';
            savestruct(xzv). raw_FanoSave6102omit= FanoSave6102';
            savestruct(xzv). raw_FanoSave6101omit= FanoSave6101';
            savestruct(xzv). raw_FanoSave6105omit= FanoSave6105';
            savestruct(xzv). raw_FanoSave6201omit= FanoSave6201';
            savestruct(xzv). raw_FanoSaveAll= FanoSaveAllinc';
            savestruct(xzv). raw_FanoSave6103= FanoSave6103inc';
            savestruct(xzv). raw_FanoSave6102= FanoSave6102inc';
            savestruct(xzv). raw_FanoSave6101= FanoSave6101inc';
            savestruct(xzv). raw_FanoSave6201= FanoSave6201inc';
        end
        %end of Fano
    

        

        close all;
        clear PDS roc proc A1 A2 ch1 ch2 ch3 ch3 p r
        
        
    end
    if strcmpi(str,'BFphas')
        save timingproceduresummary3monksBF_phasic_V1.mat savestruct
    elseif strcmpi(str,'BFramping')
        save timingproceduresummary3monksBF_tonic_V1.mat savestruct
    end
end