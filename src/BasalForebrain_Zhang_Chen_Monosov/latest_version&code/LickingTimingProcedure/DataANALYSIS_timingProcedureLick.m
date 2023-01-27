% clc; clear all; close all;
% 
% addpath('C:\Users\Ilya\Dropbox\HELPER\HELPER_GENERAL');
% addpath('C:\Users\Ilya Monosov\Dropbox\HELPER\HELPER_GENERAL');
% 
% D1=dir ('X:\MONKEYDATA\Batman\Timingprocedure_Basilforebrain\AllCombined\*.mat');
% addpath('X:\MONKEYDATA\Batman\Timingprocedure_Basilforebrain\AllCombined\');
% 
% D2=dir ('X:\MONKEYDATA\BatmanLedbetteretalandWhiteMonosovandChen(olddata)\Batman\TimingProcedure\AllCombined\*.mat');
% addpath('X:\MONKEYDATA\BatmanLedbetteretalandWhiteMonosovandChen(olddata)\Batman\TimingProcedure\AllCombined\');
% 
% D3=dir ('X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingProcedure\AllCombined\*.mat');
% addpath('X:\MONKEYDATA\WolverineLedbetteretalandWhiteMonosovandChen(olddata)\WolverineData\TimingProcedure\AllCombined\');
% 
% D4=dir ('X:\MONKEYDATA\ZOMBIE_ongoing\BF_timingprocejure\AllCombined\*.mat');
% addpath('X:\MONKEYDATA\ZOMBIE_ongoing\BF_timingprocejure\AllCombined\');
% 
% D5=dir ('X:\MONKEYDATA\Robin_ongoing\TimingProcedureBF\AllTimingProcedureBFBG\*.mat');
% addpath('X:\MONKEYDATA\Robin_ongoing\TimingProcedureBF\AllTimingProcedureBFBG\');
% 
% D=[D1; D2; D3; D4; D5;];
% clear D1 D2 D3 D4 D5
% 
% for xzv=1:length(D)
%     clc;
%     xzv
%     load(D(xzv).name,'PDS');
%     savestruct(xzv).filename=D(xzv).name;
%     durationsuntilreward=PDS(1).timeoutcome-PDS(1).timetargeton;
%     durationsuntilreward=round(durationsuntilreward*10)./10;
%     completedtrial=find(PDS.timetargeton>0);
%     
%     SkipThisSession=0;
%     try
%         try
%             deliv=find(PDS.rewardDuration>0);
%             ndeliv=find(PDS.rewardDuration==0);
%         catch
%             deliv=find(PDS.deliveredornot>0);
%             ndeliv=find(PDS.deliveredornot==0);
%         end
%     catch
%         SkipThisSession=1
%     end
%     
%     savestruct(xzv).SkipThisSession=SkipThisSession;
%     
%     if SkipThisSession==0
%         %organize trial types into indices
%         trials6201=(find(PDS(1).fractals==6201));
%         trials6201=intersect(trials6201,completedtrial);
%         trials6201n=intersect(trials6201,deliv);
%         trials6201nd=intersect(trials6201,ndeliv);
%         %
%         trials6102=intersect(find(PDS(1).fractals==6102),completedtrial); %50% LONG 50 SHORT
%         trials6102_50s=intersect(find(durationsuntilreward==1.5),trials6102);
%         trials6102_50l=intersect(find(durationsuntilreward==4.5),trials6102);
%         %
%         trials6101=intersect(find(PDS(1).fractals==6101),completedtrial); %25SHORT
%         trials6101_25s=intersect(find(durationsuntilreward==1.5),trials6101);
%         trials6101_75l=intersect(find(durationsuntilreward==4.5),trials6101);
%         %
%         trials6103=intersect(find(PDS(1).fractals==6103),completedtrial);%25LONG
%         trials6103_75s=intersect(find(durationsuntilreward==1.5),trials6103);
%         trials6103_25l=intersect(find(durationsuntilreward==4.5),trials6103);
%         %
%         trials6104=intersect(find(PDS(1).fractals==6104),completedtrial); %SHORT
%         %
%         trials6105=intersect(find(PDS(1).fractals==6105),completedtrial);
%         trials6105_25s=intersect(find(durationsuntilreward==1.5),trials6105);
%         trials6105_25ms=intersect(find(durationsuntilreward==2.5),trials6105);
%         trials6105_25ml=intersect(find(durationsuntilreward==3.5),trials6105);
%         trials6105_25l=intersect(find(durationsuntilreward==4.5),trials6105);
%         
%         [bb,aa]=butter(8,10/500,'low');
%         Lick=[];
%         GoodTrials=[];
%         LickingTargArrayProb=[];
%         for i=1:length(PDS.fractals)
%             clear x
%             if isnan(PDS.timetargeton(i))==0
%                 analogtemp_lick_butter=PDS.EyeJoy{i}(4,:);
%                 shiftdelta=round((2-PDS.timetargeton(i))*1000);
%                 analogtemp_lick_butter=filtfilt(bb,aa,analogtemp_lick_butter);
%                 if shiftdelta>0
%                     analogtemp_lick_butter=cat(2,NaN(1,shiftdelta), analogtemp_lick_butter);
%                     analogtemp_lick_butter(end-shiftdelta+1:end)=[];
%                 elseif shiftdelta<0
%                     analogtemp_lick_butter(1:1+abs(shiftdelta)-1)=[];
%                     analogtemp_lick_butter=cat(2,analogtemp_lick_butter, NaN(1,abs(shiftdelta)));
%                 end
%                 %
%                 numberofstd=2;
%                 baseline=analogtemp_lick_butter(1:2000);
%                 baseline_mean=nanmean(baseline(:));
%                 rangemin=baseline_mean-(nanstd(baseline)*numberofstd);
%                 rangemax=baseline_mean+(nanstd(baseline)*numberofstd);
%                 tempLick=analogtemp_lick_butter;
%                 tempLick(find(tempLick<rangemin | tempLick>rangemax))=999999;
%                 tempLick(find(tempLick~=999999))=0;
%                 tempLick(find(tempLick==999999))=1;
%                 tempLick(find(isnan(analogtemp_lick_butter)))=NaN;
%                 LickingTargArrayProb=[LickingTargArrayProb; tempLick];
%                 %
%                 GoodTrials=[GoodTrials; i];
%                 Lick=[Lick; analogtemp_lick_butter];
%             else
%                 x(1:10000)=NaN;
%                 Lick=[Lick; x];
%                 LickingTargArrayProb=[  LickingTargArrayProb; x];
%             end
%         end
%         numberofstd=2;
%         baseline=Lick(GoodTrials,1000:2000); %baseline from completed trials with outcomes
%         baseline=baseline(:);
%         baseline=baseline(find(isnan(baseline)==0));
%         baselinemean=mean(baseline(:));
%         rangemax=baselinemean+(std(baseline)*numberofstd);
%         rangemin=baselinemean-(std(baseline)*numberofstd);
%         Lickdetect=[];
%         for x=1:length(PDS.fractals)
%             x=Lick(x,:);
%             x(find(x>rangemax))=999999;
%             x(find(x<rangemin))=999999;
%             x(find(x~=999999))=0;
%             x(find(x==999999))=1;
%             Lickdetect=[Lickdetect; x]; clear x;
%         end
%         clear x rangemin rangemax baseline baselinemean
%         
%         %         figure;
%         %         subplot(2,1,1)
%         %         imagesc(Lickdetect)
%         %         xlim([0 10000])
%         %         subplot(2,1,2)
%         %         plot(nanmean(Lickdetect))
%         %         xlim([0 10000])
%         
%         %save sessions with reasonable licking signal
%         test=Lickdetect([trials6104],2000:3500);
%         test=nansum(test)./size(test,1);
%         if length(find(test>0.2))>200 
%             
%             Lickdetect_=plot_mean_psth({[Lickdetect]},100,1,size(Lickdetect,2),1);
%             Lickdetect_([ trials6101_25s trials6102_50s  trials6103_75s trials6104 ],3500:end)=NaN; %trials6201
%             Lickdetect_([ trials6105 ],1:end)=NaN;
%             Lickdetect_(:,6450:end)=NaN;
%             Lickdetect_(:,1:1999)=NaN;
%             %%zscore (depricated)
%             %Lickdetect_=(Lickdetect_-nanmean(Lickdetect_(:))) ./ nanstd(Lickdetect_(:));
%             %             figure
%             %             plot(nanmean(Lickdetect_(trials6104,:)),'k')
%             %             hold on
%             %             plot(nanmean(Lickdetect_(trials6103,:)),'c')
%             %             hold on
%             %             plot(nanmean(Lickdetect_(trials6101,:)),'g')
%             %             hold on
%             %             plot(nanmean(Lickdetect_(trials6102,:)),'r')
%             
%             savestruct(xzv).lick50risk=Lickdetect_([trials6201],:);
%             savestruct(xzv).lick50riskOmit=Lickdetect_([intersect(ndeliv,trials6201)],:);
%             savestruct(xzv).lick=Lickdetect_([trials6104],:);
%             savestruct(xzv).lick75=Lickdetect_([trials6103],:);
%             savestruct(xzv).lick50=Lickdetect_([trials6102],:);
%             savestruct(xzv).lick25=Lickdetect_([trials6101],:);
%             
%             savestruct(xzv).lick75l=Lickdetect_([trials6103_75s],:);
%             savestruct(xzv).lick50l=Lickdetect_([ trials6102_50l],:);
%             savestruct(xzv).lick25l=Lickdetect_([ trials6101_75l],:);
%         end
% 
%         % LOOKING ANALYSES WHICH WILL BE USED LATER FOR REACTION TIME
%         millisecondResolution=0.001;
%         Pupil=[];
%         Xeye=[];
%         Yeye=[];
%         Lick=[];
%         Blnksdetect=[];
%         %onlineLickForce
%         for x=1:length(PDS.fractals)
%             trialanalog=PDS.onlineEye{x};
%             %
%             temp=trialanalog(:,3:4);
%             relatveTimePDS = temp(:,2)-temp(1,2);
%             regularTimeVectorForPdsInterval = [0: millisecondResolution  : temp(end,2)-temp(1,2)];
%             regularPdsData = interp1(  relatveTimePDS , temp(:,1) , regularTimeVectorForPdsInterval  );
%             regularPdsData(length(regularPdsData)+1:12000)=NaN; %i do this because they may be different sizes
%             
%             %remove blinks (very crude)
%             regularPdsData(1:40)=NaN;
%             findblinks=find(regularPdsData<-4);
%             
%             temp1(1:12000)=0;
%             temp1(find(regularPdsData<-4))=1;
%             Blnksdetect=[Blnksdetect; temp1(1:12000)];
%             
%             
%             %get rid of blinks out of pupil dillation
%             if ~isempty(findblinks)==1
%                 for zz=1:length(findblinks)
%                     regularPdsData(fix(findblinks(zz))-20:fix(findblinks(zz))+40)=NaN;
%                 end
%             end
%             %
%             Pupil=[Pupil; regularPdsData(1:12000)];
%             clear regularPdsData regularTimeVectorForPdsInterval temp temp1 relatveTimePDS
%             
%             temp=trialanalog(:,[1 4]);
%             relatveTimePDS = temp(:,2)-temp(1,2);
%             regularTimeVectorForPdsInterval = [0: millisecondResolution  : temp(end,2)-temp(1,2)];
%             regularPdsData = interp1(  relatveTimePDS , temp(:,1) , regularTimeVectorForPdsInterval  );
%             regularPdsData(length(regularPdsData)+1:12000)=NaN;
%             Xeye=[Xeye; regularPdsData(1:12000)];
%             clear regularPdsData regularTimeVectorForPdsInterval temp relatveTimePDS
%             %
%             temp=trialanalog(:,[2 4]);
%             relatveTimePDS = temp(:,2)-temp(1,2);
%             regularTimeVectorForPdsInterval = [0: millisecondResolution  : temp(end,2)-temp(1,2)];
%             regularPdsData = interp1(  relatveTimePDS , temp(:,1) , regularTimeVectorForPdsInterval  );
%             regularPdsData(length(regularPdsData)+1:12000)=NaN;
%             Yeye=[Yeye; regularPdsData(1:12000)];
%             clear regularPdsData regularTimeVectorForPdsInterval temp relatveTimePDS
%             %
%             %
%         end
%         
%         
%         
%         LookingTargArray=[];
%         windowwidth=5;
%         for x=1:length(PDS.fractals)
%             tempx=Xeye(x,:);
%             tempy=Yeye(x,:);
%             
%             angs=PDS.targAngle(x);
%             amp=10;
%             amp              = round(amp-0.5); %we do this in the code in tasks, do it here too
%             location               = amp*[cosd(360-angs(1)), sind(360-angs(1))];
%             timelook=find(tempx>location(1)-windowwidth & tempx<location(1)+windowwidth & tempy>location(2)-windowwidth & tempy<location(2)+windowwidth);
%             
%             temp(1:length(tempx))=0;
%             temp(timelook)=1;
%             try
%                 temp=temp(fix(PDS.timetargeton(x)*1000):fix(PDS.timetargeton(x)*1000)+4500);
%             catch
%                 clear temp;
%                 temp(1:4501)=NaN;
%             end
%             LookingTargArray=[LookingTargArray; temp];
%             clear temp timelook amp angs tempy tempx x
%         end
%         LookingTargArray(find(PDS.targAngle==-1),:)=NaN;
%         
%         
%         RT=[];
%         TEMP=LookingTargArray;
%         TEMP(find(isnan(TEMP)==1))=0;
%         for TESTl=1:size(TEMP,1)
%             T=TEMP(TESTl,:);
%             T=T(find(mean(T')~=0),:);
%             [idx,idx] = max(T,[],2);
%             RT_=idx(find(idx>20));
%             
%             if isempty(RT_)==1
%                 RT_=NaN;
%             end
%             RT=[RT; RT_]; clear RT_ T idx 
%         end
%         clear TEMP TEMPl
%         RT(find(RT==0 | RT< 0))=NaN;
% 
%         LookingTargArray=plot_mean_psth({[LookingTargArray]},100,1,size(LookingTargArray,2),1);
%         LookingTargArray([ trials6101_25s trials6102_50s  trials6103_75s trials6104 trials6201],1500:end)=NaN;
%         LookingTargArray([ trials6105 ],1:end)=NaN;
%         
%         savestruct(xzv).look50risk= LookingTargArray([trials6201],:);
%         savestruct(xzv).look= LookingTargArray([trials6104],:);
%         savestruct(xzv).look75= LookingTargArray([trials6103],:);
%         savestruct(xzv).look50= LookingTargArray([trials6102],:);
%         savestruct(xzv).look25= LookingTargArray([trials6101],:);
%         
%         savestruct(xzv).RT50risk= RT([trials6201],:);
%         savestruct(xzv).RT= RT([trials6104],:);
%         savestruct(xzv).RT75= RT([trials6103],:);
%         savestruct(xzv).RT50= RT([trials6102],:);
%         savestruct(xzv).RT25= RT([trials6101],:);
%
%     end
%     clear PDS LookingTargArray
%     clear roc proc A1 A2 ch1 ch2 ch3 ch3 p r test x  Lickdetectm Lick
%     close all; clc;
% end
% save timingproceduresummaryBehavior.mat savestruct
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%



clc; clear all; close all;
addpath('HELPER_GENERAL');

load timingproceduresummaryBehavior.mat
doprint=1;

lick100=vertcat(savestruct(1,:).lick);
lick75=vertcat(savestruct(1,:).lick75);
lick50=vertcat(savestruct(1,:).lick50);
lick25=vertcat(savestruct(1,:).lick25);
lick50risk=vertcat(savestruct(1,:).lick50risk);
lick50risk=vertcat(savestruct(1,:).lick50risk);
lick50riskOmit=vertcat(savestruct(1,:).lick50riskOmit);


look100=vertcat(savestruct(1,:).look)./1000;
look75=vertcat(savestruct(1,:).look75)./1000;
look50=vertcat(savestruct(1,:).look50)./1000;
look25=vertcat(savestruct(1,:).look25)./1000;
look50risk=vertcat(savestruct(1,:).look50risk)./1000;

% RT=vertcat(savestruct(1,:).RT);
% RT75=vertcat(savestruct(1,:).RT75);
% RT50=vertcat(savestruct(1,:).RT50);
% RT25=vertcat(savestruct(1,:).RT25);
% RT50risk=vertcat(savestruct(1,:).RT50risk);
% RT=RT(find(RT>35))
% RT50=RT50(find(RT50>35))
% RT75=RT75(find(RT75>35))
% RT25=RT25(find(RT25>35))
% RT50risk=RT50risk(find(RT50risk>35))
% figure
% errorbar(1,nanmean(RT25),nanstd(RT25)./sqrt(length(RT25)),'r','LineWidth',2); hold on
% errorbar(2,nanmean(RT50),nanstd(RT50)./sqrt(length(RT50)),'g','LineWidth',2); hold on
% errorbar(3,nanmean(RT75),nanstd(RT75)./sqrt(length(RT75)),'b','LineWidth',2); hold on
% errorbar(4,nanmean(RT),nanstd(RT)./sqrt(length(RT)),'k','LineWidth',2); hold on
% errorbar(5,nanmean(RT50risk),nanstd(RT50risk)./sqrt(length(RT50risk)),'c','LineWidth',2); hold on
% xlim([0 6])

figure
nsubplot(220,220,1:50,61:110);

Limit1=2000:3500;
Limit2=2000:6500;

lower_bound=min(nanmean(lick100(:,Limit1)));
normal_factor=max(nanmean(lick100(:,Limit1)-lower_bound));

% lower_bound=0;
% normal_factor=1;


target=lick100;
plt=(target(:,Limit1)-lower_bound)./normal_factor;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
plt4a=plt;
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-k', 'LineWidth', 1}, 0); hold on


target=lick75;
plt=(target(:,Limit1)-lower_bound)./normal_factor;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
plt3a=plt;
plt=(target(:,Limit2)-lower_bound)./normal_factor;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-b', 'LineWidth', 1}, 0); hold on


target=lick50;
plt=(target(:,Limit1)-lower_bound)./normal_factor;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
plt2a=plt;
plt=(target(:,Limit2)-lower_bound)./normal_factor;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-g', 'LineWidth', 1}, 0); hold on


target=lick25;
plt=(target(:,Limit1)-lower_bound)./normal_factor;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
plt1a=plt;
plt=(target(:,Limit2)-lower_bound)./normal_factor;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-r', 'LineWidth', 1}, 0); hold on

target=lick50risk;
plt=(target(:,Limit1)-lower_bound)./normal_factor;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
plt5a=plt;
%shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-c', 'LineWidth', 1}, 0); hold on

x=[1500,1500]; y=[-2 2]; plot(x,y,'k','LineWidth',2); hold on;
xlim([0 4500])
ylim([-0.1 1.1])
xlabel('time (ms)')
ylabel('magnitude of licking')

%
%
%
nsubplot(220,220,1:50,1:43);
% lower_bound=min(nanmean(lick50risk(:,Limit1)));
% normal_factor=max(nanmean(lick50risk(:,Limit1)-lower_bound));

plt=plt5a; x=1:length(plt); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-c', 'LineWidth', 1}, 0); hold on

plt=plt2a; x=1:length(plt); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-g', 'LineWidth', 1}, 0); hold on

ylim([-0.1 0.6])
xlim([0 1500])








nsubplot(220,220,1:50,121:170);

%ylim([0 1])
xlim([0 6])
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
text(1,0.6,['rho=' mat2str(rho)])
text(1,0.7,['p=' mat2str(pvalue)])

if doprint==1
    set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
    print('-dpdf', 'Lick.pdf' );
    close all;
end



figure
nsubplot(220,220,1:50,61:110);

Limit1=1:1501;
Limit2=1:4501;

plt=look100;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
plt4a=plt;
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-k', 'LineWidth', 1}, 0); hold on


plt=look75; target=plt;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
plt3a=plt;
target=plt;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-b', 'LineWidth', 1}, 0); hold on

plt=look50; target=plt;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
plt2a=plt;
target=plt;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-g', 'LineWidth', 1}, 0); hold on

plt=look25; target=plt;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
plt1a=plt;
target=plt;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-r', 'LineWidth', 1}, 0); hold on

plt=look50risk; target=plt;
plt=plt(find(isnan(plt(:,1))~=1),:); x=1:length(plt); v=sqrt(size(plt,1));
plt5a=plt;
%shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-c', 'LineWidth', 1}, 0); hold on

x=[1500,1500]; y=[-2 2]; plot(x,y,'k','LineWidth',2); hold on;
xlim([0 4500])
ylim([-0.1 1.1])
xlabel('time (ms)')
ylabel('probability of looking')

% 
nsubplot(220,220,1:50,27:43);

plt=plt5a; x=1:length(plt); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-c', 'LineWidth', 1}, 0); hold on

plt=plt2a; x=1:length(plt); v=sqrt(size(plt,1));
shadedErrorBar(x, plt, {@nanmean, @(x) nanstd(x)./v}, {'-g', 'LineWidth', 1}, 0); hold on

ylim([-0.1 1.1])
xlim([0 1500])


nsubplot(220,220,1:50,121:170);

xlim([0 6])
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

ylabel('magnitude of looking')
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
text(1,0.6,['rho=' mat2str(rho)])
text(1,0.7,['p=' mat2str(pvalue)])






