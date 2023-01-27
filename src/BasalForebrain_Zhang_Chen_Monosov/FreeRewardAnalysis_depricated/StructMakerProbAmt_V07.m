% StructMakerProbAmt_V07

%Script level structMaker for packaging ProbAmtData, ment to be run after
%ProbVersusamt_helper_V08 and later

% tempSaveStructProbAmt.

tempSaveStructProbAmt.completedtrial_s = completedtrial_s;
tempSaveStructProbAmt.completedtrial_c = completedtrial_c;
tempSaveStructProbAmt.trials100 = trials100 ;
tempSaveStructProbAmt.trials50  = trials50  ;
tempSaveStructProbAmt.trials0  = trials0  ;
tempSaveStructProbAmt.trials100s  = trials100s  ;
tempSaveStructProbAmt.trials50d  = trials50d  ;
tempSaveStructProbAmt.trials50nd  =trials50nd   ;
tempSaveStructProbAmt.choice100versus50  = choice100versus50  ;
tempSaveStructProbAmt.choice100versus0  =choice100versus0   ;
tempSaveStructProbAmt.choice100versus100s  =  choice100versus100s ;
tempSaveStructProbAmt.choice50versus100s  =   choice50versus100s;
tempSaveStructProbAmt.choice50versus0  =  choice50versus0 ;
tempSaveStructProbAmt.choice100sversus0  = choice100sversus0  ;
tempSaveStructProbAmt.BehaviortosaveforSummary  = BehaviortosaveforSummary  ;
tempSaveStructProbAmt.c100v50  = c100v50  ;
tempSaveStructProbAmt.c100v100s  = c100v100s  ;
tempSaveStructProbAmt.c100v0  =  c100v0 ;
tempSaveStructProbAmt.c50v100s  = c50v100s  ;
tempSaveStructProbAmt.c50v0  =c50v0   ;
tempSaveStructProbAmt.c100sv0  =   c100sv0;



tempSaveStructProbAmt.SDFcstrials100  = nanmean(SDFcs(trials100,:),1) ;
tempSaveStructProbAmt.SDFcstrials50d  = nanmean(SDFcs(trials50d,:),1) ;
tempSaveStructProbAmt.SDFcstrials0  = nanmean(SDFcs(trials0,:),1) ;
tempSaveStructProbAmt.SDFcstrials50nd  = nanmean(SDFcs(trials50nd,:),1) ;





tempSaveStructProbAmt.SDFcstrials100s  = nanmean(SDFcs(trials100s,:),1) ;
tempSaveStructProbAmt.SDFcstrials50ALL  = nanmean(SDFcs(trials50,:),1) ;

% tempSaveStructProbAmt.SDFfree  =  single(SDFfree) ;

tempSaveStructProbAmt.CenterForCs = 11000;

CENTER=8001; %this is event alignment. this means that at 11,000 the event that we are studying (aligning spikes too) will be in the SDF *you will see in ploting
tempSaveStructProbAmt.CenterForCs = CENTER;

gauswindow_ms=50;
limitsarray=[CENTER-1000:CENTER+1750];

xlimvar=length(limitsarray);
% ylimvar=100;

PDS.timesoffreeoutcomes_first(find(PDS.timesoffreeoutcomes_first>10))=NaN; %very few trials have a timing bug. just remove them
free1=intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==1)); %reward/juice
free34=intersect(find(PDS.timesoffreeoutcomes_first>0),find(PDS.freeoutcometype==34)); %flash.sound combination

tempSaveStructProbAmt.SDFfreeReward = nanmean(SDFfree(free1 ,limitsarray ),1) ;
tempSaveStructProbAmt.SDFfreeFlashSound = nanmean(SDFfree(free34  ,limitsarray),1) ;

% tempSaveStructProbAmt.SDFchosenwindow  = single(SDFchosenwindow ) ;

%   tempSaveStructProbAmt.LogicalRasterscs  =  logical(Rasterscs );

%    tempSaveStructProbAmt.LogicalRastersfree  =  logical(Rastersfree) ;

