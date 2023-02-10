function dirs = get_dirs_bf(user)

switch user
    case 'mac'
        dirs.root = '/Users/stevenerrington/Desktop/Projects/2023-basal-timing';
        dirs.toolbox = '/Users/stevenerrington/Desktop/Projects/toolbox';
        dirs.inherit = '/Users/stevenerrington/Desktop/Projects/2023-basal-timing/src/BasalForebrain_Zhang_Chen_Monosov';
        
    case 'home'
        dirs.root = 'D:\projectCode\2023-basal-timing\';
        dirs.toolbox = 'D:\projectCode\toolbox\';
        dirs.inherit = 'C:\Users\Steven\Desktop\temp\BasalForebrain_Zhang_Chen_Monosov\BasalForebrain_Zhang_Chen_Monosov';
        
    case 'wustl'
        dirs.root = 'C:\Users\Steven\Documents\GitHub\2023-basal-timing\';
        dirs.toolbox = 'C:\Users\Steven\Documents\GitHub\toolbox\';
        dirs.inherit = 'C:\Users\Steven\Documents\GitHub\2023-basal-timing\src\BasalForebrain_Zhang_Chen_Monosov\';
        
end

addpath(genpath(dirs.root));
addpath(genpath(dirs.toolbox));
addpath(genpath(dirs.inherit));

end

