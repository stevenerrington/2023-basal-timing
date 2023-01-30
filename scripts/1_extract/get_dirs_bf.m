function dirs = get_dirs_bf(user)

switch user
    case 'mac'
        dirs.root = '/Users/stevenerrington/Desktop/Projects/2023-basal-timing';
        dirs.inherit = '/Users/stevenerrington/Desktop/Projects/2023-basal-timing/src/BasalForebrain_Zhang_Chen_Monosov';
        
    case 'home'
        dirs.root = 'D:\projectCode\2023-basal-timing\';
        dirs.inherit = 'C:\Users\Steven\Desktop\temp\BasalForebrain_Zhang_Chen_Monosov\BasalForebrain_Zhang_Chen_Monosov';
        
    case 'wustl'
        dirs.root = 'C:\Users\Steven\Documents\GitHub\2023-basal-timing\';
        dirs.inherit = 'C:\Users\Steven\Documents\GitHub\2023-basal-timing\src\BasalForebrain_Zhang_Chen_Monosov\';
        
end

addpath(genpath(dirs.root));
addpath(genpath(dirs.inherit));

end

