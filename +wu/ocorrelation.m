function oc = ocorrelation(w,r)

% OCORRELATION Overlap correlation
%    OCORRELATION(W,R) computes the overlap correlation (OC) for window W
%    given an overlap R.  If the overlap becomes too big, spectrum
%    estimates from subsequent stretches become strongly correlated, even
%    if the signal is random.

%  Joe Henning - Jan 2014

w = w(:);

N = length(w);

% Compute noise power
sw2 = sum(w.*w);

oc = 0;
for k = 1:r*N
   ind = k + (1-r)*N;
   il = fix(ind);
   ih = il + 1;
   if (ind == il)
      w2 = w(ind);
   else
      % linear interpolation
      w2 = w(il) + (ind-il)*(w(ih)-w(il));
   end
   oc = oc + w(k)*w2;
end
oc = oc/sw2;
