%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%initialize workspace
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all; close all; clc;
addpath('Z:\Charlie\FIGURES\TIMING_W_BF\');
addpath('Z:\Charlie\FIGURES\TIMING_B_BF\');
addpath('Z:\Charlie\FIGURES\TIMING_R_BF\');
addpath('Z:\Charlie\FIGURES\TIMING_W_BG\');
addpath('Z:\Charlie\FIGURES\TIMING_B_BG\');
addpath('Z:\Charlie\FIGURES\TIMING_R_BG\');
addpath('HELPER_GENERAL');

addpath('Z:\Charlie\FIGURES\BEHAVIOR_W\');
addpath('Z:\Charlie\FIGURES\BEHAVIOR_B\');
addpath('Z:\Charlie\FIGURES\BEHAVIOR_R\');

%D='Z:\Charlie\FIGURES\BEHAVIOR_B\';
%F=dir ('Z:\Charlie\FIGURES\BEHAVIOR_B\*.mat');

%D=dir ('Z:\Charlie\FIGURES\TIMING_W_BF\*.mat');
%D1=dir ('Z:\Charlie\FIGURES\TIMING_B_BF\*.mat');
%D2=dir ('Z:\Charlie\FIGURES\TIMING_R_BF\*.mat');
%D3=dir ('Z:\Charlie\FIGURES\TIMING_W_BG\*.mat');
%D4=dir ('Z:\Charlie\FIGURES\TIMING_B_BG\*.mat');
%D5=dir ('Z:\Charlie\FIGURES\TIMING_R_BG\*.mat');
%D=[D; D1; D2;D3;D4;D5]; clear D1 D2 D3 D4 D5

D=dir ('Z:\Charlie\FIGURES\BEHAVIOR_W\*.mat');
D1=dir ('Z:\Charlie\FIGURES\BEHAVIOR_B\*.mat');
D2=dir ('Z:\Charlie\FIGURES\BEHAVIOR_R\*.mat');
D=[D;D1;D2]; clear D1 D2 

CENTER=5001;
guaswind=50;
LW=2;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%initialize population variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
LickingTargArray6101_25s_population=[];
collectpupils6101_25s_dil_population=[];
LickingTargArray6101_75l_population=[];
collectpupils6101_75l_dil_population=[];

LickingTargArray6102_50s_population=[];
collectpupils6102_50s_dil_population=[];
LickingTargArray6102_50l_population=[];
collectpupils6102_50l_dil_population=[];

LickingTargArray6103_75s_population=[];
collectpupils6103_75s_dil_population=[];
LickingTargArray6103_25l_population=[];
collectpupils6103_25l_dil_population=[];

LickingTargArray6104_100s_population=[];
collectpupils6104_100s_dil_population=[];

%%%
LickingTargArray6105_25s_population=[];
collectpupils6105_25s_dil_population=[];

LickingTargArray6105_25ms_population=[];
collectpupils6105_25ms_dil_population=[];

LickingTargArray6105_25ml_population=[];
collectpupils6105_25ml_dil_population=[];

LickingTargArray6105_25l_population=[];
collectpupils6105_25l_dil_population=[];
%%%

LickingTargArray6201_d_population=[];
collectpupils6201_d_dil_population=[];
LickingTargArray6201_nd_population=[];
collectpupils6201_nd_dil_population=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%loop over sessions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%for ii=1:length(F)
%load([D F(ii).name])
y=1;
for xzv=1:length(D)
    load(D(xzv).name,'PDS')
    Behavior_6101
    Behavior_6102
    Behavior_6103
    Behavior_6104
    Behavior_6105
    Behavior_6201
    %Behavior_figures


LickingTargArray6104=plot_mean_psth({[LickingTargArray6104_100s]},guaswind,1,(CENTER*2)-2,1);

if max(nanmean(LickingTargArray6104(:,[2000:3500])./1000)) > 0.1
okayBehavior(y).filename=D(xzv).name
    
LickingTargArray6101_25s_population=[LickingTargArray6101_25s_population; LickingTargArray6101_25s];
collectpupils6101_25s_dil_population=[collectpupils6101_25s_dil_population; collectpupils6101_25s_dil];
LickingTargArray6101_75l_population=[LickingTargArray6101_75l_population; LickingTargArray6101_75l];
collectpupils6101_75l_dil_population=[collectpupils6101_75l_dil_population; collectpupils6101_75l_dil];
    
LickingTargArray6102_50s_population=[LickingTargArray6102_50s_population; LickingTargArray6102_50s];
collectpupils6102_50s_dil_population=[collectpupils6102_50s_dil_population; collectpupils6102_50s_dil];
LickingTargArray6102_50l_population=[LickingTargArray6102_50l_population; LickingTargArray6102_50l];
collectpupils6102_50l_dil_population=[collectpupils6102_50l_dil_population; collectpupils6102_50l_dil];
    
LickingTargArray6103_75s_population=[LickingTargArray6103_75s_population; LickingTargArray6103_75s];
collectpupils6103_75s_dil_population=[collectpupils6103_75s_dil_population; collectpupils6103_75s_dil];
LickingTargArray6103_25l_population=[LickingTargArray6103_25l_population; LickingTargArray6103_25l];
collectpupils6103_25l_dil_population=[collectpupils6103_25l_dil_population; collectpupils6103_25l_dil];
    
LickingTargArray6104_100s_population=[LickingTargArray6104_100s_population; LickingTargArray6104_100s];
collectpupils6104_100s_dil_population=[collectpupils6104_100s_dil_population; collectpupils6104_100s_dil];

%%%
LickingTargArray6105_25s_population=[LickingTargArray6105_25s_population;LickingTargArray6105_25s];
collectpupils6105_25s_dil_population=[collectpupils6105_25s_dil_population;collectpupils6105_25s_dil];

LickingTargArray6105_25ms_population=[LickingTargArray6105_25ms_population;LickingTargArray6105_25ms];
collectpupils6105_25ms_dil_population=[collectpupils6105_25ms_dil_population;collectpupils6105_25ms_dil];

LickingTargArray6105_25ml_population=[LickingTargArray6105_25ml_population;LickingTargArray6105_25ml];
collectpupils6105_25ml_dil_population=[collectpupils6105_25ml_dil_population;collectpupils6105_25ml_dil];

LickingTargArray6105_25l_population=[LickingTargArray6105_25l_population;LickingTargArray6105_25l];
collectpupils6105_25l_dil_population=[collectpupils6105_25l_dil_population;collectpupils6105_25l_dil];
%%%

LickingTargArray6201_d_population=[LickingTargArray6201_d_population;LickingTargArray6201_d];
collectpupils6201_d_dil_population=[collectpupils6201_nd_dil_population;collectpupils6201_d_dil];
LickingTargArray6201_nd_population=[LickingTargArray6201_d_population;LickingTargArray6201_nd];
collectpupils6201_nd_dil_population=[collectpupils6201_nd_dil_population;collectpupils6201_nd_dil];

y=y+1
end

end
