function w = scoswin(n, alpha)

% SCOSWIN Symmetric Sum-Cosine window
%    SCOSWIN(N,ALPHA) returns a symmetric N point Sum-Cosine window with
%    parameter ALPHA.  Notable values for ALPHA are:
%       0.1   - 52 dB SLL
%       0.103 - 54 dB SLL

%  Joe Henning - Jan 2014
 
if nargin < 2
   fprintf('??? Bad ALPHA input to sumcoswin ==> ALPHA must be specified\n');
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
   w = (1-2*alpha)*cos(pi*x) + 2*alpha*cos(3*pi*x);
   w = [w(end:-1:1); w];
else
   % Odd length window
   m = (n+1)/2;
   x = (0:m-1)'/(n-1);
   w = (1-2*alpha)*cos(pi*x) + 2*alpha*cos(3*pi*x);
   w = [w(end:-1:2); w];
end
