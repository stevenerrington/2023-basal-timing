clear all; close all; clc; beep off;
addpath('HELPER_GENERAL');

YLIMit=50; YLIMitm=-25;
YYLIMit=70; YYLIMitm=-30;
PermNum=10000;

ModelAllGroups=1;
takeoutNegs=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load('DATA15.mat')
P=ProbAmtDataStruct;
load('DATA25.mat')
ProbAmtDataStruct = [P ProbAmtDataStruct];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

CorvalP=[];
CoruncP=[];
CorvalP_a=[];
CoruncP_a=[];
Vectors=[];
for x=1:length(ProbAmtDataStruct)
    t=ProbAmtDataStruct(x).Prob_(1001:end);
    t=t-min(t);
    t=t./max(t);
    Vectors=[Vectors; (t)];
%     %
%     %if size(ProbAmtDataStruct(x).CorvalP,2)==1400
%     CorvalP=[CorvalP; ProbAmtDataStruct(x).CorvalP(1:500)];
%     CoruncP=[CoruncP; ProbAmtDataStruct(x).CoruncP(1:500)];
%     CorvalP_a=[CorvalP_a; ProbAmtDataStruct(x).CorvalP_a(1:500)];
%     CoruncP_a=[CoruncP_a; ProbAmtDataStruct(x).CoruncP_a(1:500)];
    %else
end

G=Vectors;
%[pc, zscores, pcvars] = pca(G,'VariableWeights','variance');
[pc, zscores, pcvars] = pca(G);
%VarE_=pcvars./sum(pcvars) * 100 %var exp
%VarE=cumsum(pcvars./sum(pcvars) * 100); %cum sum of variance

meas=zscores(:,[1:10])
rng('default');  % For reproducibility
eva = evalclusters(meas,'kmeans','CalinskiHarabasz','KList',[1:6])
eva = evalclusters(meas,'kmeans','silhouette','KList',[1:6])
idx3 = kmeans(meas,2,'Distance','sqeuclidean');

T1=G(find(idx3==1),:);
T2=G(find(idx3==2),:);

NUM=2;
D = pdist(T1, 'euclidean');
T = linkage(D, 'ward');
[H,T,outperm] = dendrogram(T, 0, 'colorthreshold',mean(T(end-NUM+1:end-NUM+2,3)),'Orientation','left');
T1=T1(outperm,:); clear T D H outperm; close all;

D = pdist(T2, 'euclidean');
T = linkage(D, 'ward');
[H,T,outperm] = dendrogram(T, 0, 'colorthreshold',mean(T(end-NUM+1:end-NUM+2,3)),'Orientation','left');
T2=T2(outperm,:); clear T D H outperm; close all;

G=[T1; T2];



%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure; 
nsubplot(4,4,3:4,1:1)
hold on; set(gca,'ticklength',4*get(gca,'ticklength'))
imagesc(flipud(G))
xlim([0 1500])
colormap('bone');colorbar;
ylim([0 (round((size(G,1)+5)./10))*10])
 axis off
title( [' n= ' mat2str(size(G,1))] )
 
ThP=0.01;
CorvalP(find(CorvalP<ThP))=10;
CorvalP(find(CorvalP~=10))=0;
CorvalP(find(CorvalP==10))=1; 
CorvalPG1=CorvalP(find(idx3==1),:);
CorvalPG2=CorvalP(find(idx3==2),:);

