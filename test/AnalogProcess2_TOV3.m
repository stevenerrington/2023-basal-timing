% function [savestruct]= AnalogProcess2(PDS, s)

[bb,aa]=butter(8,10/500,'low');
    windowwidth=3;
 
       plexonconv=0; 
    try
    PDS.onlineEye;
 
    catch
       plexonconv=1; 
    end
    
    
if plexonconv == 0
    
    millisecondResolution=0.001;
    Pupil=[];
    Xeye=[];
    Yeye=[];
    for x=1:length(PDS.fractals)
        trialanalog=PDS.onlineEye{x};
        %
        temp=trialanalog(:,3:4);
%         relatveTimePDS = temp(:,2)-temp(1,2);
%         regularTimeVectorForPdsInterval = [0: millisecondResolution  : temp(end,2)-temp(1,2)];
%         regularPdsData = interp1(  relatveTimePDS , temp(:,1) , regularTimeVectorForPdsInterval  );
          %Takaya Added
        relatveTimePDS = temp(:,2)-PDS.trialstarttime(x);
        regularTimeVectorForPdsInterval = [0: millisecondResolution  : relatveTimePDS(end)];
        regularPdsData = interp1(  relatveTimePDS , temp(:,1) , regularTimeVectorForPdsInterval  );
        regularPdsData(length(regularPdsData)+1:12000)=NaN; %i do this because they may be different sizes
        
        %remove blinks (very crude) %
        regularPdsData(1:40)=NaN;
        findblinks=find(regularPdsData<-9.9); %%% VOLTAGE THRESHOLD; SOME -4.9 some -9.9 depending on eyelink voltage output settings
        
        %get rid of blinks out of pupil dillation
        if ~isempty(findblinks)==1
            for zz=1:length(findblinks)
                regularPdsData(fix(findblinks(zz))-20:fix(findblinks(zz))+40)=NaN;
            end
        end
        %
        Pupil=[Pupil; regularPdsData(1:12000)];
        clear regularPdsData regularTimeVectorForPdsInterval temp temp1 relatveTimePDS
        
        temp=trialanalog(:,[1 4]);
%         relatveTimePDS = temp(:,2)-temp(1,2);
%         regularTimeVectorForPdsInterval = [0: millisecondResolution  : temp(end,2)-temp(1,2)];
%         regularPdsData = interp1(  relatveTimePDS , temp(:,1) , regularTimeVectorForPdsInterval  );
        %Takaya Added
        relatveTimePDS = temp(:,2)-PDS.trialstarttime(x);
        regularTimeVectorForPdsInterval = [0: millisecondResolution  : relatveTimePDS(end)];
        regularPdsData = interp1(  relatveTimePDS , temp(:,1) , regularTimeVectorForPdsInterval  );
        regularPdsData(length(regularPdsData)+1:12000)=NaN;
        Xeye=[Xeye; regularPdsData(1:12000)];
        clear regularPdsData regularTimeVectorForPdsInterval temp relatveTimePDS
        %
        temp=trialanalog(:,[2 4]);
%         relatveTimePDS = temp(:,2)-temp(1,2);
%         regularTimeVectorForPdsInterval = [0: millisecondResolution  : temp(end,2)-temp(1,2)];
%         regularPdsData = interp1(  relatveTimePDS , temp(:,1) , regularTimeVectorForPdsInterval  );
        %Takaya Added
        relatveTimePDS = temp(:,2)-PDS.trialstarttime(x);
        regularTimeVectorForPdsInterval = [0: millisecondResolution  : relatveTimePDS(end)];
        regularPdsData = interp1(  relatveTimePDS , temp(:,1) , regularTimeVectorForPdsInterval  );
        regularPdsData(length(regularPdsData)+1:12000)=NaN;
        Yeye=[Yeye; regularPdsData(1:12000)];
        clear regularPdsData regularTimeVectorForPdsInterval temp relatveTimePDS
        %
        %
    end
    
    
    
    
    clear t

    LookingTargArray=[];
    LookingTargArrayFromGo = [];
    for x=1:length(PDS.fractals)
        tempx=Xeye(x,:);
        tempy=Yeye(x,:);
        angs=PDS.targAngle(x);
   amp=10;
        amp              = round(amp-0.5); %we do this in the code in tasks, do it here too
        location               = amp*[cosd(360-angs(1)), sind(360-angs(1))];
        
        timelook=find(tempx>location(1)-windowwidth & tempx<location(1)+windowwidth & tempy>location(2)-windowwidth & tempy<location(2)+windowwidth);
        
        temp(1:length(tempx))=0;
        temp(timelook)=1;
        try
            temp=temp(fix(PDS.timetargeton(x)*1000):fix(PDS.timetargeton(x)*1000)+3500); % change 3000 to 3300 % change 3300 to 3500
        catch
            clear temp;
            temp(1:3501)=NaN;
        end
        LookingTargArray=[LookingTargArray; temp];
        
        clear temp
        temp(1:length(tempx))=0;
        temp(timelook)=1;
        try
            temp=temp(fix(PDS.timefpoff(x)*1000):fix(PDS.timefpoff(x)*1000)+3000); 
        catch
            clear temp;
            temp(1:3001)=NaN;
        end
        LookingTargArrayFromGo = [LookingTargArrayFromGo; temp];
        
        clear temp timelook angs tempy tempx x
    end
    
    RT=[];
    TargetGazeRate=[];
    TargetGazeRate_last2000=[];
    TargetGazeRate_last1000=[];
    TargetGazeRate_last1500=[];
    TargetGazeSeqBefoRew = [];
    TEMP=LookingTargArray;
    TEMP(isnan(TEMP)==1)=0;
    for TESTl=1:size(TEMP,1)
        T=TEMP(TESTl,:);
