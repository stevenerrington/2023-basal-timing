function info = rate_normalized_autocor_power(data,interval,K,showplot)
%********* JUDE MITCHELL (jude@salk.edu):  11/20/2008
%******** function info = rate_normalized_autocor_power(data,interval,showplot)
%**********
%    one example:  info = rate_normalized_autocor_power('mnar4_u2',[],[],1);  % use defaults 
%
%                  load 'msiv3_u8';
%                  info = rate_normalized_autocor_power(data,data.sustained,30,1)
%
%                  load 'mnar4_u2';
%                  info = rate_normalized_autocor_power(data,data.sustained,30,1);
%
%                  load 'msir27_u3';
%                  info = rate_normalized_autocor_power(data,data.morepause,30,1);  
%
%***** general: computes the Poisson normalized autocorrelation
%*****          from the spikes in the specified interval as
%*****          Prob( spike(delay) | spike(0) == 1) divided by the
%*****          mean probability of spiking (average value would be 1
%*****          if it were a Poisson Process)

%*****
%*****          ALSO SMOOTHS THE AUTOCORRELATION FUNCTION DOWN BY
%*****          PROJECTING IT ONTO A LOG-TIME SPACED SET OF K BASIS
%*****          FUNCTIONS (similar to Keat et al,2001, details below)   

%*****          To factor out any time-locked slow trends in firing rate
%*****          per trial, it computes a correction to the autocorrelation
%*****          to eliminate the time-lock component.  it shuffles spikes
%*****          between trials keeping their time in the trial fixed
%*****          -- keeping it fixed relative to trial, shift predictor)
%*****          and subtracts off the autocorrelation from this shifted
%*****          version to eliminate slow trends in firing rate 
%*****          that are consistent in trials (it repeats the shuffling
%*****          and autocorrelation computation many times for better estimate)
%*****
%*****          In addition, computes the autocorrelation that would
%*****          be expected from a renewal process by shuffling ISI's
%*****          within the trial but keeping ISI distribution fixed
%*****          and evaluated to what extent ISI's are correlated
%
%*****          LASTLY, using this normalized autocorrelation, it 
%*****          computes the normalized power spectra .... the peak
%*****          at delay 0 is not included, and a Hanning Window is
%*****          applied to obtain some degree of frequency smoothing.
%*****
%** inputs:
%********** data - all relevent data fields for a neuron
%*********       do 'help datafile_format' to see details
%********** interval - interval of specific analysis, 1xN array of timepoints
%**********            - use data from this interval to evaluate
%**********              significant differences in rate and in Fano
%********** K -  to smooth autocorrelations, project them onto a basis
%**********      set of K filters.  Each filter is a raised bump that is
%**********      centered at one delay, with delays tiled evenly on a 
%**********      log-time axis .... so short delays represented with 
%**********      less smoothing and more smoothing at longer delays
%**********      (this is similar to spike history models, see Keat al al,
%**********       2001)  .. essentially, this is a kind of regularization
%**********       in which you assume that osciallations of any kind
%**********       persist in phase only a few cycles.
%**********   - if K = [], set it equal to 30, default 
%**********        if K is set too large, solution becomes non-singular
%********** showplot - to plot out results
%******* input:
%*****
%******  output:
%******   info.timediv{1xC} = time axis of autocorrelation
%******   info.isidist{1xC} = ISI distribution
%******   info.autocor{1xC} = autocorrelation per attention condition
%******   info.autocor_s{1xC} = Jacknife estimate of confidence intervals
%******   info.pautocor{1xC} = mean poisson autocor of matched firing rate
%******   info.sautocor{1xC} = std of poisson autocor matched firing rate
%******   info.nautocor{1xC} = autocorrelation normalized by Poisson rate
%%*****
%******   info.rautocor{1xC} = mean autocor of renewal process(ISI shuffle)
%******   info.srautocor{1xC} = std of many samples of renewal (is the
%******                         autocor of actual spikes really different)
%******   info.nrautocor{1xC} = normalized by Poisson flat height
%******
%******   info.poissest{1xC} = estimate of Poisson with trial rate trends
%******   info.pdeviate{1xC} = estimate of effect due to trial rate
%******   info.rate{1xC} = mean height of flat Poisson autocor
%******
%******   perform smoothing prior to computing error bars as well ****
%******   info.zautocor{1xC} = smoothed autocor fit
%******   info.zautocor_s{1xC} = smoothed est of Jacknife conf intervals
%******   info.zpautocor{1xC} -- also smoothed
%******   info.zsautocor{1xC} -- also smoothed
%******   info.znautocor{1xC} -- also smoothed
%******   info.zrautocor{1xC} -- also smoothed
%******   info.zsrautocor{1xC} -- also smoothed
%******   info.znrautocor{1xC} -- also smoothed
%******