%   tempSaveStructProbAmt.LogicalRastersChosenwindow  = logical(RastersChosenwindow)  ;
%    tempSaveStructProbAmt.meansaveautocor  = nanmean(saveautocor)  ;
%  tempSaveStructProbAmt.zsuaireg  = zsuaireg  ;
tempSaveStructProbAmt.FIRIG_IREG_INDEX  = FIRIG_IREG_INDEX  ;
tempSaveStructProbAmt.significantautocorwidth  =  significantautocorwidth ;
Savelicks(isnan(Savelicks)) =0;

tempSaveStructProbAmt.Savelicks = logical(Savelicks)  ;
tempSaveStructProbAmt.PercentPupil  =  single(PercentPupil) ;
tempSaveStructProbAmt.LookinginTargetZone  = PDS.samplesInTargetZonefinish  ;

tempSaveStructProbAmt.singlepvalue_valueindex  =   pvalue_valueindex;
tempSaveStructProbAmt.singlevalueindex  =   valueindex;
tempSaveStructProbAmt.singlepvalue_uncertindex  =   pvalue_uncertindex;
tempSaveStructProbAmt.singleuncertindex  =   uncertindex;


% choice Data

try
    tempSaveStructProbAmt.SDFchoicePreGo   =  nanmean(SDFcs(choicetrialsstarted,10500:11000),1);
catch
    tempSaveStructProbAmt.SDFchoicePreGo   = NaN;
end
try
    tempSaveStructProbAmt.SDFchoice100V50   = nanmean(SDFcs((choice100_versus50),11000:11000+RT1),1);
catch
    tempSaveStructProbAmt.SDFchoice100V50   = NaN;
end
try
    tempSaveStructProbAmt.SDFchoice100V100s   = nanmean(SDFcs((choice100_versus100s),11000:11000+RT2),1);
catch
    tempSaveStructProbAmt.SDFchoice100V100s   = NaN;
end
try
    tempSaveStructProbAmt.SDFchoice100V0   = nanmean(SDFcs((choice100_versus0),11000:11000+RT3),1);
catch
    tempSaveStructProbAmt.SDFchoice100V0   =NaN;
end
try
    tempSaveStructProbAmt.SDFchoice50V100s   = nanmean(SDFcs((choice50_versus100s),11000:11000+RT4),1);
catch
    tempSaveStructProbAmt.SDFchoice50V100s   =NaN;
end
try
    tempSaveStructProbAmt.SDFchoice50V0   = nanmean(SDFcs((choice50_versus0),11000:11000+RT5),1);
catch
    tempSaveStructProbAmt.SDFchoice50V0   = NaN;
end
try
    tempSaveStructProbAmt.SDFchoice100sV0   = nanmean(SDFcs((choice100s_versus0),11000:11000+RT6),1);
catch
    tempSaveStructProbAmt.SDFchoice100sV0   = NaN;
end

try
    tempSaveStructProbAmt.prechoiceWillChoose100 = prechoiceWillChoose100;
catch
    tempSaveStructProbAmt.prechoiceWillChoose100 =NaN;
end
try
    tempSaveStructProbAmt.prechoiceWillChoose50 = prechoiceWillChoose50;
catch
    tempSaveStructProbAmt.prechoiceWillChoose50 =NaN;
end
try
    tempSaveStructProbAmt.prechoiceWillChoose100s = prechoiceWillChoose100s;
catch
    tempSaveStructProbAmt.prechoiceWillChoose100s  =NaN;
end
try
    tempSaveStructProbAmt.prechoiceWillChoose100sover50 = prechoiceWillChoose100sover50;
catch
    tempSaveStructProbAmt.prechoiceWillChoose100sover50 =NaN;
end
try
    tempSaveStructProbAmt.prechoiceWillChoose50over100s = prechoiceWillChoose50over100s;
catch
    tempSaveStructProbAmt.prechoiceWillChoose50over100s =NaN;
end
try
    tempSaveStructProbAmt.fractals = PDS.fractals
    tempSaveStructProbAmt.fractals2 = PDS.fractals2
    tempSaveStructProbAmt.chosenwindow =  PDS.chosenwindow
catch
end

tempSaveStructProbAmt.SDFchosen100 = nanmean(chosen100);
tempSaveStructProbAmt.SDFchosen50 = nanmean(chosen50);
tempSaveStructProbAmt.SDFchosen100s = nanmean(chosen100s);
tempSaveStructProbAmt.SDFchosenTimeRange =chosenRangein;



