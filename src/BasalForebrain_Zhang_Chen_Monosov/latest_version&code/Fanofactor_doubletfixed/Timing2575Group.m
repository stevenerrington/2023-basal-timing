addpath('HELPER_GENERAL');
PRINTYESORNO=0;

savestruct(xzv).name=DDD(iii).name;
savestruct(xzv).monkey=DDD(iii).MONKEYID; 
%savestruct(xzv).celltype = DDD(iii).celltype;

%freereward=find(PDS.freeoutcometype==1 & PDS.timesoffreeoutcomes_first>0)
%freeflash=find(PDS.freeoutcometype==34 & PDS.timesoffreeoutcomes_first>0)

durationsuntilreward=PDS(1).timeoutcome-PDS(1).timetargeton;
durationsuntilreward=round(durationsuntilreward*10)./10;
completedtrial=find(durationsuntilreward>0); %was the trial completed
deliv=intersect(find(PDS.timeoutcome>0),find( PDS.rewardduration>0)); %was reward delivered or not
ndeliv=intersect(find(PDS.timeoutcome>0),find( PDS.rewardduration==0));
%
prob100=intersect(completedtrial,find(PDS.fractals==9800));
prob75=intersect(completedtrial,find(PDS.fractals==9801));
prob50=intersect(completedtrial,find(PDS.fractals==9802));
prob25=intersect(completedtrial,find(PDS.fractals==9803));
prob0=intersect(completedtrial,find(PDS.fractals==9804));
%
a100=intersect(completedtrial,find(PDS.fractals==9805));
a75=intersect(completedtrial,find(PDS.fractals==9806));
a50=intersect(completedtrial,find(PDS.fractals==9807));
a25=intersect(completedtrial,find(PDS.fractals==9808));
a0=intersect(completedtrial,find(PDS.fractals==9809));
%
prob75d=intersect(prob75,deliv);
prob75nd=intersect(prob75,ndeliv);
prob50d=intersect(prob50,deliv);
prob50nd=intersect(prob50,ndeliv);
prob25d=intersect(prob25,deliv);
prob25nd=intersect(prob25,ndeliv);


savestruct(xzv).prob75ndl=length(prob75nd);
savestruct(xzv).prob25dl=length(prob25d);


CENTER=6001;
Rasters=[];
for x=1:length(durationsuntilreward)
    %
         spike_times = PDS.sptimes{x}(PDS.spikes{x} == 65535);
        spk=spike_times-PDS(1).timetargeton(x);
    spk=(spk*1000)+CENTER-1;
    spk=fix(spk);
    %
    spk=spk(find(spk<CENTER*2));
    %
    temp(1:CENTER*2)=0;
    temp(spk)=1;
    Rasters=[Rasters; temp];
    %
    clear temp spk x
end


% CENTER=6001;
% RastersFree=[];
% for x=1:length(PDS.timesoffreeoutcomes_first)
%     %
%     spk=PDS(1).sptimes{x}-PDS(1).timetargeton(x);
%     spk=(spk*1000)+CENTER-1;
%     spk=fix(spk);
%     %
%     spk=spk(find(spk<CENTER*2));
%     %
%     temp(1:CENTER*2)=0;
%     temp(spk)=1;
%     RastersFree=[RastersFree; temp];
%     %
%     clear temp spk x
% end
% SDFFREE=plot_mean_psth({RastersFree},gauswindow_ms,1,size(RastersFree,2),1); %make spike density functions for displaying and average across neurons for displaying
% SDFFREE=SDFFREE(:,6000-500:7000);

cleanreward50n=intersect(prob75,ndeliv);
cleanreward50=intersect(prob75,deliv);
if ~isempty(cleanreward50n)==1 & ~isempty(cleanreward50)==1
    for x=1:length(cleanreward50)
        spk_dirty=Rasters(cleanreward50(x),:);
        
        cleanreward50n=cleanreward50n(randperm(length(cleanreward50n)));
        spk_clean=Rasters(cleanreward50n(1),:);
        
        spk_dirty(7500-45:7500+15)=spk_clean(7500-45:7500+15);
        Rasters(cleanreward50(x),:)=spk_dirty;
        clear spk_dirty spk_clean x
    end
end

cleanreward50n=intersect(prob50,ndeliv);
cleanreward50=intersect(prob50,deliv);
if ~isempty(cleanreward50n)==1 & ~isempty(cleanreward50)==1
    for x=1:length(cleanreward50)
        spk_dirty=Rasters(cleanreward50(x),:);
        
        cleanreward50n=cleanreward50n(randperm(length(cleanreward50n)));
        spk_clean=Rasters(cleanreward50n(1),:);
        
        spk_dirty(7500-45:7500+15)=spk_clean(7500-45:7500+15);
        Rasters(cleanreward50(x),:)=spk_dirty;
        clear spk_dirty spk_clean x
    end
end

cleanreward50n=intersect(prob25,ndeliv);
cleanreward50=intersect(prob25,deliv);
if ~isempty(cleanreward50n)==1 & ~isempty(cleanreward50)==1
    for x=1:length(cleanreward50)
        spk_dirty=Rasters(cleanreward50(x),:);
        
        cleanreward50n=cleanreward50n(randperm(length(cleanreward50n)));
        spk_clean=Rasters(cleanreward50n(1),:);
        
        spk_dirty(7500-45:7500+15)=spk_clean(7500-45:7500+15);
        Rasters(cleanreward50(x),:)=spk_dirty;
        clear spk_dirty spk_clean x
    end
end

