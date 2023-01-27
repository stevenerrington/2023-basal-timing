figure

load('behaviorPopulationData.mat')

nsubplot(220,220,1:50,61:110);

Limit1=2000:3500;
Limit2=3500:7000;
LimitX=2000:7000;

x2=1500:5000;

ylim([0 1])
xlim([0 4500])

lower_bound=min(nanmean(LickingTargArray6104(:,Limit1)./1000));
normal_factor=max(nanmean(LickingTargArray6104(:,Limit1)./1000-lower_bound));

target=LickingTargArray6104;
lower_bound=min(nanmean(target(:,Limit1)./1000));
plt=(target(:,Limit1)./1000-lower_bound)./normal_factor;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-k', 'LineWidth', 1}, 0); hold on
plt4a=plt;

target=[LickingTargArray6101_25s_population_s; LickingTargArray6101_75l_population_s];
lower_bound=min(nanmean(target(:,Limit1)./1000));
plt=(target(:,Limit1)./1000-lower_bound)./normal_factor;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-r', 'LineWidth', 1}, 0); hold on
plt1a=plt;
%
target=LickingTargArray6101_75l_population_s;
lower_bound=min(nanmean(target(:,Limit1)./1000));
plt=(target(:,Limit2)./1000-lower_bound)./normal_factor; 
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
shadedErrorBar(x2, plt, {@nanmean, @(x) nanstd(x)./v}, {'-r', 'LineWidth', 1}, 0); hold on
plt1b=plt;

target=[LickingTargArray6102_50s_population_s; LickingTargArray6102_50l_population_s];
lower_bound=min(nanmean(target(:,Limit1)./1000));
plt=(target(:,Limit1)./1000-lower_bound)./normal_factor;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-g', 'LineWidth', 1}, 0); hold on
plt2a=plt;
%
target=LickingTargArray6102_50l_population_s;
lower_bound=min(nanmean(target(:,Limit1)./1000));
plt=(target(:,Limit2)./1000-lower_bound)./normal_factor; 
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
shadedErrorBar(x2, plt, {@nanmean, @(x) nanstd(x)./v}, {'-g', 'LineWidth', 1}, 0); hold on
plt2b=plt;

target=[LickingTargArray6103_75s_population_s; LickingTargArray6103_25l_population_s];
lower_bound=min(nanmean(target(:,Limit1)./1000));
plt=(target(:,Limit1)./1000-lower_bound)./normal_factor;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-b', 'LineWidth', 1}, 0); hold on
plt3a=plt;
%
target=LickingTargArray6103_25l_population_s;
lower_bound=min(nanmean(target(:,Limit1)./1000));
plt=(target(:,Limit2)./1000-lower_bound)./normal_factor; 
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
shadedErrorBar(x2, plt, {@nanmean, @(x) nanstd(x)./v}, {'-b', 'LineWidth', 1}, 0); hold on
plt3b=plt;

x=[1500,1500]; y=[0,max(ylim)]; plot(x,y,'k','LineWidth',2); hold on;
xlabel('time (ms)')
ylabel('magnitude of licking')

nsubplot(220,220,1:50,27:43);

Limit1=2000:3500;
Limit2=3500:7000;
LimitX=2000:7000;

x2=1500:5000;

ylim([0 1])
xlim([0 1500])

target=LickingTargArray6201;
lower_bound=min(nanmean(target(:,Limit1)./1000));
plt=(target(:,Limit1)./1000-lower_bound)./normal_factor;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-c', 'LineWidth', 1}, 0); hold on

target=[LickingTargArray6102_50s_population_s; LickingTargArray6102_50l_population_s];
lower_bound=min(nanmean(target(:,Limit1)./1000));
plt=(target(:,Limit1)./1000-lower_bound)./normal_factor;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-g', 'LineWidth', 1}, 0); hold on

x=[1500,1500]; y=[0,max(ylim)]; plot(x,y,'k','LineWidth',2); hold on;
xlabel('time (ms)')
ylabel('magnitude of licking')

%%

nsubplot(220,220,1:50,1:17);

xlim([0 5])
ylim([0 1])

plotthis1=nanmean(plt1a(:,1:1500),2); errorbar(1,nanmean(plotthis1),nanstd(plotthis1)./sqrt(length(plotthis1)),'r','LineWidth',2); hold on
plotthis2=nanmean(plt2a(:,1:1500),2); errorbar(2,nanmean(plotthis2),nanstd(plotthis2)./sqrt(length(plotthis2)),'g','LineWidth',2); hold on
plotthis3=nanmean(plt3a(:,1:1500),2); errorbar(3,nanmean(plotthis3),nanstd(plotthis3)./sqrt(length(plotthis3)),'b','LineWidth',2); hold on
plotthis4=nanmean(plt4a(:,1:1500),2); errorbar(4,nanmean(plotthis4),nanstd(plotthis4)./sqrt(length(plotthis4)),'k','LineWidth',2); hold on
plotthis5=nanmean(plt5a(:,1:1500),2); errorbar(5,nanmean(plotthis5),nanstd(plotthis5)./sqrt(length(plotthis5)),'c','LineWidth',2); hold on

plotthis1(:,2)=0.25;
plotthis2(:,2)=0.50;
plotthis3(:,2)=0.75;
plotthis4(:,2)=1.00;
plotthis5(:,2)=0.50;

ylabel('magnitude of licking')
%set(gca, 'XTick',0:5, 'XTickLabel',{'0.00' '0.25', '0.50' '0.75' '1.00' '0.50'})

minimal=min(length(plotthis1),length(plotthis2));
p=randperm(minimal);
if ranksum(plotthis1(p),plotthis2(p))<0.05
    t=text(1.5,(nanmean(plotthis1(:,1))),'*'); set(t, 'FontSize', 20);
else
    t=text(1.5,(nanmean(plotthis1(:,1))),['ns']); set(t, 'FontSize', 10);
end

minimal=min(length(plotthis2),length(plotthis3));
p=randperm(minimal);
if ranksum(plotthis2(p),plotthis3(p))<0.05
    t=text(2.5,(nanmean(plotthis2(:,1))),['*']); set(t, 'FontSize', 20);
else
    t=text(2.5,(nanmean(plotthis2(:,1))),['ns']); set(t, 'FontSize', 10);
end

minimal=min(length(plotthis3),length(plotthis4));
p=randperm(minimal);
if ranksum(plotthis3(p),plotthis4(p))<0.05
    t=text(3.5,0.9*(nanmean(plotthis3(:,1))),['*']); set(t, 'FontSize', 20);
else
    t=text(3.5,0.9*(nanmean(plotthis3(:,1))),['ns']); set(t, 'FontSize', 10);
end

minimal=min(length(plotthis2),length(plotthis5));
p=randperm(minimal);
if ranksum(plotthis2(p),plotthis5(p))<0.05
    t=text(4.5,1.1*(nanmean(plotthis5(:,1))),['*']); set(t, 'FontSize', 20);
else
    t=text(4.5,1.1*(nanmean(plotthis5(:,1))),['ns']); set(t, 'FontSize', 10);
end

minimal=min([length(plotthis1) length(plotthis2) length(plotthis3) length(plotthis4) length(plotthis5)]);
p=randperm(minimal);
all=[plotthis1(p,:);plotthis2(p,:);plotthis3(p,:);plotthis4(p,:);plotthis5(p,:)];
x1=all(:,1);
y1=all(:,2);
[rho,pvalue]=corr(x1(:),y1(:),'type','Spearman');


set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
print(sprintf('%s.pdf', 'task-input'),'-dpdf')