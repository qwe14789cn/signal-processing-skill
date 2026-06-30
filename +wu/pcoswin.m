function w = pcoswin(N, p)

% PCOSWIN Power of cosine (Bernstein-Rogozinkskii) window
%    PCOSWIN(N,P) returns an N-point power of cosine window.  P defines the
%    power of the cosine basis function.  When P = 1 (default), a regular
%    cosine window is obtained.

%  Joe Henning - Aug 2015

if nargin < 2
   p = 1;
end

% Index vector
k = -(N-1)/2:(N-1)/2;

w = cos(pi*k/N)';

% apply power
w = w.^p;
