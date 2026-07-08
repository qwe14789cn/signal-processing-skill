function w = dchebwin(N, R)

% DCHEBWIN Symmetric Dolph-Chebyshev window
%    DCHEBWIN(N,R) returns a symmetric N point Dolph-Chebyshev window with
%    R decibels of relative sidelobe attenuation.  The computation is
%    performed in the time domain as decribed by Antoniou.
%
%    Ref: Antoniou, A., "Digital Filters", McGraw-Hill, 2000.
%
%    See also CHEBWIN.

%  Joe Henning - Oct 2013

if nargin < 2
   fprintf('??? Bad R input to dchebwin ==> R must be specified\n');
   w = [];
   return;
end

if (N == 1)
   w = 1;
   return
end

rho = 10^(R/20);
x0 = cosh((1.0/(N-1))*acosh(rho));

M = (N-1)/2;

w = [];
for k = 0:M
   n = k-M;
   sum = 0;
   for m = 1:M
      sum = sum + chebyshev1(N-1,x0*cos(pi*m/N))*cos(2.0*n*pi*m/N);
   end
   w(k+1) = rho + 2*sum;
   w(N-k) = w(k+1);
end

% normalize
w = w(:)/max(w);


function w = fftchebwin(N, R)
% FFTCHEBWIN Symmetric Dolph-Chebyshev window
%    FFTCHEBWIN(N,R) returns a symmetric N point Dolph-Chebyshev window with R
%    decibels of relative sidelobe attenuation.  The computation is performed
%    in the frequency domain.

rho = 10^(R/20);
beta = cosh((1.0/(N-1))*acosh(rho));

W = [];
for k = 0:N-1
   x = beta*cos(pi*k/N);
   W(k+1) = chebyshev1(N-1,x);   % /chebyshev1(N-1,beta)
end

if mod(N,2)
   w = real(fft(W));
   k = (N+1)/2;
else
   W = W.*exp(j*pi/N*(0:N-1));
   w = real(fft(W));
   k = N/2 + 1;
end

% make symmetric
w = [w(k+1:N) w(1:k)];

% normalize
w = w(:)/max(w);


function T = chebyshev1(n,x)
% CHEBYSHEV1 Compute Chebyshev polynomials of the first kind
%    CHEBYSHEV1 computes the Chebyshev polynomials of the first kind which
%    are defined as the unique polynomials satisfying
%       Tn(x) = cos(n*arccos x) = cosh(n*arccosh x)

if (abs(x) <= 1)
   T = cos(n*acos(x));
else
   T = cosh(n*acosh(x));
end
