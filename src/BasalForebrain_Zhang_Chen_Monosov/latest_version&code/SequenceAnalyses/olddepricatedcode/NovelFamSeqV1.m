clear all; clc; close all; beep off;
GauSw=101;
addpath('HELPER_GENERAL');


% % addpath('C:\Users\Ilya\Desktop\Seq\');
% % D=dir ('C:\Users\Ilya\Desktop\Seq\S*.mat');
% 
% addpath('Y:\MONKEYDATA\Batman\SequenceLearning\neurons\');
% D=dir ('Y:\MONKEYDATA\Batman\SequenceLearning\neurons\S*.mat');
% 
% addpath('Y:\MONKEYDATA\Robin_ongoing\SequenceLearning\neurons\phasic\');
% D1=dir ('Y:\MONKEYDATA\Robin_ongoing\SequenceLearning\neurons\phasic\S*.mat');
% 
% addpath('Y:\MONKEYDATA\Robin_ongoing\OldSequenceLearning\neurons\');
% D2=dir ('Y:\MONKEYDATA\Robin_ongoing\OldSequenceLearning\neurons\S*.mat');
% 
% D=[D; D1; D2];
% 
% %
% % % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% SDFSS=[]; FamSS=[]; NovSS=[]; BEsave=[]; NoBEsave=[]; BEsave_Nov1=[]; noBEsave_Nov1=[]; BEsave_Nov3=[]; noBEsave_Nov3=[];
% ROCbe=[]; ROCbeP=[];
% SingleBE=[]; NovUseful=[]; NovNotUseful=[]; SetVersusSet2=[];
% 
% for x_file=1:length(D)
%     clear PDS
%     load(D(x_file).name,'PDS')
%     savestruct(x_file).name=D(x_file).name;
%     
%     
%     trials=find(PDS.Set(:,1)~=9999 & PDS.Set(:,2)~=9999 & PDS.timeoutcome'>0)
%     try
%         trials=intersect(find(PDS.timingerr==0),trials);
%     end
%     
%     try
%         NoBeliefErrors=intersect(trials,find(PDS.belieferror==0 & PDS.timeoutcome>0 & PDS.chosenwindow==0));
%         BeliefErrors=intersect(trials,find(PDS.belieferror==1 & PDS.timeoutcome>0 & PDS.chosenwindow==0));
%         BE=PDS.Set(:,1)-PDS.Set(:,3)
%         BEPos2=intersect(find(BE==99),BeliefErrors)
%         BEPos1=intersect(find(BE==-101),BeliefErrors)
%         if length(unique(PDS.WhichSet))>3 %exclude older versions with more than 1 sets from set compare
%             Set1Trials=[];
%             Set2Trials=[];
%             NoBeliefErrors=[];
%             BEPos2=[];
%             BEPos1=[];
%         else
%             Set1Trials=intersect(find(PDS.WhichSet==1),NoBeliefErrors)
%             Set2Trials=intersect(find(PDS.WhichSet==2),NoBeliefErrors)
%             
%         end
%         
%     catch
%         NoBeliefErrors=[];
%         BEPos2=[];
%         BEPos1=[];
%         Set1Trials=[];
%         Set2Trials=[];
%     end
%     
%     
%     
%     
%     
%     Rasters=[];
%     for x=1:length(PDS.timeoutcome)
%         CENTER=11001;
%         spk=PDS(1).sptimes{x}-PDS(1).timeoutcome(x);
%         spk=(spk*1000)+CENTER-1;
%         spk=fix(spk);
%         %
%         spk=spk(find(spk<CENTER*2));
%         %
%         temp(1:CENTER*2)=0;
%         temp(spk)=1;
%         Rasters=[Rasters; temp];
%         clear temp spk x
%     end
%     
%     Rasters=Rasters(:,11000-5000:11000);
%     SDFcs=plot_mean_psth({Rasters},GauSw,1,size(Rasters,2),1); close all;
%     AveragePreFirstF=nanmean(nanmean(SDFcs(trials,1000-100:1000)'))
%     SDFcs=SDFcs(:,1000:end);
%     
%     
%     FamS=[]; NovS=[];
%     if isempty(NoBeliefErrors)==0
%         t=NoBeliefErrors
%     else
%         t=trials
%     end
%     
%     for x=1:length(t)
%         x=t(x);
%         Fam=nanmean([SDFcs(x,2001:3000)
%             SDFcs(x,3001:4000)]);
%         Nov=SDFcs(x,1001:2000);
%         
%         Famb=nanmean([SDFcs(x,2000-100:2000)
%             SDFcs(x,3000-100:3000)]);
%         Novb=SDFcs(x,1000-100:1000);
%         FamS=[FamS; Fam-nanmean(Famb)];
%         NovS=[NovS; Nov-nanmean(Novb)];
%         clear Fam Nov x BE_
%     end
%     [savestruct(x_file).Nov_r,savestruct(x_file).Nov_p]=rocarea3(nanmean(FamS(:,200:400)')',nanmean(NovS(:,200:400)')')
%     
%     temp=min([nanmean(FamS)'; nanmean(NovS)'])
%     FamS=nanmean(FamS)-temp
%     NovS=nanmean(NovS)-temp
%     temp=max([(FamS)'; (NovS)'])
%     FamS=FamS./temp
%     NovS=NovS./temp
%     
%     savestruct(x_file).SDFcs= nanmean(SDFcs(t,:));
%     savestruct(x_file).FamSS=FamS;
%     savestruct(x_file).NovSS=NovS;
%     clear p temp FamS NovS
%     
%     
%     if isempty(Set1Trials)~=1
%         
%         t1=nanmean(SDFcs(Set2Trials,1001:2000))-nanmean(nanmean(SDFcs(Set2Trials,1000-100:1000)))
%         t2=nanmean(SDFcs(Set1Trials,1001:2000))-nanmean(nanmean(SDFcs(Set1Trials,1000-100:1000)))
%         t3=nanmean([SDFcs(Set2Trials,2001:3000)
%             SDFcs(Set2Trials,3001:4000)]) - nanmean(nanmean([SDFcs(Set2Trials,2000-100:2000)
%             SDFcs(Set2Trials,3000-100:3000)]))
%         t4=nanmean([SDFcs(Set1Trials,2001:3000)
%             SDFcs(Set1Trials,3001:4000)]) - nanmean(nanmean([SDFcs(Set1Trials,2000-100:2000)
%             SDFcs(Set1Trials,3000-100:3000)]))
%         
%         %normalization
%         t1=t1(1:500);
%         t2=t2(1:500);
%         t3=t3(1:500);
%         t4=t4(1:500);
%         
%         temp=min([t1'; t2'; t3'; t4';]);
%         t1=t1-temp;
%         t2=t2-temp;
%         t3=t3-temp;
%         t4=t4-temp;
%         
%         temp=max([t1'; t2'; t3'; t4';]);
%         t1=t1./temp;
%         t2=t2./temp;
%         t3=t3./temp;
%         t4=t4./temp;
%         
%         savestruct(x_file).NovUseful= t1;
%         savestruct(x_file).NovNotUseful= t2;
%         savestruct(x_file).NovUsefulFam=t3;
%         savestruct(x_file).NovNotUsefulFam=t4;   
%         clear t1 t2 t3 t4 temp
%     end
%     
%     
%     BEALL=[BEPos1; BEPos2];
%     if length(BEALL)>2 & length(BEPos1)>0 & length(BEPos2)>0
%         
%         B1=SDFcs(BEPos1,1:500)%-AveragePreFirstF;
%         B2=SDFcs(BEPos2,2001:2500)%-nanmean(nanmean(SDFcs(:,2000-100:2000)')); 
%         BEALLsdf=nanmean([B1; B2]);
%         
%         trialspos1=NoBeliefErrors(1:round((length(NoBeliefErrors)*length(BEPos1)./(length(BEPos2)+length(BEPos1)))))
%         trialspos2=NoBeliefErrors(1:round((length(NoBeliefErrors)*length(BEPos2)./(length(BEPos2)+length(BEPos1)))))
%         
%         B1=SDFcs(trialspos1,1:500)%-AveragePreFirstF;
%         B2=SDFcs(trialspos2,2001:2500)%-nanmean(nanmean(SDFcs(NoBeliefErrors,2000-100:2000)'));
%         NOBEALLsdf=nanmean([B1; B2]);
%         
%         %normalization
%         temp= [BEALLsdf;  NOBEALLsdf];
%         tempmin=min(temp(:));
%         BEALLsdf=BEALLsdf-tempmin;
%         NOBEALLsdf=NOBEALLsdf-tempmin;
%         temp= [BEALLsdf;  NOBEALLsdf];
%         tempmin=max(temp(:));
%         BEALLsdf=BEALLsdf./tempmin;
%         NOBEALLsdf=NOBEALLsdf./tempmin;
%         
%         
%         savestruct(x_file).BEALLsdf=BEALLsdf;
%         savestruct(x_file). NOBEALLsdf= NOBEALLsdf;
%     end
%     
%     
%     
%     
%     clear NOBEALL BEALL NoBeliefErrors t trials FamS NovS SDFcs Rasters
%     clear FamS NovS BEPos2 BEPos1 PDS Set1Trials Set2Trials
%     clear B1 B2 trialspos1 trialspos2 tempmin temp BEALLsdf NOBEALLsdf
%     close all; clc;
% end
% 
% save savedata.mat savestruct


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; clc; beep off;
addpath('HELPER_GENERAL');
load savedata.mat

doprint=0;

%latency=vertcat(savestruct(1,:).latency)
FamSS=vertcat(savestruct(1,:).FamSS)
NovSS=vertcat(savestruct(1,:).NovSS)
figure
nsubplot(150,150,1:100,1:100)
set(gca,'ticklength',4*get(gca,'ticklength'))
plt=NovSS; x=1:size(plt,2); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-r', 'LineWidth', 3}, 0); hold on
plt=FamSS; x=1:size(plt,2); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-k', 'LineWidth', 3}, 0); hold on
xlim([0 1000])
line([200 400],[1 1],'LineWidth',3, 'Color', 'r')
line([500 500], [0 25])
xlabel('Time from object onset (milliseconds)')
%
text(100,0.5,['n='   mat2str(size(FamSS,1))])
p=signrank(mean(FamSS(:,200:400)')',mean(NovSS(:,200:400)')')
text(100,0.7,['p='   mat2str(p)]);
title('object on for 500ms starting at 0ms')
%

SavePvalues=[];
for x=1:size(FamSS,2)
    SavePvalues=[SavePvalues; signrank(FamSS(:,x),NovSS(:,x))];
end
SavePvalues(find(SavePvalues<0.05))=9;
SavePvalues(find(SavePvalues~=9))=NaN;
SavePvalues(find(SavePvalues==9))=-0.1;
plot(SavePvalues,'LineWidth',3, 'Color', 'g')
SavePvalues=findseq(SavePvalues)
SavePvalues=SavePvalues(min(find(SavePvalues(:,1)==-0.1 & SavePvalues(:,4)>20)),2)
%line([SavePvalues SavePvalues], [0 .5])
text(100,0.9,['population latency='   mat2str(SavePvalues)]);
ylim([-0.1 1])
ylabel('Neuronal response')
p1=plot(NaN,'-r'); hold on
p3=plot(NaN,'-k'); hold on
legend([p1 p3],'Novel','Familiar')

nsubplot(150,150,51:100,111:150)
set(gca,'ticklength',4*get(gca,'ticklength'))
F=nanmean(FamSS(:,200:400)')'
N=nanmean(NovSS(:,200:400)')'
scatter(N,F, 30, 'k','filled');
axis([-0.1  1 -0.1  1])
line([0 round(max([F N])+10)], [0 round(max([F N])+10)])
axis square
ylabel('Response to familiar objects')
xlabel('Response to novel objects')


nsubplot(150,150,1:45,111:150);
set(gca,'ticklength',4*get(gca,'ticklength'))
ROC=vertcat(savestruct(1,:).Nov_r);
ROC(:,2)=1
JitterVar=0.2; %jitter for scatter plot
scatter(mean(ROC(:,2)),mean(ROC(:,1)),120,'r','filled'); hold on;
scatter(ROC(:,2),ROC(:,1),20,'k','filled','jitter','on', 'jitterAmount',JitterVar); hold on;
ylabel('Novelty discrimination (AUC)')
line([0 2], [0.5 0.5])

if doprint==1
    set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
    print('-dpdf', 'NoveltyResponse' );
    close all;
end


figure
NovUseful=vertcat(savestruct(1,:).NovUseful);
NovNotUseful=vertcat(savestruct(1,:).NovNotUseful);
NovUsefulFam=vertcat(savestruct(1,:).NovUsefulFam);
NovNotUsefulFam=vertcat(savestruct(1,:).NovNotUsefulFam);
nsubplot(150,150,1:40,1:40)
plt=NovNotUseful; x=1:size(plt,2); v=sqrt(size(plt,1)); shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'--r', 'LineWidth', 2}, 0); hold on
plt=NovUseful; x=1:size(plt,2); v=sqrt(size(plt,1)); shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-r', 'LineWidth', 0.5}, 0); hold on
xlim([0 500])
line([200 400],[1 1],'LineWidth',3, 'Color', 'r')
set(gca,'ticklength',4*get(gca,'ticklength'))
xlabel('Time from object onset (milliseconds)')
text(100,0.7,['n='   mat2str(size(NovNotUseful,1))])
p=signrank(mean(NovUseful(:,200:400)')',mean(NovNotUseful(:,200:400)')')
text(100,0.1,['p='   mat2str(p)]);
ylim([0 1])
ylabel('Neuronal response')
%

nsubplot(150,150,1:40,51:90)
plt=NovNotUsefulFam; x=1:size(plt,2); v=sqrt(size(plt,1)); shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'--k', 'LineWidth', 2}, 0); hold on
plt=NovUsefulFam; x=1:size(plt,2); v=sqrt(size(plt,1)); shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-k', 'LineWidth', 0.5}, 0); hold on
xlim([0 500])
line([200 400],[1 1],'LineWidth',3, 'Color', 'r')
set(gca,'ticklength',4*get(gca,'ticklength'))
xlabel('Time from object onset (milliseconds)')
text(100,0.7,['n='   mat2str(size(NovNotUsefulFam,1))])
p=signrank(mean(NovUsefulFam(:,200:400)')',mean(NovNotUsefulFam(:,200:400)')')
text(100,0.1,['p='   mat2str(p)]);
ylim([0 1])

p1=plot(NaN,'-r'); hold on
p2=plot(NaN,'--r'); hold on
p3=plot(NaN,'-k'); hold on
p4=plot(NaN,'--k'); hold on
legend([p1 p2 p3 p4],'Novel-relevant','Novel-irrelevant', 'Familiar-relevant', 'Familiar-irrelevant')



%
nsubplot(150,150,51:100,111:150)
F=nanmean(NovNotUseful(:,200:400)')'
N=nanmean(NovUseful(:,200:400)')'
scatter(N,F, 60, 'k', 'filled');
axis([0  1 0  1])
line([0 round(max([F N])+10)], [0 round(max([F N])+10)])
axis square
xlabel({'Novel object related response','from memory relevant sequence'})
ylabel({'Novel object related response','from memory irrelevant sequence'})


nsubplot(150,150,101:150,111:150)
F=nanmean(NovNotUsefulFam(:,200:400)')'
N=nanmean(NovUsefulFam(:,200:400)')'
scatter(N,F, 60, 'k', 'filled');
axis([0  1 0  1])
line([0 round(max([F N])+10)], [0 round(max([F N])+10)])
axis square
xlabel({'Familiar object related response','from memory relevant sequence'})
ylabel({'Familiar object related response','from memory irrelevant sequence'})

if doprint==1
    set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
    print('-dpdf', 'Memoryactivity' );
    close all;
end




figure
nobeall=vertcat(savestruct(1,:).NOBEALLsdf)
beall=vertcat(savestruct(1,:).BEALLsdf)
plot(nanmean(beall))
hold on
plot(nanmean(nobeall),'g')
WindA=[100:500]
[p]=signrank(nanmean(nobeall(:,WindA)')', nanmean(beall(:,WindA)')')
text( 100,0.5,['p=' mat2str(p) ] )
title('fractal switch')
