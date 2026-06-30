function w = coshwin(N, beta, p, normwin)

% COSHWIN Symmetric hyperbolic cosine window
%    COSHWIN(N,BETA,P,NORMWIN) returns a symmetric N point hyperbolic
%    cosine window with shaping parameter BETA.  P defines the power
%    of the cosh window.  When P = 1 (default), a regular cosh window
%    is obtained.
%
%    When true (default), NORMWIN normalizes the window such that the
%    maximum amplitude is 1.
%
%    Given an ALPHA parameterization, the equivalent BETA is
%       BETA = pi*ALPHA
%
%    See also COSHWORD, COSHORD.
%
%    Ref:
%    Performance of Modified Cosh Window Function
%    Shruti Jain, Dinesh Kumar Verma
%    International Journal of Computers & Technology
%    Vol 9, No 3, pp. 1111-1118

%  Joe Henning - Dec 2013
        
if nargin < 2
   fprintf('??? Bad beta input to coshwin ==> beta must be specified\n');
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

M = (N-1)/2;

w = [];
for k = 0:M
   n = k-M;
   w(k+1) = cosh(beta*sqrt(1-4*n*n/(N-1)/(N-1)))/cosh(beta);
   w(N-k) = w(k+1);
end

% apply power
w = w(:).^p;

if (normwin)
   % normalize
   w = w/max(w);
end
