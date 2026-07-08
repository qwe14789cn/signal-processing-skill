function w = dslepwin(N, bvar, normwin, betaflag)

% DSLEPWIN Symmetric DPSS window
%    DSLEPWIN(N,BW,NORMWIN) returns a symmetric Discrete Prolate Spheroidal
%    Sequences (DPSS) window with bandwidth parameter BW.  BW represents
%    the time-bandwidth product in normalized radians (0 to 1) where
%    bandwidth is measured from 0 to positive band-limit.
%
%    When true (default), NORMWIN normalizes the window such that the
%    maximum amplitude is 1.
%
%    The DPSS window is used to maximize the energy concentration in the
%    mainlobe.  Slepian showed that index-limited DPSSs satisfy a
%    particular difference equation.  The DSLEPWIN solution is obtained by
%    finding the eigenvector associated with the dominant eigenvalue of a
%    symmetric tridiagonal matrix consistent with Slepian's difference
%    equation reformulation.
%
%    W = DSLEPWIN(N,BETA,NORMWIN,'beta') replaces BW with BETA.  The two
%    are related by
%       BETA = BW*N/2
%
%    See also DPSS, DSLEPWORD.
%
%    Ref:
%    The Digital Signal Processing Handbook, Second Edition
%    Vijay Madisetti
%    CRC Press, 2009
%    pgs. 11-16 - 11-17

% Joe Henning - Dec 2013

if nargin < 2
   fprintf('??? Bad bw input to dslepwin ==> bw must be specified\n');
   w = [];
   return;
end

if nargin < 3
   normwin = 1;
end

if (N == 1)
   w = 1;
   return
end

if nargin == 4
   bw = 2*bvar/N;
else
   bw = bvar;
end

if (bw > 1)
   fprintf('??? Bad bw input to dslepwin ==> bw <= 1\n');
   w = [];
   return;
end

W = bw/2;

T = [];
for i = 0:N-1
   for j = 0:N-1
      if (j == i-1)
         T(i+1,j+1) = 0.5*i*(N-i);
      elseif (j == i)
         T(i+1,j+1) = ((N-1)/2-i)*((N-1)/2-i)*cos(2*pi*W);
      elseif (j == i+1)
         T(i+1,j+1) = 0.5*(i+1)*(N-1-i);
      end
   end
end

% The following finds all eigenvalues/vectors of T.  Note that
% this method becomes prohibitively slow for large N.
[v,d] = eig(T);
[maxd,ind] = max(abs(diag(d)));   % dominant eigenvalue
w = abs(v(:,ind));

%% T can be large, and is sparse.  Use eigs.  Doesn't seem to be fast though.
%sT = sparse(T);
%opts.disp = 0;
%[v,d] = eigs(sT,1,'lm',opts);
%w = abs(v);

if (normwin)
   % normalize
   w = w(:)/max(w);
else
   w = w(:);
end
