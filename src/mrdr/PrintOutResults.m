
clear all; clc; close all; warning off;
load('probamt.mat');

dosubtraction=2;

LINESIZE=2;
YLIMM=75;
WindowAn=[5150:6500];
normalBBB=[3000:4000];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x1=[500,500]; y1=[0,150];
x2=[1500,1500]; y2=[0,150];
x3=[3000,3000]; y3=[0,150];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;

baselinesort=nanmean(SF50prob50(:,3500:4500)');
sorted=sort(baselinesort);
ss=[];
for xz=1:length(baselinesort)
    s=baselinesort(xz);
    ss=[ss; (find(sorted==s))];
end

baselinesort=max(SF50prob50');
baselinesorts=[];
for xz=1:10000
    baselinesorts=[baselinesorts; baselinesort(ss)];
end
baselinesorts=baselinesorts';



SF50amt0=SF50amt0(ss,:)./baselinesorts;
SF50amt25=SF50amt25(ss,:)./baselinesorts;
SF50amt50=SF50amt50(ss,:)./baselinesorts;
SF50amt75=SF50amt75(ss,:)./baselinesorts;
SF50amt100=SF50amt100(ss,:)./baselinesorts;
SF50prob0=SF50prob0(ss,:)./baselinesorts;
SF50prob25=SF50prob25(ss,:)./baselinesorts;
SF50prob50=SF50prob50(ss,:)./baselinesorts;
SF50prob75=SF50prob75(ss,:)./baselinesorts;
SF50prob100=SF50prob100(ss,:)./baselinesorts;

SF50amt0=SF50amt0(ss,:);
SF50amt25=SF50amt25(ss,:);
SF50amt50=SF50amt50(ss,:);
SF50amt75=SF50amt75(ss,:);
SF50amt100=SF50amt100(ss,:);
SF50prob0=SF50prob0(ss,:);
SF50prob25=SF50prob25(ss,:);
SF50prob50=SF50prob50(ss,:);
SF50prob75=SF50prob75(ss,:);
SF50prob100=SF50prob100(ss,:);



xzz=.3;

figure
%
YLIMM1=11
nsubplot(15,25,1:5,1:5)
for xz=1:size(SF50amt0,1)
    plot(SF50amt0(xz,3500:7500)+(xz*xzz),'k')
     axis square; ylim([0 YLIMM1]); xlim([0 4000])
    hold on
end
%
nsubplot(15,25,1:5,6:10)
for xz=1:size(SF50amt25,1)
    plot(SF50amt25(xz,3500:7500)+(xz*xzz),'k')
     axis square; ylim([0 YLIMM1]); xlim([0 4000])
    hold on
end
%
nsubplot(15,25,1:5,11:15)
for xz=1:size(SF50amt50,1)
    plot(SF50amt50(xz,3500:7500)+(xz*xzz),'k')
     axis square; ylim([0 YLIMM1]); xlim([0 4000])
    hold on
end
%
nsubplot(15,25,1:5,16:20)
for xz=1:size(SF50amt75,1)
    plot(SF50amt75(xz,3500:7500)+(xz*xzz),'k')
     axis square; ylim([0 YLIMM1]); xlim([0 4000])
    hold on
end
%
nsubplot(15,25,1:5,21:25)
%
for xz=1:size(SF50amt100,1)
    plot(SF50amt100(xz,3500:7500)+(xz*xzz),'k')
     axis square; ylim([0 YLIMM1]); xlim([0 4000])
    hold on
end
%%%%
nsubplot(15,25,7:11,1:5)
for xz=1:size(SF50prob0,1)
    plot(SF50prob0(xz,3500:7500)+(xz*xzz),'r')
     axis square; ylim([0 YLIMM1]); xlim([0 4000])
    hold on
end
%
nsubplot(15,25,7:11,6:10)
for xz=1:size(SF50prob25,1)
    plot(SF50prob25(xz,3500:7500)+(xz*xzz),'r')
     axis square; ylim([0 YLIMM1]); xlim([0 4000])
    hold on
end
%
nsubplot(15,25,7:11,11:15)
for xz=1:size(SF50prob50,1)
    plot(SF50prob50(xz,3500:7500)+(xz*xzz),'r')
     axis square; ylim([0 YLIMM1]); xlim([0 4000])
    hold on
end
%
nsubplot(15,25,7:11,16:20)
for xz=1:size(SF50prob75,1)
    plot(SF50prob75(xz,3500:7500)+(xz*xzz),'r')
     axis square; ylim([0 YLIMM1]); xlim([0 4000])
    hold on
end
%
nsubplot(15,25,7:11,21:25)
%
for xz=1:size(SF50prob100,1)
    plot(SF50prob100(xz,3500:7500)+(xz*xzz),'r')
     axis square; ylim([0 YLIMM1]); xlim([0 4000])
    hold on
end
%%%%%%%%%%%%%%%%%%


load('probamt.mat');
figure

if dosubtraction==0
    nsubplot(50,50,1:5,1:5)
    p=plot(nanmean(SF50amt0(:,3500:7500)),'k'); hold on
    set(p,'LineWidth',LINESIZE)
    hold on; plot(x1,y1); hold on; plot(x2,y2); hold on; plot(x3,y3);
    axis square; ylim([0 YLIMM]); xlim([0 4000])
    hold on
    ylabel('firing rate'); hold on
    title('amount')
    nsubplot(50,50,1:5,6:10)
    p=plot(nanmean(SF50amt25(:,3500:7500)),'k'); hold on
    set(p,'LineWidth',LINESIZE)
    hold on; plot(x1,y1); hold on; plot(x2,y2); hold on; plot(x3,y3);
    axis square; ylim([0 YLIMM]);  xlim([0 4000])
    nsubplot(50,50,1:5,11:15)
    p=plot(nanmean(SF50amt50(:,3500:7500)),'k'); hold on
    set(p,'LineWidth',LINESIZE)
    hold on; plot(x1,y1); hold on; plot(x2,y2); hold on; plot(x3,y3);
    axis square; ylim([0 YLIMM]);  xlim([0 4000])
    nsubplot(50,50,1:5,16:20)
    p=plot(nanmean(SF50amt75(:,3500:7500)),'k'); hold on
    set(p,'LineWidth',LINESIZE)
    hold on; plot(x1,y1); hold on; plot(x2,y2); hold on; plot(x3,y3);
    axis square; ylim([0 YLIMM]);  xlim([0 4000])
    nsubplot(50,50,1:5,21:25)
    p=plot(nanmean(SF50amt100(:,3500:7500)),'k'); hold on
    set(p,'LineWidth',LINESIZE)
    hold on; plot(x1,y1); hold on; plot(x2,y2); hold on; plot(x3,y3);
    axis square; ylim([0 YLIMM]);  xlim([0 4000])
    
elseif dosubtraction==1
    nsubplot(50,50,1:5,1:5)
    YLIMM1=35;
    XLIM1=-5;
    p=plot(nanmean(SF50prob0(:,3500:7500))-nanmean(SF50amt0(:,3500:7500)),'k'); hold on
    set(p,'LineWidth',LINESIZE)
    hold on; plot(x1,y1); hold on; plot(x2,y2); hold on; plot(x3,y3);
    axis square; ylim([XLIM1 YLIMM1]); xlim([0 4000])
    hold on
    ylabel('firing rate'); hold on
    
    nsubplot(50,50,1:5,6:10)
    
    p=plot(nanmean(SF50prob25(:,3500:7500))-nanmean(SF50amt25(:,3500:7500)),'k'); hold on
    set(p,'LineWidth',LINESIZE)
    hold on; plot(x1,y1); hold on; plot(x2,y2); hold on; plot(x3,y3);
    axis square; ylim([XLIM1 YLIMM1]); xlim([0 4000])
    hold on
    ylabel('firing rate'); hold on
    
    nsubplot(50,50,1:5,11:15)
    
    p=plot(nanmean(SF50prob50(:,3500:7500))-nanmean(SF50amt50(:,3500:7500)),'k'); hold on
    set(p,'LineWidth',LINESIZE)
    hold on; plot(x1,y1); hold on; plot(x2,y2); hold on; plot(x3,y3);
    axis square; ylim([XLIM1 YLIMM1]); xlim([0 4000])
    hold on
    ylabel('firing rate'); hold on
    
    nsubplot(50,50,1:5,16:20)
    
    p=plot(nanmean(SF50prob75(:,3500:7500))-nanmean(SF50amt75(:,3500:7500)),'k'); hold on
    set(p,'LineWidth',LINESIZE)
    hold on; plot(x1,y1); hold on; plot(x2,y2); hold on; plot(x3,y3);
    axis square; ylim([XLIM1 YLIMM1]); xlim([0 4000])
    hold on
    ylabel('firing rate'); hold on
    
    nsubplot(50,50,1:5,21:25)
    
    p=plot(nanmean(SF50prob100(:,3500:7500))-nanmean(SF50amt100(:,3500:7500)),'k'); hold on
    set(p,'LineWidth',LINESIZE)
    hold on; plot(x1,y1); hold on; plot(x2,y2); hold on; plot(x3,y3);
    axis square; ylim([XLIM1 YLIMM1]); xlim([0 4000])
    hold on
    ylabel('firing rate'); hold on
    
elseif dosubtraction==2
    
    nsubplot(50,50,1:5,1:5)
    p=plot(nanmean(SF50prob0(:,3500:7500))-nanmean(SF50amt0(:,3500:7500)),'r'); hold on
    set(p,'LineWidth',LINESIZE)
    p=plot(nanmean(SF50prob25(:,3500:7500))-nanmean(SF50amt25(:,3500:7500)),'m'); hold on
    set(p,'LineWidth',LINESIZE)
    p=plot(nanmean(SF50prob50(:,3500:7500))-nanmean(SF50amt50(:,3500:7500)),'k'); hold on
    set(p,'LineWidth',LINESIZE)
    p=plot(nanmean(SF50prob75(:,3500:7500))-nanmean(SF50amt75(:,3500:7500)),'g'); hold on
    set(p,'LineWidth',LINESIZE)
    p=plot(nanmean(SF50prob100(:,3500:7500))-nanmean(SF50amt100(:,3500:7500)),'y'); hold on
    set(p,'LineWidth',LINESIZE)
    ylim([-5 60])
    xlim([0 4000])
    
    nsubplot(50,50,1:5,6:10)
    set(p,'LineWidth',LINESIZE)
    p=plot(nanmean(SF50prob0(:,3500:7500)),'r'); hold on
    set(p,'LineWidth',LINESIZE)
    p=plot(nanmean(SF50prob25(:,3500:7500)),'m'); hold on
    set(p,'LineWidth',LINESIZE)
    p=plot(nanmean(SF50prob50(:,3500:7500)),'k'); hold on
    set(p,'LineWidth',LINESIZE)
    p=plot(nanmean(SF50prob75(:,3500:7500)),'g'); hold on
    set(p,'LineWidth',LINESIZE)
    p=plot(nanmean(SF50prob100(:,3500:7500)),'y'); hold on
    ylim([-5 60])
    xlim([0 4000])
    
    
    nsubplot(50,50,1:5,11:15)
    p=plot(nanmean(SF50amt0(:,3500:7500)),'r'); hold on
    p=plot(nanmean(SF50amt25(:,3500:7500)),'m'); hold on
    p=plot(nanmean(SF50amt50(:,3500:7500)),'k'); hold on
    p=plot(nanmean(SF50amt75(:,3500:7500)),'g'); hold on
    p=plot(nanmean(SF50amt100(:,3500:7500)),'y'); hold on
    ylim([-5 60])
    xlim([0 4000])
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

x1=[500,500]; y1=[0,150];
x2=[1500,1500]; y2=[0,150];
x3=[3000,3000]; y3=[0,150];

nsubplot(50,50,10:14,1:5)
p=plot(nanmean(SF50prob0(:,3500:7500)),'k'); hold on
set(p,'LineWidth',LINESIZE)
hold on; plot(x1,y1); hold on; plot(x2,y2); hold on; plot(x3,y3);
axis square; ylim([0 YLIMM]); xlim([0 4000])
title('probability'); hold on
ylabel('firing rate'); hold on
nsubplot(50,50,10:14,6:10)
p=plot(nanmean(SF50prob25(:,3500:6500)),'k'); hold on
set(p,'LineWidth',LINESIZE)
p=plot(3000:4000,nanmean(SF50prob25r(:,6500:7500)),'k'); hold on
set(p,'LineWidth',LINESIZE)
p=plot(3000:4000,nanmean(SF50prob25nr(:,6500:7500)),'g'); hold on
set(p,'LineWidth',LINESIZE)
hold on; plot(x1,y1); hold on; plot(x2,y2); hold on; plot(x3,y3);
axis square; ylim([0 YLIMM]); xlim([0 4000])
nsubplot(50,50,10:14,11:15)
p=plot(nanmean(SF50prob50(:,3500:6500)),'k'); hold on
set(p,'LineWidth',LINESIZE)
p=plot(3000:4000,nanmean(SF50prob50r(:,6500:7500)),'k'); hold on
set(p,'LineWidth',LINESIZE)
p=plot(3000:4000,nanmean(SF50prob50nr(:,6500:7500)),'g'); hold on
set(p,'LineWidth',LINESIZE)
hold on; plot(x1,y1); hold on; plot(x2,y2); hold on; plot(x3,y3);
axis square; ylim([0 YLIMM]); xlim([0 4000])
nsubplot(50,50,10:14,16:20)
p=plot(nanmean(SF50prob75(:,3500:6500)),'k'); hold on
set(p,'LineWidth',LINESIZE)
p=plot(3000:4000,nanmean(SF50prob75r(:,6500:7500)),'k'); hold on
set(p,'LineWidth',LINESIZE)
p=plot(3000:4000,nanmean(SF50prob75nr(:,6500:7500)),'g'); hold on
set(p,'LineWidth',LINESIZE)
hold on; plot(x1,y1); hold on; plot(x2,y2); hold on; plot(x3,y3);
axis square; ylim([0 YLIMM]); xlim([0 4000])
nsubplot(50,50,10:14,21:25)
p=plot(nanmean(SF50prob100(:,3500:7500)),'k'); hold on
set(p,'LineWidth',LINESIZE)
hold on; plot(x1,y1); hold on; plot(x2,y2); hold on; plot(x3,y3);
axis square; ylim([0 YLIMM]); xlim([0 4000])
%set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
%print('-dpdf', 'C:\Users\monosovi\Desktop\probamtSDFs.pdf' );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

temp=nanmean([SF50prob100; SF50prob75; SF50prob50; SF50prob25; SF50prob0;SF50amt100; SF50amt75; SF50amt50; SF50amt25; SF50amt0;]);
normalbase=nanmean(temp(normalBBB)); clear temp
%
temp=nanmean([SF50amt100; SF50amt75; SF50amt50; SF50amt25; SF50amt0;]);
normalbaseA=nanmean(temp(normalBBB)); clear temp
normalbaseA=nanmean([SF50amt100(:,normalBBB)'; SF50amt75(:,normalBBB)'; SF50amt50(:,normalBBB)'; SF50amt25(:,normalBBB)'; SF50amt0(:,normalBBB)';])
%
temp=nanmean([SF50prob100; SF50prob75; SF50prob50; SF50prob25; SF50prob0;]);
normalbaseP=nanmean(temp(normalBBB)); clear temp
normalbaseP=nanmean([SF50prob100(:,normalBBB)'; SF50prob75(:,normalBBB)'; SF50prob50(:,normalBBB)'; SF50prob25(:,normalBBB)'; SF50prob0(:,normalBBB)';])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ProbBlockR=[];
ProbBlockSER=[];
AmtBlockR=[];
AmtBlockSER=[];
ProbBlock=[];
ProbBlockSE=[];
AmtBlock=[];
AmtBlockSE=[];

signrank((nanmean(SF50prob50(:,WindowAn)')-normalbaseP),(nanmean(SF50prob25(:,WindowAn)')-normalbaseP))



temp=nanmean(SF50prob100(:,WindowAn)');
temp=temp-normalbaseP;
prob100norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
ProbBlock=[ProbBlock;nanmean(temp)];
ProbBlockSE=[ProbBlockSE;t]; clear temp t
%
temp=nanmean(SF50prob75(:,WindowAn)');
temp=temp-normalbaseP;
prob75norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
ProbBlock=[ProbBlock;nanmean(temp)];
ProbBlockSE=[ProbBlockSE;t]; clear temp t
%
temp=nanmean(SF50prob50(:,WindowAn)');
temp=temp-normalbaseP;
prob50norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
ProbBlock=[ProbBlock;nanmean(temp)];
ProbBlockSE=[ProbBlockSE;t]; clear temp t
%
temp=nanmean(SF50prob25(:,WindowAn)');
temp=temp-normalbaseP;
prob25norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
ProbBlock=[ProbBlock;nanmean(temp)];
ProbBlockSE=[ProbBlockSE;t]; clear temp t
%
temp=nanmean(SF50prob0(:,WindowAn)');
temp=temp-normalbaseP;
prob0norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
ProbBlock=[ProbBlock;nanmean(temp)];
ProbBlockSE=[ProbBlockSE;t]; clear temp t
%
temp=nanmean(SF50amt100(:,WindowAn)');
temp=temp-normalbaseA;
amt100norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
AmtBlock=[AmtBlock;nanmean(temp)];
AmtBlockSE=[AmtBlockSE;t]; clear temp t
%
temp=nanmean(SF50amt75(:,WindowAn)');
temp=temp-normalbaseA;
amt75norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
AmtBlock=[AmtBlock;nanmean(temp)];
AmtBlockSE=[AmtBlockSE;t]; clear temp t
%
temp=nanmean(SF50amt50(:,WindowAn)');
temp=temp-normalbaseA;
amt50norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
AmtBlock=[AmtBlock;nanmean(temp)];
AmtBlockSE=[AmtBlockSE;t]; clear temp t
%
temp=nanmean(SF50amt25(:,WindowAn)');
temp=temp-normalbaseA;
amt25norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
AmtBlock=[AmtBlock;nanmean(temp)];
AmtBlockSE=[AmtBlockSE;t]; clear temp t
%
temp=nanmean(SF50amt0(:,WindowAn)');
temp=temp-normalbaseA;
amt0norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
AmtBlock=[AmtBlock;nanmean(temp)];
AmtBlockSE=[AmtBlockSE;t]; clear temp t

LINESIZE=1.5;
nsubplot(50,50,20:30,1:10)
p=errorbar(ProbBlock([5,4,3,2,1]),ProbBlockSE([5,4,3,2,1]),'r')
set(p,'LineWidth',LINESIZE)
hold on
p=errorbar(AmtBlock([5,4,3,2,1]),AmtBlockSE([5,4,3,2,1]),'k')
set(p,'LineWidth',LINESIZE)
xlim([0 6]); ylim([-10 20])
xticklabel_rotate([1:5],45,{'0%','25%','50%','75%','100%'},'interpreter','none')
hold on
ylabel('firing rate'); hold on
title('red-prob black-amount')
temp=ProbBlock-AmtBlock;
axis square

if signrank(nanmean(SF50prob0(:,WindowAn)')-normalbaseP,nanmean(SF50prob25(:,WindowAn)')-normalbaseP)<0.05
    plot(1.4,20,'r*','MarkerSize',8)
end
if signrank(nanmean(SF50prob25(:,WindowAn)')-normalbaseP,nanmean(SF50prob50(:,WindowAn)')-normalbaseP)<0.05
    plot(2.4,20,'r*','MarkerSize',8)
end
if signrank(nanmean(SF50prob75(:,WindowAn)')-normalbaseP,nanmean(SF50prob50(:,WindowAn)')-normalbaseP)<0.05
    plot(3.4,20,'r*','MarkerSize',8)
end
if signrank(nanmean(SF50prob75(:,WindowAn)')-normalbaseP,nanmean(SF50prob100(:,WindowAn)')-normalbaseP)<0.05
    plot(4.6,20,'r*','MarkerSize',8)
end
if signrank(nanmean(SF50prob75(:,WindowAn)')-normalbaseP,nanmean(SF50prob25(:,WindowAn)')-normalbaseP)<0.05
    plot(3,10,'r*','MarkerSize',8)
end



if signrank(nanmean(SF50amt0(:,WindowAn)')-normalbaseA,nanmean(SF50amt25(:,WindowAn)')-normalbaseA)<0.05
    plot(1.4,-7,'k*','MarkerSize',8)
end
if signrank(nanmean(SF50amt25(:,WindowAn)')-normalbaseA,nanmean(SF50amt50(:,WindowAn)')-normalbaseA)<0.05
    plot(2.4,-7,'k*','MarkerSize',8)
end
if signrank(nanmean(SF50amt75(:,WindowAn)')-normalbaseA,nanmean(SF50amt50(:,WindowAn)')-normalbaseA)<0.05
    plot(3.4,-7,'k*','MarkerSize',8)
end
if signrank(nanmean(SF50amt75(:,WindowAn)')-normalbaseA,nanmean(SF50amt100(:,WindowAn)')-normalbaseA)<0.05
    plot(4.6,-7,'k*','MarkerSize',8)
end
if signrank(nanmean(SF50amt75(:,WindowAn)')-normalbaseA,nanmean(SF50amt25(:,WindowAn)')-normalbaseA)<0.05
    plot(3,-10,'k*','MarkerSize',8)
end




% %normalized
% signrank(nanmean(SF50prob0(:,WindowAn)')-normalbaseP,nanmean(SF50amt0(:,WindowAn)')-normalbaseA)
% signrank(nanmean(SF50prob100(:,WindowAn)')-normalbaseP,nanmean(SF50amt100(:,WindowAn)')-normalbaseA)
% %not normalized
% signrank(nanmean(SF50prob0(:,WindowAn)'),nanmean(SF50amt0(:,WindowAn)'))
% signrank(nanmean(SF50prob100(:,WindowAn)'),nanmean(SF50amt100(:,WindowAn)'))
% %
% signrank(nanmean(SF50prob100(:,WindowAn)')-normalbaseP,nanmean(SF50prob75(:,WindowAn)')-normalbaseP)
% signrank(nanmean(SF50prob75(:,WindowAn)')-normalbaseP,nanmean(SF50prob50(:,WindowAn)')-normalbaseP)
% signrank(nanmean(SF50prob50(:,WindowAn)')-normalbaseP,nanmean(SF50prob25(:,WindowAn)')-normalbaseP)
% signrank(nanmean(SF50prob75(:,WindowAn)')-normalbaseP,nanmean(SF50prob25(:,WindowAn)')-normalbaseP)
% signrank(nanmean(SF50prob0(:,WindowAn)')-normalbaseP,nanmean(SF50prob25(:,WindowAn)')-normalbaseP)
% signrank(nanmean(SF50prob100(:,WindowAn)')-normalbaseP,nanmean(SF50prob0(:,WindowAn)')-normalbaseP)
% %
% signrank(nanmean(SF50amt100(:,WindowAn)')-normalbaseA,nanmean(SF50amt75(:,WindowAn)')-normalbaseA)
% signrank(nanmean(SF50amt75(:,WindowAn)')-normalbaseA,nanmean(SF50amt50(:,WindowAn)')-normalbaseA)
% signrank(nanmean(SF50amt50(:,WindowAn)')-normalbaseA,nanmean(SF50amt25(:,WindowAn)')-normalbaseA)
% signrank(nanmean(SF50amt0(:,WindowAn)')-normalbaseA,nanmean(SF50amt25(:,WindowAn)')-normalbaseA)
% signrank(nanmean(SF50amt0(:,WindowAn)')-normalbaseA,nanmean(SF50amt100(:,WindowAn)')-normalbaseA)
% signrank(nanmean(SF50amt0(:,WindowAn)')-normalbaseA,nanmean(SF50amt50(:,WindowAn)')-normalbaseA)
% signrank(nanmean(SF50amt0(:,WindowAn)')-normalbaseA,nanmean(SF50amt75(:,WindowAn)')-normalbaseA)
% size(amt0norm)


%
% close all
% figure
% TTT=LOOKINGPROB(1:18,[5 4 3 2 1]);
% TTT_se=std(TTT)./sqrt(size(TTT,1));
% p=errorbar(nanmean(TTT),TTT_se,'r')
% set(p,'LineWidth',LINESIZE)
% hold on
% TTT=LOOKINGAMT(1:18,[5 4 3 2 1]);
% TTT_se=std(TTT)./sqrt(size(TTT,1));
% p=errorbar(nanmean(TTT),TTT_se,'k')
% set(p,'LineWidth',LINESIZE)
% ylim([0 100])
%
% figure
% TTT=LOOKINGPROB(19:31,[5 4 3 2 1]);
% TTT_se=std(TTT)./sqrt(size(TTT,1));
% p=errorbar(nanmean(TTT),TTT_se,'r')
% set(p,'LineWidth',LINESIZE)
% hold on
% TTT=LOOKINGAMT(19:31,[5 4 3 2 1]);
% TTT_se=std(TTT)./sqrt(size(TTT,1));
% p=errorbar(nanmean(TTT),TTT_se,'k')
% set(p,'LineWidth',LINESIZE)
% ylim([0 100])


nsubplot(50,50,41:47,41:47);
TTT=LOOKINGPROB(:,[5 4 3 2 1]);
TTT_se=std(TTT)./sqrt(size(TTT,1));
p=errorbar(nanmean(TTT),TTT_se,'r')
set(p,'LineWidth',LINESIZE)
hold on
TTT=LOOKINGAMT(:,[5 4 3 2 1]);
TTT_se=std(TTT)./sqrt(size(TTT,1));
p=errorbar(nanmean(TTT),TTT_se,'k')
set(p,'LineWidth',LINESIZE)
ylim([0 100]); axis square;
title('look%')

%ddfsf

uncertind=(prob50norm-prob100norm)./(prob50norm+prob100norm)
valueind=(amt100norm-amt0norm)./(amt100norm+amt0norm)
[rho,p]=corr(uncertind',valueind')
valueind=(prob100norm-prob0norm)./(prob100norm+prob0norm)
[rho,p]=corr(uncertind',valueind')

TTT=[prob0norm' prob25norm' prob50norm' prob75norm' prob100norm']-[amt0norm' amt25norm' amt50norm' amt75norm' amt100norm'];
TTT_se=std(TTT)./sqrt(size(TTT,1))
nsubplot(50,50,20:30,10:20)
p=errorbar(nanmean(TTT),TTT_se,'r')
set(p,'LineWidth',LINESIZE)
hold on
xlim([0 6]); ylim([-5 10])
xticklabel_rotate([1:5],45,{'0%','25%','50%','75%','100%'},'interpreter','none')
hold on
title('difference')
%
signrank(TTT(:,1),TTT(:,2))
if signrank(TTT(:,1),TTT(:,2))<0.05
    plot(1.4,10,'*','MarkerSize',8)
end
signrank(TTT(:,3),TTT(:,2))
if signrank(TTT(:,3),TTT(:,2))<0.05
    plot(2.6,10,'*','MarkerSize',8)
end
%
signrank(TTT(:,3),TTT(:,4))
if signrank(TTT(:,3),TTT(:,4))<0.05
    plot(3.7,10,'*','MarkerSize',8)
end
%
signrank(TTT(:,5),TTT(:,4))
if signrank(TTT(:,5),TTT(:,4))<0.05
    plot(4.8,10,'*','MarkerSize',8)
end
%
signrank(TTT(:,2),TTT(:,4))
if signrank(TTT(:,2),TTT(:,4))<0.05
    plot(3,5,'*','MarkerSize',8)
end



LINESIZE=1;
clear tempR;
countsZ=[];
tempR=[amt0norm' amt25norm' amt50norm' amt75norm' amt100norm'];
SaveC=[];
for x=1:length(tempR)
    crap=tempR(x,:);
    crap=crap./crap(5);
    %crap=((crap)-min(crap))./max((crap)-min(crap));
    SaveC=[SaveC; crap'];
    if max(crap)==crap(3)
        countsZ=[countsZ; 1];
    else
        countsZ=[countsZ; 0];
    end
    
    nsubplot(50,50,1:7,30:37);
    
    p=plot([1; 2; 3; 4; 5],crap(1:5),'k'); axis square;
    set(p,'LineWidth',LINESIZE)
    hold on
    xlim([0 6]); hold on
    %ylim([-.1 1.1]); 
    ylim([0 10])
    axis square; hold on
    
    hold on
    title('black-amt;red-prob'); hold on
end
xlabel(['n=' int2str(size(tempR(:,1),1))])


clear tempR;
countsZ=[];
tempR=[prob0norm' prob25norm' prob50norm' prob75norm' prob100norm'];
SaveC=[];
for x=1:length(tempR)
    crap=tempR(x,:);
    crap=crap./crap(5);
    %crap=((crap)-min(crap))./max((crap)-min(crap));
    SaveC=[SaveC; crap'];
    if max(crap)==crap(3)
        countsZ=[countsZ; 1];
    else
        countsZ=[countsZ; 0];
    end
    
    nsubplot(50,50,9:15,30:37)
    
    p=plot([1; 2; 3; 4; 5],crap(1:5),'r'); axis square;
    set(p,'LineWidth',LINESIZE)
    hold on
    xlim([0 6]); hold on
    %ylim([-.1 1.1]); 
    ylim([0 10])
    axis square; hold on
    hold on
    
end
xlabel(['n=' int2str(size(tempR(:,1),1))])
clear tempR;

figure
countsZ=[];
tempR=TTT;
SaveC=[];
for x=1:length(tempR)
    crap=tempR(x,:);
    crap=((crap)-min(crap))./max((crap)-min(crap));
    SaveC=[SaveC; crap'];

    p=plot([1; 2; 3; 4; 5],crap(1:5),'r'); axis square;
    set(p,'LineWidth',LINESIZE)
    hold on
    xlim([0 6]); hold on
    ylim([0 1])
    axis square; hold on
    hold on
    
end
clear tempR

sdfesf

LINESIZE=1;
nsubplot(50,50,20:23,36:39);
for zzzz=1:size(linepar,2)
    P=linepar(zzzz).P33
    x=linepar(zzzz).x33
    yfit=linepar(zzzz).yfit33
    p=plot(x,yfit,'k-');
    set(p,'LineWidth',LINESIZE)
    hold on
    axis square
    xlim([0 9]); ylim([0 120])
    %slope=P(1)
    %%yfit = P(1)*x+P(2) is the equation.... P(1) is the slope and P(2) is the
    %%intercept
    
end

nsubplot(50,50,20:23,32:35);
for zzzz=1:size(linepar,2)
    P=linepar(zzzz).P34
    x=linepar(zzzz).x34
    yfit=linepar(zzzz).yfit34
    p=plot(x,yfit,'k-');
    set(p,'LineWidth',LINESIZE)
    hold on
    axis square
    xlim([0 9]); ylim([0 120])
    %slope=P(1)
    %%yfit = P(1)*x+P(2) is the equation.... P(1) is the slope and P(2) is the
    %%intercept
    
end

nsubplot(50,50,20:23,28:31);
for zzzz=1:size(linepar,2)
    P=linepar(zzzz).P35
    x=linepar(zzzz).x35
    yfit=linepar(zzzz).yfit35
    p=plot(x,yfit,'k-');
    set(p,'LineWidth',LINESIZE)
    hold on
    axis square
    xlim([0 9]); ylim([0 120])
    %slope=P(1)
    %%yfit = P(1)*x+P(2) is the equation.... P(1) is the slope and P(2) is the
    %%intercept
    
end

nsubplot(50,50,20:23,24:27);
for zzzz=1:size(linepar,2)
    P=linepar(zzzz).P36
    x=linepar(zzzz).x36
    yfit=linepar(zzzz).yfit36
    p=plot(x,yfit,'k-');
    set(p,'LineWidth',LINESIZE)
    hold on
    axis square
    xlim([0 9]); ylim([0 120])
    %slope=P(1)
    %%yfit = P(1)*x+P(2) is the equation.... P(1) is the slope and P(2) is the
    %%intercept
end

nsubplot(50,50,20:23,20:23);
for zzzz=1:size(linepar,2)
    P=linepar(zzzz).P37
    x=linepar(zzzz).x37
    yfit=linepar(zzzz).yfit37
    p=plot(x,yfit,'k-');
    set(p,'LineWidth',LINESIZE)
    hold on
    axis square
    xlim([0 9]); ylim([0 120])
    hold on
    %slope=P(1)
    %%yfit = P(1)*x+P(2) is the equation.... P(1) is the slope and P(2) is the
    %%intercept
end


nsubplot(50,50,25:28,36:39);
for zzzz=1:size(linepar,2)
    P=linepar(zzzz).P38
    x=linepar(zzzz).x38
    yfit=linepar(zzzz).yfit38
    p=plot(x,yfit,'r-');
    set(p,'LineWidth',LINESIZE)
    hold on
    axis square
    xlim([0 9]); ylim([0 120])
    %slope=P(1)
    %%yfit = P(1)*x+P(2) is the equation.... P(1) is the slope and P(2) is the
    %%intercept
end
nsubplot(50,50,25:28,32:35);
for zzzz=1:size(linepar,2)
    P=linepar(zzzz).P39
    x=linepar(zzzz).x39
    yfit=linepar(zzzz).yfit39
    p=plot(x,yfit,'r-');
    set(p,'LineWidth',LINESIZE)
    hold on
    axis square
    xlim([0 9]); ylim([0 120])
    %slope=P(1)
    %%yfit = P(1)*x+P(2) is the equation.... P(1) is the slope and P(2) is the
    %%intercept
end
nsubplot(50,50,25:28,28:31);
for zzzz=1:size(linepar,2)
    P=linepar(zzzz).P40
    x=linepar(zzzz).x40
    yfit=linepar(zzzz).yfit40
    p=plot(x,yfit,'r-');
    set(p,'LineWidth',LINESIZE)
    hold on
    axis square
    xlim([0 9]); ylim([0 120])
    %slope=P(1)
    %%yfit = P(1)*x+P(2) is the equation.... P(1) is the slope and P(2) is the
    %%intercept
end
nsubplot(50,50,25:28,24:27);
for zzzz=1:size(linepar,2)
    P=linepar(zzzz).P41
    x=linepar(zzzz).x41
    yfit=linepar(zzzz).yfit41
    p=plot(x,yfit,'r-');
    set(p,'LineWidth',LINESIZE)
    hold on
    axis square
    xlim([0 9]); ylim([0 120])
    %slope=P(1)
    %%yfit = P(1)*x+P(2) is the equation.... P(1) is the slope and P(2) is the
    %%intercept
end
nsubplot(50,50,25:28,20:23);
for zzzz=1:size(linepar,2)
    P=linepar(zzzz).P42
    x=linepar(zzzz).x42
    yfit=linepar(zzzz).yfit42
    p=plot(x,yfit,'r-');
    set(p,'LineWidth',LINESIZE)
    hold on
    axis square
    xlim([0 9]); ylim([0 120])
    %slope=P(1)
    %%yfit = P(1)*x+P(2) is the equation.... P(1) is the slope and P(2) is the
    %%intercept
    hold on
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% figure
% amtSlope=[];
% probSlope=[];
% for zzzz=1:size(linepar,2)
%     amt_temp=[linepar(zzzz).P37(1) linepar(zzzz).P36(1) linepar(zzzz).P35(1) linepar(zzzz).P34(1) linepar(zzzz).P33(1)];
%     prob_temp=[linepar(zzzz).P42(1) linepar(zzzz).P41(1) linepar(zzzz).P40(1) linepar(zzzz).P39(1) linepar(zzzz).P38(1)];
%     amtSlope=[amtSlope; amt_temp]; clear amt_temp
%     probSlope=[probSlope; prob_temp]; clear prob_temp
% end
% TTT=probSlope;
% TTT_se=std(TTT)./sqrt(size(TTT,1))
% p=errorbar(nanmean(TTT),TTT_se,'r')
% set(p,'LineWidth',LINESIZE)
% hold on
% xlim([0 6]); ylim([-3 3])
% xticklabel_rotate([1:5],45,{'0%','25%','50%','75%','100%'},'interpreter','none')
% hold on
% title('slope')
% %
% signrank(TTT(:,1),TTT(:,2))
% if signrank(TTT(:,1),TTT(:,2))<0.05
%     plot(1.4,2,'*','MarkerSize',8)
% end
% signrank(TTT(:,3),TTT(:,2))
% if signrank(TTT(:,3),TTT(:,2))<0.05
%     plot(2.6,2,'*','MarkerSize',8)
% end
% %
% signrank(TTT(:,3),TTT(:,4))
% if signrank(TTT(:,3),TTT(:,4))<0.05
%     plot(3.7,2,'*','MarkerSize',8)
% end
% %
% signrank(TTT(:,5),TTT(:,4))
% if signrank(TTT(:,5),TTT(:,4))<0.05
%     plot(4.8,2,'*','MarkerSize',8)
% end
% %
% signrank(TTT(:,2),TTT(:,4))
% if signrank(TTT(:,2),TTT(:,4))<0.05
%     plot(3,1,'*','MarkerSize',8)
% end
% TTT=amtSlope;
% TTT_se=std(TTT)./sqrt(size(TTT,1))
% p=errorbar(nanmean(TTT),TTT_se,'k')
% set(p,'LineWidth',LINESIZE)
% signrank(TTT(:,1),TTT(:,2))
% if signrank(TTT(:,1),TTT(:,2))<0.05
%     plot(1.4,-2,'*','MarkerSize',8)
% end
% signrank(TTT(:,3),TTT(:,2))
% if signrank(TTT(:,3),TTT(:,2))<0.05
%     plot(2.6,-2,'*','MarkerSize',8)
% end
% %
% signrank(TTT(:,3),TTT(:,4))
% if signrank(TTT(:,3),TTT(:,4))<0.05
%     plot(3.7,-2,'*','MarkerSize',8)
% end
% %
% signrank(TTT(:,5),TTT(:,4))
% if signrank(TTT(:,5),TTT(:,4))<0.05
%     plot(4.8,-2,'*','MarkerSize',8)
% end
% %
% signrank(TTT(:,2),TTT(:,4))
% if signrank(TTT(:,2),TTT(:,4))<0.05
%     plot(3,-1,'*','MarkerSize',8)
% end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





OUTPUT=ChoiceAnalysis;
nsubplot(50,50,33:40,33:40);
image(colormapify(flipud(OUTPUT(1).ChoiceMatrixAmtVsAmt),[0 100],'b','w','r','k'))
%set(gca,'YTickLabel',{'';'75';'';'50';'';'25';'';'0'})
axis([0 5 0 5])
title('amt')
OUTPUT(1).ChoiceMatrixAmtVsAmt
xticklabel_rotate([1:4],0,{'25','50','75','100'},'interpreter','none')
yticklabel_rotate([1:4],0,{'0','25','50','75'},'interpreter','none')
axis square;



nsubplot(50,50,33:40,23:30);
image(colormapify(flipud(OUTPUT(1).ChoiceMatrixProbVsProb),[0 100],'b','w','r','k'))
%set(gca,'YTickLabel',{'';'75';'';'50';'';'25';'';'0'})
axis([0 5 0 5])
title('prob')
OUTPUT(1).ChoiceMatrixProbVsProb
xticklabel_rotate([1:4],0,{'25','50','75','100'},'interpreter','none')
yticklabel_rotate([1:4],0,{'0','25','50','75'},'interpreter','none')
axis square;


nsubplot(50,50,33:40,13:20);
image(colormapify(flipud(OUTPUT(1).ChoiceMatrixProbVsAmt),[0 100],'b','w','r','k'))
%set(gca,'YTickLabel',{'';'75';'';'50';'';'25';'';'0'})
axis([0 6 0 6])
title(['probVsamt; n=' int2str(OUTPUT(1).TotalTrials) ' total trials'])
OUTPUT(1).ChoiceMatrixProbVsAmt
xticklabel_rotate([1:5],0,{'0','25','50','75','100'},'interpreter','none')
yticklabel_rotate([1:5],0,{'0','25','50','75','100'},'interpreter','none')
axis square;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



clear all; clc;
load('C:\Users\monosovi\Desktop\MRDR\probamt1.mat');

LINESIZE=1.5;
YLIMM=75;
WindowAn=[5150:6500];
normalBBB=[3000:4000];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

temp=nanmean([SF50prob100; SF50prob75; SF50prob50; SF50prob25; SF50prob0;SF50amt100; SF50amt75; SF50amt50; SF50amt25; SF50amt0;]);
normalbase=nanmean(temp(normalBBB)); clear temp
%
temp=nanmean([SF50amt100; SF50amt75; SF50amt50; SF50amt25; SF50amt0;]);
normalbaseA=nanmean(temp(normalBBB)); clear temp
normalbaseA=nanmean([SF50amt100(:,normalBBB)'; SF50amt75(:,normalBBB)'; SF50amt50(:,normalBBB)'; SF50amt25(:,normalBBB)'; SF50amt0(:,normalBBB)';])
%
temp=nanmean([SF50prob100; SF50prob75; SF50prob50; SF50prob25; SF50prob0;]);
normalbaseP=nanmean(temp(normalBBB)); clear temp
normalbaseP=nanmean([SF50prob100(:,normalBBB)'; SF50prob75(:,normalBBB)'; SF50prob50(:,normalBBB)'; SF50prob25(:,normalBBB)'; SF50prob0(:,normalBBB)';])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ProbBlockR=[];
ProbBlockSER=[];
AmtBlockR=[];
AmtBlockSER=[];
ProbBlock=[];
ProbBlockSE=[];
AmtBlock=[];
AmtBlockSE=[];
signrank((nanmean(SF50prob50(:,WindowAn)')-normalbaseP),(nanmean(SF50prob25(:,WindowAn)')-normalbaseP))

temp=nanmean(SF50prob100(:,WindowAn)');
temp=temp-normalbaseP;
prob100norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
ProbBlock=[ProbBlock;nanmean(temp)];
ProbBlockSE=[ProbBlockSE;t]; clear temp t
%
temp=nanmean(SF50prob75(:,WindowAn)');
temp=temp-normalbaseP;
prob75norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
ProbBlock=[ProbBlock;nanmean(temp)];
ProbBlockSE=[ProbBlockSE;t]; clear temp t
%
temp=nanmean(SF50prob50(:,WindowAn)');
temp=temp-normalbaseP;
prob50norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
ProbBlock=[ProbBlock;nanmean(temp)];
ProbBlockSE=[ProbBlockSE;t]; clear temp t
%
temp=nanmean(SF50prob25(:,WindowAn)');
temp=temp-normalbaseP;
prob25norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
ProbBlock=[ProbBlock;nanmean(temp)];
ProbBlockSE=[ProbBlockSE;t]; clear temp t
%
temp=nanmean(SF50prob0(:,WindowAn)');
temp=temp-normalbaseP;
prob0norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
ProbBlock=[ProbBlock;nanmean(temp)];
ProbBlockSE=[ProbBlockSE;t]; clear temp t
%
temp=nanmean(SF50amt100(:,WindowAn)');
temp=temp-normalbaseA;
amt100norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
AmtBlock=[AmtBlock;nanmean(temp)];
AmtBlockSE=[AmtBlockSE;t]; clear temp t
%
temp=nanmean(SF50amt75(:,WindowAn)');
temp=temp-normalbaseA;
amt75norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
AmtBlock=[AmtBlock;nanmean(temp)];
AmtBlockSE=[AmtBlockSE;t]; clear temp t
%
temp=nanmean(SF50amt50(:,WindowAn)');
temp=temp-normalbaseA;
amt50norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
AmtBlock=[AmtBlock;nanmean(temp)];
AmtBlockSE=[AmtBlockSE;t]; clear temp t
%
temp=nanmean(SF50amt25(:,WindowAn)');
temp=temp-normalbaseA;
amt25norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
AmtBlock=[AmtBlock;nanmean(temp)];
AmtBlockSE=[AmtBlockSE;t]; clear temp t
%
temp=nanmean(SF50amt0(:,WindowAn)');
temp=temp-normalbaseA;
amt0norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
AmtBlock=[AmtBlock;nanmean(temp)];
AmtBlockSE=[AmtBlockSE;t]; clear temp t

LINESIZE=1.5;
nsubplot(50,50,35:40,1:5);
p=errorbar(ProbBlock([5,4,3,2,1]),ProbBlockSE([5,4,3,2,1]),'g')
set(p,'LineWidth',LINESIZE)
xlim([0 6]); ylim([-10 20])
hold on
ylabel('firing rate'); hold on
title('grn-set1 mag-set2')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



clear all; clc;
load('C:\Users\monosovi\Desktop\MRDR\probamt2.mat');

LINESIZE=1.5;
YLIMM=75;
WindowAn=[5150:6500];
normalBBB=[3000:4000];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

temp=nanmean([SF50prob100; SF50prob75; SF50prob50; SF50prob25; SF50prob0;SF50amt100; SF50amt75; SF50amt50; SF50amt25; SF50amt0;]);
normalbase=nanmean(temp(normalBBB)); clear temp
%
temp=nanmean([SF50amt100; SF50amt75; SF50amt50; SF50amt25; SF50amt0;]);
normalbaseA=nanmean(temp(normalBBB)); clear temp
normalbaseA=nanmean([SF50amt100(:,normalBBB)'; SF50amt75(:,normalBBB)'; SF50amt50(:,normalBBB)'; SF50amt25(:,normalBBB)'; SF50amt0(:,normalBBB)';])
%
temp=nanmean([SF50prob100; SF50prob75; SF50prob50; SF50prob25; SF50prob0;]);
normalbaseP=nanmean(temp(normalBBB)); clear temp
normalbaseP=nanmean([SF50prob100(:,normalBBB)'; SF50prob75(:,normalBBB)'; SF50prob50(:,normalBBB)'; SF50prob25(:,normalBBB)'; SF50prob0(:,normalBBB)';])
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ProbBlockR=[];
ProbBlockSER=[];
AmtBlockR=[];
AmtBlockSER=[];
ProbBlock=[];
ProbBlockSE=[];
AmtBlock=[];
AmtBlockSE=[];
signrank((nanmean(SF50prob50(:,WindowAn)')-normalbaseP),(nanmean(SF50prob25(:,WindowAn)')-normalbaseP))

temp=nanmean(SF50prob100(:,WindowAn)');
temp=temp-normalbaseP;
prob100norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
ProbBlock=[ProbBlock;nanmean(temp)];
ProbBlockSE=[ProbBlockSE;t]; clear temp t
%
temp=nanmean(SF50prob75(:,WindowAn)');
temp=temp-normalbaseP;
prob75norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
ProbBlock=[ProbBlock;nanmean(temp)];
ProbBlockSE=[ProbBlockSE;t]; clear temp t
%
temp=nanmean(SF50prob50(:,WindowAn)');
temp=temp-normalbaseP;
prob50norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
ProbBlock=[ProbBlock;nanmean(temp)];
ProbBlockSE=[ProbBlockSE;t]; clear temp t
%
temp=nanmean(SF50prob25(:,WindowAn)');
temp=temp-normalbaseP;
prob25norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
ProbBlock=[ProbBlock;nanmean(temp)];
ProbBlockSE=[ProbBlockSE;t]; clear temp t
%
temp=nanmean(SF50prob0(:,WindowAn)');
temp=temp-normalbaseP;
prob0norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
ProbBlock=[ProbBlock;nanmean(temp)];
ProbBlockSE=[ProbBlockSE;t]; clear temp t
%
temp=nanmean(SF50amt100(:,WindowAn)');
temp=temp-normalbaseA;
amt100norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
AmtBlock=[AmtBlock;nanmean(temp)];
AmtBlockSE=[AmtBlockSE;t]; clear temp t
%
temp=nanmean(SF50amt75(:,WindowAn)');
temp=temp-normalbaseA;
amt75norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
AmtBlock=[AmtBlock;nanmean(temp)];
AmtBlockSE=[AmtBlockSE;t]; clear temp t
%
temp=nanmean(SF50amt50(:,WindowAn)');
temp=temp-normalbaseA;
amt50norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
AmtBlock=[AmtBlock;nanmean(temp)];
AmtBlockSE=[AmtBlockSE;t]; clear temp t
%
temp=nanmean(SF50amt25(:,WindowAn)');
temp=temp-normalbaseA;
amt25norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
AmtBlock=[AmtBlock;nanmean(temp)];
AmtBlockSE=[AmtBlockSE;t]; clear temp t
%
temp=nanmean(SF50amt0(:,WindowAn)');
temp=temp-normalbaseA;
amt0norm=temp;
temp=temp(find(~isnan(temp)==1));
t=std(temp)./sqrt(length(temp));
AmtBlock=[AmtBlock;nanmean(temp)];
AmtBlockSE=[AmtBlockSE;t]; clear temp t

LINESIZE=1.5;
nsubplot(50,50,35:40,1:5);
p=errorbar(ProbBlock([5,4,3,2,1]),ProbBlockSE([5,4,3,2,1]),'m')
set(p,'LineWidth',LINESIZE)
xlim([0 6]); ylim([-10 20])
hold on
xlabel(['n=' int2str(size(SF50amt0(:,3000),1))])





