addpath('HELPER_GENERAL');
PRINTYESORNO=0;

savestruct(xzv).name=DDD(iii).name;
savestruct(xzv).monkey=DDD(iii).MONKEYID; 

freereward=find(PDS.freeoutcometype==1 & PDS.timesoffreeoutcomes_first>0)
freeflash=find(PDS.freeoutcometype==34 & PDS.timesoffreeoutcomes_first>0)

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
    spk=PDS(1).sptimes{x}-PDS(1).timetargeton(x);
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


CENTER=6001;
RastersFree=[];
for x=1:length(PDS.timesoffreeoutcomes_first)
    %
    spk=PDS(1).sptimes{x}-PDS(1).timetargeton(x);
    spk=(spk*1000)+CENTER-1;
    spk=fix(spk);
    %
    spk=spk(find(spk<CENTER*2));
    %
    temp(1:CENTER*2)=0;
    temp(spk)=1;
    RastersFree=[RastersFree; temp];
    %
    clear temp spk x
end
SDFFREE=plot_mean_psth({RastersFree},gauswindow_ms,1,size(RastersFree,2),1); %make spike density functions for displaying and average across neurons for displaying
SDFFREE=SDFFREE(:,6000-500:7000);

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

%for analyses use RASTERS (spike count)
Rasters=Rasters(:,5000-1000-500:5000+2500+1000);




PostRasterAnalysis;



