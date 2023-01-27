close all; clc; beep off;
addpath('HELPER_GENERAL');

%add analyses that shows 1st fractal diffs or no diffs comparing seq 1 and
%seq2

load savedata.mat
%load savedata_TONIC.mat

doprint=9;

%latency=vertcat(savestruct(1,:).latency)
FamSS=vertcat(savestruct(1,:).FamSS)
NovSS=vertcat(savestruct(1,:).NovSS)
figure
nsubplot(450,450,1:100,1:100)
set(gca,'ticklength',4*get(gca,'ticklength'))
plt=NovSS; x=1:size(plt,2); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-r', 'LineWidth', 3}, 0); hold on
plt=FamSS; x=1:size(plt,2); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-k', 'LineWidth', 3}, 0); hold on
xlim([0 1000])
line([200 400],[1 1],'LineWidth',3, 'Color', 'r')
line([500 500], [0 25])
t=xlabel('Time from object onset (milliseconds)'); set(t, 'FontSize', 8);
%
t=text(100,0.5,['n='   mat2str(size(FamSS,1))]); set(t, 'FontSize', 8);


p=signrank(mean(FamSS(:,200:400)')',mean(NovSS(:,200:400)')')
t=text(100,0.7,['p='   mat2str(p)]); set(t, 'FontSize', 8);
t=title('object on for 500ms starting at 0ms'); set(t, 'FontSize', 8);
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
t=text(100,0.9,['population latency='   mat2str(SavePvalues)]); set(t, 'FontSize', 8);
ylim([-0.1 1])
t=ylabel('Normalized response'); set(t, 'FontSize', 8);
p1=plot(NaN,'-r'); hold on
p3=plot(NaN,'-k'); hold on
legend([p1 p3],'Novel','Familiar')

nsubplot(450,450,1:61,141:201)
set(gca,'ticklength',4*get(gca,'ticklength'))
% F=nanmean(FamSS(:,200:400)')'
% N=nanmean(NovSS(:,200:400)')'
F=vertcat(savestruct(1,:).FamSS_)
N=vertcat(savestruct(1,:).NovSS_)
scatter(N,F, 30, 'k','filled');
axis([round(min([F' N'])) round(max([F' N'])+10) round(min([F' N'])) round(max([F' N'])+10)])
line([round(min([F' N'])) round(max([F' N'])+10)], [round(min([F' N'])) round(max([F' N'])+10)])
axis square
t=ylabel('Response to familiar objects (spikes/s)'); set(t, 'FontSize', 8);
t=xlabel('Response to novel objects (spikes/s)'); set(t, 'FontSize', 8);

nsubplot(450,450,1:61,221:241);
set(gca,'ticklength',4*get(gca,'ticklength'))
ROC=vertcat(savestruct(1,:).Nov_r);
ROC(:,2)=1
JitterVar=0.2; %jitter for scatter plot
scatter(mean(ROC(:,2)),mean(ROC(:,1)),120,'r','filled'); hold on;
scatter(ROC(:,2),ROC(:,1),20,'k','filled','jitter','on', 'jitterAmount',JitterVar); hold on;
t=ylabel('Novelty discrimination (AUC)'); set(t, 'FontSize', 8);
line([0 2], [0.5 0.5])
ylim([0 1])



nsubplot(450,450,301:450,1:150)
NovUseful=vertcat(savestruct(1,:).NovUseful);
NovNotUseful=vertcat(savestruct(1,:).NovNotUseful);
NovUsefulFam=vertcat(savestruct(1,:).NovUsefulFam);
NovNotUsefulFam=vertcat(savestruct(1,:).NovNotUsefulFam);
plt=NovNotUseful; x=1:size(plt,2); v=sqrt(size(plt,1)); shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'--r', 'LineWidth', 2}, 0); hold on
plt=NovUseful; x=1:size(plt,2); v=sqrt(size(plt,1)); shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-r', 'LineWidth', 0.5}, 0); hold on
xlim([0 500])
line([200 400],[1 1],'LineWidth',3, 'Color', 'r')
set(gca,'ticklength',4*get(gca,'ticklength'))
t=xlabel('Time from object onset (milliseconds)'); set(t, 'FontSize', 8);
t=text(100,0.7,['n='   mat2str(size(NovNotUseful,1))]); set(t, 'FontSize', 8);
p=signrank(mean(NovUseful(:,200:400)')',mean(NovNotUseful(:,200:400)')')
t=text(100,0.1,['p='   mat2str(p)]); set(t, 'FontSize', 8);
ylim([0 1])
t=ylabel('Normalized response'); set(t, 'FontSize', 8);
%

nsubplot(450,450,301:450,201:350)
plt=NovNotUsefulFam; x=1:size(plt,2); v=sqrt(size(plt,1)); shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'--k', 'LineWidth', 2}, 0); hold on
plt=NovUsefulFam; x=1:size(plt,2); v=sqrt(size(plt,1)); shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-k', 'LineWidth', 0.5}, 0); hold on
xlim([0 500])
line([200 400],[1 1],'LineWidth',3, 'Color', 'r')
set(gca,'ticklength',4*get(gca,'ticklength'))
t=xlabel('Time from object onset (milliseconds)'); set(t, 'FontSize', 8);
t=text(100,0.7,['n='   mat2str(size(NovNotUsefulFam,1))]); set(t, 'FontSize', 8);
p=signrank(mean(NovUsefulFam(:,200:400)')',mean(NovNotUsefulFam(:,200:400)')')
t=text(100,0.1,['p='   mat2str(p)]); set(t, 'FontSize', 8);
ylim([0 1])

p1=plot(NaN,'-r'); hold on
p2=plot(NaN,'--r'); hold on
p3=plot(NaN,'-k'); hold on
p4=plot(NaN,'--k'); hold on
legend([p1 p2 p3 p4],'Novel-relevant','Novel-irrelevant', 'Familiar-relevant', 'Familiar-irrelevant')

%

nsubplot(450,450,255:320,375:450)
N=vertcat(savestruct(1,:).NovUseful_);
F=vertcat(savestruct(1,:).NovNotUseful_);
axis([0 round(max([F' N']))+1 0 round(max([F' N']))+1])
line([0 round(max([F' N']))], [0 round(max([F' N']))])
scatter(N,F, 30, 'k', 'filled');
axis square
t=xlabel({'Novel object related response','from memory relevant sequence'}); set(t, 'FontSize', 6);
t=ylabel({'Novel object related response','from memory irrelevant sequence'}); set(t, 'FontSize', 6);
p=signrank(N,F)
t=text(15,5,['p='   mat2str(p)]); set(t, 'FontSize', 8);
N1=N; F1=F;

PercIndex=[];
for x=1:length(savestruct)
    
    if isempty(savestruct(x).NovUseful_)==0
        temp= ((savestruct(x).NovUseful_)-(savestruct(x).NovNotUseful_)) ./ ((savestruct(x).NovSS_) - (savestruct(x).FamSS_))
        PercIndex=[PercIndex; temp]
        clear temp
    end
end

t=text(15,10,['nov mem rel - nov mem irrel / nov - fam='   mat2str(round(100*nanmean(PercIndex)))]); set(t, 'FontSize', 8);


nsubplot(450,450,375:440,375:450)
N=vertcat(savestruct(1,:).NovUsefulFam_);
F=vertcat(savestruct(1,:).NovNotUsefulFam_);
axis([0 round(max([F1' N1']))+1 0 round(max([F1' N1']))+1])
line([0 round(max([F1' N1']))], [0 round(max([F1' N1']))])
scatter(N,F, 30, 'k', 'filled');
axis square
t=xlabel({'object related response','from memory relevant sequence'}); set(t, 'FontSize', 6);
t=ylabel({'object related response','from memory irrelevant sequence'}); set(t, 'FontSize', 6);
p=signrank(N,F)
t=text(15,5,['p='   mat2str(p)]); set(t, 'FontSize', 8);




nsubplot(450,450,1:61,341:401)
N1=vertcat(savestruct(1,:).BEfiring);
F1=vertcat(savestruct(1,:).NOBEfiring);
axis([round(min([F1' N1'])) round(max([F1' N1'])) round(min([F1' N1'])) round(max([F1' N1']))])
line([round(min([F1' N1'])) round(max([F1' N1']))], [round(min([F1' N1'])) round(max([F1' N1']))])
scatter(N1,F1, 30, 'k', 'filled');
axis square
t=xlabel({'Belief state error'}); set(t, 'FontSize', 6);
t=ylabel({'Control'}); set(t, 'FontSize', 6);
p=signrank(N1,F1)
t=text(round(max([F1' N1'])),round(max([F1' N1'])),['p='   mat2str(p)]); set(t, 'FontSize', 8);



figure
F1=vertcat(savestruct(1,:).SDFcs);
plot(nanmean(F1),'k','LineWidth',3)
xlim([0 4000])

if doprint ==1
    
    set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
    print('-dpdf', 'Memoryactivity' );
    close all;
end



