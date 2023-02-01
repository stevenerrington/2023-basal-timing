
%% Load Zhang processed data
nih_datastruct = load(fullfile(dirs.root,'data','DATA15.mat'));
wustl_datastruct = load(fullfile(dirs.root,'data','DATA25_V2.mat'));

joint_datastruct = [nih_datastruct.ProbAmtDataStruct wustl_datastruct.ProbAmtDataStruct];

%% Import
% XLS Sheet: WUSTL Neurons
[~,~,wustl_neuronsheet] = xlsread(fullfile(dirs.root,'docs','BF_neuron_sheet'));

% XLS Sheet: NIH Neurons
[~,~,nih_neuronsheet] = xlsread(fullfile(dirs.root,'docs','septumprobamt.xls'));


%%
clear bf_datasheet

for ii = 1:size(joint_datastruct,2)
    clear file monkey date ap_loc ml_loc depth area site dir

    file = {joint_datastruct(ii).name};
    monkey = {lower(joint_datastruct(ii).monkey)};
    
    % WUSTL Data
    if ~isempty( find(strcmp(wustl_neuronsheet(:,15),file{1}(1:end-4))))
        xls_index = find(strcmp(wustl_neuronsheet(:,15),file{1}(1:end-4)));
        
        date = {wustl_neuronsheet{xls_index,12}};
        ap_loc = wustl_neuronsheet{xls_index,10};
        ml_loc = wustl_neuronsheet{xls_index,11};
        depth = wustl_neuronsheet{xls_index,3};
        area = wustl_neuronsheet(xls_index,14);
        site = {'wustl'};
        dir = wustl_neuronsheet(xls_index,16);
        
    % NIH Data
    elseif ~isempty(find(strcmp(nih_neuronsheet(:,2),file{1}(4:end)))) || ...
            ~isempty(find(strcmp(nih_neuronsheet(:,2),file{1}(5:end))))
        
        xls_index = find(strcmp(nih_neuronsheet(:,2),file{1}(4:end)));
        
        if isempty(xls_index)
            xls_index = find(strcmp(nih_neuronsheet(:,2),file{1}(5:end)));
        end
        
        
        date = {'?'};
        ap_loc = nih_neuronsheet{xls_index,5};
        ml_loc = nih_neuronsheet{xls_index,6};
        depth = nih_neuronsheet{xls_index,4};
        area = {'BF'};
        site = {'nih'};   
        dir = {'X:\MONKEYDATA\NIHBFrampingdata2575\MRDR\'};
        
    else
        continue
    end
    
    
    bf_datasheet(ii,:) = table(file, monkey, date, ap_loc, ml_loc, depth, area, site, dir);
    
end






for ii = 1:size(joint_datastruct,2)
    if ~isempty(find(strcmp(wustl_neuronsheet(:,15),joint_datastruct(ii).name(1:end-4))))
        a(ii) = find(strcmp(wustl_neuronsheet(:,15),joint_datastruct(ii).name(1:end-4)))
    else
        a(ii) = NaN;
    end
end


    



%% 




neuron_i = 2; % 1 - 23; 2 - 24

clear analysis_win analysis_win_ref 
analysis_win = [-1000:2500];
event_zero = 5000;
analysis_win_ref = analysis_win + event_zero;



figure;
subplot(3,1,1)
imagesc(bf_datasheet.rasters{neuron_i}(:,analysis_win_ref))
colormap(flipud(bone))

subplot(3,1,2)
plot(analysis_win,nanmean(bf_datasheet.sdf{neuron_i}(:,analysis_win_ref)))

subplot(3,1,3)
plot(bf_datasheet.fano(neuron_i).time,bf_datasheet.fano(neuron_i).FanoSaveAll)
xlim([analysis_win(1) analysis_win(end)])





neuron_b_index = 23;


figure;
subplot(3,1,1)


subplot(3,1,2)
plot(-1500:2500, ProbAmtDataStruct(neuron_b_index).AllSDF)
xlim([analysis_win(1) analysis_win(end)])

subplot(3,1,3)
plot(ProbAmtDataStruct(neuron_b_index).FanoSaveAll)
