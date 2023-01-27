clear all; clc; close all; beep off;

GauSw=101;
addpath('HELPER_GENERAL');




% addpath('C:\Users\Ilya\Desktop\Seq\');
% D=dir ('C:\Users\Ilya\Desktop\Seq\S*.mat');
% % 
% 
addpath('Y:\MONKEYDATA\Batman\SequenceLearning\neurons\');
D=dir ('Y:\MONKEYDATA\Batman\SequenceLearning\neurons\S*.mat');

addpath('Y:\MONKEYDATA\Robin_ongoing\SequenceLearning\neurons\phasic\');
D1=dir ('Y:\MONKEYDATA\Robin_ongoing\SequenceLearning\neurons\phasic\S*.mat');

addpath('Y:\MONKEYDATA\Robin_ongoing\OldSequenceLearning\neurons\');
D2=dir ('Y:\MONKEYDATA\Robin_ongoing\OldSequenceLearning\neurons\S*.mat');

D=[D; D1; D2];
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


SDFSS=[]; FamSS=[]; NovSS=[]; BEsave=[]; NoBEsave=[]; BEsave_Nov1=[]; noBEsave_Nov1=[]; BEsave_Nov3=[]; noBEsave_Nov3=[];
ROCbe=[]; ROCbeP=[];
SingleBE=[]; NovUseful=[]; NovNotUseful=[]; SetVersusSet2=[];

for x_file=1:length(D)
    clear PDS
    load(D(x_file).name,'PDS')
    savestruct(x_file).name=D(x_file).name;
    
    
    trials=find(PDS.Set(:,1)~=9999 & PDS.Set(:,2)~=9999 & PDS.timeoutcome'>0)
    try
        trials=intersect(find(PDS.timingerr==0),trials);
    end
    
    try
        NoBeliefErrors=intersect(trials,find(PDS.belieferror==0 & PDS.timeoutcome>0 & PDS.chosenwindow==0));
        BeliefErrors=intersect(trials,find(PDS.belieferror==1 & PDS.timeoutcome>0 & PDS.chosenwindow==0));
        BE=PDS.Set(:,1)-PDS.Set(:,3)
        BEPos2=intersect(find(BE==99),BeliefErrors)
        BEPos1=intersect(find(BE==-101),BeliefErrors)
        Set1Trials=intersect(find(PDS.WhichSet==1),NoBeliefErrors)
        Set2Trials=intersect(find(PDS.WhichSet==2),NoBeliefErrors)

    catch
        NoBeliefErrors=[];
        BEPos2=[];
        BEPos1=[];
        Set1Trials=[];
        Set2Trials=[];
    end
    
 
    
    
    
    Rasters=[];
    for x=1:length(PDS.timeoutcome)
        CENTER=11001;
        spk=PDS(1).sptimes{x}-PDS(1).timeoutcome(x);
        spk=(spk*1000)+CENTER-1;
        spk=fix(spk);
        %
        spk=spk(find(spk<CENTER*2));
        %
        temp(1:CENTER*2)=0;
        temp(spk)=1;
        Rasters=[Rasters; temp];
        clear temp spk x
    end

    Rasters=Rasters(:,11000-5000:11000);
    SDFcs=plot_mean_psth({Rasters},GauSw,1,size(Rasters,2),1); close all;
    SDFcs=SDFcs(:,1000:end);


    FamS=[]; NovS=[];
    if isempty(NoBeliefErrors)==0
        t=NoBeliefErrors
    else
        t=trials
    end
    
    SDFTEMP=nanmean(SDFcs(t,:));
        SDFcs=SDFcs-min(SDFTEMP(:));
    SDFcs=SDFcs./max(SDFTEMP(:));
    
    
    
    for x=1:length(t)
        x=t(x);
        %Fam=nanmean([SDFcs(x,1:500)
        %    SDFcs(x,2001:2500)
        %    SDFcs(x,3001:3500)]);
          Fam=nanmean([SDFcs(x,2001:3000)
            SDFcs(x,3001:4000)]);
        Nov=SDFcs(x,1001:2000);
        FamS=[FamS; Fam];
        NovS=[NovS; Nov];
        clear Fam Nov x BE_
    end
    savestruct(x_file).SDFcs= nanmean(SDFcs(t,:));
    savestruct(x_file).FamSS=nanmean(FamS(:,:));
    savestruct(x_file).NovSS=nanmean(NovS(:,:));
    [savestruct(x_file).Nov_r,savestruct(x_file).Nov_p]=rocarea3(nanmean(FamS(:,:)')',nanmean(NovS(:,:)')')
    %
    [r,p]=rocarea3(FamS,NovS);
    p(find(p<0.05))=9;
    p(find(p~=9))=0;
    p=findseq(p);
    try
        savestruct(x_file).latency=p(min(find(p(:,1)==9 & p(:,4)>20)),2);
    catch
        %savestruct(x_file).latency=NaN;
    end
    clear p
    %
    SDFSS=[SDFSS; nanmean(SDFcs(t,:))]; clear t
    FamSS=[FamSS; nanmean(FamS(:,:))]; 
    NovSS=[NovSS; nanmean(NovS(:,:))];
    %
    if isempty(Set1Trials)~=1
        NovUseful=[NovUseful; nanmean(SDFcs(Set2Trials,:))]; %1001:1500
        NovNotUseful=[NovNotUseful; nanmean(SDFcs(Set1Trials,:))];
        SetVersusSet2=[SetVersusSet2; rocarea3(SDFcs(Set1Trials,:),SDFcs(Set2Trials,:)) ];
        
        savestruct(x_file).NovUseful= nanmean(SDFcs(Set2Trials,1001:2000));
        savestruct(x_file).NovNotUseful= nanmean(SDFcs(Set1Trials,1001:2000));
        
        savestruct(x_file).NovUsefulFam=nanmean([SDFcs(Set2Trials,2001:3000)
            SDFcs(Set2Trials,3001:4000)]);
        
        savestruct(x_file).NovNotUsefulFam=nanmean([SDFcs(Set1Trials,2001:3000)
            SDFcs(Set1Trials,3001:4000)]);
    end
   
    
    B1=SDFcs(BEPos1,1:500);
    B2=SDFcs(BEPos2,2001:2500);
    if size(B1,1)>0 | size(B2,1)>0
        BEALL=[B1; B2];
    else
        BEALL=NaN;
    end
    clear B1 B2
    
    
    
    try
        
        
        
    ConversionFactor=round(length(trials)./length([BEPos1; BEPos2]));
    numtrialspos1=length(BEPos1)*ConversionFactor;
    numtrialspos2=length(BEPos2)*ConversionFactor;
    trials=trials(randperm(length(trials)));
    trialspos1=trials(1:numtrialspos1)
    trials=trials(randperm(length(trials)));
    trialspos2=trials(1:numtrialspos2)
    trialspos1=trials(1:round((length(trials)*length(BEPos1)./(length(BEPos2)+length(BEPos1)))))
    trialspos2=trials(1:round((length(trials)*length(BEPos2)./(length(BEPos2)+length(BEPos1)))))
    
    
 
    
    B1=SDFcs(trialspos1,1:500);
    B2=SDFcs(trialspos2,2001:2500);
  %  B1=SDFcs(trials,1:500);
  %  B2=SDFcs(trials,2001:2500);
    
    NOBEALL=[B1; B2];
    clear B1 B2 trialspos1 trialspos2 ConversionFactor

      
      if size(BEALL,1)>2
          BEsave=[BEsave; nanmean(BEALL)];
          NoBEsave=[NoBEsave; nanmean(NOBEALL)];
          
          RangeEarly=[100:400]
          [r,P]=rocarea3(nanmean(NOBEALL(:,RangeEarly)')',nanmean(BEALL(:,RangeEarly)')')
          
          tempT=[ nanmean(nanmean(NOBEALL(:,RangeEarly)')') nanmean(nanmean(BEALL(:,RangeEarly)')')]; tempT=tempT./max(tempT)
          
          if isempty(find(tempT==0))~=1
             warning on; 
          end
          
          SingleBE=[SingleBE; [r P tempT]]
          
          [r,P]=(rocarea3(NOBEALL,BEALL))
          ROCbe=[ROCbe; r];
          ROCbeP=[ROCbeP; (P)]; clear r P
          
          if size(BEPos1,1)>2
              BEsave_Nov1=[BEsave_Nov1; nanmean([SDFcs(BEPos1,:)])];
              noBEsave_Nov1=[noBEsave_Nov1; nanmean(SDFcs(trials,:))];
          end
          if size(BEPos2,1)>2
              BEsave_Nov3=[BEsave_Nov3; nanmean([SDFcs(BEPos2,:)])];
              noBEsave_Nov3=[noBEsave_Nov3; nanmean(SDFcs(trials,:))];
          end
          
          figure
          plot(mean(BEALL),'k')
          hold on
          plot(mean(NOBEALL))
          close all;
       
      end

    
    end

    %
    %     AllBE=[BEPos2; BEPos1];
    %     for x=1:length(AllBE)
    %
    %         t=AllBE(x);
    %
    %
%         Fam=nanmean([SDFcs(x,1:500)
%             SDFcs(x,2001:2500)
%             SDFcs(x,3001:3500)]);
%         
%         BE_=nanmean([SDFcs(x,1:500)
%             SDFcs(x,2001:2500)]);
%         
%         Nov=SDFcs(x,1001:1500);
%         
%         BES=[BES; BE_];
%         FamS=[FamS; Fam];
%         NovS=[NovS; Nov];
%         clear Fam Nov x BE_
%     end

        
    

 
    clear NOBEALL BEALL NoBeliefErrors t trials FamS NovS SDFcs Rasters
    clear FamS NovS BEPos2 BEPos1 PDS Set1Trials Set2Trials
    close all; clc;
end

save savedata.mat savestruct


addpath('HELPER_GENERAL');
load savedata.mat

%latency=vertcat(savestruct(1,:).latency)
FamSS=vertcat(savestruct(1,:).FamSS)
NovSS=vertcat(savestruct(1,:).NovSS)
figure
nsubplot(150,150,1:100,1:100)
plt=FamSS; x=1:size(plt,2); v=sqrt(size(plt,1)); shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-k', 'LineWidth', 3}, 0); hold on
plt=NovSS; x=1:size(plt,2); v=sqrt(size(plt,1)); shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-r', 'LineWidth', 3}, 0); hold on
xlim([0 1000])
line([100 400],[1 1],'LineWidth',3, 'Color', 'r')
line([500 500], [0 25])
set(gca,'ticklength',4*get(gca,'ticklength'))
xlabel('Time from object onset (milliseconds)')
%
text(100,0.5,['n='   mat2str(size(FamSS,1))])
p=signrank(mean(FamSS(:,100:400)')',mean(NovSS(:,100:400)')')
text(100,0.7,['p='   mat2str(p)]);
%

SavePvalues=[];
for x=1:size(FamSS,2)
    SavePvalues=[SavePvalues; signrank(FamSS(:,x),NovSS(:,x))];
end
SavePvalues(find(SavePvalues<0.05))=9;
SavePvalues(find(SavePvalues~=9))=NaN;
SavePvalues(find(SavePvalues==9))=0.01;
plot(SavePvalues,'LineWidth',3, 'Color', 'g')
SavePvalues=findseq(SavePvalues)
SavePvalues=SavePvalues(min(find(SavePvalues(:,1)==0.01 & SavePvalues(:,4)>20)),2)
line([SavePvalues SavePvalues], [0 .5])
text(100,0.9,['population latency='   mat2str(SavePvalues)]);
ylim([0 1])

%
nsubplot(150,150,51:100,111:150)
F=nanmean(FamSS(:,100:400)')'
N=nanmean(NovSS(:,100:400)')'
scatter(N,F, 60, 'k', 'filled');
axis([0  1 0  1])
line([0 round(max([F N])+10)], [0 round(max([F N])+10)])
axis square


figure
NovUseful=vertcat(savestruct(1,:).NovUseful);
NovNotUseful=vertcat(savestruct(1,:).NovNotUseful);
NovUsefulFam=vertcat(savestruct(1,:).NovUsefulFam);
NovNotUsefulFam=vertcat(savestruct(1,:).NovNotUsefulFam);
nsubplot(150,150,1:40,1:40)
plt=NovNotUseful; x=1:size(plt,2); v=sqrt(size(plt,1)); shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'--r', 'LineWidth', 2}, 0); hold on
plt=NovUseful; x=1:size(plt,2); v=sqrt(size(plt,1)); shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-r', 'LineWidth', 0.5}, 0); hold on
xlim([0 1000])
line([100 400],[1 1],'LineWidth',3, 'Color', 'r')
line([500 500], [0 25])
set(gca,'ticklength',4*get(gca,'ticklength'))
xlabel('Time from object onset (milliseconds)')
text(100,0.7,['n='   mat2str(size(NovNotUseful,1))])
p=signrank(mean(NovUseful(:,100:400)')',mean(NovNotUseful(:,100:400)')')
text(100,0.5,['p='   mat2str(p)]);
ylim([0 1])
%

nsubplot(150,150,1:40,51:90)
plt=NovNotUsefulFam; x=1:size(plt,2); v=sqrt(size(plt,1)); shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'--k', 'LineWidth', 2}, 0); hold on
plt=NovUsefulFam; x=1:size(plt,2); v=sqrt(size(plt,1)); shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-k', 'LineWidth', 0.5}, 0); hold on
xlim([0 1000])
line([100 400],[1 1],'LineWidth',3, 'Color', 'r')
line([500 500], [0 25])
set(gca,'ticklength',4*get(gca,'ticklength'))
xlabel('Time from object onset (milliseconds)')
text(100,0.7,['n='   mat2str(size(NovNotUsefulFam,1))])
p=signrank(mean(NovUsefulFam(:,100:400)')',mean(NovNotUsefulFam(:,100:400)')')
text(100,0.5,['p='   mat2str(p)]);
ylim([0 1])
%
nsubplot(150,150,51:100,111:150)
F=nanmean(NovNotUseful(:,100:400)')'
N=nanmean(NovUseful(:,100:400)')'
scatter(N,F, 60, 'k', 'filled');
axis([0  1 0  1])
line([0 round(max([F N])+10)], [0 round(max([F N])+10)])
axis square


nsubplot(150,150,51:100,111:150)  
F=nanmean(NovNotUseful(:,100:400)')'
N=nanmean(NovUseful(:,100:400)')'
scatter(N,F, 60, 'k', 'filled');
axis([0  1 0  1])
line([0 round(max([F N])+10)], [0 round(max([F N])+10)])
axis square

nsubplot(150,150,101:150,111:150)
F=nanmean(NovNotUsefulFam(:,100:400)')'
N=nanmean(NovUsefulFam(:,100:400)')'
scatter(N,F, 60, 'k', 'filled');
axis([0  1 0  1])
line([0 round(max([F N])+10)], [0 round(max([F N])+10)])
axis square



sdaf



fd
    savestruct(x_file).SDFcs= nanmean(SDFcs(t,:));
    savestruct(x_file).FamSS=nanmean(FamS(:,:));
    savestruct(x_file).NovSS=nanmean(NovS(:,:));
    [savestruct(x_file).Nov_r,savestruct(x_file).Nov_p]=rocarea3(nanmean(FamS(:,:)')',nanmean(NovS(:,:)')')


figure
plot(nanmean(NovNotUseful),'g','LineWidth',1); hold on
hold on
plot(nanmean(NovUseful),'r','LineWidth',1);
ylim([0 25])
xlim([0 500])
%line([1 500],[1 1],'LineWidth',3, 'Color', 'r')
xlabel('Novel Versus Familiar')
set(gca,'ticklength',4*get(gca,'ticklength'))
text(100,2,['n='   mat2str(size(FamSS,1))])
p=signrank(mean(FamSS(:,100:end)')',mean(NovSS(:,100:end)')')
text(100,20,['p='   mat2str(p)]);



close all;

figure
nsubplot(150,150,1:100,1:100)
plot(nanmean(SDFSS),'k','LineWidth',1); hold on
h=area(nanmean(SDFSS)); hold on
h.FaceColor = 'black';
ylim([0 25])
xlim([0 4000])
line([0 500],[0.25 0.25],'LineWidth',2, 'Color', 'g')
line([1000 1500],[0.25 0.25],'LineWidth',2, 'Color', 'r')
line([2000 2500],[0.25 0.25],'LineWidth',2, 'Color', 'g')
line([3000 3500],[0.25 0.25],'LineWidth',2, 'Color', 'g')
line([1001 1001],[1 20],'LineWidth',1, 'Color', 'k')
line([2001 2001],[1 20],'LineWidth',1, 'Color', 'k')
line([3001 3001],[1 20],'LineWidth',1, 'Color', 'k')
xlabel('Sequence response')
set(gca,'ticklength',4*get(gca,'ticklength'))
text(500,25,['n='   mat2str(size(SDFSS,1))])

nsubplot(150,150,111:150,1:100)
plot(nanmean(FamSS),'g','LineWidth',1); hold on
hold on
plot(nanmean(NovSS),'r','LineWidth',1);
ylim([0 25])
xlim([0 500])
%line([1 500],[1 1],'LineWidth',3, 'Color', 'r')
xlabel('Novel Versus Familiar')
set(gca,'ticklength',4*get(gca,'ticklength'))
text(100,2,['n='   mat2str(size(FamSS,1))])
p=signrank(mean(FamSS(:,100:end)')',mean(NovSS(:,100:end)')')
text(100,20,['p='   mat2str(p)]);


disp('hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh')
WindA=[100:250]
[p]=signrank(nanmean(NoBEsave(:,WindA)'), nanmean(BEsave(:,WindA)'))
figure 
subplot(3,1,1)
plot(nanmean(NoBEsave),'k','LineWidth',2); hold on
  plot(nanmean(BEsave),'r','LineWidth',2)
  line([100 400], [0.5 0.5],'LineWidth',5)
  text(10,10,mat2str(p))
  text(10,15,['n=' mat2str(size(ROCbeP,1))])
  
ylim([0 25])
title('Coding of "Belief State Errors" during object sequences')
subplot(3,1,2)
plot(nanmean(ROCbe),'k','LineWidth',2)
ylabel('Discrimination Index (AUC / classification)')
ylim([0.45 .7])
line([0 500], [0.5 0.5],'LineWidth',1)
%%%
ROCbeP_=ROCbeP;
ROCbeP(find(ROCbeP>0.049999999999999999))=9;
ROCbeP(find(ROCbeP~=9))=1;
ROCbeP(find(ROCbeP==9))=0;
PropPlot=sum(ROCbeP)./(size(ROCbeP,1))
subplot(3,1,3)
plot(PropPlot,'k','LineWidth',2)
ylabel('Proportion')
ylim([0 .7])
line([0 500], [0.05 0.05],'LineWidth',1)

disp('vvvvv')

signrank(SingleBE(:,1),0.5)

signrank(SingleBE(:,3),SingleBE(:,4))



sdf

figure; plot(nanmean(BEsave_Nov3))
hold on
plot(nanmean(noBEsave_Nov3),'r')

figure; plot(nanmean(BEsave_Nov1))
hold on
plot(nanmean(noBEsave_Nov1),'r')














