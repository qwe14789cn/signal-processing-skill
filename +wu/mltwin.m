function w = mltwin(N, c, normwin)

% MLTWIN Symmetric Modulated Lapped Transform window
%    MLTWIN(N,TYPE,NORMWIN) returns a symmetric N point Modulated Lapped
%    Transform (MLT) window.  TYPE defines the type of window:
%       1 : Malvar MLT (default)
%       2 : Vorbis MLT
%
%    When true (default), NORMWIN normalizes the window such that the
%    maximum amplitude is 1.
%
%    Note that for a length-M MLT, N = 2*M.
%
%    Ref:
%    Lapped Transforms for Efficient Transform/Subband Coding
%    Henrique S. Malvar
%    IEEE Transactions on Acoustics, Speech, and Signal Processing
%    Vol. 38, No. 6, June 1990
%    pgs. 969-978

%  Joe Henning - Jan 2014

if nargin < 2
   c = 1;
end

if nargin < 3
   normwin = 1;
end

if (N == 1)
   w = 1;
   return
end

w = [];
for k = 0:N-1
   tap = sin((k+0.5)*pi/N);
   switch c
      case 1
         w(k+1) = tap;
      case 2
         w(k+1) = sin(pi*tap*tap/2.0);
      otherwise
         error('Unknown window TYPE');
   end
end

if (normwin)
   % normalize
   w = w(:)/max(w);
else
   w = w(:);
end
