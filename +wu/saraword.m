function [N, beta] = saraword(A, bw, approxflag)

% SARAWORD Saramaki window order estimator
%    [N,BETA] = SARAWORD(R,BW) is the approximate length N and shaping
%    factor BETA for a Saramaki window given R decibels of relative
%    sidelobe attenuation with respect to a mainlobe bandwidth of BW.
%
%    BW represents the time-bandwidth product in normalized radians (0 to
%    1) where bandwidth is measured from 0 to positive band-limit.
%
%    [N,BETA] = SARAWORD(R,BW,'approx') uses documented approximations to
%    estimate N; these come from the equation
%       N = 2*beta/w0
%    where w0 is the normalized frequency of the first null
%
%    See also SARAWIN.
%
%    Ref:
%    T. Saramaki, "Finite Impulse Response Filter Design"
%    Handbook for Digital Signal Processing, Ch. 4
%    Ed. S. K. Mitra and J. F. Kaiser
%    John Wiley & Sons, 1993
%    pgs. 155-277

%  Joe Henning - Dec 2013

N = NaN;
beta = NaN;

if nargin < 2
   fprintf('??? Bad bw input to saraword ==> bw must be specified\n');
   return;
end

R = -A;

if (R > -13.26)
   beta = 0;
   D = 0;
else
   beta = 0.513933799016027 - 0.0354888125083806*R + 6.30091375715958e-005*R*R + 4.80622156566883e-007*R*R*R + 1.08613232528344e-009*R*R*R*R;

   D = 7.65939862325171 - 0.280943802769384*R + 0.00831244964552806*R*R + 0.000172337141217055*R*R*R + 1.9988282557672e-006*R*R*R*R + 1.31470582797244e-008*R*R*R*R*R + 4.56784649222846e-011*R*R*R*R*R*R + 6.51524049578523e-014*R*R*R*R*R*R*R;
end

N = D/(bw*2*pi) + 1;

if nargin == 3
   N = 2*beta/bw;
end

N = ceil(N);
