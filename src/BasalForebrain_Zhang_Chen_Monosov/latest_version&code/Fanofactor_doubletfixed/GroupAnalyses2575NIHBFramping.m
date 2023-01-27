clear all; close all; clc; beep off;
addpath('X:\Kaining\HELPER_GENERAL');
addpath('X:\MONKEYDATA\NIHBFrampingdata2575\MRDR\');
[ndata, text, alldata]=xlsread('septumprobamt.xls');
celldata=xlsread('septumprobamt.xls');
Sess_id=(find((celldata(:,7))==2));
SPIKES=celldata(Sess_id,1);
FILENAM=alldata(Sess_id,2);
MONKEYID=celldata(Sess_id,3);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%MANUAL SETINGS
PlotYm=150; %PLOT YLIM for spike density functions
analysiswindow=[13500-1000:13500];  %outcome at 13500.
xzv=1;
gauswindow_ms=100; %for making a spike density function (fits each spike with a 100ms gaus)
%kruskalpvalueforfunningtests=0.05;
%pvalueLimitContplot=0.025;
BinForStat=101;
NumberofPermutations=100;
CorTh=0.01;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for zzzz=1:length(SPIKES)
	spka=(SPIKES(zzzz));
    TESTFILE=(cell2mat(FILENAM(zzzz)));
    if MONKEYID(zzzz)==1
        TESTFILE=['han' TESTFILE]
        MONKEYID_='han'
    elseif MONKEYID(zzzz)==2
        TESTFILE=['peek' TESTFILE]
        MONKEYID_='peek'
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    cd X:\MONKEYDATA\NIHBFrampingdata2575\MRDR\
    d=mrdr('-a', '-d', TESTFILE);
    cd ..
    %cd 'X:\Kaining\NewestVersionofBFpaper\kaining\Simplified Timing\ProbAMt2575_15'
    d=d(2:length(d));
    d=d(1:length(d)-1);
    
    cd 'C:\Users\Ilya Monosov\Dropbox\Ilya&kaining\Fanofactor_doubletfixed'
    loopCounter=zzzz
    Timing2575GroupNIHBFramping;
    xzv = zzzz;
 
    %ProbAmtDataStruct(zzzz) = savestruct(1) %if youw ant to add

    %clear savestruct
    close all


end
ProbAmtDataStruct = savestruct;
save DATA15.mat ProbAmtDataStruct; 
clear all; close all;