tempSaveStructProbAmt.SDFoutcome100 = nanmean(SDFoutcome(postchoice100,:),1);
tempSaveStructProbAmt.SDFoutcome100s = nanmean(SDFoutcome(postchoice100s,:),1);
tempSaveStructProbAmt.SDFoutcome50d= nanmean(SDFoutcome(postchoice50d,:),1);
tempSaveStructProbAmt.SDFoutcome50nd = nanmean(SDFoutcome(postchoice50nd,:),1);


tempSaveStructProbAmt.choiceepochpvalue_valueindex_c  = pvalue_valueindex_c  ;
tempSaveStructProbAmt.choiceepochvalueindex_c  =  valueindex_c ;
tempSaveStructProbAmt.choiceepochpvalue_uncertindex_c  =  pvalue_uncertindex_c ;
tempSaveStructProbAmt.choiceepochuncertindex_c  =  uncertindex_c;

tempSaveStructProbAmt.postChoicepvalue_valueindex_cpost  =pvalue_valueindex_cpost   ;
tempSaveStructProbAmt.postChoicevalueindex_cpost  = valueindex_cpost  ;
tempSaveStructProbAmt.postChoicepvalue_uncertindex_cpost  =  pvalue_uncertindex_cpost ;
tempSaveStructProbAmt.postChoiceuncertindex_cpost  =  uncertindex_cpost ;

tempSaveStructProbAmt.PvaracrossCSs = PvaracrossCSs;
tempSaveStructProbAmt.UncertsaveCsSingleTrials =UncertsaveCsSingleTrials   ;
tempSaveStructProbAmt.ValuesaveCsSingleTrials=  ValuesaveCsSingleTrials;

tempSaveStructProbAmt.SingleTrialPvalueSaveCS =SingleTrialPvalueSaveCS;

%     tempSaveStructProbAmt.PvalueAcrossCs  =  PvalueAcrossCs ;

tempSaveStructProbAmt.choiceTargOnUncertsaveCS  =   UncertsaveCS;
tempSaveStructProbAmt.choiceTargOnValuesaveCS  =   ValuesaveCS;
tempSaveStructProbAmt.choiceTargOnPval   = PvalueAcrossCs;



tempSaveStructProbAmt.PvalueCHSN  = PvalueSaveCHSN;
tempSaveStructProbAmt.UncertsaveCHSN  = UncertsaveCHSN  ;
tempSaveStructProbAmt.ValuesaveCHSN  =ValuesaveCHSN   ;


tempSaveStructProbAmt.ResponseTime  = ResponseTime  ;
%     tempSaveStructProbAmt.PvalueChoiceOnset  =PvalueChoiceOnset   ;
%     %     tempSaveStructProbAmt.PvalueChoiceOnsetFull  =  PvalueChoiceOnsetFull ;
%     tempSaveStructProbAmt.PvalueChoiceOnsetOverall  =PvalueChoiceOnsetOverall

tempSaveStructProbAmt.PvaluePostChoice  =   PvaluePostChoice;
tempSaveStructProbAmt.PvaluePostChoiceOverall  =   PvaluePostChoiceOverall;

tempSaveStructProbAmt.PvalueChoiceOnsetFull6CCond = PvalueChoiceOnsetFull6CCond;
tempSaveStructProbAmt.PvalChoiceOnsetoverall6Cond = PvalChoiceOnsetoverall6Cond;

tempSaveStructProbAmt.PvalChoiceEyein = PvalChoiceEyein;


tempSaveStructProbAmt.PvaluePostOutcome  =  PvaluePostOutcome ;
tempSaveStructProbAmt.PvaluePostOutcomeOverall  =  PvaluePostOutcomeOverall ;

tempSaveStructProbAmt.PvalChoiceOnsetoverall6Cond = PvalChoiceOnsetoverall6Cond;
tempSaveStructProbAmt.PvalueChoiceOnsetFull6CCond = PvalueChoiceOnsetFull6CCond;

tempSaveStructProbAmt.PvalueChoiceOnsetOverall3cond = PvalueChoiceOnsetOverall3cond;
tempSaveStructProbAmt.PvalueChoiceOnsetFull3cond = PvalueChoiceOnsetFull3cond;


