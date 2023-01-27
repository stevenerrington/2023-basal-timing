close all
clear all; clc; close all; warning off; beep off;
addpath('HELPER_GENERAL'); %keep hepers functions here

CENTER=8001;
gauswindow_ms=50;
rastersplot=1;
limitsarray=[CENTER-1000:CENTER+2750];
xlimvar=length(limitsarray);
smoothValue=1; %1 wont smooth


filestoanalyze(1).x='X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingTrace\TimingTrace_V7_02_06_2015_14_23.mat';
filestoanalyze(2).x='X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingTrace\TimingTrace_V7_08_05_2015_15_13.mat';
filestoanalyze(3).x='X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingTrace\TimingTrace_V7_09_05_2015_10_27.mat';
filestoanalyze(4).x='X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingTrace\TimingTrace_V7_10_08_2015_12_44.mat';
filestoanalyze(5).x='X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingTrace\TimingTrace_V7_12_05_2015_15_13.mat';
filestoanalyze(6).x='X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingTrace\TimingTrace_V7_14_07_2015_12_18.mat';
filestoanalyze(7).x='X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingTrace\TimingTrace_V7_14_07_2015_13_17.mat';
filestoanalyze(8).x='X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingTrace\TimingTrace_V7_25_06_2015_12_44.mat';
filestoanalyze(9).x='X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingTrace\TimingTrace_V7_28_05_2015_15_34.mat';



for iii=  1 :size(filestoanalyze,2)
    
    limitsarray=[CENTER-1000:CENTER+2750];
    clear PDS
    load(filestoanalyze(iii).x, 'PDS');
    
    
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
    
%     cleanfreeoutcome=[free1_ free2_ free34_];
%     CLEAN=cleanfreeoutcome;
%     
%     fullItiTrials_=[];
%     clear temp
%     for x=1:length(CLEAN)
%         x=CLEAN(x);
%      spk=PDS(1).sptimes{x};
%                % spk = PDS.sptimes{x}(PDS.spikes{x} == 65535);
%     
%       
%         spk1=spk(find(spk<PDS.timesoffreeoutcomes_first(x)));
%         spk2=spk(find(spk>PDS.timesoffreeoutcomes_first(x)+10/1000));
%         
%         spk=[spk1 spk2]; clear spk1 spk2
%         try
%             no_noise=find(spk>(PDS.timesoffreeoutcomes_first(x)+(10/1000)) & spk<(PDS.timesoffreeoutcomes_first(x)+(20/1000)));
%             no_noise=length(no_noise); %this many spikes in the window  so insert that many spikes in the deleted time range
%             grabnumbers=PDS.timesoffreeoutcomes_first(x)+randperm(10)/1000;
%             grabnumbers=grabnumbers(no_noise);
%             spk=[spk grabnumbers];
%         end
%         PDS(1).sptimes{x}=sort(spk);
%         
%         if PDS.sptimes{x}(end) - PDS.timesoffreeoutcomes_first(x)>2.5
%             fullItiTrials_ = [fullItiTrials_ x];
%         end
%         clear y spk spk1 spk2 x
%     end
%     
%     for x=1:length(CLEAN)
%         x=CLEAN(x);
%         spk=PDS(1).sptimes{x};
%         try
%             no_noise=find(spk>(PDS.timesoffreeoutcomes_second(x)+(10/1000)) & spk<(PDS.timesoffreeoutcomes_second(x)+(20/1000)));
%             no_noise=length(no_noise); %this many spikes in the window  so insert that many spikes in the deleted time range
%             grabnumbers=PDS.timesoffreeoutcomes_second(x)+randperm(10)/1000;
%             grabnumbers=grabnumbers(no_noise);
%             spk=[spk grabnumbers];
%         end
%         spk1=spk(find(spk<PDS.timesoffreeoutcomes_second(x)));
%         spk2=spk(find(spk>PDS.timesoffreeoutcomes_second(x)+10/1000));
%         spk=[spk1 spk2]; clear spk1 spk2
%         
%         PDS(1).sptimes{x}=sort(spk);
%         %
%         clear y spk spk1 spk2 x
%         clc
%     end
    
    
    
      fullItiTrials_=[];
      
      
    BadTrials=[];
    Rasters=[];
    for x=1:length(PDS.fractals)
        %x
       % try
        %  spike_times = PDS.sptimes{x}(PDS.spikes{x} == 65535);
        %    spk=spike_times-PDS.timesoffreeoutcomes_first(x);
