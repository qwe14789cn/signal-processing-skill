function w = parawin(n,alpha)

% PARAWIN Parabolic (Riesz) Window
%    PARAWIN(N,ALPHA) returns a symmetric N point Parabolic window with
%    parameter ALPHA.  The default value of ALPHA is 1.
%
%    ALPHA must lie within the range 0 <= ALPHA <= 1.  When ALPHA = 0, the
%    window is rectangular.  When ALPHA = 1, the window is a Riesz window.
 
%  Joe Henning - Aug 2015

if nargin < 2
    alpha = 1;
end

if (n == 1)
   w = 1;
   return
end

if (alpha < 0)
   alpha = 0;
end

if (alpha > 1)
   alpha = 1;
end

M = (n-1)/2;

w = [];
for k = 0:M
    w(k+1) = 1 - alpha*alpha*k*k/M/M;
end

w = [w(end:-1:2) w];


w = w(:);
