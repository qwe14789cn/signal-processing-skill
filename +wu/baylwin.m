function w = baylwin(N, R, nbar, normwin)

% BAYLWIN Symmetric Bayliss taper
%    BAYLWIN(N,R,NBAR,NORMWIN) returns a symmetric N point Bayliss taper
%    with R decibels of relative sidelobe attenuation and NBAR
%    nearly-constant sidelobes relative to the mainlobe.  The computation
%    is performed in the time domain.
%
%    When true (default), NORMWIN normalizes the window such that the
%    maximum amplitude is 1.

%  Joe Henning - Oct 2013

if nargin < 2
   fprintf('??? Bad R input to baylwin ==> R must be specified\n');
   w = [];
   return;
end

if nargin < 3
   fprintf('??? Bad nbar input to baylwin ==> nbar must be specified\n');
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

A   = 0.30387530 + R*(0.05042922 + R*(-0.00027989 + R*( 0.00000343 + R*(-0.00000002))));
xi1 = 0.98583020 + R*(0.03338850 + R*( 0.00014064 + R*(-0.00000190 + R*( 0.00000001))));
xi2 = 2.00337487 + R*(0.01141548 + R*( 0.00041590 + R*(-0.00000373 + R*( 0.00000001))));
xi3 = 3.00636321 + R*(0.00683394 + R*( 0.00029281 + R*(-0.00000161 + R*( 0.00000000))));
xi4 = 4.00518423 + R*(0.00501795 + R*( 0.00021735 + R*(-0.00000088 + R*( 0.00000000))));

U = [];
for m = 1:(nbar-1)
   U(m) = (nbar+0.5)/sqrt(A*A + nbar*nbar);
   if (m == 1)
      U(m) = U(m)*xi1;
   elseif (m == 2)
      U(m) = U(m)*xi2;
   elseif (m == 3)
      U(m) = U(m)*xi3;
   elseif (m == 4)
      U(m) = U(m)*xi4;
   else
      U(m) = U(m)*sqrt(A*A + m*m);
   end
end

B = [];
for m = 0:(nbar-1)
   B(m+1) = baylisscoef(m,nbar,U);
end

M = (N-1)/2;

w = [];
for k = 0:M
   n = k-M;
   sum = 0;
   for m = 0:(nbar-1)
      sum = sum + B(m+1)*sin(2.0*n*pi*(m+0.5)/N);
   end
   w(k+1) = sum;
   w(N-k) = -w(k+1);
end

if (normwin)
   % normalize
   w = w(:)/max(w);
else
   w = w(:);
end


function F = baylisscoef(m,nbar,U)
% BAYLISSCOEF Compute Bayliss window coefficients

prod1 = 1;
for n = 1:(nbar-1)
   prod1 = prod1*(1 - (m+0.5)*(m+0.5)/U(n)/U(n));
end

prod2 = 1;
for n = 0:(nbar-1)
   if (n ~= m)
      prod2 = prod2*(1 - (m+0.5)*(m+0.5)/(n+0.5)/(n+0.5));
   end
end

F = -0.5*((-1)^m)*(m+0.5)*(m+0.5)*prod1/prod2;
