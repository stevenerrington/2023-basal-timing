% StructMakerTimingTrace_V01

%Script level structMaker for packaging TimingTrace


if sum((unique(PDS.fractals) == 6200))==1
    tempSaveStructTrace.TraceVersion =2;
    
    %Stub
    tempSaveStructTrace.DummyDataForOldTrace = 'null';
    
elseif sum((unique(PDS.fractals) == 6250))==1
    tempSaveStructTrace.TraceVersion =3;
    
%     PDS(trials6253).sptimes ;
    %NML  save for Ilya all spike times cleaned
 try

           tempSaveStructTrace.trials6254d = trials6254d;
           tempSaveStructTrace.trials6260d = trials6260d;
           tempSaveStructTrace.trials6301d = trials6301d;
 
           tempSaveStructTrace.trials6254nd = trials6254nd;
           tempSaveStructTrace.trials6260nd = trials6260nd;
           tempSaveStructTrace.trials6301nd = trials6301nd;
    
    
    tempSaveStructTrace.trialsTrace100 = ([trials6253 trials6259]);
    tempSaveStructTrace.trialsTrace50 = [trials6254  trials6260 ];
    
    tempSaveStructTrace.trialsNoTrace100 = trials6300;
    tempSaveStructTrace.trialsNoTrace50 = trials6301;
    
    CLEAN=[trials6253 trials6259 trials6300];
    for x=1:length(CLEAN)
        x=CLEAN(x);
        spk=PDS(1).sptimes{x};
        spk1=spk(find(spk<PDS.timeoutcome(x)));
        spk2=spk(find(spk>PDS.timeoutcome(x)+10/1000));
        spk=[spk1 spk2]; clear spk1 spk2
        %
        try
            no_noise=find(spk>(PDS.timeoutcome(x)+(10/1000)) & spk<(PDS.timeoutcome(x)+(20/1000)));
            no_noise=length(no_noise); %this many spikes in the window  so insert that many spikes in the deleted time range
            grabnumbers=PDS.timeoutcome(x)+randperm(10)/1000;
            grabnumbers=grabnumbers(no_noise);
            spk=[spk grabnumbers];
        end
        PDS(1).sptimes{x}=sort(spk);
        %
        clear y spk spk1 spk2 x
    end
    cleanreward50n=[trials6254nd trials6260nd trials6301nd];
    cleanreward50=[trials6254d trials6260d trials6301d];
    for x=1:length(cleanreward50)
        x=cleanreward50(x);
        spk=PDS(1).sptimes{x};
        spk1=spk(find(spk<PDS.timeoutcome(x)));
        spk2=spk(find(spk>PDS.timeoutcome(x)+10/1000));
        spk=[spk1 spk2]; clear spk1 spk2
        try
            y=cleanreward50n(randperm(length(cleanreward50n))); y=y(1);
            y=PDS(1).sptimes{y};
            
            y=y(find(y>PDS.timeoutcome(x) & y<PDS.timeoutcome(x)+10/1000));
            spk=[spk; y];
        end
        PDS(1).sptimes{x}=sort(spk);
        %
        clear y spk spk1 spk2
    end
    
    
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
    SDFcstrace=plot_mean_psth({Rasters},gauswindow_ms,1,(CENTER*2)-2,1);
     
    tempSaveStructTrace.LogicalRasters =logical(Rasters);
     clear Rasters 
     

    
 catch
 end
 try
      tempSaveStructTrace.SDFcstrace = SDFcstrace ; 
      tempSaveStructTrace.CenterOfCS = CENTER;     
 catch
 end
 try
      tempSaveStructTrace.SDFcstrace50 =nanmean(SDFcstrace([trials6254  trials6260 ]),1) ; 
 catch
 end
  try
      tempSaveStructTrace.SDFcstrace_fractal6260Only =nanmean(SDFcstrace([  trials6260 ]),1) ; 
 catch
  end
  try
      tempSaveStructTrace.SDFcstrace_fractal6264Only =nanmean(SDFcstrace([trials6254   ]),1) ; 
 catch
 end
 
 try
      tempSaveStructTrace.SDFcstrace100 =nanmean(SDFcstrace([trials6253 trials6259]),1) ; 
 catch
 end
 
 try
      tempSaveStructTrace.SDFcstrace_fractal6253Only =nanmean(SDFcstrace([trials6253 ]),1) ; 
 catch
 end
   try
      tempSaveStructTrace.SDFcstrace_fractal6259Only =nanmean(SDFcstrace([ trials6259]),1) ; 
 catch
   end
 
  try
      tempSaveStructTrace.SDFcsNoTrace50 =nanmean(SDFcstrace([trials6301 ]),1) ; 
 catch
 end
 
 try
      tempSaveStructTrace.SDFcsNoTrace100 =nanmean(SDFcstrace([trials6300]),1) ; 
 catch
 end
 
 
 
 
       
    %licking
    if isfield(PDS, 'onlineLickForce')
        numberofstd=2; %for lick detection
        millisecondResolution=0.001;
        ConverTrialsToRealTime=[];
        for x=1:length(PDS.fractals)
            trial=x;
            if PDS.timetargeton(trial)>0 & PDS.fractals2(trial)==0
                x=PDS.onlineLickForce{trial};
                relatveTimePDS = x(:,2)-x(1,2);
                regularTimeVectorForPdsInterval = [0: millisecondResolution  : x(end,2)-x(1,2)];
                regularPdsData = interp1(  relatveTimePDS , x(:,1) , regularTimeVectorForPdsInterval  );
                regularPdsData=regularPdsData(round(PDS.timetargeton(trial)*1000)-1000:round(PDS.timetargeton(trial)*1000)+2500);
                clear regularTimeVectorForPdsInterval relatveTimePDS x
                %x=PDS.EyeJoy{trial}(4,:);
                %x=x(round(PDS.timetargeton(trial)*1000)-1000:round(PDS.timetargeton(trial)*1000)+2500);
            else
                %if target never cameon make it a array full of NaNs;
                regularPdsData(1:3501)=NaN;
            end
            try
                regularPdsData=smooth(regularPdsData)';
            end
            ConverTrialsToRealTime=[ConverTrialsToRealTime; regularPdsData];
            clear x trial regularPdsData
        end
        %baseline=ConverTrialsToRealTime(:,1:200);
        baseline=ConverTrialsToRealTime(:,900:1200);
        baseline=baseline(:);
        baseline=baseline(find(isnan(baseline)==0));
        baselinemean=mean(baseline(:));
        rangemin=baselinemean-(std(baseline)*numberofstd);
        rangemax=baselinemean+(std(baseline)*numberofstd);
        ConverTrialsToRealTime=ConverTrialsToRealTime(:,1001:3501);
        Savelicks=[];
        for x=1:length(PDS.fractals)
            if PDS.timetargeton(x)>0
                x=ConverTrialsToRealTime(x,:);
                x(find(x<rangemin | x>rangemax))=999999;
                x(find(x~=999999))=0;
                x(find(x==999999))=1;
            else
                x(1:2501)=NaN;
            end
            Savelicks=[Savelicks; x]; clear x;
        end
    end
        Savelicks(isnan(Savelicks)) =0;
    tempSaveStructTrace.Savelicks  = logical(Savelicks) ;
    
    %%%%%%%%%%%%%%%%%%%%%
    %% Pupil dialation
    millisecondResolution=0.001;
    ConverTrialsToRealTime=[];
    Savenumberofblinks=[];
    for x=1:length(PDS.fractals)
        trial=x;
        if PDS.timetargeton(trial)>0 & PDS.fractals2(trial)==0
            x=PDS.onlineEye{trial};
            x=x(:,3:4);
            relatveTimePDS = x(:,2)-x(1,2);
            regularTimeVectorForPdsInterval = [0: millisecondResolution  : x(end,2)-x(1,2)];
            regularPdsData = interp1(  relatveTimePDS , x(:,1) , regularTimeVectorForPdsInterval  );
            regularPdsData=regularPdsData(round(PDS.timetargeton(trial)*1000)-1000:round(PDS.timetargeton(trial)*1000)+2500);
            clear regularTimeVectorForPdsInterval relatveTimePDS x
        else
            %if target never cameon make it a array full of NaNs;
            regularPdsData(1:3501)=NaN;
        end
        %remove blinks (very crude)
        regularPdsData(1:40)=NaN;
        findblinks=find(regularPdsData<-4)-40;
        %save blink raster
        temp1(1:3501)=0;
        temp1(find(regularPdsData<-4))=1;
        Savenumberofblinks=[Savenumberofblinks; temp1]; clear f;
        %get rid of blinks out of pupil dillation
        for zz=1:length(findblinks)
            try
                regularPdsData(findblinks(zz):findblinks(zz)+80)=NaN;
            end
            try
                regularPdsData(findblinks(zz):findblinks(zz)+60)=NaN;
            end
            try
                regularPdsData(findblinks(zz):findblinks(zz)+40)=NaN;
            end
        end
        %smooth data if matlab version is new (default is 5place bin)
        try
            regularPdsData=smooth(regularPdsData)';
        end
        
        ConverTrialsToRealTime=[ConverTrialsToRealTime; regularPdsData(1:3501)];
        clear x trial regularPdsData
    end
    %calculate percentage difference relative to fixation at trial start. here
    %use the individual trial's average pupil size
    baseline=ConverTrialsToRealTime(:,900:1200);
    baseline=nanmean(baseline')';
    ConverTrialsToRealTime=ConverTrialsToRealTime(:,1001:3501);
    PercentPupil=[];
    for x=1:length(PDS.fractals)
        if ~isnan(baseline(x))==1
            y=ConverTrialsToRealTime(x,:);
            temp(1:length(y))=baseline(x);
            temp=((temp-y)/temp(1))*100;
        else
            temp(1:2501)=NaN;
        end
        PercentPupil=[PercentPupil; temp]; clear x y temp;
    end
    clear baseline;
    tempSaveStructTrace.PercentPupil = single(PercentPupil);
    
    try
        tempSaveStructTrace.PositionAP = (xlsCellsForChosenFiles{iii,14})
        tempSaveStructTrace.PositionML = (xlsCellsForChosenFiles{iii,15})
        
        tempSaveStructTrace.Depth = (xlsCellsForChosenFiles{iii,13}) ;
        
        if  isfield(PDS, 'goodtrial')
            tempSaveStructTrace.numTrials = sum(PDS.goodtrial) ;
        else
            tempSaveStructTrace.numTrials = sum(~PDS.repeatflag)
        end
    catch e
        e
    end
    
    %%%%%%%%%%%%%% waveformShape
    % load paired Alpha Omefga File
    try
    load(AlphaOmegaFilesToRun{iii})
    
    tempSaveStructTrace.waveformUpperBound = CSPK_001_BitResolution* (  mean(CSEG_001_Template1_SEG') +  2*std(double(CSEG_001_Template1_SEG),0,2)'  )
    tempSaveStructTrace.waveformLowerBound =  CSPK_001_BitResolution* (  mean(CSEG_001_Template1_SEG') -  2*std(double(CSEG_001_Template1_SEG),0,2)'  )
    tempSaveStructTrace.meanWaveform = CSPK_001_BitResolution*  mean(CSEG_001_Template1_SEG');
    %     sumAo= size(CSEG_001_Template1_SEG,2)
    tempSaveStructTrace.timeOfWaveformCap =1000* ( 1/44000:1/44000:size(upperBound,2)*(1/44000));
    catch
        %AO file Not found...
         tempSaveStructTrace.waveformUpperBound = NaN;
         tempSaveStructTrace.waveformLowerBound =NaN;
        tempSaveStructTrace.meanWaveform= NaN;
        tempSaveStructTrace.timeOfWaveformCap=NaN;
    end
    
end

% 2 contains many odd length fractals
% 3 contains all 2.5 second CS-outcome intervals


try % Excel data
    tempSaveStructTrace.PositionAP = (xlsCellsForChosenFiles{iii,14})
    tempSaveStructTrace.PositionML = (xlsCellsForChosenFiles{iii,15})
    
    tempSaveStructTrace.Depth = (xlsCellsForChosenFiles{iii,13}) ;
    
    if  isfield(PDS, 'goodtrial')
        tempSaveStructTrace.numTrials = sum(PDS.goodtrial) ;
    else
        tempSaveStructTrace.numTrials = sum(~PDS.repeatflag)
    end
    
    tempSaveStructTrace.UnitId = (xlsCellsForChosenFiles{iii,16})
catch e
    e
end



