function info = rate_normalized_coherence(data,lfplabel,interval,window,showplot)
%********* JUDE MITCHELL (jude@salk.edu):  11/20/2008
%******** function info = rate_normalized_coherence(data,lfplabel,interval,window,showplot)
%**********
%    one example:  load 'msiv3_u8';
%                  info = rate_normalized_coherence(data,'LFP1',data.sustained,100,1)
%
%                  load 'mnar4_u2';
%                  info = rate_normalized_coherence(data,'LFP1',data.sustained,100,1);
%
%                  load 'msir27_u3';
%                  info = rate_normalized_coherence(data,'LFP2',data.morepause,100,1);  
%
%***** general: computes the coherence in (window size ms, 100 default) hanning windows 
%*****          hopefully the same as in Womelsdorf and Fries
%*****  3/12/08: it runs coherence analysis off the isolated unit
%*****  in the data input 'Su1' with the labeled LFP channel (lpflabel) 
%****** and plots the computed coherence for attended and unattended trials
%*****  NOTE: data has been sorted of LFP1 is same lfp channel as the
%*****        isolated unit was recorded from, and same for MU1 mulit-unit
%** inputs:
%********** data - all relevent data fields for a neuron
%**********    do 'help datafile_format' to see data format
%********** lfplabel - lfp to do spike-lfp coherence, 1 is same lfp
%**********              'LFP1', and 'LFP2' would be nearest off electrode
%**********              if a second electrode is available
%********** interval - interval of analysis, 1xN array of timepoints
%********** window - duration of LFP window around each spike for FFT
%********** showplot - to plot out results
%*****
%****** showplot - set this to 1 to see the results plotted out
%*****
%******  output:
%******      info.acoho  - attended coherence [1 x F]
%******      info.ascoho - std from permutes of estimate
%******      info.arcoho  - shuffled trials, attended coherence [1 x F]
%******      info.arscoho - shuffled trials, std from permutes of estimate
%******      info.afreq - frequencies [1 x F]
%******      info.ucoho  - attended coherence [1 x F]
%******      info.uscoho - std from jacknife of estimate
%******      info.urcoho  - shuffled trials, attended coherence [1 x F]
%******      info.usrcoho - shuffled trials, std from jacknife 
%******      info.ufreq - frequencies [1 x F]
%********* 
%****** recap:
%********
%******** function info = rate_normalized_coherence(data,lfplabel,interval,window,showplot)
%**********
%    one example:  info = ...
%                    rate_normalized_coherence('mnar4_u2','LFP1',[],200,1);
%
%                  load 'msiv3_u8';
%                  info = rate_normalized_coherence(data,'LFP1',...
%                               data.sustained,100,1)

datalocation = 'datafiles';  % directory with data files

info = [];

%******* if data is just a name, load that file, else it is structure
if (isfield(data,'label') == 0)
    disp(sprintf('Trying to load data file %s',data));
    load(sprintf('%s\\%s',datalocation,data));
    disp(sprintf('Using default sustained interval for analysis'));
    interval = data.sustained;  %must use default interval then
end

%*********** locate su1
it_su = -1;
it_lfp = -1;
for zz = 1:size(data.label,2)
        if (strcmp(data.label{zz},'SU1'))
            it_su = zz;
        end
        if (strcmp(data.label{zz},lfplabel))
            it_lfp = zz;
        end
end
if ( (it_su == -1) | (it_lfp == -1) )
    disp(sprintf('Unable to identify SU1 or lfp label %s',lfplabel));
    info = [];
    return;
end

