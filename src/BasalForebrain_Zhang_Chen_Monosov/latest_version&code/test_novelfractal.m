%%%%%%%%%%%%%%%%%%%%% test %%%%%%%%%%%%%%%%%%%%%%%
clear all;close all;

load('X:\PLEXON_GRAYARRAY_LEMMY\NovelFractalLearning\matlab\LemmyKim-02232018_NovFrac_PDS.mat','PDS');

addpath('X:\Kaining\HELPER_GENERAL');
for xxx = 1: length(PDS.channelname)
    channel = xxx;
    %channel = find(contains(PDS.channelname,'114a'));
%     Rasters=[];
%     for x=1:size(PDS.trialstart,1)
%         CENTER=11001;
%         spk=PDS(1).sptimes{channel,x}-PDS(1).trialstart(x,1)-PDS(1).timetargeton(x,1); %align spiking on targetonset
%         spk=(spk*1000)+CENTER-1;
%         spk=fix(spk);
%         %
%         spk=spk(find(spk<CENTER*2));
%         %
%         temp(1,1:CENTER*2)=0;
%         temp(spk)=1;
%         Rasters=[Rasters; temp];
%         clear temp spk x
%     end
%     %for ploting
%     Rasterscs=Rasters;
%     gauswindow_ms=100;
    %SDFcs_n=plot_mean_psth({Rasterscs},gauswindow_ms,1,(CENTER*2)-2,1); %make spike density functions for displaying and average across neurons for displaying
    
    Hist_raster = [];
    Hist_sdf = [];
    for x=1:size(PDS.trialstart,1)
        Hist_template = -200:2500;
        Hist_raw = hist((PDS.sptimes{channel,x}-PDS.trialstart(x,1)-PDS.timetargeton(x,1))*1000, Hist_template);
        Hist_raster = [Hist_raster; Hist_raw];
        
        Smoothing=3; %1 - box car; 2- gaus; 3 - epsp (causal); specs of kernel are defined in Smooth_Histogram function
        sdf=Smooth_Histogram(Hist_raw,Smoothing);
        Hist_sdf = [Hist_sdf;sdf];
        clear temp spk x
    end
    
    
    Rasters_f=[];
    for x=1:size(PDS.Fractals,2)
        CENTER=11001;
        spk=PDS.fracsptimes{channel,x}-PDS.Fractals(4,x); %align spiking on targetonset
        spk=(spk*1000)+CENTER-1;
        spk=fix(spk);
        %
        spk=spk(find(spk<CENTER*2));
        %
        temp(1,1:CENTER*2)=0;
        temp(spk)=1;
        Rasters_f=[Rasters_f; temp];
        clear temp spk x
    end
    %for ploting
    Rasterscs_f=Rasters_f;
    gauswindow_ms=100;
    SDFcs_n=plot_mean_psth({Rasterscs_f},gauswindow_ms,1,(CENTER*2)-2,1); %make spike density functions for displaying and average across neurons for displaying
    
    
    % for trialtype = 1 : 6
    % %ploting
    % trials = find(PDS.trialtype==trialtype);
    % popwindow=[11000:13500];
    % alltrials = nanmean(SDFcs_n(trials,popwindow));
    % figure;
    % RSTP=20;
    % nsubplot(165,165,5:160,5:160)
    % title(['trial type: ' num2str(trialtype)]);
    % h1=area((alltrials));
    % h1.FaceColor = 'red';
    % xuncert=[Rasterscs(trials,11000:13500)];
    % xt=[];
    % rasts=[];
    % for tq=1:size(xuncert,1)
    %     Z=xuncert(tq,:);
    %     Z(find(Z==1))=(find(Z==1));
    %     Z(find(Z==0))=NaN;
    %     xt_=length(find(Z>0));
    %     if isempty(xt_)==1
    %         xt_=NaN;
    %     end
    %     xt=[xt; xt_];
    %     rasts=[rasts; Z];
    %     clear Z tq xt_
    % end
    % MatPlot(1:size(xuncert,1),1:max(xt))=NaN;
    % for tq=1:size(xuncert,1)
    %     temptq=find(rasts(tq,:)>0);
    %     MatPlot(tq,1:length(temptq))=temptq;
    % end
    % rastList=MatPlot;
    % rasIntv=1;
    % LWidth=1;
    % LColor='k';
    % maxY_rast=RSTP;
    %
    % for line = 1:size(rastList,1)
    %     hold on
    %     curY_rast = maxY_rast+rasIntv*line;
    %     plot([rastList(line,:); rastList(line,:)],...
    %         [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
    %         (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor )
    % end
    % clear xuncert rasts MatPlot rastList
    %
    % end
    
    
    
    
    %channel = find(contains(PDS.channelname,'117a'));
    close all;
    figure;
    plotsize = [200 300];
    %print the file name and the channel name
    try
        temp = find(PDS.Filename == '-',1,'last');
        recorddate = PDS.Filename((temp+1):(temp+8));
        clear temp;
    catch
        recorddate='';
    end
    nsubplot(plotsize(1),plotsize(2),5:45,(5:45))
    text(2,3,['Date: ' recorddate],'Color','red','FontSize',14);
    text(2,2,['Channel: ' PDS.channelname{xxx}],'Color','red','FontSize',14);
    xlim([0,10]);
    ylim([1,4]);
    
    try
        tr_no_b_error = find(PDS.b_error_place == 0);
    catch
        tr_no_b_error = 1: length(PDS.trialtype);
    end
    sucesstrial = find(PDS.successtrial == 1);
    
    for trialtype = 2:6
        plotax{trialtype} = nsubplot(plotsize(1),plotsize(2),5:45,50*(trialtype-1)+(5:45));
        
        trials = intersect(find(PDS.trialtype==trialtype),tr_no_b_error);
        trials = intersect(trials, sucesstrial);
        title(['Trial type: ' num2str(trialtype) ', n=' num2str(length(trials))])
        plot(Hist_template, mean(Hist_sdf(trials,:)),'k','LineWidth',2);
        xlim([0 3000]);
        %ylim([0 50]);
        %set ylim:
        ylim_num = get(plotax{2},'ylim');
        if (max(ylim_num)<30)
            ylim_num = [0,30];
        end
        set(gca,'ylim', ylim_num);
    end
    
    nsubplot(plotsize(1),plotsize(2),3*50+(5:45),(5:45));
    trials = find(PDS.b_error_place == 2 & ismember(PDS.trialtype,[2,3])');
    trials = intersect(trials, sucesstrial);
    title(['Believe error at 2nd place,n=' num2str(length(trials))])
    plot(Hist_template, mean(Hist_sdf(trials,:),1),'k','LineWidth',2);
    xlim([0 3000]);
    %ylim([0 50]);
    set(gca,'ylim', get(plotax{2},'ylim'));
    
    nsubplot(plotsize(1),plotsize(2),3*50+(5:45),50+(5:45));
    trials = find(PDS.b_error_place == 3 & ismember(PDS.trialtype,[2,3])');
    trials = intersect(trials, sucesstrial);
    title(['Believe error at 3rd place,n=' num2str(length(trials))]);
    plot(Hist_template, mean(Hist_sdf(trials,:),1),'k','LineWidth',2);
    xlim([0 3000]);
    %ylim([0 50]);
    set(gca,'ylim', get(plotax{2},'ylim'));
    
    
    %%%%%%learing trial%%%%%%%%%%%%%%%%%%%
    
    
    clear Rasters Rasterscs
    Rasters_f=[];
    for x=1:size(PDS.Fractals,2)
        CENTER=11001;
        spk=PDS.fracsptimes{channel,x}-PDS.Fractals(4,x); %align spiking on targetonset
        spk=(spk*1000)+CENTER-1;
        spk=fix(spk);
        %
        spk=spk(find(spk<CENTER*2));
        %
        temp(1,1:CENTER*2)=0;
        temp(spk)=1;
        Rasters_f=[Rasters_f; temp];
        clear temp spk x
    end
    %for ploting
    Rasterscs_f=Rasters_f;
    gauswindow_ms=100;
    SDFcs_n=plot_mean_psth({Rasterscs_f},gauswindow_ms,1,(CENTER*2)-2,1); %make spike density functions for displaying and average across neurons for displaying
    
    
    %%%%%%%%%%%%%%%%% analysing %%%%%%%%%%%%%%%%%%%%%%
    % familiar
    for i = 1:4
        Fractaltype{i} = 6300+i-1;
    end
    % novel
    for i = 1:4
        Fractaltype{i+4} = 7300+i-1;
    end
    Fractaltype{9} = 7999;
    
    % Fractaltype{1} = [6300:6309];
    % Fractaltype{2} = [7300:7309];
    % Fractaltype{3} = 7999; %always novel
    clear trials
    for i = 1: 8
        trials{i} = find(ismember(PDS.Fractals(1,:),Fractaltype{i}));
        trials{i} = intersect(trials{i},find(~isnan(PDS.Fractals(5,:))));
    end
    % trials{1} = find(ismember(PDS.Fractals(1,:),Fractaltype{1}));
    % trials{2} = find(ismember(PDS.Fractals(1,:),Fractaltype{2}));
    % trials{3} = find(ismember(PDS.Fractals(1,:),Fractaltype{3}) & PDS.Fractals(2,:) == 1);
    
    % get the always novel fractal in trial 1 and trial 6 respectively
    trials{9} = find(ismember(PDS.Fractals(1,:),Fractaltype{9}) & PDS.Fractals(2,:) == 1 & ~isnan(PDS.Fractals(5,:)));
    trials{10} = find(ismember(PDS.Fractals(1,:),Fractaltype{9}) & PDS.Fractals(2,:) == 6 & ~isnan(PDS.Fractals(5,:)));
    
    
    %%%%%%%%%%%%% test %%%%%%%%%%%%%%%
    popwindow=[11000:11000+250];
    for xd = 1:length(trials)
        spikesum{xd} = sum(Rasterscs_f(trials{xd},popwindow)');
    end
    minlength = min(cellfun(@(C) length(C), spikesum));
    spikesum_ = cellfun(@(C) C(1:minlength),spikesum,'UniformOutput', false);
    spikesum_plot = cell2mat(spikesum_');
    
    clear plotax
    plotax = nsubplot(plotsize(1),plotsize(2),50+(5:45),50*0+(5:45));
    plot(spikesum_plot(1:4,:)', 'LineWidth', 0.3);
    shadedErrorBar([],spikesum_plot(1:4,:), {@nanmean, @(x) nanstd(x)}, {'-b', 'LineWidth', 1}, 0);
    title('familiar fractal in trial type 1');
    set(gca,'ylim',1.2*get(plotax,'ylim'));
    
    nsubplot(plotsize(1),plotsize(2),50+(5:45),50*1+(5:45));
    plot(spikesum_plot(5:8,:)', 'LineWidth', 0.5);hold on;
    shadedErrorBar([],spikesum_plot(5:8,:), {@nanmean, @(x) nanstd(x)}, {'-b', 'LineWidth', 1}, 0);
    title('Learning fractal in trial type 1');
    set(gca,'ylim',get(plotax,'ylim'));
    hold off;
    
    nsubplot(plotsize(1),plotsize(2),50+(5:45),50*2+(5:45));
    plot(spikesum_plot(9,:));
    title('always novel fractal in trial type 1');
    set(gca,'ylim',get(plotax,'ylim'));
    
    nsubplot(plotsize(1),plotsize(2),50+(5:45),50*3+(5:45));
    plot(spikesum_plot(10,:));
    title('always fractal in trial type 6');
    set(gca,'ylim',get(plotax,'ylim'));
    
    % p1 = ranksum(spikesum{1},spikesum{2})
    % p2 = ranksum(spikesum{2},spikesum{3})
    % p3 = ranksum(spikesum{1},spikesum{3})
    
    %%%%%%%%% end of analysing %%%%%%%%%%%%%%%%%%%%%%%
    
    %ploting
    
    plottitle = {'familiar', 'learning', 'always novel'};
    plotfracnum = [4,8,9];
    clear plotax
    for xd = 1:3
        
        popwindow=[11000:11000+500];
        alltrials = nanmean(SDFcs_n(trials{plotfracnum(xd)},popwindow));
        RSTP=20;
        plotax{xd} = nsubplot(plotsize(1),plotsize(2),100+(5:45),50*(xd-1)+(5:45));
        title(plottitle{xd});
        h1=area((alltrials));
        h1.FaceColor = 'red';
        xuncert=[Rasterscs_f(trials{plotfracnum(xd)},11000:11000+500)];
        xt=[];
        rasts=[];
        for tq=1:size(xuncert,1)
            Z=xuncert(tq,:);
            Z(find(Z==1))=(find(Z==1));
            Z(find(Z==0))=NaN;
            xt_=length(find(Z>0));
            if isempty(xt_)==1
                xt_=NaN;
            end
            xt=[xt; xt_];
            rasts=[rasts; Z];
            clear Z tq xt_
        end
        MatPlot(1:size(xuncert,1),1:max(xt))=NaN;
        for tq=1:size(xuncert,1)
            temptq=find(rasts(tq,:)>0);
            MatPlot(tq,1:length(temptq))=temptq;
        end
        rastList=MatPlot;
        rasIntv=1;
        LWidth=1;
        LColor='k';
        maxY_rast=RSTP;
        
        for line = 1:size(rastList,1)
            hold on
            curY_rast = maxY_rast+rasIntv*line;
            plot([rastList(line,:); rastList(line,:)],...
                [(curY_rast+rasIntv/2)*ones(1,size(rastList,2)); ...
                (curY_rast-rasIntv/2)*ones(1,size(rastList,2))],'-','linewidth',LWidth,'color',LColor )
        end
        %ylim([0 40]);
        set(gca,'ylim',get(plotax{1},'ylim'));
        clear xuncert rasts MatPlot rastList
        
    end
    
    set(gcf,'Position',[1 41 2560 1484],'Paperposition',[0 0 26.6667 15.4583], 'Paperpositionmode','auto','Papersize',[26.6667 15.4583]);  % sets the size of the figure and orientation
    print('-djpeg', ['Save_' recorddate '_' PDS.channelname{xxx}]);
    
end
