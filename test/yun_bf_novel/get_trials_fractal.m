function trials = get_trials_fractal(PDS)


%% Get relevant trial indices %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % General:
completedtrial=find(PDS.goodtrial>0); % Completed trials
deliv=intersect(find(PDS.timereward>0),find( PDS.rewardDur>0)); % Reward delivered
ndeliv=intersect(find(PDS.timereward>0),find( PDS.rewardDur==0)); % Reward not delivered

fractals = unique(PDS.Cuetype);
fractals = fractals(~isnan(fractals));

for fractal_i = 1:length(fractals)
    trials.(['fractal_' int2str(fractals(fractal_i))])=intersect(completedtrial,find(PDS.Cuetype==fractals(fractal_i)));
end


end
