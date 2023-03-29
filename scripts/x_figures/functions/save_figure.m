function save_figure(figure_handle,save_folder,figure_name)
% Once we're done with a page, save it and close it.
filename = fullfile(save_folder,[figure_name '.jpg']);
set(figure_handle,'PaperSize',[20 10]); %set the paper size to what you want
print(figure_handle,filename,'-djpeg') % then print it
close(figure_handle)