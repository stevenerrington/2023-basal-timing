
neuron_i = 2; % 1 - 23; 2 - 24

clear analysis_win analysis_win_ref 
analysis_win = [-1000:2500];
event_zero = 5000;
analysis_win_ref = analysis_win + event_zero;



figure;
subplot(3,1,1)
imagesc(test.rasters{neuron_i}(:,analysis_win_ref))
colormap(flipud(bone))

subplot(3,1,2)
plot(analysis_win,nanmean(test.sdf{neuron_i}(:,analysis_win_ref)))

subplot(3,1,3)
plot(test.fano(neuron_i).time,test.fano(neuron_i).FanoSaveAll)
xlim([analysis_win(1) analysis_win(end)])





neuron_b_index = 23;


figure;
subplot(3,1,1)


subplot(3,1,2)
plot(-1500:2500, ProbAmtDataStruct(neuron_b_index).AllSDF)
xlim([analysis_win(1) analysis_win(end)])

subplot(3,1,3)
plot(ProbAmtDataStruct(neuron_b_index).FanoSaveAll)