%********* get the single unit spikes for attended and unattended trials
CNUM = max(data.attend);   % 2 or 3 conditions, or more?
spikes = cell(1,CNUM);   % single unit attended spikes (in sustatined period
lfp = cell(1,CNUM);
for trial = 1:size(data.trials,2)
   cubo = data.attend(trial);
   spikes{cubo} = [spikes{cubo} ; data.trials{trial}(it_su,:)];
   lfp{cubo} = [lfp{cubo} ; data.trials{trial}(it_lfp,:)];
end
%************ subtract out mean LFP's across trials ********
lfpbef = cell(1,CNUM);
for kk = 1:CNUM
  lfpbef{kk} = lfp{kk};
  ameanlfp = mean(lfp{kk});
  for ii = 1:size(lfp{kk},1)
    lfp{kk}(ii,:) = lfp{kk}(ii,:) - ameanlfp;
    meno = mean(lfp{kk}(ii,:));  % subtract out mean inside trial
    lfp{kk}(ii,:) = lfp{kk}(ii,:) - meno;
  end
end
%*****************************************************************

%************ plot the spike rasters and mean firing rates to sanity check
%************ and also show the local fields and mean local fields 
if (showplot == 1)
   
   spiker = spikes;
   
   %****************
   disp('Plotting rastergrams (slow) ...');
   subplot('position',[0.1 0.4 0.4 0.55]);
   plot_spike_raster(spiker,1,size(spikes{1,1},2),[]);
   V = axis;
   axis([0 size(spikes{1},2) V(3) V(4)]);
   grid on;
   ylabel('Trial Number');
   title(sprintf('Unit %s rasters',data.name));
   %*************
   subplot('position',[0.1 0.1 0.4 0.3]);
   smooth_window = 25;  % give sigma of 12.5ms
   plot_mean_psth(spiker,smooth_window,1,size(spikes{1,1},2),[]);
   V = axis;
   axis([0 size(spikes{1},2) V(3) V(4)]);
   plot([interval(1),interval(1)],[V(3),V(4)],'k-'); hold on;
   plot([interval(end),interval(end)],[V(3),V(4)],'k-'); hold on;
   ylabel('Firing Rate');
   xlabel('Time (ms)');
   
   spiker = lfpbef;
   %****************
   disp('Plotting lfps per trial (slow) ...');
   subplot('position',[0.57 0.4 0.4 0.55]);
   plot_lfp_raster(spiker);
   V = axis;
   axis([0 size(spikes{1},2) V(3) V(4)]);
   grid on;
   ylabel('Trial Number');
   title(sprintf('Unit %s lfp %s',data.name,lfplabel));
   %*************
   subplot('position',[0.57 0.1 0.4 0.3]);
   smooth_window = 2;  % give sigma of 12.5ms
   plot_mean_psth(spiker,smooth_window,1,size(spiker{1,1},2),[]);
   V = axis;
   axis([0 size(spikes{1},2) V(3) V(4)]);
   plot([interval(1),interval(1)],[V(3),V(4)],'k-'); hold on;
   plot([interval(end),interval(end)],[V(3),V(4)],'k-'); hold on;
   ylabel('LFP');
   xlabel('Time (ms)');
   
end



%**************** now call for the coherence estimates ***********
Win = window;  % use specified hanning tapered windows
MinCount = 200;  % use minimum 200 spikes per permuted estimate
                 % you may desire even larger number if you have
                 % a large number of spikes on average in your data
                 % (it reduces height of baseline coherence from shuffled
                 %   trials as you can include more spikes into analysis)
%************************************************
for cubo = 1:CNUM
 disp(sprintf('Computing coherence on group %d trials',cubo));
 [coho{cubo},scoho{cubo},phaso{cubo},rcoho{cubo},srcoho{cubo},freq{cubo}] = ...
    compute_fries_coherence_match(lfp{cubo}(:,interval),...
                          spikes{cubo}(:,interval),...
                          Win,MinCount);
end
%*********** store results *********
info.coho = coho;
info.scoho = scoho;
info.phaso = phaso;
info.rcoho = rcoho;
info.srcoho = srcoho;
info.freq = freq;
%***********************************

if (showplot == 1)
   figure;
   colo = 'rbgy';
   
   for ii = 1:CNUM
    H = plot(freq{ii},coho{ii},[colo(ii),'-']); hold on;
    set(H,'Linewidth',2);
    H = plot(freq{ii},coho{ii}+scoho{ii},[colo(ii),'-'],...
             freq{ii},coho{ii}-scoho{ii},[colo(ii),'-']); hold on;
    set(H,'Linewidth',1);
    
    H = plot(freq{ii},rcoho{ii},[colo(ii),'--']); hold on;
    set(H,'Linewidth',1.5);
    H = plot(freq{ii},rcoho{ii}+srcoho{ii},[colo(ii),'--'],...
             freq{ii},rcoho{ii}-srcoho{ii},[colo(ii),'--']); hold on;
    set(H,'Linewidth',1);
   end
   
   ylabel('Coherence');
   xlabel('Frequency (Hz)');
   title(sprintf('%s with %s (dashed shuffled)',data.name,lfplabel));
   
end

return;

