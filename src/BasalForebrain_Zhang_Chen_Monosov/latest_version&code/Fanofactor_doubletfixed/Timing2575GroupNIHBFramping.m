plotsingleneuronfig = 0;
align_signal='evtime.targetontime';
savestruct(xzv).name=TESTFILE;
savestruct(xzv).monkey=MONKEYID_; clear MONKEYID_
%savestruct(xzv).celltype='Ramping';

PRINTYESORNO=0;

% T(1:1501)=NaN;
% savestruct(xzv).FFLASH= T;
% savestruct(xzv).FREWARD=T;
% clear T;




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
    

    

    a100=find(infos.amounttrials==1);
    a75=find(infos.amounttrials==2);
    a50=find(infos.amounttrials==3);
    a25=find(infos.amounttrials==4);
    a0=find(infos.amounttrials==5);
    prob100=find(infos.probtrials==1);
    prob75=find(infos.probtrials==2);
    prob50=find(infos.probtrials==3);
    prob25=find(infos.probtrials==4);
    prob0=find(infos.probtrials==5);
    prob75d=find(infos.probtrials==2 & evtime.rewardtime>0);
    prob50d=find(infos.probtrials==3 & evtime.rewardtime>0);
    prob25d=find(infos.probtrials==4 & evtime.rewardtime>0);
    prob75nd=find(infos.probtrials==2 & evtime.rewardtime==0);
    prob50nd=find(infos.probtrials==3 & evtime.rewardtime==0);
    prob25nd=find(infos.probtrials==4 & evtime.rewardtime==0);
    
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
    % remove reward noise
    trialid_rewdel=find(data(43).x==1);
    trialid_notrewdel=find(data(46).x==1);
    no_noise=(SDFs(trialid_notrewdel,6510:6520));
    yes_noise=(SDFs(trialid_rewdel,6510:6520));
    %
    yes_remove=yes_noise;
    for xremove=1:size(yes_remove,1)
        trialins=randi(size(no_noise,1),1);
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
        trialins=randi(size(no_noise,1),1);
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
        trialins=randi(size(no_noise,1),1);
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
        trialins=randi(size(no_noise,1),1);
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
        trialins=randi(size(no_noise,1),1);
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
        trialins=randi(size(no_noise,1),1);
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
        trialins=randi(size(no_noise,1),1);
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
        trialins=randi(size(no_noise,1),1);
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
        trialins=randi(size(no_noise,1),1);
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
        trialins=randi(size(no_noise,1),1);
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
    
    
    %Average rasters in Bins
    binwindow = [0:50];
    binstep = 20;
    BinRasters = [];
    Bintime = [];
    
    for i = 1: floor((length(Rasterscs)-length(binwindow))/binstep)+1
        iii = (i-1)*binstep+1;
        BinRasters(:,i) = sum(Rasterscs(:, iii+binwindow),2)./length(binwindow)*1000;
        Bintime(1,i) = iii+median(binwindow)/2-5000-1500; % align 0 on the outcome of reward.
    end
    %for analyses use RASTERS (spike count)
    Rasters=Rasters(:,5000-1000-500:5000+1500+1000);
    
    
    %PostRasterAnalysis;
    %%%%%%%%%%%%%%% for clastering
