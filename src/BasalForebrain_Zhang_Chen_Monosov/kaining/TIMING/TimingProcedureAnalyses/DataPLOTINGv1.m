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

nsubplot(250,250,12:62,192:242)
hold on; set(gca,'ticklength',4*get(gca,'ticklength'))
p25=nanmean(BFs6101_75l(:,rangeCS)')
p50=nanmean(BFs6102_50s(:,rangeCS)')
p75=nanmean(BFs6103_75s(:,rangeCS)')
p100=nanmean(BFs6104(:,rangeCS)')
p50r=nanmean(BFs6201nd(:,rangeCS)')
%
prob=fliplr([p100' p75' p50' p25' p50r']);
prob=prob(find(isnan(mean(prob'))==0),:);


%
prob=prob-repmat(min(prob')',1,size(prob,2))
prob=prob./repmat(max(prob')',1,size(prob,2))
%
p50r=prob(:,1);
prob=prob(:,2:5);
%
GroupID=repmat([4 3 2 1], size(prob,1),1)
BFpval=kruskalwallis(prob(:),GroupID(:),'off')
[pval, R]=permutation_pair_test_fast(prob(:),GroupID(:),10000,'rankcorr')
%
ProbSE=nanstd(prob)./sqrt((size(prob,1)))
errorbar(nanmean(prob),ProbSE,'r','LineWidth',3); hold on
errorbar(6,nanmean(p50r), nanstd(p50r)./sqrt((length(p50r))) ,'b','LineWidth',3); hold on

xlim([0 7]);
ylim([0 1])
axis square;
text(1,0.6,['n=' mat2str(size(prob,1))])
text(1,0.5,['anova=' mat2str(BFpval)])
text(1,0.7,['rho=' mat2str(R) 'p=' mat2str(pval)])
text(6,0.1,['50v50r=' mat2str(signrank(p50r,prob(:,2)))])
clear prob GroupID BFpval pval R



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nsubplot(250,250,12:62,1:20)
hold on; set(gca,'ticklength',4*get(gca,'ticklength'))
plot(nanmean(BFs6104(:,1:2000)),'b','LineWidth',linew);
hold on
plot(nanmean([BFs6201nd(:,1:1500); BFs6201d(:,1:1500)]),'k','LineWidth',linew)
hold on
plot(1500:2000,nanmean(BFs6201nd(:,1500:2000)),'k','LineWidth',linew);
hold on
plot(1500:2000,nanmean(BFs6201d(:,1500:2000)),'r','LineWidth',linew);
hold on
x=[1500,1500]; y=[-60,60]; plot(x,y,'k'); hold on;
xlim([0 2250])
set(gca, 'XTick',[800 1900], 'XTickLabel',{'0\newlineTime from CS onset' '1.5 seconds', })
t=ylabel('Baseline subtracted activity (spikes/s)'); set(t, 'FontSize', 8);

xlim([0 2000])
p=signrank(nanmean(BFs6201d(:,region)'),nanmean(BFs6201nd(:,region)')); p=round(p*1000)./1000
text(1600,20,mat2str(p))
ylim([yll ylmax])

nsubplot(250,250,12:62,31:50)
hold on; set(gca,'ticklength',4*get(gca,'ticklength'))
plot(nanmean([BFs6101_75l(:,1:1500); BFs6101_25s(:,1:1500)]),'k','LineWidth',linew)
hold on
plot(1500:2000,nanmean(BFs6101_75l(:,1500:2000)),'k','LineWidth',linew);
hold on
plot(1500:2000,nanmean(BFs6101_25s(:,1500:2000)),'r','LineWidth',linew);
hold on
x=[1500,1500]; y=[-60,60]; plot(x,y,'k'); hold on;
xlim([0 2250])
set(gca, 'XTick',[800 1900], 'XTickLabel',{'0\newlineTime from CS onset' '1.5 seconds', })
xlim([0 2000])
p=signrank(nanmean(BFs6101_25s(:,region)'),nanmean(BFs6101_75l(:,region)')); p=round(p*1000)./1000
text(1600,20,mat2str(p))
ylim([yll ylmax])

%
nsubplot(250,250,12:62,61:80)
hold on; set(gca,'ticklength',4*get(gca,'ticklength'))
plot(nanmean([BFs6102_50l(:,1:1500); BFs6102_50s(:,1:1500)]),'k','LineWidth',linew)
hold on
plot(1500:2000,nanmean(BFs6102_50l(:,1500:2000)),'k','LineWidth',linew);
hold on
plot(1500:2000,nanmean(BFs6102_50s(:,1500:2000)),'r','LineWidth',linew);
hold on
x=[1500,1500]; y=[-60,60]; plot(x,y,'k'); hold on;
xlim([0 2250])
set(gca, 'XTick',[800 1900], 'XTickLabel',{'0\newlineTime from CS onset' '1.5 seconds', })
xlim([0 2000])
p=signrank(nanmean(BFs6102_50s(:,region)'),nanmean(BFs6102_50l(:,region)')); p=round(p*1000)./1000
text(1600,20,mat2str(p))
ylim([yll ylmax])

%
nsubplot(250,250,12:62,91:110)
hold on; set(gca,'ticklength',4*get(gca,'ticklength'))
plot(nanmean([BFs6103_25l(:,1:1500); BFs6103_75s(:,1:1500)]),'k','LineWidth',linew)
hold on
plot(1500:2000,nanmean(BFs6103_25l(:,1500:2000)),'k','LineWidth',linew);
hold on
plot(1500:2000,nanmean(BFs6103_75s(:,1500:2000)),'r','LineWidth',linew);
hold on
x=[1500,1500]; y=[-60,60]; plot(x,y,'k'); hold on;
xlim([0 2250])
set(gca, 'XTick',[800 1900], 'XTickLabel',{'0\newlineTime from CS onset' '1.5 seconds', })
xlim([0 2000])
p=signrank(nanmean(BFs6103_25l(:,region)'),nanmean(BFs6103_75s(:,region)')); p=round(p*1000)./1000
text(1600,20,mat2str(p))
ylim([yll ylmax])


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

nsubplot(250,250,112:162,192:242)
hold on; set(gca,'ticklength',4*get(gca,'ticklength'))
p25=nanmean(BFs6101_75l(:,rangeCS)')
p50=nanmean(BFs6102_50s(:,rangeCS)')
p75=nanmean(BFs6103_75s(:,rangeCS)')
p100=nanmean(BFs6104(:,rangeCS)')
p50r=nanmean(BFs6201nd(:,rangeCS)')
%
prob=fliplr([p100' p75' p50' p25' p50r']);
prob=prob(find(isnan(mean(prob'))==0),:);


%
prob=prob-repmat(min(prob')',1,size(prob,2))
prob=prob./repmat(max(prob')',1,size(prob,2))
%
p50r=prob(:,1);
prob=prob(:,2:5);
%
GroupID=repmat([4 3 2 1], size(prob,1),1)
BFpval=kruskalwallis(prob(:),GroupID(:),'off')
[pval, R]=permutation_pair_test_fast(prob(:),GroupID(:),10000,'rankcorr')
%
ProbSE=nanstd(prob)./sqrt((size(prob,1)))
errorbar(nanmean(prob),ProbSE,'r','LineWidth',3); hold on
errorbar(6,nanmean(p50r), nanstd(p50r)./sqrt((length(p50r))) ,'b','LineWidth',3); hold on

xlim([0 7]);
ylim([0 1])
axis square;
text(1,0.6,['n=' mat2str(size(prob,1))])
text(1,0.5,['anova=' mat2str(BFpval)])
text(1,0.7,['rho=' mat2str(R) 'p=' mat2str(pval)])
text(6,0.1,['50v50r=' mat2str(signrank(p50r,prob(:,2)))])
clear prob GroupID BFpval pval R



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nsubplot(250,250,112:162,1:20)
hold on; set(gca,'ticklength',4*get(gca,'ticklength'))
plot(nanmean(BFs6104(:,1:2000)),'b','LineWidth',linew);
hold on
plot(nanmean([BFs6201nd(:,1:1500); BFs6201d(:,1:1500)]),'k','LineWidth',linew)
hold on
plot(1500:2000,nanmean(BFs6201nd(:,1500:2000)),'k','LineWidth',linew);
hold on
plot(1500:2000,nanmean(BFs6201d(:,1500:2000)),'r','LineWidth',linew);
hold on
x=[1500,1500]; y=[-60,60]; plot(x,y,'k'); hold on;
xlim([0 2250])
set(gca, 'XTick',[800 1900], 'XTickLabel',{'0\newlineTime from CS onset' '1.5 seconds', })
t=ylabel('Baseline subtracted activity (spikes/s)'); set(t, 'FontSize', 8);

xlim([0 2000])
p=signrank(nanmean(BFs6201d(:,region)'),nanmean(BFs6201nd(:,region)')); p=round(p*1000)./1000
text(1600,20,mat2str(p))
ylim([yll ylmax])

nsubplot(250,250,112:162,31:50)
hold on; set(gca,'ticklength',4*get(gca,'ticklength'))
plot(nanmean([BFs6101_75l(:,1:1500); BFs6101_25s(:,1:1500)]),'k','LineWidth',linew)
hold on
plot(1500:2000,nanmean(BFs6101_75l(:,1500:2000)),'k','LineWidth',linew);
hold on
plot(1500:2000,nanmean(BFs6101_25s(:,1500:2000)),'r','LineWidth',linew);
hold on
x=[1500,1500]; y=[-60,60]; plot(x,y,'k'); hold on;
xlim([0 2250])
set(gca, 'XTick',[800 1900], 'XTickLabel',{'0\newlineTime from CS onset' '1.5 seconds', })
xlim([0 2000])
p=signrank(nanmean(BFs6101_25s(:,region)'),nanmean(BFs6101_75l(:,region)')); p=round(p*1000)./1000
text(1600,20,mat2str(p))
ylim([yll ylmax])

%
nsubplot(250,250,112:162,61:80)
hold on; set(gca,'ticklength',4*get(gca,'ticklength'))
plot(nanmean([BFs6102_50l(:,1:1500); BFs6102_50s(:,1:1500)]),'k','LineWidth',linew)
hold on
plot(1500:2000,nanmean(BFs6102_50l(:,1500:2000)),'k','LineWidth',linew);
hold on
plot(1500:2000,nanmean(BFs6102_50s(:,1500:2000)),'r','LineWidth',linew);
hold on
x=[1500,1500]; y=[-60,60]; plot(x,y,'k'); hold on;
xlim([0 2250])
set(gca, 'XTick',[800 1900], 'XTickLabel',{'0\newlineTime from CS onset' '1.5 seconds', })
xlim([0 2000])
p=signrank(nanmean(BFs6102_50s(:,region)'),nanmean(BFs6102_50l(:,region)')); p=round(p*1000)./1000
text(1600,20,mat2str(p))
ylim([yll ylmax])

%
nsubplot(250,250,112:162,91:110)
hold on; set(gca,'ticklength',4*get(gca,'ticklength'))
plot(nanmean([BFs6103_25l(:,1:1500); BFs6103_75s(:,1:1500)]),'k','LineWidth',linew)
hold on
plot(1500:2000,nanmean(BFs6103_25l(:,1500:2000)),'k','LineWidth',linew);
hold on
plot(1500:2000,nanmean(BFs6103_75s(:,1500:2000)),'r','LineWidth',linew);
hold on
x=[1500,1500]; y=[-60,60]; plot(x,y,'k'); hold on;
xlim([0 2250])
set(gca, 'XTick',[800 1900], 'XTickLabel',{'0\newlineTime from CS onset' '1.5 seconds', })
xlim([0 2000])
p=signrank(nanmean(BFs6103_25l(:,region)'),nanmean(BFs6103_75s(:,region)')); p=round(p*1000)./1000
text(1600,20,mat2str(p))
ylim([yll ylmax])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc; clear all; 
addpath('HELPER_GENERAL');
load timingproceduresummary3monksBF_tonic.mat
D=savestruct;
load timingproceduresummary3monksBF_phasic.mat
savestruct=[savestruct D]

%load timingproceduresummary3monksBF_tonic.mat
%load timingproceduresummary3monksBF_phasic.mat

rangeCS=[100:1500]; %CS region
region=[1600:1900]; %outcome region
yll=-15;
ylmax=35;
linew=2;

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

nsubplot(250,250,190:250,190:250)
hold on; set(gca,'ticklength',4*get(gca,'ticklength'))

t1=(BFs6101_25s)-(BFs6101_75l);
t2=(BFs6102_50s)-(BFs6102_50l);
t3=(BFs6103_75s)-(BFs6103_25l);
t4=(BFs6201d)-(BFs6201nd);
%
t11=[nanmean(t1(:,region)')];
t12=[nanmean(t2(:,region)')];
t13=[nanmean(t3(:,region)')];
t14=[nanmean(t4(:,region)')];
%
PlotMatrix=[t11' t12' t13']

% PlotMatrix=(([nanmean(Resp75(:,100:400)');
%     nanmean(Resp50(:,100:400)');
%     nanmean(Resp25(:,100:400)');
%     ]))'; 
%  PlotMatrix=fliplr(PlotMatrix)
%
PlotMatrixCorr=repmat([3 2 1],size(PlotMatrix,1),1)
[pval, R]=permutation_pair_test_fast(PlotMatrixCorr(:),PlotMatrix(:), 10000,'rankcorr');
t=text(3,15,['p= ' mat2str(pval)]); set(t, 'FontSize', 8);
t=text(3,10,['Model fit rho= ' mat2str(R)]); set(t, 'FontSize', 8);
%
%PlotMatrix=PlotMatrix-repmat(PlotMatrix(:,2),1,size(PlotMatrix,2))
%PlotMatrix=PlotMatrix-repmat(min(PlotMatrix')',1,size(PlotMatrix,2))
%PlotMatrix=PlotMatrix./repmat(max(PlotMatrix')',1,size(PlotMatrix,2))
Matrixmean=mean(PlotMatrix)
MatrixError=std(PlotMatrix)./sqrt(size(PlotMatrix,1))
errorbar(Matrixmean,MatrixError,'k','LineWidth',2); hold on
x=[0,4]; y=[0,0]; plot(x,y,'--k','LineWidth',0.5); hold on;
[h,p]=ttest(t11,0);
t=text(0.5,-12,['p value comparing to 0 = ' mat2str(p)]); set(t, 'FontSize', 8);
[h,p]=ttest(t12,0);
t=text(2,-13,['p= ' mat2str(p)]); set(t, 'FontSize', 8);
[h,p]=ttest(t13,0);
t=text(3.5,-14,['p= ' mat2str(p)]); set(t, 'FontSize', 8);
xlim([0 4]);
ylim([-15 15])
axis square
t=ylabel('Difference (spikes/s)'); set(t, 'FontSize', 8);
t=xlabel('Probability of reward at 1.5 sec'); set(t, 'FontSize', 8);
%xticklabels({'0.25','0.50','0.75',' '})
t=text(1,15,['n= ' mat2str(length(t11))]); set(t, 'FontSize', 8);




if DOPRINT==1
set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
print('-dpdf', 'T' );
close all;
end



dfg

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clc; clear all; 
PermNum=100;
addpath('HELPER_GENERAL');
load timingproceduresummary3monksBF_tonic.mat
rangeCS=[100:1500]; %CS region
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


nsubplot(250,250,190:250,1:100); hold on; 
set(gca,'ticklength',4*get(gca,'ticklength'));

plt=BFs6102_50l_; x=1:size(plt,2); v=sqrt(size(plt,1)); shadedErrorBar(x, plt, {@mean, @(x) std(x)./v}, {'-r', 'LineWidth', 0.5}, 0); hold on
plt=BFs6103_25l_; x=1:size(plt,2); v=sqrt(size(plt,1)); shadedErrorBar(x, plt, {@mean, @(x) std(x)./v}, {'-m', 'LineWidth', 0.5}, 0); hold on
plt=BFs6101_75l_; x=1:size(plt,2); v=sqrt(size(plt,1)); shadedErrorBar(x, plt, {@mean, @(x) std(x)./v}, {'-g', 'LineWidth', 0.5}, 0); hold on

x=[3000,3000]; y=[0,1]; plot(x,y,'k'); hold on;
CollectForCor=[];
for x=1:length(BFs6101_75l_)
    try
        %BinSize=100;
        BinS=x; % [x:x+BinSize];
        if BinS>1
            t1=nanmean(BFs6101_75l_(:,BinS)')'; t1(:,2)=1;
            t2=nanmean(BFs6102_50l_(:,BinS)')'; t2(:,2)=2;
            t3=nanmean(BFs6103_25l_(:,BinS)')'; t3(:,2)=3;
        else
            t1=(BFs6101_75l_(:,BinS)')'; t1(:,2)=1;
            t2=(BFs6102_50l_(:,BinS)')'; t2(:,2)=2;
            t3=(BFs6103_25l_(:,BinS)')'; t3(:,2)=3;
        end
        temp=[t1; t2; t3;];
        T=nanmean(temp);
        AverageF(x)=T(1);
        BFpval(x)=kruskalwallis(temp(:,1),temp(:,2),'off');
    end
    clear t1 t2 t3 temp
    
    BinS=[x];
    t1=(BFs6101_75l_(:,BinS)')'; t1(:,2)=x;
    t2=(BFs6102_50l_(:,BinS)')'; t2(:,2)=x;
    t3=(BFs6103_25l_(:,BinS)')'; t3(:,2)=x;
    temp=[t1; t2; t3;];
    CollectForCor=[CollectForCor; temp];
    clear temp t1 t2 t3;
end
BFpval(find(BFpval<0.05))=1.1;
BFpval(find(BFpval~=1.1))=NaN;
 
x1=CollectForCor(:,1);
y1=CollectForCor(:,2);
F=x1(find(y1>1000 & y1<3000));
D=y1(find(y1>1000 & y1<3000));
% p=polyfit(D,F,1);
% f=polyval(p,D);
% hold on
% plot(D,f,'--k','LineWidth',1)
%%
[pval, R]=permutation_pair_test_fast(x1,y1, PermNum,'rankcorr');
text(1600,.10,['p=' mat2str(pval)]);
text(1600,.15,['rho=' mat2str(R)]);
xlim([1 3500]);
ylim([0.1 0.7]);
axis square;


