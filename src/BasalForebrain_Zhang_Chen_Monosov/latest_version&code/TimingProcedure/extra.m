%{
nsubplot(220,220,1:50,121:138);
Limitz=2000:3500;
Limit2=3500:7000;
LimitX=2000:7000;
x2=1500:5000;
ylim([0 1])
xlim([0 1500])
%
target3=LickingTargArray6101_75l_population_s;
target2=LickingTargArray6101_25s_population_s;

target=LickingTargArray6201ss;
lower_bound=min(nanmean(target2(:,Limitz)./1000));
normal_factor=max(nanmean(LickingTargArray6104(:,Limitz)./1000-lower_bound));
plt=(target(:,Limitz)./1000-lower_bound)./normal_factor;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-c', 'LineWidth', 1}, 0); hold on
%

%
target=LickingTargArray6102_50s_population_s;
%lower_bound=min(nanmean(target2(:,LimitX)./1000));
plt=(target(:,Limitz)./1000-lower_bound)./normal_factor;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-g', 'LineWidth', 1}, 0); hold on
% target=LickingTargArray6102_50l_population_s;
% lower_bound=min(nanmean(target3(:,LimitX)./1000));
% plt=(target(:,Limit2)./1000-lower_bound)./normal_factor; 
% plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
% shadedErrorBar(x2, plt, {@nanmean, @(x) nanstd(x)./v}, {'-g', 'LineWidth', 1}, 0); hold on
%

%target3=LickingTargArray6101_75l_population_s;
%target2=LickingTargArray6101_25s_population_s;
target=LickingTargArray6104;
%lower_bound=min(nanmean(target2(:,LimitX)./1000));
%normal_factor=max(nanmean(LickingTargArray6104(:,Limitz)./1000-lower_bound));
plt=(target(:,Limitz)./1000-lower_bound)./normal_factor;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-k', 'LineWidth', 1}, 0); hold on


%
x=[1500,1500]; y=[0,max(ylim)]; plot(x,y,'k','LineWidth',2); hold on;
xlabel('time (ms)')
ylabel('licking (proportion of trials)')
%}

target2=LickingTargArray6101_25s_population_s;