cleantrials=prob100;
cleantrials_copy=cleantrials;
if ~isempty(cleantrials)==1
    for x=1:length(cleantrials)
        spk_dirty=Rasters(cleantrials(x),:);
        cleantrials_copy=cleantrials_copy(randperm(length(cleantrials_copy)));
        spk_clean=Rasters(cleantrials_copy(1),:);
        spk_dirty(7500-15:7500+15)=spk_clean(7500-15-30:7500-15);
        Rasters(cleantrials(x),:)=spk_dirty;
        clear spk_dirty spk_clean x
    end
end

cleantrials=a100;
cleantrials_copy=cleantrials;
if ~isempty(cleantrials)==1
    for x=1:length(cleantrials)
        spk_dirty=Rasters(cleantrials(x),:);
        cleantrials_copy=cleantrials_copy(randperm(length(cleantrials_copy)));
        spk_clean=Rasters(cleantrials_copy(1),:);
        spk_dirty(7500-15:7500+15)=spk_clean(7500-15-30:7500-15);
        Rasters(cleantrials(x),:)=spk_dirty;
        clear spk_dirty spk_clean x
    end
end

cleantrials=a75;
cleantrials_copy=cleantrials;
if ~isempty(cleantrials)==1
    for x=1:length(cleantrials)
        spk_dirty=Rasters(cleantrials(x),:);
        cleantrials_copy=cleantrials_copy(randperm(length(cleantrials_copy)));
        spk_clean=Rasters(cleantrials_copy(1),:);
        spk_dirty(7500-15:7500+15)=spk_clean(7500-15-30:7500-15);
        Rasters(cleantrials(x),:)=spk_dirty;
        clear spk_dirty spk_clean x
    end
end

cleantrials=a50;
cleantrials_copy=cleantrials;
if ~isempty(cleantrials)==1
    for x=1:length(cleantrials)
        spk_dirty=Rasters(cleantrials(x),:);
        cleantrials_copy=cleantrials_copy(randperm(length(cleantrials_copy)));
        spk_clean=Rasters(cleantrials_copy(1),:);
        spk_dirty(7500-15:7500+15)=spk_clean(7500-15-30:7500-15);
        Rasters(cleantrials(x),:)=spk_dirty;
        clear spk_dirty spk_clean x
    end
end
cleantrials=a25;
cleantrials_copy=cleantrials;
if ~isempty(cleantrials)==1
    for x=1:length(cleantrials)
        spk_dirty=Rasters(cleantrials(x),:);
        cleantrials_copy=cleantrials_copy(randperm(length(cleantrials_copy)));
        spk_clean=Rasters(cleantrials_copy(1),:);
        spk_dirty(7500-15:7500+15)=spk_clean(7500-15-30:7500-15);
        Rasters(cleantrials(x),:)=spk_dirty;
        clear spk_dirty spk_clean x
    end
end
%%%
Rasters=Rasters(:,6000-5000:6000+5000);
Rasterscs=Rasters;
%%%
%%%
SDFcs_n=[];
for R=1:size(Rasterscs,1)
    sdf=Smooth_Histogram(Rasterscs(R,:),3);
    SDFcs_n=[SDFcs_n; sdf;];
end
SDFcs_nC= SDFcs_n;

SDFcs_n=plot_mean_psth({Rasterscs},gauswindow_ms,1,size(Rasterscs,2),1); %make spike density functions for displaying and average across neurons for displaying

%Average rasters in Bins
binwindow = [0:50];
binstep = 20;
BinRasters = [];
Bintime = [];

for i = 1: floor((length(Rasterscs)-length(binwindow))/binstep)+1
    iii = (i-1)*binstep+1;
    BinRasters(:,i) = sum(Rasterscs(:, iii+binwindow),2)./length(binwindow)*1000;
    Bintime(1,i) = iii+median(binwindow)/2-5000-2500; % align 0 on the outcome of reward
end

%for analyses use RASTERS (spike count)
Rasters=Rasters(:,5000-1000-500:5000+2500+1000);




%PostRasterAnalysis;
%%%%%%%%%%%%%%% for clastering
temp=SDFcs_n([a100 a75 a50 a25 a0],5000-1000:7500);
Amt_=nanmean(temp);
temp=SDFcs_n([prob100 prob75 prob50 prob25 prob0],5000-1000:7500);
Prob_=nanmean(temp);
Amt_=(Amt_-nanmean(Amt_(1:1000)));
Prob_=(Prob_-nanmean(Prob_(1:1000)));

Amt_=smooth([Amt_(1:1500) Amt_(end-1000:end)],100)';
Prob_=smooth([Prob_(1:1500) Prob_(end-1000:end)],100)';



savestruct(xzv).Amt_=Amt_;
savestruct(xzv).Prob_=Prob_;

Amt_=Amt_(1000:end);
Prob_=Prob_(1000:end);

