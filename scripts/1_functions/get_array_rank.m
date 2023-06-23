function rank = get_array_rank(array)

   [~,p] = sort(array,'descend');
   rank = 1:length(array);
   rank(p) = rank;

end
