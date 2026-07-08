function w = barthewin(N, beta, p, ustep)

% BARTHEWIN Symmetric Barcilon-Temes window
%    BARTHEWIN(N,BETA,P) returns a symmetric N point Barcilon-Temes window
%    with shaping parameter BETA.  P defines the power of the Barcilon-Temes
%    window.  When P = 1 (default), a regular Barcilon-Temes window is
%    obtained.
%
%    The Barcilon-Temes window minimizes the weighted minimum energy
%    outside of the mainlobe.  Its response resides between the
%    Kaiser-Bessel and Dolph-Chebyshev windows.
%
%    W = BARTHEWIN(N,BETA,P,USTEP) changes the number of integration
%    points for a window tap (default is 20).
%
%    Ref:
%    Optimum Impulse Response and the van der Maas Function
%    Victor Barcilon and Gabor C. Temes
%    IEEE Transactions on Circuit Theory
%    Vol. CT-19, No. 4, July 1972
%    pp. 336-342

%  Joe Henning - March 2013

if nargin < 2
   fprintf('??? Bad beta input to barthewin ==> beta must be specified\n');
   w = [];
   return;
end

if nargin < 3
   p = 1;
end

if nargin < 4
   ustep = 20;
end

if (N == 1)
   w = 1;
   return
end

if (beta == 0)
   w = ones(N,1);
   return
end

M = (N-1)/2;

istep = 2/(N-1)/ustep;

a = cosh(beta);
b = sinh(beta);
c = 2*pi*a/(beta+b*a);
d = 2*pi*beta/(beta+b*a);

w = [];
for k = 0:M
   n = k-M;
   zeta = 2*n/(N-1);
   s = abs(zeta):istep:1;
%   y = [];
%   for m = 1:length(s)
%      y(m) = besseli(0,beta*sqrt(s(m)*s(m)-zeta*zeta))*sinh(beta*s(m));
%   end
   % vector the above for matlab speed
   y = besseli(0,beta*sqrt(s.*s-zeta*zeta)).*sinh(beta*s);
   w(k+1) = c*besseli(0,beta*sqrt(1-zeta*zeta)) - d*simps(s,y);
   w(N-k) = w(k+1);
end

% apply power
w = w.^p;

% normalize
w = w(:)/max(w);


function z = simps(x,y)
% SIMPS Simple Simpson's Method numerical integration
lx = length(x);
z = 0;

if mod(lx,2) ~= 1
   error('lx must be odd.\n');
end

for k  = 1:2:lx-2
   z = z + (x(k+2)-x(k))*(y(k)+4*y(k+1)+y(k+2))/6.0;
end
