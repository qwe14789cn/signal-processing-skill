function w = legendwin(N, alph, beta)
 
% LEGENDWIN Symmetric Legendre polynomial window
%    LEGENDWIN(N,ALPHA,BETA) returns a symmetric N point Legendre
%    polynomial window with shaping parameters ALPHA and BETA.
%
%    The window may be used to approximate other windows:
%         alpha           beta   Window shape
%         -----           ----   ------------
%       1.00161   6.4793157025   Hamming
%
%    Ref:
%    New windows family based on modified Legendre polynomials
%    Marek Jaskula
%    IEEE Instruments and Measurement
%    Technology Conference
%    Anchorage, AK, USA 21-23 May 2002
%    pgs. 553-556
 
%  Joe Henning - May 2014
 
phi = [0:N-1]*pi/N;
 
n = alph*cos(phi);
 
W(1,:) = ones(1,length(n));
W(2,:) = n + beta;
for k = 3:N-1
    W(k,:) = ((2*k-1)/k.*n.*W(k-1,:) - (k-1)/k.*W(k-2,:));
end
 
if mod(N,2)
    w = real(ifft(W(N-1,:)));
    k = (N+1)/2;
else
    W(N-1,:) = W(N-1,:).*exp(j*pi/N*(0:N-1));
    w = real(ifft(W(N-1,:)));
    k = N/2 + 1;
end
 
% make symmetric
w = [w(k+1:N) w(1:k)];
 
% normalize
w = w(:)/max(w);
