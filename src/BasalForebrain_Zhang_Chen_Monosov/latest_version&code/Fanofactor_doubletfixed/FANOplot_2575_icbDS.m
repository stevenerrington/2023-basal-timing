clc; clear all; close all; beep off;
addpath('X:\Kaining\HELPER_GENERAL')
addpath('C:\Users\Ilya Monosov\Dropbox\HELPER\HELPER_GENERAL')
doprint=1;

RangeforearlyCS=[3000:3951];


    
    load Data25_V2icbds.mat
    savestruct=ProbAmtDataStruct




FanoSaveAll=vertcat(savestruct(1,:). FanoSaveAll);
t(1:size(FanoSaveAll,1),1:50)=NaN;
FanoSaveAll=[t vertcat(savestruct(1,:). FanoSaveAll)];
FanoSave75=[t vertcat(savestruct(1,:). FanoSave75)];
FanoSave50=[t vertcat(savestruct(1,:). FanoSave50)];
FanoSave25=[t vertcat(savestruct(1,:). FanoSave25)];
FanoSave0=[t vertcat(savestruct(1,:). FanoSave0)];
FanoSave100=[t vertcat(savestruct(1,:). FanoSave100)];

SDF100=vertcat(savestruct(1,:). SDF100);
SDF75=vertcat(savestruct(1,:). SDF75);
SDF50=vertcat(savestruct(1,:). SDF50);
SDF25=vertcat(savestruct(1,:). SDF25);
SDF0=vertcat(savestruct(1,:). SDF0);


% SDF100=vertcat(savestruct(1,:). raw_SDFcs_actp100);
% SDF75=vertcat(savestruct(1,:). raw_SDFcs_actp75);
% SDF50=vertcat(savestruct(1,:). raw_SDFcs_actp50);
% SDF25=vertcat(savestruct(1,:). raw_SDFcs_actp25);
% SDF0=vertcat(savestruct(1,:). raw_SDFcs_actp0);
%
%



RangeX=[1:3951];
figure
nsubplot(200,200,1:99, 1:99); hold on;
plot(nanmean(FanoSave25(:,RangeX)),'r','LineWidth',2); hold on
plot(nanmean(FanoSave50(:,RangeX)),'g','LineWidth',2); hold on
plot(nanmean(FanoSave75(:,RangeX)),'m','LineWidth',2); hold on
plot(nanmean(FanoSave100(:,RangeX)),'k','LineWidth',2); hold on
plot(nanmean(FanoSave0(:,RangeX)),'c','LineWidth',2); hold on

xlim = get(gca,'xlim');  %Get x range
plot([xlim(1) xlim(2)],[1 1],'k')
ylim = get(gca,'ylim');  %Get x range
plot([500 500],[ylim(1) ylim(2)],'k')
plot([1500 1500],[ylim(1) ylim(2)],'k')
%plot([3000 3000],[ylim(1) ylim(2)],'k')
clear xlim
ylabel('Fano Factor')
axis([0 4000 0 2])

nsubplot(200,200,101:200, 1:99)
plot(nanmean(SDF25(:,RangeX)),'r','LineWidth',2); hold on
plot(nanmean(SDF50(:,RangeX)),'g','LineWidth',2); hold on
plot(nanmean(SDF75(:,RangeX)),'m','LineWidth',2); hold on
plot(nanmean(SDF100(:,RangeX)),'k','LineWidth',2); hold on
plot(nanmean(SDF0(:,RangeX)),'c','LineWidth',2); hold on

xlim = get(gca,'xlim');  %Get x range
plot([xlim(1) xlim(2)],[1 1],'k')
ylim = get(gca,'ylim');  %Get x range
plot([500 500],[ylim(1) ylim(2)],'k')
plot([1500 1500],[ylim(1) ylim(2)],'k')
%plot([3000 3000],[ylim(1) ylim(2)],'k')
clear xlim
ylabel('Firing rate')
axis([0 4000 0 50])
text(100,30,['n=' mat2str(size(SDF100,1))])

nsubplot(200,200,1:99, 151:200)
axis([0 6 0 4])
errorbar( 1, nanmean(nanmean(FanoSave0(:,RangeforearlyCS)')), nanstd(nanmean(FanoSave0(:,RangeforearlyCS)'))./sqrt(size(FanoSave0,1)) ,'k'); hold on
errorbar( 2, nanmean(nanmean(FanoSave25(:,RangeforearlyCS)')),nanstd(nanmean(FanoSave25(:,RangeforearlyCS)'))./sqrt(size(FanoSave25,1)) ,'k'); hold on
errorbar( 3, nanmean(nanmean(FanoSave50(:,RangeforearlyCS)')), nanstd(nanmean(FanoSave50(:,RangeforearlyCS)'))./sqrt(size(FanoSave50,1)) ,'k'); hold on
errorbar( 4, nanmean(nanmean(FanoSave75(:,RangeforearlyCS)')), nanstd(nanmean(FanoSave75(:,RangeforearlyCS)'))./sqrt(size(FanoSave75,1)) ,'k'); hold on
errorbar( 5, nanmean(nanmean(FanoSave100(:,RangeforearlyCS)')), nanstd(nanmean(FanoSave100(:,RangeforearlyCS)'))./sqrt(size(FanoSave100,1)) ,'k'); hold on

bar( 1, nanmean(nanmean(FanoSave0(:,RangeforearlyCS)')) );
bar( 2, nanmean(nanmean(FanoSave25(:,RangeforearlyCS)')) );
bar( 3, nanmean(nanmean(FanoSave50(:,RangeforearlyCS)')) );
bar( 4, nanmean(nanmean(FanoSave75(:,RangeforearlyCS)')) );
bar( 5, nanmean(nanmean(FanoSave100(:,RangeforearlyCS)')) );

xlim = get(gca,'xlim');  %Get x range
plot([xlim(1) xlim(2)],[1 1],'k')

clear t1 t2 t3 t4 t5
t1=(nanmean(FanoSave0(:,RangeforearlyCS)'))'; t1=t1(find(t1>0)); t1(:,2)=1
t2=(nanmean(FanoSave25(:,RangeforearlyCS)'))'; t2=t2(find(t2>0)); t2(:,2)=2
t3=(nanmean(FanoSave50(:,RangeforearlyCS)'))'; t3=t3(find(t3>0)); t3(:,2)=3
t4=(nanmean(FanoSave75(:,RangeforearlyCS)'))'; t4=t4(find(t4>0)); t4(:,2)=4
t5=(nanmean(FanoSave100(:,RangeforearlyCS)'))'; t5=t5(find(t5>0)); t5(:,2)=5
testT=[t1; t2; t3; t4; t5;]
p=kruskalwallis(testT(:,1),testT(:,2),'off')
text(1,3,mat2str(p))

total=[
nanmean(FanoSave100(:,RangeforearlyCS)')
nanmean(FanoSave75(:,RangeforearlyCS)')
nanmean(FanoSave50(:,RangeforearlyCS)')
nanmean(FanoSave25(:,RangeforearlyCS)')
nanmean(FanoSave0(:,RangeforearlyCS)')
]

nanmean(nanmean(total))
signrank( nanmean(total) , 1)


if doprint==1
    set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
    print('-dpdf', 'AllBGFANO.pdf' );
    close all;
end










