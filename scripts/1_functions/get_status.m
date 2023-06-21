function status = get_status(dirs)

if ispc()
    data_dir = fullfile(dirs.root,'data','large');
end
if ismac()
    data_dir = '/Users/stevenerrington/Box Sync/Research/2023-basal-timing/data';
end


% check to see if analysis data has been saved/is available
if exist(fullfile(data_dir,'bf_data_CS.mat')) == 2 &&...
        exist(fullfile(data_dir,'bf_data_traceExp.mat')) == 2 &&...
        exist(fullfile(data_dir,'bf_data_timingTask.mat')) == 2 &&...
        exist(fullfile(data_dir,'striatum_data_traceExp.mat')) == 2 &&...
        exist(fullfile(data_dir,'bf_datasheet_CS.mat')) == 2 &&...
        exist(fullfile(data_dir,'bf_datasheet_traceExp.mat')) == 2 &&...
        exist(fullfile(data_dir,'bf_datasheet_timingExp.mat')) == 2 &&...
        exist(fullfile(data_dir,'striatum_datasheet_CS.mat')) == 2;
    
    status = 'data';
    
else
    status = 'extract';
end

end