CorvalP_a(find(CorvalP_a<ThP))=10;
CorvalP_a(find(CorvalP_a~=10))=0;
CorvalP_a(find(CorvalP_a==10))=1; 
CorvalPG1_a=CorvalP_a(find(idx3==1),:);
CorvalPG2_a=CorvalP_a(find(idx3==2),:);
%
Thr=30;
D=CorvalPG1(find(mean(CorvalPG1')~=0),:);
[idx,idx] = max(D,[],2);
LatencyG1=idx(find(idx>Thr));
%
D=CorvalPG2(find(mean(CorvalPG2')~=0),:);
[idx,idx] = max(D,[],2);
LatencyG2=idx(find(idx>Thr));

D=CorvalPG1_a(find(mean(CorvalPG1_a')~=0),:);
[idx,idx] = max(D,[],2);
LatencyG1_a=idx(find(idx>Thr));
%
D=CorvalPG2_a(find(mean(CorvalPG2_a')~=0),:);
[idx,idx] = max(D,[],2);
LatencyG2_a=idx(find(idx>Thr));
% 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


figure; 
nsubplot(4,4,3:4,1:1)

hold on; set(gca,'ticklength',4*get(gca,'ticklength'))
scatter3(zscores(find(idx3==1),1), zscores(find(idx3==1),2),zscores(find(idx3==1),3),20,'r','filled')
scatter3(zscores(find(idx3==2),1), zscores(find(idx3==2),2),zscores(find(idx3==2),3),20,'b','filled')
LL=-20;
LLL=20;
xlim([LL LLL])
ylim([LL LLL])
zlim([LL LLL])
axis square
view(-10,20)
xlabel('PC1')
ylabel('PC2')
zlabel('PC3')
title('group 1 - red; group 2 - blue')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%subtract baseline.
for x=1:length(ProbAmtDataStruct)
    shift_plot=ProbAmtDataStruct(x).actp100s;
    shift_plot=(nanmean(shift_plot(:,1:15)'))';
    
    ProbAmtDataStruct(x).actp100s=ProbAmtDataStruct(x).actp100s-shift_plot;
    ProbAmtDataStruct(x).actp75s=ProbAmtDataStruct(x).actp75s-shift_plot;
    ProbAmtDataStruct(x).actp50s=ProbAmtDataStruct(x).actp50s-shift_plot;
    ProbAmtDataStruct(x).actp25s=ProbAmtDataStruct(x).actp25s-shift_plot;
    ProbAmtDataStruct(x).actp0s=ProbAmtDataStruct(x).actp0s-shift_plot;
    ProbAmtDataStruct(x).actp100l=ProbAmtDataStruct(x).actp100l-shift_plot;
    ProbAmtDataStruct(x).actp75l= ProbAmtDataStruct(x).actp75l-shift_plot;
    ProbAmtDataStruct(x).actp50l=ProbAmtDataStruct(x).actp50l-shift_plot;
    ProbAmtDataStruct(x).actp25l=ProbAmtDataStruct(x).actp25l-shift_plot;
    ProbAmtDataStruct(x).actp0l=ProbAmtDataStruct(x).actp0l-shift_plot;
    
    ProbAmtDataStruct(x).acta100s=ProbAmtDataStruct(x).acta100s-shift_plot;
    ProbAmtDataStruct(x).acta75s=ProbAmtDataStruct(x).acta75s-shift_plot;
    ProbAmtDataStruct(x).acta50s=ProbAmtDataStruct(x).acta50s-shift_plot;
    ProbAmtDataStruct(x).acta25s=ProbAmtDataStruct(x).acta25s-shift_plot;
    ProbAmtDataStruct(x).acta0s=ProbAmtDataStruct(x).acta0s-shift_plot;
    ProbAmtDataStruct(x).acta100l=ProbAmtDataStruct(x).acta100l-shift_plot;
    ProbAmtDataStruct(x).acta75l= ProbAmtDataStruct(x).acta75l-shift_plot;
    ProbAmtDataStruct(x).acta50l=ProbAmtDataStruct(x).acta50l-shift_plot;
    ProbAmtDataStruct(x).acta25l=ProbAmtDataStruct(x).acta25l-shift_plot;
    ProbAmtDataStruct(x).acta0l=ProbAmtDataStruct(x).acta0l-shift_plot;
    
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%separate into 2 groups based on IDX from clustering
Group1=ProbAmtDataStruct(find(idx3==1));
Group2=ProbAmtDataStruct(find(idx3==2));

if takeoutNegs==1
    IDS = { Group1(:).monkey}
    Group1=Group1 ( find(~strcmp(IDS,'robin_')) );
    IDS = { Group1(:).monkey}
    Group1=Group1 ( find(~strcmp(IDS,'zombie_')) );
    IDS = { Group1(:).monkey}
    Group1=Group1 ( find(~strcmp(IDS,'batman_')) );
    
    IDS = { Group2(:).monkey}
    Group2=Group2( find(~strcmp(IDS,'robin_')) );
    IDS = { Group2(:).monkey}
    Group2=Group2 ( find(~strcmp(IDS,'zombie_')) );
    IDS = { Group2(:).monkey}
    Group2=Group2 ( find(~strcmp(IDS,'batman_')) );

    IndexWithEnoughTrials=[];
    for x=1:size(Group1,2)
        if length(Group1(x).actp75ndR)>1 & length(Group1(x).actp25dR)>1
            
            if isempty(find(isnan(Group1(x).actp75ndR)==1))==1
                if isempty(find(isnan(Group1(x).actp25dR)==1)) ==1
                    
                    IndexWithEnoughTrials=[IndexWithEnoughTrials; x];
                    
                end
            end
        end
    end
    Group1=Group1(IndexWithEnoughTrials);
    
        IndexWithEnoughTrials=[];
    for x=1:size(Group2,2)
        if length(Group2(x).actp75ndR)>1 & length(Group2(x).actp25dR)>1
            
            if isempty(find(isnan(Group2(x).actp75ndR)==1))==1
                if isempty(find(isnan(Group2(x).actp25dR)==1)) ==1
                    
                    IndexWithEnoughTrials=[IndexWithEnoughTrials; x];
                    
                end
            end
        end
    end
    Group2=Group2(IndexWithEnoughTrials);
    

end

figure; 
nsubplot(4,4,3:4,1:1)

YYLIMitm=0 
YYLIMit=65


plot(nanmean(vertcat(Group1(1,:).actp100R)),'Color',[0 0 0],'LineWidth',1)
xlim([0 1000])
ylim([YYLIMitm YYLIMit])
title('100')

figure; 
nsubplot(4,4,3:4,1:1)
plot(nanmean(vertcat(Group1(1,:).actp75dR)),'Color',[1 0 0],'LineWidth',1)
plot(nanmean(vertcat(Group1(1,:).actp75ndR)),'Color',[0 0 0],'LineWidth',1)
xlim([0 1000])
ylim([YYLIMitm YYLIMit])
title('75')

figure; 
nsubplot(4,4,3:4,1:1)
plot(nanmean(vertcat(Group1(1,:).actp50dR)),'Color',[1 0 0],'LineWidth',1)
plot(nanmean(vertcat(Group1(1,:).actp50ndR)),'Color',[0 0 0],'LineWidth',1)
xlim([0 1000])
ylim([YYLIMitm YYLIMit])
title('50')

figure; 
nsubplot(4,4,3:4,1:1)
plot(nanmean(vertcat(Group1(1,:).actp25dR)),'Color',[1 0 0],'LineWidth',1)
plot(nanmean(vertcat(Group1(1,:).actp25ndR)),'Color',[0 0 0],'LineWidth',1)
xlim([0 1000])
ylim([YYLIMitm YYLIMit])
title('25')

YYLIMitm=-20 
YYLIMit=20

figure; 
nsubplot(4,4,3:4,1:1)
Resp75=(vertcat(Group1(1,:).actp75dR))-(vertcat(Group1(1,:).actp75ndR));
Resp50=(vertcat(Group1(1,:).actp50dR))-(vertcat(Group1(1,:).actp50ndR));
Resp25=(vertcat(Group1(1,:).actp25dR))-(vertcat(Group1(1,:).actp25ndR));
plot(mean(Resp25),'r','LineWidth',1)
plot(mean(Resp50),'g','LineWidth',1)
plot(mean(Resp75),'m','LineWidth',1)
xlim([0 1000])
ylim([YYLIMitm YYLIMit])
title('Outcome Responses')

YYLIMitm=0 
YYLIMit=20

figure; 
nsubplot(4,4,3:4,1:1)
plot(nanmean(vertcat(Group2(1,:).actp100R)),'Color',[0 0 0],'LineWidth',1)
xlim([0 1000])
ylim([YYLIMitm YYLIMit])

figure; 
nsubplot(4,4,3:4,1:1)
plot(nanmean(vertcat(Group2(1,:).actp75dR)),'Color',[1 0 0],'LineWidth',1)
plot(nanmean(vertcat(Group2(1,:).actp75ndR)),'Color',[0 0 0],'LineWidth',1)
xlim([0 1000])
ylim([YYLIMitm YYLIMit])

figure; 
nsubplot(4,4,3:4,1:1)
plot(nanmean(vertcat(Group2(1,:).actp50dR)),'Color',[1 0 0],'LineWidth',1)
plot(nanmean(vertcat(Group2(1,:).actp50ndR)),'Color',[0 0 0],'LineWidth',1)
xlim([0 1000])
ylim([YYLIMitm YYLIMit])

figure; 
nsubplot(4,4,3:4,1:1)
plot(nanmean(vertcat(Group2(1,:).actp25dR)),'Color',[1 0 0],'LineWidth',1)
plot(nanmean(vertcat(Group2(1,:).actp25ndR)),'Color',[0 0 0],'LineWidth',1)
xlim([0 1000])
ylim([YYLIMitm YYLIMit])

YYLIMitm=-10 
YYLIMit=15

figuren;

Resp75=(vertcat(Group2(1,:).actp75dR))-(vertcat(Group2(1,:).actp75ndR));
Resp50=(vertcat(Group2(1,:).actp50dR))-(vertcat(Group2(1,:).actp50ndR));
Resp25=(vertcat(Group2(1,:).actp25dR))-(vertcat(Group2(1,:).actp25ndR));
plot(mean(Resp25),'r','LineWidth',1)
plot(mean(Resp50),'g','LineWidth',1)
plot(mean(Resp75),'m','LineWidth',1)
xlim([0 1000])
ylim([YYLIMitm YYLIMit])

% set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
% print('-dpdf', 'T22' );
% close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if takeoutNegs==1

    IDS = { ProbAmtDataStruct(:).monkey}
    ProbAmtDataStruct=ProbAmtDataStruct( find(~strcmp(IDS,'robin_')) );
    IDS = { ProbAmtDataStruct(:).monkey}
    ProbAmtDataStruct=ProbAmtDataStruct ( find(~strcmp(IDS,'zombie_')) );
    IDS = { ProbAmtDataStruct(:).monkey}
    ProbAmtDataStruct=ProbAmtDataStruct ( find(~strcmp(IDS,'batman_')) );
    
    
    IndexWithEnoughTrials=[];
for x=1:size(ProbAmtDataStruct,2)
    if length(ProbAmtDataStruct(x).actp75ndR)>2 & length(ProbAmtDataStruct(x).actp25dR)>2
        
        if isempty(find(isnan(ProbAmtDataStruct(x).actp75ndR)==1))==1
            if isempty(find(isnan(ProbAmtDataStruct(x).actp25dR)==1)) ==1
                
                IndexWithEnoughTrials=[IndexWithEnoughTrials; x];
                
            end
        end
    end
end
ProbAmtDataStruct=ProbAmtDataStruct(IndexWithEnoughTrials);

    
    
end


if ModelAllGroups==1
elseif ModelAllGroups==2
    ProbAmtDataStruct=Group1;
elseif ModelAllGroups==3
    ProbAmtDataStruct=Group2;
end

figure; 
nsubplot(4,4,3:4,1:1)

Resp75=(vertcat(ProbAmtDataStruct(1,:).actp75dR))-(vertcat(ProbAmtDataStruct(1,:).actp75ndR));
Resp50=(vertcat(ProbAmtDataStruct(1,:).actp50dR))-(vertcat(ProbAmtDataStruct(1,:).actp50ndR));
Resp25=(vertcat(ProbAmtDataStruct(1,:).actp25dR))-(vertcat(ProbAmtDataStruct(1,:).actp25ndR));
PlotMatrix=(([nanmean(Resp75(:,100:400)');
    nanmean(Resp50(:,100:400)');
    nanmean(Resp25(:,100:400)');
    ]))'; 
 PlotMatrix=fliplr(PlotMatrix)
%
PlotMatrixCorr=repmat([3 2 1],size(PlotMatrix,1),1)
[pval, R]=permutation_pair_test_fast(PlotMatrixCorr(:),PlotMatrix(:), PermNum,'rankcorr');
t=text(3,15,['p= ' mat2str(pval)]); set(t, 'FontSize', 8);
t=text(3,10,['Model fit rho= ' mat2str(R)]); set(t, 'FontSize', 8);
title(mat2str(size(PlotMatrix,1)))
xlabel(' 25 50 75')
%
%PlotMatrix=PlotMatrix-repmat(PlotMatrix(:,2),1,size(PlotMatrix,2))
%PlotMatrix=PlotMatrix-repmat(min(PlotMatrix')',1,size(PlotMatrix,2))
%PlotMatrix=PlotMatrix./repmat(max(PlotMatrix')',1,size(PlotMatrix,2))
Matrixmean=mean(PlotMatrix)
MatrixError=std(PlotMatrix)./sqrt(size(PlotMatrix,1))
errorbar(Matrixmean,MatrixError,'k','LineWidth',2); hold on
x=[0,4]; y=[0,0]; plot(x,y,'--k','LineWidth',0.5); hold on;
[h,p]=ttest(nanmean(Resp25(:,100:400)'),0);
t=text(0.5,-12,['p value comparing to 0 = ' mat2str(p)]); set(t, 'FontSize', 8);
[h,p]=ttest(nanmean(Resp50(:,100:400)'),0);
t=text(2,-13,['p= ' mat2str(p)]); set(t, 'FontSize', 8);
[h,p]=ttest(nanmean(Resp75(:,100:400)'),0);
t=text(3.5,-14,['p= ' mat2str(p)]); set(t, 'FontSize', 8);
xlim([0 4]);
ylim([-15 15])
axis square
t=ylabel('Difference (spikes/s)'); set(t, 'FontSize', 8);
t=xlabel('Probability of reward'); set(t, 'FontSize', 8);
%xticklabels({' ','0.25','0.50','0.75'})

figure; 
nsubplot(4,4,3:4,1:1)
Rpe75d=1-0.75;
Rpe50d=1-0.50;
Rpe25d=1-0.25;
Rpe75nd=0-0.75;
Rpe50nd=0-0.50;
Rpe25nd=0-0.25;
%
plot([Rpe25d Rpe50d Rpe75d],'r','LineWidth',5); hold on
scatter([1 2 3],[Rpe25d Rpe50d Rpe75d],60,'k','filled'); hold on
%
plot([Rpe25nd Rpe50nd Rpe75nd],'b','LineWidth',5); hold on
scatter([1 2 3],[Rpe25nd Rpe50nd Rpe75nd],60,'k','filled'); hold on
%
plot([Rpe25d Rpe50d Rpe75d]-[Rpe25nd Rpe50nd Rpe75nd],'k','LineWidth',5); hold on
scatter([1 2 3],[Rpe25d Rpe50d Rpe75d]-[Rpe25nd Rpe50nd Rpe75nd],60,'k','filled'); hold on
%
x=[0,4]; y=[0,0]; plot(x,y,'--k','LineWidth',0.5); hold on;
ylim([-1 1.1])
xlim([0 4])
t=ylabel('RPE'); set(t, 'FontSize', 8);

figure; 
nsubplot(4,4,3:4,1:1)
p1=plot(NaN,'-r'); hold on
p2=plot(NaN,'-b'); hold on
p3=plot(NaN,'-k'); hold on
legend([p1 p2 p3],'Delivered','Not delivered', 'Difference')
axis off

figure; 
nsubplot(4,4,3:4,1:1)
Rpe75d=1-0.75;
Rpe50d=1-0.50;
Rpe25d=1-0.25;
Rpe75nd=(1-0.25);
Rpe50nd=(1-0.50);
Rpe25nd=(1-0.75);
plot([Rpe25d Rpe50d Rpe75d],'r','LineWidth',5); hold on
plot([Rpe25nd Rpe50nd Rpe75nd],'b','LineWidth',5); hold on
plot([Rpe25d Rpe50d Rpe75d]-[Rpe25nd Rpe50nd Rpe75nd],'k','LineWidth',5); hold on
plot([Rpe25d Rpe50d Rpe75d],'r','LineWidth',5); hold on
scatter([1 2 3],[Rpe25d Rpe50d Rpe75d],60,'k','filled'); hold on
scatter([1 2 3],[Rpe25nd Rpe50nd Rpe75nd],60,'k','filled'); hold on
scatter([1 2 3],[Rpe25d Rpe50d Rpe75d]-[Rpe25nd Rpe50nd Rpe75nd],60,'k','filled'); hold on
%
x=[0,4]; y=[0,0]; plot(x,y,'--k','LineWidth',0.5); hold on;
ylim([-1 1.1])
xlim([0 4])
t=ylabel('Surprise / abs(RPE)'); set(t, 'FontSize', 8);
title('Models')


% %set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
% set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
% print('-dpdf', 'T' );
% close all;
