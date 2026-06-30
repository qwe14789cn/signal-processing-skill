function w = genhamm(n, alpha)

% GENHAMM Generalized Hamming window
%    GENHAMM(N,ALPHA) returns a symmetric N point generalized Hamming
%    window with parameter ALPHA.  ALPHA must satisfy (0 <= ALPHA <= 0.5).
 
%  Joe Henning - Jan 2014
 
if nargin < 2
   fprintf('??? Bad ALPHA input to genhamm ==> ALPHA must be specified\n');
   w = [];
   return;
end

if (alpha < 0 || alpha > 0.5)
   fprintf('??? Bad ALPHA input to genhamm ==> 0 <= ALPHA <= 0.5\n');
   w = [];
   return;
end

if (n == 1)
   w = 1;
   return
end
 
if ~rem(n,2)
   % Even length window
   m = n/2;
   x = (0:m-1)'/(n-1);
   w = (1-alpha) - alpha*cos(2*pi*x);
   w = [w; w(end:-1:1)];
else
   % Odd length window
   m = (n+1)/2;
   x = (0:m-1)'/(n-1);
   w = (1-alpha) - alpha*cos(2*pi*x);
   w = [w; w(end-1:-1:1)];
end
