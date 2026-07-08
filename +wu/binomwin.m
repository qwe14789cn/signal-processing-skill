function w = binomwin(N)

% BINOMWIN Symmetric Binomial window
%    BINOMWIN(N) returns a symmetric N point binomial window.

%  Joe Henning - Nov 2016

if (N == 1)
   w = 1;
   return
end

w = [];

for k = 0:N-1
   w(k+1) = nchoosek(N-1,k);
end

% normalize
w = w(:)/max(w);
