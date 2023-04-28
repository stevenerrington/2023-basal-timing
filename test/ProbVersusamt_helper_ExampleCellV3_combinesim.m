clear all; clc; close all; warning off; beep off;


filename='X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\ProbAmt\ProbAmtIsoLum_V3_29_04_2015_15_00.mat'
titleofplot='examplecell3'

load(filename,'PDS');
figuren
text(1,1,filename,'FontSize',6)
%%settings for spike and ploting
ylimvar=200; 
ylimvaR=200; 
ylimvaRmin=0;
CENTER=11001; 
gauswindow_ms=100;
rastersplot=0;
CsStartIndex=11000;
CsWindow=[CsStartIndex:CsStartIndex+2500];
earlyWindow = [CsWindow(1)+100 : CsWindow(1)+100+500]; %500+100
earlyWindow2 =  [CsWindow(1)+100+500 : CsWindow(end)]; %CsWindow(1)+100+500+500
lateWindow = [CsWindow(1)+(2500-750):CsWindow(end)]; %500
wholeAnalysisEpoch =  [CsWindow(1)+100:CsWindow(end)];
pvalueLimt=0.0500;
pvalueLimitContplot=0.0500; %was 0.01 before
VariancePval=0.0100;
BinForStat=101;
xlimvaR=4500;
VariancePval=0.01000;
BinForStat=101;
ShuffleTime=20000;
kruskalpvalueforfunningtests=VariancePval;










%organize trials organization used later on to parse them further
completedtrial=find(PDS.repeatflag==0);
completedtrial_s=intersect(find(PDS.fractals2==0),completedtrial); %get the single fractal fractals
completedtrial_c=intersect(find(PDS.fractals2>0),completedtrial); %get the choice trials
%
%%reward delivered not delivered
deliv=find(PDS. rewardduration>0)
ndeliv=find(PDS.rewardduration==0)

free1=[]
free2=[]
free34=[]
trials100=[]
trials50=[]
trials0=[]
trials100s=[]
trials50d=[]
trials50nd=[]

%organize freeoutcomes
PDS.timesoffreeoutcomes_first(find(PDS.timesoffreeoutcomes_first>10))=NaN; %very few trials have a timing bug. just remove them
free1=intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==1)); %reward/juice
free34=intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==34)); %flash.sound combination

%PROB BLOCK
trials100p=intersect(find(PDS(1).fractals==6300 | PDS(1).fractals==6306),completedtrial_s);
trials50p=intersect(find(PDS(1).fractals==6301 | PDS(1).fractals==6307),completedtrial_s);
trials0p=intersect(find(PDS(1).fractals==6302 | PDS(1).fractals==6308),completedtrial_s);
trials50d=intersect(trials50p,deliv);
trials50nd=intersect(trials50p,ndeliv);

%AMT BLOCK
trials100a=intersect(find(PDS(1).fractals==6303 | PDS(1).fractals==6309),completedtrial_s);
trials100sa=intersect(find(PDS(1).fractals==6304 | PDS(1).fractals==6310),completedtrial_s);
trials0a=intersect(find(PDS(1).fractals==6305 | PDS(1).fractals==6311),completedtrial_s);

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%organize trials for choice
%find fractals on in PDSfractals
trials100c1=intersect(find(PDS(1).fractals==6300 | PDS(1).fractals==6303 | PDS(1).fractals==6306 | PDS(1).fractals==6309),completedtrial_c);
trials50c1=intersect(find(PDS(1).fractals==6301 | PDS(1).fractals==6307),completedtrial_c);
trials0c1=intersect(find(PDS(1).fractals==6302 | PDS(1).fractals==6305 | PDS(1).fractals==6308 | PDS(1).fractals==6311),completedtrial_c);
trials100sc1=intersect(find(PDS(1).fractals==6304 | PDS(1).fractals==6310),completedtrial_c);

%find fractals on in PDS.fractals2
trials100c2=intersect(find(PDS(1).fractals2==6300 | PDS(1).fractals2==6303 | PDS(1).fractals2==6306 | PDS(1).fractals2==6309),completedtrial_c);
trials50c2=intersect(find(PDS(1).fractals2==6301 | PDS(1).fractals2==6307),completedtrial_c);
trials0c2=intersect(find(PDS(1).fractals2==6302 | PDS(1).fractals2==6305 | PDS(1).fractals2==6308 | PDS(1).fractals2==6311),completedtrial_c);
trials100sc2=intersect(find(PDS(1).fractals2==6304 | PDS(1).fractals2==6310),completedtrial_c);


