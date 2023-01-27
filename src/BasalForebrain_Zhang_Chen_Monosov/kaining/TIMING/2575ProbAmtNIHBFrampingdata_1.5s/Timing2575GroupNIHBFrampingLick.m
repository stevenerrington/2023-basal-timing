
align_signal='evtime.targetontime';
savestruct(xzv).name=TESTFILE;
savestruct(xzv).monkey=MONKEYID_; clear MONKEYID_
PRINTYESORNO=0;

T(1:1501)=NaN;
savestruct(xzv).FFLASH= T;
savestruct(xzv).FREWARD=T;
clear T;




% ana_fractal_set=3; %1 is set 1 only; 2 is set 2 only; %3 is all sets
% threshfix=4; %window size

%event codes used in C NIH system (REX); also find trials
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lefttrials=5502;
righttrials=4501;
centertrials=3500;
prob100=2011;
prob75rew=2016;
prob75norew=2017;
prob50rew=2014;
prob50norew=2015;
prob25rew=2012;
prob25norew=2013;
prob0=2018;
amount100=2021;
amount75=2022;
amount50=2023;
amount25=2024;
amount0=2025;
TRIALSTART=1001;
CUECD	=		1050;
REWCD=			1030;
AIRCD=			1990;
TARGONCD	=	1100;
TARGOFFCD	=	1101;
REWOFFCD=		1037;
EYEIN = 5555;
EYEATSTIM = 6666;


CD=[];
for x=1:size(d,2)
    CODES=[];
    TIMES=[];
    for y=1:size(d(x).Events,2)
        CODES=[CODES;  d(x).Events(y).Code];
        TIMES=[TIMES;  d(x).Events(y).Time];
    end
    codes(x).save=CODES;
    codes(x).time=TIMES;
    CD=[CD; CODES;];
    clear CODES y x TIMES
end
AllCodes=unique(CD);
size(codes,2)


CDS1=[];
for x=1:size(d,2)
    if isempty(find(codes(x).save==8880))==1
    else
        CDS1=[CDS1; x];
    end
end
CDS2=[];
for x=1:size(d,2)
    if isempty(find(codes(x).save==8881))==1
    else
        CDS2=[CDS2; x];
    end
end

