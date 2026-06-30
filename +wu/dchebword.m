function N = dchebword(A, bw)

% DCHEBWORD Dolph-Chebyshev window order estimator
%    [N] = DCHEBWORD(R,BW) is the approximate length N for a  Dolph-Chebyshev
%    window given R decibels of relative sidelobe attenuation with respect
%    to a mainlobe bandwidth of BW.
%
%    BW represents the time-bandwidth product in normalized radians (0 to
%    1) where bandwidth is measured from 0 to positive band-limit.
%
%    See also DCHEBWIN.

%  Joe Henning - Dec 2013

N = NaN;

if nargin < 2
   fprintf('??? Bad bw input to dchebword ==> bw must be specified\n');
   return;
end

R = -A;

if (R > -13.26)
   D = 0;
else
   pn = [ 0.981678883633966 -0.0791758721924475 0.00300983971384747];
   pd = [0.153344220678042 -0.00622243728446775 2.70952611265731e-006];
   D = (pn(1) + pn(2)*R + pn(3)*R^2)/...
       (pd(1) + pd(2)*R + pd(3)*R^2);
end

N = D/(bw*2*pi) + 1;
N = ceil(N);