tempSaveStructProbAmt.ranksum100V50  =  p100V50 ;
tempSaveStructProbAmt.ranksump100V0 =  p100V0 ;
tempSaveStructProbAmt.ranksump100V100s  =   p100V100s;
tempSaveStructProbAmt.ranksump0V50  = p0V50  ;
tempSaveStructProbAmt.ranksump0V100s  =  p0V100s ;
tempSaveStructProbAmt.ranksump100sV50  = p100sV50  ;


tempSaveStructProbAmt.ranksumearly100V50  =  earlyp100V50 ;
tempSaveStructProbAmt.ranksumpearly100V0 =  earlyp100V0 ;
tempSaveStructProbAmt.ranksumpearly100V100s  =   earlyp100V100s;
tempSaveStructProbAmt.ranksumpearly0V50  = earlyp0V50  ;
tempSaveStructProbAmt.ranksumpearly0V100s  =  earlyp0V100s ;
tempSaveStructProbAmt.ranksumpearly100sV50  = earlyp100sV50  ;

tempSaveStructProbAmt.ranksumearly_2_100V50  =  early2p100V50 ;
tempSaveStructProbAmt.ranksumpearly_2_100V0 =  early2p100V0 ;
tempSaveStructProbAmt.ranksumpearly_2_100V100s  =   early2p100V100s;
tempSaveStructProbAmt.ranksumpearly_2_0V50  = early2p0V50  ;
tempSaveStructProbAmt.ranksumpearly_2_0V100s  =  early2p0V100s ;
tempSaveStructProbAmt.ranksumpearly_2_100sV50  = early2p100sV50  ;




tempSaveStructProbAmt.ranksumlate100V50  =  latep100V50 ;
tempSaveStructProbAmt.ranksumplate100V0 =  latep100V0 ;
tempSaveStructProbAmt.ranksumplate100V100s  =   latep100V100s;
tempSaveStructProbAmt.ranksumplate0V50  = latep0V50  ;
tempSaveStructProbAmt.ranksumplate0V100s  =  latep0V100s ;
tempSaveStructProbAmt.ranksumplate100sV50  = latep100sV50  ;



tempSaveStructProbAmt.typeOfUncertCodingWholeCs  = typeOfCoding{1}  ;
tempSaveStructProbAmt.typeAmtOfCodingWholeCs = typeAmtOfCoding{1};
tempSaveStructProbAmt.typeOfUncertCodingEarlyCs  = typeOfCoding{2}  ;
tempSaveStructProbAmt.typeAmtOfCodingEarlyCs = typeAmtOfCoding{2};
tempSaveStructProbAmt.typeOfUncertCodingEarly2Cs  = typeOfCoding{3}  ;
tempSaveStructProbAmt.typeAmtOfCodingEarly2Cs = typeAmtOfCoding{3};
tempSaveStructProbAmt.typeOfUncertCodingLateCs  = typeOfCoding{4}  ;
tempSaveStructProbAmt.typeAmtOfCodingLateCs = typeAmtOfCoding{4};



%   tempSaveStructProbAmt.ranksumrate100Vrates0  = ranksumrate100Vrates0  ;
%   tempSaveStructProbAmt.ranksumrate100sVrates0  = ranksumrate100sVrates0  ;


tempSaveStructProbAmt.roc50V100AreaAndP  = [singleFileRocIndexX(kk), pvalsingleFileRocIndexX(kk)]  ;
tempSaveStructProbAmt.roc50V0AreaAndP   =   [singleFileRocIndexY(kk), pvalsingleFileRocIndexY(kk) ];
tempSaveStructProbAmt. roc100V0AreaAndP =   [singleFileRocIndexZ(kk), pvalsingleFileRocIndexZ(kk) ];

tempSaveStructProbAmt.roc50V100sAreaAndP  =  [singleFileRocIndexXsmall(kk), pvalsingleFileRocIndexXsmall(kk) ] ;
tempSaveStructProbAmt.roc100V100sAreaAndP  =  [singleFileRocIndexYsmall(kk), pvalsingleFileRocIndexYsmall(kk) ] ;

tempSaveStructProbAmt.roc100sV0AreaAndP  =  [singleFileRocIndexZsmall(kk), pvalsingleFileRocIndexZsmall(kk) ] ;
% tempSaveStructProbAmt.  =   ;