%         T=T(mean(T')~=0,:);
%         [~,idx] = max(T,[],2);
%         RT_=idx(idx>50);

%Takaya Added
        x_output= findseq(T);
        RT_=x_output(min(find(x_output(:,1)==1 & x_output(:,4)>100)),2);
        if isempty(RT_)==1
            RT_=NaN;
        end
        RT=[RT; RT_];
        tempRT = RT_;
        clear RT_
        
        % Target gaze rate from Go cue to reward onset
%         TEMP1 = fix((PDS.timefpoff(TESTl) - PDS.timetargeton(TESTl))*1000);
%         TEMP2 = fix((PDS.timeoutcome(TESTl) - PDS.timetargeton(TESTl))*1000);
%         if ~isnan(TEMP1) && ~isnan(TEMP2)
%         TargetGazeDur = sum(T(TEMP1+2:TEMP2+1));
%         TargetGazeRate = [TargetGazeRate; TargetGazeDur/(TEMP2 - TEMP1)];
%         clear TEMP1 TEMP2 TargetGazeDur
%         else
%             TargetGazeRate = [TargetGazeRate; NaN];
%         end
      % Revision
        TEMP2 = fix((PDS.timeoutcome(TESTl) - PDS.timetargeton(TESTl))*1000);
        TEMP1 = TEMP2 - 1500;
        if TEMP1>0 && ~isnan(TEMP2)
        TargetGazeDur = sum(T(TEMP1+1:TEMP2+1));
        TargetGazeRate = [TargetGazeRate; TargetGazeDur/(TEMP2 - TEMP1+1)];
        clear TEMP1 TEMP2 TargetGazeDur
        else
            TargetGazeRate = [TargetGazeRate; NaN];
        end

        % save last 2500ms 0 1 sequence to later gaze rate analysis
        clear TEMP1 TEMP2
        TEMP2 = fix((PDS.timeoutcome(TESTl) - PDS.timetargeton(TESTl))*1000);
        TEMP1 = TEMP2 - 2500;
        if TEMP1>0 && ~isnan(TEMP2)
        TargetGazeSeqBefoRew = [TargetGazeSeqBefoRew; T(TEMP1+1:TEMP2+1)];
        clear TEMP1 TEMP2
        else
        TargetGazeSeqBefoRew = [TargetGazeSeqBefoRew; NaN(1, 2501)];
        end
        
        
        
        %%% Filtering out gaze rate with longer RT than threshold
        tempTT= PDS.timefpoff(TESTl)-PDS.timetargeton(TESTl);
        if tempTT < 0
            tempTT = 0;
        end
        if isnan(tempTT)
            tempTT = 0;
        end
        if PDS.fixreq(TESTl) == 2
            tempTT = 0;
        end
        
        tempRT = tempRT - tempTT*1000;
        
        if PDS.fixreq(TESTl) == 2
            tempRT = NaN;
        end
         clear tempTT
        % last 2000ms
        clear TEMP1 TEMP2 TEMP3 TargetGazeDur
        TEMP2 = fix((PDS.timeoutcome(TESTl) - PDS.timetargeton(TESTl))*1000);
        THR = 2000;
        TEMP1 = TEMP2 - THR;
        TEMP3 = (PDS.timefpoff(TESTl) - PDS.timetargeton(TESTl))*1000;
        THR_GR = TEMP2 - TEMP3 - THR;
        if TEMP1>0 && ~isnan(TEMP2) && tempRT < THR_GR
        TargetGazeDur = sum(T(TEMP1+1:TEMP2+1));
        TargetGazeRate_last2000 = [TargetGazeRate_last2000; TargetGazeDur/(TEMP2 - TEMP1+1)];
        clear TEMP1 TargetGazeDur
        else
            TargetGazeRate_last2000 = [TargetGazeRate_last2000; NaN];
        end
        % last 1000
        clear TEMP1 TargetGazeDur
        THR = 1000;
        TEMP1 = TEMP2 - THR;
        THR_GR = TEMP2 - TEMP3 - THR;
        if TEMP1>0 && ~isnan(TEMP2)  && tempRT < THR_GR
        TargetGazeDur = sum(T(TEMP1+1:TEMP2+1));
        TargetGazeRate_last1000 = [TargetGazeRate_last1000; TargetGazeDur/(TEMP2 - TEMP1+1)];
        clear TEMP1 TargetGazeDur
        else
            TargetGazeRate_last1000 = [TargetGazeRate_last1000; NaN];
        end
        
        %last 1500
         clear TEMP1 TargetGazeDur
        THR = 1500;
        TEMP1 = TEMP2 - THR;
        THR_GR = TEMP2 - TEMP3 - THR;
        if TEMP1>0 && ~isnan(TEMP2)  && tempRT < THR_GR
        TargetGazeDur = sum(T(TEMP1+1:TEMP2+1));
        TargetGazeRate_last1500 = [TargetGazeRate_last1500; TargetGazeDur/(TEMP2 - TEMP1+1)];
        clear TEMP1 TargetGazeDur
        else
            TargetGazeRate_last1500 = [TargetGazeRate_last1500; NaN];
        end
        
        
    end
    clear TEMP TEMPl
    R=(PDS.timefpoff-PDS.timetargeton);
    R(R<0)=0;
    R(isnan(R))=0;
    R(PDS.fixreq==2)=0;
    RT=(RT./1000) - R';
    RT(PDS.fixreq==2)=NaN;
    
    %REVISION
    % Filter out gaze rate with RT longer than threshold
    
    
    
    
else  %this is for PLEXON CONVERTED FILES
    
    
    millisecondResolution=0.001;
    Pupil=[];
    Xeye=[];
    Yeye=[];
    Lick=[];
    Blnksdetect=[];
    Lickbase=[];
    for x=1:length(PDS.fractals)
        
        targon_=fix(PDS.timetargeton(x)*1000);
        targrange=[targon_' : targon_'+3500]; %change 3250 to 3300 % change 3300 to 3500
        
        if ~isnan(targrange)
        badtrialfiller(1:length(targrange))=NaN;
        else
            badtrialfiller(1:3501)=NaN; %change 3250 to 3300
        end
        
        
        Xeye_ = PDS.AIvariables{1,x};
        Yeye_ = PDS.AIvariables{2,x};
        %Pupil_ = smooth(PDS.AIvariables{3,x},20);
        Pupil_ = PDS.AIvariables{3,x};
        Pupil_(:,1)=filtfilt(bb,aa,Pupil_(:,1));
        
        Lick_ = PDS.AIvariables{4,x};
        Lick_(:,1)=filtfilt(bb,aa,Lick_(:,1));
        
        %temp1(1:length(Pupil_(:,1)))=0;
        %temp1(find(Pupil_(:,1)<-30000))=1;                  %ARBITRARY NUMBER BASED ON EYE LINK SETTINGS
        %Blnksdetect=[Blnksdetect; temp1(targrange)]; clear temp1
        
        try
            Xeye=[Xeye; Xeye_(targrange,1)'];
            Yeye=[Yeye; Yeye_(targrange,1)'];
            Pupil=[Pupil; Pupil_(targrange,1)'];
            Lick=[Lick; Lick_(targrange,1)'];
        catch
            Xeye=[Xeye; badtrialfiller];
            Yeye=[Yeye; badtrialfiller];
            Pupil=[Pupil; badtrialfiller];
            Lick=[Lick; badtrialfiller];
            
        end
        
        try
            lickbaserange=[targon_'-1000 : targon_'];
            Lickbase=[Lickbase; Lick_(lickbaserange,1)'];
        end
        
        %figure; plot(Pupil_);
        %close all;
        clear Xeye_ Yeye_ Pupil_ Lick_
        
    end
    
    
    
    LookingTargArray=[];
    LookingTargArrayFromGo = [];
    for x=1:length(PDS.fractals)
        try
            clear tempx tempy temp xx c
            tempx=Xeye(x,:)./1000;
            tempy=Yeye(x,:)./1000;
            
            c.viewdist                      = 410;      % viewing distance (mm)
            c.screenhpix                    = 1080;     % screen height (pixels)
            c.screenh                       = 293.22;
            
            V=tempx;
            for xx=1:length(tempx)
                EyeX(xx)    = sign(V(xx))*deg2pix(8*abs(V(xx)),c);
            end
            
            V=tempy;
            for xx=1:length(tempy)
                EyeY(xx)    = sign(V(xx))*deg2pix(8*abs(V(xx)),c);
            end
            
            %tempx=EyeX;
            %tempy=EyeY;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            angs=PDS.targAngle(x);
               amp=10;
            amp              = round(amp-0.5); %we do this in the code in tasks, do it here too
            location               = amp*[cosd(360-angs(1)), sind(360-angs(1))];
            
            timelook=find(tempx>location(1)-windowwidth & tempx<location(1)+windowwidth & tempy>location(2)-windowwidth & tempy<location(2)+windowwidth);
            
            temp(1:length(tempx))=0;
            temp(timelook)=1;
            
            
            LookingTargArray=[LookingTargArray; temp];
            
            %%% looking array from fix off
            fixholddur = fix(PDS.timefpoff(x)*1000) - fix(PDS.timetargeton(x)*1000);
            if ~isnan(fixholddur)
                LookingTargArrayFromGo = [LookingTargArrayFromGo; temp(fixholddur+1:fixholddur+3001)];
            else
                LookingTargArrayFromGo = [LookingTargArrayFromGo; NaN(1, 3001)];
            end
    
        catch
            
            temp(1:3001)=NaN;
            LookingTargArray=[LookingTargArray; temp(1:3001)];
            %
            LookingTargArrayFromGo = [LookingTargArrayFromGo; NaN(1, 3001)];
        end
        

        
        
        clear temp timelook angs tempy tempx x V tempx tempy
        
    end
    
    
    RT=[];
    TargetGazeRate=[];
    TargetGazeRate_last2000=[];
    TargetGazeRate_last1000=[];
    TargetGazeRate_last1500=[];
    TargetGazeSeqBefoRew =[];
    TEMP=LookingTargArray;
    TEMP(isnan(TEMP)==1)=0;
    for TESTl=1:size(TEMP,1)
        T=TEMP(TESTl,:);
%         T=T(mean(T')~=0,:);
%         [idx,idx] = max(T,[],2);
%         RT_=idx(find(idx>50));

        %Takaya Added
        x_output= findseq(T);
        RT_=x_output(min(find(x_output(:,1)==1 & x_output(:,4)>100)),2);
        if isempty(RT_)==1
            RT_=NaN;
        end
        RT=[RT; RT_];
        tempRT = RT_;
        clear RT_
        
        % Target gaze rate from GO cue to reward onset
%         TEMP1 = fix((PDS.timefpoff(TESTl) - PDS.timetargeton(TESTl))*1000);
%         TEMP2 = fix((PDS.timeoutcome(TESTl) - PDS.timetargeton(TESTl))*1000);
%         if ~isnan(TEMP1) && ~isnan(TEMP2)
%         TargetGazeDur = sum(T(TEMP1+2:TEMP2+1));
%         TargetGazeRate = [TargetGazeRate; TargetGazeDur/(TEMP2 - TEMP1)];
%         clear TEMP1 TEMP2 TargetGazeDur
%         else
%             TargetGazeRate = [TargetGazeRate; NaN];
%         end
        % revised version (Last 1500 ms before outcome)
        
        TEMP2 = fix((PDS.timeoutcome(TESTl) - PDS.timetargeton(TESTl))*1000);
        TEMP1 = TEMP2 - 1500;
        if TEMP1>0 && ~isnan(TEMP2)
        TargetGazeDur = sum(T(TEMP1+1:TEMP2+1));
        TargetGazeRate = [TargetGazeRate; TargetGazeDur/(TEMP2 - TEMP1+1)];
        clear TEMP1 TEMP2 TargetGazeDur
        else
            TargetGazeRate = [TargetGazeRate; NaN];
        end
        
        % save last 2500ms 0 1 sequence to later gaze rate analysis
        clear TEMP1 TEMP2
        TEMP2 = fix((PDS.timeoutcome(TESTl) - PDS.timetargeton(TESTl))*1000);
        TEMP1 = TEMP2 - 2500;
        if TEMP1>0 && ~isnan(TEMP2)
        TargetGazeSeqBefoRew = [TargetGazeSeqBefoRew; T(TEMP1+1:TEMP2+1)];
        clear TEMP1 TEMP2
        else
        TargetGazeSeqBefoRew = [TargetGazeSeqBefoRew; NaN(1, 2501)];
        end
        
        %%% Filtering out gaze rate with longer RT than threshold
        tempTT= PDS.timefpoff(TESTl)-PDS.timetargeton(TESTl);
        if tempTT < 0
            tempTT = 0;
        end
        if isnan(tempTT)
            tempTT = 0;
        end
        
        tempRT = tempRT - tempTT*1000;
        clear tempTT
        % last 2000ms
        clear TEMP1 TEMP2 TEMP3 TargetGazeDur
        TEMP2 = fix((PDS.timeoutcome(TESTl) - PDS.timetargeton(TESTl))*1000);
        THR = 2000;
        TEMP1 = TEMP2 - THR;
        TEMP3 = (PDS.timefpoff(TESTl) - PDS.timetargeton(TESTl))*1000;
        THR_GR = TEMP2 - TEMP3 - THR;
        if TEMP1>0 && ~isnan(TEMP2) && tempRT < THR_GR
        TargetGazeDur = sum(T(TEMP1+1:TEMP2+1));
        TargetGazeRate_last2000 = [TargetGazeRate_last2000; TargetGazeDur/(TEMP2 - TEMP1+1)];
        clear TEMP1 TargetGazeDur
        else
            TargetGazeRate_last2000 = [TargetGazeRate_last2000; NaN];
        end
        % last 1000
        clear TEMP1 TargetGazeDur
        THR = 1000;
        TEMP1 = TEMP2 - THR;
        THR_GR = TEMP2 - TEMP3 - THR;
        if TEMP1>0 && ~isnan(TEMP2)  && tempRT < THR_GR
        TargetGazeDur = sum(T(TEMP1+1:TEMP2+1));
        TargetGazeRate_last1000 = [TargetGazeRate_last1000; TargetGazeDur/(TEMP2 - TEMP1+1)];
        clear TEMP1 TargetGazeDur
        else
            TargetGazeRate_last1000 = [TargetGazeRate_last1000; NaN];
        end
        
        %last 1500
         clear TEMP1 TargetGazeDur
        THR = 1500;
        TEMP1 = TEMP2 - THR;
        THR_GR = TEMP2 - TEMP3 - THR;
        if TEMP1>0 && ~isnan(TEMP2)  && tempRT < THR_GR
        TargetGazeDur = sum(T(TEMP1+1:TEMP2+1));
        TargetGazeRate_last1500 = [TargetGazeRate_last1500; TargetGazeDur/(TEMP2 - TEMP1+1)];
        clear TEMP1 TargetGazeDur
        else
            TargetGazeRate_last1500 = [TargetGazeRate_last1500; NaN];
        end
        
        
    end
    clear TEMP TEMPl
    R=(PDS.timefpoff-PDS.timetargeton);
    R(R<0)=0;
    R(isnan(R)==1)=0;
    RT=(RT./1000) - R';


    
    
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Takaya added 1010/07/25
goodtrial = find(PDS.goodtrial);
typetrial = cell(6, 3);
typetrial{1,1} = intersect(goodtrial , find(PDS.TrialTypeSave == 6101)); % trialtype(1) = novel
typetrial{2,1} = intersect(goodtrial , find(PDS.TrialTypeSave == 6102)); % familiar
typetrial{3,1} = intersect(goodtrial , find(PDS.TrialTypeSave == 6103)); % familiar - novel
typetrial{4,1} = intersect(goodtrial , find(PDS.TrialTypeSave == 6104)); % familiar - familiar
typetrial{5,1} = intersect(goodtrial , find(PDS.TrialTypeSave == 6111)); % learning
typetrial{6,1} = intersect(goodtrial , find(PDS.TrialTypeSave == 6112)); % familiar

% left or rignt?
typetrial{1,2} = intersect(typetrial{1,1},find(PDS.targAngle == 180)); % left
typetrial{2,2} = intersect(typetrial{2,1},find(PDS.targAngle == 180));
typetrial{3,2} = intersect(typetrial{3,1},find(PDS.targAngle == 180));
typetrial{4,2} = intersect(typetrial{4,1},find(PDS.targAngle == 180));
typetrial{5,2} = intersect(typetrial{5,1},find(PDS.targAngle == 180));
typetrial{6,2} = intersect(typetrial{6,1},find(PDS.targAngle == 180));

typetrial{1,3} = intersect(typetrial{1,1},find(PDS.targAngle == 0)); % right
typetrial{2,3} = intersect(typetrial{2,1},find(PDS.targAngle == 0));
typetrial{3,3} = intersect(typetrial{3,1},find(PDS.targAngle == 0));
typetrial{4,3} = intersect(typetrial{4,1},find(PDS.targAngle == 0));
typetrial{5,3} = intersect(typetrial{5,1},find(PDS.targAngle == 0));
typetrial{6,3} = intersect(typetrial{6,1},find(PDS.targAngle == 0));

RT_1L = RT(typetrial{1,2});
RT_2L = RT(typetrial{2,2});
RT_3L = RT(typetrial{3,2});
RT_4L = RT(typetrial{4,2});
RT_5L = RT(typetrial{5,2});
RT_6L = RT(typetrial{6,2});

RT_1R = RT(typetrial{1,3});
RT_2R = RT(typetrial{2,3});
RT_3R = RT(typetrial{3,3});
RT_4R = RT(typetrial{4,3});
RT_5R = RT(typetrial{5,3});
RT_6R = RT(typetrial{6,3});

% comment out this for matching # of RTs and single trial firing rates
% RT_1L = RT_1L(~isnan(RT_1L));
% RT_2L = RT_2L(~isnan(RT_2L));
% RT_3L = RT_3L(~isnan(RT_3L));
% RT_4L = RT_4L(~isnan(RT_4L));
% RT_1R = RT_1R(~isnan(RT_1R));
% RT_2R = RT_2R(~isnan(RT_2R));
% RT_3R = RT_3R(~isnan(RT_3R));
% RT_4R = RT_4R(~isnan(RT_4R));

LookingTargArray_1L = LookingTargArray(typetrial{1,2}, :);
LookingTargArray_2L = LookingTargArray(typetrial{2,2}, :);
LookingTargArray_3L = LookingTargArray(typetrial{3,2}, :);
LookingTargArray_4L = LookingTargArray(typetrial{4,2}, :);
LookingTargArray_5L = LookingTargArray(typetrial{5,2}, :);
LookingTargArray_6L = LookingTargArray(typetrial{6,2}, :);

LookingTargArray_1R = LookingTargArray(typetrial{1,3}, :);
LookingTargArray_2R = LookingTargArray(typetrial{2,3}, :);
LookingTargArray_3R = LookingTargArray(typetrial{3,3}, :);
LookingTargArray_4R = LookingTargArray(typetrial{4,3}, :);
LookingTargArray_5R = LookingTargArray(typetrial{5,3}, :);
LookingTargArray_6R = LookingTargArray(typetrial{6,3}, :);

% comment out this for matching # of RTs and single trial firing rates
% LookingTargArray_1L = LookingTargArray_1L(~isnan(RT_1L), :);
% LookingTargArray_2L = LookingTargArray_2L(~isnan(RT_2L), :);
% LookingTargArray_3L = LookingTargArray_3L(~isnan(RT_3L), :);
% LookingTargArray_4L = LookingTargArray_4L(~isnan(RT_4L), :);
% LookingTargArray_1R = LookingTargArray_1R(~isnan(RT_1R), :);
% LookingTargArray_2R = LookingTargArray_2R(~isnan(RT_2R), :);
% LookingTargArray_3R = LookingTargArray_3R(~isnan(RT_3R), :);
% LookingTargArray_4R = LookingTargArray_4R(~isnan(RT_4R), :);

LookingTargArrayFromGo_1L = LookingTargArrayFromGo(typetrial{1,2}, :);
LookingTargArrayFromGo_2L = LookingTargArrayFromGo(typetrial{2,2}, :);
LookingTargArrayFromGo_3L = LookingTargArrayFromGo(typetrial{3,2}, :);
LookingTargArrayFromGo_4L = LookingTargArrayFromGo(typetrial{4,2}, :);
LookingTargArrayFromGo_5L = LookingTargArrayFromGo(typetrial{5,2}, :);
LookingTargArrayFromGo_6L = LookingTargArrayFromGo(typetrial{6,2}, :);

LookingTargArrayFromGo_1R = LookingTargArrayFromGo(typetrial{1,3}, :);
LookingTargArrayFromGo_2R = LookingTargArrayFromGo(typetrial{2,3}, :);
LookingTargArrayFromGo_3R = LookingTargArrayFromGo(typetrial{3,3}, :);
LookingTargArrayFromGo_4R = LookingTargArrayFromGo(typetrial{4,3}, :);
LookingTargArrayFromGo_5R = LookingTargArrayFromGo(typetrial{5,3}, :);
LookingTargArrayFromGo_6R = LookingTargArrayFromGo(typetrial{6,3}, :);

TargetGazeRate_1L = TargetGazeRate(typetrial{1,2});
TargetGazeRate_2L = TargetGazeRate(typetrial{2,2});
TargetGazeRate_3L = TargetGazeRate(typetrial{3,2});
TargetGazeRate_4L = TargetGazeRate(typetrial{4,2});
TargetGazeRate_5L = TargetGazeRate(typetrial{5,2});
TargetGazeRate_6L = TargetGazeRate(typetrial{6,2});

TargetGazeRate_1R = TargetGazeRate(typetrial{1,3});
TargetGazeRate_2R = TargetGazeRate(typetrial{2,3});
TargetGazeRate_3R = TargetGazeRate(typetrial{3,3});
TargetGazeRate_4R = TargetGazeRate(typetrial{4,3});
TargetGazeRate_5R = TargetGazeRate(typetrial{5,3});
TargetGazeRate_6R = TargetGazeRate(typetrial{6,3});

% REVISION
TargetGazeSeqBefoRew_1L = TargetGazeSeqBefoRew(typetrial{1,2}, :);
TargetGazeSeqBefoRew_2L = TargetGazeSeqBefoRew(typetrial{2,2}, :);
TargetGazeSeqBefoRew_3L = TargetGazeSeqBefoRew(typetrial{3,2}, :);
TargetGazeSeqBefoRew_4L = TargetGazeSeqBefoRew(typetrial{4,2}, :);
TargetGazeSeqBefoRew_5L = TargetGazeSeqBefoRew(typetrial{5,2}, :);
TargetGazeSeqBefoRew_6L = TargetGazeSeqBefoRew(typetrial{6,2}, :);

TargetGazeSeqBefoRew_1R = TargetGazeSeqBefoRew(typetrial{1,3}, :);
TargetGazeSeqBefoRew_2R = TargetGazeSeqBefoRew(typetrial{2,3}, :);
TargetGazeSeqBefoRew_3R = TargetGazeSeqBefoRew(typetrial{3,3}, :);
TargetGazeSeqBefoRew_4R = TargetGazeSeqBefoRew(typetrial{4,3}, :);
TargetGazeSeqBefoRew_5R = TargetGazeSeqBefoRew(typetrial{5,3}, :);
TargetGazeSeqBefoRew_6R = TargetGazeSeqBefoRew(typetrial{6,3}, :);

TargetGazeRate_last2000_1L = TargetGazeRate_last2000(typetrial{1,2});
TargetGazeRate_last2000_2L = TargetGazeRate_last2000(typetrial{2,2});
TargetGazeRate_last2000_3L = TargetGazeRate_last2000(typetrial{3,2});
TargetGazeRate_last2000_4L = TargetGazeRate_last2000(typetrial{4,2});
TargetGazeRate_last2000_5L = TargetGazeRate_last2000(typetrial{5,2});
TargetGazeRate_last2000_6L = TargetGazeRate_last2000(typetrial{6,2});

TargetGazeRate_last2000_1R = TargetGazeRate_last2000(typetrial{1,3});
TargetGazeRate_last2000_2R = TargetGazeRate_last2000(typetrial{2,3});
TargetGazeRate_last2000_3R = TargetGazeRate_last2000(typetrial{3,3});
TargetGazeRate_last2000_4R = TargetGazeRate_last2000(typetrial{4,3});
TargetGazeRate_last2000_5R = TargetGazeRate_last2000(typetrial{5,3});
TargetGazeRate_last2000_6R = TargetGazeRate_last2000(typetrial{6,3});

TargetGazeRate_last1000_1L = TargetGazeRate_last1000(typetrial{1,2});
TargetGazeRate_last1000_2L = TargetGazeRate_last1000(typetrial{2,2});
TargetGazeRate_last1000_3L = TargetGazeRate_last1000(typetrial{3,2});
TargetGazeRate_last1000_4L = TargetGazeRate_last1000(typetrial{4,2});
TargetGazeRate_last1000_5L = TargetGazeRate_last1000(typetrial{5,2});
TargetGazeRate_last1000_6L = TargetGazeRate_last1000(typetrial{6,2});

TargetGazeRate_last1000_1R = TargetGazeRate_last1000(typetrial{1,3});
TargetGazeRate_last1000_2R = TargetGazeRate_last1000(typetrial{2,3});
TargetGazeRate_last1000_3R = TargetGazeRate_last1000(typetrial{3,3});
TargetGazeRate_last1000_4R = TargetGazeRate_last1000(typetrial{4,3});
TargetGazeRate_last1000_5R = TargetGazeRate_last1000(typetrial{5,3});
TargetGazeRate_last1000_6R = TargetGazeRate_last1000(typetrial{6,3});

TargetGazeRate_last1500_1L = TargetGazeRate_last1500(typetrial{1,2});
TargetGazeRate_last1500_2L = TargetGazeRate_last1500(typetrial{2,2});
TargetGazeRate_last1500_3L = TargetGazeRate_last1500(typetrial{3,2});
TargetGazeRate_last1500_4L = TargetGazeRate_last1500(typetrial{4,2});
TargetGazeRate_last1500_5L = TargetGazeRate_last1500(typetrial{5,2});
TargetGazeRate_last1500_6L = TargetGazeRate_last1500(typetrial{6,2});

TargetGazeRate_last1500_1R = TargetGazeRate_last1500(typetrial{1,3});
TargetGazeRate_last1500_2R = TargetGazeRate_last1500(typetrial{2,3});
TargetGazeRate_last1500_3R = TargetGazeRate_last1500(typetrial{3,3});
TargetGazeRate_last1500_4R = TargetGazeRate_last1500(typetrial{4,3});
TargetGazeRate_last1500_5R = TargetGazeRate_last1500(typetrial{5,3});
TargetGazeRate_last1500_6R = TargetGazeRate_last1500(typetrial{6,3});

if contains(s.RecHemisphere{s.MonkeyID{DATA_N}(x_file)}, 'Right')
    d1 = 'L';
    d2 = 'R';
    d1_ = 2;
    d2_ = 3;
else
    d1 = 'R';
    d2 = 'L';
    d1_ = 3;
    d2_ = 2;
end


%% add these conditions for adjusting recording hemisphere in vprobe recording
if contains(specificfilename, '_cl') % if its vprobe data
if contains(PDS.recinfo.Subj, 'zo')
    
    % determine Rec hemisphere according to MRI and lab book
    % zombie All LHb cells were in left LHb
    if PDS.recinfo.Ant == -5 || PDS.recinfo.Ant == -6
        RecHemisphere = 'Left';
    else
        RecHemisphere = 'Right';
    end
    
elseif contains(PDS.recinfo.Subj, 'ro')
    
    % P12 M4 is Right LHb, M6 is Left LHb, others are Right hemi
    if PDS.recinfo.Ant == -12 && PDS.recinfo.Lat == -6
        RecHemisphere = 'Left';
    else
        RecHemisphere = 'Right';
    end
end

        if contains(RecHemisphere, 'Right')
            d1 = 'L';
            d2 = 'R';
        else
            d1 = 'R';
            d2 = 'L';
        end

end
%%

% fix break error rate

temp_er = PDS.goodtrial == 0;
% left
temp1L = PDS.TrialTypeSave == 6101 & PDS.targAngle == 180;
ErrorRate_1L = sum(temp_er & temp1L)/sum(temp1L);

temp2L = PDS.TrialTypeSave == 6102 & PDS.targAngle == 180;
ErrorRate_2L = sum(temp_er & temp2L)/sum(temp2L);

temp3L = PDS.TrialTypeSave == 6103 & PDS.targAngle == 180;
ErrorRate_3L = sum(temp_er & temp3L)/sum(temp3L);

temp4L = PDS.TrialTypeSave == 6104 & PDS.targAngle == 180;
ErrorRate_4L = sum(temp_er & temp4L)/sum(temp4L);


% right
temp1R = PDS.TrialTypeSave == 6101 & PDS.targAngle == 0;
ErrorRate_1R = sum(temp_er & temp1R)/sum(temp1R);

temp2R = PDS.TrialTypeSave == 6102 & PDS.targAngle == 0;
ErrorRate_2R = sum(temp_er & temp2R)/sum(temp2R);

temp3R = PDS.TrialTypeSave == 6103 & PDS.targAngle == 0;
ErrorRate_3R = sum(temp_er & temp3R)/sum(temp3R);

temp4R = PDS.TrialTypeSave == 6104 & PDS.targAngle == 0;
ErrorRate_4R = sum(temp_er & temp4R)/sum(temp4R);

% if ~isempty(find(isnan([ErrorRate_1L ErrorRate_2L ErrorRate_3L ErrorRate_4L ErrorRate_1R ErrorRate_2R ErrorRate_3R ErrorRate_4R])))
%     
%     gnindnf
% end


savestruct.Analogdata(s.iii).rtRAW6101_Contra = eval(['RT_1', d1]);
savestruct.Analogdata(s.iii).rtRAW6102_Contra = eval(['RT_2', d1]);
savestruct.Analogdata(s.iii).rtRAW6103_Contra = eval(['RT_3', d1]);
savestruct.Analogdata(s.iii).rtRAW6104_Contra = eval(['RT_4', d1]);
savestruct.Analogdata(s.iii).rtRAW6111_Contra = eval(['RT_5', d1]);
savestruct.Analogdata(s.iii).rtRAW6112_Contra = eval(['RT_6', d1]);

savestruct.Analogdata(s.iii).rtRAW6101_Ipsi = eval(['RT_1', d2]);
savestruct.Analogdata(s.iii).rtRAW6102_Ipsi = eval(['RT_2', d2]);
savestruct.Analogdata(s.iii).rtRAW6103_Ipsi = eval(['RT_3', d2]);
savestruct.Analogdata(s.iii).rtRAW6104_Ipsi = eval(['RT_4', d2]);
savestruct.Analogdata(s.iii).rtRAW6111_Ipsi = eval(['RT_5', d2]);
savestruct.Analogdata(s.iii).rtRAW6112_Ipsi = eval(['RT_6', d2]);

%         NumNeedRemoval = [];
%         NumNeedRemoval = find(contains(STATEDATA{:,'FILENAME'}, EXLDATA{x_file, 'FILENAME'}{:}));
% 
% if isempty(NumNeedRemoval) && ~isequal(savestruct.Recording(end).typetrial , typetrial)
%     dfdfsfs
% end
% 
% if isempty(NumNeedRemoval) && numel(savestruct.Recording(end).typetrial{1,d1_}) == numel(savestruct.Analogdata(s.iii).rtRAW6101_Contra) && numel(savestruct.Recording(end).typetrial{2,d2_}) == numel(savestruct.Analogdata(s.iii).rtRAW6102_Ipsi)
% else
%     
%     dfkjlkj
% end

savestruct.Analogdata(s.iii).GazeTimecourse6101_Contra = eval(['LookingTargArray_1', d1]);
savestruct.Analogdata(s.iii).GazeTimecourse6102_Contra = eval(['LookingTargArray_2', d1]);
savestruct.Analogdata(s.iii).GazeTimecourse6103_Contra = eval(['LookingTargArray_3', d1]);
savestruct.Analogdata(s.iii).GazeTimecourse6104_Contra = eval(['LookingTargArray_4', d1]);
savestruct.Analogdata(s.iii).GazeTimecourse6111_Contra = eval(['LookingTargArray_5', d1]);
savestruct.Analogdata(s.iii).GazeTimecourse6112_Contra = eval(['LookingTargArray_6', d1]);

savestruct.Analogdata(s.iii).GazeTimecourse6101_Ipsi = eval(['LookingTargArray_1', d2]);
savestruct.Analogdata(s.iii).GazeTimecourse6102_Ipsi = eval(['LookingTargArray_2', d2]);
savestruct.Analogdata(s.iii).GazeTimecourse6103_Ipsi = eval(['LookingTargArray_3', d2]);
savestruct.Analogdata(s.iii).GazeTimecourse6104_Ipsi = eval(['LookingTargArray_4', d2]);
savestruct.Analogdata(s.iii).GazeTimecourse6111_Ipsi = eval(['LookingTargArray_5', d2]);
savestruct.Analogdata(s.iii).GazeTimecourse6112_Ipsi = eval(['LookingTargArray_6', d2]);

savestruct.Analogdata(s.iii).GazeTimecourse6101FromGo_Contra = eval(['LookingTargArrayFromGo_1', d1]);
savestruct.Analogdata(s.iii).GazeTimecourse6102FromGo_Contra = eval(['LookingTargArrayFromGo_2', d1]);
savestruct.Analogdata(s.iii).GazeTimecourse6103FromGo_Contra = eval(['LookingTargArrayFromGo_3', d1]);
savestruct.Analogdata(s.iii).GazeTimecourse6104FromGo_Contra = eval(['LookingTargArrayFromGo_4', d1]);
savestruct.Analogdata(s.iii).GazeTimecourse6111FromGo_Contra = eval(['LookingTargArrayFromGo_5', d1]);
savestruct.Analogdata(s.iii).GazeTimecourse6112FromGo_Contra = eval(['LookingTargArrayFromGo_6', d1]);

savestruct.Analogdata(s.iii).GazeTimecourse6101FromGo_Ipsi = eval(['LookingTargArrayFromGo_1', d2]);
savestruct.Analogdata(s.iii).GazeTimecourse6102FromGo_Ipsi = eval(['LookingTargArrayFromGo_2', d2]);
savestruct.Analogdata(s.iii).GazeTimecourse6103FromGo_Ipsi = eval(['LookingTargArrayFromGo_3', d2]);
savestruct.Analogdata(s.iii).GazeTimecourse6104FromGo_Ipsi = eval(['LookingTargArrayFromGo_4', d2]);
savestruct.Analogdata(s.iii).GazeTimecourse6111FromGo_Ipsi = eval(['LookingTargArrayFromGo_5', d2]);
savestruct.Analogdata(s.iii).GazeTimecourse6112FromGo_Ipsi = eval(['LookingTargArrayFromGo_6', d2]);

savestruct.Analogdata(s.iii).TargetGazeRate6101_Contra = eval(['TargetGazeRate_1', d1]);
savestruct.Analogdata(s.iii).TargetGazeRate6102_Contra = eval(['TargetGazeRate_2', d1]);
savestruct.Analogdata(s.iii).TargetGazeRate6103_Contra = eval(['TargetGazeRate_3', d1]);
savestruct.Analogdata(s.iii).TargetGazeRate6104_Contra = eval(['TargetGazeRate_4', d1]);
savestruct.Analogdata(s.iii).TargetGazeRate6111_Contra = eval(['TargetGazeRate_5', d1]);
savestruct.Analogdata(s.iii).TargetGazeRate6112_Contra = eval(['TargetGazeRate_6', d1]);

savestruct.Analogdata(s.iii).TargetGazeRate6101_Ipsi = eval(['TargetGazeRate_1', d2]);
savestruct.Analogdata(s.iii).TargetGazeRate6102_Ipsi = eval(['TargetGazeRate_2', d2]);
savestruct.Analogdata(s.iii).TargetGazeRate6103_Ipsi = eval(['TargetGazeRate_3', d2]);
savestruct.Analogdata(s.iii).TargetGazeRate6104_Ipsi = eval(['TargetGazeRate_4', d2]);
savestruct.Analogdata(s.iii).TargetGazeRate6111_Ipsi = eval(['TargetGazeRate_5', d2]);
savestruct.Analogdata(s.iii).TargetGazeRate6112_Ipsi = eval(['TargetGazeRate_6', d2]);

savestruct.Analogdata(s.iii).typetrial = typetrial;
savestruct.Analogdata(s.iii).RecHemisphere = s.RecHemisphere{s.MonkeyID{DATA_N}(x_file)};
savestruct.Analogdata(s.iii).SessionNumber = s.iii ;

savestruct.Analogdata(s.iii).FixbreakErrorRate6101_Contra = eval(['ErrorRate_1', d1]);
savestruct.Analogdata(s.iii).FixbreakErrorRate6102_Contra = eval(['ErrorRate_2', d1]);
savestruct.Analogdata(s.iii).FixbreakErrorRate6103_Contra = eval(['ErrorRate_3', d1]);
savestruct.Analogdata(s.iii).FixbreakErrorRate6104_Contra = eval(['ErrorRate_4', d1]);

savestruct.Analogdata(s.iii).FixbreakErrorRate6101_Ipsi = eval(['ErrorRate_1', d2]);
savestruct.Analogdata(s.iii).FixbreakErrorRate6102_Ipsi = eval(['ErrorRate_2', d2]);
savestruct.Analogdata(s.iii).FixbreakErrorRate6103_Ipsi = eval(['ErrorRate_3', d2]);
savestruct.Analogdata(s.iii).FixbreakErrorRate6104_Ipsi = eval(['ErrorRate_4', d2]);


savestruct.Analogdata(s.iii).TargetGazeSeqBefoRew6101_Contra = eval(['TargetGazeSeqBefoRew_1', d1]);
savestruct.Analogdata(s.iii).TargetGazeSeqBefoRew6102_Contra = eval(['TargetGazeSeqBefoRew_2', d1]);
savestruct.Analogdata(s.iii).TargetGazeSeqBefoRew6103_Contra = eval(['TargetGazeSeqBefoRew_3', d1]);
savestruct.Analogdata(s.iii).TargetGazeSeqBefoRew6104_Contra = eval(['TargetGazeSeqBefoRew_4', d1]);
savestruct.Analogdata(s.iii).TargetGazeSeqBefoRew6111_Contra = eval(['TargetGazeSeqBefoRew_5', d1]);
savestruct.Analogdata(s.iii).TargetGazeSeqBefoRew6112_Contra = eval(['TargetGazeSeqBefoRew_6', d1]);

savestruct.Analogdata(s.iii).TargetGazeSeqBefoRew6101_Ipsi = eval(['TargetGazeSeqBefoRew_1', d2]);
savestruct.Analogdata(s.iii).TargetGazeSeqBefoRew6102_Ipsi = eval(['TargetGazeSeqBefoRew_2', d2]);
savestruct.Analogdata(s.iii).TargetGazeSeqBefoRew6103_Ipsi = eval(['TargetGazeSeqBefoRew_3', d2]);
savestruct.Analogdata(s.iii).TargetGazeSeqBefoRew6104_Ipsi = eval(['TargetGazeSeqBefoRew_4', d2]);
savestruct.Analogdata(s.iii).TargetGazeSeqBefoRew6111_Ipsi = eval(['TargetGazeSeqBefoRew_5', d2]);
savestruct.Analogdata(s.iii).TargetGazeSeqBefoRew6112_Ipsi = eval(['TargetGazeSeqBefoRew_6', d2]);

savestruct.Analogdata(s.iii).TargetGazeRate6101_last2000_Contra = eval(['TargetGazeRate_last2000_1', d1]);
savestruct.Analogdata(s.iii).TargetGazeRate6102_last2000_Contra = eval(['TargetGazeRate_last2000_2', d1]);
savestruct.Analogdata(s.iii).TargetGazeRate6103_last2000_Contra = eval(['TargetGazeRate_last2000_3', d1]);
savestruct.Analogdata(s.iii).TargetGazeRate6104_last2000_Contra = eval(['TargetGazeRate_last2000_4', d1]);
savestruct.Analogdata(s.iii).TargetGazeRate6111_last2000_Contra = eval(['TargetGazeRate_last2000_5', d1]);
savestruct.Analogdata(s.iii).TargetGazeRate6112_last2000_Contra = eval(['TargetGazeRate_last2000_6', d1]);

savestruct.Analogdata(s.iii).TargetGazeRate6101_last2000_Ipsi = eval(['TargetGazeRate_last2000_1', d2]);
savestruct.Analogdata(s.iii).TargetGazeRate6102_last2000_Ipsi = eval(['TargetGazeRate_last2000_2', d2]);
savestruct.Analogdata(s.iii).TargetGazeRate6103_last2000_Ipsi = eval(['TargetGazeRate_last2000_3', d2]);
savestruct.Analogdata(s.iii).TargetGazeRate6104_last2000_Ipsi = eval(['TargetGazeRate_last2000_4', d2]);
savestruct.Analogdata(s.iii).TargetGazeRate6111_last2000_Ipsi = eval(['TargetGazeRate_last2000_5', d2]);
savestruct.Analogdata(s.iii).TargetGazeRate6112_last2000_Ipsi = eval(['TargetGazeRate_last2000_6', d2]);

savestruct.Analogdata(s.iii).TargetGazeRate6101_last1000_Contra = eval(['TargetGazeRate_last1000_1', d1]);
savestruct.Analogdata(s.iii).TargetGazeRate6102_last1000_Contra = eval(['TargetGazeRate_last1000_2', d1]);
savestruct.Analogdata(s.iii).TargetGazeRate6103_last1000_Contra = eval(['TargetGazeRate_last1000_3', d1]);
savestruct.Analogdata(s.iii).TargetGazeRate6104_last1000_Contra = eval(['TargetGazeRate_last1000_4', d1]);
savestruct.Analogdata(s.iii).TargetGazeRate6111_last1000_Contra = eval(['TargetGazeRate_last1000_5', d1]);
savestruct.Analogdata(s.iii).TargetGazeRate6112_last1000_Contra = eval(['TargetGazeRate_last1000_6', d1]);

savestruct.Analogdata(s.iii).TargetGazeRate6101_last1000_Ipsi = eval(['TargetGazeRate_last1000_1', d2]);
savestruct.Analogdata(s.iii).TargetGazeRate6102_last1000_Ipsi = eval(['TargetGazeRate_last1000_2', d2]);
savestruct.Analogdata(s.iii).TargetGazeRate6103_last1000_Ipsi = eval(['TargetGazeRate_last1000_3', d2]);
savestruct.Analogdata(s.iii).TargetGazeRate6104_last1000_Ipsi = eval(['TargetGazeRate_last1000_4', d2]);
savestruct.Analogdata(s.iii).TargetGazeRate6111_last1000_Ipsi = eval(['TargetGazeRate_last1000_5', d2]);
savestruct.Analogdata(s.iii).TargetGazeRate6112_last1000_Ipsi = eval(['TargetGazeRate_last1000_6', d2]);

savestruct.Analogdata(s.iii).TargetGazeRate6101_last1500_Contra = eval(['TargetGazeRate_last1500_1', d1]);
savestruct.Analogdata(s.iii).TargetGazeRate6102_last1500_Contra = eval(['TargetGazeRate_last1500_2', d1]);
savestruct.Analogdata(s.iii).TargetGazeRate6103_last1500_Contra = eval(['TargetGazeRate_last1500_3', d1]);
savestruct.Analogdata(s.iii).TargetGazeRate6104_last1500_Contra = eval(['TargetGazeRate_last1500_4', d1]);
savestruct.Analogdata(s.iii).TargetGazeRate6111_last1500_Contra = eval(['TargetGazeRate_last1500_5', d1]);
savestruct.Analogdata(s.iii).TargetGazeRate6112_last1500_Contra = eval(['TargetGazeRate_last1500_6', d1]);

savestruct.Analogdata(s.iii).TargetGazeRate6101_last1500_Ipsi = eval(['TargetGazeRate_last1500_1', d2]);
savestruct.Analogdata(s.iii).TargetGazeRate6102_last1500_Ipsi = eval(['TargetGazeRate_last1500_2', d2]);
savestruct.Analogdata(s.iii).TargetGazeRate6103_last1500_Ipsi = eval(['TargetGazeRate_last1500_3', d2]);
savestruct.Analogdata(s.iii).TargetGazeRate6104_last1500_Ipsi = eval(['TargetGazeRate_last1500_4', d2]);
savestruct.Analogdata(s.iii).TargetGazeRate6111_last1500_Ipsi = eval(['TargetGazeRate_last1500_5', d2]);
savestruct.Analogdata(s.iii).TargetGazeRate6112_last1500_Ipsi = eval(['TargetGazeRate_last1500_6', d2]);

% for i = 1:length(goodtrial)
%     
%     x = goodtrial(i);
%     
%     targon_=fix(PDS.timetargeton(x)*1000);
%     
%     Gocue = fix(PDS.timefpoff(x)*1000) - targon_;
%     
%     aquisitiontime = fix((PDS.targetAcquisitionFirst(x) - PDS.trialstarttime(x))*1000) - targon_;
%     
%     timecourse = 0:800;    
%     figuren;
%     hold on
%     plot(timecourse, Xeye(x, timecourse+1)./1000)
%     plot([Gocue Gocue], [-20 20], '-r')
%     plot([aquisitiontime aquisitiontime], [-20 20], '-b')
%     axis([0 800 -inf inf])
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function pixels             =   deg2pix(degrees,c) % PPD pixels/degree
% deg2pix convert degrees of visual angle into pixels

pixels = round(tand(degrees)*c.viewdist*c.screenhpix/c.screenh);

end

% end






