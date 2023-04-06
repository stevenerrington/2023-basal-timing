function TrialEventTimes = dev_extractTrialEventTimes(REX)

REX = struct2table(REX);

% Event Codes:
TRIALSTART  =   1001;
CUECD	    =	1050;
REWCD       =	1030;
AIRCD       =	1990;
TARGONCD	=	1100;
TARGOFFCD	=	1101;
REWOFFCD    =	1037;
EYEIN       =   5555;
EYEATSTIM   =   6666;



% ISSUE - THIS CODE SOMETIMES SPITS OUT TWO EVENT CODES FOR ONE EVENT?

nTrls = size(REX,1);

TrialEventTimes = table();
for trl_i = 1:nTrls
    
    trl_event_in = []; trl_event_in = struct2table(REX.Events{trl_i});
    
    trl_start = double(trl_event_in.Time(trl_event_in.Code == TRIALSTART));
    fix_on = double(trl_event_in.Time(trl_event_in.Code == CUECD));
    cs_on = double(trl_event_in.Time(trl_event_in.Code == TARGONCD));
    cs_off = double(trl_event_in.Time(trl_event_in.Code == TARGOFFCD));
    rwd_on = double(trl_event_in.Time(trl_event_in.Code == REWCD));
    rwd_off = double(trl_event_in.Time(trl_event_in.Code == REWOFFCD));
    airpuff = double(trl_event_in.Time(trl_event_in.Code == AIRCD));
    
    if isempty(trl_start); trl_start = NaN; end
    if isempty(fix_on)   ; fix_on = NaN; end
    if isempty(cs_on)    ; cs_on = NaN; end
    if isempty(cs_off)   ; cs_off = NaN; end
    if isempty(rwd_on)   ; rwd_on = NaN; end
    if isempty(rwd_off)  ; rwd_off = NaN; end
    if isempty(airpuff)  ; airpuff = NaN; end
    
    
    TrialEventTimes(trl_i,:) = ...
        table(trl_start, fix_on, cs_on, cs_off, rwd_on, rwd_off, airpuff);
    
end

end
