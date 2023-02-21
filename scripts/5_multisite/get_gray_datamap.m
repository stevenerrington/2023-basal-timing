%% GrayArray Data Map
 filename_out = 'grayarray_map.mat';

if exist(fullfile(dirs.root,'data',filename_out)) == 2
    load(fullfile(dirs.root,'data',filename_out));
    fprintf('Datamap successfully loaded! \n');
    
else
    % Get a structure of neuron data files to reference
    dirs_rawdata = 'Y:\KainingFatihShare\Neuronlists\';
    
    monkeynames = {'Lemmy','Slayer'};
    
    allInd = 0;
    
    % For both monkeys
    for monkeyInd = 1:numel(monkeynames)
        
        % Get monkey name
        monkeyName = monkeynames{monkeyInd};
        % Locate the corresponding directory
        dir2withMonkey = fullfile(dirs_rawdata,monkeyName);
        
        % Find all files within the monkey directory
        files = dir(dir2withMonkey);
        files = files(3:end);
        
        % For each file within the directory
        for fileInd = 1:numel(files)
            
            % Get the session name
            sessionName = files(fileInd).name;
            
            fprintf('Extracting data from %s... | file %i of %i \n',sessionName, fileInd, numel(files));
            % ... and full file name
            name2load = fullfile(dir2withMonkey,sessionName);
            load(name2load);
            
            % Get a list of the fields within the raw file
            fields = fieldnames(Neuronlist);
            
            % Create the structure by taking admin information from the raw file
            for listInd = 1:numel(Neuronlist)
                if contains(Neuronlist(listInd).name,'SPK')
                    allInd = allInd + 1;
                    if strcmp(monkeyName,'Lemmy')
                        monkeyInd = 2;
                    else
                        monkeyInd = 1;
                    end
                    grayarray_map(allInd).dir = dir2withMonkey;
                    grayarray_map(allInd).session = sessionName;
                    grayarray_map(allInd).monkeyName = monkeyName;
                    grayarray_map(allInd).monkeyInd = monkeyInd;
                    for fieldInd = 1:numel(fields)
                        grayarray_map(allInd).(fields{fieldInd}) = Neuronlist(listInd).(fields{fieldInd});
                    end
                end
            end
            
        end
    end
    
    grayarray_map = struct2table(grayarray_map);
    
    %% Output: Save datamap
    save(fullfile(dirs.root,'data',filename_out),'grayarray_map');
end
