function HF = hazardF(PDF, EventProb)
% This function takes in probability distribution function of an event and
% calculates the standard hazard rate.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS:
% PDF - probability distribution function: Is the frequency count for an
%       event happening at each time-step for all time-steps. This is a [N x 1]
%       array, with each value representing the occurrance frequency. The
%       elements in the array correspond to different time-steps. 
% EventProb - probability of the event happening. If the event is
%       deterministic (i.e., it will happen for sure) then EventProb = 1, and
%       hazard rate will be calculated as typically done. However, if the event
%       is probabilistic (i.e., it only happens on a proportion of trials) then
%       EventProb < 1, and the hazard rate calculation also needs to incorporate
%       *state inference*, which dynamically changes as a function of time.
%%%%%%%
% OUTPUT:
% HR - Hazard rate. Note that the time-steps have to be matched the output 
%       outside of the function. The output calculates the HR based on whatever 
%       time resolution provided in the PDF.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 2; EventProb = 1; end % default is that the event ir deterministic.

if EventProb < 1   % When the event is probabilistic:
    % A short-cut trick used in calculating conditional hazard rate is used:
    noEventProb = ( sum(PDF) * (1-EventProb)/(EventProb) ); % identify the probability that the event will not occur
    PDF = [PDF noEventProb]; % Add this to the end-tail of the original PDF. 
                             % This way the original PDF will remain as is but the probability of non-occurrance will be added as the last time-stamp.
    % Then calculate the Hazard rate in the classic way.
    PDF = PDF / sum(PDF);  
    CDF = cumsum(PDF / sum(PDF)); % cumulative distribution
    CDF = [0 CDF(1:end-1)];
    HF = PDF ./ (1-CDF);
    % BUT, since we added one element to PDF, our HF will also have one
    % extra element. So, we need to exclude the last element.
    HF = HF(1:end-1);
    % Input the probability density function (PDF).
    % Hazard function = PDF / (1-PDF)
else              % When the event is deterministic:
    % classic definition of hazard rate:
    PDF = PDF / sum(PDF);
    CDF = cumsum(PDF / sum(PDF)); % cumulative distribution
    CDF = [0 CDF(1:end-1)];
    HF = PDF ./ (1-CDF);
end