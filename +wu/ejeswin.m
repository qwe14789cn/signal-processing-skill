function w = ejeswin(N, beta)
 
% EJESWIN Elliptic Jes window
%    EJESWIN(N,B) returns a symmetric N point Elliptic Jes window with
%    shaping parameter B.
%
%    Ref:
%    Elliptic Jes Window Form 2 in Signal processing
%    Claude Ziad Bayeh
%    International Journal of Digital Information and Wireless Communications
%    (IJDIWC) 3(3): 1-9
 
% Joe Henning - April 2014
 
if nargin < 2
    fprintf('??? Bad B input to ejeswin ==> B must be specified\n');
    w = [];
    return
end
 
if (beta == 0)
    w = 0.5*ones(N,1);
    w(1) = 0;
    return
end
 
w = [];
for k = 0:N-1
    x = k/(N-1);
    cx = cos(2*pi*x);
    ang = 1;
    if (cx < 0)
       ang = -1;
    end
    tx = tan(2*pi*x);
    w(k+1) = 0.5*(1 - ang/sqrt(1 + tx*tx/beta/beta));
end
 
w = w(:);
