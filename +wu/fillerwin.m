function w = fillerwin(n, alpha, normwin, eflag)

% FILLERWIN Symmetric Filler window
%    FILLERWIN(N,ALPHA,NORMWIN) returns a symmetric N point Filler D window
%    with shaping parameter ALPHA.
%
%    When true (default), NORMWIN normalizes the window such that the
%    maximum amplitude is 1.
%
%    W = FILLERWIN(N,ALPHA,NORMWIN,'e') returns a Filler E window with
%    shaping parameter ALPHA.
%
%    The minimum sidelode of the D window is -54.5 dB (when ALPHA = 0.2589).
%
%    The minimum sidelobe of the E window is -68 dB (when ALPHA = 0.21).
%
%    Ref:
%    Apodizing functions for Fourier transform spectroscopy
%    David A. Naylor and Margaret K. Tahic
%    J. Opt. Soc. Am. A/Vol. 24, No. 11/November 2007
%    pgs. 3644-3648

%  Joe Henning - Jan 2014
 
if nargin < 2
   fprintf('??? Bad ALPHA input to fillerwin ==> ALPHA must be specified\n');
   w = [];
   return;
end

if (alpha < 0 || alpha > 1)
   fprintf('??? Bad ALPHA input to fillerwin ==> 0 <= ALPHA <= 1\n');
   w = [];
   return;
end

if (n == 1)
   w = 1;
   return
end

if nargin < 3
   normwin = 1;
end
 
if ~rem(n,2)
   % Even length window
   m = n/2;
   x = (0:m-1)'/(n-1);
   if nargin == 4
      w = (1 + alpha)*cos(2*pi*x) + alpha*cos(4*pi*x);
   else
      w = cos(pi*x) + alpha*cos(3*pi*x);
   end
   w = [w(end:-1:1); w];
else
   % Odd length window
   m = (n+1)/2;
   x = (0:m-1)'/(n-1);
   if nargin == 4
      w = 1 + (1 + alpha)*cos(2*pi*x) + alpha*cos(4*pi*x);
   else
      w = cos(pi*x) + alpha*cos(3*pi*x);
   end
   w = [w(end:-1:2); w];
end

if (normwin)
   % normalize
   w = w(:)/max(w);
end
