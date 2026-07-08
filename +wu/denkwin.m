function w = denkwin(N, alpha)

% DENKWIN Symmetric Denk window
%    DENKWIN(N,ALPHA) returns a symmetric N point Denk window with
%    parameter ALPHA.  ALPHA must be >= 0.
%
%    The Denk window possesses exponential convergence order.
%
%    Ref:
%    Filter Functions with Exponential Convergence Order
%    Robert Denk
%    Mathematische Nachrichten 169 (1994), 1
%    pgs. 107-115

%  Joe Henning - Dec 2013
        
if nargin < 2
   fprintf('??? Bad alpha input to denkwin ==> alpha must be specified\n');
   w = [];
   return;
end

if (alpha < 0)
   fprintf('??? Bad alpha input to denkwin ==> alpha >= 0\n');
   w = [];
   return
end

if (N == 1)
   w = 1;
   return
end

if (alpha == 0)
   w = ones(N,1);
   return
end

M = (N-1)/2;

beta = 2^(alpha+1.5) * alpha^(alpha-1);

w = [];
for k = 0:M
   n = (k-M)/M;
   if (k == 0)
      w(k+1) = 0;
   else
      f = -beta * (1/(1-n*n))^(alpha);
      w(k+1) = exp(f);
   end
   w(N-k) = w(k+1);
end

% normalize
w = w(:)/max(w);