All_=[Amt_'; [NaN NaN NaN]'; Prob_'];
All_=All_-min(All_);
All_=All_./max(All_);
savestruct(xzv).All_=All_;
clear temp
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% freereward=find(PDS.freeoutcometype==1 & PDS.timesoffreeoutcomes_first>0)
% freeflash=find(PDS.freeoutcometype==34 & PDS.timesoffreeoutcomes_first>0)

% if length(freereward)>2 & length(freeflash)>2
%     savestruct(xzv).FFLASH= (nanmean(SDFFREE(freeflash,:)));
%     savestruct(xzv).FREWARD= (nanmean(SDFFREE(freereward,:)));
% else
%     T(1:1501)=NaN;
%     savestruct(xzv).FFLASH= T;
%     savestruct(xzv).FREWARD= T;
% end

% T(1:1501)=NaN;
% savestruct(xzv).FFLASH= T;
% savestruct(xzv).FREWARD= T;

%%%%%% cancel free reward%%%%%%%%% 
%averages
% analysiswindow=[5050:5500];
% p100=nanmean(SDFcs_n(prob100,analysiswindow)');
% p75=nanmean(SDFcs_n(prob75,analysiswindow)');
% p50=nanmean(SDFcs_n(prob50,analysiswindow)');
% p25=nanmean(SDFcs_n(prob25,analysiswindow)');
% p0=nanmean(SDFcs_n(prob0,analysiswindow)');
% a100_=nanmean(SDFcs_n(a100,analysiswindow)');
% a75_=nanmean(SDFcs_n(a75,analysiswindow)');
% a50_=nanmean(SDFcs_n(a50,analysiswindow)');
% a25_=nanmean(SDFcs_n(a25,analysiswindow)');
% a0_=nanmean(SDFcs_n(a0,analysiswindow)');
% probtrials=fliplr([nanmean(p100) nanmean(p75) nanmean(p50) nanmean(p25) nanmean(p0)]);
% amttrials=fliplr([nanmean(a100_) nanmean(a75_) nanmean(a50_) nanmean(a25_) nanmean(a0_)]);
% savestruct(xzv).probtrialsE=probtrials;
% savestruct(xzv). amttrialsE=amttrials;

% analysiswindow=[7000:7500];
% p100=nanmean(SDFcs_n(prob100,analysiswindow)');
% p75=nanmean(SDFcs_n(prob75,analysiswindow)');
% p50=nanmean(SDFcs_n(prob50,analysiswindow)');
% p25=nanmean(SDFcs_n(prob25,analysiswindow)');
% p0=nanmean(SDFcs_n(prob0,analysiswindow)');
% a100_=nanmean(SDFcs_n(a100,analysiswindow)');
% a75_=nanmean(SDFcs_n(a75,analysiswindow)');
% a50_=nanmean(SDFcs_n(a50,analysiswindow)');
% a25_=nanmean(SDFcs_n(a25,analysiswindow)');
% a0_=nanmean(SDFcs_n(a0,analysiswindow)');
% probtrials=fliplr([nanmean(p100) nanmean(p75) nanmean(p50) nanmean(p25) nanmean(p0)]);
% amttrials=fliplr([nanmean(a100_) nanmean(a75_) nanmean(a50_) nanmean(a25_) nanmean(a0_)]);
% savestruct(xzv).probtrials=probtrials;
% savestruct(xzv). amttrials=amttrials;


%baseline
normtemp=[SDFcs_n];
normtemp=nanmean(nanmean(normtemp(:,4000-1000:4000-500)));%check if spike is recorded here, before the start cu
savestruct(xzv).baseline = normtemp;

%%%spike density functions
%%%% from 0 to 500ms 
popwindow=[5000:5500];
savestruct(xzv).actp100s=nanmean(SDFcs_n(prob100,popwindow));
savestruct(xzv).actp75s=nanmean(SDFcs_n(prob75,popwindow));
savestruct(xzv).actp75ds=nanmean(SDFcs_n(prob75d,popwindow));
savestruct(xzv).actp75nds=nanmean(SDFcs_n(prob75nd,popwindow));
savestruct(xzv).actp50s=nanmean(SDFcs_n(prob50,popwindow));
savestruct(xzv).actp50ds=nanmean(SDFcs_n(prob50d,popwindow));
savestruct(xzv).actp50nds=nanmean(SDFcs_n(prob50nd,popwindow));
savestruct(xzv).actp25s=nanmean(SDFcs_n(prob25,popwindow));
savestruct(xzv).actp25ds=nanmean(SDFcs_n(prob25d,popwindow));
savestruct(xzv).actp25nds=nanmean(SDFcs_n(prob25nd,popwindow));
savestruct(xzv).actp0s=nanmean(SDFcs_n(prob0,popwindow));
savestruct(xzv).acta100s=nanmean(SDFcs_n(a100,popwindow));
savestruct(xzv).acta75s=nanmean(SDFcs_n(a75,popwindow));
savestruct(xzv).acta50s=nanmean(SDFcs_n(a50,popwindow));
savestruct(xzv).acta25s=nanmean(SDFcs_n(a25,popwindow));
savestruct(xzv).acta0s=nanmean(SDFcs_n(a0,popwindow));


popwindow=[4000:5000+3500];
savestruct(xzv).actp100sA=nanmean(SDFcs_n(prob100,popwindow));
savestruct(xzv).actp75sA=nanmean(SDFcs_n(prob75,popwindow));
savestruct(xzv).actp75dsA=nanmean(SDFcs_n(prob75d,popwindow));
savestruct(xzv).actp75ndsA=nanmean(SDFcs_n(prob75nd,popwindow));
savestruct(xzv).actp50sA=nanmean(SDFcs_n(prob50,popwindow));
savestruct(xzv).actp50dsA=nanmean(SDFcs_n(prob50d,popwindow));
savestruct(xzv).actp50ndsA=nanmean(SDFcs_n(prob50nd,popwindow));
savestruct(xzv).actp25sA=nanmean(SDFcs_n(prob25,popwindow));
savestruct(xzv).actp25dsA=nanmean(SDFcs_n(prob25d,popwindow));
savestruct(xzv).actp25ndsA=nanmean(SDFcs_n(prob25nd,popwindow));
savestruct(xzv).actp0sA=nanmean(SDFcs_n(prob0,popwindow));
savestruct(xzv).acta100sA=nanmean(SDFcs_n(a100,popwindow));
savestruct(xzv).acta75sA=nanmean(SDFcs_n(a75,popwindow));
savestruct(xzv).acta50sA=nanmean(SDFcs_n(a50,popwindow));
savestruct(xzv).acta25sA=nanmean(SDFcs_n(a25,popwindow));
savestruct(xzv).acta0sA=nanmean(SDFcs_n(a0,popwindow));


%%%% from 2000 to 2500
popwindow=[7000:7500];
savestruct(xzv).actp100l=nanmean(SDFcs_n(prob100,popwindow));
savestruct(xzv).actp75l=nanmean(SDFcs_n(prob75,popwindow));
savestruct(xzv).actp75dl=nanmean(SDFcs_n(prob75d,popwindow));
savestruct(xzv).actp75ndl=nanmean(SDFcs_n(prob75nd,popwindow));
savestruct(xzv).actp50l=nanmean(SDFcs_n(prob50,popwindow));
savestruct(xzv).actp50dl=nanmean(SDFcs_n(prob50d,popwindow));
savestruct(xzv).actp50ndl=nanmean(SDFcs_n(prob50nd,popwindow));
savestruct(xzv).actp25l=nanmean(SDFcs_n(prob25,popwindow));
savestruct(xzv).actp25dl=nanmean(SDFcs_n(prob25d,popwindow));
savestruct(xzv).actp25ndl=nanmean(SDFcs_n(prob25nd,popwindow));
savestruct(xzv).actp0l=nanmean(SDFcs_n(prob0,popwindow));
savestruct(xzv).acta100l=nanmean(SDFcs_n(a100,popwindow));
savestruct(xzv).acta75l=nanmean(SDFcs_n(a75,popwindow));
savestruct(xzv).acta50l=nanmean(SDFcs_n(a50,popwindow));
savestruct(xzv).acta25l=nanmean(SDFcs_n(a25,popwindow));
savestruct(xzv).acta0l=nanmean(SDFcs_n(a0,popwindow));

%from 2500 to 3500 outcomewindow.
popwindow=[7500:7500+1000];
savestruct(xzv).actp100R=nanmean(SDFcs_n(prob100,popwindow));
savestruct(xzv).actp75R=nanmean(SDFcs_n(prob75,popwindow));
savestruct(xzv).actp75dR=nanmean(SDFcs_n(prob75d,popwindow));
savestruct(xzv).actp75ndR=nanmean(SDFcs_n(prob75nd,popwindow));
savestruct(xzv).actp50R=nanmean(SDFcs_n(prob50,popwindow));
savestruct(xzv).actp50dR=nanmean(SDFcs_n(prob50d,popwindow));
savestruct(xzv).actp50ndR=nanmean(SDFcs_n(prob50nd,popwindow));
savestruct(xzv).actp25R=nanmean(SDFcs_n(prob25,popwindow));
savestruct(xzv).actp25dR=nanmean(SDFcs_n(prob25d,popwindow));
savestruct(xzv).actp25ndR=nanmean(SDFcs_n(prob25nd,popwindow));
savestruct(xzv).actp0R=nanmean(SDFcs_n(prob0,popwindow));

% from outcome-500 to the end
popwindow=[5000+2500-500:7500+2000];
savestruct(xzv).actp100=nanmean(SDFcs_n(prob100,popwindow));
savestruct(xzv).actp75=nanmean(SDFcs_n(prob75,popwindow));
savestruct(xzv).actp75d=nanmean(SDFcs_n(prob75d,popwindow));
savestruct(xzv).actp75nd=nanmean(SDFcs_n(prob75nd,popwindow));
savestruct(xzv).actp50=nanmean(SDFcs_n(prob50,popwindow));
savestruct(xzv).actp50d=nanmean(SDFcs_n(prob50d,popwindow));
savestruct(xzv).actp50nd=nanmean(SDFcs_n(prob50nd,popwindow));
savestruct(xzv).actp25=nanmean(SDFcs_n(prob25,popwindow));
savestruct(xzv).actp25d=nanmean(SDFcs_n(prob25d,popwindow));
savestruct(xzv).actp25nd=nanmean(SDFcs_n(prob25nd,popwindow));
savestruct(xzv).actp0=nanmean(SDFcs_n(prob0,popwindow));
savestruct(xzv).acta100=nanmean(SDFcs_n(a100,popwindow));
savestruct(xzv).acta75=nanmean(SDFcs_n(a75,popwindow));
savestruct(xzv).acta50=nanmean(SDFcs_n(a50,popwindow));
savestruct(xzv).acta25=nanmean(SDFcs_n(a25,popwindow));
savestruct(xzv).acta0=nanmean(SDFcs_n(a0,popwindow));

%trial by trial sDFcs
% popwindow = [5000+2500-500:7500+2000];
% savestruct(xzv).raw_SDFcs_actp100=SDFcs_n(prob100,popwindow);
% savestruct(xzv).raw_SDFcs_actp75=SDFcs_n(prob75,popwindow);
% savestruct(xzv).raw_SDFcs_actp75d=SDFcs_n(prob75d,popwindow);
% savestruct(xzv).raw_SDFcs_actp75nd=SDFcs_n(prob75nd,popwindow);
% savestruct(xzv).raw_SDFcs_actp50=SDFcs_n(prob50,popwindow);
% savestruct(xzv).raw_SDFcs_actp50d=SDFcs_n(prob50d,popwindow);
% savestruct(xzv).raw_SDFcs_actp50nd=SDFcs_n(prob50nd,popwindow);
% savestruct(xzv).raw_SDFcs_actp25=SDFcs_n(prob25,popwindow);
% savestruct(xzv).raw_SDFcs_actp25d=SDFcs_n(prob25d,popwindow);
% savestruct(xzv).raw_SDFcs_actp25nd=SDFcs_n(prob25nd,popwindow);
% savestruct(xzv).raw_SDFcs_actp0=SDFcs_n(prob0,popwindow);

%%%% calculate the raster spike
popwindow=[5000+2500-500:7500+2000];
savestruct(xzv).raster_actp100=nanmean(Rasterscs(prob100,popwindow));
savestruct(xzv).raster_actp75=nanmean(Rasterscs(prob75,popwindow));
savestruct(xzv).raster_actp75d=nanmean(Rasterscs(prob75d,popwindow));
savestruct(xzv).raster_actp75nd=nanmean(Rasterscs(prob75nd,popwindow));
savestruct(xzv).raster_actp50=nanmean(Rasterscs(prob50,popwindow));
savestruct(xzv).raster_actp50d=nanmean(Rasterscs(prob50d,popwindow));
savestruct(xzv).raster_actp50nd=nanmean(Rasterscs(prob50nd,popwindow));
savestruct(xzv).raster_actp25=nanmean(Rasterscs(prob25,popwindow));
savestruct(xzv).raster_actp25d=nanmean(Rasterscs(prob25d,popwindow));
savestruct(xzv).raster_actp25nd=nanmean(Rasterscs(prob25nd,popwindow));
savestruct(xzv).raster_actp0=nanmean(Rasterscs(prob0,popwindow));

%raw raster spike

%front trial start to 1000+trialend
popwindow = [5000+2500-500:7500+2000];
savestruct(xzv).raw_raster_actp100=Rasterscs(prob100,popwindow);
savestruct(xzv).raw_raster_actp75=Rasterscs(prob75,popwindow);
savestruct(xzv).raw_raster_actp75d=Rasterscs(prob75d,popwindow);
savestruct(xzv).raw_raster_actp75nd=Rasterscs(prob75nd,popwindow);
savestruct(xzv).raw_raster_actp50=Rasterscs(prob50,popwindow);
savestruct(xzv).raw_raster_actp50d=Rasterscs(prob50d,popwindow);
savestruct(xzv).raw_raster_actp50nd=Rasterscs(prob50nd,popwindow);
savestruct(xzv).raw_raster_actp25=Rasterscs(prob25,popwindow);
savestruct(xzv).raw_raster_actp25d=Rasterscs(prob25d,popwindow);
savestruct(xzv).raw_raster_actp25nd=Rasterscs(prob25nd,popwindow);
savestruct(xzv).raw_raster_actp0=Rasterscs(prob0,popwindow);

%Bin analysis
%Spike density in time bin
%front trial start-1000 to trialend+1000
popwindow = find (Bintime>=-500 & Bintime<=2000);
savestruct(xzv).bin_time = Bintime(1,popwindow);
savestruct(xzv).bin_actp100=nanmean(BinRasters(prob100,popwindow),1);
savestruct(xzv).bin_actp75=nanmean(BinRasters(prob75,popwindow),1);
savestruct(xzv).bin_actp75d=nanmean(BinRasters(prob75d,popwindow),1);
savestruct(xzv).bin_actp75nd=nanmean(BinRasters(prob75nd,popwindow),1);
savestruct(xzv).bin_actp50=nanmean(BinRasters(prob50,popwindow),1);
savestruct(xzv).bin_actp50d=nanmean(BinRasters(prob50d,popwindow),1);
savestruct(xzv).bin_actp50nd=nanmean(BinRasters(prob50nd,popwindow),1);
savestruct(xzv).bin_actp25=nanmean(BinRasters(prob25,popwindow),1);
savestruct(xzv).bin_actp25d=nanmean(BinRasters(prob25d,popwindow),1);
savestruct(xzv).bin_actp25nd=nanmean(BinRasters(prob25nd,popwindow),1);
savestruct(xzv).bin_actp0=nanmean(BinRasters(prob0,popwindow),1);


%Spike density in time bin(raw)
%front trial start-1000 to trialend+1000
popwindow = find (Bintime>=-500 & Bintime<=2000);
savestruct(xzv).raw_bin_time = Bintime(1,popwindow);
savestruct(xzv).raw_bin_actp100=BinRasters(prob100,popwindow);
savestruct(xzv).raw_bin_actp75=BinRasters(prob75,popwindow);
savestruct(xzv).raw_bin_actp75d=BinRasters(prob75d,popwindow);
savestruct(xzv).raw_bin_actp75nd=BinRasters(prob75nd,popwindow);
savestruct(xzv).raw_bin_actp50=BinRasters(prob50,popwindow);
savestruct(xzv).raw_bin_actp50d=BinRasters(prob50d,popwindow);
savestruct(xzv).raw_bin_actp50nd=BinRasters(prob50nd,popwindow);
savestruct(xzv).raw_bin_actp25=BinRasters(prob25,popwindow);
savestruct(xzv).raw_bin_actp25d=BinRasters(prob25d,popwindow);
savestruct(xzv).raw_bin_actp25nd=BinRasters(prob25nd,popwindow);
savestruct(xzv).raw_bin_actp0=BinRasters(prob0,popwindow);



%%% z-score value
popwindow = [5000-1000:7500+1000];
savestruct(xzv).mean_for_zscore =  nanmean(nansum(Rasterscs(:,popwindow)'))./length(popwindow).*1000;
savestruct(xzv).std_for_zscore = nanstd(nansum(Rasterscs(:,popwindow)'))./length(popwindow).*1000;

%%%%%%Fanofactor

%RangeAn=[5000-1500:5000+749, 7500-750:7500+1000];
RangeAn=[5000-1500:5000+1500+1000];

RastersFano=Rasterscs(:,RangeAn);
trialtypesall=[ length(prob50)
    length(prob75)
    length(prob25)
    ];
fano75inc= RastersFano (prob75,:);
fano50inc= RastersFano (prob50,:);
fano25inc= RastersFano (prob25,:);
fano0inc = RastersFano (prob0,:);
fanoAllinc= RastersFano ([prob25 prob50 prob75],:);
fano100inc= RastersFano (prob100,:);

fano75nd= RastersFano (prob75nd,:);
fano50nd= RastersFano (prob50nd,:);
fano25nd= RastersFano (prob25nd,:);
fano0nd= RastersFano (prob0,:);
fanoAll= RastersFano ([prob25nd prob50nd prob75nd],:); %%%%75 50 25 long dilivery.


FanoSaveAll=[];
FanoSaveAllinc=[];
for x = 1:size(RastersFano,2)-100
    binAnalysis=[x:x+100];
    
    t= fanoAll(:,binAnalysis); t=nansum(t')';
    FanoSaveAll=[ FanoSaveAll; (std(t)^2)./mean(t)]; clear t
    
    
    t= fanoAllinc(:,binAnalysis); t=nansum(t')';
    FanoSaveAllinc=[ FanoSaveAllinc; (std(t)^2)./mean(t)]; clear t
    
end
savestruct(xzv). All_FanoSaveAllomit= FanoSaveAll';
savestruct(xzv). All_FanoSaveAll= FanoSaveAllinc';

if isempty(find(trialtypesall<4))==1
    
    %savestruct(xzv).filename=D(xzv).name;
    savestruct(xzv).SDF75omit= nanmean(SDFcs_n(prob75nd,RangeAn));
    savestruct(xzv).SDF50omit= nanmean(SDFcs_n(prob50nd,RangeAn));
    savestruct(xzv).SDF25omit= nanmean(SDFcs_n(prob25nd,RangeAn));
    savestruct(xzv).SDF0omit= nanmean(SDFcs_n(prob0,RangeAn));
    
    savestruct(xzv).AllSDFomit= nanmean(SDFcs_n([prob25nd prob50nd prob75nd],RangeAn));
    
    savestruct(xzv).SDF100= nanmean(SDFcs_n(prob100,RangeAn));
    savestruct(xzv).SDF75= nanmean(SDFcs_n(prob75,RangeAn));
    savestruct(xzv).SDF50= nanmean(SDFcs_n(prob50,RangeAn));
    savestruct(xzv).SDF25= nanmean(SDFcs_n(prob25,RangeAn));
    savestruct(xzv).SDF0= nanmean(SDFcs_n(prob0,RangeAn));
    
    savestruct(xzv).AllSDF= nanmean(SDFcs_n([prob25 prob50 prob75],RangeAn));
    
    
    
    FanoSave25=[];  FanoSave50=[];  FanoSave75=[];  FanoSave0=[]; FanoSaveAll=[]; FanoSave100=[];
    FanoSaveAllinc=[]; FanoSave25inc=[];  FanoSave50inc=[];  FanoSave75inc=[];
    for x = 1:size(RastersFano,2)-100
        binAnalysis=[x:x+100];
        
        t= fanoAll(:,binAnalysis); t=nansum(t')';
        FanoSaveAll=[ FanoSaveAll; (std(t)^2)./mean(t)]; clear t
        
        t= fano0nd(:,binAnalysis); t=nansum(t')';
        FanoSave0=[ FanoSave0; (std(t)^2)./mean(t)]; clear t
        
        t= fano75nd(:,binAnalysis); t=nansum(t')';
        FanoSave75=[ FanoSave75; (std(t)^2)./mean(t)]; clear t
        
        t= fano50nd(:,binAnalysis); t=nansum(t')';
        FanoSave50=[ FanoSave50; (std(t)^2)./mean(t)]; clear t
        
        t= fano25nd(:,binAnalysis); t=nansum(t')';
        FanoSave25=[ FanoSave25; (std(t)^2)./mean(t)]; clear t
        
        
        t= fanoAllinc(:,binAnalysis); t=nansum(t')';
        FanoSaveAllinc=[ FanoSaveAllinc; (std(t)^2)./mean(t)]; clear t
        
        t= fano75inc(:,binAnalysis); t=nansum(t')';
        FanoSave75inc=[ FanoSave75inc; (std(t)^2)./mean(t)]; clear t
        
        t= fano50inc(:,binAnalysis); t=nansum(t')';
        FanoSave50inc=[ FanoSave50inc; (std(t)^2)./mean(t)]; clear t
        
        t= fano25inc(:,binAnalysis); t=nansum(t')';
        FanoSave25inc=[ FanoSave25inc; (std(t)^2)./mean(t)]; clear t
        
          t= fano100inc(:,binAnalysis); t=nansum(t')';
        FanoSave100=[ FanoSave100; (std(t)^2)./mean(t)]; clear t
        
    end
    
    SmoothBin=1;
    savestruct(xzv). FanoSaveAllomit= smooth(FanoSaveAll',SmoothBin)';
    savestruct(xzv). FanoSave0=  smooth(FanoSave0',SmoothBin)';
    savestruct(xzv). FanoSave75omit=  smooth(FanoSave75',SmoothBin)';
    savestruct(xzv). FanoSave50omit=  smooth(FanoSave50',SmoothBin)';
    savestruct(xzv). FanoSave25omit=  smooth(FanoSave25',SmoothBin)';
    savestruct(xzv). FanoSaveAll= smooth(FanoSaveAllinc',SmoothBin)';
    savestruct(xzv). FanoSave75=  smooth(FanoSave75inc',SmoothBin)';
    savestruct(xzv). FanoSave50=  smooth(FanoSave50inc',SmoothBin)';
    savestruct(xzv). FanoSave25=  smooth(FanoSave25inc',SmoothBin)';
    savestruct(xzv). FanoSave100=  smooth(FanoSave100',SmoothBin)';
    
    %Raw data
    savestruct(xzv). raw_FanoSaveAllomit= FanoSaveAll';
    savestruct(xzv). raw_FanoSave0= FanoSave0';
    savestruct(xzv). raw_FanoSave75omit= FanoSave75';
    savestruct(xzv). raw_FanoSave50omit= FanoSave50';
    savestruct(xzv). raw_FanoSave25omit= FanoSave25';
    savestruct(xzv). raw_FanoSaveAll= FanoSaveAllinc';
    savestruct(xzv). raw_FanoSave75= FanoSave75inc';
    savestruct(xzv). raw_FanoSave50= FanoSave50inc';
    savestruct(xzv). raw_FanoSave25= FanoSave25inc';
end
%end of Fano


%%%%%% print sampling data
% popwindow = [5000:5000+2500];
% figure;
% plot(nanmean(SDFcs_n(prob100,popwindow)),'r');hold on;
% plot(nanmean(SDFcs_n(prob75,popwindow)),'m');hold on;
% plot(nanmean(SDFcs_n(prob50,popwindow)),'b');hold on;
% plot(nanmean(SDFcs_n(prob25,popwindow)),'g');hold on;
% plot(nanmean(SDFcs_n(prob0,popwindow)),'k');
% title([savestruct(xzv).celltype,' ', savestruct(xzv).name]);
% print(savestruct(xzv).name(1:end-4),'-dpng')
% 
% close all;
%%%%%%%%%%%%%%%%%%%%%%%%


if PRINTYESORNO==1
    popwindow=[5000-1000-750:7500+1500];
    actp100=nanmean(SDFcs_n(prob100,popwindow));
    actp75=nanmean(SDFcs_n(prob75,popwindow));
    actp75d=nanmean(SDFcs_n(prob75d,popwindow));
    actp75nd=nanmean(SDFcs_n(prob75nd,popwindow));
    actp50=nanmean(SDFcs_n(prob50,popwindow));
    actp50d=nanmean(SDFcs_n(prob50d,popwindow));
    actp50nd=nanmean(SDFcs_n(prob50nd,popwindow));
    actp25=nanmean(SDFcs_n(prob25,popwindow));
    actp25d=nanmean(SDFcs_n(prob25d,popwindow));
    actp25nd=nanmean(SDFcs_n(prob25nd,popwindow));
    actp0=nanmean(SDFcs_n(prob0,popwindow));
    
    figure
    RSTP=20;
    nsubplot(165,165,100:121,20:40)
    h1=area((actp100));
    h1.FaceColor = 'red';
    axis([0 6000 0 100]);
    x=[750,750]; y=[0,150]; plot(x,y,'k'); hold on;
    clear x
    x=[1750,1750]; y=[0,150]; plot(x,y,'k'); hold on;
    clear x
    x=[4250,4250]; y=[0,150]; plot(x,y,'k'); hold on;
    clear x
    xuncert=[Rasterscs(prob100,5000-1000-750:7500+1500)];
    xt=[];
    rasts=[];
    for tq=1:size(xuncert,1)
        Z=xuncert(tq,:);
        Z(find(Z==1))=(find(Z==1));
        Z(find(Z==0))=NaN;
        xt_=length(find(Z>0));
        if isempty(xt_)==1
            xt_=NaN;
        end
        xt=[xt; xt_];
        rasts=[rasts; Z];
        clear Z tq xt_
    end
    MatPlot(1:size(xuncert,1),1:max(xt))=NaN;
    for tq=1:size(xuncert,1)
        temptq=find(rasts(tq,:)>0);
        MatPlot(tq,1:length(temptq))=temptq;
    end
    rastList=MatPlot;
    rasIntv=1;
    LWidth=1;
    LColor='k';
    maxY_rast=tq+RSTP;
    
    for line = 1:size(rastList,1)
        hold on
        curY_rast = maxY_rast-rasIntv*line;
        plot([rastList(line,:); rastList(line,:)],...
            [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
            (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor )
    end
    clear xuncert rasts MatPlot rastList
    ylim([0 PlotYm])
    
    
    nsubplot(165,165,100:121,46:66)
    h1=area((actp75));
    h1.FaceColor = 'red';
    axis([0 6000 0 100]);
    xlabel('time(s)')
    x=[750,750]; y=[0,150]; plot(x,y,'k'); hold on;
    clear x
    x=[1750,1750]; y=[0,150]; plot(x,y,'k'); hold on;
    clear x
    x=[4250,4250]; y=[0,150]; plot(x,y,'k'); hold on;
    clear x
    xuncert=[Rasterscs(prob75,5000-1000-750:7500+1500)];
    xt=[];
    rasts=[];
    for tq=1:size(xuncert,1)
        Z=xuncert(tq,:);
        Z(find(Z==1))=(find(Z==1));
        Z(find(Z==0))=NaN;
        xt_=length(find(Z>0));
        if isempty(xt_)==1
            xt_=NaN;
        end
        xt=[xt; xt_];
        rasts=[rasts; Z];
        clear Z tq xt_
    end
    MatPlot(1:size(xuncert,1),1:max(xt))=NaN;
    for tq=1:size(xuncert,1)
        temptq=find(rasts(tq,:)>0);
        MatPlot(tq,1:length(temptq))=temptq;
    end
    rastList=MatPlot;
    rasIntv=1;
    LWidth=1;
    LColor='k';
    maxY_rast=tq+RSTP;
    
    for line = 1:size(rastList,1)
        hold on
        curY_rast = maxY_rast-rasIntv*line;
        plot([rastList(line,:); rastList(line,:)],...
            [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
            (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor )
    end
    clear xuncert rasts MatPlot rastList
    ylim([0 PlotYm])
    
    
    nsubplot(165,165,100:121,72:92)
    h1=area((actp50));
    h1.FaceColor = 'red';
    axis([0 6000 0 100]);
    
    x=[750,750]; y=[0,150]; plot(x,y,'k'); hold on;
    clear x
    x=[1750,1750]; y=[0,150]; plot(x,y,'k'); hold on;
    clear x
    x=[4250,4250]; y=[0,150]; plot(x,y,'k'); hold on;
    clear x
    xuncert=[Rasterscs(prob50,5000-1000-750:7500+1500)];
    xt=[];
    rasts=[];
    for tq=1:size(xuncert,1)
        Z=xuncert(tq,:);
        Z(find(Z==1))=(find(Z==1));
        Z(find(Z==0))=NaN;
        xt_=length(find(Z>0));
        if isempty(xt_)==1
            xt_=NaN;
        end
        xt=[xt; xt_];
        rasts=[rasts; Z];
        clear Z tq xt_
    end
    MatPlot(1:size(xuncert,1),1:max(xt))=NaN;
    for tq=1:size(xuncert,1)
        temptq=find(rasts(tq,:)>0);
        MatPlot(tq,1:length(temptq))=temptq;
    end
    rastList=MatPlot;
    rasIntv=1;
    LWidth=1;
    LColor='k';
    maxY_rast=tq+RSTP;
    
    for line = 1:size(rastList,1)
        hold on
        curY_rast = maxY_rast-rasIntv*line;
        plot([rastList(line,:); rastList(line,:)],...
            [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
            (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor )
    end
    clear xuncert rasts MatPlot rastList
    ylim([0 PlotYm])
    
    
    
    nsubplot(165,165,100:121,98:118)
    h1=area((actp25));
    h1.FaceColor = 'red';
    axis([0 6000 0 100]);
    
    x=[750,750]; y=[0,150]; plot(x,y,'k'); hold on;
    clear x
    x=[1750,1750]; y=[0,150]; plot(x,y,'k'); hold on;
    clear x
    x=[4250,4250]; y=[0,150]; plot(x,y,'k'); hold on;
    clear x
    xuncert=[Rasterscs(prob25,5000-1000-750:7500+1500)];
    xt=[];
    rasts=[];
    for tq=1:size(xuncert,1)
        Z=xuncert(tq,:);
        Z(find(Z==1))=(find(Z==1));
        Z(find(Z==0))=NaN;
        xt_=length(find(Z>0));
        if isempty(xt_)==1
            xt_=NaN;
        end
        xt=[xt; xt_];
        rasts=[rasts; Z];
        clear Z tq xt_
    end
    MatPlot(1:size(xuncert,1),1:max(xt))=NaN;
    for tq=1:size(xuncert,1)
        temptq=find(rasts(tq,:)>0);
        MatPlot(tq,1:length(temptq))=temptq;
    end
    rastList=MatPlot;
    rasIntv=1;
    LWidth=1;
    LColor='k';
    maxY_rast=tq+RSTP;
    
    for line = 1:size(rastList,1)
        hold on
        curY_rast = maxY_rast-rasIntv*line;
        plot([rastList(line,:); rastList(line,:)],...
            [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
            (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor )
    end
    clear xuncert rasts MatPlot rastList
    ylim([0 PlotYm])
    
    
    nsubplot(165,165,100:121,124:144)
    h5=area((actp0));
    h5.FaceColor = 'green';
    axis([0 6000 0 100]);
    x=[750,750]; y=[0,150]; plot(x,y,'k'); hold on;
    clear x
    x=[1750,1750]; y=[0,150]; plot(x,y,'k'); hold on;
    clear x
    x=[4250,4250]; y=[0,150]; plot(x,y,'k'); hold on;
    clear x
    xuncert=[Rasterscs(prob0,5000-1000-750:7500+1500)];
    xt=[];
    rasts=[];
    for tq=1:size(xuncert,1)
        Z=xuncert(tq,:);
        Z(find(Z==1))=(find(Z==1));
        Z(find(Z==0))=NaN;
        xt_=length(find(Z>0));
        if isempty(xt_)==1
            xt_=NaN;
        end
        xt=[xt; xt_];
        rasts=[rasts; Z];
        clear Z tq xt_
    end
    MatPlot(1:size(xuncert,1),1:max(xt))=NaN;
    for tq=1:size(xuncert,1)
        temptq=find(rasts(tq,:)>0);
        MatPlot(tq,1:length(temptq))=temptq;
    end
    rastList=MatPlot;
    rasIntv=1;
    LWidth=1;
    LColor='k';
    maxY_rast=tq+RSTP;
    
    for line = 1:size(rastList,1)
        hold on
        curY_rast = maxY_rast-rasIntv*line;
        plot([rastList(line,:); rastList(line,:)],...
            [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
            (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor )
    end
    clear xuncert rasts MatPlot rastList
    ylim([0 PlotYm])
    
    
    
    set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
    print('-djpeg', [['Save_'] '_' mat2str(loopCounter)] );
end


clc;
close all;




