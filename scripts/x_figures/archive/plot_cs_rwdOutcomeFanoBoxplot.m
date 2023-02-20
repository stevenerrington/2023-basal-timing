

filename = fullfile(dirs.root,'results','bf_ramping_outcome_fanocomp.pdf');
set(outcome_rwd_fano_out,'PaperSize',[20 10]); %set the paper size to what you want
print(outcome_rwd_fano_out,filename,'-dpdf') % then print it
close(outcome_rwd_fano_out)

