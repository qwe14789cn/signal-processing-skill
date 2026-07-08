function w = uswin(N, mu, x_mu)

% USWIN Symmetric Ultraspherical window
%    USWIN(N,MU,X_MU) returns a symmetric N point Ultraspherical window
%    with parameters MU and X_MU.  MU controls the sidelobe roll-off ratio,
%    and X_MU can be used to prescribe null-to-null width, mainlobe width,
%    or sidelobe ripple ratio.
%
%    For positive values of MU, sidelobes decrease for increasing omega. 
%    For negative values of MU, sidelobes increase.
%
%    When MU = 0, a window is obtained with equal sidelobes.  Also, if
%       X_MU = cos(acos(10^(R/20))/(N-1))
%    a Dolph-Chebyshev window with R decibels of relative sidelobe
%    attenuation is obtained.
%
%    When MU = 1, a Saramaki window is obtained.
%
%    Ref:
%    Nonrecursive Digital Filter Design Using the Ultraspherical Window
%    Bergen, Stuart W. A. and Andreas Antoniou
%    IEEE Pacific Rim Conference on Communications, Computers and Signal Processing, 2003
%    PACRIM, 2003
%    ISBN: 0-7803-7978-0
%    pgs. 260-263

% Joe Henning - Dec 2013

if (N == 1)
   w = 1;
   return
end

M = (N-1)/2;

if mod(N,2)
   A = 0;
else
   A = 0.5;
end

B = 1 - x_mu^(-2);

for k = 0:M
   n = k-M;
   w(k+1) = what(n,M,B,mu,x_mu);
   w(N-k) = w(k+1);
end

% normalize
w = w(:)/what(A,M,B,mu,x_mu);


function c = what (n, M, B, mu, x_mu)
% WHAT Ultraspherical window coefficients
%    WHAT calculates the what coefficients of an Ultraspherical window
%    of length N

sum = 0;
for m = 0:M-abs(n)
   sum = sum + dnchoosek(mu+M-abs(n)-1, M-abs(n)-m)*dnchoosek(M+abs(n), m)*B^(m);
end

if (mu == 0)
   c = x_mu^(2*M)/(M+abs(n))*dnchoosek(mu+M+abs(n)-1, M+abs(n)-1)*sum;
else
   c = mu*x_mu^(2*M)/(M+abs(n))*dnchoosek(mu+M+abs(n)-1, M+abs(n)-1)*sum;
end


function [d] = dnchoosek(n, k)
% DNCHOOSEK Binomial coefficient or all combinations.
%    DNCHOOSEK(N,K) returns the binomial coefficient (N K) = N!/K!(N-K)!.

if (k == 0 || k == n)
   d = 1;
   return
end

if (k == 1 || k == n-1)
   d = n;
   return
end

d = gamma(n+1)/(gamma(k+1)*gamma(n-k+1));

% Also find the derivative:
%a = gamma(n+1);
%b = gamma(k+1);
%c = gamma(n-k+1);
%d = a/(b*c);
%ap = a*psi(n+1);
%bp = b*psi(k+1);
%cp = c*psi(n-k+1);
%dp = (ap*b*c - (bp*c + b*cp)*a)/(b*c*b*c);
