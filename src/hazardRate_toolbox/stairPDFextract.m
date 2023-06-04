function perTrial_restricted_pdf_element = stairPDFextract( trialInfo, stairStep_speeding, stairStep_slowing )
% This code takes in trialInfo for a session and also the possible
% staircasing steps, and gives a matrix of possible SSDs for each trial
% given trial history.
% Note: Even if the staircasing algorithm did maintain SSD memory after
% aborted and no-stop trials, we only implement this for trials immediately
% following non-canceled and canceled trials. These are the trials on which
% we confidently know the subject can incorporate the staircasing
% algorithm.
%%%%%%%%%%%%%%%%
% load('C:\Users\sajada\Box\NComms_2021_ExecutiveControl\Nature Communications R2 Submission\SourceData_Code_inProgress\DATA\trialInfo.mat')
% trialInfo_forSession = trialInfo.session_1
% trialInfo = trialInfo_forSession;
% stairStep_speeding = {'NCerror', [1 2 3]}
% stairStep_slowing = {'C', [1 2 3]};

%%%%%%%%%%
SSDlist = unique( trialInfo.SSD ); SSDlist( isnan(SSDlist) ) = [];       % This is just the set of SSDs used in this study.
xC_trl = find( trialInfo.trlFlag_canceled == 1);  % xC means, all canceled trials irrespective of what the previous trial is (x means it can be anything).
xNC_trl = find( trialInfo.trlFlag_NCerror == 1  | trialInfo.trlFlag_NCpremature == 1 );   % xNC means non-canceled trials irrespective of the preceding trial.
xNCerror_trl = find( trialInfo.trlFlag_NCerror == 1 );   % xNC means non-canceled error (NCerror) trials irrespective of the preceding trial.
xNoStop_trl = find( trialInfo.trlFlag_noStop == 1 );  % all no-stop trials irrespective of trial history (previous trial denotated by x)
xStopSignal_trl = find( trialInfo.trlFlag_canceled == 1 | trialInfo.trlFlag_NCerror == 1 | trialInfo.trlFlag_NCpremature == 1 );  % all stop-signal trials irrespective of sub-type
xSSseen_trl = find( trialInfo.trlFlag_canceled == 1 | trialInfo.trlFlag_NCerror == 1 );  % all stop-signal trials in which SS is seen! irrespective of sub-type
nc_C_trl = xC_trl( ismember(xC_trl, (xNC_trl+1)) ) ;
ncerror_C_trl = xC_trl( ismember(xC_trl, (xNCerror_trl+1)) ) ;
c_C_trl = xC_trl( ismember(xC_trl, (xC_trl+1)) ) ;

perTrial_restricted_pdf_element = ones( numel(xC_trl), numel(SSDlist) );

if isempty( stairStep_speeding ) == 0    % if the subject knows that following a NC trial the SSD will speed up:
    % the knowledge of SSD can only be obtained from NCerror trials.
    if strcmpi( stairStep_speeding{1}, 'NCerror' ) == 1  % if we only want to incorporate speeding knowledge following NCerror in which SS was seen prior to response, then:
        stairedTrials = intersect( xC_trl, ncerror_C_trl ); % these are the trials to be staircased
    elseif  strcmpi( stairStep_speeding{1}, 'NC' ) == 1  % if we only want to incorporate speeding knowledge following NCerror in which SS was seen prior to response, then:
        stairedTrials = intersect( xC_trl, nc_C_trl ); % these are the trials to be staircased
    end
    for ii = 1:numel(stairedTrials) % for each of these trials do:
        currTrial = stairedTrials(ii);
        trialIdx_in_output = find( xC_trl == currTrial );
        prevSSD = trialInfo.SSD( currTrial-1 );
        prevSSD_idx = find( SSDlist == prevSSD ); % find the SSD index on previous trial (not SSDbin):
        % But this can include non-valid SSD indexes. We need to make
        % sure that only indeces within the existing range are
        % included:
        possibleSSDs = prevSSD_idx - abs( stairStep_speeding{2} ); % note: stairStep_speeding{2} contains the SSD index steps used in the session.
        possibleSSDs( ~ismember( possibleSSDs, 1:numel(SSDlist) ) ) = [];  % if the possibleSSDs falls outside of the allowed range, it should be eliminated.
        SSDlistidx = 1:numel(SSDlist);
        impossibleSSDs = SSDlistidx( ~ismember( SSDlistidx, possibleSSDs ) );
        perTrial_restricted_pdf_element( trialIdx_in_output, impossibleSSDs ) = 0;
        if sum( perTrial_restricted_pdf_element( trialIdx_in_output, : ) ) == 0 % if all SSDs are eliminated, it means that the current SSD was the earliest SSD.
                perTrial_restricted_pdf_element( trialIdx_in_output, 1 )  = 1;
        end
    end
end
clear stairedTrials
if isempty( stairStep_slowing ) == 0    % if the subject knows that following a C trial the SSD will slow down:
    % the knowledge of SSD can only be obtained from NCerror trials.
    if strcmpi( stairStep_slowing{1}, 'C' ) == 1  % if we want to incorporate speeding knowledge following C trials, then:
        stairedTrials = intersect( xC_trl, c_C_trl ); % these are the trials to be staircased
        for ii = 1:numel(stairedTrials) % for each of these trials do:
            clear possibleSSDs
            currTrial = stairedTrials(ii);
            trialIdx_in_output = find( xC_trl == currTrial );
            prevSSD = trialInfo.SSD( currTrial-1 );
            prevSSD_idx = find( SSDlist == prevSSD ); % find the SSD index on previous trial (not SSDbin):
            % But this can include non-valid SSD indexes. We need to make
            % sure that only indeces within the existing range are
            % included:
            possibleSSDs = prevSSD_idx + abs( stairStep_slowing{2} ); % note: stairStep_speeding{2} contains the SSD index steps used in the session.
            possibleSSDs( ~ismember( possibleSSDs, 1:numel(SSDlist) ) ) = [];  % if the possibleSSDs falls outside of the allowed range, it should be eliminated.
            SSDlistidx = 1:numel(SSDlist);
            impossibleSSDs = SSDlistidx( ~ismember( SSDlistidx, possibleSSDs ) );
            perTrial_restricted_pdf_element( trialIdx_in_output, impossibleSSDs ) = 0;
            if sum( perTrial_restricted_pdf_element( trialIdx_in_output, : ) ) == 0 % if all SSDs are eliminated, it means that the current SSD was the latest SSD.
                perTrial_restricted_pdf_element( trialIdx_in_output, numel(SSDlist) )  = 1;
            end
        end
    end
end









