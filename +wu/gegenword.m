function [N, alpha] = gegenword(A, bw)

% GEGENWORD Gegenbauer weighted window order estimator
%    [N,ALPHA] = GEGENWORD(R,BW) is the approximate length N and shaping
%    factor ALPHA for a Gegenbauer weighted window given R decibels of
%    relative sidelobe attenuation with respect to a mainlobe bandwidth of
%    BW.
%
%    BW represents the time-bandwidth product in normalized radians (0 to
%    1) where bandwidth is measured from 0 to positive band-limit.
%
%    See also GEGENWIN.

%  Joe Henning - Dec 2013

N = NaN;
alpha = NaN;

if nargin < 2
   fprintf('??? Bad bw input to gegenword ==> bw must be specified\n');
   return;
end

R = -A;

if (R > -13.26)
   alpha = 0;
   D = 0;
else
   alpha = -0.318017652184417 - 0.0188066673543331*R + 0.00370079186192669*R*R + 2.89564770124448e-005*R*R*R + 1.30561163264059e-007*R*R*R*R + 2.50471261535116e-010*R*R*R*R*R;

   pn = [-0.990895751600888 0.0271375815599398 -0.00329483134936172];
   pd = [-0.118638421812996 0.00241445416403795 2.09483936899459e-007];
   D = (pn(1) + pn(2)*R + pn(3)*R^2)/...
       (pd(1) + pd(2)*R + pd(3)*R^2);
end

N = D/(bw*2*pi) + 1;
N = ceil(N);
