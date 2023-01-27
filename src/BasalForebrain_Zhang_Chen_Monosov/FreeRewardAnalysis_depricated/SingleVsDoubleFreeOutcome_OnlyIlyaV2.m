close all
clear all; clc; close all; warning off;
addpath('HELPER_GENERAL'); %keep hepers functions here

CENTER=8001; 
gauswindow_ms=50;
rastersplot=1;
limitsarray=[CENTER-1000:CENTER+2750];
xlimvar=length(limitsarray);
smoothValue=1; %1 wont smooth




%1,3,4,6,7,10,11,13,15
%2,5,8,9,12,14,16 bad



groupFilenamesD{1} ={'X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingTrace\TimingTrace_V7_25_06_2015_12_44.mat'};
groupFilenamesS{1} ={'X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\ProbAmt\ProbAmtIsoLum_V3_25_06_2015_12_18.mat'};
%2
%3
groupFilenamesD{2} ={'X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingTrace\TimingTrace_V7_10_06_2015_14_10.mat'};
groupFilenamesS{2} ={'X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\ProbAmt\ProbAmtIsoLum_V3_10_06_2015_13_47.mat'};
%4
groupFilenamesD{3} ={'X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingTrace\TimingTrace_V7_02_06_2015_14_23.mat'};
groupFilenamesS{3} ={'X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\ProbAmt\ProbAmtIsoLum_V3_02_06_2015_14_00.mat'};
%5
%6
groupFilenamesD{4} ={'X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingTrace\TimingTrace_V7_28_05_2015_15_34.mat'};
groupFilenamesS{4} ={'X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\ProbAmt\ProbAmtIsoLum_V3_28_05_2015_15_21.mat'};
%7
groupFilenamesD{5} ={'X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingTrace\TimingTrace_V7_12_05_2015_15_13.mat'};
groupFilenamesS{5} ={'X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\ProbAmt\ProbAmtIsoLum_V3_12_05_2015_14_57.mat'};

groupFilenamesD{6} ={'X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingTrace\TimingTrace_V7_08_05_2015_15_13.mat'};
groupFilenamesS{6} ={'X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\ProbAmt\ProbAmtIsoLum_V3_08_05_2015_14_47.mat'};
%11
groupFilenamesD{7} ={'X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingTrace\TimingTrace_V7_07_05_2015_13_24.mat'};
groupFilenamesS{7} ={'X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\ProbAmt\ProbAmtIsoLum_V3_07_05_2015_12_49.mat'};


%OR  % ChoiceOnlyProbAmtIsoLum_02_05_2015_14_06.mat
%13
groupFilenamesD{8} ={'X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingTrace\TimingTrace_V7_02_05_2015_12_05.mat'};
groupFilenamesS{8} ={'X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\ProbOnly_ChoiceOnly\ProbOnlyIsoLum_V1_02_05_2015_12_15.mat'}; % ChoiceOnlyProbAmtIsoLum_02_05_2015_11_51.mat


