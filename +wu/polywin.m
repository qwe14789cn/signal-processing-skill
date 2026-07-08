function w = polywin(N, m)

% POLYWIN Polynomial window
%    POLYWIN(N,M) returns a symmetric N point polynomial window of
%    continuity order M.  The polynomial window allows desired order of
%    continuity at the boundary of observation windows.
%
%    Ref:
%    Desired Order Continuous Polynomial Time Window Functions for Harmonic Analysis
%    Puneet Singla and Tarunraj Singh

%  Joe Henning - May 2016
        
if nargin < 2
   fprintf('??? Bad m input to polywin ==> m must be specified\n');
   w = [];
   return;
end

if (m < 0)
   fprintf('??? Bad m input to polywin ==> m >= 0\n');
   w = [];
   return
end

if (N == 1)
   w = 1;
   return
end

Km = factorial(2*m+1)*(-1)^(m)/factorial(m)/factorial(m);

M = (N-1)/2;

w = [];
for k = 0:M
   t = (k-M)/M;
   s = 0;
   for n = 0:m
      Cmn = factorial(m)/factorial(n)/factorial(m-n);
      Amn = (-1)^(n)*Cmn/(2*m-n+1);
      s = s + Amn*(abs(t))^(2*m-n+1);
   end
   w(k+1) = 1 - Km*s;
   w(N-k) = w(k+1);
end

% normalize
%w = w(:)/max(w);
