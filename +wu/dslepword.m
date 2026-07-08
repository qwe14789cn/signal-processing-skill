function [N, beta] = dslepword(A, bw)

% DSLEPWORD DPSS window order estimator
%    [N,BETA] = DSLEPWORD(R,BW) is the approximate length N and shaping
%    factor BETA for a DPSS window given R decibels of relative sidelobe
%    attenuation with respect to a mainlobe bandwidth of BW.
%
%    BW represents the time-bandwidth product in normalized radians (0 to
%    1) where bandwidth is measured from 0 to positive band-limit.
%
%    See also DSLEPWIN.

%  Joe Henning - Dec 2013

N = NaN;
beta = NaN;

if nargin < 2
   fprintf('??? Bad bw input to dslepword ==> bw must be specified\n');
   return;
end

R = -A;

if (R > -13.26)
   beta = 0;
   D = 0;
elseif (R >= -50)
   beta = -7.266928419733 - 1.19181071537405*R - 0.0714792325026902*R*R - 0.00218824171897672*R*R*R - 3.27854885929267e-005*R*R*R*R - 1.91913589742536e-007*R*R*R*R*R;
   D = 6.52962667882771 - 0.437914446711405*R + 0.000394163023385266*R*R;
else
   beta = 0.190757682471852 - 0.041382298117979*R - 1.66782839298629e-005*R*R;
   D = 5.71395332518493 - 0.476787201828917*R - 7.45190058001167e-005*R*R;
end

N = D/(bw*2*pi);
N = ceil(N);