%******  spectra output:
%******   info.freqdiv{1xC} = freq axis of power spectra
%******   info.autopow{1xC} = power spectra per attention condition
%******   info.autopow_s{1xC} = Jacknife estimate of confidence intervals
%%*****
%******   info.rautopow{1xC} = mean power spectra of renewal process(ISI shuffle)
%******   info.rautopow_s{1xC} = std of many samples of renewal (is the
%******                         power spectra of actual spikes really different)
%******
%****** Fano factor predicted for different counting intervals
%****** Use the same counting intervals as rate_fano_psth.m routine
%  info.cintervals = [12,17,25,35,50,71,100,141,200,283,400]; %ms
%  info.cfano{C}(interval) = predicted for each of C conditions
%  info.sfano{C}(interval) = jacknife estimates of predicted C's
%  info.rcfano{C}(interval) -- same for renewal process
%  info.rsfano{C}(interval) -- same for renewal process
%***********************
%**** 
%**** recap:
%****
%******** example usuage:
%****  info = rate_normalized_autocor_power('mnar4_u2',[],[],1); 
%*********

datalocation = 'datafiles';
unix = '//';

%******* if data is just a name, load that file, else it is structure
if (isfield(data,'label') == 0)
    disp(sprintf('Trying to load data file %s',data));
    load(sprintf('%s%s%s',datalocation,unix,data));
    disp(sprintf('Using default sustained interval for analysis'));
    interval = data.sustained;  %must use default interval then
end

%************************
info = [];  % returned data (large somewhat)
ip = [];    % temp storage (not returned data)

%********* get the single unit spikes for attended and unattended trials
C = max(data.attend);   % 2 or 3 conditions, or more?
                       % condition 1 is attended in RF during 2 of 4 track
                       % condition 2 is unattended in RF during 2 of 4
                       % condition 3 is unattended in RF during 1 of 4
