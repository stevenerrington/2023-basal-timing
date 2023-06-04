function hazF_subjective = hazardF_subjective(pdf, tStep_val, eventProb, WeberFactor, timeRes)
% This function takes in probability distribution function of an event and
% calculates the subjective hazard rate. 
% Conceptually, this is similar to hazard rate calculation, except that now
% we adjust the probability distribution function based on possible
% misperceptions in time duration, as described by equations published
% previously, and explained in the manuscript.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS:
% pdf - probability distribution function: Is the frequency count for an
%       event happening at each time-step for all time-steps. This is a [N x 1]
%       array, with each value representing the occurrance frequency. The
%       elements in the array correspond to different time-steps. 
% tStep_val - is the time value array corresponding to PDF. 
% eventProb - probability of the event happening. If the event is
%       deterministic (i.e., it will happen for sure) then EventProb = 1, and
%       hazard rate will be calculated as typically done. However, if the event
%       is probabilistic (i.e., it only happens on a proportion of trials) then
%       EventProb < 1, and the hazard rate calculation also needs to incorporate
%       *state inference*, which dynamically changes as a function of time.
% WeberFactor - This number influences the relationship between inaccuracy
%       in duration perception and time duration. Default is 0.26
% timeRes - Calculation of hazard rate depends on time resolution. Here, we
%       consider time resolution to match the minimum interval between
%       adjacent SSDs (here SSDs were equally spaced). 

%%%%%%%
% OUTPUT:
% HF - Hazard rate. Note that the time-steps have to be matched the output 
%       outside of the function. The output calculates the HR based on whatever 
%       time resolution provided in the PDF.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if WeberFactor > 0         % If there is misperception of time as defined by WeberFactor:
    % NOTE: here, because there is inaccuracy in time duration
    %       perception, as defined by a Gaussian distribution, time-steps beyond
    %       those in pdf can also be considered as valid time-steps. Therefore,
    %       we will extend our time-array (always has to be greater than 0) and
    %       create an updated probability distribution function.
    subjectivePDF_perTimeStep = []; % initialize
    pdfWeight = pdf / norm(pdf); % normalizing it.
    % to set the range of normpdf, we need to know the upper and lower range of
    % values considering tStep_val (i.e., SSD) values.
    pdfRange = 0: max(tStep_val) + max(tStep_val)*WeberFactor*2; % extending the range way beyond that last time-step to account for a long Gaussian tail. (beyond a certain point it doesn't matter)
    
    for tval_i = 1:numel(tStep_val)  % for each time-step
        winSet( tval_i,: ) = round( tStep_val( tval_i) + [-timeRes:timeRes] ); % A window, centered on each bin time-step will contribute to the final updated pdf.  
        currSigma = WeberFactor * tStep_val(tval_i);  % sigma of the gaussian scales with the time duration.
        subjectivePDF_perTimeStep(tval_i,:) = normpdf( pdfRange,tStep_val(tval_i),currSigma ) .* pdfWeight(tval_i);  % weighted by pdf.
                       % NOTE: The gaussian corresponding to each time-step is placed in each row. AND it's weighted by the *pdf*.
    end
    % At this point, subjectivePDF_perTimeStep contains N rows, with each
    % row corresponding to each time-step. The new probability distribution
    % function needs to be the sum of all.
    newPDF = sum(subjectivePDF_perTimeStep, 1);  % summing across all time-steps to obtain a single new pdf.
    newPDF = newPDF / sum(newPDF);               % normalizing it.
    % Now we will bin it into the same bins as the original input (tStep_val) time resolution.
    for tval_i = 1:numel(tStep_val)
        windowsSet2use = winSet(tval_i,:);      
        windowsSet2use(windowsSet2use <= 0) = [];  % we exclude negative windows.
        subjectivePDF(tval_i) = sum(  newPDF( windowsSet2use ) ); % Any value in newPDF that falls within each bin is summed.
    end
    % Anything beyond our valid time-range can be placed in a single bin...
    % ... This is OK because we will not be dealing with time-points beyond the range of valid time intervals.
    subjectivePDF(numel(tStep_val)+1) = sum( newPDF( winSet(numel(tStep_val),end):pdfRange(end) ) ); % this added element is important so that the final valid time-step doesn't shoot up to 1. 
                                                                                                     % It shouldn't because, times beyond our time misperception may result in our estimates to fall beyond our time range.
    hazF_subjective = hazardF(subjectivePDF,eventProb);  % hazardF calculates the hazard rate (see the function for elaboration).
    hazF_subjective = hazF_subjective(1:numel(tStep_val)); % This is were the extra element added above is eliminated and becomes irrelevant.
else   % if WeberFactor = 0, then things become identical to Absolute/standard hazard rate.
    hazF_subjective = hazardF(pdf,eventProb); % hazardF calculates the hazard rate (see the function for elaboration).
    hazF_subjective = hazF_subjective(1:numel(tStep_val));
end