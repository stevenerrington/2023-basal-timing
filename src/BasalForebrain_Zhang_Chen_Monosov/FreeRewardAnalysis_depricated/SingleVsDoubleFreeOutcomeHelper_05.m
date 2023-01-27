%  SingleVsDoubleFreeOutcomeHelper_05

%  Trace V6 and V7 outcome responses minus Prob Amount
%  (for reward only)
%
% This file should plot and compare all timingTrace free outcomes with all
% Prob amt free outcomes based on the contents of the excel spreadsheet. 
% This program looks for TimingTrace files in the spreadsheet fo this 
% analysis by checking for TRUE flags in column AA (column 27) and finds
% thier paired elements by looking in column X (column 24) for the LINE-
% number of the paired file.  If a timing trace file has no pairinmg here
% it will not be part of the group analysis.
%
% 
% clear all
close all
clear all; clc; close all; warning off; 
addpath('Y:\Noah\Code\HelperFunctions\HELPER_GENERAL'); %keep hepers functions here

CENTER=8001; %this is event alignment. this means that at 11,000 the event
% that we are studying (aligning spikes too) will be in the SDF *you will see in ploting
gauswindow_ms=50;
rastersplot=1;
limitsarray=[CENTER-1000:CENTER+2750];
xlimvar=length(limitsarray);
masterXlsFile    =  'Y:\Noah\WolverineData\Wolverine_Filelist_ActiveSheet.xls' ; %location of excel file





[xlsnum,xlstxt,xlsraw] = xlsread(masterXlsFile);
savematInMainDirectory =0;
smoothValue=10;

xlsraw(1,:)'   %Labels for data columns
rootofShare1     =  'Y:' ; % parent directory of all data 
saveFileLoc = 'Y:\Noah\Code\HelperFunctions\FreeRewardAnalysis';
rootOfSaveFiles  =  'Y:\Noah\Code\HelperFunctions\FreeRewardAnalysis' ; % loaction of output file saving

clear xlsCellsForChosenFiles
filelistCounter=1;
IlyaNoteColContents = [false; (xlsnum(:,22)==1)];


% 
% 
% % load('' );
% addpath('HELPER_GENERAL'); %keep hepers functions here
% CENTER=8001; %this is event alignment. this means that at 11,000 the event
% % that we are studying (aligning spikes too) will be in the SDF *you will see in ploting
% gauswindow_ms=50;
% rastersplot=1;
% limitsarray=[CENTER-1000:CENTER+2750];
% xlimvar=length(limitsarray);
% ylimvar=150;
% masterXlsFile = 'C:\Rig Code\local Data Backup\Noah\WolverineData\Wolverine_Filelist_ActiveSheet.xls';
% 
% 
% [xlsnum,xlstxt,xlsraw] = xlsread(masterXlsFile);
% savematInMainDirectory =0;
% smoothValue=10;
% 
% xlsraw(1,:)'   %Labels for data columns
% rootofShare1 = 'C:\Rig Code\local Data Backup';
% saveFileLoc = 'C:\Rig Code\local Data Backup\Type2AnalysisAutomated';
% rootOfSaveFiles = 'C:\Rig Code\local Data Backup\Type2AnalysisAutomated';
% 
% clear xlsCellsForChosenFiles
% filelistCounter=1;
% IlyaNoteColContents = [false; (xlsnum(:,22)==1)];

FullItiOnly=1;
atHome=0;



if FullItiOnly==1
    titleStringAdd = 'fullITIonly_';
else
    titleStringAdd = '' ;
end


indexAnalysisFlag=[];
indexTimingTrace =[];
for x=1:length(xlstxt(:,1));
    tempname=xlstxt{x,1};
    
    tempneurontype= xlsraw{x,27} ;  %checks the master spreadsheet for colmn AA flags
    try
        if strcmp(tempname(1:7),'TimingT')==1;
            indexTimingTrace=[indexTimingTrace; x];
        end
    end
    try
        if tempneurontype==1;
            indexAnalysisFlag=[indexAnalysisFlag; x];
        end
    end
end

timeTraceType2=intersect(indexAnalysisFlag,indexTimingTrace) % finds intersection of 

for filelistCounter =1: size( timeTraceType2,1)
    % build a list of all files with an analysis flag of type timing Trace
    FilesToRun{filelistCounter}=  [rootofShare1 filesep ...
        xlsraw{timeTraceType2(filelistCounter),2} filesep xlsraw{timeTraceType2(filelistCounter),1}];
    
    AlphaOmegaFilesToRun {filelistCounter} =  [rootofShare1 filesep ...
        xlsraw{timeTraceType2(filelistCounter),2} filesep 'AlphaOmegaFiles' filesep  ...
        'mapfile'  num2str( xlsraw{timeTraceType2(filelistCounter),12},'%#04i' ) '.mat'];
    xlsCellsForChosenFiles( filelistCounter,:) =    xlsraw(timeTraceType2(filelistCounter),:);
    
end

%initialize all variables
AllTrialDoubleFreeRewards = [] ;
AllTrialDoubleFreeFlash = [] ;
AllTrialDoubleFreeAirpuff = [] ;

FullTrialOnlyDoubleFreeRewards = [] ;
FullTrialOnlyDoubleFreeFlash = [] ;
FullTrialOnlyDoubleFreeAirpuff = [] ;
%         FullTrialOnlyDoubleFreepunish

AllTrialSingleFreeRewards = [] ;
AllTrialSingleFreeFlash = [] ;
AllTrialSingleFreeAirpuff = [] ;

FullTrialOnlySingleFreeRewards = [] ;
FullTrialOnlySingleFreeFlash = [] ;
FullTrialOnlySingleFreepunish = [] ;

SdfAllTrialSingleFreeRewards =  [] ;
SdfAllTrialSingleFreeFlash =  [] ;
SdfAllTrialSingleFreeAirpuff =  [] ;

SdfFullTrialOnlySingleFreeRewards =  [] ;
SdfFullTrialOnlySingleFreeFlash =  [] ;
SdfFullTrialOnlySingleFreepunish =  [] ;

SdfAllTrialDoubleFreeRewards =  [] ;
SdfAllTrialDoubleFreeFlash =  [] ;
SdfAllTrialDoubleFreeAirpuff =  [] ;