%             
                %spk=PDS.sptimes{x}(PDS.spikes{x} == 65535)-PDS.timesoffreeoutcomes_first(x);
            
                     if PDS.sptimes{x}(end) - PDS.timesoffreeoutcomes_first(x)>2.5
            fullItiTrials_ = [fullItiTrials_ x];
        end
                
                  spk=PDS(1).sptimes{x}-PDS.timesoffreeoutcomes_first(x);
            
                
            spk=(spk*1000)+CENTER-1;
            spk=fix(spk);
            %
            spk=spk((spk<CENTER*2) & spk>0);
            %
            temp(1:CENTER*2)=0;
            temp(spk)=1;
             
            %remove doublets
            for xx=1:length(temp)-2
               if temp(xx) == 1
                  temp(xx+1:xx+2)=0;  
               end
            end
            
     
            
       % catch
       %      temp(1:CENTER*2)=NaN;
       %      BadTrials=[BadTrials; x];
       % end
            Rasters=[Rasters; temp];
            %
            clear temp spk x

    end
    

    
    
    Rastersfree_=Rasters; clear Rasters
    Rastersfree_=Rastersfree_(:,limitsarray);
    
    durout=(1000*(PDS.timesoffreeoutcomes_second-PDS.timesoffreeoutcomes_first))+1000;
    for x=1:length(durout) 
        try
            d=3;
            Rastersfree_(x,1000-d:1000+d)=0;
            Rastersfree_(x,fix(durout(x))-d:fix(durout(x))+d)=0;
        end 
    end
    SDFfree_=plot_mean_psth({Rastersfree_},gauswindow_ms,1,length(Rastersfree_(1,:)),1);
    
    
    
    limitsarray=[1:length(SDFfree_(1,:))];
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
    MatPlot(1:size(xuncert,1),1:max(xt))=NaN;
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
    end;
    MatPlot(1:size(xuncert,1),1:max(xt))=NaN;
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
    MatPlot(1:size(xuncert,1),1:max(xt))=NaN;
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
    ylim([0 150])
    xlabel('Double free outcomes')
    axis square;
    clear rasts xt rastList MatPlot
    
    %zscore
    temp=(SDFfree_(intersect([free34_ free2_ free1_],fullItiTrials_),:)); temp=temp(:);
    SDFfree_=(SDFfree_-nanmean(temp))./nanstd(temp); clear temp
    
    
     SaveStructFreeRewards(iii).include=0;
    if length( intersect(free1_ , fullItiTrials_) )>1  & length( intersect(free2_ , fullItiTrials_) )>1 & length(intersect(free34_ , fullItiTrials_) )>1
        SaveStructFreeRewards(iii).DoubleRewardTrials =  SDFfree_ ( intersect(free1_ , fullItiTrials_),: );
        SaveStructFreeRewards(iii).DoubleAirpuffTrials =  SDFfree_ ( intersect(free2_ , fullItiTrials_),: );
        SaveStructFreeRewards(iii).DoubleFlashTrials =  SDFfree_ ( intersect(free34_ , fullItiTrials_),: );
        
        SaveStructFreeRewards(iii).DoubleRewardTrialsA = nanmean( SDFfree_ ( intersect(free1_ , fullItiTrials_),: ));
        SaveStructFreeRewards(iii).DoubleAirpuffTrialsA = nanmean(  SDFfree_ ( intersect(free2_ , fullItiTrials_),: ));
        SaveStructFreeRewards(iii).DoubleFlashTrialsA =  nanmean( SDFfree_ ( intersect(free34_ , fullItiTrials_),: ));
        
        SaveStructFreeRewards(iii).include=1;
        
        SaveStructFreeRewards(iii).durout=nanmean(nonzeros(durout-1000))
        
    end

    set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
   close all;
    %8
end

save SaveStructFreeRewards.mat SaveStructFreeRewards
clc;

[SaveStructFreeRewards(:).include]

Reward=vertcat(SaveStructFreeRewards(1,:).DoubleRewardTrialsA );
Punish=vertcat(SaveStructFreeRewards(1,:).DoubleAirpuffTrialsA );
Sound=vertcat(SaveStructFreeRewards(1,:).DoubleFlashTrialsA );

figure
nsubplot(450,450,1:450,1:450)
set(gca,'ticklength',4*get(gca,'ticklength'))
plt=Reward; x=1:size(plt,2); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-r', 'LineWidth', 3}, 0); hold on

plt=Sound; x=1:size(plt,2); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-k', 'LineWidth', 3}, 0); hold on

plt=Punish; x=1:size(plt,2); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-b', 'LineWidth', 3}, 0); hold on

line([ fix(nanmean([SaveStructFreeRewards(:).durout]))+1000  fix(nanmean([SaveStructFreeRewards(:).durout]))+1000],[-2 5],'LineWidth',1, 'Color', 'k')
    line([ 1000 1000],[-2 5],'LineWidth',1, 'Color', 'k')
    

xlim([500 3000])
%
    set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
    print('-dpdf', 'DoubleOutcomes' );
    close all;





















