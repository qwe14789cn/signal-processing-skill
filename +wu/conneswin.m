function w = conneswin(N, alpha)

% CONNESWIN Symmetric Connes window
%    CONNESWIN(N,ALPHA) returns a symmetric N point Connes window with
%    shaping parameter ALPHA.
%
%    The minimum sidelode level of the Connes window is -28.5 dB (when 
%    ALPHA = 0.4296).

if nargin < 2
   fprintf('??? Bad alpha input to conneswin ==> alpha must be specified\n');
   w = [];
   return;
end

% Index vector
k = -(N-1)/2:(N-1)/2;

x = k/N;
w = (1 - x.*x/alpha/alpha);
w = w(:).^2;
