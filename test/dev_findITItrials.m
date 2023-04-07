function [short_iti_trls, long_iti_trls] = dev_findITItrials(TrialEventTimes)

nTrls = size(TrialEventTimes,1);

iti = [NaN];

for trl_i = 2:nTrls
    
    if ~isnan(TrialEventTimes.rwd_on(trl_i-1))
        iti = [iti;...
            TrialEventTimes.fix_on(trl_i) - ...
            TrialEventTimes.rwd_on(trl_i-1)];
    else
        iti = [iti;...
            TrialEventTimes.fix_on(trl_i) - ...
            TrialEventTimes.airpuff(trl_i-1)];
    end
end



short_iti_trls = find(iti < quantile(iti,1/3));
long_iti_trls  = find(iti > quantile(iti,2/3));

end