groupFilenamesD{9} ={'X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingTrace\TimingTrace_V6_25_04_2015_12_15.mat'};
groupFilenamesS{9} ={'X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\ProbAmt\oldversion\ProbAmtIsoLum_25_04_2015_11_29.mat'};




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for iii=  1 :size(groupFilenamesD,2)
    iii

    limitsarray=[CENTER-1000:CENTER+2750];
    
    
    
    clear  groupFilenames groupDirectory PDS
    groupFilenames{1} = groupFilenamesD{iii};
    groupFilenames{2} = groupFilenamesS{iii};;
    
    load(cell2mat(groupFilenames{1}));
    
    
    
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
        deliv=find(PDS(1).deliveredornot==1)
        ndeliv=find(PDS(1).deliveredornot==0)
    else
        if isfield(PDS,'rewardDuration')
            deliv=find(PDS(1).rewardDuration>0)
            ndeliv=find(PDS(1).rewardDuration==0);
        else
            deliv=find(PDS(1).rewardduration>0)
            ndeliv=find(PDS(1).rewardduration==0  )
        end
        
    end
    
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
    
    cleanfreeoutcome=[free1_ free2_ free34_];
    CLEAN=cleanfreeoutcome;
    
    fullItiTrials_=[];
    clear temp
    for x=1:length(CLEAN)
        x=CLEAN(x);
        spk=PDS(1).sptimes{x};
        
        spk1=spk(find(spk<PDS.timesoffreeoutcomes_first(x)));
        spk2=spk(find(spk>PDS.timesoffreeoutcomes_first(x)+10/1000));
        
        spk=[spk1 spk2]; clear spk1 spk2
        try
            no_noise=find(spk>(PDS.timesoffreeoutcomes_first(x)+(10/1000)) & spk<(PDS.timesoffreeoutcomes_first(x)+(20/1000)));
            no_noise=length(no_noise); %this many spikes in the window  so insert that many spikes in the deleted time range
            grabnumbers=PDS.timesoffreeoutcomes_first(x)+randperm(10)/1000;
            grabnumbers=grabnumbers(no_noise);
            spk=[spk grabnumbers];
        end
        PDS(1).sptimes{x}=sort(spk);
        
        if PDS.sptimes{x}(end) - PDS.timesoffreeoutcomes_first(x)>2.5
            fullItiTrials_ = [fullItiTrials_ x];
        end
        clear y spk spk1 spk2 x
    end
    
    for x=1:length(CLEAN)
        x=CLEAN(x);
        spk=PDS(1).sptimes{x};
        try
            no_noise=find(spk>(PDS.timesoffreeoutcomes_second(x)+(10/1000)) & spk<(PDS.timesoffreeoutcomes_second(x)+(20/1000)));
            no_noise=length(no_noise); %this many spikes in the window  so insert that many spikes in the deleted time range
            grabnumbers=PDS.timesoffreeoutcomes_second(x)+randperm(10)/1000;
            grabnumbers=grabnumbers(no_noise);
            spk=[spk grabnumbers];
        end
        spk1=spk(find(spk<PDS.timesoffreeoutcomes_second(x)));
        spk2=spk(find(spk>PDS.timesoffreeoutcomes_second(x)+10/1000));
        spk=[spk1 spk2]; clear spk1 spk2
        
        PDS(1).sptimes{x}=sort(spk);
        %
        clear y spk spk1 spk2 x
        clc
    end


    Rasters=[];
    for x=1:length(PDS.fractals)
        try
            spk=PDS(1).sptimes{x}-PDS.timesoffreeoutcomes_first(x);
            
            spk=(spk*1000)+CENTER-1;
            spk=fix(spk);
            %
            spk=spk((spk<CENTER*2) & spk>0);
            %
            temp(1:CENTER*2)=0;
            temp(spk)=1;
            Rasters=[Rasters; temp];
            %
            clear temp spk x
            %             catch
        end
    end
    SDFfree_=plot_mean_psth({Rasters},gauswindow_ms,1,(CENTER*2)-2,1);
    Rastersfree_=Rasters;
    
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
    SDFcstrace=plot_mean_psth({Rasters},gauswindow_ms,1,(CENTER*2)-2,1);
    Rasters_cstrace=Rasters; clear Rasters
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Plot Rasters of  Double FreeOutcomes
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    nsubplot(100,100,1:45,1:45)
    trialstoplot=intersect(free1_ , fullItiTrials_) ;
    xuncert= [Rastersfree_(trialstoplot,limitsarray)];
    SD=smooth(nanmean(SDFfree_(trialstoplot,limitsarray),1),smoothValue);
    
    plot(SD,'r','LineWidth', 2); hold on;

    SD = SD';
    freeOutcomeDoubleReward = SD;
    
    xt=[];
    rasts=[];
    
    for tq=1:size(xuncert,1)
        Z=xuncert(tq,:);
        Z(find(Z==1))=(find(Z==1));
        Z(find(Z==0))=NaN;
        xt_=length(find(Z>0));
        if isempty(xt_)==1
            xt_=NaN;
        end
        xt=[xt; xt_];
        rasts=[rasts; Z];
        clear Z tq xt_
    end
    MatPlot(1:size(xuncert,1),1:max(xt))=NaN
    for tq=1:size(xuncert,1)
        temptq=find(rasts(tq,:)>0);
        MatPlot(tq,1:length(temptq))=temptq;
    end
    rastList=MatPlot;
    rasIntv=1;
    LWidth=1;
    LColor='r';
    maxY_rast=tq+10;
    if rastersplot==1
        for line = 1:size(rastList,1)
            hold on
            curY_rast = maxY_rast-rasIntv*line;
            plot([rastList(line,:); rastList(line,:)],...
                [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
                (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor );
            hold on
        end
    end
    clear rasts xt rastList MatPlot
    
    trialstoplot=intersect(free34_, fullItiTrials_);
    xuncert=[Rastersfree_(trialstoplot,limitsarray)];
    SD=smooth(nanmean(SDFfree_(trialstoplot,limitsarray),1),smoothValue) ;
    plot(SD,'k','LineWidth', 2); hold on;

     SD = SD';
    freeOutcomeDoubleFlash = SD;
    
    xt=[];
    rasts=[];
    for tq=1:size(xuncert,1)
        Z=xuncert(tq,:);
        Z(find(Z==1))=(find(Z==1));
        Z(find(Z==0))=NaN;
        xt_=length(find(Z>0));
        if isempty(xt_)==1
            xt_=NaN;
        end
        xt=[xt; xt_];
        rasts=[rasts; Z];
        clear Z tq xt_
    end
    MatPlot(1:size(xuncert,1),1:max(xt))=NaN
    for tq=1:size(xuncert,1)
        temptq=find(rasts(tq,:)>0);
        MatPlot(tq,1:length(temptq))=temptq;
    end
    rastList=MatPlot;
    rasIntv=1;
    LWidth=1;
    LColor='k';
    maxY_rast=tq+40;
    if rastersplot==1
        for line = 1:size(rastList,1)
            hold on
            curY_rast = maxY_rast-rasIntv*line;
            plot([rastList(line,:); rastList(line,:)],...
                [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
                (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor );
            hold on
        end
    end
    clear tq xt line rastList MatPlot curY_rast temptq rasts SD SDplotto xuncert
    clear rasts xt rastList MatPlot
    
    trialstoplot=intersect(free2_ , fullItiTrials_);
    xuncert=[Rastersfree_(trialstoplot,limitsarray)];
    SD=smooth(nanmean(SDFfree_(trialstoplot,limitsarray),1),smoothValue);
    plot(SD,'b','LineWidth', 2); hold on;
    
  SD = SD';
    
    freeOutcomeDoubleAirpuff = SD;
    
    xt=[];
    rasts=[];
    for tq=1:size(xuncert,1)
        Z=xuncert(tq,:);
        Z(find(Z==1))=(find(Z==1));
        Z(find(Z==0))=NaN;
        xt_=length(find(Z>0));
        if isempty(xt_)==1
            xt_=NaN;
        end
        xt=[xt; xt_];
        rasts=[rasts; Z];
        clear Z tq xt_
    end
    MatPlot(1:size(xuncert,1),1:max(xt))=NaN
    for tq=1:size(xuncert,1)
        temptq=find(rasts(tq,:)>0);
        MatPlot(tq,1:length(temptq))=temptq;
    end
    rastList=MatPlot;
    rasIntv=1;
    LWidth=1;
    LColor='b';
    maxY_rast=tq+70;
    if rastersplot==1
        for line = 1:size(rastList,1)
            hold on
            curY_rast = maxY_rast-rasIntv*line;
            plot([rastList(line,:); rastList(line,:)],...
                [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
                (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor );
            hold on
        end
    end
    clear tq xt line rastList MatPlot curY_rast temptq rasts SD SDplotto xuncert
    firstOutcomeTime = 1000;
    x=[firstOutcomeTime,firstOutcomeTime ];
    y=[0,50];
    plot(x,y,'k'); hold on;
    
    x=[(averageOutcomeSeperation +firstOutcomeTime) ,  ...
        (averageOutcomeSeperation +firstOutcomeTime)];
    y=[0,50];
    plot(x,y,'k'); hold on;
    
    xlim([0 3000])
    ylim([0 120])
    xlabel('Double free outcomes')
    axis square;
    clear rasts xt rastList MatPlot
    

    SaveStructFreeRewards{iii}.DoubleRewardTrials =  SDFfree_ ( intersect(free1_ , fullItiTrials_),: );
    SaveStructFreeRewards{iii}.DoubleAirpuffTrials =  SDFfree_ ( intersect(free2_ , fullItiTrials_),: );
    SaveStructFreeRewards{iii}.DoubleFlashTrials =  SDFfree_ ( intersect(free34_ , fullItiTrials_),: );
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % End Plot Double Outcomes
    %%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    clear PDS
       load(cell2mat(groupFilenames{2}));
    clear free34 free3Only free4Only free9000s free1 free9021 free2
    limitsarray=[CENTER-1000:CENTER+1750];
    
    
    
    xlimvar=length(limitsarray);
    PDS.timesoffreeoutcomes_first(find(PDS.timesoffreeoutcomes_first>10))=NaN; %very few trials have a timing bug. just remove them
    free1=intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==1)); %reward/juice
    free34=intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==34)); %flash.sound combination
    free3Only = intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==3)); %flash.sound combination
    free4Only = intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==4)); %flash.sound combination
    free2 =  intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==2)); %punishment
    
    
    if max(PDS.freeoutcometype)>9000
        free9000s = intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype>9000 &PDS.freeoutcometype<9021 )); %flash.sound combination
        free9021 = intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==9021)); %flash.sound combination
        
    else
        free9000s=[];
        free9021=[];
    end
    free34 = [free34 free3Only free4Only free9000s];
    free1 = [free1 free9021];
    
    
    fullItiTrials=[];
    %let's remove the reward noise
    cleanfreeoutcome=[free1 free34];
    CLEAN=cleanfreeoutcome;
    for x=1:length(CLEAN)
        %             x
        x=CLEAN(x);
        spk=PDS(1).sptimes{x};
        spk1=spk(find(spk<PDS.timesoffreeoutcomes_first(x)));
        spk2=spk(find(spk>PDS.timesoffreeoutcomes_first(x)+10/1000));
        spk=[spk1 spk2]; clear spk1 spk2
        try
            no_noise=find(spk>(PDS.timesoffreeoutcomes_first(x)+(10/1000)) & spk<(PDS.timesoffreeoutcomes_first(x)+(20/1000)));
            no_noise=length(no_noise); %this many spikes in the window  so insert that many spikes in the deleted time range
            grabnumbers=PDS.timesoffreeoutcomes_first(x)+randperm(10)/1000;
            grabnumbers=grabnumbers(no_noise);
            spk=[spk grabnumbers];
        end
        PDS(1).sptimes{x}=sort(spk);
            if PDS.sptimes{x}(end) - PDS.timesoffreeoutcomes_first(x)>2.5
                fullItiTrials = [fullItiTrials x];
            end
        clear y spk spk1 spk2 x
        
        clc
    end
    %MAKE A RASTER AND A SPIKE DENSITY FUNCTION FOR EVERY TRIAL for
    %freeoutcomes
    Rasters=[];
    for x=1:length(PDS.fractals)
        spk=PDS(1).sptimes{x}-PDS.timesoffreeoutcomes_first(x);
        
        spk=(spk*1000)+CENTER-1;
        spk=fix(spk);
        %
        spk=spk((spk<CENTER*2) & spk>0  );  % NML added
        %
        temp(1:CENTER*2)=0;
        temp(spk)=1;
        Rasters=[Rasters; temp];
        %
        
        
        clear temp spk x
    end
    SDFfree=plot_mean_psth({Rasters},gauswindow_ms,1,(CENTER*2)-2,1);
    %close all;
    Rastersfree=Rasters;
    clear  CLEAN cleanfreeoutcome
    
    
    %%%%Plot Single outcomes%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    
    nsubplot(100,100,50:100,1:45)
    trialstoplot=intersect(free1 , fullItiTrials);
    xuncert=[Rastersfree(trialstoplot,limitsarray)];
    SD=smooth(nanmean(SDFfree(trialstoplot,limitsarray),1),smoothValue);
    
 SD = SD';
    
    freeOutcomeSingleReward =SD;
    
    plot(SD,'r','LineWidth', 2); hold on;
    xt=[];
    rasts=[];
    for tq=1:size(xuncert,1)
        Z=xuncert(tq,:);
        Z(find(Z==1))=(find(Z==1));
        Z(find(Z==0))=NaN;
        xt_=length(find(Z>0));
        if isempty(xt_)==1
            xt_=NaN;
        end
        xt=[xt; xt_];
        rasts=[rasts; Z];
        clear Z tq xt_
    end
    MatPlot(1:size(xuncert,1),1:max(xt))=NaN
    for tq=1:size(xuncert,1)
        temptq=find(rasts(tq,:)>0);
        MatPlot(tq,1:length(temptq))=temptq;
    end
    rastList=MatPlot;
    rasIntv=1;
    LWidth=1;
    LColor='r';
    maxY_rast=tq+10;
    if rastersplot==1
        for line = 1:size(rastList,1)
            hold on
            curY_rast = maxY_rast-rasIntv*line;
            plot([rastList(line,:); rastList(line,:)],...
                [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
                (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor );
            hold on
        end
    end
    clear rasts xt rastList MatPlot
    
    trialstoplot=intersect(free34 , fullItiTrials);
    xuncert=[Rastersfree(trialstoplot,limitsarray)];
    SD=smooth(nanmean(SDFfree(trialstoplot,limitsarray),1),smoothValue);
    
SD = SD';
    
    freeOutcomeSingleFlash = SD;
    plot(SD,'k','LineWidth', 2); hold on;
    xt=[];
    rasts=[];
    for tq=1:size(xuncert,1)
        Z=xuncert(tq,:);
        Z(find(Z==1))=(find(Z==1));
        Z(find(Z==0))=NaN;
        xt_=length(find(Z>0));
        if isempty(xt_)==1
            xt_=NaN;
        end
        xt=[xt; xt_];
        rasts=[rasts; Z];
        clear Z tq xt_
    end
    MatPlot(1:size(xuncert,1),1:max(xt))=NaN
    for tq=1:size(xuncert,1)
        temptq=find(rasts(tq,:)>0);
        MatPlot(tq,1:length(temptq))=temptq;
    end
    rastList=MatPlot;
    rasIntv=1;
    LWidth=1;
    LColor='k';
    maxY_rast=tq+40;
    if rastersplot==1
        for line = 1:size(rastList,1)
            hold on
            curY_rast = maxY_rast-rasIntv*line;
            plot([rastList(line,:); rastList(line,:)],...
                [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
                (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor );
            hold on
        end
    end
    clear tq xt line rastList MatPlot curY_rast temptq rasts SD SDplotto xuncert
    x=[1000,1000]; y=[0,60]; plot(x,y,'k'); hold on;
    xlabel('free outcomes')
    axis square;
    clear rasts xt rastList MatPlot

    SaveStructFreeRewards{iii}.SingleRewardTrials =  SDFfree ( intersect(free1 , fullItiTrials),: );
    SaveStructFreeRewards{iii}.SingleAirpuffTrials =  SDFfree ( intersect(free2 , fullItiTrials),: );
    SaveStructFreeRewards{iii}.SingleFlashTrials =  SDFfree ( intersect(free34 , fullItiTrials),: );
    
    iii
    close all;
end



xcv

save('SaveStructFreeRewardsData' , 'SaveStructFreeRewards' , 'SaveStructFreeRewardsGlobal' , '-v7.3');


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Average
% Plot
% this plots the Average Single and double 


%  trialsToAverage =1:size(SdfFullTrialOnlySingleFreeRewards,1);
%  trialsToAverage = 1:size(SaveStructFreeRewards)

%%%
AllTrialSingleFreeRewards ;
AllTrialSingleFreeFlash ;
AllTrialSingleFreeAirpuff;
%%%
FullTrialOnlySingleFreeRewards ;
FullTrialOnlySingleFreeFlash ;
FullTrialOnlySingleFreepunish ;
%%%
AllTrialDoubleFreeRewards ;
AllTrialDoubleFreeFlash ;
AllTrialDoubleFreeAirpuff ;

FullTrialOnlyDoubleFreeRewards ;
FullTrialOnlyDoubleFreeFlash ;
%         FullTrialOnlyDoubleFreeAirpuff ;

% plot_mean_psth({Rasters},gauswindow_ms,1,(CENTER*2)-2,1);
SDFaverageSingleReward =  plot_mean_psth({FullTrialOnlySingleFreeRewards},gauswindow_ms,1,(CENTER*2)-2,1);
SDFplotSingleFlash =  plot_mean_psth({FullTrialOnlySingleFreeFlash},gauswindow_ms,1,(CENTER*2)-2,1);
SDFplotSinglePuff =  plot_mean_psth({FullTrialOnlySingleFreepunish},gauswindow_ms,1,(CENTER*2)-2,1);
SDFplotDoubleReward =  plot_mean_psth({FullTrialOnlyDoubleFreeRewards},gauswindow_ms,1,(CENTER*2)-2,1);
SDFplotDoubleFlash =  plot_mean_psth({FullTrialOnlyDoubleFreeFlash},gauswindow_ms,1,(CENTER*2)-2,1);
SDFplotDoublePuff =  plot_mean_psth({FullTrialOnlyDoubleFreeAirpuff},gauswindow_ms,1,(CENTER*2)-2,1);


AveragePlot = figure;
nsubplot(1,3,1,1)
xAxisLabel = 7000:11000;
smoothValue=10;

if atHome==1
    SdfAllTrialSingleFreeRewards  ;
    SdfAllTrialSingleFreeFlash  ;
    SdfAllTrialSingleFreeAirpuff  ;
    
    SDFSingleReward =  SdfFullTrialOnlySingleFreeRewards' ;
    SDFSingleFlash= SdfFullTrialOnlySingleFreeFlash'  ;
    SdfFullTrialOnlySingleFreepunish' ;
    
    SDFDoubleReward=     SdfAllTrialDoubleFreeRewards' ;
    SDFDoubleFlash= SdfAllTrialDoubleFreeFlash' ;
    SDFDoublePuff=  SdfAllTrialDoubleFreeAirpuff'  ;
    
    SdfFullTrialOnlyDoubleFreeRewards ;
    SdfFullTrialOnlyDoubleFreeFlash ;
    SdfFullTrialOnlyDoubleFreepunish ;
    smallerArrayLimit = size(SDFSingleReward,1);
else
    SdfAllTrialSingleFreeRewards  ;
    SdfAllTrialSingleFreeFlash  ;
    SdfAllTrialSingleFreeAirpuff  ;
    
    SDFSingleReward =  SdfFullTrialOnlySingleFreeRewards ;
    SDFSingleFlash= SdfFullTrialOnlySingleFreeFlash  ;
    SdfFullTrialOnlySingleFreepunish ;
    
    SDFDoubleReward=     SdfAllTrialDoubleFreeRewards ;
    SDFDoubleFlash= SdfAllTrialDoubleFreeFlash ;
    SDFDoublePuff=  SdfAllTrialDoubleFreeAirpuff  ;
    
    SdfFullTrialOnlyDoubleFreeRewards ;
    SdfFullTrialOnlyDoubleFreeFlash ;
    SdfFullTrialOnlyDoubleFreepunish ;
    smallerArrayLimit = size(SDFSingleReward,2);
end

trialsToAverage=size(SDFSingleReward,1);
hold on;
% plot(nanmean(AllTrialSingleFreeRewards), 'r');
plot(xAxisLabel(1:size(SDFSingleReward,2)), nanmean(SDFSingleReward(trialsToAverage,:),1),'r','LineWidth', 2);

% plot(nanmean(AllTrialSingleFreeFlash), 'k');\
plot(xAxisLabel(1:size(SDFSingleFlash,2)), nanmean(SDFSingleFlash(trialsToAverage,:),1),'k','LineWidth', 2);

% plot(nanmean(AllTrialSingleFreeAirpuff), 'b');
% plot(nanmean(SDFplotSinglePuff),'b','LineWidth', 2);
xlim([7000 9750]);
%

ylim ([ 0 160]);
title('mean of all Single free outcome run SDFs ')
x=[8000,8000 ];
y=[-50,ylimvar];
plot(x,y,'k'); hold on;
xlim ([7000 7000+smallerArrayLimit]);


nsubplot(1,3,1,2)
% plot(nanmean(AllTrialDoubleFreeRewards), 'r');
% plot(nanmean(AllTrialDoubleFreeFlash), 'k');
% plot(nanmean(AllTrialDoubleFreeAirpuff), 'b');

hold on;
% plot(nanmean(AllTrialSingleFreeRewards), 'r');
plot(xAxisLabel(1:size(SDFDoubleReward,2)), ...
    nanmean(SDFDoubleReward(trialsToAverage,:),1),'r','LineWidth', 2);

% plot(nanmean(AllTrialSingleFreeFlash), 'k');\
plot(xAxisLabel(1:size(SDFDoubleFlash,2)), ...
    nanmean(SDFDoubleFlash(trialsToAverage,:),1),'k','LineWidth', 2);

% plot(nanmean(AllTrialSingleFreeAirpuff), 'b');
plot(xAxisLabel(1:size(SDFDoublePuff,2)), ...
    nanmean(SDFDoublePuff(trialsToAverage,:),1),'b','LineWidth', 2);

xlim([7000 11000]);
xlim ([7000 7000+smallerArrayLimit]);

ylim ([ 0 160]);
title('mean of all Double outcome run SDFs ')
firstOutcomeTime=8000;
averageOutcomeSeperation = 1176;

x=[firstOutcomeTime,firstOutcomeTime ];
y=[-50,ylimvar];
plot(x,y,'k'); hold on;
x=[(averageOutcomeSeperation +firstOutcomeTime ),(averageOutcomeSeperation +firstOutcomeTime ) ];
y=[-50,ylimvar];
plot(x,y,'k'); hold on;

nsubplot(1,3,1,3)
if atHome==1
    smallerArrayLimit = size(SDFSingleReward,1);
    SDFDoubleReward =SDFDoubleReward';
    SDFSingleReward = SDFSingleReward';
    SDFDoubleFlash = SDFDoubleFlash';
    SDFSingleFlash = SDFSingleFlash';
else
    smallerArrayLimit = size(SDFSingleReward,2);
end

useRawValues=0
if useRawValues==1
    plot(xAxisLabel(1:smallerArrayLimit), ...
        nanmean(SDFDoubleReward(trialsToAverage , 1:smallerArrayLimit ),1) - nanmean(SDFSingleReward ,1), 'r');
    hold on;
    plot(xAxisLabel(1:smallerArrayLimit), ...
        nanmean(SDFDoubleFlash(trialsToAverage , 1:smallerArrayLimit ),1) - nanmean(SDFSingleFlash ,1), 'k');
    % plot(nanmean(SDFplotDoublePuff ) - nanmean(SDFplotSinglePuff ), 'b') ;
    xlim ([7000 7000+smallerArrayLimit]);
    %  ylim ([ 0 160]);
    ylim([-20 40])
    title('Subtraction (Double-Single) mean of all run SDFs ')
    
    firstOutcomeTime=8000;
    averageOutcomeSeperation = 1176;
    x=[8000,8000 ];
    y=[-50,ylimvar];
    plot(x,y,'k'); hold on;
    x=[(averageOutcomeSeperation +firstOutcomeTime ),(averageOutcomeSeperation +firstOutcomeTime ) ];
    y=[-50,ylimvar];
    plot(x,y,'k'); hold on;
else
    %     plot(xAxisLabel(1:smallerArrayLimit), nanmean(SDFDoubleReward(: , 1:smallerArrayLimit ),1) - nanmean(SDFSingleReward ,1), 'r');
    plot(xAxisLabel(1:smallerArrayLimit), ...
        smooth(nanmean(SdfSubtractedFreeFlash),smoothValue),'k','LineWidth', 2)
    hold on;
    plot(xAxisLabel(1:smallerArrayLimit), ...
        smooth(nanmean(SdfSubtractedFreeReward),smoothValue),'r','LineWidth', 2)
    xlim ([7000 7000+smallerArrayLimit]);
    %     ylim([-1 1])
    ylim auto
    closeYlim= ylim;
    firstOutcomeTime=8000;
    averageOutcomeSeperation = 1176;
    x=[8000,8000 ];
    y=[-50,ylimvar];
    plot(x,y,'k'); hold on;
    x=[(averageOutcomeSeperation +firstOutcomeTime ), ...
        (averageOutcomeSeperation +firstOutcomeTime ) ];
    y=[-50,ylimvar];
    plot(x,y,'k'); hold on;
    (ylim(closeYlim))
    title('Normalized mean Double- Single free outcomes');
end

suptitle(['AverageFreeOutcomes ' ])
if smoothValue > 1
    ilyaOutputFile(gcf ,saveFileLoc,['FreeOutcomes_Averages'  '_005']  )
else
    ilyaOutputFile(gcf ,saveFileLoc,['FreeOutcomes_Averages_Smooth'  '_005']  )
end
save('AverageFreeRewards_006.mat');

