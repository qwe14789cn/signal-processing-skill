function w = nutwin(n,window)

% NUTWIN Symmetric Nuttall window
%    NUTWIN(N,WIN) returns a symmetric N point Nutall window.  WIN
%    specifies the window type:
%       0 : Nutall3,  46.7 dB, 2nd differentiable
%       1 : Nutall3a, 64.2 dB, differentiable
%       2 : Nutall3b, 71.5 dB
%       3 : Nutall4,  60.9 dB, 3rd differentiable
%       4 : Nutall4a, 82.6 dB, 2nd differentiable
%       5 : Nutall4b, 93.3 dB, differentiable
%       6 : Nutall4c, 98.1 dB
%
%    See also NUTTALLWIN.
%
%    Ref:
%    Spectrum and spectral density estimation by the Discrete Fourier transform (DFT), including a comprehensive list of window functions and some new flat-top windows
%    G. Heinzel, A. Rudiger, and R. Schilling
%    Max-Planck-Institut fur Gravitationsphysik
%    (Albert-Einstein-Institut)
%    Teilinstitut Hannover
%    February 15, 2002

%  Joe Henning - 6 May 2013

if nargin < 2
   window = 1;
end

if ~rem(n,2)
   % Even length window
   half = n/2;
   w = calc_window(half,n,window);
   w = [w; w(end:-1:1)];
else
   % Odd length window
   half = (n+1)/2;
   w = calc_window(half,n,window);
   w = [w; w(end-1:-1:1)];
end


function w = calc_window(m,n,window)
% CALC_WINDOW Calculate the window samples
%    CALC_WINDOW calculates and returns the first M points of an
%    N point window determined by the window number

x = (0:m-1)'/(n-1);

switch window
   case 0
      % Nutall3 window, 2nd differentiable, 46.7 dB, NBW 1.9444 bins, first zero at +/- 3 bins
      a0 = 0.375;
      a1 = 0.5;
      a2 = 0.125;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x);
   case 1
      % Nutall3a window, differentiable, 64.2 dB, NBW 1.7721 bins, first zero at +/- 3 bins
      a0 = 0.40897;
      a1 = 0.5;
      a2 = 0.09103;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x);
   case 2
      % Nutall3b window, 71.5 dB, NBW 1.7037 bins, first zero at +/- 3 bins
      a0 = 0.4243801;
      a1 = 0.4973406;
      a2 = 0.0782793;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x);
   case 3
      % Nutall4 window, 3rd differentiable, 60.9 dB, NBW 2.31 bins, first zero at +/- 4 bins
      a0 = 0.3125;
      a1 = 0.46875;
      a2 = 0.1875;
      a3 = 0.03125;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x) - a3*cos(6*pi*x);
   case 4
      % Nutall4a window, 2nd differentiable, 82.6 dB, NBW 2.1253 bins, first zero at +/- 4 bins
      a0 = 0.338946;
      a1 = 0.481973;
      a2 = 0.161054;
      a3 = 0.018027;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x) - a3*cos(6*pi*x);
   case 5
      % Nutall4b window, differentiable, 93.3 dB, NBW 2.0212 bins, first zero at +/- 4 bins
      a0 = 0.355768;
      a1 = 0.487396;
      a2 = 0.144232;
      a3 = 0.012604;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x) - a3*cos(6*pi*x);
   case 6
      % Nutall4c window, 98.1 dB, NBW 1.9761 bins, first zero at +/- 4 bins
      a0 = 0.3635819;
      a1 = 0.4891775;
      a2 = 0.1365995;
      a3 = 0.0106411;
      w = a0 - a1*cos(2*pi*x) + a2*cos(4*pi*x) - a3*cos(6*pi*x);
   otherwise
      error('Unknown WIN type');
end
