function [N, beta] = vdmword(A, bw, approxflag)

% VDMWORD van der Maas window order estimator
%    [N,BETA] = VDMWORD(R,BW) is the approximate length N and shaping
%    factor BETA for a van der Maas window given R decibels of relative
%    sidelobe attenuation with respect to a mainlobe bandwidth of BW.
%
%    BW represents the time-bandwidth product in normalized radians (0 to
%    1) where bandwidth is measured from 0 to positive band-limit.
%
%    [N,BETA] = VDMWORD(R,BW,'approx') uses documented approximations to
%    estimate N and BETA; these come from the equations
%       -R ~ cosh(beta)
%    and
%       (N+1)*w0/2 = (1/4 + B^2/pi^2)^(1/2)
%    where w0 is the normalized frequency of the first null
%
%    See also VDMWIN.
%
%    Ref:
%    Some Windows with Very Good Sidelobe Behavior
%    Albert H. Nuttall
%    IEEE Transactions on Acoustics, Speech, and Signal Processing
%    Vol. ASSP-29, No. 1, February 1981
%    pp. 84-91

%  Joe Henning - Dec 2013

N = NaN;
beta = NaN;

if nargin < 2
   fprintf('??? Bad bw input to vdmword ==> bw must be specified\n');
   return;
end

R = -A;

if (R > -13.26)
   beta = 0;
   D = 0;
else
   beta = 0.656044704901883 - 0.117534386855708*R;

   pn = [0.947909359017785 -0.0723085427584979];
   pd = [0.1816548388685 0.000384437874694227 1.53599102408957e-006];
   D = (pn(1) + pn(2)*R)/...
       (pd(1) + pd(2)*R + pd(3)*R^2);
end

N = D/(bw*2*pi) + 1;

if nargin == 3
   beta = acosh(10^(A/20));
   N = sqrt(1/4 + beta*beta/(pi*pi))/bw*2 + 1;
end

N = ceil(N);
