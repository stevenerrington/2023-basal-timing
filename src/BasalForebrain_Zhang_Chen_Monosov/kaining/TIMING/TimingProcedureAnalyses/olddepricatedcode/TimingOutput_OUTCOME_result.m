clc; clear all; close all;
addpath('HELPER_GENERAL');

linew=2;
region=[1600:2100];
rangeCS=[100:600]

load timingproceduresummary3monksBF_phasic.mat

yl1=-5
yl2=23
yl3=-10
yl4=15

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
%
%
%
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
BFs6201d=[]
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
        
        if ~isempty(savestruct(x).s6201d)==1 & ~isempty(savestruct(x).s6201nd)==1
            BFs6201d=[BFs6201d; savestruct(x).s6201d];
            BFs6201nd=[BFs6201nd; savestruct(x).s6201nd];
            
        end
        
    end
end

%%%%%%%%%%%
indexresponse=find(BFPacrossresponses<0.05);
%indexresponse_long=find(BFPacrossresponses_long<0.05);

figure % pre outcome tonic response
nsubplot(200,200,1:200, 1:200)
p25=nanmean(BFs6101_75l(:,rangeCS)')
p50=nanmean(BFs6102_50s(:,rangeCS)')
p75=nanmean(BFs6103_75s(:,rangeCS)')
p100=nanmean(BFs6104(:,rangeCS)')
prob=fliplr([p100' p75' p50' p25']);
%
prob=prob-repmat(min(prob')',1,size(prob,2))
prob=prob./repmat(max(prob')',1,size(prob,2))
%
ProbSE=nanstd(prob)./sqrt((size(prob,1)))
errorbar(nanmean(prob),ProbSE,'r','LineWidth',3); hold on
xlim([0 5]);
ylim([0 1])
axis square;



figure % post outcome phasic response
nsubplot(200,200,1:200, 1:200)
t1=(BFs6101_25s)-(BFs6101_75l);
t2=(BFs6102_50s)-(BFs6102_50l);
t3=(BFs6103_75s)-(BFs6103_25l);
t11=[nanmean(t1(:,region)')];
t12=[nanmean(t2(:,region)')];
t13=[nanmean(t3(:,region)')];
prob=[t11' t12' t13']

prob=prob-repmat(min(prob')',1,size(prob,2))
prob=prob./repmat(max(prob')',1,size(prob,2))
%
ProbSE=nanstd(prob)./sqrt((size(prob,1)))
errorbar(nanmean(prob),ProbSE,'r','LineWidth',3); hold on
xlim([0 5]);
ylim([0 1])
axis square;




t11_=t11; t12_=t12; t13_=t13;
t11std=nanstd([nanmean(t1(:,region)')])./sqrt(length(t11));
t12std=nanstd([nanmean(t2(:,region)')])./sqrt(length(t12));
t13std=nanstd([nanmean(t3(:,region)')])./sqrt(length(t13));

%%
allCels=[t11' t12' t13'];
allCels=allCels-repmat(min(allCels')',[1 3]);
allCels=allCels./(repmat(max(allCels')',[1 3]));
t11=allCels(:,1);
t11std=nanstd(t11)./sqrt(length(t11));
t12=allCels(:,2);
t12std=nanstd(t12)./sqrt(length(t12));
t13=allCels(:,3);
t13std=nanstd(t13)./sqrt(length(t13));

%%
t11_=t11'; t12_=t12'; t13_=t13';
t11(1:length(t11),2)=1;
t12(1:length(t12),2)=2;
t13(1:length(t13),2)=3; 
temp=[t11; t12; t13;];
BFpval=kruskalwallis(temp(:,1),temp(:,2),'off');
%nsubplot(250,250,1:50,20:80)
t11=t11_(indexresponse);
t12=t12_(indexresponse);
t13=t13_(indexresponse);
t11std=nanstd(t11)./sqrt(length(t11));
t12std=nanstd(t12)./sqrt(length(t12));
t13std=nanstd(t13)./sqrt(length(t13));
errorbar([0.25 0.5 0.75],[nanmean(t11) nanmean(t12) nanmean(t13)],[t11std t12std t13std],'.'); hold on
t2=t11';
t3=t12';
t4=t13';
t2(1:length(t2),2)=0.25; 
t3(1:length(t3),2)=0.5;
t4(1:length(t4),2)=0.75;
temp=[t2; t3; t4;]; 
[pval, R]=permutation_pair_test_fast(temp(:,1),temp(:,2),50000,'rankcorr');
x=temp(:,2);
y1=temp(:,1);
P = polyfit(x,y1,1);
yfit = P(1)*x+P(2);
hold on;
%plot(x,yfit,'r-','LineWidth',2);
axis square;
if signrank(t11,t12)<0.05
    t=text(0.4,1,['*']); set(t, 'FontSize', 20);
else
    t=text(0.4,1,['ns']); set(t, 'FontSize', 10);
end
if signrank(t13,t12)<0.05
    t=text(0.6,1,['*']); set(t, 'FontSize', 20);
else
    t=text(0.6,1,['ns']); set(t, 'FontSize', 10);
end
%t=text(0.1,0.2,sprintf('p-value: %s', mat2str(pval)));
%t=text(0.1,0,sprintf('R: %s', mat2str(R))); 
clear t11 t12 t13 t14 t1 t2 t3 t4
ylim([-0.1 1.1])
xlabel('P(p)')
set(gca, 'XTick',[0.25 0.50 0.75], 'XTickLabel',{'0.25' '0.50' '0.75' })

ylabel('Response (spikes/s)')
axis square;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure; 
Diff=BFs6201d(:,1500:2000)-BFs6201nd(:,1500:2000)
plot(nanmean(Diff)); hold on
Diff=BFs6102_50s(:,1500:2000)-BFs6102_50l(:,1500:2000)
plot(nanmean(Diff),'r'); hold on



nsubplot(250,250,12:62,1:20)
shift_plot=nanmean(nanmean(BFs6104(:,1:15)));
plot(nanmean(BFs6104(:,1:2000))-shift_plot,'b','LineWidth',linew);
hold on
plot(nanmean([BFs6201nd(:,1:1500); BFs6201d(:,1:1500)])-shift_plot,'k','LineWidth',linew)
hold on
plot(1500:2000,nanmean(BFs6201nd(:,1500:2000))-shift_plot,'k','LineWidth',linew);
hold on
plot(1500:2000,nanmean(BFs6201d(:,1500:2000))-shift_plot,'r','LineWidth',linew);
hold on
x=[1500,1500]; y=[-60,60]; plot(x,y,'k'); hold on;
axis([0 2250 yl1 yl2+25])

set(gca, 'XTick',[800 1900], 'XTickLabel',{'0\newlineTime from CS onset' '1.5 seconds', })
ylabel('Firing rate (spikes/s)')

xlim([0 2000])




nsubplot(250,250,12:62,31:50)
shift_plot=nanmean(nanmean(BFs6104(:,1:15)));
plot(nanmean([BFs6101_75l(:,1:1500); BFs6101_25s(:,1:1500)])-shift_plot,'k','LineWidth',linew)
hold on
plot(1500:2000,nanmean(BFs6101_75l(:,1500:2000))-shift_plot,'k','LineWidth',linew);
hold on
plot(1500:2000,nanmean(BFs6101_25s(:,1500:2000))-shift_plot,'r','LineWidth',linew);
hold on
x=[1500,1500]; y=[-60,60]; plot(x,y,'k'); hold on;
axis([0 2250 yl1 yl2+25])

set(gca, 'XTick',[800 1900], 'XTickLabel',{'0\newlineTime from CS onset' '1.5 seconds', })

xlim([0 2000])

%
nsubplot(250,250,12:62,61:80)
shift_plot=nanmean(nanmean(BFs6104(:,1:15)));
plot(nanmean([BFs6102_50l(:,1:1500); BFs6102_50s(:,1:1500)])-shift_plot,'k','LineWidth',linew)
hold on
plot(1500:2000,nanmean(BFs6102_50l(:,1500:2000))-shift_plot,'k','LineWidth',linew);
hold on
plot(1500:2000,nanmean(BFs6102_50s(:,1500:2000))-shift_plot,'r','LineWidth',linew);
hold on
x=[1500,1500]; y=[-60,60]; plot(x,y,'k'); hold on;
axis([0 2250 yl1 yl2+25])

set(gca, 'XTick',[800 1900], 'XTickLabel',{'0\newlineTime from CS onset' '1.5 seconds', })

xlim([0 2000])
%
nsubplot(250,250,12:62,91:110)
shift_plot=nanmean(nanmean(BFs6104(:,1:15)));
plot(nanmean([BFs6103_25l(:,1:1500); BFs6103_75s(:,1:1500)])-shift_plot,'k','LineWidth',linew)
hold on
plot(1500:2000,nanmean(BFs6103_25l(:,1500:2000))-shift_plot,'k','LineWidth',linew);
hold on
plot(1500:2000,nanmean(BFs6103_75s(:,1500:2000))-shift_plot,'r','LineWidth',linew);
hold on
x=[1500,1500]; y=[-60,60]; plot(x,y,'k'); hold on;
axis([0 2250 yl1 yl2+25])

set(gca, 'XTick',[800 1900], 'XTickLabel',{'0\newlineTime from CS onset' '1.5 seconds', })

xlim([0 2000])

nsubplot(250,250,12:62,121:140)
plot(nanmean(BFs6101_25s)-nanmean(BFs6101_75l),'r','LineWidth',linew); hold on
plot(nanmean(BFs6102_50s)-nanmean(BFs6102_50l),'g','LineWidth',linew); hold on
plot(nanmean(BFs6103_75s)-nanmean(BFs6103_25l),'b','LineWidth',linew); hold on
x=[1500,1500]; y=[-20,60]; plot(x,y,'k'); hold on;
set(gca,'ticklength',4*get(gca,'ticklength'))
%if strcmpi(str,'BF')
line([region(1) region(end)], [-19 -19] , 'Color', [0 0 0 ],'LineWidth',2);
%elseif strcmpi(str,'BG')
%    line([region(1) region(end)], [-4 -4] , 'Color', [0 0 0 ],'LineWidth',2);
%end
if BFpval<0.05
text(1700,22,['P<0.05'])
else
    text(1700,22,['NS'])
end
axis([1300 1900 yl1 yl2])
ylabel('Response (spikes/s)')
set(gca, 'XTick',[1500 1600 1700 1800 1900], 'XTickLabel',{'' '' '' '0\newlineTime from CS onset' '0.4 seconds' })


%
ThresholdColor=0.05;
nsubplot(250,250,1:75,151:216)
vvv=find(BFPacrossresponses<ThresholdColor);
scatter(BFrocarea325v50,BFrocarea375v50,20,'Marker','p','MarkerFaceColor','k','MarkerEdgeColor','k')
scatter(BFrocarea325v50(vvv),BFrocarea375v50(vvv),20,'Marker','p','MarkerFaceColor','r','MarkerEdgeColor','r')
line([0 1], [0.5 0.5] , 'Color', [0 0 0 ]) ;
line([0.5 0.5],[0 1],  'Color', [0 0 0 ]) ;
axis([-.1 1.1 -.1 1.1])
axis square
xlabel('P(p)=0.25 vs P(p)=0.50\newlineresponse discrimination')
ylabel('P(p)=0.50 vs P(p)=0.75\newlineresponse discrimination')


%%%

t1=(BFs6101_25s)-(BFs6101_75l);
t2=(BFs6102_50s)-(BFs6102_50l);
t3=(BFs6103_75s)-(BFs6103_25l);
t11=[nanmean(t1(:,region)')];
t11std=nanstd([nanmean(t1(:,region)')])./sqrt(length(t11));
t12=[nanmean(t2(:,region)')];
t12std=nanstd([nanmean(t2(:,region)')])./sqrt(length(t12));
t13=[nanmean(t3(:,region)')];
t13std=nanstd([nanmean(t3(:,region)')])./sqrt(length(t13));


t11=t11';
t11(:,2)=0.25;
t12=t12';
t12(:,2)=0.50;
t13=t13';
t13(:,2)=0.75;
all=[t11;t12;t13];
x1=all(:,1);
y1=all(:,2);
[rho,pvalue]=corr(x1(:),y1(:),'type','Spearman');

t1=(BFs6101_25s(vvv,:))-(BFs6101_75l(vvv,:));
t2=(BFs6102_50s(vvv,:))-(BFs6102_50l(vvv,:));
t3=(BFs6103_75s(vvv,:))-(BFs6103_25l(vvv,:));
t11=[nanmean(t1(:,region)')];
t11std=nanstd([nanmean(t1(:,region)')])./sqrt(length(t11));
t12=[nanmean(t2(:,region)')];
t12std=nanstd([nanmean(t2(:,region)')])./sqrt(length(t12));
t13=[nanmean(t3(:,region)')];
t13std=nanstd([nanmean(t3(:,region)')])./sqrt(length(t13));


t11=t11';
t11(:,2)=0.25;
t12=t12';
t12(:,2)=0.50;
t13=t13';
t13(:,2)=0.75;
all=[t11;t12;t13];
x1=all(:,1);
y1=all(:,2);
[rho,pvalue]=corr(x1(:),y1(:),'type','Spearman');


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