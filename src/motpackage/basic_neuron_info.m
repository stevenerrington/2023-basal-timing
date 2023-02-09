function info = basic_neuron_info(data,interval,showplot)
%********* JUDE MITCHELL (jude@salk.edu):  11/20/2008
%******** function info = basic_neuron_info(data,interval,showplot)
%**********
%    one example:  
%                  info = basic_neuron_info('mnar4_u2',[],1);  %uses default
%                                                           % interval
%                
%                  load 'msiv3_u8';
%                  info = basic_neuron_info(data,data.sustained,1)
%
%***** general: computes some very basic information about each unit
%*****          including reading out spike waveform, and stores that
%*****          information in smaller format that the full data struct
%*****          so it can be accessed for later analysis quickly
%** inputs:
%********** data - all relevent data fields for a neuron
%**********      - do 'help datafile_format' to get doc on file format
%********** interval - interval of specific analysis, 1xN array of timepoints
%**********            - use data from this interval to evaluate
%**********              significant differences in rate and in Fano
%********** showplot - to plot out results
%
%******  output:
%******      info.name = name of single unit in database
%******      info.monkey = id of monkey recorded from ...
%******      info.isolation = isolation quality (1 best, 2 clear cluster)
%******      info.waveform = 32 bin waveform
%******      info.iwaveform = waveform interpolated by spline
%******                       up to 2.5ms precision 
%******      info.twaveform = time axis of iwaveform 
%******      info.wduration = duration of interpolated waveform
%******      info.spontrate = spontaneous rate averaged over all conds
%******      info.visrate = average visually evoked rate (over all conds)
%******      info.pvis = probability visrate stat sig over spontaneous
%******
%****** recap:
%********
%******** function info = basic_neuron_info(data,interval,showplot)
%**********
%    one example:  
%                  info = basic_neuron_info('mnar4_u2',[],1);  %uses default
%                                                           % interval
%                
%                  load 'msiv3_u8';
%                  info = basic_neuron_info(data,data.sustained,1)

datalocation = 'datafiles';   % directory with data files
info = [];

%******* if data is just a name, load that file, else it is structure
if (isfield(data,'label') == 0)
    disp(sprintf('Trying to load data file %s',data));
    load(sprintf('%s\\%s',datalocation,data));
    disp(sprintf('Using default sustained interval for analysis'));
    interval = data.sustained;  %must use default interval then
end

%*********** locate su1 (set of spikes for the given unit)***
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

%********************* collect basic info on cell ****************
%******      info.name = name of single unit in database
%******      info.monkey = id of monkey recorded from ...
%******      info.waveform = 32 bin waveform
%******      info.iwaveform = waveform interpolated by spline
%******                       up to 5ms precision 
%******      info.spontrate = spontaneous rate averaged over all conds
%******      info.visrate = average visually evoked rate (over all conds)
%******      info.pvis = probability visrate stat sig over spontaneous
info.name = data.name;
info.monkey = data.monkey_id;
info.isolation = data.isolation;
info.waveform = data.waveform;
mino = min(info.waveform);
maxo = max(info.waveform);
%********* normalize the waveform amplitude ****
info.waveform = info.waveform / (maxo-mino);
%******** interpolate waveform here and get duration ********
dTT = 25;   % original resolution is 25 micro-secs
dT = 2.5;  % discretize waveform duration to 5 micro-secs
info.iwaveform = spline(1:32,info.waveform,[1:(dT/dTT):32]);
info.twaveform = ( dT * (1:size(info.iwaveform,2)) );
%*********** determine the duration of waveform
y = find( info.iwaveform == min(info.iwaveform));
mintime = info.twaveform(y(1));
%******** find time of maximum
y = find( info.iwaveform == max(info.iwaveform) );
maxtime = info.twaveform(y(1));
%******* determine if trough and peak in roughly correct locations
minrange = [150,400];  %plexon tries to align trough in this us range
if ( ((mintime>minrange(1))&(mintime<minrange(2)) & ...
          (maxtime>mintime)) )
      if (maxtime == info.twaveform(end))  % if clipped at end
          duration = NaN;
      else
          duration = (maxtime-mintime);
      end
else
      duration = NaN;   % not well defined peak followed by trough
end
info.wduration = duration;
%**************************

%*********** spontaneous mean rates per trial
spontos = [];
for ii = 1:size(data.spontaneous,2)
    spontos = [spontos (1000*mean(data.spontaneous{ii}))];
end
%*********** visually evoked rates per trial
visos = [];
for kk = 1:CNUM
    for ii = 1:size(spikes{kk},1)
        visos = [visos (1000*mean( spikes{kk}(ii,interval )))];
    end
end
%************ store spontaneous and visual firing rate of neuron***
info.spontrate = mean(spontos);
info.visrate = mean(visos);
if (info.spontrate < info.visrate)   % is visual response sig more than spont?
   info.pvis = ranksum(spontos,visos);
else
   info.pvis = -ranksum(spontos,visos);  % let the sign indicate direction
end
%******************************************************************
disp(sprintf('%s dur(%5.1f) sp_vis(%5.1f,%5.1f)(p=%6.4f)',...
         info.name,info.wduration,info.spontrate,...
         info.visrate,info.pvis));
     
%************ plot the spike rasters and mean firing rates, and fano
if (showplot == 1)
   figure;
   subplot(2,2,1);
   plot((25*(0:(size(info.waveform,2)-1))),info.waveform,'k.'); hold on;
   plot((2.5*(0:size(info.iwaveform,2)-1)),info.iwaveform,'b-');
   xlabel('Time (us)');
   ylabel('Waveform Amp');
   title(sprintf('WaveDuration %4.1f',info.wduration));
   
   mino = min(spontos);
   maxo = max(visos);
   vx = mino:((maxo-mino)/20):maxo;
   yhist = hist(spontos,vx);
   yhist2 = hist(visos,vx);
   
   subplot(2,2,2);
   bar(vx,yhist);
   xlabel('Firing Rate');
   ylabel('Counts');
   title(sprintf('Mean Spont = %5.3f',info.spontrate));
   V = axis;
   axis([-2 maxo 0 V(4)]);
   
   subplot(2,2,4);
   bar(vx,yhist2);
   xlabel('Firing Rate');
   ylabel('Counts');
   title(sprintf('Mean Vis = %5.3f (p=%6.4f)',info.visrate,info.pvis));
   axis([-2 maxo 0 V(4)]);
   
end

return;

