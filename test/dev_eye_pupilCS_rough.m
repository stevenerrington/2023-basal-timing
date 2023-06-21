
params.eye.window = [5 5]; params.plot.xintercept = 2500;
params.eye.zero = find(params.eye.alignWin == 0);
params.eye.baseline = [-500:0];

% Basal Forebrain: NIH CS task
trial_type_list = {'prob0','prob25','prob50','prob75','prob100'};
params.plot.xintercept = 2500;
params.eye.salience_window = params.eye.zero + params.plot.xintercept+ [-200:0];

data_in = []; data_in = bf_data_CS(strcmp(bf_datasheet_CS.site,'wustl'),:);
colors.appetitive = [247 154 154; 244 107 107; 240 59 59; 230 18 18; 182 14 14]./255;

neuron_i = 2;


eye_pupil_in = [];
for trial_i = 1:size(data_in.eye{neuron_i}.eye_pupil{1},1)
    
    eyetrace = [];
    eyetrace = [data_in.eye{neuron_i}.eye_x{1,1}(trial_i,:)',...
        data_in.eye{neuron_i}.eye_y{1,1}(trial_i,:)'];
    
    % Run saccade extraction
    saccade_info = [];
    [saccade_info,~] = saccade_detector(eyetrace,params);
    
    % Pupil
    baseline_pupil = nanmean(data_in.eye{neuron_i}.eye_pupil{1}...
        (trial_i,params.eye.baseline+params.eye.zero));
    
    eye_pupil_in(trial_i,:) = data_in.eye{neuron_i}.eye_pupil{1}(trial_i,:)./baseline_pupil;
    
    if ~isempty(saccade_info)
        for saccade_i = 1:length(saccade_info(:,2))
            sacc_window = []; sacc_window = saccade_info(saccade_i,2)+[-20:20];
            if ~any(sacc_window < 1) & ~any(sacc_window > length(params.eye.alignWin))
                eye_pupil_in(trial_i,sacc_window) = NaN;
            end
        end
    end
end

figure; hold on
plot([-500:3000],...
    nanmean(eye_pupil_in(data_in.trials{neuron_i}.prob0,params.eye.zero+[-500:3000])),...
    'color',colors.appetitive(1,:))
plot([-500:3000],...
    nanmean(eye_pupil_in(data_in.trials{neuron_i}.prob25,params.eye.zero+[-500:3000])),...
    'color',colors.appetitive(2,:))
plot([-500:3000],...
    nanmean(eye_pupil_in(data_in.trials{neuron_i}.prob50,params.eye.zero+[-500:3000])),...
    'color',colors.appetitive(3,:))
plot([-500:3000],...
    nanmean(eye_pupil_in(data_in.trials{neuron_i}.prob75,params.eye.zero+[-500:3000])),...
    'color',colors.appetitive(4,:))
plot([-500:3000],...
    nanmean(eye_pupil_in(data_in.trials{neuron_i}.prob100,params.eye.zero+[-500:3000])),...
    'color',colors.appetitive(5,:))


vline([ 0 2500 ], 'k')





