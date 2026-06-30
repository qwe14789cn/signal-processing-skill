function w = kaiserwin(N, beta, p, normwin, kbdflag)

% KAISERWIN Symmetric Kaiser window
%    KAISERWIN(N,BETA,P,NORMWIN) returns a symmetric N point Kaiser window
%    with shaping parameter BETA.  P defines the power of the Kaiser window. 
%    When P = 1 (default), a regular Kaiser window is obtained.
%
%    When true (default), NORMWIN normalizes the window such that the
%    maximum amplitude is 1.
%
%    Given an ALPHA parameterization, the equivalent BETA is
%       BETA = pi*ALPHA
%
%    The Kaiser window is also called the I0-sinh window.  It achieves a
%    close approximation to the DPSS window which has maximum energy
%    concentration in the mainlobe.
%
%    The Kaiser window can approximate many other windows by varying the
%    beta parameter:
%       beta   Window shape
%       ----   ------------
%          0   Rectangular
%          5   Hanning
%          6   Hamming
%        8.6   Blackman
%       12.2   Blackman-Harris
%
%    W = KAISERWIN(N,BETA,P,NORMWIN,'kbd') returns the Kaiser-Bessel
%    Derived (KBD) window associated with even N, BETA, and P.  The KBD
%    window is designed to be suitable for use with the modified discrete
%    cosine transform (MDCT).
%
%    See also KAISER, KAISERWORD, KAISERORD.

%  Joe Henning - Dec 2013
        
if nargin < 2
   fprintf('??? Bad beta input to kaiserwin ==> beta must be specified\n');
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

if nargin == 5
   if mod(N,2)
      fprintf('??? Bad N input to kaiserwin with kbdflag ==> N must be even\n');
      w = [];
      return
   end
   N = N/2;
end

M = (N-1)/2;

w = [];
for k = 0:M
   n = k-M;
   w(k+1) = besseli(0,beta*sqrt(1-4*n*n/(N-1)/(N-1)))/besseli(0,beta);
   w(N-k) = w(k+1);
end

% apply power
w = w.^p;

if nargin == 5
   d = [];
   sum_mi = 0;
   for k = 1:N
      sum_mi = sum_mi + w(k);
      d(k) = sum_mi;
   end
   
   for k = 1:N
      d(k) = sqrt(d(k)/sum_mi);
      d(2*N-k+1) = d(k);
   end
   
   w = d;
end

if (normwin)
   % normalize
   w = w(:)/max(w);
else
   w = w(:);
end
