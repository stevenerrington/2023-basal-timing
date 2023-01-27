clear all; close all; clc; beep off;
addpath('HELPER_GENERAL');


%
%
addpath('X:\MONKEYDATA\Batman\2575_Basilforebrain\phasic\');
DDD=dir ('X:\MONKEYDATA\Batman\2575_Basilforebrain\phasic\*.mat');
for x=1:size(DDD,1)
    DDD(x).MONKEYID='batman'
end
%
addpath('X:\MONKEYDATA\Robin_ongoing\2575_BF\phasic\');
DDD1=dir ('X:\MONKEYDATA\Robin_ongoing\2575_BF\phasic\*.mat');
for x=1:size(DDD1,1)
    DDD1(x).MONKEYID='robin'
end
%

addpath('X:\MONKEYDATA\ZOMBIE_ongoing\BF_ProbAmt2575\Phasic\');
DDD2=dir ('X:\MONKEYDATA\ZOMBIE_ongoing\BF_ProbAmt2575\Phasic\*.mat');
for x=1:size(DDD2,1)
    DDD2(x).MONKEYID='zombie'
end

%
addpath('X:\MONKEYDATA\ZOMBIE_ongoing\BF_ProbAmt2575\Ramping\');
DDD3=dir ('X:\MONKEYDATA\ZOMBIE_ongoing\BF_ProbAmt2575\Ramping\*.mat');
for x=1:size(DDD3,1)
    DDD3(x).MONKEYID='zombie'
end

%
addpath('X:\MONKEYDATA\ZOMBIE_ongoing\BF_ProbAmt2575\Negative Phasic\');
DDD4=dir ('X:\MONKEYDATA\ZOMBIE_ongoing\BF_ProbAmt2575\Negative Phasic\*.mat');
for x=1:size(DDD4,1)
    DDD4(x).MONKEYID='zombie_'
end

%
addpath('X:\MONKEYDATA\Batman\2575_Basilforebrain\tonic\');
DDD5=dir ('X:\MONKEYDATA\Batman\2575_Basilforebrain\tonic\*.mat');
for x=1:size(DDD5,1)
    DDD5(x).MONKEYID='batman'
end
%
addpath('X:\MONKEYDATA\Batman\2575_Basilforebrain\phasicnegvalue\');
DDD6=dir ('X:\MONKEYDATA\Batman\2575_Basilforebrain\phasicnegvalue\*.mat');
for x=1:size(DDD6,1)
    DDD6(x).MONKEYID='batman_'
end
%
addpath('X:\MONKEYDATA\Robin_ongoing\2575_BF\tonic\');
DDD7=dir ('X:\MONKEYDATA\Robin_ongoing\2575_BF\tonic\*.mat');
for x=1:size(DDD7,1)
    DDD7(x).MONKEYID='robin'
end

%
addpath('X:\MONKEYDATA\Robin_ongoing\2575_BF\phasicNegative\');
DDD8=dir ('X:\MONKEYDATA\Robin_ongoing\2575_BF\phasicNegative\*.mat');
for x=1:size(DDD8,1)
    DDD8(x).MONKEYID='robin_'
end
%
DDD=[DDD; DDD1; DDD2; DDD3; DDD4; DDD5; DDD6; DDD7; DDD8];


%%%%%%%%%%%MANUAL SETINGS
PlotYm=150; %PLOT YLIM for spike density functions
xzv=1;
gauswindow_ms=50; %for making a spike density function (fits each spike with a 100ms gaus)
BinForStat=101;
NumberofPermutations=100;
CorTh=0.01;

for iii=1:length(DDD)
	clear PDS c s;
    clc; close all;
    loopCounter=iii
    
    load(DDD(iii).name,'PDS')

    Timing2575Group;
    
 
    ProbAmtDataStruct(iii) = savestruct(1) %if youw ant to add

    clear savestruct
    close all

    
end

save DATA25.mat ProbAmtDataStruct; clear all; 