%     temp=SDFcs_n([completedtrial],5500:6500);
%     temp1=repmat([1:1001],size(temp,1),1);
%     [Pval,Rval]=permutation_pair_test_fast(temp(:),temp1(:),NumberofPermutations,'corr');
%     savestruct(xzv).P_ramp=Pval;
%     savestruct(xzv).R_ramp=Rval;
    
    
    temp=SDFcs_n(completedtrialAmt,5000-1000:6500);
    Amt_=nanmean(temp);
    temp=SDFcs_n(completedtrialProb,5000-1000:6500);
    Prob_=nanmean(temp);
    Amt_=(Amt_-nanmean(Amt_(1:1000)));
    Prob_=(Prob_-nanmean(Prob_(1:1000)));
    savestruct(xzv).Amt_=Amt_;
    savestruct(xzv).Prob_=Prob_;
    
    Amt_=smooth(Amt_(1000:end),100)';
    Prob_=smooth(Prob_(1000:end),100)';
    
    All_=[Amt_'; [NaN NaN NaN]'; Prob_';];
    All_=All_-min(All_);
    All_=All_./max(All_);
    savestruct(xzv).All_=All_;
    clear temp


%average vectors
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
% 
% analysiswindow=[6000:6500];
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


% popwindow=[5000:5000+2500];
% savestruct(xzv).actp100sA=nanmean(SDFcs_n(prob100,popwindow));
% savestruct(xzv).actp75sA=nanmean(SDFcs_n(prob75,popwindow));
% savestruct(xzv).actp75dsA=nanmean(SDFcs_n(prob75d,popwindow));
% savestruct(xzv).actp75ndsA=nanmean(SDFcs_n(prob75nd,popwindow));
% savestruct(xzv).actp50sA=nanmean(SDFcs_n(prob50,popwindow));
% savestruct(xzv).actp50dsA=nanmean(SDFcs_n(prob50d,popwindow));
% savestruct(xzv).actp50ndsA=nanmean(SDFcs_n(prob50nd,popwindow));
% savestruct(xzv).actp25sA=nanmean(SDFcs_n(prob25,popwindow));
% savestruct(xzv).actp25dsA=nanmean(SDFcs_n(prob25d,popwindow));
% savestruct(xzv).actp25ndsA=nanmean(SDFcs_n(prob25nd,popwindow));
% savestruct(xzv).actp0sA=nanmean(SDFcs_n(prob0,popwindow));
% savestruct(xzv).acta100sA=nanmean(SDFcs_n(a100,popwindow));
% savestruct(xzv).acta75sA=nanmean(SDFcs_n(a75,popwindow));
% savestruct(xzv).acta50sA=nanmean(SDFcs_n(a50,popwindow));
% savestruct(xzv).acta25sA=nanmean(SDFcs_n(a25,popwindow));
% savestruct(xzv).acta0sA=nanmean(SDFcs_n(a0,popwindow));

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
% 
% 
% % popwindow=[6500-500:6500+2000];
% % savestruct(xzv).actp100=nanmean(SDFcs_n(prob100,popwindow));
% % savestruct(xzv).actp75=nanmean(SDFcs_n(prob75,popwindow));
% % savestruct(xzv).actp75d=nanmean(SDFcs_n(prob75d,popwindow));
% % savestruct(xzv).actp75nd=nanmean(SDFcs_n(prob75nd,popwindow));
% % savestruct(xzv).actp50=nanmean(SDFcs_n(prob50,popwindow));
% % savestruct(xzv).actp50d=nanmean(SDFcs_n(prob50d,popwindow));
% % savestruct(xzv).actp50nd=nanmean(SDFcs_n(prob50nd,popwindow));
% % savestruct(xzv).actp25=nanmean(SDFcs_n(prob25,popwindow));
% % savestruct(xzv).actp25d=nanmean(SDFcs_n(prob25d,popwindow));
% % savestruct(xzv).actp25nd=nanmean(SDFcs_n(prob25nd,popwindow));
% % savestruct(xzv).actp0=nanmean(SDFcs_n(prob0,popwindow));
% % savestruct(xzv).acta100=nanmean(SDFcs_n(a100,popwindow));
% % savestruct(xzv).acta75=nanmean(SDFcs_n(a75,popwindow));
% % savestruct(xzv).acta50=nanmean(SDFcs_n(a50,popwindow));
% % savestruct(xzv).acta25=nanmean(SDFcs_n(a25,popwindow));
% % savestruct(xzv).acta0=nanmean(SDFcs_n(a0,popwindow));
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% popwindow=[5000:5500];
% savestruct(xzv).actp100s=nanmean(SDFcs_n(prob100,popwindow));
% savestruct(xzv).actp75s=nanmean(SDFcs_n(prob75,popwindow));
% savestruct(xzv).actp75ds=nanmean(SDFcs_n(prob75d,popwindow));
% savestruct(xzv).actp75nds=nanmean(SDFcs_n(prob75nd,popwindow));
% savestruct(xzv).actp50s=nanmean(SDFcs_n(prob50,popwindow));
% savestruct(xzv).actp50ds=nanmean(SDFcs_n(prob50d,popwindow));
% savestruct(xzv).actp50nds=nanmean(SDFcs_n(prob50nd,popwindow));
% savestruct(xzv).actp25s=nanmean(SDFcs_n(prob25,popwindow));
% savestruct(xzv).actp25ds=nanmean(SDFcs_n(prob25d,popwindow));
% savestruct(xzv).actp25nds=nanmean(SDFcs_n(prob25nd,popwindow));
% savestruct(xzv).actp0s=nanmean(SDFcs_n(prob0,popwindow));
% savestruct(xzv).acta100s=nanmean(SDFcs_n(a100,popwindow));
% savestruct(xzv).acta75s=nanmean(SDFcs_n(a75,popwindow));
% savestruct(xzv).acta50s=nanmean(SDFcs_n(a50,popwindow));
% savestruct(xzv).acta25s=nanmean(SDFcs_n(a25,popwindow));
% savestruct(xzv).acta0s=nanmean(SDFcs_n(a0,popwindow));
% 
% 
% popwindow=[6000:6500];
% savestruct(xzv).actp100l=nanmean(SDFcs_n(prob100,popwindow));
% savestruct(xzv).actp75l=nanmean(SDFcs_n(prob75,popwindow));
% savestruct(xzv).actp75dl=nanmean(SDFcs_n(prob75d,popwindow));
% savestruct(xzv).actp75ndl=nanmean(SDFcs_n(prob75nd,popwindow));
% savestruct(xzv).actp50l=nanmean(SDFcs_n(prob50,popwindow));
% savestruct(xzv).actp50dl=nanmean(SDFcs_n(prob50d,popwindow));
% savestruct(xzv).actp50ndl=nanmean(SDFcs_n(prob50nd,popwindow));
% savestruct(xzv).actp25l=nanmean(SDFcs_n(prob25,popwindow));
% savestruct(xzv).actp25dl=nanmean(SDFcs_n(prob25d,popwindow));
% savestruct(xzv).actp25ndl=nanmean(SDFcs_n(prob25nd,popwindow));
% savestruct(xzv).actp0l=nanmean(SDFcs_n(prob0,popwindow));
% savestruct(xzv).acta100l=nanmean(SDFcs_n(a100,popwindow));
% savestruct(xzv).acta75l=nanmean(SDFcs_n(a75,popwindow));
% savestruct(xzv).acta50l=nanmean(SDFcs_n(a50,popwindow));
% savestruct(xzv).acta25l=nanmean(SDFcs_n(a25,popwindow));
% savestruct(xzv).acta0l=nanmean(SDFcs_n(a0,popwindow));
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% 
% %reward dilivery window
% popwindow=[6500:6500+1000];
% savestruct(xzv).actp100R=nanmean(SDFcs_n(prob100,popwindow));
% savestruct(xzv).actp75R=nanmean(SDFcs_n(prob75,popwindow));
% savestruct(xzv).actp75dR=nanmean(SDFcs_n(prob75d,popwindow));
% savestruct(xzv).actp75ndR=nanmean(SDFcs_n(prob75nd,popwindow));
% savestruct(xzv).actp50R=nanmean(SDFcs_n(prob50,popwindow));
% savestruct(xzv).actp50dR=nanmean(SDFcs_n(prob50d,popwindow));
% savestruct(xzv).actp50ndR=nanmean(SDFcs_n(prob50nd,popwindow));
% savestruct(xzv).actp25R=nanmean(SDFcs_n(prob25,popwindow));
% savestruct(xzv).actp25dR=nanmean(SDFcs_n(prob25d,popwindow));
% savestruct(xzv).actp25ndR=nanmean(SDFcs_n(prob25nd,popwindow));
% savestruct(xzv).actp0R=nanmean(SDFcs_n(prob0,popwindow));
% 
% 
% 
% popwindow=[5000:5000+2500];
% savestruct(xzv).actp100sA=nanmean(SDFcs_n(prob100,popwindow));
% savestruct(xzv).actp75sA=nanmean(SDFcs_n(prob75,popwindow));
% savestruct(xzv).actp75dsA=nanmean(SDFcs_n(prob75d,popwindow));
% savestruct(xzv).actp75ndsA=nanmean(SDFcs_n(prob75nd,popwindow));
% savestruct(xzv).actp50sA=nanmean(SDFcs_n(prob50,popwindow));
% savestruct(xzv).actp50dsA=nanmean(SDFcs_n(prob50d,popwindow));
% savestruct(xzv).actp50ndsA=nanmean(SDFcs_n(prob50nd,popwindow));
% savestruct(xzv).actp25sA=nanmean(SDFcs_n(prob25,popwindow));
% savestruct(xzv).actp25dsA=nanmean(SDFcs_n(prob25d,popwindow));
% savestruct(xzv).actp25ndsA=nanmean(SDFcs_n(prob25nd,popwindow));
% savestruct(xzv).actp0sA=nanmean(SDFcs_n(prob0,popwindow));
% savestruct(xzv).acta100sA=nanmean(SDFcs_n(a100,popwindow));
% savestruct(xzv).acta75sA=nanmean(SDFcs_n(a75,popwindow));
% savestruct(xzv).acta50sA=nanmean(SDFcs_n(a50,popwindow));
% savestruct(xzv).acta25sA=nanmean(SDFcs_n(a25,popwindow));
% savestruct(xzv).acta0sA=nanmean(SDFcs_n(a0,popwindow));
% 
% 
% 
% 
% popwindow=[5000-1000-750:6500+1500];
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
% 
% %trial by trial sdfcs_n front trial start-1000 to 1000+trialend
% popwindow = [6500-500:6500+2000];
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
popwindow=[6500-500:6500+2000];
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
%front trial start-1000 to 1000+trialend
popwindow = [6500-500:6500+2000];
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
popwindow = [5000-1000:6500+1000];
savestruct(xzv).mean_for_zscore =  nanmean(nansum(Rasterscs(:,popwindow)'))./length(popwindow).*1000;
savestruct(xzv).std_for_zscore = nanstd(nansum(Rasterscs(:,popwindow)'))./length(popwindow).*1000;

%%%%%%Fanofactor

RangeAn=[5000-1500:5000+1500+1000];
RastersFano=Rasterscs(:,RangeAn);
trialtypesall=[ length(prob50)
    length(prob75)
    length(prob25)
    ];
fano100inc= RastersFano (prob100,:);
fano75inc= RastersFano (prob75,:);
fano50inc= RastersFano (prob50,:);
fano25inc= RastersFano (prob25,:);
fano0inc = RastersFano (prob0,:);
fanoAllinc= RastersFano ([prob25; prob50; prob75],:);

fano75nd= RastersFano (prob75nd,:);
fano50nd= RastersFano (prob50nd,:);
fano25nd= RastersFano (prob25nd,:);
fano0nd= RastersFano (prob0,:);
fanoAll= RastersFano ([prob25nd; prob50nd; prob75nd],:); %%%%75 50 25 long dilivery.


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
    
    savestruct(xzv).AllSDFomit= nanmean(SDFcs_n([prob25nd; prob50nd; prob75nd],RangeAn));
    
    savestruct(xzv).SDF100= nanmean(SDFcs_n(prob100,RangeAn));
    savestruct(xzv).SDF75= nanmean(SDFcs_n(prob75,RangeAn));
    savestruct(xzv).SDF50= nanmean(SDFcs_n(prob50,RangeAn));
    savestruct(xzv).SDF25= nanmean(SDFcs_n(prob25,RangeAn));
    savestruct(xzv).SDF0= nanmean(SDFcs_n(prob0,RangeAn));
    
    savestruct(xzv).AllSDF= nanmean(SDFcs_n([prob25; prob50; prob75],RangeAn));
    
    
    
    FanoSave25=[];  FanoSave50=[];  FanoSave75=[];  FanoSave0=[]; FanoSaveAll=[];
    FanoSaveAllinc=[]; FanoSave25inc=[];  FanoSave50inc=[];  FanoSave75inc=[]; FanoSave100=[];
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
% popwindow = [5000:5000+1500];
% figure;
% plot(nanmean(SDFcs_n(prob100,popwindow)),'r');hold on;
% plot(nanmean(SDFcs_n(prob75,popwindow)),'m');hold on;
% plot(nanmean(SDFcs_n(prob50,popwindow)),'b');hold on;
% plot(nanmean(SDFcs_n(prob25,popwindow)),'g');hold on;
% plot(nanmean(SDFcs_n(prob0,popwindow)),'k');
% title([savestruct(xzv).celltype,' ', savestruct(xzv).name]);
% print([savestruct(xzv).name(1:end)],'-dpng')
% 
% close all;
%%%%%%%%%%%%%%%%%%%%%%%%


if plotsingleneuronfig ==1
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
end



