clc; clear all; beep off;
addpath('X:\Kaining\HELPER_GENERAL')
addpath('C:\Users\Ilya Monosov\Dropbox\HELPER\HELPER_GENERAL')

doprint=1;

RangeforearlyCS=[3051-500:3051];


    load Data15.mat
    temp = ProbAmtDataStruct;
    
    for x=1:length(temp)
        temp(x).idstruct=1;
    end
    
    load Data25_V2.mat
    for x=1:length(ProbAmtDataStruct)
        ProbAmtDataStruct(x).idstruct=2;
    end
    
    ProbAmtDataStruct = [ProbAmtDataStruct temp];

    %%%%%%% cluster phasic and ramping cell
    Vectors=[];
    for x=1:length(ProbAmtDataStruct)
        t=ProbAmtDataStruct(x).Prob_(1001:end);
        t=t-min(t);
        t=t./max(t);
        Vectors=[Vectors; (t)];
    end
    clear t;
    G=Vectors;
    %[pc, zscores, pcvars] = pca(G,'VariableWeights','variance');
    [pc, zscores, pcvars] = pca(G);
    %VarE_=pcvars./sum(pcvars) * 100 %var exp
    %VarE=cumsum(pcvars./sum(pcvars) * 100); %cum sum of variance
    
    meas=zscores(:,[1:10])
    %rng('default');  % For reproducibility
    eva = evalclusters(meas,'kmeans','CalinskiHarabasz','KList',[1:6])
    eva = evalclusters(meas,'kmeans','silhouette','KList',[1:6])
    idx3 = kmeans(meas,2,'Distance','sqeuclidean');
    
    T1=G(find(idx3==1),:);
    T2=G(find(idx3==2),:);
    
    figure;
    NUM=2;
    D = pdist(T1, 'euclidean');
    T = linkage(D, 'ward');
    [H,T,outperm] = dendrogram(T, 0, 'colorthreshold',mean(T(end-NUM+1:end-NUM+2,3)),'Orientation','left');
    T1=T1(outperm,:); clear T D H outperm;
    
    D = pdist(T2, 'euclidean');
    T = linkage(D, 'ward');
    [H,T,outperm] = dendrogram(T, 0, 'colorthreshold',mean(T(end-NUM+1:end-NUM+2,3)),'Orientation','left');
    T2=T2(outperm,:); clear T D H outperm;
    close(gcf);
    
    G=[T1; T2];
    
    Group1=ProbAmtDataStruct(find(idx3==1)); %phasic
    Group2=ProbAmtDataStruct(find(idx3==2)); %Ramping
    
    if length(Group2)>length(Group1)
        savestruct = Group2;
    else
        savestruct = Group1;
    end
    
savestructS=savestruct(find([savestruct(:).idstruct]==1))
savestructL=savestruct(find([savestruct(:).idstruct]==2))



FanoSaveAll=vertcat(savestructS(1,:). FanoSaveAll);
t(1:size(FanoSaveAll,1),1:50)=NaN;
FanoSave75=[t vertcat(savestructS(1,:). FanoSave75)];
FanoSave50=[t vertcat(savestructS(1,:). FanoSave50)];
FanoSave25=[t vertcat(savestructS(1,:). FanoSave25)];
FanoSave0=[t vertcat(savestructS(1,:). FanoSave0)];
FanoSave100=[t vertcat(savestructS(1,:). FanoSave100)]; clear t
SDF100=vertcat(savestructS(1,:). SDF100);
SDF75=vertcat(savestructS(1,:). SDF75);
SDF50=vertcat(savestructS(1,:). SDF50);
SDF25=vertcat(savestructS(1,:). SDF25);
SDF0=vertcat(savestructS(1,:). SDF0);

sFanoSave100=FanoSave100(:,1:1500+750);
sFanoSave75=FanoSave75(:,1:1500+750);
sFanoSave50=FanoSave50(:,1:1500+750);
sFanoSave25=FanoSave25(:,1:1500+750);
sFanoSave0=FanoSave0(:,1:1500+750);
sSDF100=SDF100(:,1:1500+750);
sSDF75=SDF75(:,1:1500+750);
sSDF50=SDF50(:,1:1500+750);
sSDF25=SDF25(:,1:1500+750);
sSDF0=SDF0(:,1:1500+750);

lFanoSave100=FanoSave100(:,2251:2251+700);
lFanoSave75=FanoSave75(:,2251:2251+700);
lFanoSave50=FanoSave50(:,2251:2251+700);
lFanoSave25=FanoSave25(:,2251:2251+700);
lFanoSave0=FanoSave0(:,2251:2251+700);
lSDF100=SDF100(:,2251:2251+750);
lSDF75=SDF75(:,2251:2251+750);
lSDF50=SDF50(:,2251:2251+750);
lSDF25=SDF25(:,2251:2251+750);
lSDF0=SDF0(:,2251:2251+750);



FanoSaveAll=vertcat(savestructL(1,:). FanoSaveAll);
t(1:size(FanoSaveAll,1),1:50)=NaN;

FanoSave75=[t vertcat(savestructL(1,:). FanoSave75)];
FanoSave50=[t vertcat(savestructL(1,:). FanoSave50)];
FanoSave25=[t vertcat(savestructL(1,:). FanoSave25)];
FanoSave0=[t vertcat(savestructL(1,:). FanoSave0)];
FanoSave100=[t vertcat(savestructL(1,:). FanoSave100)];  clear t
SDF100=vertcat(savestructL(1,:). SDF100);
SDF75=vertcat(savestructL(1,:). SDF75);
SDF50=vertcat(savestructL(1,:). SDF50);
SDF25=vertcat(savestructL(1,:). SDF25);
SDF0=vertcat(savestructL(1,:). SDF0);


