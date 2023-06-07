function print_stats(statistics_data, location)

switch statistics_data.stat_function_name
    case 'ranksum'
        stat_text = {['Statistic name: ', statistics_data.stat_function_name],...
            ['Z = ', num2str(statistics_data.output.zval,'%4.3f') ', p = ' num2str(statistics_data.p,'%4.3f')],...
            ['N(group 1) = ', num2str(sum(~isnan(statistics_data.stat_data_a)))],...
            ['N(group 2) = ', num2str(sum(~isnan(statistics_data.stat_data_b)))]};
    case 'ttest2'
        stat_text = {['Statistic name: ', statistics_data.stat_function_name],...
            ['t (' num2str(statistics_data.output.df,'%4.0f') ') = ', num2str(statistics_data.output.tstat,'%4.3f') ', p = ' num2str(statistics_data.p,'%4.3f')],...
            ['N(group 1) = ', num2str(sum(~isnan(statistics_data.stat_data_a)))],...
            ['N(group 2) = ', num2str(sum(~isnan(statistics_data.stat_data_b)))]};        
end


stat_annotation = annotation('textbox',[location(1) location(2) .2 .1],'String',stat_text,'FitBoxToText','on','EdgeColor','none');
stat_annotation.FontSize = 8;


end