% spike shape plots
%     tempSaveStructProbAmt.waveformtempSaveStructProbAmt  =tempSaveStructProbAmt   ;
tempSaveStructProbAmt.waveformmeanWaveform  =  meanWaveform ;
tempSaveStructProbAmt.waveformlowerBound  =  lowerBound ;
tempSaveStructProbAmt.waveformupperBound  = upperBound  ;


tempSaveStructProbAmt.contRoc100V0 =  [r1];
tempSaveStructProbAmt.contRoc100V0Pval =[p1];

tempSaveStructProbAmt.contRoc50V100s =  [r2];
tempSaveStructProbAmt.contRoc50V100sPval =[p2];

tempSaveStructProbAmt.contRoc100V50 =  [r3];
tempSaveStructProbAmt.contRoc100V50Pval =[p3];

tempSaveStructProbAmt.contRoc50V0 =  [r4];
tempSaveStructProbAmt.contRoc50V0Pval =[p4];

tempSaveStructProbAmt.contRoc100sV0 =  [r5];
tempSaveStructProbAmt.contRoc100sV0Pval =[p5];

tempSaveStructProbAmt.contRoc100V100s =  [r6];
tempSaveStructProbAmt.contRoc100V100sPval =[p6];

% 
% tempSaveStructProbAmt.earlycontRoc100V0 =  [earlyr1];
% tempSaveStructProbAmt.earlycontRoc100V0Pval =[earlyp1];
% 
% tempSaveStructProbAmt.earlycontRoc50V100s =  [earlyr2];
% tempSaveStructProbAmt.earlycontRoc50V100sPval =[earlyp2];
% 
% tempSaveStructProbAmt.earlycontRoc100V50 =  [earlyr3];
% tempSaveStructProbAmt.earlycontRoc100V50Pval =[earlyp3];
% 
% tempSaveStructProbAmt.earlycontRoc50V0 =  [earlyr4];
% tempSaveStructProbAmt.earlycontRoc50V0Pval =[earlyp4];
% 
% tempSaveStructProbAmt.earlycontRoc100sV0 =  [earlyr5];
% tempSaveStructProbAmt.earlycontRoc100sV0Pval =[earlyp5];
% 
% tempSaveStructProbAmt.earlycontRoc100V100s =  [earlyr6];
% tempSaveStructProbAmt.earlycontRoc100V100sPval =[earlyp6];
% 
% 
% tempSaveStructProbAmt.latecontRoc100V0 =  [later1];
% tempSaveStructProbAmt.latecontRoc100V0Pval =[latep1];
% 
% tempSaveStructProbAmt.latecontRoc50V100s =  [later2];
% tempSaveStructProbAmt.latecontRoc50V100sPval =[latep2];
% 
% tempSaveStructProbAmt.latecontRoc100V50 =  [later3];
% tempSaveStructProbAmt.latecontRoc100V50Pval =[latep3];
% 
% tempSaveStructProbAmt.latecontRoc50V0 =  [later4];
% tempSaveStructProbAmt.latecontRoc50V0Pval =[latep4];
% 
% tempSaveStructProbAmt.latecontRoc100sV0 =  [later5];
% tempSaveStructProbAmt.latecontRoc100sV0Pval =[latep5];
% 
% tempSaveStructProbAmt.latecontRoc100V100s =  [later6];
% tempSaveStructProbAmt.latecontRoc100V100sPval =[latep6];
% 



tempSaveStructProbAmt.earlyroc100V50AreaAndP  = [earlyr3Overall,earlyp3Overall] ;
tempSaveStructProbAmt.earlyroc50V0AreaAndP   =  [earlyr4Overall,earlyp4Overall] ;
tempSaveStructProbAmt. earlyroc100V0AreaAndP = [earlyr1Overall,earlyp1Overall]  ;
tempSaveStructProbAmt.earlyroc50V100sAreaAndP  =  [earlyr2Overall,earlyp2Overall] ;
tempSaveStructProbAmt.earlyroc100V100sAreaAndP  = [earlyr6Overall,earlyp6Overall] ;
tempSaveStructProbAmt.earlyroc100sV0AreaAndP  = [earlyr5Overall,earlyp5Overall];


