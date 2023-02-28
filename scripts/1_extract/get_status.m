function status = get_status(dirs)

% check to see if BF analysis has been saved/is available
if exist(fullfile(dirs.root,'data','large','bf_data_CS.mat')) == 2 &&...
        exist(fullfile(dirs.root,'data','large','bf_data_traceExp.mat')) == 2 &&...
        exist(fullfile(dirs.root,'data','large','bf_data_timingTask.mat')) == 2 &&...
        exist(fullfile(dirs.root,'data','large','bf_datasheet_CS.mat')) == 2 &&...
        exist(fullfile(dirs.root,'data','large','bf_datasheet_traceExp.mat')) == 2 &&...
        exist(fullfile(dirs.root,'data','large','bf_datasheet_timingExp.mat'))
        
    status = 'data';
    
else
    status = 'extract';
end

end