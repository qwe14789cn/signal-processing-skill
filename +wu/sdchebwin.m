function w = sdchebwin(N, beta, normwin)

% SDCHEBWIN Symmetric Dolph-Chebyshev window
%    SDCHEBWIN(N,BETA,NORMWIN) returns a symmetric N point Dolph-Chebyshev
%    window with shaping parameter BETA.  The computations use Saramaki's
%    formulas.  
%
%    When true (default), NORMWIN normalizes the window such that the
%    maximum amplitude is 1.
%
%    BETA can be related to R decibels of relative sidelobe attenuation by
%       BETA ~ 0.46 + 0.036*R
%
%    See also CHEBWIN, DCHEBWIN.
%
%    Ref:
%    T. Saramaki, "Finite Impulse Response Filter Design"
%    Handbook for Digital Signal Processing, Ch. 4
%    Ed. S. K. Mitra and J. F. Kaiser
%    John Wiley & Sons, 1993
%    pgs. 155-277

%  Joe Henning - Dec 2013

if nargin < 2
   fprintf('??? Bad beta input to sdchebwin ==> beta must be specified\n');
   w = [];
   return;
end

if nargin < 3
   normwin = 1;
end

if (N == 1)
   w = 1;
   return
end

if mod(N,2)
   M = (N-1)/2;
else
   M = N-1;
end

gamma = (1 + cos(pi/(2*M)))/(1 + cos(2*pi*beta/(2*M+1)));

vcnt = 1;
vindex = [0];
v = [];
for n = -M:M
   if (n == 0)
      v(vcnt,n+M+1) = 1;
   else
      v(vcnt,n+M+1) = 0;
   end
end

vcnt = vcnt + 1;
vindex = [vindex; 1];
for n = -M:M
   if (n == 0)
      v(vcnt,n+M+1) = gamma - 1;
   elseif (abs(n) == 1)
      v(vcnt,n+M+1) = gamma/2.0;
   else
      v(vcnt,n+M+1) = 0;
   end
end

for k = 2:M
   vcnt = vcnt + 1;
   vindex = [vindex; k];
   i1 = find(vindex == k-1);
   i2 = find(vindex == k-2);
   for n = -M:M
      if (abs(n) > k)
         v(vcnt,n+M+1) = 0;
      elseif (n == -M)
         v(vcnt,n+M+1) = 2*(gamma-1)*v(i1,n+M+1) - v(i2,n+M+1) + gamma*(0 + v(i1,n+M+2));
      elseif (n == M)
         v(vcnt,n+M+1) = 2*(gamma-1)*v(i1,n+M+1) - v(i2,n+M+1) + gamma*(v(i1,n+M) + 0);
      else
         v(vcnt,n+M+1) = 2*(gamma-1)*v(i1,n+M+1) - v(i2,n+M+1) + gamma*(v(i1,n+M) + v(i1,n+M+2));
      end
   end
end

w = v(size(v,1),:);

if ~mod(N,2)
   wtemp = w/max(w);
   % Every second value is disregarded
   w = wtemp(1:2:size(wtemp,2));
end

if (normwin)
   % normalize
   w = w(:)/max(w);
else
   w = w(:);
end
