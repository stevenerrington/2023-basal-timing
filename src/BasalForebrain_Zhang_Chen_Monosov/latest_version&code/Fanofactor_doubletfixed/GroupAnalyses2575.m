clear all; close all; clc; beep off;
addpath('X:\Kaining\HELPER_GENERAL');

%%%%%%%%Use excelsheet to load neuron

[~,~,neuronsheet] = xlsread('X:\Kaining\BF_neuron_sheet');
excel_celltype = find(strcmp(neuronsheet(1,:),'Cell Type'));
excel_Area = find(strcmp(neuronsheet(1,:),'Area'));
excel_monkeyid = find(strcmp(neuronsheet(1,:),'Monkey'));
excel_ProbAmt = find(strcmp(neuronsheet(1,:),'ProbAmt2575'));
excel_ProbAmtdir = find(strcmp(neuronsheet(1,:),'ProbAmt2575dir'));
excel_TimingP = find(strcmp(neuronsheet(1,:),'Timingprocedure'));
excel_TimingPdir = find(strcmp(neuronsheet(1,:),'Timingproceduredir'));

DDD = [];
errorDDD = [];
for i = 2 : size(neuronsheet,1)
    if strcmp(neuronsheet{i,excel_Area},'BF') && (strcmp(neuronsheet{i,excel_celltype},'Phasic') || strcmp(neuronsheet{i,excel_celltype},'Ramping'))... %|| strcmp(neuronsheet{i,excel_celltype},'Negphasic'))...
            && length(neuronsheet{i,excel_ProbAmt})>1 %&& length(neuronsheet{i,excel_TimingP})>1
        tp.name = [neuronsheet{i,excel_ProbAmt},'.mat'];
        tp.folder = neuronsheet{i,excel_ProbAmtdir};
        tp.celltype = neuronsheet{i,excel_celltype};
        if strcmpi(neuronsheet{i,excel_celltype},'Negphasic')
            tp.MONKEYID = [neuronsheet{i,excel_monkeyid},'_'];
        else
            tp.MONKEYID = neuronsheet{i,excel_monkeyid};
        end
        
        addpath(tp.folder);
        if exist(tp.name)
            DDD = [DDD,tp];
        else
            errorDDD = [errorDDD,tp];
        end
        clear tp;
    end
end


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
save DATA25_V2.mat ProbAmtDataStruct;% clear all; 
