function w = rcoswin(n, b)

% RCOSWIN Symmetric Raised-Cosine window
%    RCOSWIN(N,BETA) returns a symmetric N point Raised-Cosine window with
%    shaping parameter BETA.  Notable values for BETA are:
%       0.0 - 26.4 dB SLL
%       0.5 - 28.6 dB SLL
%       1.0 - 36.6 dB SLL

%  Joe Henning - Jan 2014
 
if nargin < 2
   fprintf('??? Bad BETA input to rcoswin ==> BETA must be specified\n');
   w = [];
   return;
end

if (n == 1)
   w = 1;
   return
end

if (b == 0)
   % Avoid divide by zero warnings
   b = eps;
end

m = (n-1)/2;
x = (-m:m)/m;
i = find(x == -1/(2*b) | x == 1/(2*b));
x(i) = 1;   % Don't need this if divide-by-zero warning is off
w = sinc(x).*cos(pi*b*x)./(1-(2*b*x).*(2*b*x));
w(i) = pi/4*sinc(1/(2*b));

w = w(:);