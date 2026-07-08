function [N, beta] = bartheword(A, bw)

% BARTHEWORD Barcilon-Temes window order estimator
%    [N,BETA] = BARTHEWORD(R,BW) is the approximate length N and shaping
%    factor BETA for a Barcilon-Temes window given R decibels of relative
%    sidelobe attenuation with respect to a mainlobe bandwidth of BW.
%
%    BW represents the time-bandwidth product in normalized radians (0 to
%    1) where bandwidth is measured from 0 to positive band-limit.
%
%    See also BARTHEWIN.

%  Joe Henning - March 2014

N = NaN;
beta = NaN;

if nargin < 2
   fprintf('??? Bad bw input to bartheword ==> bw must be specified\n');
   return;
end

R = -A;

if (R > -12.31)
   beta = 0;
   D = 0;
elseif (R >= -80)
   pn = [0.961292924686011 0.197991344794477 0.011669384610242 0.000172052995854437 1.31711075563721e-006];
   pd = [0.157810646447942 0.0488602491572255 0.00394325651578295 9.35847395106313e-005 1.00748228449383e-006 3.78803432470193e-009];
   beta = (pn(1) + pn(2)*R + pn(3)*R^2 + pn(4)*R^3 + pn(5)*R^4)/...
          (pd(1) + pd(2)*R + pd(3)*R^2 + pd(4)*R^3 + pd(5)*R^4 + pd(6)*R^5);

   pn = [0.995072490446261 -0.0292866015729705 -0.00197654139540056 -2.57068376627845e-005];
   pd = [0.15171314561472 0.00547063275091734 5.87419010085071e-005];
   D = (pn(1) + pn(2)*R + pn(3)*R^2 + pn(4)*R^3)/...
       (pd(1) + pd(2)*R + pd(3)*R^2);
else
   pn = [0.897396716584769 -0.0303823746301407 -0.000780266236962301 -3.94466632084253e-006];
   pd = [0.455134747636465 0.00853044809029188 4.2159917189231e-005 1.76330428904716e-008];
   beta = (pn(1) + pn(2)*R + pn(3)*R^2 + pn(4)*R^3)/...
          (pd(1) + pd(2)*R + pd(3)*R^2 + pd(4)*R^3);

   pn = [-0.998265017982916 -0.0577585900525769 -0.00132139166568932 -1.58379146463719e-005 -1.06185897770954e-007 -3.78451197686737e-010 -5.56902240283242e-013];
   pd = [0.00315476102460015 5.1033983381691e-005 2.15369475246599e-007];
   D = (pn(1) + pn(2)*R + pn(3)*R^2 + pn(4)*R^3 + pn(5)*R^4 + pn(6)*R^5 + pn(7)*R^6)/...
       (pd(1) + pd(2)*R + pd(3)*R^2);
end

N = D/(bw*2*pi) + 1;
N = ceil(N);