choice100versus50=[intersect(trials100c1,trials50c2) intersect(trials100c2,trials50c1)];
choice100versus0=[intersect(trials100c1,trials0c2) intersect(trials100c2,trials0c1)];
choice100versus100s=[intersect(trials100c1,trials100sc2) intersect(trials100c2,trials100sc1)];
choice50versus100s=[intersect(trials50c1,trials100sc2) intersect(trials50c2,trials100sc1)];
choice50versus0=[intersect(trials50c1,trials0c2) intersect(trials50c2,trials0c1)];
choice100sversus0=[intersect(trials100sc1,trials0c2) intersect(trials100sc2,trials0c1)];


%for behavior we should collect all single trials and which the monkey
%chose and combine all sessions included in the analyses to get the final
%percentages.. i did not write this in but i got close... see what i do
%below
fractsvalue1=PDS.fractals;
fractsvalue1(completedtrial_s)=0;
fractsvalue1(find(PDS.repeatflag==1))=0;
fractsvalue1(trials100c1)=100;
fractsvalue1(trials50c1)=50;
fractsvalue1(trials100sc1)=25;
fractsvalue1(trials0c1)=1;
fractsvalue2=PDS.fractals2;
fractsvalue2(find(PDS.repeatflag==1))=0;
fractsvalue2(trials100c2)=100;
fractsvalue2(trials50c2)=50;
fractsvalue2(trials100sc2)=25;
fractsvalue2(trials0c2)=1;
Chosenvalue=[];
for x=1:length(PDS.chosenwindow)
    if PDS.chosenwindow(x)==1
        x=fractsvalue1(x);
    elseif PDS.chosenwindow(x)==2
        x=fractsvalue2(x);
    elseif PDS.chosenwindow(x)==0
        x=NaN;
    end
    Chosenvalue=[Chosenvalue; x]; %we can use this to calculate percentages easily or save trial type and waht the monkey chose in a huge matrix for all sessions
end


%this makes the behavior summary for CHOICE Trials only. measure for single
%trials for the summary get done later
ResponseTime=PDS.windowchosen-0.75-PDS.timetargeton;
ResponseTime(find(ResponseTime<0))=NaN;
BehaviortosaveforSummary=[fractsvalue1' fractsvalue2' Chosenvalue ResponseTime']; %here is the matrix to save for behavioral summary
BehaviortosaveforSummary=BehaviortosaveforSummary(find(fractsvalue1>0),:); %NaN's in third colum means monkey refused to choose


%%this later will need to be implemented for studying choice activity
%%because if the animal can know what fractas are going to come analyzing
%%the choice related activity before he makes the choice is not as
%%meaningful.
%Chosenvalue(find(PDS.repeatflag==1)+1)=NaN;
%Chosenvalue(find(PDS.fixOverlap~=0.5))=NaN;


%organize choices
choice100_versus0_=choice100versus0;
choice100_versus100s_=choice100versus100s;
choice50_versus100s_=choice50versus100s;
choice50_versus0_=choice50versus0;
choice100s_versus50_=choice50versus100s;
choice100_versus50_=choice100versus50;
choice100s_versus0_=choice100sversus0;
%
choice100_versus0=intersect(find(Chosenvalue==100),choice100versus0);
choice100_versus100s=intersect(find(Chosenvalue==100),choice100versus100s);
choice50_versus100s=intersect(find(Chosenvalue==50),choice50versus100s);
choice50_versus0=intersect(find(Chosenvalue==50),choice50versus0);
choice100s_versus50=intersect(find(Chosenvalue==25),choice50versus100s);
choice100_versus50=intersect(find(Chosenvalue==100),choice100versus50);
choice100s_versus0=intersect(find(Chosenvalue==25),choice100sversus0);
%
%performance for ploting
c100v50=length(choice100_versus50)./length(choice100_versus50_)*100
c100v100s=length(choice100_versus100s)./length(choice100_versus100s_)*100
c100v0=length(choice100_versus0)./length(choice100_versus0_)*100

c50v100s=length(choice50_versus100s)./length(choice100s_versus50_)*100
c50v0=length(choice50_versus0)./length(choice50_versus0_)*100

c100sv0=length(choice100s_versus0)./length(choice100s_versus0_)*100


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%MAKE A RASTER AND A SPIKE DENSITY FUNCTION FOR EVERY TRIAL for CSs

Rasters=[];
for x=1:length(PDS.fractals)
    %
    spk=PDS(1).sptimes{x}-PDS.timetargeton(x);
    
    spk=(spk*1000)+CENTER;%-1;
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


SDFcs=plot_mean_psth({Rasters},gauswindow_ms,1,(CENTER*2)-2,1); close all;
Rasterscs=Rasters;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MAKE A RASTER AND A SPIKE DENSITY FUNCTION FOR CHOICE TRIALS ALIGNED ON
%CHOSEN WINDOW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Rasters=[];
for x=1:length(PDS.fractals)
    spk=PDS(1).sptimes{x}-PDS.windowchosen(x);
    
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
SDFchosenwindow=plot_mean_psth({Rasters},gauswindow_ms,1,(CENTER*2)-2,1); close all;
RastersChosenwindow=Rasters;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%spike statistics

figuren;
%%%100p
nsubplot(15,15,1:2,2:4)
trials100p=[trials100p trials100a];
h=area(nanmean(SDFcs(trials100p,11000-1000-750:13500+1500)));  %,'r','LineWidth',3); hold on
h.FaceColor = 'red';
hold on
axis([0 5000 0 150])
title('100% Probability large reward')
xuncert=[Rasterscs(trials100p,11000-1000-750:13500+1500)];
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
maxY_rast=tq+10;

