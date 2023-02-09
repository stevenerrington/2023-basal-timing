%********** this function gives the predicted Fano Factor for
%********** counting interval of size T given the autocorrelation
%********** defined as Prob( Spike(t+tau)=1 | Spike(t)=1 )
%**********
function FF = compute_FF_from_auto(autoboy,rat,T);
%****** function FF = compute_FF_from_auto(autoboy,rat,T)
%****** input:  autoboy - autocorrelation function
%******         rat - mean firing rate for condition auto computed
%******               - estimate of rate must be exact (mean from
%******                  the spike train, not average of autocor)
%******         T - size of counting interval
%****** output: FF - Fano factor predicted from autocorrelation
%******
% see Lowen and Teich for similar equation
%***** FF = 1 + (2/T) (sum(1 to T) (T-tau)a(tau))  - (lambda*T)
     
     if (T > size(autoboy,2))
         input('Error: Fano counting larger than autocorrelation');
         FF = 0;
         return;
     end
     if (isempty(rat))
         rat = mean(autoboy);
     end
     %******** implement equation ***********
     sumo = 1;
     for tt = 1:T
        sumo = sumo + (2/T)*(T-tt)*autoboy(tt);
     end
     FF = sumo - (T*rat);
     %***************************************
     
return;
