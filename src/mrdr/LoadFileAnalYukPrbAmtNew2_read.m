clear all; clear; close all; warning off; clc;
addpath('HELPER_GENERAL'); %keep helpers functions here
ana_fractal_set=3; %1 is set 1 only; 2 is set 2 only; %3 is all sets
threshfix=5.5; %window size

SF50amt100=[];
SF50amt75=[];
SF50amt50=[];
SF50amt25=[];
SF50amt0=[];
SF50prob100=[];
SF50prob75=[];
SF50prob50=[];
SF50prob25=[];
SF50prob0=[];
SF50prob75r=[];
SF50prob50r=[];
SF50prob25r=[];
SF50prob75nr=[];
SF50prob50nr=[];
SF50prob25nr=[];
RTimes=[];
LickingTZ=[];
LookingT=[];
TrialIndex_=[];
CorrProb=[];
CorrAmt=[];
CorrProbP=[];
CorrAmtP=[];
LeftTrials=[];
RightTrials=[];
CenterTrials=[];
amt100vs75=[];
amt100vs50=[];
amt100vs25=[];
amt100vs0=[];
amt75vs50=[];
amt75vs25=[];
amt75vs0=[];
amt50vs25=[];
amt50vs0=[];
amt25vs0=[];
prob100vs75=[];
prob100vs50=[];
prob100vs25=[];
prob100vs0=[];
prob75vs75=[];
prob75vs50=[];
prob75vs0=[];
prob50vs25=[];
prob50vs0=[];
prob50vs0=[];
prob100vs75=[];
prob100vs50=[];
prob100vs25=[];
prob100vs0=[];
prob75vs50=[];
prob75vs25=[];
prob75vs0=[];
prob50vs25=[];
prob50vs0=[];
prob25vs0=[];
amt100vsprob100=[];
amt100vsprob75=[];
amt100vsprob50=[];
amt100vsprob25=[];
amt100vsprob0=[];
amt75vsprob100=[];
amt75vsprob75=[];
amt75vsprob50=[];
amt75vsprob25=[];
amt75vsprob0=[];
amt50vsprob100=[];
amt50vsprob75=[];
amt50vsprob50=[];
amt50vsprob25=[];
amt50vsprob0=[];
amt25vsprob100=[];
amt25vsprob75=[];
amt25vsprob50=[];
amt25vsprob25=[];
amt25vsprob0=[];
amt0vsprob100=[];
amt0vsprob75=[];
amt0vsprob50=[];
amt0vsprob25=[];
amt0vsprob0=[];
pvaluesamt=[];
pvaluesprob=[];
directionamt=[];
directionprob=[];
widthamt=[];
widthprob=[];
uncertaintyvs100P=[];
uncertaintyvs0P=[];
b50vs75P=[];
b50vs25P=[];
latencies=[];
UPE=[];
UPEP=[];

LOOKINGAMT=[];
LOOKINGPROB=[];

[ndata, text, alldata]=xlsread('septumprobamt.xls');
celldata=xlsread('septumprobamt.xls');

Sess_id=(find((celldata(:,7))==2));
SPIKES=celldata(Sess_id,1);
FILENAM=alldata(Sess_id,2);
MONKEYID=celldata(Sess_id,3);
%%%
AnalysisWindow=[5150:6500];     %CS OFF and REWARD IS AT 6500
permnumber=2000;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



