function hF = hazardF_subjective_dynamic( pdf, tStep_val, eventProb, perTrial_restricted_pdf_element, WeberFactor, timeRes )
% This function takes in overall pdf, and restricted SSD range per trial,
% and a few more inputs and % calculates the dynamic subjective hazard rate for each trial. 
% Conceptually, this is similar to Subjective hazard rate calculation, except that now
% we restrict the probability distribution (pdf) for each trial based on
% trial history and knowledge of the staircasing algorithm:
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
%    NOTE: although the eventProb changes on a trial-by-trial basis,
%    because in each SSD bin we have many trials, the eventProb on average
%    is similar to the overal eventProb. So, here we are assuming that
%    eventProb (i.e., probability of stop-signal occurrance) is constant.
% perTrial_restricted_pdf_element - This has the size TrialNum x tStep_val,
%       with any possible SSD tagged as 1, and any impossible SSD (based on
%       the staircasing algorithm) is tagged as 0. 
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
hF = nan( size( perTrial_restricted_pdf_element, 1 ), numel(pdf) ); % initializing
for trl = 1:size( perTrial_restricted_pdf_element, 1 )
    inputPDF = zeros( 1, numel(pdf) );
    inputPDF(  perTrial_restricted_pdf_element(trl,:) == 1  ) = pdf(  perTrial_restricted_pdf_element(trl,:) == 1  );  % only those pdf elements with tag = 1 are going to contribute to the current trial's pdf.
    hF( trl, : ) = hazardF_subjective(inputPDF, tStep_val, eventProb, WeberFactor, timeRes);
end