SdfFullTrialOnlyDoubleFreeRewards =  [] ;
SdfFullTrialOnlyDoubleFreeFlash =  [] ;
SdfFullTrialOnlyDoubleFreepunish =  [] ;
SdfSubtractedFreeReward = [];
SdfSubtractedFreeFlash =[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% For each file...
for iii=  1 :size(FilesToRun,2)  %1: size(FilesToRun,2)
    
%     try
        close all
        mainFig = figure;
        
        clear  groupFilenames groupDirectory
        groupFilenames{1} = xlsCellsForChosenFiles(iii,1) ;
        groupDirectory{1} = xlsCellsForChosenFiles(iii,2);
        
        if   ~isnan(xlsCellsForChosenFiles{iii,24})
            
            % pull the row of the matching single outcome file from column
            % X in the excel sheet and usethat line number to pullt he next
            % file number
            
            groupFilenames{2} = xlsraw( xlsCellsForChosenFiles{iii,24},1 );
            groupDirectory{2} = xlsraw( xlsCellsForChosenFiles{iii,24},2) ;
        else
            groupFilenames{2} ='';
            groupDirectory{2}='';
        end
        
        
        %%%%%%%%%%%%%%%%%%%% Manual Run%%%%%%%%%%%%%%%%
        CENTER=8001; %this is event alignment. this means that at 11,000 the event that we are studying (aligning spikes too) will be in the SDF *you will see in ploting
        gauswindow_ms=50;
        rastersplot=1;
        limitsarray=[CENTER-1000:CENTER+2750];
        %     xlimvar=length(limitsarray);
        %     ylimvar=200;
        %     masterXlsFile = 'C:\Users\NMLedbetter\Dropbox\Wolverine\Wolverine_Filelist_016_Type2_TraceProcedure_TEST.xls';
        %     [xlsnum,xlstxt,xlsraw] = xlsread(masterXlsFile);
        %     savematInMainDirectory =0;
        %     xlsraw(1,:)'   %Labels for data columns
        %     %   xlsraw(2:end,:)
        %     rootofShare1 = 'C:\Rig Code\local Data Backup';
        %     rootOfSaveFiles = 'C:\Rig Code\local Data Backup\Type2Analysis';
        % %     clear xlsCellsForChosenFiles
        %     groupDirectory{1} = {'Noah\WolverineData\TimingTrace'};
        %     groupDirectory{2} = {'Noah\WolverineData\ProbAmt'};
        
        %     %%%%%%%%%%%%%%%%%%%%%File Pairs in case you want to manually run
        %     them
        
        %     %1
        %     groupFilenames{1} ={'TimingTrace_V7_25_06_2015_12_44.mat'};
        %     groupFilenames{2} ={'ProbAmtIsoLum_V3_25_06_2015_12_18.mat'};
        %     %2
        %     groupFilenames{1} ={'TimingTrace_V7_18_06_2015_14_16.mat'};
        %     groupFilenames{2} ={'ProbAmtIsoLum_V3_18_06_2015_13_52.mat'};
        %     %3
        %     groupFilenames{1} ={'TimingTrace_V7_10_06_2015_14_10.mat'};
        %     groupFilenames{2} ={'ProbAmtIsoLum_V3_10_06_2015_13_47.mat'};
        %     %4
        %     groupFilenames{1} ={'TimingTrace_V7_02_06_2015_14_23.mat'};
        %     groupFilenames{2} ={'ProbAmtIsoLum_V3_02_06_2015_14_00.mat'};
        %     %5
        %     groupFilenames{1} ={'TimingTrace_V7_01_06_2015_13_20.mat'};
        %     groupFilenames{2} ={'ProbAmtIsoLum_V3_01_06_2015_13_05.mat'};
        %     %6
        %     groupFilenames{1} ={'TimingTrace_V7_28_05_2015_15_34.mat'};
        %     groupFilenames{2} ={'ProbAmtIsoLum_V3_28_05_2015_15_21.mat'};
        %     %7
        %     groupFilenames{1} ={'TimingTrace_V7_12_05_2015_15_13.mat'};
        %     groupFilenames{2} ={'ProbAmtIsoLum_V3_12_05_2015_14_57.mat'};
        %     %8 Few Trials
        %     groupFilenames{1} ={'TimingTrace_V7_11_05_2015_13_39.mat'};
        %     groupFilenames{2} ={'ProbAmtIsoLum_V3_11_05_2015_13_16.mat'};
        %     % 9
        %     groupFilenames{1} ={'TimingTrace_V7_09_05_2015_10_27.mat'};
        %     groupFilenames{2} ={'ProbAmtIsoLum_V3_09_05_2015_10_09.mat'};
        %     % 10
        %     groupFilenames{1} ={'TimingTrace_V7_08_05_2015_15_13.mat'};
        %     groupFilenames{2} ={'ProbAmtIsoLum_V3_08_05_2015_14_47.mat'};
        %     %11
        %     groupFilenames{1} ={'TimingTrace_V7_07_05_2015_13_24.mat'};
        %     groupFilenames{2} ={'ProbAmtIsoLum_V3_07_05_2015_12_49.mat'};
        %
        %     %12
        %     groupFilenames{1} ={'TimingTrace_V7_02_05_2015_13_23.mat'};
        %     groupFilenames{2} ={'ProbOnlyIsoLum_V1_02_05_2015_13_34.mat'}; %% ProbOnlyIsoLum_V1_02_05_2015_13_34.mat
        %     %OR  % ChoiceOnlyProbAmtIsoLum_02_05_2015_14_06.mat
        %     %13
        %     groupFilenames{1} ={'TimingTrace_V7_02_05_2015_12_05.mat'};
        %     groupFilenames{2} ={'ProbOnlyIsoLum_V1_02_05_2015_12_15.mat'}; % ChoiceOnlyProbAmtIsoLum_02_05_2015_11_51.mat
        %     %14
        %     groupFilenames{1} ={'TimingTrace_V7_01_05_2015_17_27.mat'};
        %     groupFilenames{2} ={'ProbOnlyIsoLum_V1_01_05_2015_17_10.mat'};
        %
        %     groupFilenames{1} ={'TimingTrace_V6_25_04_2015_12_15.mat'};
        %     groupFilenames{2} ={'ProbAmtIsoLum_25_04_2015_11_29.mat'};
        %
        %     groupFilenames{1} ={'TimingTrace_25_04_2015_12_39.mat'};
        %     groupFilenames{2} ={'ProbAmtIsoLum_25_04_2015_12_26.mat'};
        %
        %     groupFilenames{1} ={''};
        %     groupFilenames{2} ={''};
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% End File Pairs
        
        mainFig = figure;
        %     manualSingleVsDoubleOutcomeHelper_001
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Double Free Outcomes
        clear PDS
        % load timing trace file
        
        load([rootofShare1 filesep groupDirectory{1,1}{1} filesep groupFilenames{1,1}{1}]);
        
        titlestring = groupFilenames{1,1}{1}(1:end-4) ;
        
        PDS.timesoffreeoutcomes_first(find(PDS.timesoffreeoutcomes_first>10))=NaN; %very few trials have a timing bug. just remove them
        free1_=intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==1)); %reward/juice
        free2_=intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==2)); %aifpuff
        free34_=intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==34)); %flash.sound combination
        
        freeOutcomeTimingSeperation =PDS.timesoffreeoutcomes_second - PDS.timesoffreeoutcomes_first;
        averageOutcomeSeperation = fix(1000* mean(freeOutcomeTimingSeperation(freeOutcomeTimingSeperation>0)));
        
        durationsuntilreward=PDS(1).timeoutcome-PDS(1).timetargeton;
        durationsuntilreward=round(durationsuntilreward*10)./10;
        completedtrial=find(durationsuntilreward>0);
        if isfield(PDS, 'deliveredornot')
            deliv=find(PDS(1).deliveredornot==1)
            ndeliv=find(PDS(1).deliveredornot==0)
        else
            if isfield(PDS,'rewardDuration')
                deliv=find(PDS(1).rewardDuration>0)
                ndeliv=find(PDS(1).rewardDuration==0);
            else
                deliv=find(PDS(1).rewardduration>0)
                ndeliv=find(PDS(1).rewardduration==0  )
            end
            
        end
        
        
        
        
        trials6253=intersect(find(PDS(1).fractals==6253),completedtrial);
        trials6254=intersect(find(PDS(1).fractals==6254),completedtrial);
        trials6259=intersect(find(PDS(1).fractals==6259),completedtrial);
        trials6260=intersect(find(PDS(1).fractals==6260),completedtrial);
        trials6300=intersect(find(PDS(1).fractals==6300),completedtrial);
        trials6301=intersect(find(PDS(1).fractals==6301),completedtrial);
        trials6254d=intersect(trials6254,deliv);
        trials6260d=intersect(trials6260,deliv);
        trials6301d=intersect(trials6301,deliv);
        trials6254nd=intersect(trials6254,ndeliv);
        trials6260nd=intersect(trials6260,ndeliv);
        trials6301nd=intersect(trials6301,ndeliv);
        
        trials6200 = intersect(find(PDS(1).fractals==6200),completedtrial);
        trials6201 = intersect(find(PDS(1).fractals==6201),completedtrial);
        trials6202 = intersect(find(PDS(1).fractals==6202),completedtrial);
        trials6203 = intersect(find(PDS(1).fractals==6203),completedtrial);
        trials6204 = intersect(find(PDS(1).fractals==6204),completedtrial);
        trials6205 = intersect(find(PDS(1).fractals==6205),completedtrial);
        trials6206 = intersect(find(PDS(1).fractals==6206),completedtrial);
        trials6207 = intersect(find(PDS(1).fractals==6207),completedtrial);
        trials6208 = intersect(find(PDS(1).fractals==6208),completedtrial);
        trials6209 = intersect(find(PDS(1).fractals==6209),completedtrial);
        trials6210 = intersect(find(PDS(1).fractals==6210),completedtrial);
        trials6211 = intersect(find(PDS(1).fractals==6211),completedtrial);
        trials6212 = intersect(find(PDS(1).fractals==6212),completedtrial);
        trials6213 = intersect(find(PDS(1).fractals==6213),completedtrial);
        trials6214 = intersect(find(PDS(1).fractals==6214),completedtrial);
        
        cleanfreeoutcome=[free1_ free2_ free34_];
        CLEAN=cleanfreeoutcome;
        
        %         if FullItiOnly==1
        %
        %     fullItiTrials = find(PDS.definedITIdur>1);
        %     else
        %         fullItiTrials = find(PDS.goodtrial==1);
        %     end
        %
        
        fullItiTrials_=[];
        clear temp
        for x=1:length(CLEAN)
            x=CLEAN(x);
            spk=PDS(1).sptimes{x};
            
            spk1=spk(find(spk<PDS.timesoffreeoutcomes_first(x)));
            spk2=spk(find(spk>PDS.timesoffreeoutcomes_first(x)+10/1000));
            
            spk=[spk1 spk2]; clear spk1 spk2
            try
                no_noise=find(spk>(PDS.timesoffreeoutcomes_first(x)+(10/1000)) & spk<(PDS.timesoffreeoutcomes_first(x)+(20/1000)));
                no_noise=length(no_noise); %this many spikes in the window  so insert that many spikes in the deleted time range
                grabnumbers=PDS.timesoffreeoutcomes_first(x)+randperm(10)/1000;
                grabnumbers=grabnumbers(no_noise);
                spk=[spk grabnumbers];
            end
            PDS(1).sptimes{x}=sort(spk);
            
            
            clc
            
            
            % fix short Itis
            if FullItiOnly==1
                if PDS.sptimes{x}(end) - PDS.timesoffreeoutcomes_first(x)>2.5
                    fullItiTrials_ = [fullItiTrials_ x];
                end
            else
                fullItiTrials_ = [fullItiTrials_ x];
            end
            clear y spk spk1 spk2 x
        end
        for x=1:length(CLEAN)
            x=CLEAN(x);
            spk=PDS(1).sptimes{x};
            try
                no_noise=find(spk>(PDS.timesoffreeoutcomes_second(x)+(10/1000)) & spk<(PDS.timesoffreeoutcomes_second(x)+(20/1000)));
                no_noise=length(no_noise); %this many spikes in the window  so insert that many spikes in the deleted time range
                grabnumbers=PDS.timesoffreeoutcomes_second(x)+randperm(10)/1000;
                grabnumbers=grabnumbers(no_noise);
                spk=[spk grabnumbers];
            end
            spk1=spk(find(spk<PDS.timesoffreeoutcomes_second(x)));
            spk2=spk(find(spk>PDS.timesoffreeoutcomes_second(x)+10/1000));
            spk=[spk1 spk2]; clear spk1 spk2
            
            PDS(1).sptimes{x}=sort(spk);
            %
            clear y spk spk1 spk2 x
            clc
        end
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
        for x=1:length(PDS.fractals)
            try
                spk=PDS(1).sptimes{x}-PDS.timesoffreeoutcomes_first(x);
                
                spk=(spk*1000)+CENTER-1;
                spk=fix(spk);
                %
                spk=spk((spk<CENTER*2) & spk>0);
                %
                temp(1:CENTER*2)=0;
                temp(spk)=1;
                Rasters=[Rasters; temp];
                %
                clear temp spk x
