clc; clear all; close all;
addpath('X:\Kaining\HELPER_GENERAL')
 
load timingproceduresummary3monksBF_tonic_V1.mat

WinSize=1000;
RangeforOutcome=[3100:3100+WinSize];
RangeforCS=[2900-WinSize:2900];
RangeforLateR=[5900-WinSize:5900];


FanoSaveAll=vertcat(savestruct(1,:). FanoSaveAll); 
t(1:size(FanoSaveAll,1),1:50)=NaN;
%t=[];

FanoSaveAll=[t vertcat(savestruct(1,:). FanoSaveAll)];
FanoSave6103=[t vertcat(savestruct(1,:). FanoSave6103)];
FanoSave6102=[t vertcat(savestruct(1,:). FanoSave6102)];
FanoSave6101=[t vertcat(savestruct(1,:). FanoSave6101)];
FanoSave6104=[t vertcat(savestruct(1,:). FanoSave6104)];
FanoSave6201=[t vertcat(savestruct(1,:). FanoSave6201)];
FanoSaveAllomit=[t vertcat(savestruct(1,:). FanoSaveAllomit)];
FanoSave6105omit=[t vertcat(savestruct(1,:). FanoSave6105omit)];
FanoSave6103omit=[t vertcat(savestruct(1,:). FanoSave6103omit)];
FanoSave6102omit=[t vertcat(savestruct(1,:). FanoSave6102omit)];
FanoSave6101omit=[t vertcat(savestruct(1,:). FanoSave6101omit)];
FanoSave6201omit=[t vertcat(savestruct(1,:). FanoSave6201omit)];
%
All_FanoSaveAllomit=vertcat(savestruct(1,:). All_FanoSaveAllomit); 
t(1:size(All_FanoSaveAllomit,1),1:50)=NaN;
FanoSaveAllomitAll = [t vertcat(savestruct(1,:). All_FanoSaveAllomit) ];
%

% 
l6103omit=vertcat(savestruct(1,:). l6103omit);
l6102omit=vertcat(savestruct(1,:). l6102omit);
l6101omit=vertcat(savestruct(1,:). l6101omit);
l6201omit=vertcat(savestruct(1,:). l6201omit);
%l6105omit=vertcat(savestruct(1,:). l6105omit);
AllSDFomit=vertcat(savestruct(1,:). AllSDFomit);
AllSDF=vertcat(savestruct(1,:). AllSDF);
l6103=vertcat(savestruct(1,:). l6103);
l6102=vertcat(savestruct(1,:). l6102);
l6101=vertcat(savestruct(1,:). l6101);
l6104=vertcat(savestruct(1,:). l6104);
l6201=vertcat(savestruct(1,:). l6201);


figure
plot(nanmean(FanoSave6101omit(:,:)),'c'); hold on
plot(nanmean(FanoSave6102omit(:,:)),'r'); hold on
plot(nanmean(FanoSave6103omit(:,:)),'m'); hold on



