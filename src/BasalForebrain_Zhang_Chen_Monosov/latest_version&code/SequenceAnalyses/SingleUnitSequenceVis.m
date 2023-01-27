clear all; clc; close all; beep off;
addpath('HELPER_GENERAL');

load('X:\MONKEYDATA\ZOMBIE_ongoing\BF_SequenceLearning\Phasic\SequenceLearning_22_01_2018_15_29.mat')
PDS.timeoutcome(end-20:end)=NaN; %ISOLATION DECREASED AT END. THROW OUT LAST 20 TRIALS

 load('X:\MONKEYDATA\ZOMBIE_ongoing\BF_SequenceLearning\Ramping\SequenceLearning_03_08_2018_15_17.mat')

gauswind=101;
showerror=9

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PDS.timeoutcome(end-100:end)=0


trials=find(PDS.Set(:,1)~=9999 & PDS.Set(:,2)~=9999 & PDS.timeoutcome'>0)

BeliefErrors=find(PDS.belieferror==1 & PDS.timeoutcome>0 & PDS.chosenwindow==0);
NoBeliefErrors=find(PDS.belieferror==0 & PDS.timeoutcome>0 & PDS.chosenwindow==0);

completedtrials=(find(PDS.timeoutcome>0));
completedtrials_notchoice=intersect(intersect(find(PDS.chosenwindow==0),completedtrials),NoBeliefErrors);
try completedtrials_notchoice=intersect(completedtrials_notchoice, find(PDS.timingerr==0)); end
try
    BeliefErrors=intersect(BeliefErrors, find(PDS.timingerr==0));
end

Set1Trials=intersect(intersect(find(PDS.WhichSet==1),completedtrials_notchoice),NoBeliefErrors)
Set2Trials=intersect(intersect(find(PDS.WhichSet==2),completedtrials_notchoice),NoBeliefErrors)

aLLTrials=intersect(intersect(find(PDS.WhichSet==1 | PDS.WhichSet==2),completedtrials_notchoice),NoBeliefErrors)


BE=PDS.Set(:,1)-PDS.Set(:,3)
BEPos2=intersect(find(BE==99),BeliefErrors)
BEPos1=intersect(find(BE==-101),BeliefErrors)

Rasters=[];
for x=1:length(PDS.timeoutcome)
    CENTER=11001;
    spike_times = PDS.sptimes{x}(PDS.spikes{x} == 65535)
    spk=spike_times-PDS(1).timeoutcome(x);
    %spk=PDS(1).sptimes{x}-PDS(1).timeoutcome(x);
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
Rasters=Rasters(:,11000-4000:11000);
SDFcs=plot_mean_psth({Rasters},gauswind,1,size(Rasters,2),1); close all;

maxplot=round(max(nanmean(SDFcs')))+10;

figure;
nsubplot(600,600,1:300,1:300)
LineFormat = struct()
LineFormat.Color = [0 0 0];
LineFormat.LineWidth = 0.5;
LineFormat.LineStyle = '-';
plotSpikeRaster(logical(flipud(Rasters(Set1Trials,:))),'PlotType','vertline','LineFormat',LineFormat); hold on;

LineFormat = struct()
LineFormat.Color = [1 0 0.3];
LineFormat.LineWidth = 0.5;
LineFormat.LineStyle = '-';
plotSpikeRaster(logical(flipud(Rasters(Set2Trials,:))),'PlotType','vertline','LineFormat',LineFormat,'VertSpikePosition',...
    length(Set1Trials)+5);

% if showerror==1
%     LineFormat = struct()
%     LineFormat.Color = [0 0 1];
%     LineFormat.LineWidth = 0.5;
%     LineFormat.LineStyle = '-';
%     plotSpikeRaster(logical(flipud(Rasters(BEPos1,:))),'PlotType','vertline','LineFormat',LineFormat,'VertSpikePosition',...
%         length([Set2Trials Set1Trials])+10);
%     
%     LineFormat = struct()
%     LineFormat.Color = [1 0 0];
%     LineFormat.LineWidth = 0.5;
%     LineFormat.LineStyle = '-';
%     plotSpikeRaster(logical(flipud(Rasters(BEPos2,:))),'PlotType','vertline','LineFormat',LineFormat,'VertSpikePosition',...
%         length([Set2Trials Set1Trials BEPos1'])+15);
% end
ylim([0 length([Set2Trials Set1Trials BEPos1' BEPos2'])+25])

% set(gca,'color','black')
% set(gcf,'color',[0.32 0.32 0.32])
% a=findobj(gcf);
% set(gca,'XColor','white')
% set(gca,'YColor','white')
% set(gca,'ZColor','white')
% alltext=findall(a,'Type','text');%'axes' 'line'
% set(alltext,'color', 'white');

nsubplot(600,600,301:600,1:301)
plot(nanmean(SDFcs(Set1Trials,:)),'Color',[0 0 0],'LineWidth',3); hold on
plot(nanmean(SDFcs(Set2Trials,:)),'Color',[1 0 0.3],'LineWidth',3); hold on
% if showerror==1
%     plot(nanmean(SDFcs(BEPos1,:)),'Color',[0 0 1],'LineWidth',.5); hold on
%     plot(nanmean(SDFcs(BEPos2,:)),'Color',[1 0 0],'LineWidth',.5); hold on
%     plot(nanmean(SDFcs(find(PDS.timingerr==1),:)),'Color',[1 1 0],'LineWidth',.5); hold on
% end
xlim([0 4000])
% set(gca,'color','black')
% set(gcf,'color',[0.32 0.32 0.32])
% a=findobj(gcf);
% set(gca,'XColor','white')
% set(gca,'YColor','white')
% set(gca,'ZColor','white')
% alltext=findall(a,'Type','text');%'axes' 'line'
% set(alltext,'color', 'white');
line([0 0], [0 maxplot],'LineWidth',1)
line([1000 1000], [0 maxplot],'LineWidth',1)
line([2000 2000], [0 maxplot],'LineWidth',1)
line([3000 3000], [0 maxplot],'LineWidth',1)




figure;
nsubplot(600,600,1:300,1:300)
LineFormat = struct()
LineFormat.Color = [0 0 0];
LineFormat.LineWidth = 0.5;
LineFormat.LineStyle = '-';
plotSpikeRaster(logical(flipud(Rasters(aLLTrials,:))),'PlotType','vertline','LineFormat',LineFormat); hold on;
ylim([0 length([Set2Trials Set1Trials BEPos1' BEPos2'])+25])
nsubplot(600,600,301:600,1:301)
plot(nanmean(SDFcs(aLLTrials,:)),'Color',[0 0 0],'LineWidth',3); hold on
xlim([0 4000])
line([0 0], [0 maxplot],'LineWidth',1)
line([1000 1000], [0 maxplot],'LineWidth',1)
line([2000 2000], [0 maxplot],'LineWidth',1)
line([3000 3000], [0 maxplot],'LineWidth',1)

line([0 500], [70 70],'LineWidth',1)
line([1000 1500], [70 70],'LineWidth',1)
line([2000 2500], [70 70],'LineWidth',1)
line([3000 3500], [70 70],'LineWidth',1)


sdf
  set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
    print('-dpdf', 'SUA' );
    close all;
    
 