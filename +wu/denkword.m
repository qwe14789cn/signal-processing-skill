function [N, alpha] = denkword(A, bw)

% DENKWORD Denk window order estimator
%    [N,ALPHA] = DENKWORD(R,BW) is the approximate length N and shaping
%    factor ALPHA for a Denk window given R decibels of relative sidelobe
%    attenuation with respect to a mainlobe bandwidth of BW.
%
%    BW represents the time-bandwidth product in normalized radians (0 to
%    1) where bandwidth is measured from 0 to positive band-limit.
%
%    See also DENKWIN.

%  Joe Henning - Dec 2013

N = NaN;
alpha = NaN;

if nargin < 2
   fprintf('??? Bad bw input to denkword ==> bw must be specified\n');
   return;
end

R = -A;

if (R > -13.26)
   alpha = 0;
   D = 0;
else
   pn = [-0.994333821278243 -0.0898849244191318 -0.00191379570756554 1.65604542169875e-006];
   pd = [0.0321785556583871 -0.0187974733738137 -0.000777332754245418];
   alpha = (pn(1) + pn(2)*R + pn(3)*R^2 + pn(4)*R^3)/...
           (pd(1) + pd(2)*R + pd(3)*R^2);

   pn = [0.977839531870183 0.120387779100406 0.0005504272359361 -0.000103520615134533 -4.74079389959666e-007 -9.85000311299867e-010];
   pd = [-0.11710327042773 -0.00423673819272466];
   D = (pn(1) + pn(2)*R + pn(3)*R^2 + pn(4)*R^3 + pn(5)*R^4 + pn(6)*R^5)/...
       (pd(1) + pd(2)*R);
end

N = D/(bw*2*pi) + 1;
N = ceil(N);
