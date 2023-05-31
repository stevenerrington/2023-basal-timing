% Basal Forebrain: NIH CS task
trial_type_list = {'prob0','prob50','prob100'};
params.plot.xintercept = 1500;
params.eye.salience_window = params.eye.zero+1500+[-200:0];

data_in = []; data_in = bf_data_punish;
[~, ~, mean_gaze_array_bf_nih, time_gaze_window_nih]  =...
    get_pgaze_window(data_in, trial_type_list, params);

trl_type_in = 'prob50';

sdf_x_eye_r = [];
sdf_x_eye_p = [];

for neuron_i = 1:size(data_in,1)
    analysis_win_eye = [0:1500]+ find(params.eye.alignWin == 0);
    analysis_win_spk = [0:1500]+ 5001;
    
    trl_gaze_in = []; trl_gaze_in = mean_gaze_array_bf_nih.(trl_type_in)(neuron_i,analysis_win_eye);
    trl_spk_in = []; trl_spk_in = nanmean(data_in.sdf{neuron_i}(data_in.trials{neuron_i}.(trl_type_in),analysis_win_spk));
    trl_spk_in = trl_spk_in./max(trl_spk_in);
    
    
    sdf_x_eye_r_boot = [];
    
    for bootstrap_i = 1:500
        
        sampletimes = []; sampletimes = sort(datasample([1:1500],250));
        sdf_bootstrap = []; sdf_bootstrap = trl_spk_in(sampletimes);
        eye_bootstrap = []; eye_bootstrap = trl_gaze_in(sampletimes);
        
        [sdf_x_eye_r_boot(bootstrap_i,1), ~] = corr(sdf_bootstrap', eye_bootstrap');
    end
    
    sdf_x_eye_r(neuron_i,1) = median(sdf_x_eye_r_boot);
    try
        sdf_x_eye_p(neuron_i,1) = signrank(sdf_x_eye_r_boot);
    catch
        sdf_x_eye_p(neuron_i,1) = NaN;
    end
end

figure;
histogram(sdf_x_eye_r,-1:0.1:1)

figure;
histogram(sdf_x_eye_p,0:0.001:1)
vline(0.05/
figure;
subplot(1,2,1)
plot([0:1500],trl_gaze_in);
subplot(1,2,2)
plot([0:1500],trl_spk_in);
