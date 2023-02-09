function [smo,basis] = compute_logtime_smooth(orig, K, baser)
%****** function [smo,basis] = compute_logtime_smooth(orig,K,baser)
%*****
%******* take a kernel, smooth it with a set of K basis functions
%******* in which the K basis are spaced in log-time ala Keat et al, 2001
%***** inputs:
%*****    orig - original 1xT data to be smoothed (like ISI or autocor)
%*****    K - number of log-time spaced kernels to use (# parameters)
%*****    baser - if done previously, can reuse basis to save time in comp
%*****
%***** outputs:
%*****    smo - smoothed version of original function
%*****    basis - basis functions used in case want to reuse them

%disp('Computing Log-Time Smoothed Function');

if (size(baser,2) == size(orig,2))
    basis = baser;
else
    T = size(orig,2);
    %******** log time spacing ***********
    bit = 0.75;
    divo = (log(T*bit)-log(1))/(K-1);
    divos = log(1):divo:log(T*bit);
    centers = exp(divos);
    %*******************************
    basis = zeros(K,T);
    for kk = 1:K
      cent = centers(kk);
      leno = min( (2*cent), T);
      xt = 1:ceil(leno);
      xo = (1/(2*cent)) * xt;
      yo = pi * ((2*xo) - 1);   % from -pi to pi
      basis(kk,xt) = (cos(yo) + 1)/2;
    end
end

%********** if you want to see the basis set ******
if (0)
  for kk = 1:K
    subplot(2,2,1);
    semilogx(1:T,basis(kk,:),'k-'); hold on;
    subplot(2,2,2);
    plot(1:T,basis(kk,:),'k-'); hold on;
  end
end

%********** prepare least-squares projections
baso = inv( basis * basis' ) * basis;

%******** project function onto filters *****
for kk = 1:K
    weights(kk) = sum( baso(kk,:) .* orig );
end

%******** build smooth from weightings *******
smo = zeros(size(orig));
for kk = 1:K
    smo = smo + weights(kk) * basis(kk,:);
end

return;