%if size(d,2)>40 
    
    possiblevalues=[2011;2012;2013;2014;2015;2016;2017;2018;2021;2022;2023;2024;2025; 2091; 2098; 2094];
    findcodes=[];
    for x=1:size(d,2)
        temp=intersect(codes(x).save,possiblevalues);
        if isempty(temp)~=1
            %temp=posiblelocations(temp);
        else
            temp=NaN;
        end
        findcodes=[findcodes;temp];
        clear temp x
    end
    infos.typeoftrial=findcodes; typeoftrial=findcodes;
    clear locations findcodes
    
    probtrials=[];
    for x=1:length(typeoftrial)
        if typeoftrial(x)==2011
            temp=1;
        end
        if typeoftrial(x)==2012 | typeoftrial(x)==2013
            temp=4;
        end
        if typeoftrial(x)==2014 | typeoftrial(x)==2015
            temp=3;
        end
        if typeoftrial(x)==2016 | typeoftrial(x)==2017
            temp=2;
        end
        if typeoftrial(x)==2018
            temp=5;
        end
        if typeoftrial(x)>2018 | typeoftrial(x)<2010
            temp=NaN;
        end
        probtrials=[probtrials; temp]; clear temp
    end
    infos.probtrials=probtrials; clear probtrials
    
    amounttrials=[];
    for x=1:length(typeoftrial)
        
        if typeoftrial(x)==2021%91
            temp=1;
        end
        if typeoftrial(x)==2022 %is this correct...!
            temp=2;
        end
        if typeoftrial(x)==2023%94
            temp=3;
        end
        if typeoftrial(x)==2024 %is this correct...!
            temp=4;
        end
        if typeoftrial(x)==2025%98
            temp=5;
        end
        if typeoftrial(x)<2020
            temp=NaN;
        end
        % try
        amounttrials=[amounttrials; temp]; clear temp
        % catch
        %     amounttrials=[amounttrials; NaN];
        % end
    end
    infos.amounttrials=amounttrials; clear amounttrials
    clear typeoftrial zzz TEMP__ temp
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    possiblevalues=[REWCD];
    findcodes=[];
    for x=1:size(d,2)
        temp=intersect(codes(x).save,possiblevalues);
        if isempty(temp)~=1
            temp=codes(x).time(find(codes(x).save==temp));
        else
            temp=NaN;
        end
        if length(temp)>1
            temp=temp(2);
        end
        findcodes=[findcodes; temp];
        clear temp x
    end
    findcodes(find(findcodes==0))=NaN;
    evtime.rewardtime=findcodes;
    clear findcodes
    
    
    possiblevalues=[TARGONCD];
    findcodes=[];
    for x=1:size(d,2)
        temp=intersect(codes(x).save,possiblevalues);
        if isempty(temp)~=1
            temp=codes(x).time(find(codes(x).save==temp));
        else
            temp=NaN;
        end
        if length(temp)>1
            temp=temp(2);
        end
        findcodes=[findcodes; temp];
        clear temp x
    end
    findcodes(find(findcodes==0))=NaN;
    evtime.targetontime=findcodes;
    clear findcodes
    
    possiblevalues=[CUECD];
    findcodes=[];
    for x=1:size(d,2)
        temp=intersect(codes(x).save,possiblevalues);
        if isempty(temp)~=1
            temp=codes(x).time(find(codes(x).save==temp));
        else
            temp=NaN;
        end
        if length(temp)>1
            temp=temp(2);
        end
        findcodes=[findcodes; temp];
        clear temp x
    end
    findcodes(find(findcodes==0))=NaN;
    evtime.cueontime=findcodes;
    clear findcodes
    
    possiblevalues=[TARGOFFCD];
    findcodes=[];
    for x=1:size(d,2)
        temp=intersect(codes(x).save,possiblevalues);
        if isempty(temp)~=1
            temp=codes(x).time(find(codes(x).save==temp));
        else
            temp=NaN;
        end
        if length(temp)>1
            temp=temp(2);
        end
        findcodes=[findcodes; temp];
        clear temp x
    end
    findcodes(find(findcodes==0))=NaN;
    evtime.targetofftime=findcodes;
    evtime.outcomedelivery=findcodes+(0.0030);
    clear findcodes
    
    
    valuesoftrial=infos.typeoftrial;
    valuesoftrial(find(infos.typeoftrial<2020))=2010;
    valuesoftrial(find(infos.typeoftrial>2020))=2020;
    temp=findseq(valuesoftrial);
    valuesoftrial=infos.typeoftrial;
    %valuesoftrial(find(isnan(evtime.rewardtime)==1))=NaN; %incomplete trials removed
    blockvalues=[];
    orderoftrials=[];
    for x=1:length(temp(:,1))
        xx(1:(temp(x,3)-temp(x,2))+1)=x;
        blockvalues=[blockvalues; (xx')];
        clear xx
    end
    infos.blockvalues=blockvalues; clear blockvalues
    clear blockvalues orderoftrials valuesoftrial temp TRIALS blockvalues1
    
    %%
    infos.amounttrials(evtime.outcomedelivery==0)=NaN;
    infos.probtrials(evtime.outcomedelivery==0)=NaN;
    %%
    %%
    %%
    
    possiblevalues=[800];
    findcodes=[];
    for x=1:size(d,2)
        temp=intersect(codes(x).save,possiblevalues);
        if isempty(temp)~=1
            temp=codes(x).time(find(codes(x).save==temp));
        else
            temp=NaN;
        end
        if length(temp)>1
            temp=temp(2);
        end
        findcodes=[findcodes; temp];
        clear temp x
    end
    findcodes(find(findcodes==0))=NaN;
    evtime.analogstart=findcodes;
    clear findcodes temp temp2
    
    
    
    %     alltrialsid(1:length(infos.probtrials))=0;
    %     alltrialsid(find(~isnan(infos.probtrials)==1))=1;
    %     alltrialsid(find(~isnan(infos.amounttrials)==1))=1;
    %     looktime=[];
    %     for bnbn=1:length(alltrialsid)
    %         if isnan(alltrialsid(bnbn))==1
    %             looktime=[looktime; NaN;];
    %         else
    %             try
    %                 %look at CS
    %                 st_=evtime.targetontime(bnbn);%-d(Tsac).aStartTime;
    %                 st_=st_-evtime.analogstart(bnbn);
    %                 en_=st_+1500;
    %                 %look at tS
    %                 %st_=evtime.targetontime(bnbn)-1000;%-d(Tsac).aStartTime;
    %                 %en_=evtime.targetontime(bnbn);
    %
    %                 eyepos=[d(bnbn).Signals(1).Signal(st_:en_); d(bnbn).Signals(2).Signal(st_:en_)];
    %                 %plot(eyepos(1,:),eyepos(2,:)); axis([-10 10 -10 10])
    %                 %infos.probtrials(bnbn)
    %                 %infos.amounttrials(bnbn)
    %                 close all
    %                 %threshold based on fixation spot
    %
    %                 hor=find(eyepos(1,:)<threshfix & eyepos(1,:)>(threshfix*-1));
    %                 ver=find(eyepos(2,:)<threshfix & eyepos(2,:)>(threshfix*-1));
    %                 looktimeTEMP=length(intersect(ver,hor));
    %                 looktime=[looktime; (looktimeTEMP/1501)*100];
    %                 clear hor ver eyepos st_ en_
    %             catch
    %                 looktime=[looktime; NaN;];
    %             end
    %
    %         end
    %     end
    %     infos.looktime=looktime; clear looktime bnbn alltrialsid
    
    %     lookingprob=[nanmean(infos.looktime(find(infos.probtrials==1)));
    %         nanmean(infos.looktime(find(infos.probtrials==2)));
    %         nanmean(infos.looktime(find(infos.probtrials==3)));
    %         nanmean(infos.looktime(find(infos.probtrials==4)));
    %         nanmean(infos.looktime(find(infos.probtrials==5)))]';
    %     lookingamt=[nanmean(infos.looktime(find(infos.amounttrials==1)));
    %         nanmean(infos.looktime(find(infos.amounttrials==2)));
    %         nanmean(infos.looktime(find(infos.amounttrials==3)));
    %         nanmean(infos.looktime(find(infos.amounttrials==4)));
    %         nanmean(infos.looktime(find(infos.amounttrials==5)))]';
    %     LOOKINGAMT=[LOOKINGAMT;lookingamt];
    %     LOOKINGPROB=[LOOKINGPROB;lookingprob];
    %     clear lookingamt lookingprob
    
    
    
    
    %
    %         alltrialsid(1:length(infos.probtrials))=0;
    %         alltrialsid(find(~isnan(infos.probtrials)==1))=1;
    %         alltrialsid(find(~isnan(infos.amounttrials)==1))=1;
    %         baseline=[];
    %         for bnbn=1:length(alltrialsid)
    %             %look at tS
    %             try
    %                 st_base=evtime.targetontime(bnbn)-1000;%-d(Tsac).aStartTime;
    %                 en_base=evtime.targetontime(bnbn);
    %                 lickstbase=d(bnbn).Signals(6).Signal(st_base:en_base);
    %                 baseline=[baseline;lickstbase];
    %             end
    %         end
    %         CSlick=[];
    %         for bnbn=1:length(alltrialsid)
    %             %look at tS
    %             try
    %                 %look at CS
    %                 st_=evtime.targetontime(bnbn);%-d(Tsac).aStartTime;
    %                 st_=st_-evtime.analogstart(bnbn);
    %                 en_=st_+1500;
    %                 lickstbase=d(bnbn).Signals(6).Signal(st_:en_);
    %                 CSlick=[CSlick;lickstbase];
    %             end
    %         end
    %
    %
    
    
    %
    %
    %
    %
    %         alltrialsid(1:length(infos.probtrials))=0;
    %         alltrialsid(find(~isnan(infos.probtrials)==1))=1;
    %         alltrialsid(find(~isnan(infos.amounttrials)==1))=1;
    %         looktime=[];
    %         for bnbn=1:length(alltrialsid)
    %             if isnan(alltrialsid(bnbn))==1
    %                 looktime=[looktime; NaN;];
    %             else
    %                 try
    %                     %look at CS
    %                     st_=evtime.targetontime(bnbn);%-d(Tsac).aStartTime;
    %                     st_=st_-evtime.analogstart(bnbn);
    %                     en_=st_+1500;
    %                     lickst=d(bnbn).Signals(6).Signal(st_:en_);
    %
    %                     %look at tS
    %                     st_base=evtime.targetontime(bnbn)-1000;%-d(Tsac).aStartTime;
    %                     en_base=evtime.targetontime(bnbn);
    %                     lickstbase=d(bnbn).Signals(6).Signal(st_base:en_base);
    %
    %                     figure
    %                     plot(lickst,'b')
    %                     hold on
    %                     plot(lickstbase,'r')
    %
    %                     %plot(eyepos(1,:),eyepos(2,:)); axis([-10 10 -10 10])
    %                     %infos.probtrials(bnbn)
    %                     %infos.amounttrials(bnbn)
    %                     close all
    %                     %threshold based on fixation spot
    %                     threshfix=2;
    %                     hor=find(eyepos(1,:)<threshfix & eyepos(1,:)>(threshfix*-1));
    %                     ver=find(eyepos(2,:)<threshfix & eyepos(2,:)>(threshfix*-1));
    %                     looktimeTEMP=length(intersect(ver,hor));
    %                     looktime=[looktime; (looktimeTEMP/1501)*100];
    %                     clear hor ver threshfix eyepos st_ en_
    %                 catch
    %                     looktime=[looktime; NaN;];
    %                 end
    %
    %             end
    %         end
    %         infos.looktime=looktime; clear looktime bnbn alltrialsid
    %
    %
    %
    

    

    a100=(infos.amounttrials==1);
    a75=(infos.amounttrials==2);
    a50=(infos.amounttrials==3);
    a25=(infos.amounttrials==4);
    a0=(infos.amounttrials==5);
    prob100=(infos.probtrials==1);
    prob75=(infos.probtrials==2);
    prob50=(infos.probtrials==3);
    prob25=(infos.probtrials==4);
    prob0=(infos.probtrials==5);
    prob75d=(infos.probtrials==2 & evtime.rewardtime>0);
    prob50d=(infos.probtrials==3 & evtime.rewardtime>0);
    prob25d=(infos.probtrials==4 & evtime.rewardtime>0);
    prob75nd=(infos.probtrials==2 & evtime.rewardtime==0);
    prob50nd=(infos.probtrials==3 & evtime.rewardtime==0);
    prob25nd=(infos.probtrials==4 & evtime.rewardtime==0);
    
    savestruct(xzv).prob75ndl=length(prob75nd);
savestruct(xzv).prob25dl=length(prob25d);


    
    
completedtrial=[find(infos.amounttrials>0);  find(infos.probtrials>0)]
  completedtrialAmt=[find(infos.amounttrials>0);]
     completedtrialProb=[find(infos.probtrials>0);]
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        align_signal='evtime.targetontime';
    align_signal=eval(align_signal); 
    CENTER=5001;
    align_signal=(align_signal);
    Rasters=[];
    for x=1:size(d,2)
        alignval=align_signal(x);
        if alignval==0
            alignval=NaN;
        end
        
        if isempty(d(x).Units)==1
            singtrialspk=[1];
        else
            singtrialspk=d(x).Units(spka).Times-alignval;
        end
        
        temp1=singtrialspk+5000;
        temp1=temp1(find(temp1>0));
        temp1=temp1(find(temp1<((CENTER-1))*2));
        temp(1:10000)=0;
        temp(temp1)=1; clear temp1
        Rasters=[Rasters; temp];
        clear alignval singtrialspk x temp temp1 x singtrialspk
    end
    
    
    clear data temp temp2
    align_signal='evtime.targetontime';
    align_signal=eval(align_signal);
    %
    data(33).x=(infos.amounttrials==1);
    data(34).x=(infos.amounttrials==2);
    data(35).x=(infos.amounttrials==3);
    data(36).x=(infos.amounttrials==4);
    data(37).x=(infos.amounttrials==5);
    data(38).x=(infos.probtrials==1);
    data(39).x=(infos.probtrials==2);
    data(40).x=(infos.probtrials==3);
    data(41).x=(infos.probtrials==4);
    data(42).x=(infos.probtrials==5);
    data(43).x=(infos.probtrials==2 & evtime.rewardtime>0);
    data(44).x=(infos.probtrials==3 & evtime.rewardtime>0);
    data(45).x=(infos.probtrials==4 & evtime.rewardtime>0);
    data(46).x=(infos.probtrials==2 & evtime.rewardtime==0);
    data(47).x=(infos.probtrials==3 & evtime.rewardtime==0);
    data(48).x=(infos.probtrials==4 & evtime.rewardtime==0);
    %
    
    SDFs=Rasters;
    %% remove reward noise
    trialid_rewdel=find(data(43).x==1);
    trialid_notrewdel=find(data(46).x==1);
    no_noise=(SDFs(trialid_notrewdel,6510:6520));
    yes_noise=(SDFs(trialid_rewdel,6510:6520));
    %
    yes_remove=yes_noise;
    for xremove=1:size(yes_remove,1)
        trialins=randi(size(no_noise,1),1,1);
        yes_remove(xremove,:)=no_noise(trialins,:);
    end
    SDFs(trialid_rewdel,6510:6520)=yes_remove;
    %%
    trialid_rewdel=find(data(44).x==1);
    trialid_notrewdel=find(data(47).x==1);
    no_noise=(SDFs(trialid_notrewdel,6510:6520));
    yes_noise=(SDFs(trialid_rewdel,6510:6520));
    %
    yes_remove=yes_noise;
    for xremove=1:size(yes_remove,1)
        trialins=randi(size(no_noise,1),1,1);
        yes_remove(xremove,:)=no_noise(trialins,:);
    end
    SDFs(trialid_rewdel,6510:6520)=yes_remove;
    %%
    trialid_rewdel=find(data(45).x==1);
    trialid_notrewdel=find(data(48).x==1);
    no_noise=(SDFs(trialid_notrewdel,6510:6520));
    yes_noise=(SDFs(trialid_rewdel,6510:6520));
    %
    yes_remove=yes_noise;
    for xremove=1:size(yes_remove,1)
        trialins=randi(size(no_noise,1),1,1);
        yes_remove(xremove,:)=no_noise(trialins,:);
    end
    SDFs(trialid_rewdel,6510:6520)=yes_remove;
    %%
    
    
    
    trialid_rewdel=find(data(38).x==1);
    trialid_notrewdel=find(data(38).x==1);
    no_noise=(SDFs(trialid_notrewdel,6500:6510));
    yes_noise=(SDFs(trialid_rewdel,6510:6520));
    %
    yes_remove=yes_noise;
    for xremove=1:size(yes_remove,1)
        trialins=randi(size(no_noise,1),1,1);
        yes_remove(xremove,:)=no_noise(trialins,:);
    end
    SDFs(trialid_rewdel,6510:6520)=yes_remove;
    
    trialid_rewdel=find(data(33).x==1);
    trialid_notrewdel=find(data(33).x==1);
    no_noise=(SDFs(trialid_notrewdel,6500:6510));
    yes_noise=(SDFs(trialid_rewdel,6510:6520));
    %
    yes_remove=yes_noise;
    for xremove=1:size(yes_remove,1)
        trialins=randi(size(no_noise,1),1,1);
        yes_remove(xremove,:)=no_noise(trialins,:);
    end
    SDFs(trialid_rewdel,6510:6520)=yes_remove;
    
    trialid_rewdel=find(data(34).x==1);
    trialid_notrewdel=find(data(34).x==1);
    no_noise=(SDFs(trialid_notrewdel,6500:6510));
    yes_noise=(SDFs(trialid_rewdel,6510:6520));
    %
    yes_remove=yes_noise;
    for xremove=1:size(yes_remove,1)
        trialins=randi(size(no_noise,1),1,1);
        yes_remove(xremove,:)=no_noise(trialins,:);
    end
    SDFs(trialid_rewdel,6510:6520)=yes_remove;
    
    trialid_rewdel=find(data(35).x==1);
    trialid_notrewdel=find(data(35).x==1);
    no_noise=(SDFs(trialid_notrewdel,6500:6510));
    yes_noise=(SDFs(trialid_rewdel,6510:6520));
    %
    yes_remove=yes_noise;
    for xremove=1:size(yes_remove,1)
        trialins=randi(size(no_noise,1),1,1);
        yes_remove(xremove,:)=no_noise(trialins,:);
    end
    SDFs(trialid_rewdel,6510:6520)=yes_remove;
    
    trialid_rewdel=find(data(36).x==1);
    trialid_notrewdel=find(data(36).x==1);
    no_noise=(SDFs(trialid_notrewdel,6500:6510));
    yes_noise=(SDFs(trialid_rewdel,6510:6520));
    %
    yes_remove=yes_noise;
    for xremove=1:size(yes_remove,1)
        trialins=randi(size(no_noise,1),1,1);
        yes_remove(xremove,:)=no_noise(trialins,:);
    end
    SDFs(trialid_rewdel,6510:6520)=yes_remove;
    
    
    trialid_rewdel=find(data(45).x==1);
    trialid_notrewdel=find(data(47).x==1);
    no_noise=(SDFs(trialid_notrewdel,6510:6520))
    yes_noise=(SDFs(trialid_rewdel,6510:6520))
    %
    yes_remove=yes_noise;
    for xremove=1:size(yes_remove,1)
        trialins=randi(size(no_noise,1),1,1);
        yes_remove(xremove,:)=no_noise(trialins,:);
    end
    SDFs(trialid_rewdel,6510:6520)=yes_remove;
    
    
    trialid_rewdel=find(data(33).x==1);
    trialid_notrewdel=find(data(33).x==1);
    no_noise=(SDFs(trialid_notrewdel,6500:6510))
    yes_noise=(SDFs(trialid_rewdel,6510:6520))
    %
    yes_remove=yes_noise;
    for xremove=1:size(yes_remove,1)
        trialins=randi(size(no_noise,1),1,1);
        yes_remove(xremove,:)=no_noise(trialins,:);
    end
    SDFs(trialid_rewdel,6510:6520)=yes_remove;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Rasters=SDFs;

    
    
    
    Rasterscs=Rasters;
    
        SDFcs_n=[];
    for R=1:size(Rasterscs,1)
        sdf=Smooth_Histogram(Rasterscs(R,:),3);
        SDFcs_n=[SDFcs_n; sdf;];
    end
   
    SDFcs_nC= SDFcs_n;

   SDFcs_n=plot_mean_psth({Rasterscs},gauswindow_ms,1,(CENTER*2)-2,1); %make spike density functions for displaying and average across neurons for displaying
    
    %for analyses use RASTERS (spike count)
    Rasters=Rasters(:,5000-1000-500:5000+1500+1000);
    
    
    PostRasterAnalysis;
    


%average vectors
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

analysiswindow=[6000:6500];
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



popwindow=[5000-1000-750:6500+1500];
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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


popwindow=[6000:6500];
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




popwindow=[6500:6500+1000];
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






popwindow=[5000-1000-750:6500+1500];
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



close all;
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
xuncert=[Rasterscs(prob100,5000-1000-750:6500+1500)];
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
xuncert=[Rasterscs(prob75,5000-1000-750:6500+1500)];
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
xuncert=[Rasterscs(prob50,5000-1000-750:6500+1500)];
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
xuncert=[Rasterscs(prob25,5000-1000-750:6500+1500)];
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
xuncert=[Rasterscs(prob0,5000-1000-750:6500+1500)];
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

if PRINTYESORNO==1
set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
print('-djpeg', [['Save_'] '_' mat2str(loopCounter)] );
end
close all;
clc


% 
%     
%     sdf
%     
%     
%     %
%     %
%     maxrate=100
%     figure
%     subplot(5,2,1)
%     plot(nanmean(data(33).SDF),'k'); ylim([0 maxrate]); xlim([3000 7000])
%     %hold on; plot(3000,[0 :maxrate]);hold on; plot(4000,[0 :maxrate]);hold on; plot(2000,[0 :maxrate]);
%     axis square;
%     subplot(5,2,3)
%     plot(nanmean(data(34).SDF),'k'); ylim([0 maxrate]); xlim([3000 7000])
%     %hold on; plot(3000,[0 :maxrate]);hold on; plot(4000,[0 :maxrate]);hold on; plot(2000,[0 :maxrate]);
%     axis square;
%     subplot(5,2,5)
%     plot(nanmean(data(35).SDF),'k'); ylim([0 maxrate]); xlim([3000 7000])
%     %hold on; plot(3000,[0 :maxrate]);hold on; plot(4000,[0 :maxrate]);hold on; plot(2000,[0 :maxrate]);
%     axis square;
%     subplot(5,2,7)
%     plot(nanmean(data(36).SDF),'k'); ylim([0 maxrate]); xlim([3000 7000])
%     %hold on; plot(3000,[0 :maxrate]);hold on; plot(4000,[0 :maxrate]);hold on; plot(2000,[0 :maxrate]);
%     axis square;
%     subplot(5,2,9)
%     plot(nanmean(data(37).SDF),'k'); ylim([0 maxrate]); xlim([3000 7000])
%     %hold on; plot(3000,[0 :maxrate]);hold on; plot(4000,[0 :maxrate]);hold on; plot(2000,[0 :maxrate]);
%     axis square;
%     subplot(5,2,2)
%     plot(nanmean(data(38).SDF),'g'); ylim([0 maxrate]); xlim([3000 7000])
%     %hold on; plot(3000,[0 :maxrate]);hold on; plot(4000,[0 :maxrate]);hold on; plot(2000,[0 :maxrate]);
%     axis square;
%     subplot(5,2,4)
%     plot(nanmean(data(39).SDF),'g'); ylim([0 maxrate]); xlim([3000 7000])
%     %hold on; plot(3000,[0 :maxrate]);hold on; plot(4000,[0 :maxrate]);hold on; plot(2000,[0 :maxrate]);
%     axis square;
%     subplot(5,2,6)
%     plot(nanmean(data(40).SDF),'g'); ylim([0 maxrate]); xlim([3000 7000])
%     %hold on; plot(3000,[0 :maxrate]);hold on; plot(4000,[0 :maxrate]);hold on; plot(2000,[0 :maxrate]);
%     axis square;
%     subplot(5,2,8)
%     plot(nanmean(data(41).SDF),'g'); ylim([0 maxrate]); xlim([3000 7000])
%     %hold on; plot(3000,[0 :maxrate]);hold on; plot(4000,[0 :maxrate]);hold on; plot(2000,[0 :maxrate]);
%     axis square;
%     subplot(5,2,10)
%     plot(nanmean(data(42).SDF),'g'); ylim([0 maxrate]); xlim([3000 7000])
%     %hold on; plot(3000,[0 :maxrate]);hold on; plot(4000,[0 :maxrate]);hold on; plot(2000,[0 :maxrate]);
%     axis square;
%     
%     %     figure
%     %      plot(nanmean(data(38).SDF),'r'); ylim([0 maxrate]); xlim([3000 7000]); hold on
%     %     plot(nanmean(data(39).SDF),'b'); ylim([0 maxrate]); xlim([3000 7000]); hold on
%     %     plot(nanmean(data(40).SDF),'m'); ylim([0 maxrate]); xlim([3000 7000]); hold on
%     %     plot(nanmean(data(41).SDF),'k'); ylim([0 maxrate]); xlim([3000 7000]); hold on
%     %     plot(nanmean(data(42).SDF),'y'); ylim([0 maxrate]); xlim([3000 7000]); hold on
%     %     ylim([0 75]);
%     %
%     ranksum(nanmean(data(40).SDF(:,5150:6500)')',nanmean(data(38).SDF(:,5150:6500)')')
%     
%     close all;
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
%     %         amountrho=[];
%     %         amountp=[];
%     %         probrho=[];
%     %         probp=[];
%     %         for ggg=5000:6500
%     %             V1=(data(33).SDF(:,ggg)');
%     %             V2=(data(34).SDF(:,ggg)');
%     %             V3=(data(35).SDF(:,ggg)');
%     %             V4=(data(36).SDF(:,ggg)');
%     %             V5=(data(37).SDF(:,ggg)');
%     %             V1=V1(find(~isnan(V1)==1));
%     %             V2=V2(find(~isnan(V2)==1));
%     %             V3=V3(find(~isnan(V3)==1));
%     %             V4=V4(find(~isnan(V4)==1));
%     %             V5=V5(find(~isnan(V5)==1));
%     %             V1leng(1:length(V1))=1;
%     %             V2leng(1:length(V2))=2;
%     %             V3leng(1:length(V3))=3;
%     %             V4leng(1:length(V4))=4;
%     %             V5leng(1:length(V5))=5;
%     %             tempV1=[V1 V2 V3 V4 V5]';
%     %             tempV1leng=[V1leng V2leng V3leng V4leng V5leng]';
%     %             try
%     %                 [pval, r]=permutation_pair_test_fast(tempV1,tempV1leng,permnumber,'rankcorr');
%     %             catch
%     %                 r=NaN;
%     %                 pval=NaN;
%     %             end
%     %             amountrho=[amountrho; r];
%     %             amountp=[amountp; pval];
%     %             clear V1leng V2leng V3leng V4leng V5leng
%     %             %%%
%     %             V1=(data(38).SDF(:,ggg)');
%     %             V2=(data(39).SDF(:,ggg)');
%     %             V3=(data(40).SDF(:,ggg)');
%     %             V4=(data(41).SDF(:,ggg)');
%     %             V5=(data(42).SDF(:,ggg)');
%     %             V1=V1(find(~isnan(V1)==1));
%     %             V2=V2(find(~isnan(V2)==1));
%     %             V3=V3(find(~isnan(V3)==1));
%     %             V4=V4(find(~isnan(V4)==1));
%     %             V5=V5(find(~isnan(V5)==1));
%     %             V1leng(1:length(V1))=1;
%     %             V2leng(1:length(V2))=2;
%     %             V3leng(1:length(V3))=3;
%     %             V4leng(1:length(V4))=4;
%     %             V5leng(1:length(V5))=5;
%     %             tempV1=[V1 V2 V3 V4 V5]';
%     %             tempV1leng=[V1leng V2leng V3leng V4leng V5leng]';
%     %             try
%     %                 [pval, r]=permutation_pair_test_fast(tempV1,tempV1leng,permnumber,'rankcorr');
%     %             catch
%     %                 r=NaN;
%     %                 pval=NaN;
%     %             end
%     %             probrho=[probrho; r];
%     %             probp=[probp; pval];
%     %             clear V1leng V2leng V3leng V4leng V5leng
%     %             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %             clear V1 V2 V3 V4 V5 V1leng V2leng V3leng V4leng V5leng tempV1 tempV1leng r pval
%     %         end
%     %         linepar(zzzz).probrho=probrho;
%     %         linepar(zzzz).amountrho=amountrho;
%     %         linepar(zzzz).probp=probp;
%     %         linepar(zzzz).amountp=amountp;
%     
%     
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%linear
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%fits
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
%     limnnn=5;
%     limend=15;
%     
%     trialsregs=[];
%     trialsregs_nums=[];
%     for yreg=1:size(data(33).SDF,1)
%         tempxreg=[];
%         for xreg=limnnn:limend
%             %tempforreg=(data(33).SDF(yreg,5000+xreg*100:5000+((xreg+1)*100)));
%             tempforreg=(data(33).SDF(yreg,5000+xreg*100:5000+((xreg)*100)));
%             
%             tempxreg=[tempxreg; nanmean(tempforreg)];
%         end
%         trialsregs=[trialsregs; tempxreg'];
%         tempyreg(1:length(tempxreg))=1:length(tempxreg);
%         trialsregs_nums=[trialsregs_nums; tempyreg];
%         
%         clear tempxreg xreg tempyreg
%     end
%     y1=trialsregs(:);
%     x=trialsregs_nums(:);
%     [pval, r]=permutation_pair_test_fast(x,y1,NumberofPermutations,'rankcorr')
%     P = polyfit(x,y1,1);
%     yfit = P(1)*x+P(2);
%     linepar(zzzz).P33=P;
%     linepar(zzzz).x33=x;
%     linepar(zzzz).yfit33=yfit;
%     linepar(zzzz).pval33=pval;
%     linepar(zzzz).r33=r;
%     trialsregs=[];
%     trialsregs_nums=[];
%     for yreg=1:size(data(34).SDF,1)
%         tempxreg=[];
%         for xreg=limnnn:limend
%             tempforreg=(data(34).SDF(yreg,5000+xreg*100:5000+((xreg)*100)));
%             tempxreg=[tempxreg; nanmean(tempforreg)];
%         end
%         trialsregs=[trialsregs; tempxreg'];
%         tempyreg(1:length(tempxreg))=1:length(tempxreg);
%         trialsregs_nums=[trialsregs_nums; tempyreg];
%         
%         clear tempxreg xreg tempyreg
%     end
%     y1=trialsregs(:);
%     x=trialsregs_nums(:);
%     [pval, r]=permutation_pair_test_fast(x,y1,NumberofPermutations,'rankcorr');
%     P = polyfit(x,y1,1);
%     yfit = P(1)*x+P(2);
%     linepar(zzzz).P34=P;
%     linepar(zzzz).x34=x;
%     linepar(zzzz).yfit34=yfit;
%     linepar(zzzz).pval34=pval;
%     linepar(zzzz).r34=r;
%     trialsregs=[];
%     trialsregs_nums=[];
%     for yreg=1:size(data(35).SDF,1)
%         tempxreg=[];
%         for xreg=limnnn:limend
%             tempforreg=(data(35).SDF(yreg,5000+xreg*100:5000+((xreg)*100)));
%             tempxreg=[tempxreg; nanmean(tempforreg)];
%         end
%         trialsregs=[trialsregs; tempxreg'];
%         tempyreg(1:length(tempxreg))=1:length(tempxreg);
%         trialsregs_nums=[trialsregs_nums; tempyreg];
%         
%         clear tempxreg xreg tempyreg
%     end
%     y1=trialsregs(:);
%     x=trialsregs_nums(:);
%     [pval, r]=permutation_pair_test_fast(x,y1,NumberofPermutations,'rankcorr');
%     P = polyfit(x,y1,1);
%     yfit = P(1)*x+P(2);
%     linepar(zzzz).P35=P;
%     linepar(zzzz).x35=x;
%     linepar(zzzz).yfit35=yfit;
%     linepar(zzzz).pval35=pval;
%     linepar(zzzz).r35=r;
%     trialsregs=[];
%     trialsregs_nums=[];
%     for yreg=1:size(data(36).SDF,1)
%         tempxreg=[];
%         for xreg=limnnn:limend
%             tempforreg=(data(36).SDF(yreg,5000+xreg*100:5000+((xreg)*100)));
%             tempxreg=[tempxreg; nanmean(tempforreg)];
%         end
%         trialsregs=[trialsregs; tempxreg'];
%         tempyreg(1:length(tempxreg))=1:length(tempxreg);
%         trialsregs_nums=[trialsregs_nums; tempyreg];
%         
%         clear tempxreg xreg tempyreg
%     end
%     y1=trialsregs(:);
%     x=trialsregs_nums(:);
%     [pval, r]=permutation_pair_test_fast(x,y1,NumberofPermutations,'rankcorr');
%     P = polyfit(x,y1,1);
%     yfit = P(1)*x+P(2);
%     linepar(zzzz).P36=P;
%     linepar(zzzz).x36=x;
%     linepar(zzzz).yfit36=yfit;
%     linepar(zzzz).pval36=pval;
%     linepar(zzzz).r36=r;
%     trialsregs=[];
%     trialsregs_nums=[];
%     for yreg=1:size(data(37).SDF,1)
%         tempxreg=[];
%         for xreg=limnnn:limend
%             tempforreg=(data(37).SDF(yreg,5000+xreg*100:5000+((xreg)*100)));
%             tempxreg=[tempxreg; nanmean(tempforreg)];
%         end
%         trialsregs=[trialsregs; tempxreg'];
%         tempyreg(1:length(tempxreg))=1:length(tempxreg);
%         trialsregs_nums=[trialsregs_nums; tempyreg];
%         clear tempxreg xreg tempyreg
%     end
%     y1=trialsregs(:);
%     x=trialsregs_nums(:);
%     [pval, r]=permutation_pair_test_fast(x,y1,NumberofPermutations,'rankcorr');
%     P = polyfit(x,y1,1);
%     yfit = P(1)*x+P(2);
%     linepar(zzzz).P37=P;
%     linepar(zzzz).x37=x;
%     linepar(zzzz).yfit37=yfit;
%     linepar(zzzz).pval37=pval;
%     linepar(zzzz).r37=r;
%     trialsregs=[];
%     trialsregs_nums=[];
%     for yreg=1:size(data(38).SDF,1)
%         tempxreg=[];
%         for xreg=limnnn:limend
%             tempforreg=(data(38).SDF(yreg,5000+xreg*100:5000+((xreg)*100)));
%             tempxreg=[tempxreg; nanmean(tempforreg)];
%         end
%         trialsregs=[trialsregs; tempxreg'];
%         tempyreg(1:length(tempxreg))=1:length(tempxreg);
%         trialsregs_nums=[trialsregs_nums; tempyreg];
%         clear tempxreg xreg tempyreg
%     end
%     y1=trialsregs(:);
%     x=trialsregs_nums(:);
%     [pval, r]=permutation_pair_test_fast(x,y1,NumberofPermutations,'rankcorr');
%     P = polyfit(x,y1,1);
%     yfit = P(1)*x+P(2);
%     linepar(zzzz).P38=P;
%     linepar(zzzz).x38=x;
%     linepar(zzzz).yfit38=yfit;
%     linepar(zzzz).pval38=pval;
%     linepar(zzzz).r38=r;
%     trialsregs=[];
%     trialsregs_nums=[];
%     for yreg=1:size(data(39).SDF,1)
%         tempxreg=[];
%         for xreg=limnnn:limend
%             tempforreg=(data(39).SDF(yreg,5000+xreg*100:5000+((xreg)*100)));
%             tempxreg=[tempxreg; nanmean(tempforreg)];
%         end
%         trialsregs=[trialsregs; tempxreg'];
%         tempyreg(1:length(tempxreg))=1:length(tempxreg);
%         trialsregs_nums=[trialsregs_nums; tempyreg];
%         clear tempxreg xreg tempyreg
%     end
%     y1=trialsregs(:);
%     x=trialsregs_nums(:);
%     [pval, r]=permutation_pair_test_fast(x,y1,NumberofPermutations,'rankcorr');
%     P = polyfit(x,y1,1);
%     yfit = P(1)*x+P(2);
%     linepar(zzzz).P39=P;
%     linepar(zzzz).x39=x;
%     linepar(zzzz).yfit39=yfit;
%     linepar(zzzz).pval39=pval;
%     linepar(zzzz).r39=r;
%     trialsregs=[];
%     trialsregs_nums=[];
%     for yreg=1:size(data(40).SDF,1)
%         tempxreg=[];
%         for xreg=limnnn:limend
%             tempforreg=(data(40).SDF(yreg,5000+xreg*100:5000+((xreg)*100)));
%             tempxreg=[tempxreg; nanmean(tempforreg)];
%         end
%         trialsregs=[trialsregs; tempxreg'];
%         tempyreg(1:length(tempxreg))=1:length(tempxreg);
%         trialsregs_nums=[trialsregs_nums; tempyreg];
%         
%         clear tempxreg xreg tempyreg
%     end
%     y1=trialsregs(:);
%     x=trialsregs_nums(:);
%     [pval, r]=permutation_pair_test_fast(x,y1,NumberofPermutations,'rankcorr');
%     P = polyfit(x,y1,1);
%     yfit = P(1)*x+P(2);
%     linepar(zzzz).P40=P;
%     linepar(zzzz).x40=x;
%     linepar(zzzz).yfit40=yfit;
%     linepar(zzzz).pval40=pval;
%     linepar(zzzz).r40=r;
%     trialsregs=[];
%     trialsregs_nums=[];
%     for yreg=1:size(data(41).SDF,1)
%         tempxreg=[];
%         for xreg=limnnn:limend
%             tempforreg=(data(41).SDF(yreg,5000+xreg*100:5000+((xreg)*100)));
%             tempxreg=[tempxreg; nanmean(tempforreg)];
%         end
%         trialsregs=[trialsregs; tempxreg'];
%         tempyreg(1:length(tempxreg))=1:length(tempxreg);
%         trialsregs_nums=[trialsregs_nums; tempyreg];
%         
%         clear tempxreg xreg tempyreg
%     end
%     y1=trialsregs(:);
%     x=trialsregs_nums(:);
%     [pval, r]=permutation_pair_test_fast(x,y1,NumberofPermutations,'rankcorr');
%     P = polyfit(x,y1,1);
%     yfit = P(1)*x+P(2);
%     linepar(zzzz).P41=P;
%     linepar(zzzz).x41=x;
%     linepar(zzzz).yfit41=yfit;
%     linepar(zzzz).pval41=pval;
%     linepar(zzzz).r41=r;
%     trialsregs=[];
%     trialsregs_nums=[];
%     for yreg=1:size(data(42).SDF,1)
%         tempxreg=[];
%         for xreg=limnnn:limend
%             tempforreg=(data(42).SDF(yreg,5000+xreg*100:5000+((xreg)*100)));
%             tempxreg=[tempxreg; nanmean(tempforreg)];
%         end
%         trialsregs=[trialsregs; tempxreg'];
%         tempyreg(1:length(tempxreg))=1:length(tempxreg);
%         trialsregs_nums=[trialsregs_nums; tempyreg];
%         
%         clear tempxreg xreg tempyreg
%     end
%     y1=trialsregs(:);
%     x=trialsregs_nums(:);
%     [pval, r]=permutation_pair_test_fast(x,y1,NumberofPermutations,'rankcorr');
%     P = polyfit(x,y1,1);
%     yfit = P(1)*x+P(2);
%     linepar(zzzz).P42=P;
%     linepar(zzzz).x42=x;
%     linepar(zzzz).yfit42=yfit;
%     linepar(zzzz).pval42=pval;
%     linepar(zzzz).r42=r;
%     
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     
%     
%     %     close all
%     %     trialsregs=[];
%     %     trialsregs_nums=[];
%     %     for yreg=1:size(data(40).SDF,1)
%     %         tempxreg=[];
%     %         for xreg=4.5:14.5
%     %             tempforreg=(data(40).SDF(yreg,5000+xreg*100:5000+((xreg+1)*100)));
%     %             tempxreg=[tempxreg; nanmean(tempforreg)];
%     %         end
%     %         trialsregs=[trialsregs; tempxreg'];
%     %         tempyreg(1:length(tempxreg))=1:length(tempxreg);
%     %         trialsregs_nums=[trialsregs_nums; tempyreg];
%     %
%     %         clear tempxreg xreg tempyreg
%     %     end
%     %     y1=trialsregs(:);
%     %     x=trialsregs_nums(:);
%     %     subplot(2,1,1)
%     %     scatter(x,y1,25,'b','*')
%     %     P = polyfit(x,y1,1);
%     %     yfit = P(1)*x+P(2);
%     %     hold on;
%     %     plot(x,yfit,'r-.');
%     %     %slope=P(1)
%     %     %%yfit = P(1)*x+P(2) is the equation.... P(1) is the slope and P(2) is the
%     %     %%intercept
%     %     subplot(2,1,2)
%     %     plot(nanmean(data(40).SDF(:,5000:6500)))
%     %     linepar(zzzz).P=P;
%     %     linepar(zzzz).x=x;
%     %     linepar(zzzz).yfit=yfit;
%     
%     
%     triallimitcut=1;
%     temp=data(33).SDF;
%     t=size(temp,1);
%     if t<triallimitcut
%         tt(1:size(temp,2))=NaN;
%         temp=tt; clear tt
%     else
%         temp=nanmean(temp);
%     end
%     clear t
%     SF50amt100=[SF50amt100; temp]; clear temp
%     %
%     temp=data(34).SDF;
%     t=size(temp,1);
%     if t<triallimitcut
%         tt(1:size(temp,2))=NaN;
%         temp=tt; clear tt
%     else
%         temp=nanmean(temp);
%     end
%     clear t
%     SF50amt75=[SF50amt75; temp]; clear temp
%     %
%     temp=data(35).SDF;
%     t=size(temp,1);
%     if t<triallimitcut
%         tt(1:size(temp,2))=NaN;
%         temp=tt; clear tt
%     else
%         temp=nanmean(temp);
%     end
%     clear t
%     SF50amt50=[SF50amt50; temp]; clear temp
%     %
%     temp=data(36).SDF;
%     t=size(temp,1);
%     if t<triallimitcut
%         tt(1:size(temp,2))=NaN;
%         temp=tt; clear tt
%     else
%         temp=nanmean(temp);
%     end
%     clear t
%     SF50amt25=[SF50amt25; temp]; clear temp
%     %
%     temp=data(37).SDF;
%     t=size(temp,1);
%     if t<triallimitcut
%         tt(1:size(temp,2))=NaN;
%         temp=tt; clear tt
%     else
%         temp=nanmean(temp);
%     end
%     clear t
%     SF50amt0=[SF50amt0; temp]; clear temp
%     %
%     temp=data(38).SDF;
%     t=size(temp,1);
%     if t<triallimitcut
%         tt(1:size(temp,2))=NaN;
%         temp=tt; clear tt
%     else
%         temp=nanmean(temp);
%     end
%     clear t
%     SF50prob100=[SF50prob100; temp]; clear temp
%     %
%     %
%     temp=data(39).SDF;
%     t=size(temp,1);
%     if t<triallimitcut
%         tt(1:size(temp,2))=NaN;
%         temp=tt; clear tt
%     else
%         temp=nanmean(temp);
%     end
%     clear t
%     SF50prob75=[SF50prob75; temp]; clear temp
%     %
%     %
%     temp=data(40).SDF;
%     t=size(temp,1);
%     if t<triallimitcut
%         tt(1:size(temp,2))=NaN;
%         temp=tt; clear tt
%     else
%         temp=nanmean(temp);
%     end
%     clear t
%     SF50prob50=[SF50prob50; temp]; clear temp
%     %
%     %
%     temp=data(41).SDF;
%     t=size(temp,1);
%     if t<triallimitcut
%         tt(1:size(temp,2))=NaN;
%         temp=tt; clear tt
%     else
%         temp=nanmean(temp);
%     end
%     clear t
%     SF50prob25=[SF50prob25; temp]; clear temp
%     %
%     %
%     temp=data(42).SDF;
%     t=size(temp,1);
%     if t<triallimitcut
%         tt(1:size(temp,2))=NaN;
%         temp=tt; clear tt
%     else
%         temp=nanmean(temp);
%     end
%     clear t
%     SF50prob0=[SF50prob0; temp]; clear temp
%     %
%     %
%     temp=data(43).SDF;
%     t=size(temp,1);
%     if t<triallimitcut
%         tt(1:size(temp,2))=NaN;
%         temp=tt; clear tt
%     else
%         temp=nanmean(temp);
%     end
%     clear t
%     SF50prob75r=[SF50prob75r; temp]; clear temp
%     %
%     %
%     temp=data(44).SDF;
%     t=size(temp,1);
%     if t<triallimitcut
%         tt(1:size(temp,2))=NaN;
%         temp=tt; clear tt
%     else
%         temp=nanmean(temp);
%     end
%     clear t
%     SF50prob50r=[SF50prob50r; temp]; clear temp
%     %
%     
%     temp=data(45).SDF;
%     t=size(temp,1);
%     if t<triallimitcut
%         tt(1:size(temp,2))=NaN;
%         temp=tt; clear tt
%     else
%         if size(temp,1)>1
%             temp=nanmean(temp);
%         end
%     end
%     clear t
%     SF50prob25r=[SF50prob25r; temp]; clear temp
%     %
%     %
%     temp=data(46).SDF;
%     t=size(temp,1);
%     if t<triallimitcut
%         tt(1:size(temp,2))=NaN;
%         temp=tt; clear tt
%     else
%         if size(temp,1)>1
%             temp=nanmean(temp);
%         end
%     end
%     clear t
%     SF50prob75nr=[SF50prob75nr; temp]; clear temp
%     %
%     temp=data(47).SDF;
%     t=size(temp,1);
%     if t<triallimitcut
%         tt(1:size(temp,2))=NaN;
%         temp=tt; clear tt
%     else
%         temp=nanmean(temp);
%     end
%     clear t
%     SF50prob50nr=[SF50prob50nr; temp]; clear temp
%     %
%     
%     temp=data(48).SDF;
%     t=size(temp,1);
%     if t<triallimitcut
%         tt(1:size(temp,2))=NaN;
%         temp=tt; clear tt
%     else
%         temp=nanmean(temp);
%     end
%     clear t
%     SF50prob25nr=[SF50prob25nr; temp]; clear temp
%     
%     
%     
%     
%     
%     
%     sdaf
%     clear infos data evtime spike SpikeDATA TrialSpikeData_ SpikeDATA_ NEX analogdata ad SDF SDFs probrho amountrho
%     
% end
% close all;
% 
% 
% 
% 
% 
% 
% durationsuntilreward=PDS(1).timeoutcome-PDS(1).timetargeton;
% durationsuntilreward=round(durationsuntilreward*10)./10;
% completedtrial=find(durationsuntilreward>0); %was the trial completed
% deliv=intersect(find(PDS.timeoutcome>0),find( PDS.rewardduration>0)); %was reward delivered or not
% ndeliv=intersect(find(PDS.timeoutcome>0),find( PDS.rewardduration==0));
% %
% prob100=intersect(completedtrial,find(PDS.fractals==9800));
% prob75=intersect(completedtrial,find(PDS.fractals==9801));
% prob50=intersect(completedtrial,find(PDS.fractals==9802));
% prob25=intersect(completedtrial,find(PDS.fractals==9803));
% prob0=intersect(completedtrial,find(PDS.fractals==9804));
% %
% a100=intersect(completedtrial,find(PDS.fractals==9805));
% a75=intersect(completedtrial,find(PDS.fractals==9806));
% a50=intersect(completedtrial,find(PDS.fractals==9807));
% a25=intersect(completedtrial,find(PDS.fractals==9808));
% a0=intersect(completedtrial,find(PDS.fractals==9809));
% %
% prob75d=intersect(prob75,deliv);
% prob75nd=intersect(prob75,ndeliv);
% prob50d=intersect(prob50,deliv);
% prob50nd=intersect(prob50,ndeliv);
% prob25d=intersect(prob25,deliv);
% prob25nd=intersect(prob25,ndeliv);
% 
% Rasters=[];
% for x=1:length(durationsuntilreward)
%     CENTER=11001;
%     spk=PDS(1).sptimes{x}-PDS(1).timetargeton(x); %align spiking on targetonset
%     spk=(spk*1000)+CENTER-1;
%     spk=fix(spk);
%     %
%     spk=spk(find(spk<CENTER*2));
%     %
%     temp(1:CENTER*2)=0;
%     temp(spk)=1;
%     Rasters=[Rasters; temp];
%     clear temp spk x
% end
% %for ploting
% Rasterscs=Rasters;
% SDFcs_n=plot_mean_psth({Rasterscs},gauswindow_ms,1,(CENTER*2)-2,1); %make spike density functions for displaying and average across neurons for displaying
% 
% %for analyses use RASTERS (spike count)
% Rasters=Rasters(:,11000-1000-500:11000+2500+1000);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%     
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
%     
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
%     
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
%     
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
%     
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
%     
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
% 
% 
% 
% 
% 
% 
% 
% popwindow=[11000-1000-750:13500+1500];
% actp100=nanmean(SDFcs_n(prob100,popwindow));
% actp75=nanmean(SDFcs_n(prob75,popwindow));
% actp75d=nanmean(SDFcs_n(prob75d,popwindow));
% actp75nd=nanmean(SDFcs_n(prob75nd,popwindow));
% actp50=nanmean(SDFcs_n(prob50,popwindow));
% actp50d=nanmean(SDFcs_n(prob50d,popwindow));
% actp50nd=nanmean(SDFcs_n(prob50nd,popwindow));
% actp25=nanmean(SDFcs_n(prob25,popwindow));
% actp25d=nanmean(SDFcs_n(prob25d,popwindow));
% actp25nd=nanmean(SDFcs_n(prob25nd,popwindow));
% actp0=nanmean(SDFcs_n(prob0,popwindow));
% 
% close all;
% figure
% RSTP=20;
% nsubplot(165,165,100:121,20:40)
% h1=area((actp100));
% h1.FaceColor = 'red';
% axis([0 6000 0 100]);
% x=[750,750]; y=[0,150]; plot(x,y,'k'); hold on;
% clear x
% x=[1750,1750]; y=[0,150]; plot(x,y,'k'); hold on;
% clear x
% x=[4250,4250]; y=[0,150]; plot(x,y,'k'); hold on;
% clear x
% xuncert=[Rasterscs(prob100,11000-1000-750:13500+1500)];
% xt=[];
% rasts=[];
% for tq=1:size(xuncert,1)
%     Z=xuncert(tq,:);
%     Z(find(Z==1))=(find(Z==1));
%     Z(find(Z==0))=NaN;
%     xt_=length(find(Z>0));
%     if isempty(xt_)==1
%         xt_=NaN;
%     end
%     xt=[xt; xt_];
%     rasts=[rasts; Z];
%     clear Z tq xt_
% end
% MatPlot(1:size(xuncert,1),1:max(xt))=NaN;
% for tq=1:size(xuncert,1)
%     temptq=find(rasts(tq,:)>0);
%     MatPlot(tq,1:length(temptq))=temptq;
% end
% rastList=MatPlot;
% rasIntv=1;
% LWidth=1;
% LColor='k';
% maxY_rast=tq+RSTP;
% 
% for line = 1:size(rastList,1)
%     hold on
%     curY_rast = maxY_rast-rasIntv*line;
%     plot([rastList(line,:); rastList(line,:)],...
%         [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
%         (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor )
% end
% clear xuncert rasts MatPlot rastList
% ylim([0 PlotYm])
% 
% 
% nsubplot(165,165,100:121,46:66)
% h1=area((actp75));
% h1.FaceColor = 'red';
% axis([0 6000 0 100]);
% xlabel('time(s)')
% x=[750,750]; y=[0,150]; plot(x,y,'k'); hold on;
% clear x
% x=[1750,1750]; y=[0,150]; plot(x,y,'k'); hold on;
% clear x
% x=[4250,4250]; y=[0,150]; plot(x,y,'k'); hold on;
% clear x
% xuncert=[Rasterscs(prob75,11000-1000-750:13500+1500)];
% xt=[];
% rasts=[];
% for tq=1:size(xuncert,1)
%     Z=xuncert(tq,:);
%     Z(find(Z==1))=(find(Z==1));
%     Z(find(Z==0))=NaN;
%     xt_=length(find(Z>0));
%     if isempty(xt_)==1
%         xt_=NaN;
%     end
%     xt=[xt; xt_];
%     rasts=[rasts; Z];
%     clear Z tq xt_
% end
% MatPlot(1:size(xuncert,1),1:max(xt))=NaN;
% for tq=1:size(xuncert,1)
%     temptq=find(rasts(tq,:)>0);
%     MatPlot(tq,1:length(temptq))=temptq;
% end
% rastList=MatPlot;
% rasIntv=1;
% LWidth=1;
% LColor='k';
% maxY_rast=tq+RSTP;
% 
% for line = 1:size(rastList,1)
%     hold on
%     curY_rast = maxY_rast-rasIntv*line;
%     plot([rastList(line,:); rastList(line,:)],...
%         [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
%         (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor )
% end
% clear xuncert rasts MatPlot rastList
% ylim([0 PlotYm])
% 
% 
% nsubplot(165,165,100:121,72:92)
% h1=area((actp50));
% h1.FaceColor = 'red';
% axis([0 6000 0 100]);
% 
% x=[750,750]; y=[0,150]; plot(x,y,'k'); hold on;
% clear x
% x=[1750,1750]; y=[0,150]; plot(x,y,'k'); hold on;
% clear x
% x=[4250,4250]; y=[0,150]; plot(x,y,'k'); hold on;
% clear x
% xuncert=[Rasterscs(prob50,11000-1000-750:13500+1500)];
% xt=[];
% rasts=[];
% for tq=1:size(xuncert,1)
%     Z=xuncert(tq,:);
%     Z(find(Z==1))=(find(Z==1));
%     Z(find(Z==0))=NaN;
%     xt_=length(find(Z>0));
%     if isempty(xt_)==1
%         xt_=NaN;
%     end
%     xt=[xt; xt_];
%     rasts=[rasts; Z];
%     clear Z tq xt_
% end
% MatPlot(1:size(xuncert,1),1:max(xt))=NaN;
% for tq=1:size(xuncert,1)
%     temptq=find(rasts(tq,:)>0);
%     MatPlot(tq,1:length(temptq))=temptq;
% end
% rastList=MatPlot;
% rasIntv=1;
% LWidth=1;
% LColor='k';
% maxY_rast=tq+RSTP;
% 
% for line = 1:size(rastList,1)
%     hold on
%     curY_rast = maxY_rast-rasIntv*line;
%     plot([rastList(line,:); rastList(line,:)],...
%         [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
%         (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor )
% end
% clear xuncert rasts MatPlot rastList
% ylim([0 PlotYm])
% 
% 
% 
% nsubplot(165,165,100:121,98:118)
% h1=area((actp25));
% h1.FaceColor = 'red';
% axis([0 6000 0 100]);
% 
% x=[750,750]; y=[0,150]; plot(x,y,'k'); hold on;
% clear x
% x=[1750,1750]; y=[0,150]; plot(x,y,'k'); hold on;
% clear x
% x=[4250,4250]; y=[0,150]; plot(x,y,'k'); hold on;
% clear x
% xuncert=[Rasterscs(prob25,11000-1000-750:13500+1500)];
% xt=[];
% rasts=[];
% for tq=1:size(xuncert,1)
%     Z=xuncert(tq,:);
%     Z(find(Z==1))=(find(Z==1));
%     Z(find(Z==0))=NaN;
%     xt_=length(find(Z>0));
%     if isempty(xt_)==1
%         xt_=NaN;
%     end
%     xt=[xt; xt_];
%     rasts=[rasts; Z];
%     clear Z tq xt_
% end
% MatPlot(1:size(xuncert,1),1:max(xt))=NaN;
% for tq=1:size(xuncert,1)
%     temptq=find(rasts(tq,:)>0);
%     MatPlot(tq,1:length(temptq))=temptq;
% end
% rastList=MatPlot;
% rasIntv=1;
% LWidth=1;
% LColor='k';
% maxY_rast=tq+RSTP;
% 
% for line = 1:size(rastList,1)
%     hold on
%     curY_rast = maxY_rast-rasIntv*line;
%     plot([rastList(line,:); rastList(line,:)],...
%         [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
%         (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor )
% end
% clear xuncert rasts MatPlot rastList
% ylim([0 PlotYm])
% 
% 
% nsubplot(165,165,100:121,124:144)
% h5=area((actp0));
% h5.FaceColor = 'green';
% axis([0 6000 0 100]);
% x=[750,750]; y=[0,150]; plot(x,y,'k'); hold on;
% clear x
% x=[1750,1750]; y=[0,150]; plot(x,y,'k'); hold on;
% clear x
% x=[4250,4250]; y=[0,150]; plot(x,y,'k'); hold on;
% clear x
% xuncert=[Rasterscs(prob0,11000-1000-750:13500+1500)];
% xt=[];
% rasts=[];
% for tq=1:size(xuncert,1)
%     Z=xuncert(tq,:);
%     Z(find(Z==1))=(find(Z==1));
%     Z(find(Z==0))=NaN;
%     xt_=length(find(Z>0));
%     if isempty(xt_)==1
%         xt_=NaN;
%     end
%     xt=[xt; xt_];
%     rasts=[rasts; Z];
%     clear Z tq xt_
% end
% MatPlot(1:size(xuncert,1),1:max(xt))=NaN;
% for tq=1:size(xuncert,1)
%     temptq=find(rasts(tq,:)>0);
%     MatPlot(tq,1:length(temptq))=temptq;
% end
% rastList=MatPlot;
% rasIntv=1;
% LWidth=1;
% LColor='k';
% maxY_rast=tq+RSTP;
% 
% for line = 1:size(rastList,1)
%     hold on
%     curY_rast = maxY_rast-rasIntv*line;
%     plot([rastList(line,:); rastList(line,:)],...
%         [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
%         (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor )
% end
% clear xuncert rasts MatPlot rastList
% ylim([0 PlotYm])
% 
% 
% set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
% print('-djpeg', [['Save_'] '_' mat2str(loopCounter)] );
% close all;
% 
% 
% 
% 