tempSaveStructProbAmt.early2roc100V50AreaAndP  = [early2r3Overall,early2p3Overall] ;
tempSaveStructProbAmt.early2roc50V0AreaAndP   =  [early2r4Overall,early2p4Overall] ;
tempSaveStructProbAmt. early2roc100V0AreaAndP = [early2r1Overall,early2p1Overall]  ;
tempSaveStructProbAmt.early2roc50V100sAreaAndP  =  [early2r2Overall,early2p2Overall] ;
tempSaveStructProbAmt.early2roc100V100sAreaAndP  = [early2r6Overall,early2p6Overall] ;
tempSaveStructProbAmt.early2roc100sV0AreaAndP  = [early2r5Overall,early2p5Overall];

tempSaveStructProbAmt.lateroc100V50AreaAndP  = [later3Overall,latep3Overall] ;
tempSaveStructProbAmt.lateroc50V0AreaAndP   =  [later4Overall,latep4Overall] ;
tempSaveStructProbAmt. lateroc100V0AreaAndP = [later1Overall,latep1Overall]  ;
tempSaveStructProbAmt.lateroc50V100sAreaAndP  =  [later2Overall,latep2Overall] ;
tempSaveStructProbAmt.lateroc100V100sAreaAndP  = [later6Overall,latep6Overall] ;
tempSaveStructProbAmt.lateroc100sV0AreaAndP  = [later5Overall,latep5Overall];

tempSaveStructProbAmt.chosen100WpreEyeIn = chosen100WpreEyeIn;
tempSaveStructProbAmt.chosen100sWpreEyeIn = chosen100sWpreEyeIn;

tempSaveStructProbAmt.chosen50WpreEyeIn = chosen50WpreEyeIn;
tempSaveStructProbAmt.pval_valuereg = pval_valuereg;
tempSaveStructProbAmt.r_valuereg = r_valuereg;


if  isfield(PDS, 'goodtrial')
    tempSaveStructProbAmt.numTrials = sum(PDS.goodtrial) ;
else
    tempSaveStructProbAmt.numTrials = sum(~PDS.repeatflag);
    
end

% Excel data
try

tempSaveStructProbAmt.Depth = (xlsCellsForChosenFiles{iii,13}) ;
tempSaveStructProbAmt.UnitId = (xlsCellsForChosenFiles{iii,16});
tempSaveStructProbAmt.PDSfilename= FilesToRun{iii};
tempSaveStructProbAmt.AOfilename= AlphaOmegaFilesToRun{iii};
tempSaveStructProbAmt.excelLine = {xlsCellsForChosenFiles{iii,:}}
tempSaveStructProbAmt.PositionAP = (xlsCellsForChosenFiles{iii,14});
tempSaveStructProbAmt.PositionML = (xlsCellsForChosenFiles{iii,15});
catch
   tempSaveStructProbAmt.Depth = NaN ;
tempSaveStructProbAmt.UnitId = NaN;
tempSaveStructProbAmt.PDSfilename='NotSpecified';
tempSaveStructProbAmt.AOfilename= 'NotSpecified';
tempSaveStructProbAmt.excelLine = NaN; 
tempSaveStructProbAmt.PositionAP = NaN;
tempSaveStructProbAmt.PositionML = NaN;
end




%% No longer used data from all SDFs and rasters
% 
% MasterDataStruct.Rasters =  logical(Rasterscs );
% MasterDataStruct.LogicalRastersfree  =  logical(Rastersfree) ;
% MasterDataStruct.SDFcs=SDFcs;
% MasterDataStruct.SDFfree=SDFfree;
% MasterDataStruct.trials100 = trials100 ;
% MasterDataStruct.trials50  = trials50  ;
% MasterDataStruct.trials0  = trials0  ;
% MasterDataStruct.trials100s  = trials100s  ;
% MasterDataStruct.trials50d  = trials50d  ;
% MasterDataStruct.trials50nd  =trials50nd   ;
% MasterDataStruct.choice100versus50  = choice100versus50  ;
% MasterDataStruct.choice100versus0  =choice100versus0   ;
% MasterDataStruct.choice100versus100s  =  choice100versus100s ;
% MasterDataStruct.choice50versus100s  =   choice50versus100s;
% MasterDataStruct.choice50versus0  =  choice50versus0 ;
% MasterDataStruct.choice100sversus0  = choice100sversus0  ;
% MasterDataStruct.PDSfilename= FilesToRun{iii};
% MasterDataStruct.AOfilename= AlphaOmegaFilesToRun{iii}

