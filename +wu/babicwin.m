function [w, I] = babicwin(M, N, L, normwin)

% BABICWIN Symmetric Babic-Temes window
%    BABICWIN(M,N,L,NORMWIN) returns a symmetric 2*M+1 point Babic-Temes
%    window which is a least-square approximations to an optimal N point
%    window.  M must be less than N/2.
%
%    L specifies the widening factor of the mainlobe, which introduces
%    smoothing into the calculation of the spectrum and may be desirable
%    for noisy signals.  It defaults to 1.
%
%    When true (default), NORMWIN normalizes the window such that the
%    maximum amplitude is 1.
%
%    See also EBERWIN, DSLEPWIN.
%
%    Ref:
%    Optimum Low-Order Windows for Discrete Fourier Transform Systems
%    Hrvoje Babic and Gabor C. Temes
%    IEEE Transactions on Acoustics, Speech, and Signal Processing
%    Vol. ASSP-24, No. 6, December 1976 
%    pp. 512-517

%  Joe Henning - March 2013

if nargin < 3
   L = 1;
end

if nargin < 4
   normwin = 1;
end

if M > N/2
   fprintf('   Error ==> M must be < N/2 ');
   w = [];
   return
end

G = zeros(2*M+1,2*M+1);
for i = -M:M
   for k = -M:M
      sum1 = 0;
      for m = 0:N-1
         sum2 = 0;
         for n = 0:N-1
            if (m == n)
               sum2 = sum2 + exp(-j*2*pi*n*i/N);
            else
               sum2 = sum2 + exp(-j*2*pi*n*i/N)*sin(L*(m-n)*2*pi/N)/(L*(m-n)*2*pi/N);
            end
         end
         sum1 = sum1 + exp(j*pi*2*m*k/N)*sum2;
      end
      G(i+M+1,k+M+1) = exp(j*pi*(i-k)*(1-1/N))*sum1;
   end
end

% The following finds all eigenvalues/vectors of M.  Note that
% this method becomes prohibitively slow for large N.
[v,d] = eig(G);
[maxd,ind] = max(abs(diag(d)));   % dominant eigenvalue
w = real(v(:,ind));

I = 2*L*maxd/N/N;

if (normwin)
   % normalize
   w = w(:)/max(w);
else
   w = w(:);
end
