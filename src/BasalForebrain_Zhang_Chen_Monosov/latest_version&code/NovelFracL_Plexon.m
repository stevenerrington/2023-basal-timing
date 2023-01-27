clear all; %close all
addpath('HELPER_GENERAL');
% nex = actxserver('NeuroExplorer.Application');
% doc = nex.OpenDocument('Y:\PLEXON_GRAYARRAY_LEMMY\NovelFractalLearning\LemmyKim-02052018-001-01.pl2');
% %doc = nex.OpenDocument('C:\Kaining_local\NovelfractalLearning\Plexonfile\LemmyKim-01232018-006.pl2');
% Strobes = doc.Variable('Strobed');
% Spikes = cell(0);
% spikingtime = cell(0);
% channelnum = doc.neuroncount;%102 channels

%load from the matlab.
% PDSfile = 'Y:\MONKEYDATA\Lemmy\NovelFractalLearning\NovelFracLearning_05_02_2018_10_11';
% load([PDSfile '.mat'],'PDS');
% PDS2.image = PDS.image;
% PDS2.trialnumber = PDS.trialnumber;
% clear PDS;

Filename = 'Y:\PLEXON_GRAYARRAY_LEMMY\NovelFractalLearning\matlab\LemmyKim-02232018_NovFrac';
load([Filename '.mat'])

%find all the LFP channels
clear LFPvariables
vars = who('-regexp', 'FP');
outStr = regexpi(vars, '_ind');
ind = cellfun('isempty',outStr);
vars=vars(ind);
outStr = regexpi(vars, '_ts');
ind = cellfun('isempty',outStr);
LFPvariables=vars(ind);




%find SPIKES
clear SPKchannels
SPKchannels = who('-regexp', 'SPK');
outStr = regexpi(SPKchannels, 'i');
ind = cellfun('isempty',outStr);
SPKchannels=SPKchannels(ind);
outStr = regexpi(SPKchannels, 'wf');
ind = cellfun('isempty',outStr);
SPKchannels=SPKchannels(ind);



%find the eye, licking, pupil
clear AIvariables 
clear AI04 %empty junk
vars = who('-regexp', 'AI');
outStr = regexpi(vars, '_ind');
ind = cellfun('isempty',outStr);
vars=vars(ind);
outStr = regexpi(vars, '_ts');
ind = cellfun('isempty',outStr);
AIvariables=vars(ind);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Cut the recording by trials %%%%%%%%%

% for i=1:channelnum  
% Spikes{i} = doc.Neuron(i);
% spikingtime{i} = Spikes{i}.Timestamps;
% end
% Event = cell(0);
% Event{1} = doc.Event(1).Timestamps;%RSTART
% Event{2} = doc.Event(2).Timestamps;%RSTOP


% StrobedMark = str2num(cell2mat(Strobes.MarkerValues));
% Strobedtime = Strobes.Timestamps';
% Strobed = [Strobedtime, StrobedMark];


unique_strobe = unique(Strobed(:,2));
StrobedMark = Strobed(:,2);
Strobedtime = Strobed(:,1);

startstrobnum = find(StrobedMark == 1001); 
endstrobnum = find(StrobedMark == 1010 | StrobedMark == 1011);


%%%%% aligned the start and end strobemark
trialsuptime = 15; % the supreme time a trial can last 

temp_start = startstrobnum;
temp_end = endstrobnum;
clear startstrobnum endstrobnum
startstrobnum = [];
endstrobnum = [];
for i = 1: length(temp_start)
    trialstart = temp_start(i);
    trialend = temp_end(find(temp_end>trialstart,1));
    if ~isempty(trialend) && (temp_start(find(temp_start<trialend,1,'last')) == trialstart) && ...
            Strobedtime(trialend)-Strobedtime(trialstart)<=trialsuptime
        startstrobnum(end+1,1) = trialstart;
        endstrobnum(end+1,1) = trialend;
    end
end

clear trialstart trialend temp_start temp_end

% if Strobedtime(startstrobnum(1)) >= Strobedtime(endstrobnum(1))
%     endstrobnum = endstrobnum(2:end);
% end
% if Strobedtime(startstrobnum(end)) >= Strobedtime(endstrobnum(end))
%     startstrobnum = startstrobnum(1:end-1);
% end

%startstrobnum = startstrobnum([1:233,235:end],:);

assert(length(startstrobnum) == length(endstrobnum), 'trial start and trial end mismatch');

%%%conbine the Plexon and the original PDS together
% assert(size(PDS2.trialnumber,2) == length(startstrobnum), 'Plexon and PDS mismatch');
% clear PDS;
% PDS = rmfield(PDS2,'trialnumber');
PDS.Filename = Filename;
PDS.trialstart = Strobed(startstrobnum,:);
PDS.trialend = Strobed(endstrobnum,:);
PDS.successtrial = (PDS.trialend(:,2) == 1010);
PDS.successtrstart = PDS.trialstart(find(PDS.trialend(:,2) == 1010),1);


%PDS.sptimes = cell(0);

PDS.channelname = SPKchannels;
PDS.AIname = AIvariables;
PDS.LFPname = LFPvariables;

