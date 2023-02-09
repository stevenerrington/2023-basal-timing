function info = rate_fano_factor_psth(data,interval,showplot)
%********* JUDE MITCHELL (jude@salk.edu):  11/20/2008
%******** function info = rate_fano_factor_psth(data,interval,showplot)
%**********
%    one example:  
%                  info = rate_fano_factor_psth('mnar4_u2',[],1);  %uses default
%                                                           % interval
%                
%                  load 'msiv3_u8';
%                  info = rate_fano_factor_psth(data,data.sustained,1)
%
%                  load 'mnar4_u2';
%                  info = rate_fano_factor_psth(data,data.sustained,1);
%
%                  load 'msir27_u3';
%                  info = rate_fano_factor_psth(data,data.morepause,1);  
%
%***** general: computes smoothed firing rate and the Fano factor
%*****          at several different smooth windows and count intervals
%*****          and plots those results  
%** inputs:
%********** data - all relevent data fields for a neuron
%******          - do 'help datafile_format' to see documentation
%******
%********** interval - interval of specific analysis, 1xN array of timepoints
%**********            - use data from this interval to evaluate
%**********              significant differences in rate and in Fano
%********** showplot - to plot out results
%*****
%******  output:
%******      info.cintervals = [1 x N] array of counting intervals
%******      info.cinfo{1xN} = detailed fano and rate info (see below)
%******      info.cfano(C,N) = mean fano as function on interval each
%******                         for each of the C attention conditions
%******      info.sfano(C,N) = same as cfano, but sem of the mean
%******
%******  cinfo:
%*****       C - the number of attention conditions 
%***** cinfo.timebin{1xC} - time midpoints of counting intervals
%***** cinfo.smorate{1xC} - gaussian smooth firing rate
%***** cinfo.ratebin{1xC} - mean spike counts in bins
%***** cinfo.varbin{1xC} -  variance spike counts in bins
%***** cinfo.fanobin{1xC} - fano factor, NaN if no spikes in a bin
%*****
%***** cinfo.crange - count windows falling in interval of analysis
%***** cinfo.meanfano(C) - mean fano over range of analysis
%***** cinfo.semfano(C) - sem of fano over range of analysis
%*****
%***** cinfo.airate - AI of rate mod (A-U)/(A+U)
%***** cinfo.ratepval - significance cond 1 vs 2 in firing rate diff
%***** cinfo.aifano - AI of fano mod
%***** cinfo.fanopval - significance cond 1 vs 2 in fano factor diff
%************
%****** recap:
%********
%******** function info = rate_fano_factor_psth(data,interval,showplot)
%**********
%    one example:  
%                  info = rate_fano_factor_psth('mnar4_u2',[],1);  %uses default
%                                                           % interval
%                
%                  load 'msiv3_u8';
%                  info = rate_fano_factor_psth(data,data.sustained,1)

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
for zz = 1:size(data.label,2)
        if (strcmp(data.label{zz},'SU1'))
            it_su = zz;
        end
end
if (it_su == -1)
    disp(sprintf('Unable to identify SU1'));
    info = [];
    return;
end

%********* get the single unit spikes for attended and unattended trials
CNUM = max(data.attend);   % 2 or 3 conditions, or more?
                       % condition 1 is attended in RF during 2 of 4 track
                       % condition 2 is unattended in RF during 2 of 4
                       % condition 3 is unattended in RF during 1 of 4
