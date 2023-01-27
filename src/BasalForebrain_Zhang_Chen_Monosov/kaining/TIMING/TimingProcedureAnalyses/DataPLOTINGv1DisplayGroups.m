clc; clear all; close all;
addpath('HELPER_GENERAL');
load timingproceduresummary3monksBF_tonic.mat
rangeCS=[100:1500]; %CS region
region=[1600:1900]; %outcome region
yll=-15;
ylmax=35;
linew=2;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

BFPacrossresponses=[];
BFPc=[];
BFRc=[];
BFresponse75=[];
BFresponse25=[];
BFresponse50=[];
BFranksum75v50=[];
BFranksum25v50=[];
BFranksum25v75=[];
BFrocarea375v50=[];
BFrocarea325v50=[];
BFrocarea325v75=[];
BFs6102_50s=[];
BFs6102_50l=[];
BFs6104=[];
BFs6103_75s=[];
BFs6103_25l=[];
BFs6101_25s=[];
BFs6101_75l=[];
BFPvalueSaveCor=[];
BFPvalueSave=[];
BFSaveCor=[];
BFROC_6105VS6101=[];
BFP_6105VS6101=[];
BFs6105_25ms=[];
BFs6105_25ml=[];
BFs6105_25l=[];
BFs6105_25s=[];
BFs6201d=[];
BFs6201nd=[];
BFs6201=[];
BFPvalueSaveHz=[];
BFhz6101=[];
BFhz6102=[];
BFhz6103=[];
BFhz6104=[];
BFhz=[];
BFac=[];
BF_Roc_RPE=[];
BF_P_RPE=[];
BF_tRoc_RPE=[];
BF_tP_PPE=[];
BF_Presponse=[];
BFPacrossresponses_long=[];
BFs6102_50l_match=[];
BF6105=[];

