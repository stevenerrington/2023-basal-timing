clc; clear all; close all;
addpath(genpath('C:\Users\Ilya Monosov\Dropbox\HELPER\'))
 



WinSize=1000;
RangeforOutcome=[3100:3100+WinSize];
RangeforCS=[2900-WinSize:2900];
RangeforLateR=[5900-WinSize:5900];


figure
% nsubplot(200,200,1:200, 1:200)
%
load timingproceduresummary3monksBG_50msNew.mat

         FanoSave6103=vertcat(savestruct(1,:). FanoSave6103); 
    FanoSave6102=vertcat(savestruct(1,:). FanoSave6102); 
    FanoSave6101=vertcat(savestruct(1,:). FanoSave6101); 
FanoSaveAll=(FanoSave6103+FanoSave6102+FanoSave6101)./3
t(1:size(FanoSaveAll,1),1:50)=NaN;
FanoSaveAll=[t vertcat(savestruct(1,:). FanoSaveAll)];
plotthese=FanoSaveAll(:,1:3000);
x=1:length(plotthese); v=sqrt(size(plotthese,1));
shadedErrorBar(x, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',[0 0 0], 'LineWidth', 2}, 0); hold on



load timingproceduresummary3monksBF_phasic_V1.mat
         FanoSave6103=vertcat(savestruct(1,:). FanoSave6103); 
    FanoSave6102=vertcat(savestruct(1,:). FanoSave6102); 
    FanoSave6101=vertcat(savestruct(1,:). FanoSave6101); 
FanoSaveAll=(FanoSave6103+FanoSave6102+FanoSave6101)./3

t(1:size(FanoSaveAll,1),1:50)=NaN;
FanoSaveAll=[t vertcat(savestruct(1,:). FanoSaveAll)];
plotthese=FanoSaveAll(:,1:3000);
x=1:length(plotthese); v=sqrt(size(plotthese,1));
shadedErrorBar(x, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',[0.4 0.4 0.4], 'LineWidth', 2}, 0); hold on


load timingproceduresummary3monksBF_tonic_V1.mat
         FanoSave6103=vertcat(savestruct(1,:). FanoSave6103); 
    FanoSave6102=vertcat(savestruct(1,:). FanoSave6102); 
    FanoSave6101=vertcat(savestruct(1,:). FanoSave6101); 
FanoSaveAll=(FanoSave6103+FanoSave6102+FanoSave6101)./3
 
t(1:size(FanoSaveAll,1),1:50)=NaN;
FanoSaveAll=[t vertcat(savestruct(1,:). FanoSaveAll)];
plotthese=FanoSaveAll(:,1:3000);
x=1:length(plotthese); v=sqrt(size(plotthese,1));
shadedErrorBar(x, plotthese, {@nanmean, @(x) nanstd(x)./v}, {'Color',[0.9 0.9 0.4], 'LineWidth', 2}, 0); hold on


axis([0 3000 0 5])

ylabel('Fano Factor')
grid on
xlim = get(gca,'xlim');  %Get x range 
plot([xlim(1) xlim(2)],[1 1],'k')
ylim = get(gca,'ylim');  %Get x range 
plot([500 500],[ylim(1) ylim(2)],'k')
plot([1500 1500],[ylim(1) ylim(2)],'k')


