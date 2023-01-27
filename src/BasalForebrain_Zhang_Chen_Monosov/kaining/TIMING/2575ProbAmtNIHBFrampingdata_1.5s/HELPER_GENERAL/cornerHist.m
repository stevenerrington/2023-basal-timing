function [newScat, newHist] = cornerHist(scatPlot,histPlot,ratio)
%function [newScat, newHist] = cornerHist(scatPlot,histPlot,ratio)
% copies a scatter plot to a new figure, and puts a histogram corresponding to the scatter
% plot in the top right corner.  Ratio is optional to change the height of
% the hist plot relative to its width - (ratio = width/height - ie. a ratio
% of 3 means that the height is one third of the width).
%
% To use this function:
% make two plots in separate figures.  Send in the handles to these two
% plots to this function - scatPlot will be the main figure, and histPlot
% will be placed in the top right corner at a 45 degree angle.  The
% histogram will be lined up correctly with the scatter plot, so if the
% hist shows 2 data points in a bin, you can draw lines from the edges of
% this bin, and see the 2 data points in between in the plot below (no
% guarantees if you are not using zero in the bottom left corner).  You 
% will be returned the handles to the two axes.  You can then move these
% plots around within the figure, add titles, text, change colors, etc.  To
% slide the histogram up and down along the main diagonal change both of
% the first two elements of the position vector by the same amount, ie.
% changing from set(newHist,'Position',[0.4 0.4 0.4 0.4]) to
% set(newHist,'Position',[0.5 0.5 0.4 0.4]) moves it farther into the top
% right corner.  You will need to use get(newHist,'Position') first, to get
% the size of the plot (position 3 and 4).  It is important not to change
% the size of the plot when you slide it. Start over if you want a
% different size plot.
% 
% created by Maria Mckinley, May 2004
% major update Apr 2008

if nargin < 3
    ratio = 1;
end
f = figure;
set(f,'position',[250 250 600 600])
scatAx = axes('Parent',f);
set(scatAx,'Position',[0.1 0.1 0.65 0.65])

% find length of bottom side of scatter plot
lScat = get(scatAx,'position');
LScat = lScat(3);
figure(scatPlot)
% get scale of scatter plot axis
limScat = get(gca,'XLim');
% get positive limit of axis, this will be the point of intersection, but
% need to have this in same units as position
figure(histPlot)
%posHist = get(gca,'Position');
limHist = get(gca,'Xlim');
LimScat = limScat(2) - limScat(1);
% need the point of intersection in same units as position
y = (LScat*limHist(end)/LimScat);
% matlab creates a box using the position, it then adjusts the plot to
% maximize this space.  In this case, since we are turning the plot 45
% degrees, (assuming for the moment that our plot will be square) it will
% expand the plot until the corner hits the middle of this box.  Therefor,
% the size of our square is twice the length of y, so that the width of our
% plot will be y times the square root of 2.
q = 2*y;
% now if we do not have a square plot, we need to adjust the size of the 
% box so that the plot stays the right width 
q2 = (0.5*q) + (q/(2*ratio));
% now we can change the height/width ratio
DAR = get(gca,'DataAspectRatio');
DAR(2) = DAR(2)*ratio;
set(gca,'DataAspectRatio',DAR)
figure(f)
histAx = axes('Parent',f);
set(histAx,'Position',[.4 .4 q2 q2])

% copy the scatter plot
figure(scatPlot)
h = get(gcf,'Children');
newScat = copyobj(h,f);
possub = get(scatAx,'Position');
set(newScat,'Position',...
    [possub(1) possub(2) possub(3) possub(4)])
delete(scatAx)

% copy the hist plot
figure(histPlot)
h = get(gcf,'Children');
newXlim = get(gca,'Xlim');
newYlim = get(gca,'Ylim');
newHist = copyobj(h,f);
possub = get(histAx,'Position');
set(newHist,'XLim',newXlim)
set(newHist,'YLim',newYlim)
set(newHist,'Position',...
    [possub(1) possub(2) possub(3) possub(4)])
delete(histAx)
axes(newHist)        
box on
% rotate the hist plot
camorbit(45, 0)
