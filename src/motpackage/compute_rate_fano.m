function info = compute_rate_fano(spmat,interval,cwindow)
%*************
%****** info = compute_rate_fano(spmat,interval,cwindow)
%*** inputs:
%****** spmat - cell matrix {1xC} with spike matrices for each attention
%******         condition, condition 1 - attended in 2 of 4 tracking
%******                    condition 2 - unattended in 2 of 4
%******                    condition 3 - unattended in 1 of 4
%****** interval - the desired interval of analysis to do significance
%******            testing for the rate and fano difference cond 1 vs 2
%****** cwindow - the size of the counting window
%******
%***** outputs:
%***** info.timebin{1xC} - time midpoints of counting intervals
%***** info.smorate{1xC} - gaussian smooth firing rate
%***** info.ratebin{1xC} - mean spike counts in bins
%***** info.varbin{1xC} -  variance spike counts in bins
%***** info.fanobin{1xC} - fano factor, NaN if no spikes in a bin
%*****
%***** info.crange - count windows falling in interval of analysis
%***** info.meanfano(C) - mean fano over range of analysis
%***** info.semfano(C) - sem of fano over range of analysis
%*****
%***** info.airate - AI of rate mod (A-U)/(A+U)
%***** info.ratepval - significance cond 1 vs 2 in firing rate diff
%***** info.aifano - AI of fano mod
%***** info.fanopval - significance cond 1 vs 2 in fano factor diff

  C = size(spmat,2);  % number of attention conditions
  info = [];
  
  %*************** compute time bins for counting windows **********
  timbin = [];
  %align first counting windows so one begins perfectly on interval of
  %***** the analysis specified in input
  tt = interval(1);
  dt = max(1,floor( tt - (cwindow * floor( tt/cwindow )) ));
  bsize = floor( (size(spmat{1,1},2)-dt) / cwindow);  % number of time bins
  begints = [];
  endints = [];
  midints = [];
  ik = 1;
  while (1)       
        base = (ik-1)*cwindow + dt;
        baso = base + cwindow;
        if (baso > size(spmat{1,1},2) )
            break;
        else
            ik = ik + 1;
        end
        midints = [midints (0.5*(base+baso))];
        begints = [begints base];
        endints = [endints baso];
  end
  %*******************************************************************
  %********* store all spike counts in array for later use in Monte-Carlo
  %*********    shuffling to estimate significance of Fano change *******
  trialpercond = size(spmat{1,1},1);  %should be identical # trials per cond
  trialtotal = C * trialpercond;
  cints = size(begints,2);
  storage = zeros(trialtotal,cints);
    
  %********* for each attention condition, compute rate, var, and fano in
  %*********   the specified sized count windows (cwindow) parameter
  for k = 1:C  % for attention condition
     
     startrial = (k-1)*trialpercond; 
     numtrials(k) = size(spmat{1,k},1); 
     rstatbin = [];  %mean and variance per counting interval
     
     for ik = 1:size(begints,2)   % for each counting interval
        
        %***************** 
        base = begints(ik);
        baso = endints(ik);  
        %**** get spike counts of intervals
        for jk = 1:numtrials(k)  
          tval = sum(sum( spmat{1,k}(jk,base:baso) ));  % raw spike counts
          storage( ((k-1)*trialpercond) + jk , ik ) = tval;
        end
        %******* compute mean and variance of counts
        rstatbin(1,ik) = mean( storage((startrial+1):(startrial+numtrials(k)),ik) );
        rstatbin(2,ik) = var( storage((startrial+1):(startrial+numtrials(k)),ik) );
        if (rstatbin(1,ik) > 0)
            rstatbin(3,ik) = (rstatbin(2,ik) / rstatbin(1,ik));  % Fano Factor
        else
            rstatbin(3,ik) = NaN;  % if no spike counts, Fano not defined
        end
     end
     
     %************* store results per attention condition C********
     info.timebin{k} = midints;  % time centers of count intervals in ms
     info.smorate{k} = compute_gauss_smooth(mean( spmat{1,k}),cwindow)*1000;  %smoothed rate
     info.ratebin{k} = rstatbin(1,:);
     info.varbin{k} = rstatbin(2,:);
     info.fanobin{k} = rstatbin(3,:);
  end

  %******* run Monte-Carlo to randomly permute trials between attention
  %******** conditions to assess the significance of the Fano Factor effects
  crange = find( (midints > interval(1)) & (midints < interval(end)) );
  info.crange = crange;
  %*****************
  atto = nanmean( info.fanobin{1}(crange) );
  utto = nanmean( info.fanobin{2}(crange) );
  aival = (atto-utto)/(atto + utto);  % AI value of Fano change in desired 
                                      % interval of analysis
  %*******************************************
  disp(sprintf('Computing Monte-Carlo Its on Counting Interval %d',cwindow));
  %**********
  XA = 1:numtrials(1);
  XB = (numtrials(1)+1):(numtrials(1)+numtrials(2));
  N = 100;
  aivals = zeros(1,N);
  for ii = 1:N
      %***************
      ax = randperm( (numtrials(1)+numtrials(2)) );
      XXA = ax(XA);  % randomly assign trials as attended cond 1
      XXB = ax(XB);  % randomly assign trials as unattended cond 2
      %************* compute ai value of mean fano for random assign
      amen = mean( storage(XXA,crange) );
      avar = var( storage(XXA,crange) );
      y = find( amen > 0);
      ffa = avar(y) ./ amen(y);  % all non-NAN (var/mean) ratios
      %*********************
      umen = mean( storage(XXB,crange) );
      uvar = var( storage(XXB,crange) );
      y = find( umen > 0);
      ffu = uvar(y) ./ umen(y);
      %*********************
      aa = mean(ffa);
      uu = mean(ffu);
      aivals(ii) = (aa-uu) / (aa+uu);
  end
  y = find( abs(aivals) >= abs(aival));   % fraction of values > observed
  %**************************
  info.aifano = aival;
  info.pfanoval = (size(y,2)/N);

  %********* significant effect of firing rate in analysis window?
  %***** compare 1st and 2nd conditions, attended and unattended 2 of 4
  attrate = (mean(spmat{1,1}(:,interval)'))';
  uttrate = (mean(spmat{1,2}(:,interval)'))';
  %*****************************************
  aa = mean(attrate);
  uu = mean(uttrate);
  info.airate = (aa-uu) / (aa + uu);
  info.prateval = ranksum(attrate,uttrate);  %simple ranksum over trials (rate significance)
  %*******************************************

  %***************************
  for k = 1:C
      info.meanfano(k) = nanmean( info.fanobin{k}(crange) );
      info.semfano(k) = nanstd( info.fanobin{k}(crange) )/sqrt(size(crange,2));
  end
  
  disp(sprintf('CountWin %d, AI rate %5.3f(p=%6.4f), AI fano %5.3f(p=%6.4f)',...
                 cwindow,info.airate,info.prateval,info.aifano,info.pfanoval));

return;