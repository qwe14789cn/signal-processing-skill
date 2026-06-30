function w = simple_bartlett(N, normwin)

% SIMPLE_BARTLETT Bartlett window
%    SIMPLE_BARTLETT(N,NORMWIN) returns a symmetric N point Bartlett window.
%
%    When true (default is false), NORMWIN normalizes the window such that
%    the maximum aplitude is 1.
% 
%    See also BARTLETT

%  Joe Henning - Jan 2014

if nargin < 2
   normwin = 0;
end

if (N == 1)
   w = 1;
   return
end

M = (N-1)/2;

w = [];
for k = 0:M
    w(k+1) = k/M;
    w(N-k) = w(k+1);
end

if (normwin)
   % normalize
   w = w(:)/max(w);
else
   w = w(:);
end
