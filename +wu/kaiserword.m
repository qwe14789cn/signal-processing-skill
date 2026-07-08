function [N, beta] = kaiserword(A, bw)

% KAISERWORD Kaiser window order estimator
%    [N,BETA] = KAISERWORD(R,BW) is the approximate length N and shaping
%    factor BETA for a Kaiser window given R decibels of relative sidelobe
%    attenuation with respect to a mainlobe bandwidth of BW.
%
%    BW represents the time-bandwidth product in normalized radians (0 to
%    1) where bandwidth is measured from 0 to positive band-limit.
%
%    See also KAISER, KAISERWIN.

%  Joe Henning - Dec 2013

N = NaN;
beta = NaN;

if nargin < 2
   fprintf('??? Bad bw input to kaiserword ==> bw must be specified\n');
   return;
end

R = -A;

% original, with polynomials
%if (R > -13.26)
%   beta = 0;
%   D = 0;
%elseif (R >= -20)
%   beta = -1164.14391818205 - 343.606841829255*R - 40.5299307026549*R*R - 2.38732039318705*R*R*R - 0.0701499413589057*R*R*R*R - 0.000822390983114953*R*R*R*R*R;
%   D = 6.23974330242298 - 0.453990506234273*R;
%elseif (R >= -54)
%   beta = -0.840073684130163 - 0.15498609142865*R;
%   D = 6.29903562226494 - 0.429970215798375*R + 0.000990759660519596*R*R;
%else
%   beta = 0.788322042520224 - 0.124504649431397*R;
%   D = -62.0230019027655 - 4.43459802024911*R - 0.0882545748805074*R*R - 0.000949973885307498*R*R*R - 4.93510133777466e-06*R*R*R*R - 9.91682615719669e-09*R*R*R*R*R;
%end

% with rational polynomials
if (R > -13.26)
   beta = 0;
   D = 0;
else
   pn = [0.715938627678121 0.203942994535355 0.0147378272897758 0.000276078576892056 1.60687249545458e-006];
   pd = [-0.65680791715325 -0.0679055458055719 -0.00116105763035389 -2.56245795835672e-006 4.65577422775788e-008 8.12834811146935e-011];
   beta = (pn(1) + pn(2)*R + pn(3)*R^2 + pn(4)*R^3 + pn(5)*R^4)/...
          (pd(1) + pd(2)*R + pd(3)*R^2 + pd(4)*R^3 + pd(5)*R^4 + pd(6)*R^5);

   pn = [0.990811201803234 -0.0173469723085628 -0.000918101519498532 -8.75750303063659e-006];
   pd = [0.14024895002036 0.00474127003552376 6.49578886747074e-005 4.49348476501917e-007 2.17671231058145e-009 4.17883314295998e-012];
   D = (pn(1) + pn(2)*R + pn(3)*R^2 + pn(4)*R^3)/...
       (pd(1) + pd(2)*R + pd(3)*R^2 + pd(4)*R^3 + pd(5)*R^4 + pd(6)*R^5);
end

N = D/(bw*2*pi) + 1;
N = ceil(N);
