function w = sarawin(N, beta, p, normwin)

% SARAWIN Symmetric Saramaki window
%    SARAWIN(N,BETA,P,NORMWIN) returns a symmetric N point Saramaki window
%    with shaping parameter BETA.  P defines the power of the Saramaki
%    window.  When P = 1 (default), a regular Saramaki window is obtained.
%
%    When true (default), NORMWIN normalizes the window such that the
%    maximum amplitude is 1.
%
%    Ref:
%    T. Saramaki, "Finite Impulse Response Filter Design"
%    Handbook for Digital Signal Processing, Ch. 4
%    Ed. S. K. Mitra and J. F. Kaiser
%    John Wiley & Sons, 1993
%    pgs. 155-277

%  Joe Henning - Dec 2013
       
if nargin < 2
   fprintf('??? Bad beta input to sarawin ==> beta must be specified\n');
   w = [];
   return;
end

if nargin < 3
   p = 1;
end

if nargin < 4
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

gamma = (1 + cos(2*pi/(2*M+1)))/(1 + cos(2*pi*beta/(2*M+1)));

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

w = v(1,:);
for k = 2:size(v,1)
   w = w + 2*v(k,:);
end

if ~mod(N,2)
   wtemp = w/max(w);
   % Every second value is disregarded
   w = wtemp(1:2:size(wtemp,2));
end

% apply power
w = w.^p;

if (normwin)
   % normalize
   w = w(:)/max(w);
else
   w = w(:);
end
