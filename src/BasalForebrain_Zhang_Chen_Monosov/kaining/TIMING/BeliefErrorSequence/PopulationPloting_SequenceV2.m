close all; clc; beep off; clear all;
addpath('HELPER_GENERAL');
load savedataAll.mat


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

doprint=1;
FamIncludeFirst=2; %do both to give latency range (e.g. 85ms if exclude first and 110 if you include first)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CellTypes = {savestruct.TYPE}
savestructPhasic=savestruct( find(strcmp(CellTypes,'phasic')) );
savestructTonic=savestruct( find(strcmp(CellTypes,'tonic')) );


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
nsubplot(450,450,1:450,1:450)
set(gca,'ticklength',4*get(gca,'ticklength'))
F1=vertcat(savestructPhasic(1,:).SDFcs);
plt=F1; x=1:size(plt,2); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-k', 'LineWidth', 3}, 0); hold on
%plot(nanmean(F1),'k','LineWidth',3)
xlim([0 4000])
if doprint==1
    set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
    print('-dpdf', 'MultiPhasic' );
    close all;
end


figure
nsubplot(450,450,1:450,1:450)
set(gca,'ticklength',4*get(gca,'ticklength'))
F1=vertcat(savestructTonic(1,:).SDFcs);
plt=F1; x=1:size(plt,2); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-k', 'LineWidth', 3}, 0); hold on
%plot(nanmean(F1),'k','LineWidth',3)
xlim([0 4000])
if doprint==1
    set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
    print('-dpdf', 'MultiTonic' );
    close all;
end

figure
nsubplot(450,450,1:450,1:450)
set(gca,'ticklength',4*get(gca,'ticklength'))

F1=vertcat(savestructTonic(1,:).SDFcs1);
plt=F1; x=1:size(plt,2); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-c', 'LineWidth', 3}, 0); hold on

F2=vertcat(savestructTonic(1,:).SDFcs2);
plt=F2; x=1:size(plt,2); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-b', 'LineWidth', 3}, 0); hold on

P=[];
for x=1:length(F1)
    P=[P;signrank(F1(:,x),F2(:,x))];
end
P(find(P>0.049999))=NaN;
LimY=0.4;
P(find(isnan(P)==0))=LimY-0.1;
plot(P,'LineWidth', 4)
ylim([-.4 LimY])
xlim([0 4000])





close all; figure
nsubplot(450,450,1:450,1:450)
set(gca,'ticklength',4*get(gca,'ticklength'))

F1=vertcat(savestructPhasic(1,:).SDFcs1);
plt=F1; x=1:size(plt,2); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-c', 'LineWidth', 3}, 0); hold on

F2=vertcat(savestructPhasic(1,:).SDFcs2);
plt=F2; x=1:size(plt,2); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-b', 'LineWidth', 3}, 0); hold on

P=[];
for x=1:length(F1)
    P=[P;signrank(F1(:,x),F2(:,x))];
end
P(find(P>0.04999))=NaN;
LimY=1.6;
P(find(isnan(P)==0))=LimY-0.1;
plot(P,'LineWidth', 4)
ylim([-.4 LimY])
xlim([0 4000])


close all; figure
nsubplot(450,450,1:450,1:450)
set(gca,'ticklength',4*get(gca,'ticklength'))
NovUseful=vertcat(savestructPhasic(1,:).NovUseful);
NovNotUseful=vertcat(savestructPhasic(1,:).NovNotUseful);
NovUsefulFam=vertcat(savestructPhasic(1,:).NovUsefulFam);
NovNotUsefulFam=vertcat(savestructPhasic(1,:).NovNotUsefulFam);
plt=NovUseful; x=1:size(plt,2); v=sqrt(size(plt,1)); shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-r', 'LineWidth', 1.5}, 0); hold on
plt=NovNotUseful; x=1:size(plt,2); v=sqrt(size(plt,1)); shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-m', 'LineWidth', 0.5}, 0); hold on
xlim([0 500])
line([200 400],[1 1],'LineWidth',3, 'Color', 'r')

