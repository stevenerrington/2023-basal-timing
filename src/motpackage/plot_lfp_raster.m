%******************* make a rastergram of the actual spikes on each trial
function plot_lfp_raster(spmat)

colo = 'rbgy';

totspike = [];
CNUM = size(spmat,2);
for ii = 1:size(spmat,2)
    totspike = [totspike ; spmat{1,ii}];
end
splito = size(totspike,1)/CNUM;

mino = min(min(totspike)) * 0.5;  %allow some partial overlap
maxo = max(max(totspike)) * 0.5;
for ii = 1:size(totspike,1)
   offset = (size(totspike,1)-ii);
   yy = offset + ((totspike(ii,:)-mino)/(maxo-mino));
   cubo = 1 + floor((ii-1)/splito);
   plot(1:size(totspike,2),yy,[colo(cubo),'-']); hold on;
end
V = axis;
axis([V(1) V(2) 0 size(totspike,1)]);

return;