for x=1:length(savestruct)
    filler(1:6001)=NaN;
    filler1(1:2901)=NaN;
    
    TrialNoInc=2;
    if size(savestruct(x).s6102_50s,2)>TrialNoInc ...
            & size(savestruct(x).s6102_50l,2)>TrialNoInc ...
            & size(savestruct(x).s6103_25l,2)>TrialNoInc ...
            & size(savestruct(x).s6103_75s,2)>TrialNoInc & ...
            size(savestruct(x).s6101_75l,2)>TrialNoInc ...
            & size(savestruct(x).s6101_25s,2)>TrialNoInc & ...
            length(savestruct(x).s6102_50s)>TrialNoInc & ...
            length(savestruct(x).s6102_50l)>TrialNoInc & ...
            length(savestruct(x).s6103_25l)>TrialNoInc & ...
            length(savestruct(x).s6103_75s)>TrialNoInc &  ...
            length(savestruct(x).s6101_25s)>TrialNoInc & ...
            length(savestruct(x).s6101_75l)>TrialNoInc & ...
            isempty(savestruct(x).response75)==0 & ...
            isnan(nanmean(savestruct(x).s6101_25s))==0
        
        BF6105=[ BF6105; savestruct(x).s6105_25l];
        
        
        BFPacrossresponses=[BFPacrossresponses;savestruct(x).Pacrossresponses];
        
        BFPc=[BFPc;savestruct(x).Pc];
        BFRc=[BFRc;savestruct(x).Rc];
        
        BFranksum75v50=[BFranksum75v50;savestruct(x).ranksum75v50];
        BFranksum25v50=[BFranksum25v50;savestruct(x).ranksum25v50];
        
        BFrocarea375v50=[BFrocarea375v50;savestruct(x).rocarea375v50];
        BFrocarea325v50=[BFrocarea325v50;savestruct(x).rocarea325v50];
        
        BFs6102_50s=[BFs6102_50s;savestruct(x).s6102_50s];
        BFs6102_50l=[BFs6102_50l;savestruct(x).s6102_50l];
        BFs6104=[BFs6104;savestruct(x).s6104];
        BFs6103_75s=[BFs6103_75s;savestruct(x).s6103_75s];
        BFs6103_25l=[BFs6103_25l;savestruct(x).s6103_25l];
        BFs6101_25s=[BFs6101_25s;savestruct(x).s6101_25s];
        BFs6101_75l=[BFs6101_75l;savestruct(x).s6101_75l];
        BFSaveCor=[BFSaveCor;savestruct(x).SaveCor'];
        %        BFPvalueSave=[BFPvalueSave;savestruct(x).PvalueSave'];
        %      BFPvalueSaveCor=[BFPvalueSaveCor;savestruct(x).PvalueSaveCor'];
        
        if length(savestruct(x).s6201d)>1 & length(savestruct(x).s6201nd)>1 & ...
                isnan(nanmean(savestruct(x).s6201d))==0 & isnan(nanmean(savestruct(x).s6201nd))==0
            BFs6201d=[BFs6201d; savestruct(x).s6201d];
            BFs6201nd=[BFs6201nd; savestruct(x).s6201nd];
            BFs6102_50l_match=[BFs6102_50l_match;savestruct(x).s6102_50l];
        else
            temp(1:6001)=NaN;
            BFs6201d=[BFs6201d; temp];
            BFs6201nd=[BFs6201nd; temp];
            BFs6102_50l_match=[BFs6102_50l_match;temp];
        end
        
    end
end

BFs6101_75lT=BFs6101_75l;

indexresponse=find(BFPacrossresponses<0.05);

%normalize to pre CS baseline and clear
shift_plot=repmat(nanmean(BFs6104(:,1:15)')',1,size(BFs6101_75l,2));
BFs6101_75l=BFs6101_75l-shift_plot;
BFs6102_50l=BFs6102_50l-shift_plot;
BFs6103_25l=BFs6103_25l-shift_plot;
BFs6101_25s=BFs6101_25s-shift_plot;
BFs6102_50s=BFs6102_50s-shift_plot;
BFs6103_75s=BFs6103_75s-shift_plot;
BFs6104=BFs6104-shift_plot;
BFs6201nd=BFs6201nd-shift_plot;
BFs6201d=BFs6201d-shift_plot;
BFs6102_50l_match=BFs6102_50l_match-shift_plot;
clear shift_plot

BFs6101_75l_=BFs6101_75l(:,1500:end);
BFs6102_50l_=BFs6102_50l(:,1500:end);
BFs6103_25l_=BFs6103_25l(:,1500:end);

temp=([BFs6101_75l_'; BFs6102_50l_'; BFs6103_25l_']');
BFs6101_75l_=BFs6101_75l_-repmat(min(temp')',1,size(BFs6101_75l_,2));
BFs6102_50l_=BFs6102_50l_-repmat(min(temp')',1,size(BFs6102_50l_,2));
BFs6103_25l_=BFs6103_25l_-repmat(min(temp')',1,size(BFs6103_25l_,2));
temp=([BFs6101_75l_'; BFs6102_50l_'; BFs6103_25l_']');
BFs6101_75l_=BFs6101_75l_./repmat(max(temp')',1,size(BFs6101_75l_,2));
BFs6102_50l_=BFs6102_50l_./repmat(max(temp')',1,size(BFs6102_50l_,2));
BFs6103_25l_=BFs6103_25l_./repmat(max(temp')',1,size(BFs6103_25l_,2));
clear temp

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure
nsubplot(400,400,101:175,1:50); hold on; set(gca,'ticklength',4*get(gca,'ticklength'))
%
plot(nanmean(BFs6104(:,1:1450)),'k','LineWidth',1); 
plot(nanmean(BFs6101_75l(:,1:1450)),'g','LineWidth',1); 
plot(nanmean(BFs6102_50l(:,1:1450)),'r','LineWidth',1); 
plot(nanmean(BFs6103_75s(:,1:1450)),'m','LineWidth',1); 
xlim([0 1500])
title(['n=  ' mat2str(size(BFs6101_75l,1))])
ylim([-15 12])
t=ylabel('Baseline subtracted activity (spikes/s)'); set(t, 'FontSize', 8);

nsubplot(400,400,101:175,61:110); hold on;
set(gca,'ticklength',4*get(gca,'ticklength'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load timingproceduresummary3monksBF_phasic.mat
yll=-15;
ylmax=35;
linew=2;
rangeCS=[100:600]; %CS region
region=[1600:1900]; %outcome region

BFPacrossresponses=[];
BFPc=[];
BFRc=[];
BFresponse75=[];
BFresponse25=[];
BFresponse50=[];
BFranksum75v50=[];
BFranksum25v50=[];
BFranksum25v75=[];
BFrocarea375v50=[];
BFrocarea325v50=[];
BFrocarea325v75=[];
BFs6102_50s=[];
BFs6102_50l=[];
BFs6104=[];
BFs6103_75s=[];
BFs6103_25l=[];
BFs6101_25s=[];
BFs6101_75l=[];
BFPvalueSaveCor=[];
BFPvalueSave=[];
BFSaveCor=[];
BFROC_6105VS6101=[];
BFP_6105VS6101=[];
BFs6105_25ms=[];
BFs6105_25ml=[];
BFs6105_25l=[];
BFs6105_25s=[];
BFs6201d=[];
BFs6201nd=[];
BFs6201=[];
BFPvalueSaveHz=[];
BFhz6101=[];
BFhz6102=[];
BFhz6103=[];
BFhz6104=[];
BFhz=[];
BFac=[];
BF_Roc_RPE=[];
BF_P_RPE=[];
BF_tRoc_RPE=[];
BF_tP_PPE=[];
BF_Presponse=[];
BFPacrossresponses_long=[];
BFs6102_50l_match=[];
 BF6105P=[];
for x=1:length(savestruct)
    filler(1:6001)=NaN;
    filler1(1:2901)=NaN;
    
    TrialNoInc=2;
    if size(savestruct(x).s6102_50s,2)>TrialNoInc ...
            & size(savestruct(x).s6102_50l,2)>TrialNoInc ...
            & size(savestruct(x).s6103_25l,2)>TrialNoInc ...
            & size(savestruct(x).s6103_75s,2)>TrialNoInc & ...
            size(savestruct(x).s6101_75l,2)>TrialNoInc ...
            & size(savestruct(x).s6101_25s,2)>TrialNoInc & ...
            length(savestruct(x).s6102_50s)>TrialNoInc & ...
            length(savestruct(x).s6102_50l)>TrialNoInc & ...
            length(savestruct(x).s6103_25l)>TrialNoInc & ...
            length(savestruct(x).s6103_75s)>TrialNoInc &  ...
            length(savestruct(x).s6101_25s)>TrialNoInc & ...
            length(savestruct(x).s6101_75l)>TrialNoInc & ...
            isempty(savestruct(x).response75)==0 & ...
            isnan(nanmean(savestruct(x).s6101_25s))==0
        
        
        
  BF6105P=[ BF6105P; savestruct(x).s6105_25l];
        

        
        BFPacrossresponses=[BFPacrossresponses;savestruct(x).Pacrossresponses];
        
        BFPc=[BFPc;savestruct(x).Pc];
        BFRc=[BFRc;savestruct(x).Rc];
        
        BFranksum75v50=[BFranksum75v50;savestruct(x).ranksum75v50];
        BFranksum25v50=[BFranksum25v50;savestruct(x).ranksum25v50];
        
        BFrocarea375v50=[BFrocarea375v50;savestruct(x).rocarea375v50];
        BFrocarea325v50=[BFrocarea325v50;savestruct(x).rocarea325v50];
        
        BFs6102_50s=[BFs6102_50s;savestruct(x).s6102_50s];
        BFs6102_50l=[BFs6102_50l;savestruct(x).s6102_50l];
        BFs6104=[BFs6104;savestruct(x).s6104];
        BFs6103_75s=[BFs6103_75s;savestruct(x).s6103_75s];
        BFs6103_25l=[BFs6103_25l;savestruct(x).s6103_25l];
        BFs6101_25s=[BFs6101_25s;savestruct(x).s6101_25s];
        BFs6101_75l=[BFs6101_75l;savestruct(x).s6101_75l];
        BFSaveCor=[BFSaveCor;savestruct(x).SaveCor'];
        %        BFPvalueSave=[BFPvalueSave;savestruct(x).PvalueSave'];
        %      BFPvalueSaveCor=[BFPvalueSaveCor;savestruct(x).PvalueSaveCor'];
        
        if length(savestruct(x).s6201d)>1 & length(savestruct(x).s6201nd)>1 & ...
                isnan(nanmean(savestruct(x).s6201d))==0 & isnan(nanmean(savestruct(x).s6201nd))==0
            BFs6201d=[BFs6201d; savestruct(x).s6201d];
            BFs6201nd=[BFs6201nd; savestruct(x).s6201nd];
            BFs6102_50l_match=[BFs6102_50l_match;savestruct(x).s6102_50l];
        else
            temp(1:6001)=NaN;
            BFs6201d=[BFs6201d; temp];
            BFs6201nd=[BFs6201nd; temp];
            BFs6102_50l_match=[BFs6102_50l_match;temp];
        end
        
    end
end
indexresponse=find(BFPacrossresponses<0.05);


 BFs6101_75lP= BFs6101_75l;


%normalize to pre CS baseline and clear
shift_plot=repmat(nanmean(BFs6104(:,1:15)')',1,size(BFs6101_75l,2));
BFs6101_75l=BFs6101_75l-shift_plot;
BFs6102_50l=BFs6102_50l-shift_plot;
BFs6103_25l=BFs6103_25l-shift_plot;
BFs6101_25s=BFs6101_25s-shift_plot;
BFs6102_50s=BFs6102_50s-shift_plot;
BFs6103_75s=BFs6103_75s-shift_plot;
BFs6104=BFs6104-shift_plot;
BFs6201nd=BFs6201nd-shift_plot;
BFs6201d=BFs6201d-shift_plot;
BFs6102_50l_match=BFs6102_50l_match-shift_plot;
clear shift_plot

BFs6101_75l_=BFs6101_75l(:,1500:end);
BFs6102_50l_=BFs6102_50l(:,1500:end);
BFs6103_25l_=BFs6103_25l(:,1500:end);

temp=([BFs6101_75l_'; BFs6102_50l_'; BFs6103_25l_']');
BFs6101_75l_=BFs6101_75l_-repmat(min(temp')',1,size(BFs6101_75l_,2));
BFs6102_50l_=BFs6102_50l_-repmat(min(temp')',1,size(BFs6102_50l_,2));
BFs6103_25l_=BFs6103_25l_-repmat(min(temp')',1,size(BFs6103_25l_,2));
temp=([BFs6101_75l_'; BFs6102_50l_'; BFs6103_25l_']');
BFs6101_75l_=BFs6101_75l_./repmat(max(temp')',1,size(BFs6101_75l_,2));
BFs6102_50l_=BFs6102_50l_./repmat(max(temp')',1,size(BFs6102_50l_,2));
BFs6103_25l_=BFs6103_25l_./repmat(max(temp')',1,size(BFs6103_25l_,2));
clear temp

nsubplot(400,400,101:175,61:110); hold on;
set(gca,'ticklength',4*get(gca,'ticklength'))

plot(nanmean(BFs6104(:,1:1450)),'k','LineWidth',1); 
plot(nanmean(BFs6101_75l(:,1:1450)),'g','LineWidth',1); 
plot(nanmean(BFs6102_50l(:,1:1450)),'r','LineWidth',1); 
plot(nanmean(BFs6103_75s(:,1:1450)),'m','LineWidth',1); 
xlim([0 1500])
title(['n=  ' mat2str(size(BFs6101_75l,1))])
ylim([-5 45])
t=ylabel('Baseline subtracted activity (spikes/s)'); set(t, 'FontSize', 8);

figure
plot(nanmean(BFs6101_75lP),'g'); hold on
plot(nanmean(BF6105P),'k'); hold on
x=[1500,1500]; y=[0, 45]; plot(x,y,'k'); hold on;
x=[2500,2500]; y=[0, 45]; plot(x,y,'k'); hold on;
x=[3500,3500]; y=[0, 45]; plot(x,y,'k'); hold on;
xlim([0 4400])

figure
plot(nanmean(BFs6101_75lT),'g'); hold on
plot(nanmean(BF6105),'k'); hold on
x=[1500,1500]; y=[0, 45]; plot(x,y,'k'); hold on;
x=[2500,2500]; y=[0, 45]; plot(x,y,'k'); hold on;
x=[3500,3500]; y=[0, 45]; plot(x,y,'k'); hold on;
xlim([0 4400])

asdf

set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
print('-dpdf', 'TwoGroups' );

close all;

