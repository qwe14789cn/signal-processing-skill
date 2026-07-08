function w = gegenwin(N, alpha, normwin)

% GEGENWIN Symmetric Gegenbauer weighted window
%    GEGENWIN(N,ALPHA,NORMWIN) returns a symmetric N point window based on
%    a Gegenbauer weighting with parameter ALPHA.
%
%    When true (default), NORMWIN normalizes the window such that the
%    maximum amplitude is 1.
%
%    Gegenbauer polynomials (or ultraspherical polynomials) are orthogonal
%    polynomials over [-1,1] with a weight function of (1 - x^2)^(alpha-1/2).

%  Joe Henning - Dec 2013
        
if nargin < 2
   fprintf('??? Bad alpha input to gegenwin ==> alpha must be specified\n');
   w = [];
   return;
end

if nargin < 3
   normwin = 1;
end

if (alpha < 0.5)
   fprintf('??? Bad alpha input to gegenwin ==> alpha >= 0.5\n');
   w = [];
   return
end

if (N == 1)
   w = 1;
   return
end

M = (N-1)/2;

w = [];
for k = 0:M
   n = (k-M)/M;
   w(k+1) = (1 - n*n)^(alpha-0.5);
   w(N-k) = w(k+1);
end

if (normwin)
   % normalize
   w = w(:)/max(w);
else
   w = w(:);
end
