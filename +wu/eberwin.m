function w = eberwin(N, normwin)

% EBERWIN Optimal discrete window for power spectra
%    EBERWIN(N,NORMWIN) returns a symmetric N point window whose weights
%    help provide a good estimator of a power spectrum.
%
%    When true (default), NORMWIN normalizes the window such that the
%    maximum amplitude is 1.
%
%    The sidelobe level of this window is -22.9 dB.
%
%    See also DSLEPWIN.
%
%    Ref:
%    An Optimal Discrete Window for the Calculation of Power Spectra
%    A. Eberhard
%    IEEE Transactions on Audio and Electroacoustics
%    Vol. AU-21, No. 1, February 1973
%    pgs. 37-43

% Joe Henning - Dec 2013

if nargin < 2
   normwin = 1;
end

M = [];
for q = 0:N-1
   for k = 0:N-1
      if (q==k)
         M(q+1,k+1) = 2/N;
      else
         M(q+1,k+1) = sin(2*pi*(q-k)/N)/(pi*(q-k));
      end
   end
end

% The following finds all eigenvalues/vectors of M.  Note that
% this method becomes prohibitively slow for large N.
[v,d] = eig(M);
[maxd,ind] = max(abs(diag(d)));   % dominant eigenvalue
w = abs(v(:,ind));

if (normwin)
   % normalize
   w = w(:)/max(w);
else
   w = w(:);
end