% cut each trial out find the strobe and save in the struct
for iii = 1: size(PDS.trialstart,1)

    %%%%%%%%%%%% Behavior data
    trialstrobed = Strobed(startstrobnum(iii): endstrobnum(iii),:);
    trialstrobed(:,1) = trialstrobed(:,1)-trialstrobed(1,1); % align the time to trialstart
    
    PDS.trialtype(iii,1) = trialstrobed(ismember(trialstrobed(:,2), [10000:10006]),2);
    %get trial number
    try
        PDS.trialnumber(iii,1) = trialstrobed(ismember(trialstrobed(:,2), [12000:12999]),2)-12000;
    catch
        PDS.trialnumber(iii,1) = iii;
    end
    
    %fractal:
    temp = trialstrobed(ismember(trialstrobed(:,2), [6300:6999, 7300:7999]),:);
    temp(end+1:3,:) = NaN;
    PDS.timetargeton(iii,:) = temp(:,1)';
    PDS.Set(iii,:) = temp(:,2)';
    
    
    temp = trialstrobed(trialstrobed(:,2) == 4003,:);
    temp(end+1:3,:) = NaN;
    PDS.timetargetoff(iii,:) = temp(:,1)';
    
    temp = trialstrobed(ismember(trialstrobed(:,2), [3001,11000:11360]),:);
    temp(end+1:3,:) = NaN;
    PDS.timefpon(iii,:) = temp(:,1)';
    
    temp = trialstrobed(trialstrobed(:,2) == 3003,:);
    temp(end+1:3,:) = NaN;
    PDS.timefpoff(iii,:) = temp(:,1)';
    
    temp = trialstrobed(trialstrobed(:,2) == 8000,2);
    if isempty(temp)
        temp = [NaN NaN];
    end
    PDS.rewardeliver(iii) = temp(1);
    
    temp = trialstrobed(ismember(trialstrobed, 10000:10006));
    if isempty(temp)
        temp = NaN;
    end
    PDS.trialtype(iii) = temp-10000;
    
    temp = trialstrobed(ismember(trialstrobed, [11000:11360]));
    if isempty(temp)
        temp = NaN;
    end
    PDS.rewfixangle(iii) = temp-11000;
    
    temp = trialstrobed(trialstrobed(:,2) == 2008,:);
    temp(end+1:3,:) = NaN;
    PDS.fixacq(iii,:) = temp(:,1)';
    
    temp = trialstrobed(ismember(trialstrobed, 10100:10103));
    if isempty(temp)
        temp = NaN; %There is no believe error in previous data
    end
    PDS.b_error_place(iii) = temp-10100;
    
    %%%%%%%%%% Neuronal data %%%%%%%
%     for i=1:channelnum
%         PDS.sptimes{i,iii} = spikingtime{i}(spikingtime{i}>PDS.trialstart(iii,1) & spikingtime{i}<PDS.trialend(iii,1));
%     end
    tic
    for i = 1: length(SPKchannels)
        temp = eval(SPKchannels{i});
        PDS.sptimes{i,iii} = temp(temp>PDS.trialstart(iii,1) & temp<PDS.trialend(iii,1));
    end
    clear temp
    
    for i = 1: length(AIvariables)
        temp = eval(AIvariables{i});
        PDS.AIvariables{i,iii} = temp(temp(:,2)>PDS.trialstart(iii,1) & temp(:,2)<PDS.trialend(iii,1),:);
    end
    clear temp
    
    for i = 1: length(LFPvariables)
        temp = eval(LFPvariables{i});
        PDS.LFPvariables{i,iii} = temp(temp(:,2)>PDS.trialstart(iii,1) & temp(:,2)<PDS.trialend(iii,1),:);
    end
    clear temp
    
    
    %%%%%%%% Fractal-center alignment
    for xxx = 1:3
        PDS.Fractals(1,3*(iii-1)+xxx) = PDS.Set(iii,xxx); % Fractal ID
        PDS.Fractals(2,3*(iii-1)+xxx) = PDS.trialtype(iii); %Type of trial the fractal is in
        PDS.Fractals(3,3*(iii-1)+xxx) = xxx; % Fractal sequence within the trial.
        PDS.Fractals(4,3*(iii-1)+xxx) = PDS.timetargeton(iii,xxx)+ PDS.trialstart(iii,1);; % Fractal start time
        PDS.Fractals(5,3*(iii-1)+xxx) = PDS.timetargetoff(iii,xxx) + + PDS.trialstart(iii,1); %Fractal end time
        
        d_t = 0.2;
        for i = 1: length(SPKchannels)
            temp = PDS.sptimes{i,iii};
            PDS.fracsptimes{i,3*(iii-1)+xxx} = temp(temp>PDS.Fractals(4,3*(iii-1)+xxx)-d_t & temp<PDS.Fractals(5,3*(iii-1)+xxx)+d_t);
        end
        clear temp
        
        for i = 1: length(AIvariables)
            temp = PDS.AIvariables{i,iii};
            PDS.fracAIvariables{i,3*(iii-1)+xxx} = temp(temp(:,2)>PDS.Fractals(4,3*(iii-1)+xxx)-d_t & temp(:,2)<PDS.Fractals(5,3*(iii-1)+xxx)+d_t);
        end
        clear temp
        
        for i = 1: length(LFPvariables)
            temp = PDS.LFPvariables{i,iii};
            PDS.fracLFPvariables{i,3*(iii-1)+xxx} = temp(temp(:,2)>PDS.Fractals(4,3*(iii-1)+xxx)-d_t & temp(:,2)<PDS.Fractals(5,3*(iii-1)+xxx)+d_t);
        end
        clear temp
        
        
    end
    t = toc
    
    %%%%%%%%%% Event data %%%%%%%%%%%
    % 1 RSTART, 2 RSTOP
%     for i = 1:2
%     PDS.Event{i,iii} = spikingtime{i}(Event{i}>PDS.trialstart(iii,1) & Event{i}<PDS.trialend(iii,1));
%     end
end
clear temp;


save([Filename '_PDS.mat'],'PDS','-v7.3');

% ITI = PDS.trialstart(2:end,1) - PDS.trialend(1:end-1,1);
% figure;
% plot(ITI);




