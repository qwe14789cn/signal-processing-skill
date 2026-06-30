function [N, beta] = expword(A, bw)

% EXPWORD Exponential window order estimator
%    [N,BETA] = EXPWORD(R,BW) is the approximate length N and shaping
%    factor BETA for an exponential window given R decibels of relative
%    sidelobe attenuation with respect to a mainlobe bandwidth of BW.
%
%    BW represents the time-bandwidth product in normalized radians (0 to
%    1) where bandwidth is measured from 0 to positive band-limit.
%
%    See also EXPWIN.

% Exponential Window Family
% K. Avci and A. Nacaroglu
% Signal & Image Processing: An International Journal (SIPIJ)
% Vol. 4, No. 4, August 2013

%  Joe Henning - Dec 2013

N = NaN;
beta = NaN;

if nargin < 2
   fprintf('??? Bad bw input to expword ==> bw must be specified\n');
   return;
end

R = -A;

if (R > -13.26)
   beta = 0;
   D = 0;
elseif (R > -50)
   beta = -1.513E-3*R*R - 0.2809*R - 3.398;
   D = -7.58E-5*R*R*R + 7.22E-3*R*R - 0.3566*R + 4.312;
else
   beta = -1.085E-4*R*R - 0.1506*R - 0.304;
   D = -1.297E-4*R*R - 0.5281*R + 4.708;
end

N = D/(bw*2*pi) + 1;
N = ceil(N);
