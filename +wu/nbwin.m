function w = nbwin(n,window)

% NBWIN Symmetric extended Norton-Beer window
%    NBWIN(N,WIN) returns a symmetric N point extended Norton-Beer
%    window.  WIN specifies the type of window:
%       0 : Relative FWHM 1.0,  13.3 dB
%       1 : Relative FWHM 1.1,  20.3 dB
%       2 : Relative FWHM 1.2,  25.3 dB
%       3 : Relative FWHM 1.3,  31.3 dB
%       4 : Relative FWHM 1.4,  37.2 dB
%       5 : Relative FWHM 1.5,  36.1 dB
%       6 : Relative FWHM 1.6,  35.8 dB
%       7 : Relative FWHM 1.64, 35.4 dB
%       8 : Relative FWHM 1.7,  36.0 dB
%       9 : Relative FWHM 1.77, 36.8 dB
%      10 : Relative FWHM 1.83, 38.7 dB
%     102 : Relative FWHM 1.2, original, 24.8 dB
%     104 : Relative FWHM 1.4, original, 37.2 dB
%     106 : Relative FWHM 1.6, original, 36.0 dB
%
%    Ref:
%    Apodizing functions for Fourier transform spectroscopy
%    David A. Naylor and Margaret K. Tahic
%    J. Opt. Soc. Am. A/Vol. 24, No. 11/November 2007
%    pgs. 3644-3648

%  Joe Henning - Jan 2014
 
if nargin < 2
   window = 2;
end

if (n == 1)
   w = 1;
   return
end
 
if ~rem(n,2)
   % Even length window
   half = n/2;
   w = calc_window(half,n,window);
   w = [w(end:-1:1); w];
else
   % Odd length window
   half = (n+1)/2;
   w = calc_window(half,n,window);
   w = [w(end:-1:2); w];
end


function w = calc_window(m,n,window)
% CALC_WINDOW Calculate the window samples
%    CALC_WINDOW calculates and returns the first M points of an
%    N point window determined by the window number
 
x = (0:m-1)'/(n-1);

switch window
   case 0
      % Relative FWHM 1, 13.3 dB, NBW 1 bin
      C = [1];
   case 1
      % Relative FWHM 1.1, 20.3 dB, NBW 1.0361 bins
      C = [0.701551 -0.639244 0.937693];
   case 2
      % Relative FWHM 1.2, 25.3 dB, NBW 1.0992 bins
      C = [0.396430 -0.150902 0.754472];
   case 3
      % Relative FWHM 1.3, 31.3 dB, NBW 1.1811 bins
      C = [0.237413 -0.065285 0.827872];
   case 4
      % Relative FWHM 1.4, 37.2 dB, NBW 1.2692 bins
      C = [0.153945 -0.141765 0.987820];
   case 5
      % Relative FWHM 1.5, 36.1 dB, NBW 1.3463 bins
      C = [0.077112 0 0.703371 0.219517];
   case 6
      % Relative FWHM 1.6, 35.8 dB, NBW 1.4241 bins
      C = [0.039234 0 0.630268 0.234934 0.095563];
   case 7
      % Relative FWHM 1.64, 35.4 dB, NBW 1.4886 bins
      C = [0.020078 0 0.480667 0.386409 0.112845];
   case 8
      % Relative FWHM 1.7, 36.0 dB, NBW 1.5474 bins
      C = [0.010172 0 0.344429 0.451817 0.193580];
   case 9
      % Relative FWHM 1.77, 36.8 dB, 1.6009 bins
      C = [0.004773 0 0.232473 0.464562 0.298191];
   case 10
      % Relative FWHM 1.83, 38.7 dB, 1.6534 bins
      C = [0.002267 0 0.140412 0.487172 0.256200 0.113948];
   case 102
      % Relative FWHM 1.2, 24.8 dB, NBW 1.0989 bins, original
      C = [0.384093 -0.087577 0.703484];
   case 104
      % Relative FWHM 1.4, 37.2 dB, NBW 1.2695 bins, original
      C = [0.152442 -0.136176 0.983734];
   case 106
      % Relative FWHM 1.6, 36.0 dB, NBW 1.4176 bins, original
      C = [0.045335 0 0.554883 0.399782];
   otherwise
      error('Unknown WIN type');
end

w = zeros(size(x));
for k = 1:length(C)
   w = w + C(k)*(1 - 4*x.*x).^(k-1);
end
