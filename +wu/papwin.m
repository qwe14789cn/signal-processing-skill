function w = papwin(N)

% PAPWIN Symmetric Papoulis window
%    PAPWIN(N) returns a symmetric N point Papoulis window.  The Papoulis
%    window is a minimum bias window that is derived by minimizing the
%    second moment of the window's Fourier transform.
%
%    Ref:
%    Minimum-bias Windows for High-Resolution Spectral Estimates
%    A. Papoulis
%    IEEE Trans. Inform. Theory, Vol. IT-19, no. 1
%    pgs. 9-12

%  Joe Henning - Feb 2016

if (N == 1)
   w = 1;
   return
end

M = (N-1)/2;

w = [];
for k = 0:M
   n = k-M;
   w(k+1) = (1 - abs(n)/M)*cos(pi*n/M) + sin(pi*abs(n)/M)/pi;
   w(N-k) = w(k+1);
end

w = w(:);
