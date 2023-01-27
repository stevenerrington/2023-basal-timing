clc; clear all; close all;
addpath('HELPER_GENERAL');

phasictonic=2; % what kind fo neurons to plot
%number of permutations / for final / paper version set to 10,000
PermNum=100;
%ploting setings
yll=-15; 
ylmax=35;
linew=2;

if phasictonic==1;
    load timingproceduresummary3monksBF_phasic.mat
    rangeCS=[100:600]; %CS region
    region=[1600:2100]; %outcome region
else phasictonic==2;
    load timingproceduresummary3monksBF_tonic.mat
    rangeCS=[100:1500]; %CS region
    region=[1600:2100]; %outcome region
end


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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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




nsubplot(250,250,175:250,175:250); hold on; set(gca,'ticklength',4*get(gca,'ticklength'));

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
 
%plot(BFpval, 'b', 'LineWidth', 4)

%    plot(AverageF , 'k', 'LineWidth', 4)
%
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


nsubplot(250,250,101:150,1:50)
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




%prob=[t11' t12' t13' t14']
prob=[t11' t12' t13']

prob=prob-repmat(min(prob')',1,size(prob,2))
prob=prob./repmat(max(prob')',1,size(prob,2))
%
%prob50r=prob(:,4)
prob=prob(:,1:3)
prob=prob(find(isnan(mean(prob'))==0),:);


%
GroupID=repmat([ 3 2 1], size(prob,1),1)
BFpval=kruskalwallis(prob(:),GroupID(:),'off')
[pval, R]=permutation_pair_test_fast(prob(:),GroupID(:),10000,'rankcorr')
%
ProbSE=nanstd(prob)./sqrt((size(prob,1)))
errorbar(nanmean(prob),ProbSE,'r','LineWidth',3); hold on
%errorbar(5,nanmean(prob50r), std(prob50r)./sqrt(length(prob50r)) ,'b','LineWidth',3); hold on

xlim([0 6]);
ylim([0 1])
axis square;
text(1,0.6,['n=' mat2str(size(prob,1))])
text(1,0.5,['anova=' mat2str(BFpval)])
text(1,0.7,['rho=' mat2str(R) 'p=' mat2str(pval)])
clear t11 t12 t13 t1 t2 t3 GroupID BFpval pval R
xlabel('P(p)')
ylabel('Normalized neuronal response')

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
ylabel('Firing rate (spikes/s)')
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






% nsubplot(250,250,12:62,121:140)
% plot(nanmean(BFs6101_25s)-nanmean(BFs6101_75l),'r','LineWidth',linew); hold on
% plot(nanmean(BFs6102_50s)-nanmean(BFs6102_50l),'g','LineWidth',linew); hold on
% plot(nanmean(BFs6103_75s)-nanmean(BFs6103_25l),'b','LineWidth',linew); hold on
% x=[1500,1500]; y=[-20,60]; plot(x,y,'k'); hold on;
% set(gca,'ticklength',4*get(gca,'ticklength'))
% %if strcmpi(str,'BF')
% line([region(1) region(end)], [-19 -19] , 'Color', [0 0 0 ],'LineWidth',2);
% %elseif strcmpi(str,'BG')
% %    line([region(1) region(end)], [-4 -4] , 'Color', [0 0 0 ],'LineWidth',2);
% %end
% if BFpval<0.05
% text(1700,22,['P<0.05'])
% else
%     text(1700,22,['NS'])
% end
% axis([1300 1900 yl1 yl2])
% ylabel('Response (spikes/s)')
% set(gca, 'XTick',[1500 1600 1700 1800 1900], 'XTickLabel',{'' '' '' '0\newlineTime from CS onset' '0.4 seconds' })
%
%
% %
% ThresholdColor=0.05;
% nsubplot(250,250,1:75,151:216)
% vvv=find(BFPacrossresponses<ThresholdColor);
% scatter(BFrocarea325v50,BFrocarea375v50,20,'Marker','p','MarkerFaceColor','k','MarkerEdgeColor','k')
% scatter(BFrocarea325v50(vvv),BFrocarea375v50(vvv),20,'Marker','p','MarkerFaceColor','r','MarkerEdgeColor','r')
% line([0 1], [0.5 0.5] , 'Color', [0 0 0 ]) ;
% line([0.5 0.5],[0 1],  'Color', [0 0 0 ]) ;
% axis([-.1 1.1 -.1 1.1])
% axis square
% xlabel('P(p)=0.25 vs P(p)=0.50\newlineresponse discrimination')
% ylabel('P(p)=0.50 vs P(p)=0.75\newlineresponse discrimination')


% %%%
% t1=(BFs6101_25s)-(BFs6101_75l);
% t2=(BFs6102_50s)-(BFs6102_50l);
% t3=(BFs6103_75s)-(BFs6103_25l);
% t11=[nanmean(t1(:,region)')];
% t11std=nanstd([nanmean(t1(:,region)')])./sqrt(length(t11));
% t12=[nanmean(t2(:,region)')];
% t12std=nanstd([nanmean(t2(:,region)')])./sqrt(length(t12));
% t13=[nanmean(t3(:,region)')];
% t13std=nanstd([nanmean(t3(:,region)')])./sqrt(length(t13));
% t11=t11';
% t11(:,2)=0.25;
% t12=t12';
% t12(:,2)=0.50;
% t13=t13';
% t13(:,2)=0.75;
% all=[t11;t12;t13];
% x1=all(:,1);
% y1=all(:,2);
% [rho,pvalue]=corr(x1(:),y1(:),'type','Spearman');
% t1=(BFs6101_25s(vvv,:))-(BFs6101_75l(vvv,:));
% t2=(BFs6102_50s(vvv,:))-(BFs6102_50l(vvv,:));
% t3=(BFs6103_75s(vvv,:))-(BFs6103_25l(vvv,:));
% t11=[nanmean(t1(:,region)')];
% t11std=nanstd([nanmean(t1(:,region)')])./sqrt(length(t11));
% t12=[nanmean(t2(:,region)')];
% t12std=nanstd([nanmean(t2(:,region)')])./sqrt(length(t12));
% t13=[nanmean(t3(:,region)')];
% t13std=nanstd([nanmean(t3(:,region)')])./sqrt(length(t13));
% t11=t11';
% t11(:,2)=0.25;
% t12=t12';
% t12(:,2)=0.50;
% t13=t13';
% t13(:,2)=0.75;
% all=[t11;t12;t13];
% x1=all(:,1);
% y1=all(:,2);
% [rho,pvalue]=corr(x1(:),y1(:),'type','Spearman');


%{
if strcmpi(str,'BF')
%COLOR MAPS (right now disorganized.. )

pvalueforcolormap=0.01; %set low due to multipe compare
SaveCor=BFSaveCor;
PvalueSave=BFPvalueSave;
PvalueSaveCor=BFPvalueSaveCor;


%figure
nsubplot(250,250,1:50,181:200)
PvalueSaveCor(find(PvalueSaveCor>pvalueforcolormap))=9; PvalueSaveCor(find(PvalueSaveCor~=9))=1;  PvalueSaveCor(find(PvalueSaveCor==9))=0;
plot(sum(PvalueSaveCor)./size(PvalueSaveCor,1),'k','LineWidth',1.5);
hold on; x=[1500,1500]; y=[0,1]; plot(x,y,'k'); hold on;
axis([1500 2250 0 0.8])
xlim([1500 1720])
ylabel('% cells significant')
%set(gca, 'XTick',[1500], 'XTickLabel',{'1.5 seconds\newlineTime from CS onset' })
text(1720,0.1,mat2str(size(PvalueSaveCor,1)))

nsubplot(250,250,61:110,181:200)
try
S=SaveCor;
S(PvalueSaveCor==0)=0;
SS=[];
Latency=[];
cellno=0;
for x=1:size(S,1)
    if  length(nonzeros(S(x,1500:2250)))>10
        cellno=cellno+1;
        SS=[SS; S(x,:)];
        t=S(x,1500:2250);
        %Latency=[Latency; min(find(t>0)) cellno];
        Latency=[Latency; min(find(t~=0)) cellno];
    end
    clear x T
end
Latency=sortrows(Latency,1);
SS=SS(Latency(:,2),:);
S=SS;
image(colormapify(S,[-0.8 0.8],'b','w','r')); hold on
hold on; x=[1500,1500]; y=[0,size(S,1)]; plot(x,y,'k','LineWidth',1.5); hold on;
ylim([0 size(S,1)+2])
xlim([1500 2250])
axis off
text(1720,2,['cells: ' mat2str(size(S,1)) ' / ' mat2str(size(SaveCor,1))])
text(1720,1,['median latency: ' mat2str(median(Latency(:,1))) ' ms'])
end
xlim([1500 1720])
%
end
%}


% if strcmpi(str,'BF')
% set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
% print(sprintf('%s.pdf', 'timing-phasic-input-bf'),'-dpdf')
% elseif strcmpi(str,'BG')
% set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
% print(sprintf('%s.pdf', 'timing-phasic-input-bg'),'-dpdf')
% end
% %




%
%{
figure % uncertainty
nsubplot(250,250,1:200,1:200)
%
plotthese1=BFs6201nd(:,1500:2000);
plotthese2=BFs6201d(:,1500:2000);
plotthese3=BFs6101_75l(:,1500:2000);
plotthese4=BFs6101_25s(:,1500:2000);
%plotthese3=plotthese4-plotthese3;
 
plotthese=plotthese1;
x=1:length(plotthese);
v=sqrt(size(plotthese,1));
shadedErrorBar(x, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',[0.3 0.3 0.3], 'LineWidth', 2}, 0); hold on

plotthese=plotthese2;
x=1:length(plotthese);
v=sqrt(size(plotthese,1));
shadedErrorBar(x, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',[0.7 0.7 0.7], 'LineWidth', 2}, 0); hold on
%
plot(nanmean(plotthese4),'r','LineWidth',2)
xlim([0 500])
ylim([-20 25])
axis square
%}
%end