spikes = cell(1,C);   % single unit attended spikes (in sustatined period

%*****************************************
TP = 0.5;  % discretization of time, 0.5 ms
xstart = interval(1);
xend = interval(end);

%*********** build spike array of desired time precision ********
for trial = 1:size(data.trials,2)
   cubo = data.attend(trial);
   tspikes = zeros(1,floor( (xend-xstart)/TP ));
   exact_times = data.exactspikes{trial};
   y = find( (exact_times >= xstart) & (exact_times < (xend-TP)) );
   y = round( (exact_times(y) - xstart + TP) / TP );
   tspikes(y) = 1;
   
   if (1)
     spikes{cubo} = [spikes{cubo} ; tspikes];
     
   else % if you want to test on an artificial train
        % to test out algorithm properties of rate normalization
        
     rates = [0.1,0.03,0.01];  % test 3 diff rates to see not an issue
       
     tt = 1:size(tspikes,2);
     rr = ones(size(tt));
     rphase = rand*2*pi;
     
     wfrec = 40;  % insert a signal at 40 hz for example 
     freco = ((1000/wfrec)/TP);
     rr = rr + 0.5 * cos( (tt*2*pi)/freco + rphase);  % exact 10hz signal
     %******** include a slow phase locked per trial component also ***
     rr = rr + 0.5 * cos( (tt*2*pi)/(size(tspikes,2)*2) );
     %*****************************************************
     
     tspikes = (rand(1,size(tspikes,2)) < (rr*rates(cubo)) );
     spikes{cubo} = [spikes{cubo} ; tspikes];   
  
   end

end

%************** set smoothing parameter K ...
if (isempty(K))
    K = 30;
end

%*****************************************************************
spiker = spikes;
info.cfano = cell(1,C);  % autocor predicted FF
info.sfano = cell(1,C);  % jacknife on predicted
info.rcfano = cell(1,C);  % renewal autocor predicted FF
info.rsfano = cell(1,C);  % renewal jacknife on predicted
%*************************************
for kk = 1:C
    
    %********** compute autocorrelation and Poisson normalized
    tempinfo = compute_autocor_renewal(spikes{kk},TP,K);
    info.timediv{kk} = tempinfo.timediv;
    info.isidist{kk} = tempinfo.isidist;
    info.autocor{kk} = tempinfo.autocor;
    info.autocor_s{kk} = tempinfo.autocor_s;
    %***************************************
    ip.poisscor{kk} = tempinfo.poisscor;   % store temporary in 'ip' structure
    ip.jackcor{kk} = tempinfo.jackcor;
    ip.jackrate{kk} = tempinfo.jackrate;
    ip.renewcor{kk} = tempinfo.renewcor;
    ip.renewrate{kk} = tempinfo.renewrate;
    %******** here the Poisson is known to have flat autocor, so constrain
    info.pautocor{kk} = ones(size(tempinfo.pautocor)) * mean(tempinfo.pautocor);
    info.sautocor{kk} = ones(size(tempinfo.sautocor)) * mean(tempinfo.sautocor);
    %*********************************************
    info.poissest{kk} = tempinfo.poissest;
    info.pdeviate{kk} = tempinfo.pdeviate;
    %*********
    info.rate(kk) = tempinfo.rate;
    info.nautocor{kk} = (info.autocor{kk} / info.rate(kk) );
    %*********** added computations for renewal autocorrelation **
    info.rautocor{kk} = tempinfo.rautocor;
    info.srautocor{kk} = tempinfo.srautocor;
    info.nrautocor{kk} = (info.rautocor{kk} / info.rate(kk) );
    %************************************************************
    
    %******** store smoothed versions **************************
    info.zautocor{kk} = tempinfo.zautocor;
    info.zautocor_s{kk} = tempinfo.zautocor_s;
    info.zpautocor{kk} = tempinfo.zpautocor;  %the size of error bar will shrink with smoothing
    info.zsautocor{kk} = tempinfo.zsautocor;
    info.nautocor{kk} = (info.zautocor{kk} / info.rate(kk));
    %*********** added features for renewal autocorrelation ****
    info.zrautocor{kk} = tempinfo.zrautocor;
    info.zsrautocor{kk} = tempinfo.zsrautocor;
    info.znrautocor{kk} = (info.zrautocor{kk} / info.rate(kk));
    
    %********** NOW TAKE WHAT YOU GOT, AND USE AUTOCORRELATIONS TO COMPUTE
    %********** THE SPECTRAS CORRESPONDINGLY
    
    
     %********** power spectra from autocorrelation
     NT = size(spikes{kk},1);
     TT = size(spikes{kk},2);
     rate = mean(mean(spikes{kk}));
     tempinfo = compute_power_from_auto(info.autocor{kk},ip.jackcor{kk},ip.jackrate{kk},...
                           ip.poisscor{kk},ip.renewcor{kk},info.rate(kk),NT,TT,TP);
    
     info.pautopow{kk} = tempinfo.pautopow;
     info.pautopow_s{kk} = tempinfo.pautopow_s;
     %*************** all measures normalized for Poisson
     info.freqdiv{kk} = tempinfo.freqdiv;
     info.autopow{kk} = tempinfo.autopow;
     info.autopow_s{kk} = tempinfo.autopow_s;
     %*********** added computations for renewal process **
     info.rautopow{kk} = tempinfo.rautopow;
     info.rautopow_s{kk} = tempinfo.rautopow_s;
     %************************************************************
   
     %********* Given the autocorrelation, what does it predict
     %********* for the change in FF with counting interval?
     info.cintervals = [12,17,25,35,50,71,100,141,200,283,400]; %ms
     for k = 1:size(info.cintervals,2)
        T = ceil( info.cintervals(k) / TP);
        
        info.bTT(k) = T;
        info.bautocor{kk} = info.autocor{kk};
        info.brate(kk) = info.rate(kk);
        
        val = compute_FF_from_auto(info.autocor{kk},info.rate(kk),T);
        info.cfano{kk} = [info.cfano{kk} val];
        list = [];
        NN = size(ip.jackcor{kk},1);
        for tt = 1:NN  %jacknife estimates
            val = compute_FF_from_auto(ip.jackcor{kk}(tt,:),ip.jackrate{kk}(tt),T);
            list = [list val];
        end
        sval = sqrt( (NN-1) * var( list ) );
        info.sfano{kk} = [info.sfano{kk} sval];
        
        %********** and what about for a simple renewal process
        val = compute_FF_from_auto(info.rautocor{kk},info.rate(kk),T);
        info.rcfano{kk} = [info.rcfano{kk} val];
        list = [];
        NN = size(ip.renewcor{kk},1);
        for tt = 1:NN  %jacknife estimates
            val = compute_FF_from_auto(ip.renewcor{kk}(tt,:),ip.renewrate{kk}(tt),T);
            list = [list val];
        end
        sval = std(list) / sqrt(NN); % indep samples, not jacknifes
        info.rsfano{kk} = [info.rsfano{kk} sval];
        
     end     
     %**************************
end
%******************************************************************

%************ plot the spike rasters and mean firing rates, and fano
if (showplot == 1)
       
   figure;
   %**************** plot spike trains of interest on left ******
   subplot('position',[0.1 0.4 0.3 0.5]);
   plot_spike_raster(spiker,xstart,xend,TP);
   V = axis;
   axis([xstart xend V(3) V(4)]);
   grid on;
   ylabel('Trial Number');
   title(sprintf('Unit %s rasters',data.name));
   %*************
   subplot('position',[0.1 0.1 0.3 0.2]);
   smooth_window = (12.5/TP);  % give sigma of 12.5ms
   plot_mean_psth(spiker,smooth_window,xstart,xend,TP);
   axis tight;
   V = axis;
   maxo = V(4);
   axis([xstart xend 0 (V(4)*1.25)]);
   plot([interval(1),interval(1)],[V(3),V(4)],'k-'); hold on;
   plot([interval(end),interval(end)],[V(3),V(4)],'k-'); hold on;
   ylabel('Firing Rate');
   xlabel('Time (ms)');

   %********* plot autocorrelations for each condtion along
   %********* with Poisson distributions of matched rate
   awid = 0.65;
   bwid = (awid/C);
   col = 'rbg';
   %******* find maximum for vertical scale match across plots *****
   maxo = 0;
   for kk = 1:C
       maxo = max( maxo, max(info.autocor{kk}) );
   end
   maxo = maxo * 1.1;
   %*********************
   for kk = 1:C
      
      gcol = [0.5,0.5,0.5];  % plot rate matched Poisson in gray
      
      %************* plot first 50 ms linear scale
      xx = 1:(100/TP);
      subplot('position',[0.5 (1.0-((bwid+0.07)*kk)) 0.2 bwid]);
      H = plot(info.timediv{kk}(xx),info.autocor{kk}(xx),['k.']); hold on;
      
      %********* plot rate matched poisson
      H = plot(info.timediv{kk}(xx),info.pautocor{kk}(xx),['c-']);
      set(H,'Color',gcol);
      H = plot(info.timediv{kk}(xx),(info.pautocor{kk}(xx) + 2 * info.sautocor{kk}(xx)),'c-');
      set(H,'Color',gcol);
      H = plot(info.timediv{kk}(xx),(info.pautocor{kk}(xx) - 2 * info.sautocor{kk}(xx)),'c-');
      set(H,'Color',gcol);
      
      %********* plot matched renewal process autocorrelation               
      H = plot(info.timediv{kk}(xx),info.rautocor{kk}(xx),[col(kk),'-']);
      set(H,'Linewidth',2);
      H = plot(info.timediv{kk}(xx),(info.rautocor{kk}(xx) + 2 * info.srautocor{kk}(xx)),...
                         [col(kk),'-']);
      H = plot(info.timediv{kk}(xx),(info.rautocor{kk}(xx) - 2 * info.srautocor{kk}(xx)),...
                         [col(kk),'-']);
      
      %********** draw actual data last
      H = plot(info.timediv{kk}(xx),info.zautocor{kk}(xx),'k-');
      set(H,'Linewidth',2);
      H = plot(info.timediv{kk}(xx),(info.zautocor{kk}(xx) + 2 * info.zautocor_s{kk}(xx)),'k-');
      H = plot(info.timediv{kk}(xx),(info.zautocor{kk}(xx) - 2 * info.zautocor_s{kk}(xx)),'k-');
      %******************************
      
      axis tight;
      V = axis;
      axis([0 100 0 maxo]);
      xlabel('Delay (ms)');
      ylabel('Probability');
      
      %************* plot whole range on log scale
      xx = 1:size(info.timediv{kk},2);
      rr = (1/info.rate(kk));
      ra = (1/min(info.rate));
      subplot('position',[0.75 (1.0-((bwid+0.07)*kk)) 0.2 bwid]);
      H = semilogx(info.timediv{kk}(xx),rr*info.zautocor{kk}(xx),'k-'); hold on;
      set(H,'Linewidth',1);
      
      %************ plot rate matched poisson 
      H = semilogx(info.timediv{kk}(xx),rr*info.zpautocor{kk}(xx),['c-']);
      set(H,'Color',gcol);
      H = semilogx(info.timediv{kk}(xx),rr*(info.zpautocor{kk}(xx) + 2 * info.zsautocor{kk}(xx)),'c-');
      set(H,'Color',gcol);
      H = semilogx(info.timediv{kk}(xx),rr*(info.zpautocor{kk}(xx) - 2 * info.zsautocor{kk}(xx)),'c-');
      set(H,'Color',gcol);
                     
      %********* plot matched renewal process autocorrelation               
      H = semilogx(info.timediv{kk}(xx),rr*info.zrautocor{kk}(xx),[col(kk),'-']);
      set(H,'Linewidth',2);
      H = semilogx(info.timediv{kk}(xx),rr*(info.zrautocor{kk}(xx) + 2 * info.zsrautocor{kk}(xx)),...
                         [col(kk),'-']);
      H = semilogx(info.timediv{kk}(xx),rr*(info.zrautocor{kk}(xx) - 2 * info.zsrautocor{kk}(xx)),...
                         [col(kk),'-']);
      
      %******** plot original process on top ***************
      H = semilogx(info.timediv{kk}(xx),rr*info.zautocor{kk}(xx),'k-'); hold on;
      set(H,'Linewidth',2);
      H = semilogx(info.timediv{kk}(xx),rr*(info.zautocor{kk}(xx) + 2 * info.zautocor_s{kk}(xx)),'k-');
      H = semilogx(info.timediv{kk}(xx),rr*(info.zautocor{kk}(xx) - 2 * info.zautocor_s{kk}(xx)),'k-');
      %******************************
      
      axis tight;
      V = axis;
      axis([V(1) V(2) 0 V(4)]); %(ra*maxo)]);
      semilogx([50,50],[0,V(4)],'k--'); %(ra*maxo)],'k--');
      xlabel('Delay (ms)');
      ylabel('Norm Prob.');   
   end
    
   %*************** NOW FOR A SECOND PLOT, THAT WILL BE THE SPECTRUMS
   
   figure;
   %**************** plot spike trains of interest on left ******
   subplot('position',[0.1 0.4 0.3 0.5]);
   plot_spike_raster(spiker,xstart,xend,TP);
   V = axis;
   axis([xstart xend V(3) V(4)]);
   grid on;
   ylabel('Trial Number');
   title(sprintf('Unit %s rasters',data.name));
   %*************
   subplot('position',[0.1 0.1 0.3 0.2]);
   smooth_window = (12.5/TP);  % give sigma of 12.5ms
   plot_mean_psth(spiker,smooth_window,xstart,xend,TP);
   axis tight;
   V = axis;
   maxo = V(4);
   axis([xstart xend 0 (V(4)*1.25)]);
   plot([interval(1),interval(1)],[V(3),V(4)],'k-'); hold on;
   plot([interval(end),interval(end)],[V(3),V(4)],'k-'); hold on;
   ylabel('Firing Rate');
   xlabel('Time (ms)');

   %********* plot autocorrelations for each condtion along
   %********* with Poisson distributions of matched rate
   awid = 0.65;
   bwid = (awid/C);
   col = 'rbg';
   %******* find maximum for vertical scale match across plots *****
   maxo = 0;
   mino = 100000;
   for kk = 1:C
       maxo = max( maxo, max(info.autopow{kk}(2:end)) );
       mino = min( mino, min(info.autopow{kk}(2:end)) );
   end
   diffo = (maxo-mino);
   maxo = maxo + 0.5*diffo;
   mino = mino - 0.5*diffo;
   %*********************
   for kk = 1:C
      
      gcol = [0.5,0.5,0.5];  % plot rate matched Poisson in gray
      
      %************* plot first 50 hz linear scale
      xx = find( info.freqdiv{kk} <= 50); 
      
      subplot('position',[0.5 (1.0-((bwid+0.07)*kk)) 0.2 bwid]);
      H = plot(info.freqdiv{kk}(xx),info.autopow{kk}(xx),['k.']); hold on;
       
      %******** plot matched renewal process autocorrelation               
      H = plot(info.freqdiv{kk}(xx),info.rautopow{kk}(xx),[col(kk),'-']);
      set(H,'Linewidth',2);
      H = plot(info.freqdiv{kk}(xx),(info.rautopow{kk}(xx) + 2 * info.rautopow_s{kk}(xx)),...
                         [col(kk),'-']);
      H = plot(info.freqdiv{kk}(xx),(info.rautopow{kk}(xx) - 2 * info.rautopow_s{kk}(xx)),...
                         [col(kk),'-']);
      
      %*********** Poisson flatline ************ (varies by # spikes)               
      H = plot(info.freqdiv{kk}(xx),info.pautopow{kk}(xx),[col(kk),'-']);
      set(H,'Linewidth',2);
      set(H,'Color',[0.5,0.5,0.5]);
      H = plot(info.freqdiv{kk}(xx),(info.pautopow{kk}(xx) + 2 * info.pautopow_s{kk}(xx)),...
                         [col(kk),'-']);
      set(H,'Color',[0.5,0.5,0.5]);
      H = plot(info.freqdiv{kk}(xx),(info.pautopow{kk}(xx) - 2 * info.pautopow_s{kk}(xx)),...
                         [col(kk),'-']);
      set(H,'Color',[0.5,0.5,0.5]);
      %*************************************************************
      
      %********** draw actual data last
      H = plot(info.freqdiv{kk}(xx),info.autopow{kk}(xx),'k-');
      set(H,'Linewidth',2);
      H = plot(info.freqdiv{kk}(xx),(info.autopow{kk}(xx) + 2 * info.autopow_s{kk}(xx)),'k-');
      H = plot(info.freqdiv{kk}(xx),(info.autopow{kk}(xx) - 2 * info.autopow_s{kk}(xx)),'k-');
      %******************************
    
      axis tight;
      V = axis;
      axis([info.freqdiv{kk}(1) info.freqdiv{kk}(size(xx,2)) mino maxo]);
      xlabel('Frequency (hz)');
      ylabel('Power');
         
      %************* plot whole range on log scale, use smoothed data
      
      xx = 1:size(info.freqdiv{kk},2);   
      subplot('position',[0.75 (1.0-((bwid+0.07)*kk)) 0.2 bwid]);  
      H = semilogx(info.freqdiv{kk}(xx),info.autopow{kk}(xx),'r-'); hold on;
      set(H,'Linewidth',1);
                    
      %********* plot matched renewal process autocorrelation               
      H = semilogx(info.freqdiv{kk}(xx),info.rautopow{kk}(xx),[col(kk),'-']);
      set(H,'Linewidth',2);
      H = semilogx(info.freqdiv{kk}(xx),(info.rautopow{kk}(xx) + 2 * info.rautopow_s{kk}(xx)),...
                         [col(kk),'-']);
      H = semilogx(info.freqdiv{kk}(xx),(info.rautopow{kk}(xx) - 2 * info.rautopow_s{kk}(xx)),...
                         [col(kk),'-']);
      
      %*********** Poisson flatline ************ (varies by # spikes)               
      H = plot(info.freqdiv{kk}(xx),info.pautopow{kk}(xx),[col(kk),'-']);
      set(H,'Linewidth',2);
      set(H,'Color',[0.5,0.5,0.5]);
      H = plot(info.freqdiv{kk}(xx),(info.pautopow{kk}(xx) + 2 * info.pautopow_s{kk}(xx)),...
                         [col(kk),'-']);
      set(H,'Color',[0.5,0.5,0.5]);
      H = plot(info.freqdiv{kk}(xx),(info.pautopow{kk}(xx) - 2 * info.pautopow_s{kk}(xx)),...
                         [col(kk),'-']);
      set(H,'Color',[0.5,0.5,0.5]);
      %*************************************************************
      
                     
      %******** plot original process on top ***************
      H = semilogx(info.freqdiv{kk}(xx),info.autopow{kk}(xx),'k-'); hold on;
      set(H,'Linewidth',2);
      H = semilogx(info.freqdiv{kk}(xx),(info.autopow{kk}(xx) + 2 * info.autopow_s{kk}(xx)),'k-');
      H = semilogx(info.freqdiv{kk}(xx),(info.autopow{kk}(xx) - 2 * info.autopow_s{kk}(xx)),'k-');
      %******************************
      
      axis([info.freqdiv{kk}(1) info.freqdiv{kk}(end) mino maxo]);
      semilogx([info.freqdiv{kk}(50),info.freqdiv{kk}(50)],[mino,maxo],'k--');
      xlabel('Frequency (hz)');
      ylabel('Norm Power.');
      
   end
   
   
   figure;
   subplot(2,2,1);  % autocorrelation prediction ******
   col = 'rbg';
   for kk = 1:C
      semilogx(info.cintervals,info.cfano{kk},[col(kk),'o-']); hold on;
      semilogx(info.cintervals,(info.cfano{kk} + 2*info.sfano{kk}),[col(kk),':']);
      semilogx(info.cintervals,(info.cfano{kk} - 2*info.sfano{kk}),[col(kk),':']);
   end
   semilogx(info.cintervals,ones(size(info.cintervals)),'k-');
   xlabel('Counting Interval');
   ylabel('Predicted FF');
   title('Autocorrelation to Fano');
  
   subplot(2,2,2);  % autocorrelation prediction ******
   col = 'rbg';
   for kk = 1:C
      semilogx(info.cintervals,info.rcfano{kk},[col(kk),'s-']); hold on;
      semilogx(info.cintervals,(info.rcfano{kk} + 2*info.rsfano{kk}),[col(kk),':']);
      semilogx(info.cintervals,(info.rcfano{kk} - 2*info.rsfano{kk}),[col(kk),':']);
   end
   semilogx(info.cintervals,ones(size(info.cintervals)),'k-');
   xlabel('Counting Interval');
   ylabel('Predicted Renew FF');
   title('Autocorrelation to Fano');
  
   subplot(2,2,3);  % autocorrelation prediction ******
   col = 'rbg';
   for kk = 1:C
      semilogx(info.cintervals,info.cfano{kk},[col(kk),'o-']); hold on;
      semilogx(info.cintervals,info.rcfano{kk},[col(kk),'s-']); hold on;
   end
   semilogx(info.cintervals,ones(size(info.cintervals)),'k-');
   xlabel('Counting Interval');
   ylabel('Predicted FF');
   title('Autocor vs Renewal');
   
end

return;