figure
% nsubplot(200,200,1:99, 1:99)
title('BF')
all_color = {'m','b','g','r'};
%
plotthese=FanoSaveAll(:,1:1499);
x=1:length(plotthese); v=sqrt(size(plotthese,1));
shadedErrorBar(x, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',[0 0 0], 'LineWidth', 2}, 0); hold on
%
RangeX=[1500:2999];
plotthese=FanoSave6101(:,RangeX);
x=1:length(plotthese); v=sqrt(size(plotthese,1));
shadedErrorBar(RangeX, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',all_color{3}, 'LineWidth', 2}, 0); hold on
%

plotthese=FanoSave6102(:,RangeX);
x=1:length(plotthese); v=sqrt(size(plotthese,1));
shadedErrorBar(RangeX, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',all_color{2}, 'LineWidth', 2}, 0); hold on
%
%

plotthese=FanoSave6103(:,RangeX);
x=1:length(plotthese); v=sqrt(size(plotthese,1));
shadedErrorBar(RangeX, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',all_color{1}, 'LineWidth', 2}, 0); hold on
%

% plotthese=FanoSave6201(:,RangeX);
% x=1:length(plotthese); v=sqrt(size(plotthese,1));
% shadedErrorBar(RangeX, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',all_color{4}, 'LineWidth', 2}, 0); hold on


%RangeX=[3000:3499];
RangeX=[3000:4250];
plotthese=FanoSave6101omit(:,RangeX);
x=1:length(plotthese); v=sqrt(size(plotthese,1));
shadedErrorBar(RangeX, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',all_color{3}, 'LineWidth', 2}, 0); hold on
%

%RangeX=[3000:3499];
plotthese=FanoSave6102omit(:,RangeX);
x=1:length(plotthese); v=sqrt(size(plotthese,1));
shadedErrorBar(RangeX, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',all_color{2}, 'LineWidth', 2}, 0); hold on
%
%
%RangeX=[3000:3499];
plotthese=FanoSave6103omit(:,RangeX);
x=1:length(plotthese); v=sqrt(size(plotthese,1));
shadedErrorBar(RangeX, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',all_color{1}, 'LineWidth', 2}, 0); hold on
%
% RangeX=[3000:5000];
% plotthese=FanoSave6201omit(:,RangeX);
% x=1:length(plotthese); v=sqrt(size(plotthese,1));
% shadedErrorBar(RangeX, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',all_color{4}, 'LineWidth', 2}, 0); hold on
% %
%

RangeX=[4251:5900];
plotthese=FanoSaveAllomit(:,RangeX);
x=1:length(plotthese); v=sqrt(size(plotthese,1));
shadedErrorBar(RangeX, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',[0 0 0], 'LineWidth', 2}, 0); hold on

ylabel('Fano Factor')
grid on

xlim = get(gca,'xlim');  %Get x range 
plot([xlim(1) xlim(2)],[1 1],'k')
ylim = get(gca,'ylim');  %Get x range 
plot([500 500],[ylim(1) ylim(2)],'k')
plot([1500 1500],[ylim(1) ylim(2)],'k')
plot([3000 3000],[ylim(1) ylim(2)],'k')

plot([RangeforCS(1) RangeforCS(end)],[ylim(1) ylim(1)],'k','LineWidth',5)
plot([RangeforLateR(1) RangeforLateR(end)],[ylim(1) ylim(1)],'k','LineWidth',5)
plot([RangeforOutcome(1) RangeforOutcome(end)],[ylim(1) ylim(1)],'k','LineWidth',5)


 
%%
nsubplot(200,200,101:200, 1:99)

%
plotthese=AllSDF(:,1:1499);
x=1:length(plotthese); v=sqrt(size(plotthese,1));
shadedErrorBar(x, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',[0 0 0], 'LineWidth', 2}, 0); hold on
%
%
RangeX=[1500:2999];
plotthese=l6101(:,RangeX);
x=1:length(plotthese); v=sqrt(size(plotthese,1));
shadedErrorBar(RangeX, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',all_color{3}, 'LineWidth', 2}, 0); hold on
%


plotthese=l6102(:,RangeX);
x=1:length(plotthese); v=sqrt(size(plotthese,1));
shadedErrorBar(RangeX, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',all_color{2}, 'LineWidth', 2}, 0); hold on
%

plotthese=l6103(:,RangeX);
x=1:length(plotthese); v=sqrt(size(plotthese,1));
shadedErrorBar(RangeX, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',all_color{1}, 'LineWidth', 2}, 0); hold on

% plotthese=l6201(:,RangeX);
% x=1:length(plotthese); v=sqrt(size(plotthese,1));
% shadedErrorBar(RangeX, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',all_color{4}, 'LineWidth', 2}, 0); hold on
% %
% RangeX=[1500:2999];
% plotthese=l6104(:,RangeX);
% x=1:length(plotthese); v=sqrt(size(plotthese,1));
% shadedErrorBar(RangeX, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',[0 0 0], 'LineWidth', 2}, 0); hold on
% %

RangeX=[3000:5900];
plotthese=l6101omit(:,RangeX);
x=1:length(plotthese); v=sqrt(size(plotthese,1));
shadedErrorBar(RangeX, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',all_color{3}, 'LineWidth', 2}, 0); hold on
%

plotthese=l6102omit(:,RangeX);
x=1:length(plotthese); v=sqrt(size(plotthese,1));
shadedErrorBar(RangeX, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',all_color{2}, 'LineWidth', 2}, 0); hold on
%

plotthese=l6103omit(:,RangeX);
x=1:length(plotthese); v=sqrt(size(plotthese,1));
shadedErrorBar(RangeX, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',all_color{1}, 'LineWidth', 2}, 0); hold on
%

% plotthese=l6201omit(:,RangeX);
% x=1:length(plotthese); v=sqrt(size(plotthese,1));
% shadedErrorBar(RangeX, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',all_color{4}, 'LineWidth', 2}, 0); hold on
% %
% %
ylabel('Firing rate')
ylim = get(gca,'ylim');  %Get x range 
plot([500 500],[ylim(1) ylim(2)],'k')
plot([1500 1500],[ylim(1) ylim(2)],'k')
plot([3000 3000],[ylim(1) ylim(2)],'k')
text( 4000,25,['n=' mat2str(size(plotthese,1))] );
plot([RangeforCS(1) RangeforCS(end)],[ylim(1) ylim(1)],'k','LineWidth',5)
plot([RangeforLateR(1) RangeforLateR(end)],[ylim(1) ylim(1)],'k','LineWidth',5)
plot([RangeforOutcome(1) RangeforOutcome(end)],[ylim(1) ylim(1)],'k','LineWidth',5)



sdf

nsubplot(200,200,1:99, 151:200)
axis([0 15 0.5 1.2])

errorbar( 1, nanmean(nanmean(FanoSave6101(:,RangeforCS)')), std(nanmean(FanoSave6101(:,RangeforCS)'))./sqrt(size(FanoSave6101,1)) ,'k'); hold on
errorbar( 2, nanmean(nanmean(FanoSave6102(:,RangeforCS)')), std(nanmean(FanoSave6102(:,RangeforCS)'))./sqrt(size(FanoSave6102,1)) ,'k'); hold on
errorbar( 3, nanmean(nanmean(FanoSave6103(:,RangeforCS)')), std(nanmean(FanoSave6103(:,RangeforCS)'))./sqrt(size(FanoSave6103,1)) ,'k'); hold on
errorbar( 4, nanmean(nanmean(FanoSave6201(:,RangeforCS)')), std(nanmean(FanoSave6201(:,RangeforCS)'))./sqrt(size(FanoSave6201,1)) ,'k'); hold on
bar( 1, nanmean(nanmean(FanoSave6101(:,RangeforCS)')) ); 
bar( 2, nanmean(nanmean(FanoSave6102(:,RangeforCS)')) ); 
bar( 3, nanmean(nanmean(FanoSave6103(:,RangeforCS)')) ); 
bar( 4, nanmean(nanmean(FanoSave6201(:,RangeforCS)')) ); 

errorbar( 7, nanmean(nanmean(FanoSave6101omit(:,RangeforOutcome)')), std(nanmean(FanoSave6101omit(:,RangeforOutcome)'))./sqrt(size(FanoSave6101omit,1)) ,'k'); hold on
errorbar( 8, nanmean(nanmean(FanoSave6102omit(:,RangeforOutcome)')), std(nanmean(FanoSave6102omit(:,RangeforOutcome)'))./sqrt(size(FanoSave6102omit,1)) ,'k'); hold on
errorbar( 9, nanmean(nanmean(FanoSave6103omit(:,RangeforOutcome)')), std(nanmean(FanoSave6103omit(:,RangeforOutcome)'))./sqrt(size(FanoSave6103omit,1)) ,'k'); hold on
errorbar( 10, nanmean(nanmean(FanoSave6201omit(:,RangeforOutcome)')), std(nanmean(FanoSave6201omit(:,RangeforOutcome)'))./sqrt(size(FanoSave6201omit,1)) ,'k'); hold on
bar( 7, nanmean(nanmean(FanoSave6101omit(:,RangeforOutcome)')) ); 
bar( 8, nanmean(nanmean(FanoSave6102omit(:,RangeforOutcome)')) ); 
bar( 9, nanmean(nanmean(FanoSave6103omit(:,RangeforOutcome)')) ); 
bar( 10, nanmean(nanmean(FanoSave6201omit(:,RangeforOutcome)')) ); 

errorbar( 13, nanmean(nanmean(FanoSaveAllomit(:,RangeforLateR)')), std(nanmean(FanoSaveAllomit(:,RangeforLateR)'))./sqrt(size(FanoSaveAllomit,1)) )
bar( 13, nanmean(nanmean(FanoSaveAllomit(:,RangeforLateR)')) );

ylabel('Fano Factor')
xlim = get(gca,'xlim');  %Get x range 
plot([xlim(1) xlim(2)],[1 1],'k')



Fano6101= nanmean(FanoSave6101omit(:,RangeforOutcome)')
Fano6103= nanmean(FanoSave6103omit(:,RangeforOutcome)')

signrank(Fano6101,1)
signrank(Fano6103,1)
signrank(Fano6101,Fano6103)