function [coho,scoho,phaso,urcoho,srcoho,ifcoher] = compute_fries_coherence_match(speco,spiko,Win,MinCount)
%******* [coho,scoho,urcoho,srcoho,ifcoher] = compute_fries_coherence_match(speco,spiko,Win)
%****** computes the coherence value using spike-triggered LFP similar to 
%****** that of Fries et al, 2001. in 100ms Hanning windowed segments 
%****** ALSO, to rate normalized, total set of spikes is divided into
%****** independent permutations of size MinCount spikes
%******
%****** inputs:
%******    speco - a MxT array where M is trials and T is time in ms
%******    spiko - a MxT array with same dimensions, 0 or 1 for spikes
%******    Win - a window around which to compute LFP segments 
%******    MinCount - number of spikes to use in Fries comp per permutation
%******             - if set to 0, don't rate normalize, run entire set in
%******               of spikes.
%****** outputs:
%******    coho - 1xF array of coherence per frequencies F
%******    scoho - std of the independent permutes in analysis
%******    urcoho - mean coherence of randomly shuffled trials
%******    srcoho - std of coherence from random shuffles
%******    ifcoher - list of frequency values, 1xF

  %**** compute number of spikes, must be at least 200 to run
  if (MinCount == 0)
      yspikes = find( spiko > 0);
      PN = size(yspikes,1);
      PRR = 1:size(yspikes,1);
      NPERM = 1;
      MinCount = PN;   % include every single spike
  else
      sumo = sum(sum(spiko));
      yspikes = find( spiko > 0 );
      NPERM = floor( sumo / MinCount );   % number of random permutations
      PN = size(yspikes,1);  % returns as a column of numbers
      PRR = randperm(PN);
  end
  
  %************* random permutations for shuffle corrected trials
  RB = 20;
  trialperm = [];
  for i = 1:RB
      trialperm = [trialperm ; randperm(size(speco,1))];  %random permutes of trial order
  end
  
  %*********** prep multi-taper fft ***************
  TT = size(speco,2);
  N = Win;
  if (N>(TT/4))
      N = floor(TT/4);
      disp(sprintf('Window size reduced to 1/4 total interval (%d to %d ms)',Win,N));
  end
  Trials = size(speco,1);
  %*******************
  TTa = 1+floor(Win/2);   %tighten up interval of analysis so Win does not fall outside
  TTb = TT-floor(Win/2);
  taper = hanning(Win,'symmetric')';
  %********** compute range of frequencies for FFT analysis
  pad = 0;
  fpass = [0.003 0.088];   % our LFP has a restricted range due to hardware filter
  Fs = 1;
  nfft=2^(nextpow2(N));
  df=Fs/nfft;
  f=0:df:Fs; % all possible frequencies
  f=f(1:nfft);
  findx=find(f>=fpass(1) & f<=fpass(end));
  f=f(findx);
  %**********************
  
  cohopool = [];     % LFP coherences on spike subsets
  urcohopool = [];   % LFP coherences over random permutes of trials (shuffle corrections)
  phaseopool = [];
  %****************
  for uber = 1:NPERM
      
    %********** do analysis many times on different permutes of same data **    
    spika = zeros(size(spiko));
    aa = 1 + ((uber-1)*MinCount);
    bb = (uber*MinCount);
    spika( yspikes(PRR(aa:bb)) ) = 1;   % select random subset of MinCount spikes
    disp(sprintf('Computing Subset %d of %d (contains %d spikes)',uber,NPERM,MinCount));
    
    %******************
    spikecount = 0;
    lfp_pow = [];
    lfp_sta = [];   % time rep of LFP
    rlfp_sta = cell(1,RB);  % random permutations (shuffle correction)
  
    %********* run through all trials, compute for each spike in the
    %********* subset of spikes the LFP segment, its FFT, power etc...
    for ii = 1:Trials
      for tt = TTa:TTb
         if (spika(ii,tt)>0)
            spikecount = spikecount + 1;
            toa = (tt-floor(Win/2));
            tob = toa + Win - 1;
            lfper = speco(ii,toa:tob) .* taper;
            %*************************
            J1=fft(lfper,nfft);
            J1=J1(1,findx);
            %*************************
            if (spikecount == 1)
                lfp_pow = conj(J1) .* J1;  % power spectrum 
                lfp_sta = J1;  
                %****************
                for rr = 1:RB
                   lfper = speco(trialperm(rr,ii),toa:tob);
                   lfper = lfper .* taper;
                   jj1 = fft(lfper,nfft);
                   jj1 = jj1(1,findx);
                   rlfp_sta{1,rr} = jj1;
                end
            else
                lfp_pow = lfp_pow + conj(J1) .* J1;   %Fries 2001 take average of power spectra
                lfp_sta = lfp_sta + J1;
                %****************
                for rr = 1:RB
                   lfper = speco(trialperm(rr,ii),toa:tob);
                   lfper = lfper .* taper;
                   jj1 = fft(lfper,nfft); 
                   jj1 = jj1(1,findx);
                   rlfp_sta{1,rr} = rlfp_sta{1,rr} + jj1;
                end
            end    
                    
         end
      end
    end  % for all trials    
    %**********************************
  
    %********** compute the coherence value
    lfp_sta = (lfp_sta / spikecount);
    S1 = sqrt(lfp_pow / spikecount);
    S12 = abs(lfp_sta);
    phaseo = lfp_sta ./ abs(lfp_sta);
    coho = (S12 ./ S1);
    
    %********* compute null distribution coherences ****
    %****** as average of several randomly permuted trials
    rcoho = [];
    for rr = 1:RB
      rlfp_sta{rr} = (rlfp_sta{rr}/spikecount);
      jja = abs(rlfp_sta{rr}); 
      cobo = (jja ./ S1);
      rcoho = [rcoho ; cobo];
    end
    urcoho = mean(rcoho);
  
    %********* pool the different permutes for later *********
    cohopool = [cohopool ; coho];
    urcohopool = [urcohopool ; urcoho];
    phaseopool = [phaseopool ; phaseo];
  end
  
  ifcoher = f * 1000;
  if (NPERM < 1)  % require min set of samples to estimate cohere
      disp(sprintf('Ret Nan only %d spikes',spikecount));
      coho = NaN * ones(1,size(f,2));
      scoho = NaN * ones(1,size(f,2));
      urcoho = NaN * ones(1,size(f,2));
      srcoho = NaN * ones(1,size(f,2));
      phaso = NaN * ones(1,size(f,2));
  else
    if (NPERM > 1)
      coho = mean(cohopool);
      scoho = std(cohopool) / sqrt( NPERM );
      urcoho = mean(urcohopool);
      srcoho = std(urcohopool) / sqrt( NPERM );
      phaso = mean(phaseopool);
    else
      coho = cohopool;
      phaso = phaseopool;
      urcoho = urcohopool;
      %******** punt on std if too few spikes - could do a real jacknife
      %******** but leave it for later
      scoho = NaN * ones(1,size(f,2));
      srcoho = NaN * ones(1,size(f,2));
    end
  end
  
return;

