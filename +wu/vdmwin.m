function w = vdmwin(N, beta, p)

% VDMWIN Symmetric van der Maas window
%    VDMWIN(N,BETA,P) returns a symmetric N point van der Maas window with
%    shaping parameter BETA.  P defines the power of the van der Maas
%    window.  When P = 1 (default), a regular van der Maas window is
%    obtained.
%
%    Given an ALPHA parameterization, the equivalent BETA is
%       BETA = pi*ALPHA
%
%    The van der Maas window is characterized by having the narrowest
%    possible mainlobe width for a specified sidelobe level, and vice
%    versa.  The window, however, does not decay at large frequencies.
%
%    See also VDMWORD, DCHEBWIN.
%
%    Ref:
%    Some Windows with Very Good Sidelobe Behavior
%    Albert H. Nuttall
%    IEEE Transactions on Acoustics, Speech, and Signal Processing
%    Vol. ASSP-29, No. 1, February 1981
%    pp. 84-91

%  Joe Henning - Dec 2013
        
if nargin < 2
   fprintf('??? Bad beta input to vdmwin ==> beta must be specified\n');
   w = [];
   return;
end

if nargin < 3
   p = 1;
end

if (N == 1)
   w = 1;
   return
end

M = (N-1)/2;

w = [];
for k = 0:M
   n = k-M;
   if (k == 0)
      w(k+1) = beta*beta/2.0/(N-1) + 0.5;
   else
      w(k+1) = beta*besseli(1,beta*sqrt(1-4*n*n/(N-1)/(N-1)))/((N-1)*sqrt(1-4*n*n/(N-1)/(N-1)));
   end
   w(N-k) = w(k+1);
end

% apply power
w = w.^p;

% normalize
w = w(:)/max(w);
