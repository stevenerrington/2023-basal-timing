function Rasters = clean_spk_artifact(Rasters,trial_a,trial_b,time_win_contam,time_win_clean)

if ~isempty(trial_a)==1 & ~isempty(trial_b)==1
    for trl_i=1:length(trial_b)
        spk_dirty=Rasters(trial_b(trl_i),:);
        
        trial_a=trial_a(randperm(length(trial_a)));
        spk_clean=Rasters(trial_a(1),:);
        
        spk_dirty(time_win_contam(1):time_win_contam(2)) =...
            spk_clean(time_win_clean(1):time_win_clean(2));
        
        Rasters(trial_b(trl_i),:)=spk_dirty;
        clear spk_dirty spk_clean x
    end
end