target=LickingTargArray6104;
lower_bound=min(nanmean(target(:,Limit1)./1000));
target=target-lower_bound*1000;
plt1a=nanmean([LickingTargArray6104(:,[2500:3500])]')./1000; 

target=LickingTargArray6103_75s_population_s;
lower_bound=min(nanmean(target(:,Limit1)./1000));
target=target-lower_bound*1000;
plt2a=nanmean([LickingTargArray6103_75s_population_s(:,[2500:3500])]')./1000; 

target=LickingTargArray6102_50s_population_s;
lower_bound=min(nanmean(target2(:,LimitX)./1000));
target=target-lower_bound*1000;
plt3a=nanmean([LickingTargArray6102_50s_population_s(:,[2500:3500])]')./1000; 

target=LickingTargArray6101_25s_population_s;
lower_bound=min(nanmean(target2(:,LimitX)./1000));
target=target-lower_bound*1000;
plt4a=nanmean([LickingTargArray6101_25s_population_s(:,[2500:3500])]')./1000; 

target=LickingTargArray6201ss;
lower_bound=min(nanmean(target2(:,LimitX)./1000));
target=target-lower_bound*1000;
plt5a=nanmean([LickingTargArray6201ss(:,[2500:3500])]')./1000; 


% minimal=min(length(plotthis1),length(plotthis2));
% p=randperm(minimal);
% if ranksum(plotthis1(p),plotthis2(p))<0.05
%     t=text(1.5,(nanmean(plotthis1)),['*']); set(t, 'FontSize', 20);
% else
%     t=text(1.5,(nanmean(plotthis1)),['ns']); set(t, 'FontSize', 10);
% end
% 
% minimal=min(length(plotthis2),length(plotthis3));
% p=randperm(minimal);
% if ranksum(plotthis2(p),plotthis3(p))<0.05
%     t=text(2.5,(nanmean(plotthis2)),['*']); set(t, 'FontSize', 20);
% else
%     t=text(2.5,(nanmean(plotthis2)),['ns']); set(t, 'FontSize', 10);
% end
% 
% minimal=min(length(plotthis3),length(plotthis4));
% p=randperm(minimal);
% if ranksum(plotthis3(p),plotthis4(p))<0.05
%     t=text(3.5,0.9*(nanmean(plotthis3)),['*']); set(t, 'FontSize', 20);
% else
%     t=text(3.5,0.9*(nanmean(plotthis3)),['ns']); set(t, 'FontSize', 10);
% end
% 
% minimal=min(length(plotthis4),length(plotthis5));
% p=randperm(minimal);
% if ranksum(plotthis4(p),plotthis5(p))<0.05
%     t=text(4.5,1.1*(nanmean(plotthis5)),['*']); set(t, 'FontSize', 20);
% else
%     t=text(4.5,1.1*(nanmean(plotthis5)),['ns']); set(t, 'FontSize', 10);
% end


%%
nsubplot(220,220,51:100,1:17);
%target=LickingTargArray6104;
%lower_bound=min(nanmean(target2(:,LimitX)./1000));
%LickingTargArray6104=LickingTargArray6104-lower_bound*1000;
%plt1a=nanmean([LickingTargArray6104(:,[5500:6500])]')./1000; 
%
target=LickingTargArray6103_25l_population_s;
lower_bound=min(nanmean(target3(:,LimitX)./1000));
%LickingTargArray6103_75s_population_s=LickingTargArray6103_75s_population_s-nanmean(nanmean(LickingTargArray6103_75s_population_s(:,1:100)));
target=target-lower_bound*1000;
plt2a=nanmean([target(:,[5500:6500])]')./1000; 
%
target=LickingTargArray6102_50l_population_s;
lower_bound=min(nanmean(target3(:,LimitX)./1000));
%LickingTargArray6102_50s_population_s=LickingTargArray6102_50s_population_s-nanmean(nanmean(LickingTargArray6102_50s_population_s(:,1:100)));
target=target-lower_bound*1000;
plt3a=nanmean([target(:,[5500:6500])]')./1000; 
%
target=LickingTargArray6101_75l_population_s;
lower_bound=min(nanmean(target3(:,LimitX)./1000));
%LickingTargArray6101_25s_population_s=LickingTargArray6101_25s_population_s-nanmean(nanmean(LickingTargArray6101_25s_population_s(:,1:100)));
target=target-lower_bound*1000;
plt4a=nanmean([target(:,[5500:6500])]')./1000; 
%
%target=LickingTargArray6201ss;
%lower_bound=min(nanmean(target2(:,LimitX)./1000));
%%LickingTargArray6201ss=LickingTargArray6201ss-nanmean(nanmean(LickingTargArray6201ss(:,1:100)));
%LickingTargArray6201ss=LickingTargArray6201ss-lower_bound*1000;
%plt5a=nanmean([LickingTargArray6201ss(:,[5500:6500])]')./1000; 
%
normal=normal_factor*10/2;
%
xlim([0 5])
ylim([0 1])
%
%plotthis=plt1a; errorbar(4,normal*nanmean(plotthis),nanstd(plotthis)./sqrt(length(plotthis)),'k','LineWidth',2); hold on
plotthis=plt2a; errorbar(3,normal*nanmean(plotthis),nanstd(plotthis)./sqrt(length(plotthis)),'b','LineWidth',2); hold on
plotthis=plt3a; errorbar(2,normal*nanmean(plotthis),nanstd(plotthis)./sqrt(length(plotthis)),'g','LineWidth',2); hold on
plotthis=plt4a; errorbar(1,normal*nanmean(plotthis),nanstd(plotthis)./sqrt(length(plotthis)),'r','LineWidth',2); hold on
%plotthis=plt5a; errorbar(5,normal*nanmean(plotthis),nanstd(plotthis)./sqrt(length(plotthis)),'c','LineWidth',2); hold on
%plot([3 2],normal*[nanmean(plt2a)  nanmean(plt3a)],'k','LineWidth',1); hold on
minimal=min(length(plt3a),length(plt4a));
if signrank(plt3a(1:minimal),plt4a(1:minimal))<0.05
    t=text(1.5,normal*nanmean(plt3a),['*']); set(t, 'FontSize', 20);
else
    t=text(1.5,normal*nanmean(plt3a),['ns']); set(t, 'FontSize', 10);
end
minimal=min(length(plt2a),length(plt3a));
if signrank(plt2a(1:minimal),plt3a(1:minimal))<0.05
    t=text(2.5,normal*nanmean(plt2a),['*']); set(t, 'FontSize', 20);
else
    t=text(2.5,normal*nanmean(plt2a),['ns']); set(t, 'FontSize', 10);
end
% minimal=min(length(plt2a),length(plt1a));
% if signrank(plt2a(1:minimal),plt1a(1:minimal))<0.05
%     t=text(3.5,normal*0.9*nanmean(plt1a),['*']); set(t, 'FontSize', 20);
% else
%     t=text(3.5,normal*0.9*nanmean(plt1a),['ns']); set(t, 'FontSize', 10);
% end
%
% minimal=min(length(plt3a),length(plt5a));
% if signrank(plt3a(1:minimal),plt5a(1:minimal))<0.05
%     t=text(4.5,normal*1.1*nanmean(plt5a),['*']); set(t, 'FontSize', 20);
% else
%     t=text(4.5,normal*1.1*nanmean(plt5a),['ns']); set(t, 'FontSize', 10);
% end
ylabel('licking (proportion of trials)')
set(gca, 'XTick',0:5, 'XTickLabel',{'\color{red}x\newline\color{red}1-x' '\color{red}0.25\newline\color{red}0.75', '\color{red}0.50\newline\color{red}0.50' '\color{red}0.75\newline\color{red}0.25' '\color{red}1.00\newline\color{black}0.00' '\color{red}0.50\newline\color{black}0.50'})
%

set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
print(sprintf('%s.pdf', 'task-input'),'-dpdf')