spikes = cell(1,CNUM);   % single unit attended spikes (in sustatined period
sponts = cell(1,CNUM);   % single unit spontaneous before trial
for trial = 1:size(data.trials,2)
   cubo = data.attend(trial);
   spikes{cubo} = [spikes{cubo} ; data.trials{trial}(it_su,:)];
   sponts{cubo} = [sponts{cubo} ; data.spontaneous{trial}(1,:)];
end
%*****************************************************************
spiker = spikes;
sponter = sponts;

%**************************** cintervals *************************
info.cintervals = [12,17,25,35,50,71,100,141,200,283,400];  
choiceint = 7;  % select one countining to plot, default 100ms
for k = 1:size(info.cintervals,2)
  info.cinfo{k} = compute_rate_fano(spikes,interval,info.cintervals(k));
  for kk = 1:size(info.cinfo{k}.meanfano,2)
      info.cfano(kk,k) = info.cinfo{k}.meanfano(kk);
      info.sfano(kk,k) = info.cinfo{k}.semfano(kk);
  end
end
%******************************************************************

%************ plot the spike rasters and mean firing rates, and fano
if (showplot == 1)
   
   figure;
   %****************
   xstart = data.surround(1);
   xend = 3100;
   %****************
   divo = size(sponter{1,1},2)/(size(sponter{1,1},2)+(xend-xstart));
   twid = 0.67;
   awid = divo * twid;
   bwid = (1-divo) * twid;
   
   %****************
   disp('Plotting rastergrams (slow) ...');
   subplot('position',[0.2 0.55 awid 0.4]);
   plot_spike_raster(sponter,1,size(sponter{1},2),[]);
   V = axis;
   axis([0 size(sponter{1},2) V(3) V(4)]);
   grid on;
   ylabel('Trial Number');
   title('Spontaneous');
   
   %**************************
   subplot('position',[(0.3+awid) 0.55 bwid 0.4]);
   plot_spike_raster(spiker,xstart,xend,[]);
   V = axis;
   axis([xstart xend V(3) V(4)]);
   grid on;
   ylabel('Trial Number');
   title(sprintf('Unit %s rasters',data.name));
   %*************
   subplot('position',[(0.3+awid) 0.35 bwid 0.15]);
   smooth_window = 25;  % give sigma of 12.5ms
   plot_mean_psth(spiker,smooth_window,xstart,xend,[]);
   axis tight;
   V = axis;
   maxo = V(4);
   axis([xstart xend V(3) V(4)]);
   plot([interval(1),interval(1)],[V(3),V(4)],'k-'); hold on;
   plot([interval(end),interval(end)],[V(3),V(4)],'k-'); hold on;
   %**** indicate pause period yellow lines
   H = plot([data.pause(1),data.pause(1)],[V(3),V(4)],'y-'); hold on;
   set(H,'Linewidth',2); set(H,'Color',[0.7,0.5,0]);
   H = plot([data.pause(end),data.pause(end)],[V(3),V(4)],'y-'); hold on;
   set(H,'Linewidth',2); set(H,'Color',[0.7,0.5,0]);
   %*******************************
   ylabel('Firing Rate');
   xlabel('Time (ms)');
   
   %**************
   subplot('position',[(0.3+awid) 0.07 bwid 0.2]);
   col = 'rbg';
   y = find( (info.cinfo{choiceint}.timebin{1} >= xstart) & ...
             (info.cinfo{choiceint}.timebin{1} <= xend ) );
   for k = 1:size(spikes,2)
     plot(info.cinfo{choiceint}.timebin{k}(y),info.cinfo{choiceint}.fanobin{k}(y),...
               [col(k),'o-']); hold on;
   end
   plot(info.cinfo{choiceint}.timebin{1},...
         ones(size(info.cinfo{choiceint}.timebin{1})),'k:');
   axis tight;
   V = axis;
   axis([xstart xend V(3) V(4)]);
   plot([interval(1),interval(1)],[V(3),V(4)],'k-'); hold on;
   plot([interval(end),interval(end)],[V(3),V(4)],'k-'); hold on;
   %**** indicate pause period yellow lines
   H = plot([data.pause(1),data.pause(1)],[V(3),V(4)],'y-'); hold on;
   set(H,'Linewidth',2); set(H,'Color',[0.7,0.5,0]);
   H = plot([data.pause(end),data.pause(end)],[V(3),V(4)],'y-'); hold on;
   set(H,'Linewidth',2); set(H,'Color',[0.7,0.5,0]);
   %*******************************
   xlabel(sprintf('Time (%d ms intervals)',info.cintervals(choiceint)));
   ylabel('Fano Factor');
   
   %*************
   subplot('position',[0.2 0.35 awid 0.15]);
   smooth_window = 25;  % give sigma of 12.5ms
   plot_mean_psth(sponter,smooth_window,1,size(sponter{1},2),[]);
   V = axis;
   axis([0 size(sponter{1},2) 0 maxo]);
   ylabel('Spontaneous Rate');
   xlabel('Time (ms)');  
   
   %************** plot fanos by counting intervals **************
   subplot('position',[0.07 0.07 (0.3+awid-0.15) 0.2]);
   col = 'rbg';
   for kk = 1:size(info.cinfo{k}.meanfano,2)
      H = semilogx(info.cintervals,info.cfano(kk,:),[col(kk),'.-']); hold on;
      set(H,'Linewidth',2);
      H = semilogx(info.cintervals,(info.cfano(kk,:) + info.sfano(kk,:)),...
                    [col(kk),':']);
      set(H,'Linewidth',1);
      H = semilogx(info.cintervals,(info.cfano(kk,:) - info.sfano(kk,:)),...
                    [col(kk),':']);
      set(H,'Linewidth',1);
   end
   semilogx(info.cintervals,ones(size(info.cintervals)));
   axis tight;
   V = axis;
   axis([ (0.75*info.cintervals(1)) (1.5*info.cintervals(end)) V(3) V(4)]);
   semilogx([info.cintervals(choiceint),info.cintervals(choiceint)],...
            [V(3),V(4)],'k--');   
   xlabel('Log Count Interval');
   ylabel('Fano Factor');
   
end

return;