%
% %for ploting
% Rasterscs=Rasters;
% SDFcs_n=plot_mean_psth({Rasterscs},gauswindow_ms,1,(CENTER*2)-2,1); %make spike density functions for displaying and average across neurons for displaying
%
% %for analyses use RASTERS (spike count)
% Rasters=Rasters(:,11000-1000-500:11000+2500+1000);
%
% %%%
%
%
% %%%%%%%%%%PUT PDS_ TESTER FOR CELLS THAT WERE COMBINED AND CONTAIN PDS and
% %%%%%%%%%%PDS_
%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ch1=Rasters(prob100,1500:1500+2500);
% ch2=Rasters(prob75,1500:1500+2500);
% ch3=Rasters(prob50,1500:1500+2500);
% ch4=Rasters(prob25,1500:1500+2500);
% ch5=Rasters(prob0,1500:1500+2500);
%
% Corval=[];
% CorvalP=[];
% Corunc=[];
% CoruncP=[];
% SingleVector=[];
% SingleVectorID=[];
% for x = 1:size(ch1,2)-BinForStat
%     %x
%     tic
%     t1=ch1(:,x:x+BinForStat);
%     t2=ch2(:,x:x+BinForStat);
%     t3=ch3(:,x:x+BinForStat);
%     t4=ch1(:,x:x+BinForStat);
%     t5=ch5(:,x:x+BinForStat);
%     t1=nansum(t1')'; t2=nansum(t2')'; t3=nansum(t3')'; t4=nansum(t4')'; t5=nansum(t5')';
%     t1(1:length(t1),2)=5;
%     t2(1:length(t2),2)=4;
%     t3(1:length(t3),2)=3;
%     t4(1:length(t4),2)=2;
%     t5(1:length(t5),2)=1;
%     temp=[t1; t2; t3; t4; t5];
%     [Pval,Rval]=permutation_pair_test_fast(temp(:,1),temp(:,2),NumberofPermutations,'corr');
%
%
%     Corval=[Corval; Rval];
%     CorvalP=[CorvalP; Pval];
%
%     clear temp t1 t2 t3 t4 t5
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     t1=ch1(:,x:x+BinForStat);
%     t2=ch2(:,x:x+BinForStat);
%     t3=ch3(:,x:x+BinForStat);
%     t4=ch1(:,x:x+BinForStat);
%     t5=ch5(:,x:x+BinForStat);
%     t1=nansum(t1')'; t2=nansum(t2')'; t3=nansum(t3')'; t4=nansum(t4')'; t5=nansum(t5')';
%     t1(1:length(t1),2)=0; %values based on STD of normalized reward (prob dist)
%     t2(1:length(t2),2)=0.5;
%     t3(1:length(t3),2)=0.57;
%     t4(1:length(t4),2)=0.5;
%     t5(1:length(t5),2)=0;
%     temp=[t1; t2; t3; t4; t5];
%     [Punc,Runc]=permutation_pair_test_fast(temp(:,1),temp(:,2),NumberofPermutations,'corr');
%
%     Corunc=[Corunc; Runc];
%     CoruncP=[CoruncP; Punc];
%
%
%     if Punc>=CorTh
%         Runc=0;
%     end
%     if Pval>=CorTh
%         Rval=0;
%     end
%     D=0;
%
%
%     if abs(Rval)>=abs(Runc)
%         V=abs(Rval);
%         D=1;
%     elseif abs(Rval)<abs(Runc)
%         V=abs(Runc)*-1;
%         D=2;
%     elseif isnan(Rval)==1
%         V=0;
%         D=1;
%     else
%         crash %crash here
%     end
%
%     SingleVector=[SingleVector; V];
%     SingleVectorID=[SingleVectorID; D];
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     clear temp t1 t2 t3 t4 t5 Runc Punc Pval Rval V D
%     toc
% end
% savestruct(xzv).SingleVectorID=SingleVectorID';
% savestruct(xzv).SingleVector=SingleVector';
% savestruct(xzv).Corunc=Corunc';
% savestruct(xzv).Corval=Corval';
% savestruct(xzv).CoruncP=CoruncP';
% savestruct(xzv).CorvalP=CorvalP';
% savestruct(xzv).CorTh=CorTh;
% savestruct(xzv).BinSize=BinForStat;
%
% figure; plot(SingleVector)
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ch1=Rasters(a100,1500:1500+2500);
% ch2=Rasters(a75,1500:1500+2500);
% ch3=Rasters(a50,1500:1500+2500);
% ch4=Rasters(a25,1500:1500+2500);
% ch5=Rasters(a0,1500:1500+2500);
%
% Corval=[];
% CorvalP=[];
% Corunc=[];
% CoruncP=[];
% SingleVector=[];
% SingleVectorID=[];
% for x = 1:size(ch1,2)-BinForStat
%     %x
%     tic
%     t1=ch1(:,x:x+BinForStat);
%     t2=ch2(:,x:x+BinForStat);
%     t3=ch3(:,x:x+BinForStat);
%     t4=ch1(:,x:x+BinForStat);
%     t5=ch5(:,x:x+BinForStat);
%     t1=nansum(t1')'; t2=nansum(t2')'; t3=nansum(t3')'; t4=nansum(t4')'; t5=nansum(t5')';
%     t1(1:length(t1),2)=5;
%     t2(1:length(t2),2)=4;
%     t3(1:length(t3),2)=3;
%     t4(1:length(t4),2)=2;
%     t5(1:length(t5),2)=1;
%     temp=[t1; t2; t3; t4; t5];
%     [Pval,Rval]=permutation_pair_test_fast(temp(:,1),temp(:,2),NumberofPermutations,'corr');
%
%
%     Corval=[Corval; Rval];
%     CorvalP=[CorvalP; Pval];
%
%     clear temp t1 t2 t3 t4 t5
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%     t1=ch1(:,x:x+BinForStat);
%     t2=ch2(:,x:x+BinForStat);
%     t3=ch3(:,x:x+BinForStat);
%     t4=ch1(:,x:x+BinForStat);
%     t5=ch5(:,x:x+BinForStat);
%     t1=nansum(t1')'; t2=nansum(t2')'; t3=nansum(t3')'; t4=nansum(t4')'; t5=nansum(t5')';
%     t1(1:length(t1),2)=0; %values based on STD of normalized reward (prob dist)
%     t2(1:length(t2),2)=0.5;
%     t3(1:length(t3),2)=0.57;
%     t4(1:length(t4),2)=0.5;
%     t5(1:length(t5),2)=0;
%     temp=[t1; t2; t3; t4; t5];
%     [Punc,Runc]=permutation_pair_test_fast(temp(:,1),temp(:,2),NumberofPermutations,'corr');
%
%     Corunc=[Corunc; Runc];
%     CoruncP=[CoruncP; Punc];
%
%
%     if Punc>=CorTh
%         Runc=0;
%     end
%     if Pval>=CorTh
%         Rval=0;
%     end
%     D=0;
%
%
%     if abs(Rval)>=abs(Runc)
%         V=abs(Rval);
%         D=1;
%     elseif abs(Rval)<abs(Runc)
%         V=abs(Runc)*-1;
%         D=2;
%     elseif isnan(Rval)==1
%         V=0;
%         D=1;
%     else
%         crash %crash here
%     end
%
%     SingleVector=[SingleVector; V];
%     SingleVectorID=[SingleVectorID; D];
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     clear temp t1 t2 t3 t4 t5 Runc Punc Pval Rval V D
%     toc
% end
% savestruct(xzv).SingleVectorID_a=SingleVectorID';
% savestruct(xzv).SingleVector_a=SingleVector';
% savestruct(xzv).Corunc_a=Corunc';
% savestruct(xzv).Corval_a=Corval';
% savestruct(xzv).CoruncP_a=CoruncP';
% savestruct(xzv).CorvalP_a=CorvalP';
% savestruct(xzv).CorTh_a=CorTh;
% savestruct(xzv).BinSize_a=BinForStat;
%
% figure; plot(SingleVector)
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ch1=Rasters(prob75d,4020:5000);
% ch2=Rasters(prob75nd,4020:5000);
% ch3=Rasters(prob50d,4020:5000);
% ch4=Rasters(prob50nd,4020:5000);
% ch5=Rasters(prob25d,4020:5000);
% ch6=Rasters(prob25nd,4020:5000);
%
% Corval=[];
% CorvalP=[];
% Corunc=[];
% CoruncP=[];
% SingleVector=[];
% SingleVectorID=[];
% for x = 1:size(ch1,2)-BinForStat
%     %x
%     tic
%     t1=ch1(:,x:x+BinForStat);
%     t2=ch2(:,x:x+BinForStat);
%     t3=ch3(:,x:x+BinForStat);
%     t4=ch1(:,x:x+BinForStat);
%     t5=ch5(:,x:x+BinForStat);
%     t6=ch6(:,x:x+BinForStat);
%     t1=nansum(t1')'; t2=nansum(t2')'; t3=nansum(t3')'; t4=nansum(t4')'; t5=nansum(t5')'; t6=nansum(t6')';
%     t1=t1-nanmean(t2);
%     t3=t3-nanmean(t4);
%     t5=t5-nanmean(t6);
%     t1(1:length(t1),2)=1;
%     t3(1:length(t3),2)=2;
%     t5(1:length(t5),2)=3;
%     temp=[t1; t3; t5];
%     [Pval,Rval]=permutation_pair_test_fast(temp(:,1),temp(:,2),NumberofPermutations,'corr');
%
%
%     Corval=[Corval; Rval];
%     CorvalP=[CorvalP; Pval];
%
%     clear temp t1 t2 t3 t4 t5
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         t1=ch1(:,x:x+BinForStat);
%     t2=ch2(:,x:x+BinForStat);
%     t3=ch3(:,x:x+BinForStat);
%     t4=ch1(:,x:x+BinForStat);
%     t5=ch5(:,x:x+BinForStat);
%     t6=ch6(:,x:x+BinForStat);
%     t1=nansum(t1')'; t2=nansum(t2')'; t3=nansum(t3')'; t4=nansum(t4')'; t5=nansum(t5')'; t6=nansum(t6')';
%     t1=t1-nanmean(t2);
%     t3=t3-nanmean(t4);
%     t5=t5-nanmean(t6);
%     t1(1:length(t1),2)=1;
%     t3(1:length(t3),2)=2;
%     t5(1:length(t5),2)=1;
%     temp=[t1; t3; t5];
%     [Punc,Runc]=permutation_pair_test_fast(temp(:,1),temp(:,2),NumberofPermutations,'corr');
%     Corunc=[Corunc; Runc];
%     CoruncP=[CoruncP; Punc];
%
%
%     if Punc>=CorTh
%         Runc=0;
%     end
%     if Pval>=CorTh
%         Rval=0;
%     end
%     D=0;
%     if abs(Rval)>=abs(Runc)
%         V=abs(Rval);
%         D=1;
%     elseif abs(Rval)<abs(Runc)
%         V=abs(Runc)*-1;
%         D=2;
%     elseif isnan(Rval)==1
%         V=0;
%         D=1;
%     else
%         crash %crash here
%     end
%
%     SingleVector=[SingleVector; V];
%     SingleVectorID=[SingleVectorID; D];
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     clear temp t1 t2 t3 t4 t5 Runc Punc Pval Rval V D
%     toc
% end
% savestruct(xzv).SingleVectorIDRPE=SingleVectorID';
% savestruct(xzv).SingleVectorRPE=SingleVector';
% savestruct(xzv).CoruncRPE=Corunc';
% savestruct(xzv).CorvalRPE=Corval';
% savestruct(xzv).CoruncPRPE=CoruncP';
% savestruct(xzv).CorvalPRPE=CorvalP';
%
% figure; plot(SingleVector)
%
%


freereward=find(PDS.freeoutcometype==1 & PDS.timesoffreeoutcomes_first>0)
freeflash=find(PDS.freeoutcometype==34 & PDS.timesoffreeoutcomes_first>0)

if length(freereward)>2 & length(freeflash)>2
    savestruct(xzv).FFLASH= (nanmean(SDFFREE(freeflash,:)));
    savestruct(xzv).FREWARD= (nanmean(SDFFREE(freereward,:)));
else
    T(1:1501)=NaN;
    savestruct(xzv).FFLASH= T;
    savestruct(xzv).FREWARD= T;
end

%averages
analysiswindow=[5050:5500];
p100=nanmean(SDFcs_n(prob100,analysiswindow)');
p75=nanmean(SDFcs_n(prob75,analysiswindow)');
p50=nanmean(SDFcs_n(prob50,analysiswindow)');
p25=nanmean(SDFcs_n(prob25,analysiswindow)');
p0=nanmean(SDFcs_n(prob0,analysiswindow)');
a100_=nanmean(SDFcs_n(a100,analysiswindow)');
a75_=nanmean(SDFcs_n(a75,analysiswindow)');
a50_=nanmean(SDFcs_n(a50,analysiswindow)');
a25_=nanmean(SDFcs_n(a25,analysiswindow)');
a0_=nanmean(SDFcs_n(a0,analysiswindow)');
probtrials=fliplr([nanmean(p100) nanmean(p75) nanmean(p50) nanmean(p25) nanmean(p0)]);
amttrials=fliplr([nanmean(a100_) nanmean(a75_) nanmean(a50_) nanmean(a25_) nanmean(a0_)]);
savestruct(xzv).probtrialsE=probtrials;
savestruct(xzv). amttrialsE=amttrials;

analysiswindow=[7000:7500];
p100=nanmean(SDFcs_n(prob100,analysiswindow)');
p75=nanmean(SDFcs_n(prob75,analysiswindow)');
p50=nanmean(SDFcs_n(prob50,analysiswindow)');
p25=nanmean(SDFcs_n(prob25,analysiswindow)');
p0=nanmean(SDFcs_n(prob0,analysiswindow)');
a100_=nanmean(SDFcs_n(a100,analysiswindow)');
a75_=nanmean(SDFcs_n(a75,analysiswindow)');
a50_=nanmean(SDFcs_n(a50,analysiswindow)');
a25_=nanmean(SDFcs_n(a25,analysiswindow)');
a0_=nanmean(SDFcs_n(a0,analysiswindow)');
probtrials=fliplr([nanmean(p100) nanmean(p75) nanmean(p50) nanmean(p25) nanmean(p0)]);
amttrials=fliplr([nanmean(a100_) nanmean(a75_) nanmean(a50_) nanmean(a25_) nanmean(a0_)]);
savestruct(xzv).probtrials=probtrials;
savestruct(xzv). amttrials=amttrials;

%%%spike density functions
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

popwindow=[5000-1000-750:7500+1500];
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





close all;
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