for line = 1:size(rastList,1)
    hold on
    curY_rast = maxY_rast-rasIntv*line;
    plot([rastList(line,:); rastList(line,:)],...
        [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
        (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor );
end
clear xuncert rasts MatPlot rastList
x=[750,750]; y=[0,150]; plot(x,y,'k'); hold on;
clear x
x=[1750,1750]; y=[0,150]; plot(x,y,'k'); hold on;
clear x
x=[4250,4250]; y=[0,150]; plot(x,y,'k'); hold on;
clear x

%%%50p
nsubplot(15,15,1:2,5:7)

h2=area(nanmean(SDFcs(trials50p,11000-1000-750:13500+1500))); hold on %,'r','LineWidth',3); hold on
h2.FaceColor = 'red';
axis([0 5000 0 150])
title('50% Probability large reward')
xuncert=[Rasterscs(intersect(trials50p,deliv),11000-1000-750:13500+1500)];
xuncertnd=[Rasterscs(intersect(trials50p,ndeliv),11000-1000-750:13500+1500)];
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
LColor='k';
maxY_rast=tq+10;
for line = 1:size(rastList,1)
    hold on
    curY_rast = maxY_rast-rasIntv*line;
    plot([rastList(line,:); rastList(line,:)],...
        [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
        (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor );
end
clear xuncert rastList MatPlot rastList rasts
xt=[];
rasts=[];

for tq=1:size(xuncertnd,1)
    Z=xuncertnd(tq,:);
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
MatPlot(1:size(xuncertnd,1),1:max(xt))=NaN
for tq=1:size(xuncertnd,1)
    temptq=find(rasts(tq,:)>0);
    MatPlot(tq,1:length(temptq))=temptq;
end
rastList=MatPlot;
rasIntv=1;
LWidth=1;
LColor='b';
maxY_rast=tq+30;
for line = 1:size(rastList,1)
    hold on
    curY_rast = maxY_rast-rasIntv*line;
    plot([rastList(line,:); rastList(line,:)],...
        [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
        (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor )
end
clear xuncertnd rasts MatPlot rastList
x=[750,750]; y=[0,150]; plot(x,y,'k'); hold on;
clear x
x=[1750,1750]; y=[0,150]; plot(x,y,'k'); hold on;
clear x
x=[4250,4250]; y=[0,150]; plot(x,y,'k'); hold on;
clear x

%%%0p
nsubplot(15,15,1:2,8:10)
trials0p=[trials0p trials0a];
h3=area(nanmean(SDFcs(trials0p,11000-1000-750:13500+1500))); hold on %,'r','LineWidth',3); hold on
h3.FaceColor = 'red';
axis([0 5000 0 150])
title('No reward')
xuncert=[Rasterscs(trials0p,11000-1000-750:13500+1500)];
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
LColor='k';
maxY_rast=tq+10;

for line = 1:size(rastList,1)
    hold on
    curY_rast = maxY_rast-rasIntv*line;
    plot([rastList(line,:); rastList(line,:)],...
        [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
        (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor );
end
clear xuncert rasts MatPlot rastList
x=[750,750]; y=[0,150]; plot(x,y,'k'); hold on;
clear x
x=[1750,1750]; y=[0,150]; plot(x,y,'k'); hold on;
clear x
x=[4250,4250]; y=[0,150]; plot(x,y,'k'); hold on;
clear x




asdfsdf
%%%100sa
nsubplot(150,150,1:21,71:91)
h5=area(nanmean(SDFcs(trials100sa,11000-1000-750:13500+1500))); hold on %,'r','LineWidth',3); hold on
h5.FaceColor = 'red';
axis([0 5000 0 150])
title('Small reward')
xuncert=[Rasterscs(trials100sa,11000-1000-750:13500+1500)];
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
LColor='k';
maxY_rast=tq+10;

for line = 1:size(rastList,1)
    hold on
    curY_rast = maxY_rast-rasIntv*line;
    plot([rastList(line,:); rastList(line,:)],...
        [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
        (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor );
end
clear xuncert rasts MatPlot rastList
x=[750,750]; y=[0,150]; plot(x,y,'k'); hold on;
clear x
x=[1750,1750]; y=[0,150]; plot(x,y,'k'); hold on;
clear x
x=[4250,4250]; y=[0,150]; plot(x,y,'k'); hold on;
clear x
% 
% %%%0a
% nsubplot(150,150,41:61,71:91)
% h6=area(nanmean(SDFcs(trials0a,11000-1000-750:13500+1500))); hold on %,'r','LineWidth',3); hold on
% h6.FaceColor = 'red';
% axis([0 5000 0 150])
% title('No reward')
% xuncert=[Rasterscs(trials0a,11000-1000-750:13500+1500)];
% xt=[];
% rasts=[];
% for tq=1:size(xuncert,1)
%     Z=xuncert(tq,:);
%     Z(find(Z==1))=(find(Z==1));
%     Z(find(Z==0))=NaN;
%     xt_=length(find(Z>0));
%     if isempty(xt_)==1
%         xt_=NaN;
%     end
%     xt=[xt; xt_];
%     rasts=[rasts; Z];
%     clear Z tq xt_
% end
% MatPlot(1:size(xuncert,1),1:max(xt))=NaN;
% for tq=1:size(xuncert,1)
%     temptq=find(rasts(tq,:)>0);
%     MatPlot(tq,1:length(temptq))=temptq;
% end
% rastList=MatPlot;
% rasIntv=1;
% LWidth=1;
% LColor='k';
% maxY_rast=tq+10;
% 
% for line = 1:size(rastList,1)
%     hold on
%     curY_rast = maxY_rast-rasIntv*line;
%     plot([rastList(line,:); rastList(line,:)],...
%         [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
%         (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor );
% end
% clear xuncert rasts MatPlot rastList
% x=[750,750]; y=[0,150]; plot(x,y,'k'); hold on;
% clear x
% x=[1750,1750]; y=[0,150]; plot(x,y,'k'); hold on;
% clear x
% x=[4250,4250]; y=[0,150]; plot(x,y,'k'); hold on;
% clear x




% figure; 
% plot(nanmean(SDFcs([trials0a trials0p],11000:13500)))
% hold on
% plot(nanmean(SDFcs([trials100a trials100p],11000:13500)),'k')
% plot(nanmean(SDFcs([trials100sa],11000:13500)),'b--')
% hold on
% plot(nanmean(SDFcs([trials50p],11000:13500)),'k--')
% close all

WindowAn=[11100:13500];
nsubplot(150,150,1:21,130:150)
pBIG=nanmean(SDFcs(trials100p_,WindowAn)')';
pMID=nanmean(SDFcs(trials50p,WindowAn)')';
pSM=nanmean(SDFcs(trials0p_,WindowAn)')';
aBIG=nanmean(SDFcs(trials100a_,WindowAn)')';
aMID=nanmean(SDFcs(trials100sa,WindowAn)')';
aSM=nanmean(SDFcs(trials0a_,WindowAn)')';
errorbar([mean(pBIG) mean(pMID) mean(pSM)],[std(pBIG)./sqrt(length(pBIG)) std(pMID)./sqrt(length(pMID)) std(pSM)./sqrt(length(pSM))],'r','LineWidth',3); hold on
errorbar([mean(aBIG) mean(aMID) mean(aSM)],[std(aBIG)./sqrt(length(aBIG)) std(aMID)./sqrt(length(aMID)) std(aSM)./sqrt(length(aSM))],'k','LineWidth',3); hold on
set(gca,'XTickLabel','')
xlim([0 4]);
axis square;
text(1.5,15,['Prob_p=' num2str(round(ranksum(aSM,aMID)*100)/100)]);
text(1.5,5,['Prob_p=' num2str(round(ranksum(aSM,aMID)*100)/100)]);
text(1.5,-5,['Prob_p=' num2str(round(ranksum(aSM,aMID)*100)/100)]);
ylim([0 150])

% WindowAn=[13500-750:13500];
% nsubplot(150,150,31:51,130:150)
% pBIG=nanmean(SDFcs(trials100p_,WindowAn)')';
% pMID=nanmean(SDFcs(trials50p,WindowAn)')';
% pSM=nanmean(SDFcs(trials0p_,WindowAn)')';
% aBIG=nanmean(SDFcs(trials100a_,WindowAn)')';
% aMID=nanmean(SDFcs(trials100sa,WindowAn)')';
% aSM=nanmean(SDFcs(trials0a_,WindowAn)')';
% errorbar([mean(pBIG) mean(pMID) mean(pSM)],[std(pBIG)./sqrt(length(pBIG)) std(pMID)./sqrt(length(pMID)) std(pSM)./sqrt(length(pSM))],'r','LineWidth',3); hold on
% errorbar([mean(aBIG) mean(aMID) mean(aSM)],[std(aBIG)./sqrt(length(aBIG)) std(aMID)./sqrt(length(aMID)) std(aSM)./sqrt(length(aSM))],'k','LineWidth',3); hold on
% set(gca,'XTickLabel','')
% xlim([0 4]);
% axis square;
% text(1.5,15,['Prob_p=' num2str(round(ranksum(aSM,aMID)*100)/100)]);
% text(1.5,5,['Prob_p=' num2str(round(ranksum(aSM,aMID)*100)/100)]);
% text(1.5,-5,['Prob_p=' num2str(round(ranksum(aSM,aMID)*100)/100)]);
% ylim([0 150])






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%CHOICE ANALYSIS
% 
startIndexForPvalCalcs=11000+100;
trials1=[choice100_versus100s' choice100_versus50' choice100_versus0'];
trials2=[choice50_versus100s' choice50_versus0'];
trials3=[choice100s_versus0];
% 
ch1=SDFcs(trials1,:);
ch2=SDFcs(trials2,:);
ch3=SDFcs(trials3,:);
PvalueSaveCS=[];
UncertsaveCS=[];
ValuesaveCS=[];
for x = 1:size(ch1,2)-BinForStat-1
    t1=nanmean(ch1(:,x:x+BinForStat)')';
    t2=nanmean(ch2(:,x:x+BinForStat)')';
    t3=nanmean(ch3(:,x:x+BinForStat)')';
    t1(1:length(t1),2)=1;
    t2(1:length(t2),2)=2;
    t3(1:length(t3),2)=3;

    temp=[t1; t2; t3;];

    P=kruskalwallis(temp(:,1),temp(:,2),'off');
    PvalueSaveCS=[PvalueSaveCS; P];
    %secondary test --
    if P<kruskalpvalueforfunningtests
        %does it have value signals (e.g. big versus small rew)
        valuestodefine=[nanmean(t1(:,1)) nanmean(t2(:,1)) nanmean(t3(:,1))];
        valuestodefine_pval=[ranksum(t1(:,1),t2(:,1)) ranksum(t1(:,1),t3(:,1)) ranksum(t2(:,1),t3(:,1))];
        [x,maxval]=max(valuestodefine);
        [x,minval]=min(valuestodefine);

        if (maxval==1 & minval==3 & valuestodefine_pval(2)<pvalueLimitContplot) || ...
                (maxval==1 & minval==2 & valuestodefine_pval(1)<pvalueLimitContplot & valuestodefine_pval(3) >pvalueLimitContplot)
            posnothinneg=1;
        elseif valuestodefine_pval(2)>pvalueLimitContplot
            posnothinneg=0;
        elseif (maxval==3 & minval==1 & valuestodefine_pval(2)<pvalueLimitContplot) || ...
                (maxval==3 & minval==2 & valuestodefine_pval(3)<pvalueLimitContplot & valuestodefine_pval(1)>pvalueLimitContplot)
            posnothinneg=-1;
        else
            posnothinneg=0;
        end
        %does it uncertselective signals (excite or inhibit)
        if maxval==2 & valuestodefine_pval(1)<pvalueLimitContplot & valuestodefine_pval(3)<pvalueLimitContplot
            uncertcode=1;
        elseif minval==2 & valuestodefine_pval(1)<pvalueLimitContplot & valuestodefine_pval(3)<pvalueLimitContplot
            uncertcode=-1;
        else
            uncertcode=0;
        end
    else
        posnothinneg=0;
        uncertcode=0;
    end
    
    UncertsaveCS=[UncertsaveCS; uncertcode];
    ValuesaveCS=[ValuesaveCS; posnothinneg];   
    clear P t1 t2 t3 t4 t5 t6 temp PlotPvalue posnothinneg uncertcode
end

ch1=SDFchosenwindow(trials1,:);
ch2=SDFchosenwindow(trials2,:);
ch3=SDFchosenwindow(trials3,:);
PvalueSaveCHSN=[];
UncertsaveCHSN=[];
ValuesaveCHSN=[];
for x = 1:size(ch1,2)-BinForStat-1
    t1=nanmean(ch1(:,x:x+BinForStat)')';
    t2=nanmean(ch2(:,x:x+BinForStat)')';
    t3=nanmean(ch3(:,x:x+BinForStat)')';
    t1(1:length(t1),2)=1;
    t2(1:length(t2),2)=2;
    t3(1:length(t3),2)=3;
    temp=[t1; t2; t3;];
    P=kruskalwallis(temp(:,1),temp(:,2),'off');
    PvalueSaveCHSN=[PvalueSaveCHSN; P];
    %secondary test --
    if P<kruskalpvalueforfunningtests
        %does it have value signals (e.g. big versus small rew)
        valuestodefine=[nanmean(t1(:,1)) nanmean(t2(:,1)) nanmean(t3(:,1))];
        valuestodefine_pval=[ranksum(t1(:,1),t2(:,1)) ranksum(t1(:,1),t3(:,1)) ranksum(t2(:,1),t3(:,1))];
        [x,maxval]=max(valuestodefine);
        [x,minval]=min(valuestodefine);

        if (maxval==1 & minval==3 & valuestodefine_pval(2)<pvalueLimitContplot) || ...
                (maxval==1 & minval==2 & valuestodefine_pval(1)<pvalueLimitContplot & valuestodefine_pval(3) >pvalueLimitContplot)
            posnothinneg=1;
        elseif valuestodefine_pval(2)>pvalueLimitContplot
            posnothinneg=0;
        elseif (maxval==3 & minval==1 & valuestodefine_pval(2)<pvalueLimitContplot) || ...
                (maxval==3 & minval==2 & valuestodefine_pval(3)<pvalueLimitContplot & valuestodefine_pval(1)>pvalueLimitContplot)
            posnothinneg=-1;
        else
            posnothinneg=0;
        end  
        %does it uncertselective signals (excite or inhibit)
        if maxval==2 & valuestodefine_pval(1)<pvalueLimitContplot & valuestodefine_pval(3)<pvalueLimitContplot
            uncertcode=1;
        elseif minval==2 & valuestodefine_pval(1)<pvalueLimitContplot & valuestodefine_pval(3)<pvalueLimitContplot
            uncertcode=-1;
        else
            uncertcode=0;
        end
    else
        posnothinneg=0;
        uncertcode=0;
    end
    UncertsaveCHSN=[UncertsaveCHSN; uncertcode];
    ValuesaveCHSN=[ValuesaveCHSN; posnothinneg];
    clear P t1 t2 t3 t4 t5 t6 temp PlotPvalue posnothinneg uncertcode
end

%evaluation epoch
nsubplot(150,150,110:150,30:61)
try
    trials1=[choice100_versus100s' choice100_versus50' choice100_versus0'];
    trials2=[choice50_versus100s' choice50_versus0'];
    trials3=[choice100s_versus0'];
catch 
    trials1=[choice100_versus100s choice100_versus50 choice100_versus0];
    trials2=[choice50_versus100s choice50_versus0];
    trials3=[choice100s_versus0];
end
RT1=nanmedian(ResponseTime(trials1))*1000;
prechoiceWillChoose100 = nanmean(SDFcs((trials1),11000:11000+RT1),1);
plot([500:500+RT1],prechoiceWillChoose100 ,'k','LineWidth',3); hold on
hold on
RT2=floor(nanmedian(ResponseTime(trials2))*1000);
prechoiceWillChoose50 = nanmean(SDFcs((trials2),11000:11000+RT2),1);
plot([500:500+RT2],prechoiceWillChoose50,'r','LineWidth',3); hold on
hold on
RT3=floor(nanmedian(ResponseTime(trials3))*1000);
prechoiceWillChoose100s = nanmean(SDFcs((trials3),11000:11000+RT3),1);
plot([500:500+RT3],prechoiceWillChoose100s ,'g','LineWidth',3); hold on
hold on

clear PlotPvalue
temp=UncertsaveCS(11000:11700);
PlotPvalue(1:length(temp))=NaN;
PlotPvalue(find(abs(temp)==1))=ylimvaRmin+10;
plot([500+50:500+length(PlotPvalue)-1+50],PlotPvalue,'r','LineWidth',4); hold on; %put line at fixation cue goes off

%
preEyeinrangein=[(11000-750-250):(11000 +1000)];
chosen100WpreEyeIn=(SDFchosenwindow([choice100_versus50' choice100_versus100s' choice100_versus0'],preEyeinrangein));
chosen50WpreEyeIn=(SDFchosenwindow([choice50_versus100s' choice50_versus0'],preEyeinrangein));
chosen100sWpreEyeIn=(SDFchosenwindow([choice100s_versus0],preEyeinrangein));
plot(1500:1500+2000,nanmean(chosen100WpreEyeIn),'k','LineWidth',3); hold on
hold on
plot(1500:1500+2000,nanmean(chosen50WpreEyeIn),'r','LineWidth',3); hold on
hold on
plot(1500:1500+2000,nanmean(chosen100sWpreEyeIn),'g','LineWidth',3); hold on
%
x=[1000,1000]; y=[0,175]; plot(x,y,'k'); hold on; %put line at targetson
x=[1750,1750]; y=[0,175]; plot(x,y,'k'); hold on; %put line at targetson
x=[1750+750,1750+750]; y=[0,175]; plot(x,y,'k'); hold on; %put line at targetson
x=[1750+750+1000,1750+750+1000]; y=[0,175]; plot(x,y,'k'); hold on; %put line at targetson
%
clear PlotPvalue
temp=UncertsaveCHSN(preEyeinrangein);
PlotPvalue(1:length(temp))=NaN;
PlotPvalue(find(abs(temp)==1))=ylimvaRmin+10;
plot([1500+50:1500+2000+50],PlotPvalue,'r','LineWidth',4); hold on; %put line at fixation cue goes off
%
xlim([500 3500])
ylim([ylimvaRmin ylimvaR])

nsubplot(150,150,110:150,120:150)
wholeAnalysisEpoch=11100:13500;
t1=nanmean(SDFcs(trials100,wholeAnalysisEpoch)');
t1(2,1:length(t1))=3;
t2=nanmean(SDFcs(trials100s,wholeAnalysisEpoch)');
t2(2,1:length(t2))=2;
t3=nanmean(SDFcs(trials0,wholeAnalysisEpoch)');
t3(2,1:length(t2))=1;
temp=[t1'; t2'; t3'];
[pval_valuereg, r_valuereg]=permutation_pair_test_fast(temp(:,1),temp(:,2),ShuffleTime,'corr'); clear temp;
text(1,1,mat2str(pval_valuereg))
text(10,10,mat2str(r_valuereg))

set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
print('-dpdf', titleofplot);

close all
sdafsdfasdfa
