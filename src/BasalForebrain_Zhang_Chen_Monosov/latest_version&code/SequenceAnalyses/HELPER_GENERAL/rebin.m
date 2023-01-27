function [y] = rebin(x,binwidth,combine_fxn,shrink,truncate)
%rebin(x,binwidth,combine_fxn,shrink,truncate)
%
% bins data by combining 'binwidth' adjacent data points
% into a single new data point, using the combine_fxn (default=@mean)
% if shrink is true, just return these new data points
% if shrink is false (the default), return a data vector
%  of the same size as x, with each
%  data point replaced by its new data point
% if truncate is true or 'end', then if x doesn't divide evenly into
%  bins of width 'binwidth', then remove the remainder of x.
% if truncate is 'start', truncate the starting entries of x
%  instead of the ending entries of x.
% if truncate is 'startnan' or 'endnan', instead of removing the
%  entries, set them to nan
%
%examples
% rebin([1 2 3 4],2,@mean) == [1.5 1.5 3.5 3.5]
% rebin([1 2 3 4],2,@mean,true) == [1.5 3.5]
% rebin([1 2 3 4],2,@sum) == [3 3 7 7]
% rebin([1 2 3 4],2,@sum,true) == [3 7]
% rebin([1 2 3 4 5],2,@sum,true,true) == [3 7]

if nargin < 1 error('need at least 1 argument'); end;
if nargin < 2 binwidth = 1; end;
if nargin < 3 combine_fxn = @mean; end;
if nargin < 4 shrink = false; end;
if nargin < 5 truncate = false; end;
if nargin > 5 error('can take at most 5 arguments'); end;

if isequal(truncate,'start') || isequal(truncate,'end') || isequal(truncate,'startnan') || isequal(truncate,'endnan')
    do_truncate = true;
elseif isequal(truncate,true)
    do_truncate = true;
    truncate = 'end';
else
    do_truncate = false;
    truncate = false;
end;

if length(size(x)) > 2 || size(x,1) > 1 && size(x,2) > 1
    % rebin separately on each row
    y_init = rebin(x(1,:),binwidth,combine_fxn,shrink,truncate);
    y = nans(size(x,1),size(y_init,2));
    y(1,:) = y_init;
    for r = 2:size(x,1)
        y(r,:) = rebin(x(r,:),binwidth,combine_fxn,shrink,truncate);
    end;
    return;
end;

if ~do_truncate && mod(length(x),binwidth) ~= 0
    error(['data does not divide evenly into bins of width ' num2str(binwidth)]);
end;

nbins = floor(length(x) / binwidth);

if ~do_truncate || isequal(truncate,'end') || isequal(truncate,'endnan')
    binstart = 1:binwidth:length(x);
    if binstart(end)+binwidth-1 > length(x)
        binstart = binstart(1:(end-1));
    end;
    binend = binstart + binwidth - 1;
elseif isequal(truncate,'start') || isequal(truncate,'startnan')
    binend = length(x):-binwidth:1;
    if binend(end) < binwidth
        binend = binend(1:(end-1));
    end;
    binend = binend(end:-1:1);
    binstart = binend - binwidth + 1;
else
    error('unknown truncation mode!');
end;

if shrink
    if size(x,1) > size(x,2)
        y = zeros(nbins,1);
    else
        y = zeros(1,nbins);
    end;
    for b = 1:nbins
        y(b) = combine_fxn(x(binstart(b):binend(b)));
    end;
else
    y = nans(size(x));
    for b = 1:nbins
        y(binstart(b):binend(b)) = combine_fxn(x(binstart(b):binend(b)));
    end;
    
    if isequal(truncate,'end') || isequal(truncate,'start')
        y = y(binstart(1):binend(end));
    end;
end;
