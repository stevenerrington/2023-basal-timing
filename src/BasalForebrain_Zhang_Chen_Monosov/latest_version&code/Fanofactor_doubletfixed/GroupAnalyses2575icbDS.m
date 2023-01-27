clear all; close all; clc; beep off;
addpath('X:\Kaining\HELPER_GENERAL');


addpath('X:\MONKEYDATA\Batman\ProbAmt7525_icbDS\');
DDD=dir ('X:\MONKEYDATA\Batman\ProbAmt7525_icbDS\*.mat');
for x=1:size(DDD,1)
    DDD(x).MONKEYID='batman'
end
%
addpath('X:\MONKEYDATA\Robin_ongoing\2575_icbds\');
DDD1=dir ('X:\MONKEYDATA\Robin_ongoing\2575_icbds\*.mat');
for x=1:size(DDD1,1)
    DDD1(x).MONKEYID='robin'
end
%

addpath('X:\MONKEYDATA\ZOMBIE_ongoing\icbDS\ProbAmt7525\Uncertainty Excited\');
DDD2=dir ('X:\MONKEYDATA\ZOMBIE_ongoing\icbDS\ProbAmt7525\Uncertainty Excited\\*.mat');
for x=1:size(DDD2,1)
    DDD2(x).MONKEYID='zombie'
end




DDD=[DDD; DDD1; DDD2;];


%%%%%%%%%%%MANUAL SETINGS
PlotYm=150; %PLOT YLIM for spike density functions
xzv=1;
gauswindow_ms=100; %for making a spike density function (fits each spike with a 100ms gaus)
BinForStat=101;
NumberofPermutations=100;
CorTh=0.01;

errorfile=cell(0);
xxx=0;
for iii=1:length(DDD)
    xzv = iii;
    clear PDS c s;
    clc; close all;
    loopCounter=iii
    
    if exist(DDD(iii).name)
        
        load(DDD(iii).name,'PDS');
        Timing2575Group;
        
        %xxx=xxx+1;
        %ProbAmtDataStruct(xxx) = savestruct(1); %if you want to add
        
        %clear savestruct
        close all
        
    else
        errorfile{end+1,1}=DDD(iii).name;
    end

end
ProbAmtDataStruct = savestruct;
save DATA25_V2icbds.mat ProbAmtDataStruct;% 
clear all; 
GroupAnalyses2575;
clear all;
GroupAnalyses2575BFramping;
disp('done. yay')






