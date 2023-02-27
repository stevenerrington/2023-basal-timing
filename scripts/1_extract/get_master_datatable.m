
%% Initialize parameters and variables
count = 0; master_datatable_bf = table();

%% Loop through tasks
% Pavlovian (CS) task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
for cs_data_i = 1:size(bf_datasheet_CS,1)
    
    if bf_datasheet_CS.cluster_id(cs_data_i) == 2
        count = count + 1;
        
        % Get data
        filename = bf_datasheet_CS.file(cs_data_i);
        dir = bf_datasheet_CS.dir(cs_data_i);
        monkey = bf_datasheet_CS.monkey(cs_data_i);
        site = bf_datasheet_CS.site(cs_data_i);
        area = bf_datasheet_CS.area(cs_data_i);
        task = {'CS'};
        
        master_datatable_bf(count,:) = table(filename, dir, monkey, site, area, task);
        
    end
    
end

% Timing task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
for timing_data_i = 1:size(bf_datasheet_timingExp,1)
    
        count = count + 1;
        
        % Get data
        filename = bf_datasheet_timingExp.file(timing_data_i);
        dir = bf_datasheet_timingExp.dir(timing_data_i);
        monkey = bf_datasheet_timingExp.monkey(timing_data_i);
        site = bf_datasheet_timingExp.site(timing_data_i);
        area = bf_datasheet_timingExp.area(timing_data_i);
        task = {'Timing'};
        
        master_datatable_bf(count,:) = table(filename, dir, monkey, site, area, task);
        

end

% Trace task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
for trace_data_i = 1:size(bf_datasheet_traceExp,1)
    
        count = count + 1;
        
        % Get data
        filename = bf_datasheet_traceExp.file(trace_data_i);
        dir = bf_datasheet_traceExp.dir(trace_data_i);
        monkey = bf_datasheet_traceExp.monkey(trace_data_i);
        site = {'wustl'};
        area = {'bf'};
        task = {'Trace'};
        
        master_datatable_bf(count,:) = table(filename, dir, monkey, site, area, task);
        
end

%% Export: Save Data
save(fullfile(dirs.root,'data','master_datatable_bf.mat'),'master_datatable_bf')