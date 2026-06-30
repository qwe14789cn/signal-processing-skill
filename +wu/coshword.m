function [N, beta] = coshword(A, bw)

% COSHWORD Hyperbolic cosine window order estimator
%    [N,BETA] = COSHWORD(R,BW) is the approximate length N and
%    shaping factor BETA for a hyperbolic cosine window given
%    R decibels of relative sidelobe attenuation with respect
%    to a mainlobe bandwidth of BW.
%
%    BW represents the time-bandwidth product in normalized
%    radians (0 to 1) where bandwidth is measured from 0 to
%    positive band-limit.
%
%    See also COSHWIN.

% Cosine Hyperbolic Window Family with its Application to FIR Filter Design
% K. Avci and A. Nacaroglu
% 3rd International Conference on Information and Communication Technologies: From Theory to Applications, 2008
% ICTTA 2008
% 10.1109/ICTTA.2008.4530047 
% pp. 1-6

%  Joe Henning - Dec 2013

N = NaN;
beta = NaN;

if nargin < 2
   fprintf('??? Bad bw input to coshword ==> bw must be specified\n');
   return;
end

R = -A;

if (R > -13.26)
   beta = 0;
   D = 0;
else
   beta = -7.18E-4*R*R - 0.225*R - 2.519;
   D = -7.848E-4*R*R - 0.616*R + 1.815;
end

N = D/(bw*2*pi) + 1;
N = ceil(N);
