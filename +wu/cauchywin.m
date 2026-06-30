function w = cauchywin(n,alpha)

% CAUCHYWIN Cauchy Window
%    CAUCHYWIN(N,ALPHA) returns a symmetric N point Cauchy window with
%    parameter ALPHA.  Typical values of ALPHA are 3, 4, and 5.
 
%  Joe Henning - Aug 2015

if nargin < 2
    alpha = 3;
end

if (n == 1)
   w = 1;
   return
end

M = (n-1)/2;

w = [];
for k = 0:M
    w(k+1) = 1/(1 + alpha*alpha*k*k/M/M);
end

w = [w(end:-1:2) w];


w = w(:);
