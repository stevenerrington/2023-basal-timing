% 
% clc; clear all; close all; addpath('X:\Kaining\HELPER_GENERAL');
% 
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% addpath('X:\MONKEYDATA\Batman\Probamt2575_Behavior\');
% D1=dir ('X:\MONKEYDATA\Batman\Probamt2575_Behavior\P*.mat');
% for x=1:size(D1,1)
%     D1(x).loc='Batman'
% end
% 
% % addpath('X:\MONKEYDATA\Robin_ongoing\Probamt2575_Behavior\');
% % D2=dir ('X:\MONKEYDATA\Robin_ongoing\Probamt2575_Behavior\P*.mat');
% % for x=1:size(D2,1)
% %     D2(x).loc='Robin'
% % end
% 
% % addpath('X:\MONKEYDATA\ZOMBIE_ongoing\Probamt2575_Behavior\');
% % D3=dir ('X:\MONKEYDATA\ZOMBIE_ongoing\Probamt2575_Behavior\P*.mat');
% % for x=1:size(D3,1)
% %     D3(x).loc='Zombie'
% % end
% 
% addpath('X:\MONKEYDATA\Wolverine\Probamt2575_Behavior\');
% D4=dir ('X:\MONKEYDATA\Wolverine\Probamt2575_Behavior\P*.mat');
% for x=1:size(D4,1)
%     D4(x).loc='Wolverine'
% end
% D=[D1;];
% clc
% % D = D4;
% 
% 
% for xzv=1:length(D)
%     try
%         analysiswindow=[11100:13500];
% 
%         load(D(xzv).name,'PDS');
% 
%         durationsuntilreward=PDS(1).timeoutcome-PDS(1).timetargeton;
%         durationsuntilreward=round(durationsuntilreward*10)./10;
%         completedtrial=find(durationsuntilreward>0); %was the trial completed
%         prob100=intersect(completedtrial,find(PDS.fractals==9800));
%         prob75=intersect(completedtrial,find(PDS.fractals==9801));
%         prob50=intersect(completedtrial,find(PDS.fractals==9802));
%         prob25=intersect(completedtrial,find(PDS.fractals==9803));
%         prob0=intersect(completedtrial,find(PDS.fractals==9804));
%         deliv=intersect(find(PDS.timeoutcome>0),find( PDS.rewardduration>0)); %was reward delivered or not
%         ndeliv=intersect(find(PDS.timeoutcome>0),find( PDS.rewardduration==0));
%         allprob=intersect(completedtrial,find(PDS.fractals<9805));
%         %
%         %get analog signals
%         Pupil=[];
%         Xeye=[];
%         Yeye=[];
%         Lick=[];
%         [bb,aa]=butter(8,10/500,'low');
%         Blnksdetect=[];
%         for x=1:length(PDS.fractals)
%             millisecondResolution=0.001;
%             trialanalog=PDS.onlineEye{x};
%             %
%             
%             
%             temp=trialanalog(:,[1 4]);
%             relatveTimePDS = temp(:,2)-temp(1,2);
%             regularTimeVectorForPdsInterval = [0: millisecondResolution  : temp(end,2)-temp(1,2)];
%             regularPdsData = interp1(  relatveTimePDS , temp(:,1) , regularTimeVectorForPdsInterval  );
%             regularPdsData(length(regularPdsData)+1:12000)=NaN;
%             Xeye=[Xeye; regularPdsData(1:12000)];
%             clear regularPdsData regularTimeVectorForPdsInterval temp relatveTimePDS
%             %
%             temp=trialanalog(:,[2 4]);
%             relatveTimePDS = temp(:,2)-temp(1,2);
%             regularTimeVectorForPdsInterval = [0: millisecondResolution  : temp(end,2)-temp(1,2)];
%             regularPdsData = interp1(  relatveTimePDS , temp(:,1) , regularTimeVectorForPdsInterval  );
%             regularPdsData(length(regularPdsData)+1:12000)=NaN;
%             Yeye=[Yeye; regularPdsData(1:12000)];
%             clear regularPdsData regularTimeVectorForPdsInterval temp relatveTimePDS
%             %
%             temp = PDS.onlineLickForce{x};
%             relatveTimePDS = temp(:,2)-temp(1,2);
%             regularTimeVectorForPdsInterval = [0: millisecondResolution  : temp(end,2)-temp(1,2)];
%             regularPdsData = interp1(  relatveTimePDS , temp(:,1) , regularTimeVectorForPdsInterval  );
%             %
%             
%             regularPdsData=filtfilt(bb,aa,regularPdsData);
%             %
%             regularPdsData(length(regularPdsData)+1:12000)=NaN;
%             Lick=[Lick; regularPdsData(1:12000)];
%             clear regularPdsData regularTimeVectorForPdsInterval temp relatveTimePDS   %
%         end
%         
%         lickingwindow = 7000;
%         Lick_=[];
%         targon_=fix(PDS.timetargeton*1000);
%         targrange=[targon_'-1500 targon_'-1500+lickingwindow];
%         for b=1:length(PDS.timetargeton)
%             try
%                 t=Lick(b,[targrange(b,1):targrange(b,2)]);
%                 
%             catch
%                 t(1:lickingwindow+1)=NaN;
%             end
%             Lick_=[Lick_; t]; clear t
%         end
%         
%         
%         numberofstd=2;
%         baseline=Lick_( allprob,1:1500); %baseline from completed trials with outcomes
%         baseline=baseline(:);
%         baseline=baseline(find(isnan(baseline)==0));
%         baselinemean=mean(baseline(:));
%         rangemax=baselinemean+(std(baseline)*numberofstd);
%         rangemin=baselinemean-(std(baseline)*numberofstd);
%         Lickdetect=[];
%         for x=1:length(PDS.fractals)
%             x=Lick_(x,:);
%             x(find(x>rangemax))=999999;
%             x(find(x<rangemin))=999999;
%             x(find(x~=999999))=0;
%             x(find(x==999999))=1;
%             Lickdetect=[Lickdetect; x]; clear x;
%         end
%         clear x rangemin rangemax baseline baselinemean
%         
%         %save sessions with reasonable licking signal
%         test=Lickdetect(intersect([prob100 prob75],deliv),3500:5000);
%         test=nansum(test)./size(test,1);
%         if length(find(test>0.2))>150 & length(intersect(ndeliv,prob75))>1 & length(intersect(ndeliv,prob50))>1
%             
%             Lickdetect_=plot_mean_psth({[Lickdetect]},100,1,size(Lickdetect,2),1);
%             savestruct(xzv).prob100=Lickdetect_(prob100,:);
%             savestruct(xzv).prob75=Lickdetect_(prob75,:);
%             savestruct(xzv).prob50=Lickdetect_(prob50,:);
%             savestruct(xzv).prob25=Lickdetect_(prob25,:);
%             savestruct(xzv).prob0=Lickdetect_(prob0,:);           
%             savestruct(xzv).prob75N=Lickdetect_(intersect(ndeliv,prob75),:);
%             savestruct(xzv).prob50N=Lickdetect_(intersect(ndeliv,prob50),:);
%             savestruct(xzv).prob25N=Lickdetect_(intersect(ndeliv,prob25),:);
%             savestruct(xzv).prob75D=Lickdetect_(intersect(deliv,prob75),:);
%             savestruct(xzv).prob50D=Lickdetect_(intersect(deliv,prob50),:);
%             savestruct(xzv).prob25D=Lickdetect_(intersect(deliv,prob25),:);
%             
% %             figure;
% %             subplot(2,1,1)
% %             imagesc(Lickdetect)
% %             xlim([0 4000])
% %             subplot(2,1,2)
% %             plot(nanmean(Lickdetect_))
% %             xlim([0 4000])
% %             clc;  
%         end
%         
%         
%         
%     end
%     clc; 
%     try
%   
%     size(savestruct)
%     
%       xzv
%     end
% end
% 
% if exist('savestruct')
%     save savestructLick2575.mat savestruct
% else
%     error('variable savestruct does not exist');
% end

load savestructLick2575_Zombie.mat

%normalize
for x = 1:length(savestruct)
lower_bound=min(nanmean(savestruct(1,x).prob100));
normal_factor=max(nanmean(savestruct(1,x).prob100)-lower_bound);
savestruct(1,x).prob100 = (savestruct(1,x).prob100-lower_bound)/normal_factor;
savestruct(1,x).prob75 = (savestruct(1,x).prob75-lower_bound)/normal_factor;
savestruct(1,x).prob50 = (savestruct(1,x).prob50-lower_bound)/normal_factor;
savestruct(1,x).prob25 = (savestruct(1,x).prob25-lower_bound)/normal_factor;
savestruct(1,x).prob0 = (savestruct(1,x).prob0-lower_bound)/normal_factor;
savestruct(1,x).prob75N = (savestruct(1,x).prob75N-lower_bound)/normal_factor;
savestruct(1,x).prob50N = (savestruct(1,x).prob50N-lower_bound)/normal_factor;
savestruct(1,x).prob25N = (savestruct(1,x).prob25N-lower_bound)/normal_factor;
savestruct(1,x).prob75D = (savestruct(1,x).prob75D-lower_bound)/normal_factor;
savestruct(1,x).prob50D = (savestruct(1,x).prob50D-lower_bound)/normal_factor;
savestruct(1,x).prob25D = (savestruct(1,x).prob25D-lower_bound)/normal_factor;

end


figure;
hold on;
plot(nanmean(vertcat(savestruct(1,:).prob100)),'k')
plot(nanmean(vertcat(savestruct(1,:).prob75D)),'m')
plot(nanmean(vertcat(savestruct(1,:).prob50D)),'r')
plot(nanmean(vertcat(savestruct(1,:).prob25D)),'g')
x=[1500,1500]; y=[0,2]; plot(x,y,'k','LineWidth',2); hold on;
x=[4000,4000]; y=[0,2]; plot(x,y,'k','LineWidth',2); hold on;
legend(['100%, n = ' num2str(size(vertcat(savestruct(1,:).prob100),1))],...
    ['75%, n = ' num2str(size(vertcat(savestruct(1,:).prob75D),1))], ...
    ['50%, n = ' num2str(size(vertcat(savestruct(1,:).prob50D),1))], ...
    ['25%, n = ' num2str(size(vertcat(savestruct(1,:).prob25D),1))]);
ylim([0,1.1]);
print('diliverytrial', '-djpeg');

figure;
hold on;
plot(nanmean(vertcat(savestruct(1,:).prob75N)),'m')
plot(nanmean(vertcat(savestruct(1,:).prob50N)),'r')
plot(nanmean(vertcat(savestruct(1,:).prob25N)),'g')
plot(nanmean(vertcat(savestruct(1,:).prob0)),'c')
x=[1500,1500]; y=[0,2]; plot(x,y,'k','LineWidth',2); hold on;
x=[4000,4000]; y=[0,2]; plot(x,y,'k','LineWidth',2); hold on;
ylim([0,0.5]);
legend(['75%, n = ' num2str(size(vertcat(savestruct(1,:).prob75N),1))],...
    ['50%, n = ' num2str(size(vertcat(savestruct(1,:).prob50N),1))],...
    ['25%, n = ' num2str(size(vertcat(savestruct(1,:).prob25N),1))],...
    ['0%, n = ' num2str(size(vertcat(savestruct(1,:).prob0),1))]);
print('nondiliverytrial', '-djpeg');

% figure;
% hold on;
% plot(nanmean(vertcat(savestruct(1,:).prob100)),'k')
% plot(nanmean(vertcat(savestruct(1,:).prob75)),'m')
% plot(nanmean(vertcat(savestruct(1,:).prob50)),'r')
% plot(nanmean(vertcat(savestruct(1,:).prob25)),'g')
% plot(nanmean(vertcat(savestruct(1,:).prob0)),'c')
% x=[1500,1500]; y=[0,2]; plot(x,y,'k','LineWidth',2); hold on;
% x=[4000,4000]; y=[0,2]; plot(x,y,'k','LineWidth',2); hold on;
% legend('100%', '75%', '50%', '25%','0%');
% ylim([0,1.1]);














