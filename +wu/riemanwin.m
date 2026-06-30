function w = riemanwin(n)

% RIEMANWIN Riemann Window
%    RIEMANWIN(N) returns a symmetric N point Riemann window.
 
%  Joe Henning - Aug 2015

if (n == 1)
   w = 1;
   return
end

M = (n-1)/2;

w = [];
w(1) = 1;
for k = 1:M
    w(k+1) = sin(pi*k/M)/(pi*k/M);
end

w = [w(end:-1:2) w];


w = w(:);