%             catch
            end
        end
        meanPsths = figure;
        SDFfree_=plot_mean_psth({Rasters},gauswindow_ms,1,(CENTER*2)-2,1);
        %     close all;
        Rastersfree_=Rasters;
        
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
        Rasters_cstrace=Rasters; clear Rasters
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Plot Rasters of  Double FreeOutcomes
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        figure(mainFig);
        
        
        try % try all plotting
            nsubplot(100,100,1:45,1:45)
            trialstoplot=intersect(free1_ , fullItiTrials_) ;
            xuncert= [Rastersfree_(trialstoplot,limitsarray)];
            SD=smooth(nanmean(SDFfree_(trialstoplot,limitsarray),1),smoothValue);
            
            plot(SD,'r','LineWidth', 2); hold on;
            if atHome==1
                SD = SD';
            else
                SD = SD';
            end
            
            freeOutcomeDoubleReward = SD;
            
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
            MatPlot(1:size(xuncert,1),1:max(xt))=NaN
            for tq=1:size(xuncert,1)
                temptq=find(rasts(tq,:)>0);
                MatPlot(tq,1:length(temptq))=temptq;
            end
            rastList=MatPlot;
            rasIntv=1;
            LWidth=1;
            LColor='r';
            maxY_rast=tq+10;
            if rastersplot==1
                for line = 1:size(rastList,1)
                    hold on
                    curY_rast = maxY_rast-rasIntv*line;
                    plot([rastList(line,:); rastList(line,:)],...
                        [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
                        (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor );
                    hold on
                end
            end
            clear rasts xt rastList MatPlot
            
            trialstoplot=intersect(free34_, fullItiTrials_);
            xuncert=[Rastersfree_(trialstoplot,limitsarray)];
            SD=smooth(nanmean(SDFfree_(trialstoplot,limitsarray),1),smoothValue) ;
            plot(SD,'k','LineWidth', 2); hold on;
            if atHome==1
                SD = SD';
            else
                SD = SD';
            end
            
            freeOutcomeDoubleFlash = SD;
            
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
            MatPlot(1:size(xuncert,1),1:max(xt))=NaN
            for tq=1:size(xuncert,1)
                temptq=find(rasts(tq,:)>0);
                MatPlot(tq,1:length(temptq))=temptq;
            end
            rastList=MatPlot;
            rasIntv=1;
            LWidth=1;
            LColor='k';
            maxY_rast=tq+40;
            if rastersplot==1
                for line = 1:size(rastList,1)
                    hold on
                    curY_rast = maxY_rast-rasIntv*line;
                    plot([rastList(line,:); rastList(line,:)],...
                        [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
                        (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor );
                    hold on
                end
            end
            clear tq xt line rastList MatPlot curY_rast temptq rasts SD SDplotto xuncert
            clear rasts xt rastList MatPlot
            
            trialstoplot=intersect(free2_ , fullItiTrials_);
            xuncert=[Rastersfree_(trialstoplot,limitsarray)];
            SD=smooth(nanmean(SDFfree_(trialstoplot,limitsarray),1),smoothValue);
            plot(SD,'b','LineWidth', 2); hold on;
            
            if atHome==1
                SD = SD';
            else
                SD = SD';
            end
            
            freeOutcomeDoubleAirpuff = SD;
            
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
            MatPlot(1:size(xuncert,1),1:max(xt))=NaN
            for tq=1:size(xuncert,1)
                temptq=find(rasts(tq,:)>0);
                MatPlot(tq,1:length(temptq))=temptq;
            end
            rastList=MatPlot;
            rasIntv=1;
            LWidth=1;
            LColor='b';
            maxY_rast=tq+70;
            if rastersplot==1
                for line = 1:size(rastList,1)
                    hold on
                    curY_rast = maxY_rast-rasIntv*line;
                    plot([rastList(line,:); rastList(line,:)],...
                        [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
                        (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor );
                    hold on
                end
            end
            clear tq xt line rastList MatPlot curY_rast temptq rasts SD SDplotto xuncert
            firstOutcomeTime = 1000;
            x=[firstOutcomeTime,firstOutcomeTime ];
            y=[0,ylimvar];
            plot(x,y,'k'); hold on;
            
            x=[(averageOutcomeSeperation +firstOutcomeTime) ,  ...
                (averageOutcomeSeperation +firstOutcomeTime)];
            y=[0,ylimvar];
            plot(x,y,'k'); hold on;
            
            xlim([0 3000])
            ylim([0 ylimvar])
            xlabel('Double free outcomes')
            axis square;
            clear rasts xt rastList MatPlot
            
            
            %Make averagable array
            AllTrialDoubleFreeRewards = [AllTrialDoubleFreeRewards ; Rastersfree_(free1_,:)] ;
            AllTrialDoubleFreeFlash = [AllTrialDoubleFreeFlash  ; Rastersfree_(free34_,:)] ;
            AllTrialDoubleFreeAirpuff = [AllTrialDoubleFreeAirpuff ; Rastersfree_(free2_,:)] ;
            
            FullTrialOnlyDoubleFreeRewards = [FullTrialOnlyDoubleFreeRewards ; Rastersfree_(intersect(free1_ , fullItiTrials_),: )] ;
            FullTrialOnlyDoubleFreeFlash = [FullTrialOnlyDoubleFreeFlash ; Rastersfree_(intersect(free34_ , fullItiTrials_),: )] ;
            FullTrialOnlyDoubleFreeAirpuff = [FullTrialOnlyDoubleFreeAirpuff ; Rastersfree_(intersect(free2_ , fullItiTrials_),: )] ;
            
            normvalueDouble(iii)=nanmean(nanmean([freeOutcomeDoubleAirpuff(:,900:990)' freeOutcomeDoubleFlash(:,900:990)' freeOutcomeDoubleReward(:,900:990)']));
            
            
            SdfAllTrialDoubleFreeRewards = [SdfAllTrialDoubleFreeRewards ; freeOutcomeDoubleReward] ;
            SdfAllTrialDoubleFreeFlash = [SdfAllTrialDoubleFreeFlash  ;freeOutcomeDoubleFlash] ;
            SdfAllTrialDoubleFreeAirpuff = [SdfAllTrialDoubleFreeAirpuff ;  freeOutcomeDoubleAirpuff] ;
            
            
            
            %%%%%%%%%%%%%%%%%%Make Save Struct %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            %     SaveStructFreeRewards{iii}.trialsToAverage =  trialstoAverage ;
            %     SaveStructFreeRewardsGlobal.trialsToAverage = [SaveStructFreeRewardsGlobal.trialsToAverage trialstoAverage];
            SaveStructFreeRewards{iii}.filenameTrace = groupFilenames{1,1}{1};
            SaveStructFreeRewards{iii}.filepathTrace = groupDirectory{1,1}{1};
            
            SaveStructFreeRewards{iii}.filenameProbAmt = groupFilenames{1,2}{1};
            SaveStructFreeRewards{iii}.filepathProbAmt = groupDirectory{1,2}{1};
            
            %%%%%%%%%%%%%
            SaveStructFreeRewards{iii}.DoubleRewardTrials =  SDFfree_ ( intersect(free1_ , fullItiTrials_),: );
            SaveStructFreeRewards{iii}.DoubleAirpuffTrials =  SDFfree_ ( intersect(free2_ , fullItiTrials_),: );
            SaveStructFreeRewards{iii}.DoubleFlashTrials =  SDFfree_ ( intersect(free34_ , fullItiTrials_),: );
            %%%%%%%%%%%%%%%%%%%%%%%%%
            SaveStructFreeRewards{iii}.DoubleMinusSingle = subtractedSD;
            
            SaveStructFreeRewards{iii}.FreeRewardCenter =8001;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Trace Data Struct
            StructMakerTimingTrace_V01;
            SaveStructTrace{iii} = tempSaveStructTrace ;
            SaveStructTrace{iii}.filename = groupFilenames{1,1}{1};
            SaveStructTrace{iii}.filepath = groupDirectory{1,1}{1};
            %         clear tempSaveStructTrace ;
            
            
            
            
%         catch e
%             e
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        % End Plot Double Outcomes
        %%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        
        %%%%%% If a paired file exists plot it individually
%         try
            clear PDS
            load([rootofShare1 filesep groupDirectory{1,2}{1} filesep groupFilenames{1,2}{1}]);
            clear free34 free3Only free4Only free9000s free1 free9021 free2
            
            figure(meanPsths);
            
            CENTER=8001; %this is event alignment. this means that at 11,000 the event that we are studying (aligning spikes too) will be in the SDF *you will see in ploting
            gauswindow_ms=50;
            rastersplot=1;
            limitsarray=[CENTER-1000:CENTER+1750];
            
            xlimvar=length(limitsarray);
            % ylimvar=100;
            
            PDS.timesoffreeoutcomes_first(find(PDS.timesoffreeoutcomes_first>10))=NaN; %very few trials have a timing bug. just remove them
            free1=intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==1)); %reward/juice
            free34=intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==34)); %flash.sound combination
            free3Only = intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==3)); %flash.sound combination
            free4Only = intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==4)); %flash.sound combination
            free2 =  intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==2)); %punishment
            
            
            if max(PDS.freeoutcometype)>9000
                free9000s = intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype>9000 &PDS.freeoutcometype<9021 )); %flash.sound combination
                free9021 = intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==9021)); %flash.sound combination
                
            else
                free9000s=[];
                free9021=[];
            end
            free34 = [free34 free3Only free4Only free9000s];
            free1 = [free1 free9021];
            
            
            fullItiTrials=[];
            %let's remove the reward noise
            cleanfreeoutcome=[free1 free34];
            CLEAN=cleanfreeoutcome;
            for x=1:length(CLEAN)
                %             x
                x=CLEAN(x);
                spk=PDS(1).sptimes{x};
                spk1=spk(find(spk<PDS.timesoffreeoutcomes_first(x)));
                spk2=spk(find(spk>PDS.timesoffreeoutcomes_first(x)+10/1000));
                spk=[spk1 spk2]; clear spk1 spk2
                try
                    no_noise=find(spk>(PDS.timesoffreeoutcomes_first(x)+(10/1000)) & spk<(PDS.timesoffreeoutcomes_first(x)+(20/1000)));
                    no_noise=length(no_noise); %this many spikes in the window  so insert that many spikes in the deleted time range
                    grabnumbers=PDS.timesoffreeoutcomes_first(x)+randperm(10)/1000;
                    grabnumbers=grabnumbers(no_noise);
                    spk=[spk grabnumbers];
                end
                PDS(1).sptimes{x}=sort(spk);
                %
                
                %             fix short Itis
                if FullItiOnly==1
                    if PDS.sptimes{x}(end) - PDS.timesoffreeoutcomes_first(x)>2.5
                        fullItiTrials = [fullItiTrials x];
                    end
                else
                    fullItiTrials = [fullItiTrials x];
                end
                clear y spk spk1 spk2 x
                
                clc
            end
            %MAKE A RASTER AND A SPIKE DENSITY FUNCTION FOR EVERY TRIAL for
            %freeoutcomes
            Rasters=[];
            for x=1:length(PDS.fractals)
                spk=PDS(1).sptimes{x}-PDS.timesoffreeoutcomes_first(x);
                
                spk=(spk*1000)+CENTER-1;
                spk=fix(spk);
                %
                spk=spk((spk<CENTER*2) & spk>0  );  % NML added
                %
                temp(1:CENTER*2)=0;
                temp(spk)=1;
                Rasters=[Rasters; temp];
                %
                
                
                clear temp spk x
            end
            SDFfree=plot_mean_psth({Rasters},gauswindow_ms,1,(CENTER*2)-2,1);
            %close all;
            Rastersfree=Rasters;
            clear  CLEAN cleanfreeoutcome
            
            
            %%%%Plot Single outcomes%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            figure(mainFig)
            
            
            nsubplot(100,100,50:100,1:45)
            trialstoplot=intersect(free1 , fullItiTrials);
            xuncert=[Rastersfree(trialstoplot,limitsarray)];
            SD=smooth(nanmean(SDFfree(trialstoplot,limitsarray),1),smoothValue);
            
            if atHome==1
                SD = SD';
            else
                SD = SD';
            end
            
            freeOutcomeSingleReward =SD;
            
            plot(SD,'r','LineWidth', 2); hold on;
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
            MatPlot(1:size(xuncert,1),1:max(xt))=NaN
            for tq=1:size(xuncert,1)
                temptq=find(rasts(tq,:)>0);
                MatPlot(tq,1:length(temptq))=temptq;
            end
            rastList=MatPlot;
            rasIntv=1;
            LWidth=1;
            LColor='r';
            maxY_rast=tq+10;
            if rastersplot==1
                for line = 1:size(rastList,1)
                    hold on
                    curY_rast = maxY_rast-rasIntv*line;
                    plot([rastList(line,:); rastList(line,:)],...
                        [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
                        (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor );
                    hold on
                end
            end
            clear rasts xt rastList MatPlot
            
            trialstoplot=intersect(free34 , fullItiTrials);
            xuncert=[Rastersfree(trialstoplot,limitsarray)];
            SD=smooth(nanmean(SDFfree(trialstoplot,limitsarray),1),smoothValue);
            
            if atHome==1
                SD = SD';
            else
                SD = SD';
            end
            
            freeOutcomeSingleFlash = SD;
            plot(SD,'k','LineWidth', 2); hold on;
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
            MatPlot(1:size(xuncert,1),1:max(xt))=NaN
            for tq=1:size(xuncert,1)
                temptq=find(rasts(tq,:)>0);
                MatPlot(tq,1:length(temptq))=temptq;
            end
            rastList=MatPlot;
            rasIntv=1;
            LWidth=1;
            LColor='k';
            maxY_rast=tq+40;
            if rastersplot==1
                for line = 1:size(rastList,1)
                    hold on
                    curY_rast = maxY_rast-rasIntv*line;
                    plot([rastList(line,:); rastList(line,:)],...
                        [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
                        (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor );
                    hold on
                end
            end
            clear tq xt line rastList MatPlot curY_rast temptq rasts SD SDplotto xuncert
            x=[1000,1000]; y=[0,ylimvar]; plot(x,y,'k'); hold on;
            %xlim([0 2000])
            ylim([0 ylimvar])
            xlabel('free outcomes')
            axis square;
            clear rasts xt rastList MatPlot
            
            AllTrialSingleFreeRewards = [AllTrialSingleFreeRewards ; Rastersfree(free1,:)] ;
            AllTrialSingleFreeFlash = [AllTrialSingleFreeFlash  ; Rastersfree(free34,:)] ;
            AllTrialSingleFreeAirpuff = [AllTrialSingleFreeAirpuff ; Rastersfree(free2,:)] ;
            
            FullTrialOnlySingleFreeRewards = [FullTrialOnlySingleFreeRewards ; Rastersfree(intersect(free1 , fullItiTrials),: )] ;
            FullTrialOnlySingleFreeFlash = [FullTrialOnlySingleFreeFlash ; Rastersfree(intersect(free34 , fullItiTrials),: )] ;
            FullTrialOnlySingleFreepunish = [FullTrialOnlySingleFreepunish ; Rastersfree(intersect(free2 , fullItiTrials),: )] ;
            
            
            SdfAllTrialSingleFreeRewards = [SdfAllTrialSingleFreeRewards ; SDFfree(free1,:)] ;
            SdfAllTrialSingleFreeFlash = [SdfAllTrialSingleFreeFlash  ; SDFfree(free34,:)] ;
            SdfAllTrialSingleFreeAirpuff = [SdfAllTrialSingleFreeAirpuff ; SDFfree(free2,:)] ;
            
            %         SdfFullTrialOnlySingleFreeRewards = [SdfFullTrialOnlySingleFreeRewards ; SDFfree(intersect(free1 , fullItiTrials),: )] ;
            %         SdfFullTrialOnlySingleFreeFlash = [SdfFullTrialOnlySingleFreeFlash ; SDFfree(intersect(free34 , fullItiTrials),: )] ;
            %         SdfFullTrialOnlySingleFreepunish = [SdfFullTrialOnlySingleFreepunish ; SDFfree(intersect(free2 , fullItiTrials),: )] ;
            SdfFullTrialOnlySingleFreeRewards = [SdfFullTrialOnlySingleFreeRewards ; freeOutcomeSingleReward] ;
            SdfFullTrialOnlySingleFreeFlash = [SdfFullTrialOnlySingleFreeFlash ; freeOutcomeSingleFlash] ;
            
            normvalueSingle(iii)=nanmean(nanmean([ freeOutcomeSingleFlash(:,900:990)' freeOutcomeSingleReward(:,900:990)']));
            %         SdfFullTrialOnlySingleFreepunish = [SdfFullTrialOnlySingleFreepunish ; freeOutcomeSinglePuff)] ;
            
            
%         catch e
%             e
%         end
        
        %
%         try
            
            
            %%%%%%% Also plot it subtracted from the double outcomes.
            % divide the normValues and subtract to get a zero baseline for
            % subtracted trials
            
            
            
            figure(mainFig)
            if atHome==1
                freeOutcomeDoubleReward = freeOutcomeDoubleReward';
                freeOutcomeSingleReward=freeOutcomeSingleReward';
                
                freeOutcomeDoubleFlash = freeOutcomeDoubleFlash';
                freeOutcomeSingleFlash = freeOutcomeSingleFlash';
            else
                freeOutcomeDoubleReward = freeOutcomeDoubleReward';
                freeOutcomeSingleReward=freeOutcomeSingleReward';
                
                freeOutcomeDoubleFlash = freeOutcomeDoubleFlash';
                freeOutcomeSingleFlash = freeOutcomeSingleFlash';
                
            end
            
            
            
            nsubplot(100,100,50:100,50:100)
            lesserLength =   min([size(freeOutcomeDoubleReward,1) size(freeOutcomeSingleReward,1)]);
            subtractedSD= (freeOutcomeDoubleReward(1:lesserLength )/normvalueDouble(iii)) - ...
                (freeOutcomeSingleReward(1:lesserLength)/normvalueDouble(iii) );
            
            plot(subtractedSD,'r','LineWidth', 2); hold on;
            SdfSubtractedFreeReward = [SdfSubtractedFreeReward  ; subtractedSD'] ;
            
            
            lesserLength =   min([size(freeOutcomeDoubleFlash,1) size(freeOutcomeSingleFlash,1)]);
            
            subtractedSD= (freeOutcomeDoubleFlash(1:lesserLength )/normvalueDouble(iii) ) - ...
                (freeOutcomeSingleFlash(1:lesserLength )/normvalueDouble(iii));
            
            plot(subtractedSD','k','LineWidth', 2); hold on;
            %     subtractedSD= freeOutcomeDoubleAirpuff -freeOutcomeSingleAirpuff;
            %     plot(subtractedSD,'b','LineWidth', 2); hold on;
            
            
            SdfSubtractedFreeFlash = [SdfSubtractedFreeFlash  ; subtractedSD'] ;
            
            clear tq xt line rastList MatPlot curY_rast temptq rasts SD SDplotto xuncert
            
            
            x=[firstOutcomeTime,firstOutcomeTime ];
            y=[-50,ylimvar];
            plot(x,y,'k'); hold on;
            
            x=[(averageOutcomeSeperation +firstOutcomeTime ),  ...
                (averageOutcomeSeperation +firstOutcomeTime)];
            
            y=[-50,ylimvar];
            plot(x,y,'k'); hold on;
            
            xlim([500 2750])
            %     ylim([-80 ylimvar])
            ylim ([-3 3])
            xlabel('(Double/NormDouble)-(Single/NormSingle) outcomes')
            axis square;
            clear rasts xt rastList MatPlot
            
%         catch e
%             e
            
%         end
        
        suptitle(['FreeOutcomes ' titleStringAdd titlestring])
        ilyaOutputFile(gcf ,saveFileLoc,['FreeOutcomes_' titleStringAdd titlestring]  )
        probAmtFigure = figure;
        %    close all;
        %%%%%%%%%%%%%%%%%%Make Save Struct %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         try
            if ~isempty(SDFfree_ ( intersect(free1_ , fullItiTrials_),: ) ) && ...
                    ~isempty(  SDFfree ( intersect(free1 , fullItiTrials),: ) ) && ...
                    ~isempty(SDFfree_ ( intersect(free34_ , fullItiTrials_),: )  ) && ...
                    ~isempty(SDFfree ( intersect(free34 , fullItiTrials),: ) )
                
                trialstoAverage = iii;
            else
                trialstoAverage = [];
            end
            %          trialsToAverage =1:size(SdfFullTrialOnlySingleFreeRewards,1);
            % trialsToAverage = [1:3 5:size(SdfFullTrialOnlySingleFreeRewards,1)] ;
            if iii==1
                SaveStructFreeRewardsGlobal.trialsToAverage = [];
            end
            
            
            SaveStructFreeRewards{iii}.trialsToAverage =  trialstoAverage ;
            SaveStructFreeRewardsGlobal.trialsToAverage = [SaveStructFreeRewardsGlobal.trialsToAverage trialstoAverage];
            
            
            %%%%%%%%%%%%%
            SaveStructFreeRewards{iii}.SingleRewardTrials =  SDFfree ( intersect(free1 , fullItiTrials),: );
            
            SaveStructFreeRewards{iii}.SingleAirpuffTrials =  SDFfree ( intersect(free2 , fullItiTrials),: );
            
            SaveStructFreeRewards{iii}.SingleFlashTrials =  SDFfree ( intersect(free34 , fullItiTrials),: );
            %%%%%%%%%%%%%%%%%%%%%%%%%
            
            SaveStructFreeRewards{iii}.DoubleMinusSingle = subtractedSD;
            SaveStructFreeRewards{iii}.freeOutcomeDoubleRewardMean = freeOutcomeDoubleReward';
            SaveStructFreeRewards{iii}.freeOutcomeSinglerewardMean = freeOutcomeSingleReward';
            
            SaveStructFreeRewards{iii}.freeOutcomeDoubleFlashMean = freeOutcomeDoubleFlash';
            SaveStructFreeRewards{iii}.freeOutcomeSingleFlashMean = freeOutcomeSingleFlash';
            SaveStructFreeRewards{iii}.FreeRewardCenter =8001;
            
%         catch
%             e
%         end
        
        %     load([rootofShare1 filesep groupDirectory{1,2}{1} filesep groupFilenames{1,2}{1}]);
        
        try
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            loopCounter=iii; % indexTimingTrace(iii);
            ProbVersusamt_helper_V08 % update to latest version if it has changed
            
            CENTER=11000 ;  % for CSs
            %%%%%%%%%%%%%%%%%%Make Save Struct %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Trace Data Struct
            StructMakerProbAmt_V07; % update to latest version if it has changed
            saveStructProbAmt{iii} = tempSaveStructProbAmt ;
            clear tempSaveStructProbAmt  ;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            saveStructProbAmt{iii}.OutcomeTime = (CENTER + (c.CS_dur*1000));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            
            
            
            %%%%% Plot reward prediction error%%%%%%%%%%%
            open([saveFileLoc filesep 'FreeOutcomes_' titleStringAdd titlestring '.fig'])
            mainFig = gcf;
                CENTER=11000; % center from Prob Amt file
            nsubplot(100,100,1:45,50:100)
            plot(wholemeantrials50dCsRate,'r')  ;
            hold on
            plot(wholemeantrials50ndCsRate,'b')  ;
            xlim([10000 15000]);
            x=[CENTER CENTER];
            
            y=[0,ylimvar];
            plot(x,y,'k'); hold on;
            xlim([CENTER-1000 15000]);
            %           +(c.CS_dur*1000)
            x=[CENTER+(c.CS_dur*1000) CENTER+(c.CS_dur*1000)];
            
            y=[0,ylimvar];
            plot(x,y,'k'); hold on;
            %     ylim([]);
            xlabel('50% CS deliverd and Not delivered')
            
            text(11000, 200,'CS on');
            text(13500, 200,'Outcome');
            axis square
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            RPE = wholemeantrials50dCsRate - wholemeantrials50ndCsRate ;
            
            %         plot(RPE , 'k');
            
            
            CENTER=8000;  
            % center from free rewards
            ilyaOutputFile(gcf ,saveFileLoc,['FreeOutcomes_' titleStringAdd titlestring]  )
            
%         catch e
%             e
        end
        
        checkloop=timeTraceType2(iii)
        SaveStructFreeRewardsGlobal.filecount=iii;
        %     save([ saveFileLoc filesep 'SaveStructFreeRewardsData' ], 'SaveStructFreeRewards' , 'SaveStructFreeRewardsGlobal' , '-v7.3');
        %     save([ saveFileLoc filesep 'SaveStructProbAmtData_FromTrace'] , 'saveStructProbAmt' , '-v7.3');
        %     save([ saveFileLoc filesep 'SaveStructTimingTrace' ], 'SaveStructTrace' , '-v7.3');
%     catch e
%         % catch error and put it in an error struct to be examined
%         errorstruct{iii}.errorinfo = e;
%         errorstruct{iii}.filename1 =groupFilenames{1};
%         errorstruct{iii}.filename2 =groupFilenames{2};
%     end
    
end




save('SaveStructFreeRewardsData' , 'SaveStructFreeRewards' , 'SaveStructFreeRewardsGlobal' , '-v7.3');
save('SaveStructProbAmtData_FromTrace' , 'saveStructProbAmt' , '-v7.3');
save('SaveStructTimingTrace' , 'SaveStructTrace' , '-v7.3');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Average
% Plot
% this plots the Average Single and double 


%  trialsToAverage =1:size(SdfFullTrialOnlySingleFreeRewards,1);
%  trialsToAverage = 1:size(SaveStructFreeRewards)

%%%
AllTrialSingleFreeRewards ;
AllTrialSingleFreeFlash ;
AllTrialSingleFreeAirpuff;
%%%
FullTrialOnlySingleFreeRewards ;
FullTrialOnlySingleFreeFlash ;
FullTrialOnlySingleFreepunish ;
%%%
AllTrialDoubleFreeRewards ;
AllTrialDoubleFreeFlash ;
AllTrialDoubleFreeAirpuff ;

FullTrialOnlyDoubleFreeRewards ;
FullTrialOnlyDoubleFreeFlash ;
%         FullTrialOnlyDoubleFreeAirpuff ;

% plot_mean_psth({Rasters},gauswindow_ms,1,(CENTER*2)-2,1);
SDFaverageSingleReward =  plot_mean_psth({FullTrialOnlySingleFreeRewards},gauswindow_ms,1,(CENTER*2)-2,1);
SDFplotSingleFlash =  plot_mean_psth({FullTrialOnlySingleFreeFlash},gauswindow_ms,1,(CENTER*2)-2,1);
SDFplotSinglePuff =  plot_mean_psth({FullTrialOnlySingleFreepunish},gauswindow_ms,1,(CENTER*2)-2,1);
SDFplotDoubleReward =  plot_mean_psth({FullTrialOnlyDoubleFreeRewards},gauswindow_ms,1,(CENTER*2)-2,1);
SDFplotDoubleFlash =  plot_mean_psth({FullTrialOnlyDoubleFreeFlash},gauswindow_ms,1,(CENTER*2)-2,1);
SDFplotDoublePuff =  plot_mean_psth({FullTrialOnlyDoubleFreeAirpuff},gauswindow_ms,1,(CENTER*2)-2,1);


AveragePlot = figure;
nsubplot(1,3,1,1)
xAxisLabel = 7000:11000;
smoothValue=10;

if atHome==1
    SdfAllTrialSingleFreeRewards  ;
    SdfAllTrialSingleFreeFlash  ;
    SdfAllTrialSingleFreeAirpuff  ;
    
    SDFSingleReward =  SdfFullTrialOnlySingleFreeRewards' ;
    SDFSingleFlash= SdfFullTrialOnlySingleFreeFlash'  ;
    SdfFullTrialOnlySingleFreepunish' ;
    
    SDFDoubleReward=     SdfAllTrialDoubleFreeRewards' ;
    SDFDoubleFlash= SdfAllTrialDoubleFreeFlash' ;
    SDFDoublePuff=  SdfAllTrialDoubleFreeAirpuff'  ;
    
    SdfFullTrialOnlyDoubleFreeRewards ;
    SdfFullTrialOnlyDoubleFreeFlash ;
    SdfFullTrialOnlyDoubleFreepunish ;
    smallerArrayLimit = size(SDFSingleReward,1);
else
    SdfAllTrialSingleFreeRewards  ;
    SdfAllTrialSingleFreeFlash  ;
    SdfAllTrialSingleFreeAirpuff  ;
    
    SDFSingleReward =  SdfFullTrialOnlySingleFreeRewards ;
    SDFSingleFlash= SdfFullTrialOnlySingleFreeFlash  ;
    SdfFullTrialOnlySingleFreepunish ;
    
    SDFDoubleReward=     SdfAllTrialDoubleFreeRewards ;
    SDFDoubleFlash= SdfAllTrialDoubleFreeFlash ;
    SDFDoublePuff=  SdfAllTrialDoubleFreeAirpuff  ;
    
    SdfFullTrialOnlyDoubleFreeRewards ;
    SdfFullTrialOnlyDoubleFreeFlash ;
    SdfFullTrialOnlyDoubleFreepunish ;
    smallerArrayLimit = size(SDFSingleReward,2);
end

trialsToAverage=size(SDFSingleReward,1);
hold on;
% plot(nanmean(AllTrialSingleFreeRewards), 'r');
plot(xAxisLabel(1:size(SDFSingleReward,2)), nanmean(SDFSingleReward(trialsToAverage,:),1),'r','LineWidth', 2);

% plot(nanmean(AllTrialSingleFreeFlash), 'k');\
plot(xAxisLabel(1:size(SDFSingleFlash,2)), nanmean(SDFSingleFlash(trialsToAverage,:),1),'k','LineWidth', 2);

% plot(nanmean(AllTrialSingleFreeAirpuff), 'b');
% plot(nanmean(SDFplotSinglePuff),'b','LineWidth', 2);
xlim([7000 9750]);
%

ylim ([ 0 160]);
title('mean of all Single free outcome run SDFs ')
x=[8000,8000 ];
y=[-50,ylimvar];
plot(x,y,'k'); hold on;
xlim ([7000 7000+smallerArrayLimit]);


nsubplot(1,3,1,2)
% plot(nanmean(AllTrialDoubleFreeRewards), 'r');
% plot(nanmean(AllTrialDoubleFreeFlash), 'k');
% plot(nanmean(AllTrialDoubleFreeAirpuff), 'b');

hold on;
% plot(nanmean(AllTrialSingleFreeRewards), 'r');
plot(xAxisLabel(1:size(SDFDoubleReward,2)), ...
    nanmean(SDFDoubleReward(trialsToAverage,:),1),'r','LineWidth', 2);

% plot(nanmean(AllTrialSingleFreeFlash), 'k');\
plot(xAxisLabel(1:size(SDFDoubleFlash,2)), ...
    nanmean(SDFDoubleFlash(trialsToAverage,:),1),'k','LineWidth', 2);

% plot(nanmean(AllTrialSingleFreeAirpuff), 'b');
plot(xAxisLabel(1:size(SDFDoublePuff,2)), ...
    nanmean(SDFDoublePuff(trialsToAverage,:),1),'b','LineWidth', 2);

xlim([7000 11000]);
xlim ([7000 7000+smallerArrayLimit]);

ylim ([ 0 160]);
title('mean of all Double outcome run SDFs ')
firstOutcomeTime=8000;
averageOutcomeSeperation = 1176;

x=[firstOutcomeTime,firstOutcomeTime ];
y=[-50,ylimvar];
plot(x,y,'k'); hold on;
x=[(averageOutcomeSeperation +firstOutcomeTime ),(averageOutcomeSeperation +firstOutcomeTime ) ];
y=[-50,ylimvar];
plot(x,y,'k'); hold on;

nsubplot(1,3,1,3)
if atHome==1
    smallerArrayLimit = size(SDFSingleReward,1);
    SDFDoubleReward =SDFDoubleReward';
    SDFSingleReward = SDFSingleReward';
    SDFDoubleFlash = SDFDoubleFlash';
    SDFSingleFlash = SDFSingleFlash';
else
    smallerArrayLimit = size(SDFSingleReward,2);
end

useRawValues=0
if useRawValues==1
    plot(xAxisLabel(1:smallerArrayLimit), ...
        nanmean(SDFDoubleReward(trialsToAverage , 1:smallerArrayLimit ),1) - nanmean(SDFSingleReward ,1), 'r');
    hold on;
    plot(xAxisLabel(1:smallerArrayLimit), ...
        nanmean(SDFDoubleFlash(trialsToAverage , 1:smallerArrayLimit ),1) - nanmean(SDFSingleFlash ,1), 'k');
    % plot(nanmean(SDFplotDoublePuff ) - nanmean(SDFplotSinglePuff ), 'b') ;
    xlim ([7000 7000+smallerArrayLimit]);
    %  ylim ([ 0 160]);
    ylim([-20 40])
    title('Subtraction (Double-Single) mean of all run SDFs ')
    
    firstOutcomeTime=8000;
    averageOutcomeSeperation = 1176;
    x=[8000,8000 ];
    y=[-50,ylimvar];
    plot(x,y,'k'); hold on;
    x=[(averageOutcomeSeperation +firstOutcomeTime ),(averageOutcomeSeperation +firstOutcomeTime ) ];
    y=[-50,ylimvar];
    plot(x,y,'k'); hold on;
else
    %     plot(xAxisLabel(1:smallerArrayLimit), nanmean(SDFDoubleReward(: , 1:smallerArrayLimit ),1) - nanmean(SDFSingleReward ,1), 'r');
    plot(xAxisLabel(1:smallerArrayLimit), ...
        smooth(nanmean(SdfSubtractedFreeFlash),smoothValue),'k','LineWidth', 2)
    hold on;
    plot(xAxisLabel(1:smallerArrayLimit), ...
        smooth(nanmean(SdfSubtractedFreeReward),smoothValue),'r','LineWidth', 2)
    xlim ([7000 7000+smallerArrayLimit]);
    %     ylim([-1 1])
    ylim auto
    closeYlim= ylim;
    firstOutcomeTime=8000;
    averageOutcomeSeperation = 1176;
    x=[8000,8000 ];
    y=[-50,ylimvar];
    plot(x,y,'k'); hold on;
    x=[(averageOutcomeSeperation +firstOutcomeTime ), ...
        (averageOutcomeSeperation +firstOutcomeTime ) ];
    y=[-50,ylimvar];
    plot(x,y,'k'); hold on;
    (ylim(closeYlim))
    title('Normalized mean Double- Single free outcomes');
end

suptitle(['AverageFreeOutcomes ' ])
if smoothValue > 1
    ilyaOutputFile(gcf ,saveFileLoc,['FreeOutcomes_Averages'  '_005']  )
else
    ilyaOutputFile(gcf ,saveFileLoc,['FreeOutcomes_Averages_Smooth'  '_005']  )
end
save('AverageFreeRewards_006.mat');