slFanoSave100=FanoSave100(:,1:1500+750);
slFanoSave75=FanoSave75(:,1:1500+750);
slFanoSave50=FanoSave50(:,1:1500+750);
slFanoSave25=FanoSave25(:,1:1500+750);
slFanoSave0=FanoSave0(:,1:1500+750);
slSDF100=SDF100(:,1:1500+750);
slSDF75=SDF75(:,1:1500+750);
slSDF50=SDF50(:,1:1500+750);
slSDF25=SDF25(:,1:1500+750);
slSDF0=SDF0(:,1:1500+750);

llFanoSave100=FanoSave100(:,3251:3251+700);
llFanoSave75=FanoSave75(:,3251:3251+700);
llFanoSave50=FanoSave50(:,3251:3251+700);
llFanoSave25=FanoSave25(:,3251:3251+700);
llFanoSave0=FanoSave0(:,3251:3251+700);
llSDF100=SDF100(:,3251:3251+750);
llSDF75=SDF75(:,3251:3251+750);
llSDF50=SDF50(:,3251:3251+750);
llSDF25=SDF25(:,3251:3251+750);
llSDF0=SDF0(:,3251:3251+750);

%%%%%%
FanoSave100=[sFanoSave100; slFanoSave100];
FanoSave75=[sFanoSave75; slFanoSave75];
FanoSave50=[sFanoSave50; slFanoSave50];
FanoSave25=[sFanoSave25; slFanoSave25];
FanoSave0=[sFanoSave0; slFanoSave0];

FanoSave100e=[lFanoSave100; llFanoSave100];
FanoSave75e=[lFanoSave75; llFanoSave75];
FanoSave50e=[lFanoSave50; llFanoSave50];
FanoSave25e=[lFanoSave25; llFanoSave25];
FanoSave0e=[lFanoSave0; llFanoSave0];

t(1:size(FanoSave100,1),1:100)=NaN;
FanoSave100=[FanoSave100'; t'; FanoSave100e';]';
FanoSave75=[FanoSave75'; t'; FanoSave75e';]';
FanoSave50=[FanoSave50'; t'; FanoSave50e';]';
FanoSave25=[FanoSave25'; t'; FanoSave25e';]';
FanoSave0=[FanoSave0'; t'; FanoSave0e';]'; 
clear t
%%%%

SDF100=[sSDF100; slSDF100];
SDF75=[sSDF75; slSDF75];
SDF50=[sSDF50; slSDF50];
SDF25=[sSDF25; slSDF25];
SDF0=[sSDF0; slSDF0];

SDF100e=[lSDF100; llSDF100];
SDF75e=[lSDF75; llSDF75];
SDF50e=[lSDF50; llSDF50];
SDF25e=[lSDF25; llSDF25];
SDF0e=[lSDF0; llSDF0];

t(1:size(SDF100,1),1:100)=NaN;
SDF100=[SDF100'; t'; SDF100e';]';
SDF75=[SDF75'; t'; SDF75e';]';
SDF50=[SDF50'; t'; SDF50e';]';
SDF25=[SDF25'; t'; SDF25e';]';
SDF0=[SDF0'; t'; SDF0e';]'; 
clear t







RangeX=[1:3051];
figure; hold on;
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
axis([0 3000 0 2])

figure; hold on;
RangeX=[1:3051+50];
plot(nanmean(SDF25(:,RangeX)),'g','LineWidth',2); hold on
plot(nanmean(SDF50(:,RangeX)),'r','LineWidth',2); hold on
plot(nanmean(SDF75(:,RangeX)),'m','LineWidth',2); hold on
plot(nanmean(SDF100(:,RangeX)),'k','LineWidth',2); hold on
plot(nanmean(SDF0(:,RangeX)),'c','LineWidth',2); hold on

xlim = get(gca,'xlim');  %Get x range
plot([xlim(1) xlim(2)],[1 1],'k')
ylim = get(gca,'ylim');  %Get x range
vline([500 1500],'k')
% plot([500 500],[ylim(1) ylim(2)],'k')
% plot([1500 1500],[ylim(1) ylim(2)],'k')
%plot([3000 3000],[ylim(1) ylim(2)],'k')
clear xlim
ylabel('Firing rate')

text(100,30,['n=' mat2str(size(SDF100,1))])

axis([0 3000 0 60])
legend('25','50','75','100','0','Event')


figure; hold on;
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
testT=[t2; t3; t4; t5;]
test_0 = t1;
p=kruskalwallis(testT(:,1),testT(:,2),'off')
text(1,3,['ANOVA p = ' mat2str(p)]);
p=ranksum(testT(:,1),test_0(:,1))
text(1,3.5,['ranksum p = ' mat2str(p,2)]);


total=[
nanmean(FanoSave100(:,RangeforearlyCS)')
nanmean(FanoSave75(:,RangeforearlyCS)')
nanmean(FanoSave50(:,RangeforearlyCS)')
nanmean(FanoSave25(:,RangeforearlyCS)')
nanmean(FanoSave0(:,RangeforearlyCS)')
]

nanmean(nanmean(total))
% 
% if doprint==1
%     set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
%     print('-dpdf', 'AllBFFANO.pdf' );
%     close all;
% end
% 


signrank( nanmean(total) , 1)








