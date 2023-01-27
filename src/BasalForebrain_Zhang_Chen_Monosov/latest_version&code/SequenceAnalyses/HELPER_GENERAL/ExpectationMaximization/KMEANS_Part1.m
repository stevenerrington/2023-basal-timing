%r: number number of iterations...
%k: number of clusters...
%x: data input

%return membership array
function [membership,centroids,count,sse_self] = KMEANS_Part1(x,intialCentroid_idx,r)
	sizeX = size(x,1);
	numOfClunters = size(intialCentroid_idx,2);
	count = 0;
	centroids = x(intialCentroid_idx,:);
	sse_self = [];
    
	membership0 = returnMemberShip(x,centroids);
    %doPlot(x,membership0,r);
    keepLooping = true;
	while keepLooping
		count=count+1;
        r
        i=count
        disp('----');
        sse = computeSSE(x,centroids);
        sse_self = [sse_self,sse];
		centroids = update_centeroids(x,membership0);
		membership = returnMemberShip(x,centroids);
        %doPlot(x,membership,r);
		if(isequal(membership0,membership))
			keepLooping = false;
        end
		membership0 =  membership;
    end
	%doPlot(x,membership,centroids,r,count);
end 