t=xlabel('Time from object onset (milliseconds)'); set(t, 'FontSize', 8);
t=text(100,0.7,['n='   mat2str(size(NovNotUseful,1))]); set(t, 'FontSize', 8);
p=signrank(mean(NovUseful(:,200:400)')',mean(NovNotUseful(:,200:400)')')
t=text(100,0.1,['p='   mat2str(p)]); set(t, 'FontSize', 8);
ylim([0 1])
t=ylabel('Normalized response'); set(t, 'FontSize', 8);
%
%
%nsubplot(450,450,301:450,201:350)
%set(gca,'ticklength',4*get(gca,'ticklength'))
plt=NovUsefulFam; x=1:size(plt,2); v=sqrt(size(plt,1)); shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-k', 'LineWidth', 1.5}, 0); hold on
plt=NovNotUsefulFam; x=1:size(plt,2); v=sqrt(size(plt,1)); shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'color',[0.5 0.5 0.5], 'LineWidth', .5}, 0); hold on
% xlim([0 500])
% line([200 400],[1 1],'LineWidth',3, 'Color', 'r')
%set(gca,'ticklength',4*get(gca,'ticklength'))
%t=xlabel('Time from object onset (milliseconds)'); set(t, 'FontSize', 8);
%t=text(100,0.7,['n='   mat2str(size(NovNotUsefulFam,1))]); set(t, 'FontSize', 8);
p=signrank(mean(NovUsefulFam(:,200:400)')',mean(NovNotUsefulFam(:,200:400)')')
t=text(100,0.2,['p='   mat2str(p)]); set(t, 'FontSize', 8);
ylim([0 1])

% p1=plot(NaN,'-r'); hold on
% p2=plot(NaN,'--r'); hold on
% p3=plot(NaN,'-k'); hold on
% p4=plot(NaN,'--k'); hold on
% legend([p1 p2 p3 p4],'Novel-relevant','Novel-irrelevant', 'Familiar-relevant', 'Familiar-irrelevant')

if doprint==1
    set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
    print('-dpdf', 'SDFRelIrel' );
    close all;
end




close all; figure
nsubplot(450,450,1:450,1:450)
set(gca,'ticklength',4*get(gca,'ticklength'))
NovUseful=[]
NovNotUseful=[]
FamSS=[];
NovSS=[];
for x=1:length(savestructPhasic)
    if isempty(savestructPhasic(x).NovUseful_)==0 & isempty(savestructPhasic(x).NovNotUseful_)==0
        
        NovUseful=[NovUseful;savestructPhasic(x).NovUseful_]
        NovNotUseful=[NovNotUseful;savestructPhasic(x).NovNotUseful_]
        FamSS=[FamSS;savestructPhasic(x).FamSS_];
        NovSS=[NovSS;savestructPhasic(x).NovSS_];
    end
end
B=NovUseful- NovNotUseful;
A=NovSS-FamSS;

bar(1,mean(mean([A'; ])'),'w'); hold on
%scatter(repmat(1,length(A),1),A,'r','filled'); hold on;
bar(4,mean(mean([B'; ])'),'w'); hold on
%scatter(repmat(4,length(B),1),B,'r','filled'); hold on;

for x=1:length(A)
    plot([1 4],[A(x) B(x)],'k'); hold on
end
axis square
if doprint==1
    set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
    print('-dpdf', 'EffectSize' );
    close all;
end



close all; figure
nsubplot(450,450,1:100,1:100)
set(gca,'ticklength',4*get(gca,'ticklength'))
if FamIncludeFirst==1
    FamSS=vertcat(savestructPhasic(1,:).FamSS)
else
    FamSS=vertcat(savestructPhasic(1,:).FamSSa)
end
NovSS=vertcat(savestructPhasic(1,:).NovSS)
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
t=text(100,0.9,['population latency='   mat2str(SavePvalues)]); set(t, 'FontSize', 8);
t=ylabel('Normalized response'); set(t, 'FontSize', 8);
p1=plot(NaN,'-r'); hold on
p3=plot(NaN,'-k'); hold on
ylim([-.5 1.5])




nsubplot(450,450,1:61,141:201)
set(gca,'ticklength',4*get(gca,'ticklength'))
F=vertcat(savestructPhasic(1,:).FamSS_)
N=vertcat(savestructPhasic(1,:).NovSS_)
scatter(N,F, 10, 'r','filled');
F=vertcat(savestructTonic(1,:).FamSS_)
N=vertcat(savestructTonic(1,:).NovSS_)
scatter(N,F, 10, 'k','filled');
axis([-5 25 -5 25])
line([-5 25],  [-5 25])
axis square;
% axis([round(min([F' N'])) round(max([F' N'])+10) round(min([F' N'])) round(max([F' N'])+10)])
% line([round(min([F' N'])) round(max([F' N'])+10)], [round(min([F' N'])) round(max([F' N'])+10)])
% axis square
t=ylabel('Response to familiar objects (spikes/s)'); set(t, 'FontSize', 8);
t=xlabel('Response to novel objects (spikes/s)'); set(t, 'FontSize', 8);



nsubplot(450,450,1:61,221:241);
set(gca,'ticklength',4*get(gca,'ticklength'))
ROC=vertcat(savestructPhasic(1,:).Nov_r);
ROCp=vertcat(savestructPhasic(1,:).Nov_p);

ROCs=ROC; ROCs(find(ROCp>0.05 | ROCp==0.05))=NaN;
ROCns=ROC; ROCns(find(isnan(ROCs)==0))=NaN;
ROCs(:,2)=1
ROCns(:,2)=1
JitterVar=0.2; %jitter for scatter plot
%scatter(mean(ROC(:,2)),mean(ROC(:,1)),120,'r','filled'); hold on;
scatter(ROCns(:,2),ROCns(:,1),10,'k','filled','jitter','on', 'jitterAmount',JitterVar); hold on;
scatter(ROCs(:,2),ROCs(:,1),10,'r','filled','jitter','on', 'jitterAmount',JitterVar); hold on;


t=ylabel('Novelty discrimination (AUC)'); set(t, 'FontSize', 8);
line([0 2], [0.5 0.5])
ylim([0 1])
text(2,0.5, mat2str(nanmean(ROC)))
p2 = [1 mean(ROC(:,1))];                         
p1 = [2 mean(ROC(:,1))];                        
dp = p2-p1;                        
quiver(p1(1),p1(2),dp(1),dp(2),0, 'MaxHeadSize',0.5)



nsubplot(450,450,255:320,375:450)
set(gca,'ticklength',4*get(gca,'ticklength'))
N=vertcat(savestructPhasic(1,:).NovUseful_);
F=vertcat(savestructPhasic(1,:).NovNotUseful_);
scatter(N,F, 10, 'r', 'filled');
N=vertcat(savestructTonic(1,:).NovUseful_);
F=vertcat(savestructTonic(1,:).NovNotUseful_);
scatter(N,F, 10, 'k', 'filled');
axis([-5 25 -5 25])
line([-5 25],  [-5 25])
axis square;
t=xlabel({'Novel object related response','from memory relevant sequence'}); set(t, 'FontSize', 6);
t=ylabel({'Novel object related response','from memory irrelevant sequence'}); set(t, 'FontSize', 6);

N=vertcat(savestructPhasic(1,:).NovUseful_);
F=vertcat(savestructPhasic(1,:).NovNotUseful_);
p=signrank(N,F)
t=text(15,5,['p phasic='   mat2str(p)]); set(t, 'FontSize', 8);

N=vertcat(savestructTonic(1,:).NovUseful_);
F=vertcat(savestructTonic(1,:).NovNotUseful_);
p=signrank(N,F)
t=text(15,10,['p tonic='   mat2str(p)]); set(t, 'FontSize', 8);




HISTWIDTH=0.5;
nsubplot(450,450,101:161,221:241);
set(gca,'ticklength',4*get(gca,'ticklength'))
N=vertcat(savestructPhasic(1,:).NovUseful_);
F=vertcat(savestructPhasic(1,:).NovNotUseful_);
h1 = histogram(N-F, 'EdgeColor','r','FaceColor','r'); hold on
%N=vertcat(savestructTonic(1,:).NovUseful_);
%F=vertcat(savestructTonic(1,:).NovNotUseful_);
%h2 = histogram(N-F, 'EdgeColor','k','FaceColor','k'); hold on
h1.BinWidth = HISTWIDTH;
%h2.BinWidth = 1;
line([0 0], [0 10] , 'Color', [0 0 0 ]) ;
xlim([-4 4])
ylim([0 10])


nsubplot(450,450,301:361,221:241);
set(gca,'ticklength',4*get(gca,'ticklength'))
N=vertcat(savestructPhasic(1,:).NovUsefulFam_);
F=vertcat(savestructPhasic(1,:).NovNotUsefulFam_);
h1 = histogram(N-F, 'EdgeColor','r','FaceColor','r'); hold on
%N=vertcat(savestructTonic(1,:).NovUseful_);
%F=vertcat(savestructTonic(1,:).NovNotUseful_);
%h2 = histogram(N-F, 'EdgeColor','k','FaceColor','k'); hold on
h1.BinWidth = HISTWIDTH;
%h2.BinWidth = 1;
line([0 0], [0 10] , 'Color', [0 0 0 ]) ;
xlim([-4 4])
ylim([0 10])


nsubplot(450,450,375:440,375:450)
set(gca,'ticklength',4*get(gca,'ticklength'))
N=vertcat(savestructPhasic(1,:).NovUsefulFam_);
F=vertcat(savestructPhasic(1,:).NovNotUsefulFam_);
scatter(N,F, 10, 'r', 'filled');
N=vertcat(savestructTonic(1,:).NovUsefulFam_);
F=vertcat(savestructTonic(1,:).NovNotUsefulFam_);
scatter(N,F, 10, 'k', 'filled');
axis([-5 25 -5 25])
line([-5 25],  [-5 25])
axis square;
t=xlabel({'object related response','from memory relevant sequence'}); set(t, 'FontSize', 6);
t=ylabel({'object related response','from memory irrelevant sequence'}); set(t, 'FontSize', 6);

N=vertcat(savestructPhasic(1,:).NovUsefulFam_);
F=vertcat(savestructPhasic(1,:).NovNotUsefulFam_);
p=signrank(N,F)
t=text(15,5,['p phasic='   mat2str(p)]); set(t, 'FontSize', 8);

N=vertcat(savestructTonic(1,:).NovUsefulFam_);
F=vertcat(savestructTonic(1,:).NovNotUsefulFam_);
p=signrank(N,F)
t=text(15,10,['p tonic='   mat2str(p)]); set(t, 'FontSize', 8);


N=vertcat(savestructPhasic(1,:).NovUsefulFam_);
F=vertcat(savestructPhasic(1,:).NovNotUsefulFam_);
PercIndex=[];
for x=1:length(savestruct)
    
    if isempty(savestruct(x).NovUsefulFam_)==0
        temp= ((savestruct(x).NovUsefulFam_)-(savestruct(x).NovNotUsefulFam_)) ./ ((savestruct(x).NovSS_) - (savestruct(x).FamSS_))
        PercIndex=[PercIndex; temp]
        clear temp
    end
end
t=text(15,15,['nov mem rel - nov mem irrel / nov - fam='   mat2str((nanmean(PercIndex)))]); set(t, 'FontSize', 8);





nsubplot(450,450,1:61,341:401)
set(gca,'ticklength',4*get(gca,'ticklength'))
N=vertcat(savestructPhasic(1,:).BEfiring);
F=vertcat(savestructPhasic(1,:).NOBEfiring);
scatter(N,F, 10, 'r', 'filled');
N1=vertcat(savestructTonic(1,:).BEfiring);
F1=vertcat(savestructTonic(1,:).NOBEfiring);
scatter(N1,F1, 10, 'k', 'filled');
axis([-5 25 -5 25])
line([-5 25],  [-5 25])
axis square;
p=signrank(N,F)
t=text(15,5,['p phasic='   mat2str(p)]); set(t, 'FontSize', 8);
p=signrank(N1,F1)
t=text(15,15,['p tonic='   mat2str(p)]); set(t, 'FontSize', 8);




nsubplot(450,450,101:161,121:141);
set(gca,'ticklength',4*get(gca,'ticklength'))
N=vertcat(savestructPhasic(1,:).BEfiring);
F=vertcat(savestructPhasic(1,:).NOBEfiring);
h1 = histogram(N-F, 'EdgeColor','r','FaceColor','r'); hold on
%N=vertcat(savestructTonic(1,:).BEfiring);
%F=vertcat(savestructTonic(1,:).NOBEfiring);
%h2 = histogram(N-F, 'EdgeColor','k','FaceColor','k'); hold on
h1.BinWidth = HISTWIDTH;
%h2.BinWidth = 1;
line([0 0], [0 10] , 'Color', [0 0 0 ]) ;
xlim([-7 7])
ylim([0 10])




if doprint==1
    set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
    print('-dpdf', 'MemoryactivityALL' );
    close all;
end



