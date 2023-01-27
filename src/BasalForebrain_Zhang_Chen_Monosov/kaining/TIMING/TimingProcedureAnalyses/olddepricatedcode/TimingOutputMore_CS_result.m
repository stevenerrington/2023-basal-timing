clc; clear all; close all;
addpath('C:\Users\Ilya Monosov\Dropbox\HELPER\HELPER_GENERAL');
linew=2;
region=[1600:1825];
%region=[4600:4825];
% prompt = '''BF'' or ''BG''? (case insensitive): ';
% str = input(prompt,'s');
% if strcmpi(str,'BF')
    load timingproceduresummary3monksBF_phasic.mat 
    yl1f=-50
    yl2f=50
    yl3f=-10
    yl4f=20
% elseif strcmpi(str,'BG')
%     load('\\128.252.37.174\Share1\Charlie\Figure4\timingproceduresummary3monksBG_50ms.mat')
%     yl1f=-5
%     yl2f=28
%     yl3f=-10
%     yl4f=15
% else
%     error('Inputs must be ''BF'' or ''BG'' (case insensitive)')
% end
%%


savestruct=savestruct;
%
%
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

BFPvalueSaveHz=[];;
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

BFPacrossresponses_rr=[];
BFrocarea375v50rr=[];
BFrocarea325v50rr=[];

BFresponse25=[];
BFresponse50=[];
BFresponse75=[];

for x=1:length(savestruct)
    filler(1:6001)=NaN;
    filler1(1:2901)=NaN;
    
    if size(savestruct(x).s6102_50s,2)>1 ...
            & size(savestruct(x).s6102_50l,2)>1 ...
            & size(savestruct(x).s6103_25l,2)>1 ...
            & size(savestruct(x).s6103_75s,2)>1 & ...
            size(savestruct(x).s6101_75l,2)>1 ...
            & size(savestruct(x).s6101_25s,2)>1 & ...
            length(savestruct(x).s6102_50s)>1 & ...
            length(savestruct(x).s6102_50l)>1 & ...
            length(savestruct(x).s6103_25l)>1 & ...
            length(savestruct(x).s6103_75s)>1 &  ...
            length(savestruct(x).s6101_25s)>1 & ...
            length(savestruct(x).s6101_75l)>1 & ...
            isnan(nanmean(savestruct(x).s6101_25s))==0
        
        
     
        
        BFPacrossresponses=[BFPacrossresponses;savestruct(x).Pacrossresponses];
        BFPacrossresponses_rr=[BFPacrossresponses_rr;savestruct(x).Pacrossresponses_rr];
        
        
        BFPc=[BFPc;savestruct(x).Pc];
        BFRc=[BFRc;savestruct(x).Rc];

        BFranksum75v50=[BFranksum75v50;savestruct(x).ranksum75v50];
        BFranksum25v50=[BFranksum25v50;savestruct(x).ranksum25v50];
 
        BFrocarea375v50=[BFrocarea375v50;savestruct(x).rocarea375v50];
        BFrocarea325v50=[BFrocarea325v50;savestruct(x).rocarea325v50];
        
        BFrocarea375v50rr=[BFrocarea375v50rr;savestruct(x).rocarea375v50rr];
        BFrocarea325v50rr=[BFrocarea325v50rr;savestruct(x).rocarea325v50rr];
        
        BFresponse25=[BFresponse25;savestruct(x).response25rr];
        BFresponse50=[BFresponse50;savestruct(x).response50rr];
        BFresponse75=[BFresponse75;savestruct(x).response75rr];

        
        BFs6102_50s=[BFs6102_50s;savestruct(x).s6102_50s];
        BFs6102_50l=[BFs6102_50l;savestruct(x).s6102_50l];
        BFs6104=[BFs6104;savestruct(x).s6104];
        BFs6103_75s=[BFs6103_75s;savestruct(x).s6103_75s];
        BFs6103_25l=[BFs6103_25l;savestruct(x).s6103_25l];
        BFs6101_25s=[BFs6101_25s;savestruct(x).s6101_25s];
        BFs6101_75l=[BFs6101_75l;savestruct(x).s6101_75l];
        BFSaveCor=[BFSaveCor;savestruct(x).SaveCor'];
        BFPvalueSave=[BFPvalueSave;savestruct(x).PvalueSave'];
        BFPvalueSaveCor=[BFPvalueSaveCor;savestruct(x).PvalueSaveCor'];

        if ~isempty(savestruct(x).s6201d)==1 & ~isempty(savestruct(x).s6201nd)==1
            BFs6201d=[BFs6201d; savestruct(x).s6201d];
            BFs6201nd=[BFs6201nd; savestruct(x).s6201nd];
    
        end
        
    end
end

%%%%%%%%%%%

indexresponse=find(BFPacrossresponses_rr<0.05);

%%%%%%%%%%%
%{
figure % pre outcome tonic response
nsubplot(200,200,1:200, 1:200)
p25=nanmean(BFs6101_75l(:,100:1500)')
p50=nanmean(BFs6102_50s(:,100:1500)')
p75=nanmean(BFs6103_75s(:,100:1500)')
p100=nanmean(BFs6104(:,100:1500)')
prob=([p100' p75' p50' p25']);
ProbSE=nanstd(prob)./sqrt((size(prob,1)))
errorbar(nanmean(prob),ProbSE,'r','LineWidth',3); hold on
xlim([0 5]);
axis square;
%}



t1=BFs6101_75l;
t2=BFs6102_50l;
t3=BFs6103_25l;
BFpval=zeros(61,1);
y=1;
for x=[1:100:6000]
    region=[x:x+100];
    t11=[nanmean(t1(:,region)')];
    t11std=nanstd([nanmean(t1(:,region)')])./sqrt(length(t11));
    t12=[nanmean(t2(:,region)')];
    t12std=nanstd([nanmean(t2(:,region)')])./sqrt(length(t12));
    t13=[nanmean(t3(:,region)')];
    t13std=nanstd([nanmean(t3(:,region)')])./sqrt(length(t13));
    t11_=t11; t12_=t12; t13_=t13;
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
    BFpval(y)=kruskalwallis(temp(:,1),temp(:,2),'off');
    y=y+1;
end


figure
% post outcome phasic response
%nsubplot(200,200,1:81,121:200)
%{
nsubplot(250,250,1:70,226:246)
t1=(BFs6101_75l);
t2=(BFs6102_50l);
t3=(BFs6103_25l);
t11=[nanmean(t1(:,region)')];
t11std=nanstd([nanmean(t1(:,region)')])./sqrt(length(t11));
t12=[nanmean(t2(:,region)')];
t12std=nanstd([nanmean(t2(:,region)')])./sqrt(length(t12));
t13=[nanmean(t3(:,region)')];
t13std=nanstd([nanmean(t3(:,region)')])./sqrt(length(t13));
t11_=t11; t12_=t12; t13_=t13;
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
t11(1:length(t11),2)=4;
t12(1:length(t12),2)=5;
t13(1:length(t13),2)=6;
%temp=[t11; t12; t13;];



regionq=[1600:1825];
q1=(BFs6101_25s)-(BFs6101_75l);
q2=(BFs6102_50s)-(BFs6102_50l);
q3=(BFs6103_75s)-(BFs6103_25l);
q11=[nanmean(q1(:,regionq)')];
q11std=nanstd([nanmean(q1(:,regionq)')])./sqrt(length(q11));
q12=[nanmean(q2(:,regionq)')];
q12std=nanstd([nanmean(q2(:,regionq)')])./sqrt(length(q12));
q13=[nanmean(q3(:,regionq)')];
q13std=nanstd([nanmean(q3(:,regionq)')])./sqrt(length(q13));
q11_=q11; q12_=q12; q13_=q13;
%%
allCels=[q11' q12' q13'];
allCels=allCels-repmat(min(allCels')',[1 3]);
allCels=allCels./(repmat(max(allCels')',[1 3]));
q11=allCels(:,1);
q11std=nanstd(q11)./sqrt(length(q11));
q12=allCels(:,2);
q12std=nanstd(q12)./sqrt(length(q12));
q13=allCels(:,3);
q13std=nanstd(q13)./sqrt(length(q13));

%%
q11_=q11'; q12_=q12'; q13_=q13';
q11(1:length(q11),2)=1;
q12(1:length(q12),2)=2;
q13(1:length(q13),2)=3;
clear temp
temp=[t11;t12;t13];
temp=[q12;q12;q13];
temp=[temp;t13]
%BFpval=kruskalwallis(temp(:,1),temp(:,2),'off');



BFpval=kruskalwallis(temp(:,1),temp(:,2),'off')
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
%}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%{
nsubplot(250,250,12:62,1:20)
shift_plot=nanmean(nanmean(BFs6104(:,1:15)));
plot(nanmean(BFs6104(:,1:5000))-shift_plot,'b','LineWidth',linew);
hold on
plot(nanmean([BFs6201nd(:,1:4500); BFs6201d(:,1:4500)])-shift_plot,'k','LineWidth',linew)
hold on
plot(1500:2000,nanmean(BFs6201nd(:,4500:5000))-shift_plot,'k','LineWidth',linew);
hold on
plot(1500:2000,nanmean(BFs6201d(:,4500:5000))-shift_plot,'r','LineWidth',linew);
hold on
x=[1500,1500]; y=[-60,60]; plot(x,y,'k'); hold on;
axis([0 2250 yl1 yl2+25])

set(gca, 'XTick',[800 1900], 'XTickLabel',{'0\newlineTime from CS onset' '1.5 seconds', })
ylabel('Firing rate (spikes/s)')

xlim([0 2000])
%}
nsubplot(250,250,12:62,1:50)
shift_plot=nanmean(nanmean(BFs6104(:,1:15)));

BFs6201=cat(1,BFs6201d,BFs6201nd);
%plot(1:1500,nanmean(BFs6201(:,1:1500))-shift_plot,'c','LineWidth',linew);
%hold on
plot(nanmean([BFs6101_75l(:,1:1500); BFs6101_25s(:,1:1500)])-shift_plot,'r','LineWidth',linew)
hold on
plot(1500:4500,nanmean(BFs6101_75l(:,1500:4500))-shift_plot,'r','LineWidth',linew);
hold on
plot(nanmean([BFs6102_50l(:,1:1500); BFs6102_50s(:,1:1500)])-shift_plot,'g','LineWidth',linew)
hold on
plot(1500:4500,nanmean(BFs6102_50l(:,1500:4500))-shift_plot,'g','LineWidth',linew);
hold on
plot(nanmean([BFs6103_25l(:,1:1500); BFs6103_75s(:,1:1500)])-shift_plot,'b','LineWidth',linew)
hold on
plot(1500:4500,nanmean(BFs6103_25l(:,1500:4500))-shift_plot,'b','LineWidth',linew);
hold on
%plot(4500:5000,nanmean([BFs6103_25l(:,4500:5000); BFs6102_50l(:,4500:5000);BFs6101_75l(:,4500:5000)])-shift_plot,'k','LineWidth',linew)
%hold on
plot(4500:5000,nanmean(BFs6101_75l(:,4500:5000))-shift_plot,'r','LineWidth',linew);
hold on
plot(4500:5000,nanmean(BFs6102_50l(:,4500:5000))-shift_plot,'g','LineWidth',linew);
hold on
plot(4500:5000,nanmean(BFs6103_25l(:,4500:5000))-shift_plot,'b','LineWidth',linew);
hold on



% plot(1:1500,nanmean(BFs6104(:,1:1500))-shift_plot,'k','LineWidth',linew);
% hold on
%plot(4500:5000,BFs6102_50l(:,4500:5000)-shift_plot,'LineWidth',linew);




x=[1500,1500]; y=[-60,60]; plot(x,y,'k'); hold on;
hold on
x=[4500,4500]; y=[-60,60]; plot(x,y,'k'); hold on;



axis([0 5000 yl1f yl2f])

set(gca, 'XTick',[800 1900], 'XTickLabel',{'0\newlineTime from CS onset' '1.5 seconds', })

xlim([0 5000])

yyy=ylim;
for z=1:length(BFpval)
    if BFpval(z)<0.01
        x=[z*100-100,z*100]; y=[yyy(1)+2,yyy(1)+2]; plot(x,y,'r','LineWidth',linew); hold on;
    end
end


% pre_6101=nanmean(BFs6101_75l(:,4000:4500),2);
% post_6101=nanmean(BFs6101_75l(:,4500:5000),2);
% pre_6102=nanmean(BFs6102_50l(:,4000:4500),2);
% post_6102=nanmean(BFs6102_50l(:,4500:5000),2);
% pre_6103=nanmean(BFs6103_25l(:,4000:4500),2);
% post_6103=nanmean(BFs6103_25l(:,4500:5000),2);
%
% signrank(pre_6101,post_6101)<0.05
% signrank(pre_6102,post_6102)<0.05
% signrank(pre_6103,post_6103)<0.05

t1=BFs6101_75l;
t2=BFs6102_50l;
t3=BFs6103_25l;
region1=[4250:4500];
region2=[4600:4850];

t11=[nanmean(t1(:,region1)')];
t12=[nanmean(t2(:,region1)')];
t13=[nanmean(t3(:,region1)')];
all=[t11 t12 t13];

t11p=[nanmean(t1(:,region2)')];
t12p=[nanmean(t2(:,region2)')];
t13p=[nanmean(t3(:,region2)')];
allp=[t11p t12p t13p];

signrank(all,allp)<0.05
% signrank(t12,t12p)<0.05
% signrank(t13,t13p)<0.05

%%%
% is there variance in time?
%{
nsubplot(250,250,72:122,1:50);
% PvalueSaveCor(find(PvalueSaveCor>pvalueforcolormap))=9; PvalueSaveCor(find(PvalueSaveCor~=9))=1;  PvalueSaveCor(find(PvalueSaveCor==9))=0;
% plot(sum(PvalueSaveCor)./size(PvalueSaveCor,1),'k','LineWidth',1.5);
% hold on; x=[1500,1500]; y=[0,1]; plot(x,y,'k'); hold on;
% axis([1500 2250 0 0.8])
% xlim([1500 1720])
% ylabel('% cells significant')
% %set(gca, 'XTick',[1500], 'XTickLabel',{'1.5 seconds\newlineTime from CS onset' })
% text(1720,0.1,mat2str(size(PvalueSaveCor,1)))

cache=[];
for s=1:numel(savestruct);
cache=[cache savestruct(s).PvalueSave];
end
cache_long=cache<0.01;

plot(nanmean(cache_long,2))
%hold on
%plot(nanmean(cache(cache_long),2))

% cache_=cache';
% cache_(find(cache_>0.05))=999;
% cache_(find(cache_~=999))=1;
% cache_(find(cache_==999))=0;
% plot(nansum(cache_)./size(cache_,1),'b'); hold on



x=[1500,1500]; y=[-60,60]; plot(x,y,'k'); hold on;
hold on
x=[4500,4500]; y=[-60,60]; plot(x,y,'k'); hold on;

axis([0 5250 0 1])

set(gca, 'XTick',[800 1900], 'XTickLabel',{'0\newlineTime from CS onset' '1.5 seconds', })

xlim([0 5000])
%}


nsubplot(250,250,82:132,1:50);

%logical=BFpval<0.01;

index1=4*100-100; %start of positive ramp
index2=1500; %end of positive ramp, start of negative ramp
index3=22*100-100; %end of negative ramp, start of no sig
index4=4500; % end of no sig

%if strcmpi(str,'BF')

x1=index1:100:index2;
%y1=[nanmean([BFs6101_75l(:,index1:index2); BFs6101_25s(:,index1:index2)])-shift_plot];
y1=[nanmean([BFs6101_75l(:,x1); BFs6101_25s(:,x1)])-shift_plot];
x1=repmat(x1,size(y1,1),1);
[p,S] = polyfit(x1,y1,1);
x11 = index1:0.1:index2;
y11 = polyval(p,x11);
[rho12r,pvalue12r]=corr(x1(:),y1(:));
p0value12r=p(1);
p1value12r=p(2);

%plot(x1,y1,'o')
%hold on
plot(x11,y11,'r','LineWidth',linew)

hold on
x1=index1:100:index2;
%y1=[nanmean([BFs6102_50l(:,index1:index2); BFs6102_50s(:,index1:index2)])-shift_plot];
y1=[([BFs6102_50l(:,x1); BFs6102_50s(:,x1)])-shift_plot];
x1=repmat(x1,size(y1,1),1);

[p,S] = polyfit(x1,y1,1);
x11 = index1:0.1:index2;
y11 = polyval(p,x11);
[rho12g,pvalue12g]=corr(x1(:),y1(:));
p0value12g=p(1);
p1value12g=p(2);

%plot(x1,y1,'o')
%hold on
plot(x11,y11,'g','LineWidth',linew)

hold on
x1=index1:100:index2;
%y1=[nanmean([BFs6103_75s(:,index1:index2); BFs6103_25l(:,index1:index2)])-shift_plot];

y1=[([BFs6103_75s(:,x1); BFs6103_25l(:,x1)])-shift_plot];
x1=repmat(x1,size(y1,1),1);
[p,S] = polyfit(x1,y1,1);
x11 = index1:0.1:index2;
y11 = polyval(p,x11);
[rho12b,pvalue12b]=corr(x1(:),y1(:));
p0value12b=p(1);
p1value12b=p(2);

%plot(x1,y1,'o')
%hold on
plot(x11,y11,'b','LineWidth',linew)



hold on
x1=index1:100:index2;
%y1=[nanmean([BFs6103_75s(:,index1:index2); BFs6103_25l(:,index1:index2)])-shift_plot];

y1=[([BFs6104(:,x1)])-shift_plot];
x1=repmat(x1,size(y1,1),1);
[p,S] = polyfit(x1,y1,1);
x11 = index1:0.1:index2;
y11 = polyval(p,x11);
[rho12k,pvalue12k]=corr(x1(:),y1(:));
p0value12k=p(1);
p1value12k=p(2);

%plot(x1,y1,'o')
%hold on
plot(x11,y11,'k','LineWidth',linew)








%%%
%%%
%%%
%{
x1=index2:100:index3;
%y1=[nanmean([BFs6101_75l(:,index2:index3);])-shift_plot];
y1=[([BFs6101_75l(:,x1);])-shift_plot];
x1=repmat(x1,size(y1,1),1);

[p,S] = polyfit(x1,y1,1);
x11 = index2:0.1:index3;
y11 = polyval(p,x11);
[rho23r,pvalue23r]=corr(x1(:),y1(:));
p0value23r=p(1);
p1value23r=p(2);

%plot(x1,y1,'o')
%hold on
plot(x11,y11,'r','LineWidth',linew)

hold on
x1=index2:100:index3;
%y1=[nanmean([BFs6102_50l(:,index2:index3);])-shift_plot];
y1=[([BFs6102_50l(:,x1);])-shift_plot];
x1=repmat(x1,size(y1,1),1);


[p,S] = polyfit(x1,y1,1);
x11 = index2:0.1:index3;
y11 = polyval(p,x11);
[rho23g,pvalue23g]=corr(x1(:),y1(:));
p0value23g=p(1);
p1value23g=p(2);

%plot(x1,y1,'o')
%hold on
plot(x11,y11,'g','LineWidth',linew)

hold on
x1=index2:100:index3;
%y1=[nanmean([BFs6103_25l(:,index2:index3);])-shift_plot];
y1=[([BFs6103_25l(:,x1);])-shift_plot];
x1=repmat(x1,size(y1,1),1);
[rho23b,pvalue23b]=corr(x1(:),y1(:));
p0value23b=p(1);
p1value23b=p(2);

[p,S] = polyfit(x1,y1,1);
x11 = index2:0.1:index3;
y11 = polyval(p,x11);
%plot(x1,y1,'o')
%hold on
plot(x11,y11,'b','LineWidth',linew)
%}

%end
%%%
%%%
%%%
x1=index3:100:index4;
yp1=[([BFs6101_75l(:,x1); ])-shift_plot];
yp2=[([BFs6102_50l(:,x1); ])-shift_plot];
yp3=[([BFs6103_25l(:,x1)])-shift_plot];
ypp=[yp1; yp2; yp3];
yppmean=nanmean(ypp);


x1=repmat(x1,size(ypp,1),1);

[p,S] = polyfit(x1,ypp,1);
x11 = index3:0.1:index4;
y11 = polyval(p,x11);
%plot(x1,y1,'o')
%hold on
[rho34,pvalue34]=corr(x1(:),ypp(:));
p0value34=p(1);
p1value34=p(2);





plot(x11,y11,'k','LineWidth',linew)

x=[1500,1500]; y=[-60,60]; plot(x,y,'k'); hold on;
hold on
x=[4500,4500]; y=[-60,60]; plot(x,y,'k'); hold on;




axis([0 5250 yl1f yl2f])

set(gca, 'XTick',[800 1900], 'XTickLabel',{'0\newlineTime from CS onset' '1.5 seconds', })

xlim([0 5000])





%
text(4600,-40+25,['r=' mat2str(rho12k,2)],'Color','k')
text(4600,-37+25, ['p=' mat2str(pvalue12k,2)],'Color','k')
text(4600,-34+25, ['m=' mat2str(p0value12k,2)],'Color','k')


text(4600,-31+25, ['rho=' mat2str(rho12r,2)],'Color','r')
text(4600,-28+25, ['p=' mat2str(pvalue12r,2)],'Color','r')
text(4600,-25+25, ['m=' mat2str(p0value12r,2)],'Color','r')


text(4600,-22+25, ['r=' mat2str(rho12g,2)],'Color','g')
text(4600,-19+25, ['p=' mat2str(pvalue12g,2)],'Color','g')
text(4600,-16+25, ['m' mat2str(p0value12g,2)],'Color','g')


text(4600,-13+25, ['r=' mat2str(rho12b,2)],'Color','b')
text(4600,-10+25, ['p=' mat2str(pvalue12b,2)],'Color','b')
text(4600,-7+25, ['m=' mat2str(p0value12b,2)],'Color','b')




% text(1750,-40, ['r=' mat2str(rho23r,3)],'Color','r')
% text(1750,-37, ['p=' mat2str(pvalue23r,3)],'Color','r')
% text(1750,-34, ['m=' mat2str(p0value23r,3)],'Color','r')
%
% text(1750,-31, ['r=' mat2str(rho23g,3)],'Color','g')
% text(1750,-28, ['p=' mat2str(pvalue23g,3)],'Color','g')
% text(1750,-25, ['m=' mat2str(p0value23g,3)],'Color','g')
%
%
% text(1750,-22, ['r=' mat2str(rho23b,3)],'Color','b')
% text(1750,-19, ['p=' mat2str(pvalue23b,3)],'Color','b')
% text(1750,-16, ['m=' mat2str(p0value23b,3)],'Color','b')


text(5500,-13+25, ['r=' mat2str(rho34,2)],'Color','k')
text(5500,-10+25, ['p=' mat2str(pvalue34,2)],'Color','k')
text(5500,-7+25, ['m=' mat2str(p0value34,2)],'Color','k')
%

nsubplot(250,250,152:202,1:50);
ThresholdColor=0.05;

vvv=find(BFPacrossresponses_rr<ThresholdColor);
scatter(BFrocarea325v50rr,BFrocarea375v50rr,20,'Marker','p','MarkerFaceColor','k','MarkerEdgeColor','k')
scatter(BFrocarea325v50rr(vvv),BFrocarea375v50rr(vvv),20,'Marker','p','MarkerFaceColor','r','MarkerEdgeColor','r')
line([0 1], [0.5 0.5] , 'Color', [0 0 0 ]) ;
line([0.5 0.5],[0 1],  'Color', [0 0 0 ]) ;
axis([-.1 1.1 -.1 1.1])
axis square
xlabel('P(p)=0.25 vs P(p)=0.50\newlineresponse discrimination')
ylabel('P(p)=0.50 vs P(p)=0.75\newlineresponse discrimination')

nsubplot(250,250,170:200,52:82);

region=1:1500;
t1=[BFs6101_25s; BFs6101_75l];
t2=[BFs6102_50s; BFs6102_50l];
t3=[BFs6103_75s; BFs6103_25l];
t11=[nanmean(t1(:,region)')];
t11std=nanstd([nanmean(t1(:,region)')])./sqrt(length(t11));
t12=[nanmean(t2(:,region)')];
t12std=nanstd([nanmean(t2(:,region)')])./sqrt(length(t12));
t13=[nanmean(t3(:,region)')];
t13std=nanstd([nanmean(t3(:,region)')])./sqrt(length(t13));
t11_=t11; t12_=t12; t13_=t13;
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


region=1:1500;
t1=[BFs6101_25s; BFs6101_75l];
t2=[BFs6102_50s; BFs6102_50l];
t3=[BFs6103_75s; BFs6103_25l];
t11=[nanmean(t1(:,region)')];
t11std=nanstd([nanmean(t1(:,region)')])./sqrt(length(t11));
t12=[nanmean(t2(:,region)')];
t12std=nanstd([nanmean(t2(:,region)')])./sqrt(length(t12));
t13=[nanmean(t3(:,region)')];
t13std=nanstd([nanmean(t3(:,region)')])./sqrt(length(t13));
t11_=t11; t12_=t12; t13_=t13;

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
nsubplot(250,250,132:182,1:50);

%plot(1:5000,nanmean(BFs6104(:,1:5000))-shift_plot,'k','LineWidth',linew);
%hold on
% plot(nanmean([BFs6101_75l(:,1:1500); BFs6101_25s(:,1:1500)])-shift_plot,'r','LineWidth',linew)
% hold on
% plot(1500:4500,nanmean(BFs6101_75l(:,1500:4500))-shift_plot,'r','LineWidth',linew);
% hold on
% plot(nanmean([BFs6102_50l(:,1:1500); BFs6102_50s(:,1:1500)])-shift_plot,'g','LineWidth',linew)
% hold on
% plot(1500:4500,nanmean(BFs6102_50l(:,1500:4500))-shift_plot,'g','LineWidth',linew);
% hold on
% plot(nanmean([BFs6103_25l(:,1:1500); BFs6103_75s(:,1:1500)])-shift_plot,'b','LineWidth',linew)
% hold on
% plot(1500:4500,nanmean(BFs6103_25l(:,1500:4500))-shift_plot,'b','LineWidth',linew);
% hold on
% plot(4500:5000,nanmean([BFs6103_25l(:,4500:5000); BFs6102_50l(:,4500:5000);BFs6101_75l(:,4500:5000)])-shift_plot,'k','LineWidth',linew)

% x=index1:index2;
% noisy_y=[nanmean([BFs6101_75l(:,index1:index2); BFs6101_25s(:,index1:index2)])-shift_plot];
% [p,S] = polyfit(x,noisy_y,3)
% x11 = index1:0.1:index2;
% y11 = polyval(p,x11);
% plot(x11,y11,'r','LineWidth',linew); hold on
% [y,delta1] = polyval(p,x11,S);
%
% x=index1:index2;
% noisy_y=[nanmean([BFs6102_50l(:,index1:index2); BFs6102_50s(:,index1:index2)])-shift_plot];
% [p,S] = polyfit(x,noisy_y,3)
% x12 = index1:0.1:index2;
% y12 = polyval(p,x12);
% plot(x12,y12,'g','LineWidth',linew); hold on
% [y,delta2] = polyval(p,x12,S);
%
% x=index1:index2;
% noisy_y=[nanmean([BFs6103_75s(:,index1:index2); BFs6103_25l(:,index1:index2)])-shift_plot];
% [p,S] = polyfit(x,noisy_y,3)
% x13 = index1:0.1:index2;
% y13 = polyval(p,x13);
% plot(x13,y13,'b','LineWidth',linew); hold on
% [y,delta3] = polyval(p,x13,S);
%
% x=index1:index2;
% noisy_y=[nanmean([BFs6104(:,index1:index2)])-shift_plot];
% [p,S] = polyfit(x,noisy_y,3)
% x14 = index1:0.1:index2;
% y14 = polyval(p,x14);
% plot(x14,y14,'k','LineWidth',linew); hold on
% [y,delta4] = polyval(p,x14,S);
%
% %%%
% %%%
% %%%
%
% hold on
%
% x=index2:index3;
% noisy_y=[nanmean([BFs6101_75l(:,index2:index3); BFs6101_25s(:,index2:index3)])-shift_plot];
% [p,S] = polyfit(x,noisy_y,3)
% x11 = index2:0.1:index3;
% y11 = polyval(p,x11);
% plot(x11,y11,'r','LineWidth',linew); hold on
% [y,delta1] = polyval(p,x11,S);
%
% x=index2:index3;
% noisy_y=[nanmean([BFs6102_50l(:,index2:index3); BFs6102_50s(:,index2:index3)])-shift_plot];
% [p,S] = polyfit(x,noisy_y,3)
% x12 = index2:0.1:index3;
% y12 = polyval(p,x12);
% plot(x12,y12,'g','LineWidth',linew); hold on
% [y,delta2] = polyval(p,x12,S);
%
% x=index2:index3;
% noisy_y=[nanmean([BFs6103_75s(:,index2:index3); BFs6103_25l(:,index2:index3)])-shift_plot];
% [p,S] = polyfit(x,noisy_y,3)
% x13 = index2:0.1:index3;
% y13 = polyval(p,x13);
% plot(x13,y13,'b','LineWidth',linew); hold on
% [y,delta3] = polyval(p,x13,S);
%
% x=index2:index3;
% noisy_y=[nanmean([BFs6104(:,index2:index3)])-shift_plot];
% [p,S] = polyfit(x,noisy_y,3)
% x14 = index2:0.1:index3;
% y14 = polyval(p,x14);
% plot(x14,y14,'k','LineWidth',linew); hold on
% [y,delta4] = polyval(p,x14,S);
%
% %%%
% %%%
% %%%
%
% x=index3:index4;
% noisy_y=[nanmean([BFs6101_75l(:,index3:index4); BFs6101_25s(:,index3:index4)])-shift_plot];
% [p,S] = polyfit(x,noisy_y,3)
% x11 = index3:0.1:index4;
% y11 = polyval(p,x11);
% plot(x11,y11,'r','LineWidth',linew); hold on
% [y,delta1] = polyval(p,x11,S);
%
% x=index3:index4;
% noisy_y=[nanmean([BFs6102_50l(:,index3:index4); BFs6102_50s(:,index3:index4)])-shift_plot];
% [p,S] = polyfit(x,noisy_y,3)
% x12 = index3:0.1:index4;
% y12 = polyval(p,x12);
% plot(x12,y12,'g','LineWidth',linew); hold on
% [y,delta2] = polyval(p,x12,S);
%
% x=index3:index4;
% noisy_y=[nanmean([BFs6103_75s(:,index3:index4); BFs6103_25l(:,index3:index4)])-shift_plot];
% [p,S] = polyfit(x,noisy_y,3)
% x13 = index3:0.1:index4;
% y13 = polyval(p,x13);
% plot(x13,y13,'b','LineWidth',linew); hold on
% [y,delta3] = polyval(p,x13,S);
%
% x=index3:index4;
% noisy_y=[nanmean([BFs6104(:,index3:index4)])-shift_plot];
% [p,S] = polyfit(x,noisy_y,3)
% x14 = index3:0.1:index4;
% y14 = polyval(p,x14);
% plot(x14,y14,'k','LineWidth',linew); hold on
% [y,delta4] = polyval(p,x14,S);


%%%
%%%
%%%



%
kk=4
pk=1
 x=pk:4501;
 noisy_y=[nanmean([BFs6101_75l(:,pk:1500); BFs6101_25s(:,pk:1500)])-shift_plot nanmean(BFs6101_75l(:,1500:4500))-shift_plot];
% cs = csapi(x,y);
% fnplt(cs,2);
% hold on
% plot(x,y,'o')

xs=pk:500:4501;
%spl2 = spap2(optknt(xs,kk), kk, x, noisy_y);
spl2 = spap2(kk, kk, x, noisy_y);

%fnplt(spl2,'r',2);
%hold on
v1 = fnval(spl2,x)
plot(pk:4501,v1,'r');
hold on

%hold on
%plot(x,noisy_y,'x')

hold on

%x=1:4501;
 noisy_y=[nanmean([BFs6102_50l(:,pk:1500); BFs6102_50s(:,pk:1500)])-shift_plot nanmean(BFs6102_50l(:,1500:4500))-shift_plot];
% cs = csapi(x,y);
% fnplt(cs,2);
% hold on
% plot(x,y,'o')

xs=pk:500:4501;
%spl2 = spap2(optknt(xs,kk), kk, x, noisy_y);
spl2 = spap2(kk, kk, x, noisy_y);
v2 = fnval(spl2,x)
plot(pk:4501,v2,'g');
hold on
% fnplt(spl2,'g',2);
% hold on
% plot(x,noisy_y,'x')

hold on

%x=1:4501;
 noisy_y=[nanmean([BFs6103_75s(:,pk:1500); BFs6103_25l(:,pk:1500)])-shift_plot nanmean(BFs6103_25l(:,1500:4500))-shift_plot];
% cs = csapi(x,y);
% fnplt(cs,2);
% hold on
% plot(x,y,'o')

xs=pk:500:4501;
%spl2 = spap2(optknt(xs,kk), kk, x, noisy_y);
spl2 = spap2(kk, kk, x, noisy_y);

v3 = fnval(spl2,x)
plot(pk:4501,v3,'b');
hold on
% fnplt(spl2,'b',2);
% hold on
% plot(x,noisy_y,'x')




%x=1:4501;
noisy_y=nanmean(BFs6104(:,pk:4501))-shift_plot;
% cs = csapi(x,y);
% fnplt(cs,2);
% hold on
% plot(x,y,'o')

xs=pk:500:4501;
%spl2 = spap2(optknt(xs,kk), kk, x, noisy_y);
spl2 = spap2(kk+4, kk+4, x, noisy_y);

v4 = fnval(spl2,x)
plot(pk:4501,v4,'k');
hold on






x=[1500,1500]; y=[ylim]; plot(x,y,'k'); hold on;
hold on
x=[4500,4500]; y=[ylim]; plot(x,y,'k'); hold on;
axis([0 5250 -10 20])
set(gca, 'XTick',[800 1900], 'XTickLabel',{'0\newlineTime from CS onset' '1.5 seconds', })
xlim([0 5000])

nsubplot(250,250,192:242,1:50);
plot(pk:4500,diff(v1),'--r')
hold on
plot(pk:4500,diff(v2),'--g')
hold on
plot(pk:4500,diff(v3),'--b')
hold on
plot(pk:4500,diff(v4),'--k')


x=[1500,1500]; y=[ylim]; plot(x,y,'k'); hold on;
hold on
x=[4500,4500]; y=[ylim]; plot(x,y,'k'); hold on;
hold on
x=[0 4500]; y=[0,0]; plot(x,y,'k');
hold on

axis([0 5250 -0.1 0.1])

set(gca, 'XTick',[800 1900], 'XTickLabel',{'0\newlineTime from CS onset' '1.5 seconds', })

xlim([0 5000])
%}
%
%{
rsave6101=[];
psave6101=[];
rsave6102=[];
psave6102=[];
rsave6103=[];
psave6103=[];
for s=1:numel(savestruct);
rsave6101=[rsave6101 savestruct(s).rsave6101];
psave6101=[psave6101 savestruct(s).psave6101];
rsave6102=[rsave6102 savestruct(s).rsave6102];
psave6102=[psave6102 savestruct(s).psave6102];
rsave6103=[rsave6103 savestruct(s).rsave6103];
psave6103=[psave6103 savestruct(s).psave6103];
end

sum6103=rsave6103>0 & psave6103<0.001;
plot(smooth(nanmean(sum6103,2),100,'moving'),'b'); hold on
%plot(nanmean(sum6103,2)),'b'); hold on
sum6102=rsave6102>0 & psave6102<0.001;
plot(smooth(nanmean(sum6102,2),100,'moving'),'g'); hold on
%plot(nanmean(sum6102,2)),'g'); hold on
sum6101=rsave6101>0 & psave6101<0.001;
plot(smooth(nanmean(sum6101,2),100,'moving'),'r'); hold on
%plot((nanmean(sum6101,2)),'r'); hold on
%}




%{
nsubplot(250,250,192:242,1:50);

sum6103=rsave6103<0 & psave6103<0.01;
%plot(smooth(nanmean(sum6103,2),100,'moving'),'b'); hold on
plot(smooth(nanmean(sum6103,2),100,'moving'),'b'); hold on
sum6102=rsave6102<0 & psave6102<0.01;
%plot(smooth(nanmean(sum6102,2),100,'moving'),'g'); hold on
plot(smooth(nanmean(sum6102,2),100,'moving'),'g'); hold on
sum6101=rsave6101<0 & psave6101<0.01;
%plot(smooth(nanmean(sum6101,2),100,'moving'),'r'); hold on
plot(smooth(nanmean(sum6101,2),100,'moving'),'r'); hold on
%}
%{
figure
rsave6103_=rsave6103';
rsave6103_(find(psave6103>0.05))=999;
rsave6103_(find(rsave6103_<0))=999;
rsave6103_(find(rsave6103_~=999))=1;
rsave6103_(find(rsave6103_==999))=0;
plot(nansum(rsave6103_)./size(rsave6103_,1),'b'); hold on

rsave6102_=rsave6102';
rsave6102_(find(psave6102>0.05))=999;
rsave6102_(find(rsave6102_<0))=999;
rsave6102_(find(rsave6102_~=999))=1;
rsave6102_(find(rsave6102_==999))=0;
plot(nansum(rsave6102_)./size(rsave6102_,1),'g'); hold on

rsave6101_=rsave6101';
rsave6101_(find(psave6101>0.05))=999;
rsave6101_(find(rsave6101_<0))=999;
rsave6101_(find(rsave6101_~=999))=1;
rsave6101_(find(rsave6101_==999))=0;
plot(nansum(rsave6101_)./size(rsave6101_,1),'r'); hold on
%}


% x=[1500,1500]; y=[-60,60]; plot(x,y,'k'); hold on;
% hold on
% x=[4500,4500]; y=[-60,60]; plot(x,y,'k'); hold on;
%
% axis([0 5250 0 1])
%
% set(gca, 'XTick',[800 1900], 'XTickLabel',{'0\newlineTime from CS onset' '1.5 seconds', })
%
% xlim([0 5000])


%{
sum6103=rsave6103>0 & psave6103<0.01;
plot(smooth(nanmean(sum6103,2),100,'moving'),'b'); hold on
%plot(nanmean(sum6103,2)),'b'); hold on
sum6102=rsave6102>0 & psave6102<0.01;
plot(smooth(nanmean(sum6102,2),100,'moving'),'g'); hold on
%plot(nanmean(sum6102,2)),'g'); hold on
sum6101=rsave6101>0 & psave6101<0.01;
plot(smooth(nanmean(sum6101,2),100,'moving'),'r'); hold on
%plot((nanmean(sum6101,2)),'r'); hold on
%}
%{
plot(smooth(nanmean(rsave6103(sum6103),2),100,'moving'),'b'); hold on
plot(smooth(nanmean(rsave6102(sum6102),2),100,'moving'),'g'); hold on
plot(smooth(nanmean(rsave6101(sum6101),2),100,'moving'),'r'); hold on
%}

%{
shift_plot=nanmean(nanmean(BFs6104(:,1:15)));
plot(1:5000,nanmean(BFs6104(:,1:5000))-shift_plot,'k','LineWidth',linew);
hold on
plot(nanmean([BFs6101_75l(:,1:1500); BFs6101_25s(:,1:1500)])-shift_plot,'r','LineWidth',linew)
hold on
plot(1500:4500,nanmean(BFs6101_75l(:,1500:4500))-shift_plot,'r','LineWidth',linew);
hold on
plot(nanmean([BFs6102_50l(:,1:1500); BFs6102_50s(:,1:1500)])-shift_plot,'g','LineWidth',linew)
hold on
plot(1500:4500,nanmean(BFs6102_50l(:,1500:4500))-shift_plot,'g','LineWidth',linew);
hold on
plot(nanmean([BFs6103_25l(:,1:1500); BFs6103_75s(:,1:1500)])-shift_plot,'b','LineWidth',linew)
hold on
plot(1500:4500,nanmean(BFs6103_25l(:,1500:4500))-shift_plot,'b','LineWidth',linew);
hold on
plot(4500:5000,nanmean([BFs6103_25l(:,4500:5000); BFs6102_50l(:,4500:5000);BFs6101_75l(:,4500:5000)])-shift_plot,'k','LineWidth',linew)
%}
%{
%
slopesave6104=zeros(4500,1);
slopesave6103=zeros(4500,1);
slopesave6102=zeros(4500,1);
slopesave6101=zeros(4500,1);
%

%
y=2;
    p1=[1 500:500:4500];
    %for x = 1:size(ch6101,2)-400
    
    for x=[1 500:500:4200]
        binAnalysis=[x:x+50];
        binAnalysisNext=[x+450:x+500];
       
       slope6104=nanmean(nanmean(BFs6104(:,binAnalysisNext)))-nanmean(nanmean(BFs6104(:,binAnalysis)));
       slope6101=nanmean(nanmean(BFs6101_75l(:,binAnalysisNext)))-nanmean(nanmean(BFs6101_75l(:,binAnalysis)));
       slope6102=nanmean(nanmean(BFs6102_50l(:,binAnalysisNext)))-nanmean(nanmean(BFs6102_50l(:,binAnalysis)));
       slope6103=nanmean(nanmean(BFs6103_25l(:,binAnalysisNext)))-nanmean(nanmean(BFs6103_25l(:,binAnalysis)));
       
       slopesave6104(p1(y-1):p1(y),1)=slope6104; %(1:length(p1(y-1):p1(y)))
       slopesave6103(p1(y-1):p1(y),1)=slope6103; %(1:length(p1(y-1):p1(y)))
       slopesave6102(p1(y-1):p1(y),1)=slope6102; %(1:length(p1(y-1):p1(y)))
       slopesave6101(p1(y-1):p1(y),1)=slope6101; %(1:length(p1(y-1):p1(y)))

        

        
        y=y+1;
    end
%
%
%
plot(slopesave6104,'k','LineWidth',linew)
hold on
plot(slopesave6101,'r','LineWidth',linew)
hold on
plot(slopesave6102,'g','LineWidth',linew)
hold on
plot(slopesave6103,'b','LineWidth',linew)
%}



%{
plot(1:5000-1,diff(nanmean(BFs6104(:,1:5000))-shift_plot),'k','LineWidth',linew);
hold on
plot(diff(nanmean([BFs6101_75l(:,1:1500); BFs6101_25s(:,1:1500)])-shift_plot),'r','LineWidth',linew)
hold on
plot(1500:4500-1,diff(nanmean(BFs6101_75l(:,1500:4500))-shift_plot),'r','LineWidth',linew);
hold on
plot(diff(nanmean([BFs6102_50l(:,1:1500); BFs6102_50s(:,1:1500)])-shift_plot),'g','LineWidth',linew)
hold on
plot(1500:4500-1,diff(nanmean(BFs6102_50l(:,1500:4500))-shift_plot),'g','LineWidth',linew);
hold on
plot(diff(nanmean([BFs6103_25l(:,1:1500); BFs6103_75s(:,1:1500)])-shift_plot),'b','LineWidth',linew)
hold on
plot(1500:4500-1,diff(nanmean(BFs6103_25l(:,1500:4500))-shift_plot),'b','LineWidth',linew);
hold on
plot(4500:5000,nanmean([BFs6103_25l(:,4500:5000); BFs6102_50l(:,4500:5000);BFs6101_75l(:,4500:5000)])-shift_plot,'k','LineWidth',linew)
%}








%{
x=[1500,1500]; y=[-60,60]; plot(x,y,'k'); hold on;
hold on
x=[4500,4500]; y=[-60,60]; plot(x,y,'k'); hold on;

axis([0 5250 -10 10])

set(gca, 'XTick',[800 1900], 'XTickLabel',{'0\newlineTime from CS onset' '1.5 seconds', })

xlim([0 5000])
%}
%{
BFpval_time=[];
for s=1:6001-200
    %for celln=1:size(BFs6101_75l,1)
    region=[0+s:200+s];
    t1=(BFs6101_75l);
    t2=(BFs6102_50l);
    t3=(BFs6103_25l);
    t11=[nanmean(t1(:,region)')];
    t11std=nanstd([nanmean(t1(:,region)')])./sqrt(length(t11));
    t12=[nanmean(t2(:,region)')];
    t12std=nanstd([nanmean(t2(:,region)')])./sqrt(length(t12));
    t13=[nanmean(t3(:,region)')];
    t13std=nanstd([nanmean(t3(:,region)')])./sqrt(length(t13));
    t11_=t11; t12_=t12; t13_=t13;
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
    %BFpval_time(s,celln)=[BFpval];
    %end
end
BFpval_time<0.05
%}





%{
nsubplot(250,250,12:62,31:50)
shift_plot=nanmean(nanmean(BFs6104(:,1:15)));
plot(nanmean([BFs6101_75l(:,1:1500); BFs6101_25s(:,1:1500)])-shift_plot,'k','LineWidth',linew)
hold on
plot(1500:2000,nanmean(BFs6101_25s(:,1500:2000))-shift_plot,'r','LineWidth',linew);
hold on
plot(1500:5000,nanmean(BFs6101_75l(:,1500:5000))-shift_plot,'k','LineWidth',linew);
hold on


x=[1500,1500]; y=[-60,60]; plot(x,y,'k'); hold on;

x=[4500,4500]; y=[-60,60]; plot(x,y,'k'); hold on;
axis([0 5250 yl1 yl2])

set(gca, 'XTick',[800 1900], 'XTickLabel',{'0\newlineTime from CS onset' '1.5 seconds', })

xlim([0 5000])

%
nsubplot(250,250,12:62,61:80)
shift_plot=nanmean(nanmean(BFs6104(:,1:15)));
plot(nanmean([BFs6102_50l(:,1:1500); BFs6102_50s(:,1:1500)])-shift_plot,'k','LineWidth',linew)
hold on
plot(1500:2000,nanmean(BFs6102_50s(:,1500:2000))-shift_plot,'r','LineWidth',linew);
hold on
plot(1500:5000,nanmean(BFs6102_50l(:,1500:5000))-shift_plot,'k','LineWidth',linew);
hold on
x=[1500,1500]; y=[-60,60]; plot(x,y,'k'); hold on;

x=[4500,4500]; y=[-60,60]; plot(x,y,'k'); hold on;
axis([0 5250 yl1 yl2])

set(gca, 'XTick',[800 1900], 'XTickLabel',{'0\newlineTime from CS onset' '1.5 seconds', })

xlim([0 5000])
%
nsubplot(250,250,12:62,91:110)
shift_plot=nanmean(nanmean(BFs6104(:,1:15)));
plot(nanmean([BFs6103_25l(:,1:1500); BFs6103_75s(:,1:1500)])-shift_plot,'k','LineWidth',linew)
hold on
plot(1500:2000,nanmean(BFs6103_75s(:,1500:2000))-shift_plot,'r','LineWidth',linew);
hold on
plot(1500:5000,nanmean(BFs6103_25l(:,1500:5000))-shift_plot,'k','LineWidth',linew);
hold on
x=[1500,1500]; y=[-60,60]; plot(x,y,'k'); hold on;
x=[1500,1500]; y=[-60,60]; plot(x,y,'k'); hold on;

x=[4500,4500]; y=[-60,60]; plot(x,y,'k'); hold on;
axis([0 5250 yl1 yl2])

set(gca, 'XTick',[800 1900], 'XTickLabel',{'0\newlineTime from CS onset' '1.5 seconds', })

xlim([0 5000])

nsubplot(250,250,12:62,121:140)
plot(nanmean(BFs6101_75l),'r','LineWidth',linew); hold on
plot(nanmean(BFs6102_50l),'g','LineWidth',linew); hold on
plot(nanmean(BFs6103_25l),'b','LineWidth',linew); hold on
x=[4500,4500]; y=[-20,60]; plot(x,y,'k'); hold on;
set(gca,'ticklength',4*get(gca,'ticklength'))
if strcmpi(str,'BF')
line([region(1) region(end)], [-19 -19] , 'Color', [0 0 0 ],'LineWidth',2);
elseif strcmpi(str,'BG')
    line([region(1) region(end)], [-4 -4] , 'Color', [0 0 0 ],'LineWidth',2);
end
if BFpval<0.05
text(1700,22,['P<0.05'])
else
    text(1700,22,['NS'])
end
axis([4300 4900 yl1 yl2+10])
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

%}

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
% print(sprintf('%s.pdf', 'timing-phasic-input-bf-ramp-50ms'),'-dpdf')
% elseif strcmpi(str,'BG')
% set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
% print(sprintf('%s.pdf', 'timing-phasic-input-bg-ramp-50ms'),'-dpdf')
% end






%
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