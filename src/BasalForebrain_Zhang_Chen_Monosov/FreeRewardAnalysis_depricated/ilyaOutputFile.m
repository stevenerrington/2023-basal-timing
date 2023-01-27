function output = ilyaOutputFile(figureHandle, directory, filename)
try 
    set(figureHandle,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
% print('-dpdf', 'c:\folder\filename' );
print('-dpdf', [directory filesep filename] );
% print('-djpeg', [directory filesep filename] );
% saveas(gcf, [directory filesep filename '.fig'] )
output=1;
catch e
    output=0;
    disp (e);
end

end