function w = taylwin(N, R, nbar, normwin)

% TAYLWIN Symmetric Taylor window
%    TAYLWIN(N,R,NBAR,NORMWIN) returns a symmetric N point Taylor window
%    with R decibels of relative sidelobe attenuation and NBAR
%    nearly-constant sidelobes relative to the mainlobe.  The computation
%    is performed in the time domain.
%
%    When true (default), NORMWIN normalizes the window such that the
%    maximum amplitude is 1.
%
%    See also TAYLORWIN.

%  Joe Henning - Oct 2013

if nargin < 2
   fprintf('??? Bad R input to taylwin ==> R must be specified\n');
   w = [];
   return;
end

if nargin < 3
   fprintf('??? Bad nbar input to taylwin ==> nbar must be specified\n');
   w = [];
   return;
end

if nargin < 4
   normwin = 1;
end

if (N == 1)
   w = 1;
   return
end

rho = 10^(R/20);
A = acosh(rho)/pi;
ss = nbar*nbar/(A*A + (nbar-0.5)*(nbar-0.5));

T = [];
for m = 1:(nbar-1)
   T(m) = taylorcoef(m,nbar,A,ss);
end

M = (N-1)/2;

w = [];
for k = 0:M
   n = k-M;
   sum = 0;
   for m = 1:(nbar-1)
      sum = sum + T(m)*cos(2.0*n*pi*m/N);
   end
   w(k+1) = 1 + 2*sum;
   w(N-k) = w(k+1);
end

if (normwin)
   % normalize
   w = w(:)/max(w);
else
   w = w(:);
end


function F = taylorcoef(m,nbar,A,ss)
% TAYLORCOEF Compute Taylor window coefficients

prod1 = 1;
for n = 1:(nbar-1)
   prod1 = prod1*(1 - m*m/ss/(A*A + (n-0.5)*(n-0.5)));
end

prod2 = 1;
for n = 1:(nbar-1)
   if (n ~= m)
      prod2 = prod2*(1 - m*m/n/n);
   end
end

F = -0.5*((-1)^m)*prod1/prod2;