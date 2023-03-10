% AUC                         Area under ROC
% 
%     [A,Aci] = auc(data,alpha,flag,nboot,varargin);
%
%     INPUTS
%     data     - Nx2 matrix [t , y], where
%                t - a vector indicating class value (>0 positive class, <=0 negative)
%                y - score value for each instance
%
%     OPTIONAL
%     alpha    - level for confidence intervals (eg., enter 0.05 if you want 95% CIs)
%     flag     - 'hanley' yields Hanley-McNeil (1982) asymptotic CI
%                'maxvar' yields maximum variance CI
%                'mann-whitney' 
%                'logit' 
%                'boot' yields bootstrapped CI (DEFAULT)
%     nboot    - if 'boot' is set, specifies # of resamples, default=1000
%     varargin - additional arguments to pass to BOOTCI, only valid for 'boot'
%                this assumes you have the STATs toolbox, otherwise it's
%                ignored and a crude percentile bootstrap is estimated.
%
%     OUTPUTS
%     A        - area under ROC
%     Aci      - confidence intervals
%
%     EXAMPLES
%     % Classic binormal ROC. 100 samples from each class, with a unit mean separation
%     % between the classes.
%     >> mu = 1;
%     >> y = [randn(100,1)+mu ; randn(100,1)];
%     >> t = [ones(100,1) ; zeros(100,1)];
%     >> [A,Aci] = auc([t,y])
%     >> trueA = normcdf(mu/sqrt(1+1^2))
%     
%     REFERENCE
%     Gengsheng Qin & Lejla Hotilovac. Comparison of non-parametric
%     confidence intervals for the area under the ROC curve of a continuous
%     scale diagnostic test.
%     Stat Methods Med Res 17:207, 2008

%     $ Copyright (C) 2011 Brian Lau http://www.subcortex.net/ $
%
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%     REVISION HISTORY:
%     brian 03.08.08 written
%     brian 08.07.11 added 'mann-whitney' and 'logit' CI estimators

function [A,Aci] = auc(data,alpha,flag,nboot,varargin);

if size(data,2) ~= 2
   error('Incorrect input size in AUC!');
end

if ~exist('flag','var')
   flag = 'boot';
elseif isempty(flag)
   flag = 'boot';
else
   flag = lower(flag);
end

if ~exist('nboot','var')
   nboot = 1000;
elseif isempty(nboot)
   nboot = 1000;
end

if ~exist('alpha','var')
   alpha = 0.05;
elseif isempty(alpha)
   alpha = 0.05;
end

if (nargin>3) & (nargout==1)
   warning('Confidence intervals will be computed, but not output in AUC!');
end

if (nargin>4) & (strcmp(flag,'hanley')|strcmp(flag,'maxvar'))
   warning('Asymptotic intervals requested in AUC, extra inputs ignored.');
end

% Count observations by class
m = sum(data(:,1)>0);
n = sum(data(:,1)<=0);

[tp,fp] = roc(data);
% Integrate ROC, A = trapz(fp,tp);
A = sum((fp(2:end) - fp(1:end-1)).*(tp(2:end) + tp(1:end-1)))/2;

% % Method for calculating AUC without integrating ROC from Will Dwinnell's function SampleError.m
% % It's actually slower!
% % Rank scores
% R = tiedrank(data(:,2));
% % Calculate AUC
% A = (sum(R(data(:,1)==1)) - (m^2 + m)/2) / (m * n);

% Confidence intervals
if nargout == 2
   if strcmp(flag,'hanley') % See Hanley & McNeil, 1982; Cortex & Mohri, 2004
      Q1 = A / (2-A);
      Q2 = (2*A^2) / (1+A);

      Avar = A*(1-A) + (m-1)*(Q1-A^2) + (n-1)*(Q2-A^2);
      Avar = Avar / (m*n);

      Ase = sqrt(Avar);
      z = norminv(1-alpha/2);
      Aci = [A-z*Ase A+z*Ase];
   elseif strcmp(flag,'maxvar') % Maximum variance
      Avar = (A*(1-A)) / min(m,n);

      Ase = sqrt(Avar);
      z = norminv(1-alpha/2);
      Aci = [A-z*Ase A+z*Ase];
   elseif strcmp(flag,'mann-whitney')
      % Reverse labels to keep notation like Qin & Hotilovac
      m = sum(data(:,1)<=0);
      n = sum(data(:,1)>0);
      X = data(data(:,1)<=0,2);
      Y = data(data(:,1)>0,2);
      temp = [sort(X);sort(Y)];
      temp = tiedrank(temp);

      R = temp(1:m);
      S = temp(m+1:end);
      Rbar = mean(R);
      Sbar = mean(S);
      S102 = (1/((m-1)*n^2)) * (sum((R-(1:m)').^2) - m*(Rbar - (m+1)/2)^2);
      S012 = (1/((n-1)*m^2)) * (sum((S-(1:n)').^2) - n*(Sbar - (n+1)/2)^2);
      S2 = (m*S012 + n*S102) / (m+n);
      
      Avar = ((m+n)*S2) / (m*n);
      Ase = sqrt(Avar);
      z = norminv(1-alpha/2);
      Aci = [A-z*Ase A+z*Ase];      
   elseif strcmp(flag,'logit')
      % Reverse labels to keep notation like Qin & Hotilovac
      m = sum(data(:,1)<=0);
      n = sum(data(:,1)>0);
      X = data(data(:,1)<=0,2);
      Y = data(data(:,1)>0,2);
      temp = [sort(X);sort(Y)];
      temp = tiedrank(temp);

      R = temp(1:m);
      S = temp(m+1:end);
      Rbar = mean(R);
      Sbar = mean(S);
      S102 = (1/((m-1)*n^2)) * (sum((R-(1:m)').^2) - m*(Rbar - (m+1)/2)^2);
      S012 = (1/((n-1)*m^2)) * (sum((S-(1:n)').^2) - n*(Sbar - (n+1)/2)^2);
      S2 = (m*S012 + n*S102) / (m+n);
      
      Avar = ((m+n)*S2) / (m*n);
      Ase = sqrt(Avar);
      logitA = log(A/(1-A));
      z = norminv(1-alpha/2);
      LL = logitA - z*(Ase)/(A*(1-A));
      UL = logitA + z*(Ase)/(A*(1-A));
      
      Aci = [exp(LL)/(1+exp(LL)) exp(UL)/(1+exp(UL))];      
   elseif strcmp(flag,'boot') % Bootstrap
      if exist('bootci') ~= 2
         warning('BOOTCI function not available, resorting to simple percentile bootstrap in AUC.')
         N = m + n;
         for i = 1:nboot
            ind = unidrnd(N,[N 1]);
            A_boot(i) = auc(data(ind,:));
         end
         Aci = prctile(A_boot,100*[alpha/2 1-alpha/2]);
      else
         if exist('varargin','var')
            Aci = bootci(nboot,{@auc,data},varargin{:})';
         else
            Aci = bootci(nboot,{@auc,data},'type','per')';
         end
      end
   else
      error('Bad FLAG for AUC!')
   end
end