function w = tukey(n,alpha)

% TUKEY Tapered Cosine Window
%    TUKEY(N,ALPHA) returns a symmetric N point Tukey window with parameter
%    ALPHA.  The default value of ALPHA is 0.5.  When ALPHA = 0, the window
%    is rectangular.  When ALPHA = 1, the window is a Hanning window.
 
%  Joe Henning - Aug 2015

if nargin < 2
   alpha = 0.5;
end

if (n == 1)
   w = 1;
   return
end

if (alpha == 0)
    w = ones(n,1);
    return
end

M = (n-1)/2;

w = [];
for k = 0:M
    if (k <= alpha*M)
        w(k+1) = 0.5*(1 + cos(pi*(k/alpha/M - 1)));
    else
        w(k+1) = 1;
    end
    w(n-k) = w(k+1);
end


w = w(:);