for zzzz=1:length(SPIKES)
    clc
    spka=(SPIKES(zzzz));



    TESTFILE=(cell2mat(FILENAM(zzzz)));
    %
    if MONKEYID(zzzz)==1
        TESTFILE=['han' TESTFILE]
    elseif MONKEYID(zzzz)==2
        TESTFILE=['peek' TESTFILE]
    end
    zzzz
    %



    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    d=mrdr('-a', '-d', TESTFILE);
    d=d(2:length(d));
    d=d(1:length(d)-1);
    align_signal='evtime.targetontime';

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


    fam100=23510;
    novel100=23512;
    fam50=23530;
    novel50=23532;
    fam0=23550;
    novel0=23552;

    fam_choice100v50=3012;
    fam_choice100v0=3013;
    fam_choice50v0=3023;

    novel_choice100v50=4012;
    novel_choice100v0=4013;
    novel_choice50v0=4023;


    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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


    if ana_fractal_set==1
        CDS=[];
        for x=1:size(d,2)
            if isempty(find(codes(x).save==8880))==1
            else
                CDS=[CDS; x];
            end
        end
        codes=codes(CDS);
        d=d(CDS);
    end
    if ana_fractal_set==2
        CDS=[];
        for x=1:size(d,2)
            if isempty(find(codes(x).save==8881))==1
            else
                CDS=[CDS; x];
            end
        end
        codes=codes(CDS);
        d=d(CDS);
    end

    if ana_fractal_set==3
        CDS1(1:100)=1;
        CDS2(1:100)=1;
    end

    if size(d,2)>40 & length(CDS1)>60 & length(CDS2)>60

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
        clear findcodes



        alltrialsid(1:length(infos.probtrials))=0;
        alltrialsid(find(~isnan(infos.probtrials)==1))=1;
        alltrialsid(find(~isnan(infos.amounttrials)==1))=1;
        looktime=[];
        for bnbn=1:length(alltrialsid)
            if isnan(alltrialsid(bnbn))==1
                looktime=[looktime; NaN;];
            else
                try
                    %look at CS
                    st_=evtime.targetontime(bnbn);%-d(Tsac).aStartTime;
                    st_=st_-evtime.analogstart(bnbn);
                    en_=st_+1500;
                    %look at tS
                    %st_=evtime.targetontime(bnbn)-1000;%-d(Tsac).aStartTime;
                    %en_=evtime.targetontime(bnbn);

                    eyepos=[d(bnbn).Signals(1).Signal(st_:en_); d(bnbn).Signals(2).Signal(st_:en_)];
                    %plot(eyepos(1,:),eyepos(2,:)); axis([-10 10 -10 10])
                    %infos.probtrials(bnbn)
                    %infos.amounttrials(bnbn)
                    close all
                    %threshold based on fixation spot

                    hor=find(eyepos(1,:)<threshfix & eyepos(1,:)>(threshfix*-1));
                    ver=find(eyepos(2,:)<threshfix & eyepos(2,:)>(threshfix*-1));
                    looktimeTEMP=length(intersect(ver,hor));
                    looktime=[looktime; (looktimeTEMP/1501)*100];
                    clear hor ver eyepos st_ en_
                catch
                    looktime=[looktime; NaN;];
                end

            end
        end
        infos.looktime=looktime; clear looktime bnbn alltrialsid

        lookingprob=[nanmean(infos.looktime(find(infos.probtrials==1)));
            nanmean(infos.looktime(find(infos.probtrials==2)));
            nanmean(infos.looktime(find(infos.probtrials==3)));
            nanmean(infos.looktime(find(infos.probtrials==4)));
            nanmean(infos.looktime(find(infos.probtrials==5)))]';
        lookingamt=[nanmean(infos.looktime(find(infos.amounttrials==1)));
            nanmean(infos.looktime(find(infos.amounttrials==2)));
            nanmean(infos.looktime(find(infos.amounttrials==3)));
            nanmean(infos.looktime(find(infos.amounttrials==4)));
            nanmean(infos.looktime(find(infos.amounttrials==5)))]';
        LOOKINGAMT=[LOOKINGAMT;lookingamt];
        LOOKINGPROB=[LOOKINGPROB;lookingprob];
        clear lookingamt lookingprob




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




        clear temp temp2
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        CENTER=5001;
        %align spikes
        align_signal=(align_signal);
        SDFs=[];
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
            SDFs=[SDFs; temp];
            clear alignval singtrialspk x temp temp1 x singtrialspk
        end


        %         data(43).x=(infos.probtrials==2 & evtime.rewardtime>0);
        %             data(46).x=(infos.probtrials==2 & evtime.rewardtime==0);
        %
        %     data(44).x=(infos.probtrials==3 & evtime.rewardtime>0);
        %         data(47).x=(infos.probtrials==3 & evtime.rewardtime==0);
        %
        %     data(45).x=(infos.probtrials==4 & evtime.rewardtime>0);
        %     data(48).x=(infos.probtrials==4 & evtime.rewardtime==0);

        %remove reward/airpuff noises%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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






        %%
        %% remove airpuff noise

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





        c1={SDFs};
        SDF=plot_mean_psth(c1,50,1,(CENTER*2)-2,1); close all;

        for zzz=1:length(data)
            try
                temp=(data(zzz).x);
                temp=find(temp==1);
                data(zzz).SDF=SDF(temp,:);
                data(zzz).RASTER=SDFs(temp,:);
                close all
                clear X Y Xt1 Yt1 t1 xx yy temp c1
                clear Hist_raw_one temp BASELINE BASELINE50
            end
        end

        %
        %
            maxrate=100
            figure
            subplot(5,2,1)
            plot(nanmean(data(33).SDF),'k'); ylim([0 maxrate]); xlim([3000 7000])
            %hold on; plot(3000,[0 :maxrate]);hold on; plot(4000,[0 :maxrate]);hold on; plot(2000,[0 :maxrate]);
            axis square;
            subplot(5,2,3)
            plot(nanmean(data(34).SDF),'k'); ylim([0 maxrate]); xlim([3000 7000])
            %hold on; plot(3000,[0 :maxrate]);hold on; plot(4000,[0 :maxrate]);hold on; plot(2000,[0 :maxrate]);
            axis square;
            subplot(5,2,5)
            plot(nanmean(data(35).SDF),'k'); ylim([0 maxrate]); xlim([3000 7000])
            %hold on; plot(3000,[0 :maxrate]);hold on; plot(4000,[0 :maxrate]);hold on; plot(2000,[0 :maxrate]);
            axis square;
            subplot(5,2,7)
            plot(nanmean(data(36).SDF),'k'); ylim([0 maxrate]); xlim([3000 7000])
            %hold on; plot(3000,[0 :maxrate]);hold on; plot(4000,[0 :maxrate]);hold on; plot(2000,[0 :maxrate]);
            axis square;
            subplot(5,2,9)
            plot(nanmean(data(37).SDF),'k'); ylim([0 maxrate]); xlim([3000 7000])
            %hold on; plot(3000,[0 :maxrate]);hold on; plot(4000,[0 :maxrate]);hold on; plot(2000,[0 :maxrate]);
            axis square;
            subplot(5,2,2)
            plot(nanmean(data(38).SDF),'g'); ylim([0 maxrate]); xlim([3000 7000])
            %hold on; plot(3000,[0 :maxrate]);hold on; plot(4000,[0 :maxrate]);hold on; plot(2000,[0 :maxrate]);
            axis square;
            subplot(5,2,4)
            plot(nanmean(data(39).SDF),'g'); ylim([0 maxrate]); xlim([3000 7000])
            %hold on; plot(3000,[0 :maxrate]);hold on; plot(4000,[0 :maxrate]);hold on; plot(2000,[0 :maxrate]);
            axis square;
            subplot(5,2,6)
            plot(nanmean(data(40).SDF),'g'); ylim([0 maxrate]); xlim([3000 7000])
            %hold on; plot(3000,[0 :maxrate]);hold on; plot(4000,[0 :maxrate]);hold on; plot(2000,[0 :maxrate]);
            axis square;
            subplot(5,2,8)
            plot(nanmean(data(41).SDF),'g'); ylim([0 maxrate]); xlim([3000 7000])
            %hold on; plot(3000,[0 :maxrate]);hold on; plot(4000,[0 :maxrate]);hold on; plot(2000,[0 :maxrate]);
            axis square;
            subplot(5,2,10)
            plot(nanmean(data(42).SDF),'g'); ylim([0 maxrate]); xlim([3000 7000])
            %hold on; plot(3000,[0 :maxrate]);hold on; plot(4000,[0 :maxrate]);hold on; plot(2000,[0 :maxrate]);
            axis square;

        %     figure
        %      plot(nanmean(data(38).SDF),'r'); ylim([0 maxrate]); xlim([3000 7000]); hold on
        %     plot(nanmean(data(39).SDF),'b'); ylim([0 maxrate]); xlim([3000 7000]); hold on
        %     plot(nanmean(data(40).SDF),'m'); ylim([0 maxrate]); xlim([3000 7000]); hold on
        %     plot(nanmean(data(41).SDF),'k'); ylim([0 maxrate]); xlim([3000 7000]); hold on
        %     plot(nanmean(data(42).SDF),'y'); ylim([0 maxrate]); xlim([3000 7000]); hold on
        %     ylim([0 75]);
        %
             ranksum(nanmean(data(40).SDF(:,5150:6500)')',nanmean(data(38).SDF(:,5150:6500)')')

        close all;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %         amountrho=[];
        %         amountp=[];
        %         probrho=[];
        %         probp=[];
        %         for ggg=5000:6500
        %             V1=(data(33).SDF(:,ggg)');
        %             V2=(data(34).SDF(:,ggg)');
        %             V3=(data(35).SDF(:,ggg)');
        %             V4=(data(36).SDF(:,ggg)');
        %             V5=(data(37).SDF(:,ggg)');
        %             V1=V1(find(~isnan(V1)==1));
        %             V2=V2(find(~isnan(V2)==1));
        %             V3=V3(find(~isnan(V3)==1));
        %             V4=V4(find(~isnan(V4)==1));
        %             V5=V5(find(~isnan(V5)==1));
        %             V1leng(1:length(V1))=1;
        %             V2leng(1:length(V2))=2;
        %             V3leng(1:length(V3))=3;
        %             V4leng(1:length(V4))=4;
        %             V5leng(1:length(V5))=5;
        %             tempV1=[V1 V2 V3 V4 V5]';
        %             tempV1leng=[V1leng V2leng V3leng V4leng V5leng]';
        %             try
        %                 [pval, r]=permutation_pair_test_fast(tempV1,tempV1leng,permnumber,'rankcorr');
        %             catch
        %                 r=NaN;
        %                 pval=NaN;
        %             end
        %             amountrho=[amountrho; r];
        %             amountp=[amountp; pval];
        %             clear V1leng V2leng V3leng V4leng V5leng
        %             %%%
        %             V1=(data(38).SDF(:,ggg)');
        %             V2=(data(39).SDF(:,ggg)');
        %             V3=(data(40).SDF(:,ggg)');
        %             V4=(data(41).SDF(:,ggg)');
        %             V5=(data(42).SDF(:,ggg)');
        %             V1=V1(find(~isnan(V1)==1));
        %             V2=V2(find(~isnan(V2)==1));
        %             V3=V3(find(~isnan(V3)==1));
        %             V4=V4(find(~isnan(V4)==1));
        %             V5=V5(find(~isnan(V5)==1));
        %             V1leng(1:length(V1))=1;
        %             V2leng(1:length(V2))=2;
        %             V3leng(1:length(V3))=3;
        %             V4leng(1:length(V4))=4;
        %             V5leng(1:length(V5))=5;
        %             tempV1=[V1 V2 V3 V4 V5]';
        %             tempV1leng=[V1leng V2leng V3leng V4leng V5leng]';
        %             try
        %                 [pval, r]=permutation_pair_test_fast(tempV1,tempV1leng,permnumber,'rankcorr');
        %             catch
        %                 r=NaN;
        %                 pval=NaN;
        %             end
        %             probrho=[probrho; r];
        %             probp=[probp; pval];
        %             clear V1leng V2leng V3leng V4leng V5leng
        %             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %             clear V1 V2 V3 V4 V5 V1leng V2leng V3leng V4leng V5leng tempV1 tempV1leng r pval
        %         end
        %         linepar(zzzz).probrho=probrho;
        %         linepar(zzzz).amountrho=amountrho;
        %         linepar(zzzz).probp=probp;
        %         linepar(zzzz).amountp=amountp;


        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%linear
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%fits
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        limnnn=5;
        limend=15;

        trialsregs=[];
        trialsregs_nums=[];
        for yreg=1:size(data(33).SDF,1)
            tempxreg=[];
            for xreg=limnnn:limend
                %tempforreg=(data(33).SDF(yreg,5000+xreg*100:5000+((xreg+1)*100)));
                tempforreg=(data(33).SDF(yreg,5000+xreg*100:5000+((xreg)*100)));

                tempxreg=[tempxreg; nanmean(tempforreg)];
            end
            trialsregs=[trialsregs; tempxreg'];
            tempyreg(1:length(tempxreg))=1:length(tempxreg);
            trialsregs_nums=[trialsregs_nums; tempyreg];

            clear tempxreg xreg tempyreg
        end
        y1=trialsregs(:);
        x=trialsregs_nums(:);
        [pval, r]=permutation_pair_test_fast(x,y1,permnumber,'rankcorr')
        P = polyfit(x,y1,1);
        yfit = P(1)*x+P(2);
        linepar(zzzz).P33=P;
        linepar(zzzz).x33=x;
        linepar(zzzz).yfit33=yfit;
        linepar(zzzz).pval33=pval;
        linepar(zzzz).r33=r;
        trialsregs=[];
        trialsregs_nums=[];
        for yreg=1:size(data(34).SDF,1)
            tempxreg=[];
            for xreg=limnnn:limend
                tempforreg=(data(34).SDF(yreg,5000+xreg*100:5000+((xreg)*100)));
                tempxreg=[tempxreg; nanmean(tempforreg)];
            end
            trialsregs=[trialsregs; tempxreg'];
            tempyreg(1:length(tempxreg))=1:length(tempxreg);
            trialsregs_nums=[trialsregs_nums; tempyreg];

            clear tempxreg xreg tempyreg
        end
        y1=trialsregs(:);
        x=trialsregs_nums(:);
        [pval, r]=permutation_pair_test_fast(x,y1,permnumber,'rankcorr');
        P = polyfit(x,y1,1);
        yfit = P(1)*x+P(2);
        linepar(zzzz).P34=P;
        linepar(zzzz).x34=x;
        linepar(zzzz).yfit34=yfit;
        linepar(zzzz).pval34=pval;
        linepar(zzzz).r34=r;
        trialsregs=[];
        trialsregs_nums=[];
        for yreg=1:size(data(35).SDF,1)
            tempxreg=[];
            for xreg=limnnn:limend
                tempforreg=(data(35).SDF(yreg,5000+xreg*100:5000+((xreg)*100)));
                tempxreg=[tempxreg; nanmean(tempforreg)];
            end
            trialsregs=[trialsregs; tempxreg'];
            tempyreg(1:length(tempxreg))=1:length(tempxreg);
            trialsregs_nums=[trialsregs_nums; tempyreg];

            clear tempxreg xreg tempyreg
        end
        y1=trialsregs(:);
        x=trialsregs_nums(:);
        [pval, r]=permutation_pair_test_fast(x,y1,permnumber,'rankcorr');
        P = polyfit(x,y1,1);
        yfit = P(1)*x+P(2);
        linepar(zzzz).P35=P;
        linepar(zzzz).x35=x;
        linepar(zzzz).yfit35=yfit;
        linepar(zzzz).pval35=pval;
        linepar(zzzz).r35=r;
        trialsregs=[];
        trialsregs_nums=[];
        for yreg=1:size(data(36).SDF,1)
            tempxreg=[];
            for xreg=limnnn:limend
                tempforreg=(data(36).SDF(yreg,5000+xreg*100:5000+((xreg)*100)));
                tempxreg=[tempxreg; nanmean(tempforreg)];
            end
            trialsregs=[trialsregs; tempxreg'];
            tempyreg(1:length(tempxreg))=1:length(tempxreg);
            trialsregs_nums=[trialsregs_nums; tempyreg];

            clear tempxreg xreg tempyreg
        end
        y1=trialsregs(:);
        x=trialsregs_nums(:);
        [pval, r]=permutation_pair_test_fast(x,y1,permnumber,'rankcorr');
        P = polyfit(x,y1,1);
        yfit = P(1)*x+P(2);
        linepar(zzzz).P36=P;
        linepar(zzzz).x36=x;
        linepar(zzzz).yfit36=yfit;
        linepar(zzzz).pval36=pval;
        linepar(zzzz).r36=r;
        trialsregs=[];
        trialsregs_nums=[];
        for yreg=1:size(data(37).SDF,1)
            tempxreg=[];
            for xreg=limnnn:limend
                tempforreg=(data(37).SDF(yreg,5000+xreg*100:5000+((xreg)*100)));
                tempxreg=[tempxreg; nanmean(tempforreg)];
            end
            trialsregs=[trialsregs; tempxreg'];
            tempyreg(1:length(tempxreg))=1:length(tempxreg);
            trialsregs_nums=[trialsregs_nums; tempyreg];
            clear tempxreg xreg tempyreg
        end
        y1=trialsregs(:);
        x=trialsregs_nums(:);
        [pval, r]=permutation_pair_test_fast(x,y1,permnumber,'rankcorr');
        P = polyfit(x,y1,1);
        yfit = P(1)*x+P(2);
        linepar(zzzz).P37=P;
        linepar(zzzz).x37=x;
        linepar(zzzz).yfit37=yfit;
        linepar(zzzz).pval37=pval;
        linepar(zzzz).r37=r;
        trialsregs=[];
        trialsregs_nums=[];
        for yreg=1:size(data(38).SDF,1)
            tempxreg=[];
            for xreg=limnnn:limend
                tempforreg=(data(38).SDF(yreg,5000+xreg*100:5000+((xreg)*100)));
                tempxreg=[tempxreg; nanmean(tempforreg)];
            end
            trialsregs=[trialsregs; tempxreg'];
            tempyreg(1:length(tempxreg))=1:length(tempxreg);
            trialsregs_nums=[trialsregs_nums; tempyreg];
            clear tempxreg xreg tempyreg
        end
        y1=trialsregs(:);
        x=trialsregs_nums(:);
        [pval, r]=permutation_pair_test_fast(x,y1,permnumber,'rankcorr');
        P = polyfit(x,y1,1);
        yfit = P(1)*x+P(2);
        linepar(zzzz).P38=P;
        linepar(zzzz).x38=x;
        linepar(zzzz).yfit38=yfit;
        linepar(zzzz).pval38=pval;
        linepar(zzzz).r38=r;
        trialsregs=[];
        trialsregs_nums=[];
        for yreg=1:size(data(39).SDF,1)
            tempxreg=[];
            for xreg=limnnn:limend
                tempforreg=(data(39).SDF(yreg,5000+xreg*100:5000+((xreg)*100)));
                tempxreg=[tempxreg; nanmean(tempforreg)];
            end
            trialsregs=[trialsregs; tempxreg'];
            tempyreg(1:length(tempxreg))=1:length(tempxreg);
            trialsregs_nums=[trialsregs_nums; tempyreg];
            clear tempxreg xreg tempyreg
        end
        y1=trialsregs(:);
        x=trialsregs_nums(:);
        [pval, r]=permutation_pair_test_fast(x,y1,permnumber,'rankcorr');
        P = polyfit(x,y1,1);
        yfit = P(1)*x+P(2);
        linepar(zzzz).P39=P;
        linepar(zzzz).x39=x;
        linepar(zzzz).yfit39=yfit;
        linepar(zzzz).pval39=pval;
        linepar(zzzz).r39=r;
        trialsregs=[];
        trialsregs_nums=[];
        for yreg=1:size(data(40).SDF,1)
            tempxreg=[];
            for xreg=limnnn:limend
                tempforreg=(data(40).SDF(yreg,5000+xreg*100:5000+((xreg)*100)));
                tempxreg=[tempxreg; nanmean(tempforreg)];
            end
            trialsregs=[trialsregs; tempxreg'];
            tempyreg(1:length(tempxreg))=1:length(tempxreg);
            trialsregs_nums=[trialsregs_nums; tempyreg];

            clear tempxreg xreg tempyreg
        end
        y1=trialsregs(:);
        x=trialsregs_nums(:);
        [pval, r]=permutation_pair_test_fast(x,y1,permnumber,'rankcorr');
        P = polyfit(x,y1,1);
        yfit = P(1)*x+P(2);
        linepar(zzzz).P40=P;
        linepar(zzzz).x40=x;
        linepar(zzzz).yfit40=yfit;
        linepar(zzzz).pval40=pval;
        linepar(zzzz).r40=r;
        trialsregs=[];
        trialsregs_nums=[];
        for yreg=1:size(data(41).SDF,1)
            tempxreg=[];
            for xreg=limnnn:limend
                tempforreg=(data(41).SDF(yreg,5000+xreg*100:5000+((xreg)*100)));
                tempxreg=[tempxreg; nanmean(tempforreg)];
            end
            trialsregs=[trialsregs; tempxreg'];
            tempyreg(1:length(tempxreg))=1:length(tempxreg);
            trialsregs_nums=[trialsregs_nums; tempyreg];

            clear tempxreg xreg tempyreg
        end
        y1=trialsregs(:);
        x=trialsregs_nums(:);
        [pval, r]=permutation_pair_test_fast(x,y1,permnumber,'rankcorr');
        P = polyfit(x,y1,1);
        yfit = P(1)*x+P(2);
        linepar(zzzz).P41=P;
        linepar(zzzz).x41=x;
        linepar(zzzz).yfit41=yfit;
        linepar(zzzz).pval41=pval;
        linepar(zzzz).r41=r;
        trialsregs=[];
        trialsregs_nums=[];
        for yreg=1:size(data(42).SDF,1)
            tempxreg=[];
            for xreg=limnnn:limend
                tempforreg=(data(42).SDF(yreg,5000+xreg*100:5000+((xreg)*100)));
                tempxreg=[tempxreg; nanmean(tempforreg)];
            end
            trialsregs=[trialsregs; tempxreg'];
            tempyreg(1:length(tempxreg))=1:length(tempxreg);
            trialsregs_nums=[trialsregs_nums; tempyreg];

            clear tempxreg xreg tempyreg
        end
        y1=trialsregs(:);
        x=trialsregs_nums(:);
        [pval, r]=permutation_pair_test_fast(x,y1,permnumber,'rankcorr');
        P = polyfit(x,y1,1);
        yfit = P(1)*x+P(2);
        linepar(zzzz).P42=P;
        linepar(zzzz).x42=x;
        linepar(zzzz).yfit42=yfit;
        linepar(zzzz).pval42=pval;
        linepar(zzzz).r42=r;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        %     close all
        %     trialsregs=[];
        %     trialsregs_nums=[];
        %     for yreg=1:size(data(40).SDF,1)
        %         tempxreg=[];
        %         for xreg=4.5:14.5
        %             tempforreg=(data(40).SDF(yreg,5000+xreg*100:5000+((xreg+1)*100)));
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
        %     subplot(2,1,1)
        %     scatter(x,y1,25,'b','*')
        %     P = polyfit(x,y1,1);
        %     yfit = P(1)*x+P(2);
        %     hold on;
        %     plot(x,yfit,'r-.');
        %     %slope=P(1)
        %     %%yfit = P(1)*x+P(2) is the equation.... P(1) is the slope and P(2) is the
        %     %%intercept
        %     subplot(2,1,2)
        %     plot(nanmean(data(40).SDF(:,5000:6500)))
        %     linepar(zzzz).P=P;
        %     linepar(zzzz).x=x;
        %     linepar(zzzz).yfit=yfit;


        triallimitcut=1;
        temp=data(33).SDF;
        t=size(temp,1);
        if t<triallimitcut
            tt(1:size(temp,2))=NaN;
            temp=tt; clear tt
        else
            temp=nanmean(temp);
        end
        clear t
        SF50amt100=[SF50amt100; temp]; clear temp
        %
        temp=data(34).SDF;
        t=size(temp,1);
        if t<triallimitcut
            tt(1:size(temp,2))=NaN;
            temp=tt; clear tt
        else
            temp=nanmean(temp);
        end
        clear t
        SF50amt75=[SF50amt75; temp]; clear temp
        %
        temp=data(35).SDF;
        t=size(temp,1);
        if t<triallimitcut
            tt(1:size(temp,2))=NaN;
            temp=tt; clear tt
        else
            temp=nanmean(temp);
        end
        clear t
        SF50amt50=[SF50amt50; temp]; clear temp
        %
        temp=data(36).SDF;
        t=size(temp,1);
        if t<triallimitcut
            tt(1:size(temp,2))=NaN;
            temp=tt; clear tt
        else
            temp=nanmean(temp);
        end
        clear t
        SF50amt25=[SF50amt25; temp]; clear temp
        %
        temp=data(37).SDF;
        t=size(temp,1);
        if t<triallimitcut
            tt(1:size(temp,2))=NaN;
            temp=tt; clear tt
        else
            temp=nanmean(temp);
        end
        clear t
        SF50amt0=[SF50amt0; temp]; clear temp
        %
        temp=data(38).SDF;
        t=size(temp,1);
        if t<triallimitcut
            tt(1:size(temp,2))=NaN;
            temp=tt; clear tt
        else
            temp=nanmean(temp);
        end
        clear t
        SF50prob100=[SF50prob100; temp]; clear temp
        %
        %
        temp=data(39).SDF;
        t=size(temp,1);
        if t<triallimitcut
            tt(1:size(temp,2))=NaN;
            temp=tt; clear tt
        else
            temp=nanmean(temp);
        end
        clear t
        SF50prob75=[SF50prob75; temp]; clear temp
        %
        %
        temp=data(40).SDF;
        t=size(temp,1);
        if t<triallimitcut
            tt(1:size(temp,2))=NaN;
            temp=tt; clear tt
        else
            temp=nanmean(temp);
        end
        clear t
        SF50prob50=[SF50prob50; temp]; clear temp
        %
        %
        temp=data(41).SDF;
        t=size(temp,1);
        if t<triallimitcut
            tt(1:size(temp,2))=NaN;
            temp=tt; clear tt
        else
            temp=nanmean(temp);
        end
        clear t
        SF50prob25=[SF50prob25; temp]; clear temp
        %
        %
        temp=data(42).SDF;
        t=size(temp,1);
        if t<triallimitcut
            tt(1:size(temp,2))=NaN;
            temp=tt; clear tt
        else
            temp=nanmean(temp);
        end
        clear t
        SF50prob0=[SF50prob0; temp]; clear temp
        %
        %
        temp=data(43).SDF;
        t=size(temp,1);
        if t<triallimitcut
            tt(1:size(temp,2))=NaN;
            temp=tt; clear tt
        else
            temp=nanmean(temp);
        end
        clear t
        SF50prob75r=[SF50prob75r; temp]; clear temp
        %
        %
        temp=data(44).SDF;
        t=size(temp,1);
        if t<triallimitcut
            tt(1:size(temp,2))=NaN;
            temp=tt; clear tt
        else
            temp=nanmean(temp);
        end
        clear t
        SF50prob50r=[SF50prob50r; temp]; clear temp
        %

        temp=data(45).SDF;
        t=size(temp,1);
        if t<triallimitcut
            tt(1:size(temp,2))=NaN;
            temp=tt; clear tt
        else
            if size(temp,1)>1
                temp=nanmean(temp);
            end
        end
        clear t
        SF50prob25r=[SF50prob25r; temp]; clear temp
        %
        %
        temp=data(46).SDF;
        t=size(temp,1);
        if t<triallimitcut
            tt(1:size(temp,2))=NaN;
            temp=tt; clear tt
        else
            if size(temp,1)>1
                temp=nanmean(temp);
            end
        end
        clear t
        SF50prob75nr=[SF50prob75nr; temp]; clear temp
        %
        temp=data(47).SDF;
        t=size(temp,1);
        if t<triallimitcut
            tt(1:size(temp,2))=NaN;
            temp=tt; clear tt
        else
            temp=nanmean(temp);
        end
        clear t
        SF50prob50nr=[SF50prob50nr; temp]; clear temp
        %

        temp=data(48).SDF;
        t=size(temp,1);
        if t<triallimitcut
            tt(1:size(temp,2))=NaN;
            temp=tt; clear tt
        else
            temp=nanmean(temp);
        end
        clear t
        SF50prob25nr=[SF50prob25nr; temp]; clear temp


    end

    clear infos data evtime spike SpikeDATA TrialSpikeData_ SpikeDATA_ NEX analogdata ad SDF SDFs probrho amountrho


    close all;


end

    save('probamt.mat');

clear all; clc; warning off; clc;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
