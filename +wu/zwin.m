function w = zwin(N, wl, normwin)

% ZWIN Symmetric Z-Window
%    ZWIN(N,WL,NORMWIN) returns a symmetric N point Z-Window with dip
%    frequencies WL.  Z-Windows are in the category of steerable sidelobe
%    dip (SSLD) windows.
%
%    WL (vector) specifies the frequencies at which the window magnitude is
%    masked.  WL must be given in normalized radians (0 to 1) where
%    bandwidth is measured from 0 to positive band-limit.
%
%    When true (default), NORMWIN normalizes the window such that the
%    maximum amplitude is 1.
%
%    The Z-Window can approximate many other windows by varying the dip
%    frequencies:
%         L          WL (bins)   Window shape
%        --          ---------   ------------
%         1              2.648   Hamming
%         2           3.5, 4.5   Blackman
%         2        2.785, 4.25   Blackman-Harris (62 dB)
%         3   3.25, 3.75, 6.75   Blackman-Harris (74 dB)
%         3   4.22, 5.25, 21.5   Blackman-Harris (92 dB)
%
%    Example:
%      % One, two, and three dips at N/4
%      w1 = zwin(61,[0.5]);
%      w2 = zwin(61,[0.5 0.5]);
%      w3 = zwin(61,[0.5 0.5 0.5]);
%      wvtool(w1,w2,w3);
%
%    Ref:
%    Design of Windows with Steerable Sidelobe Dips
%    Jicun Zhong, Zhenxiang Han, and Weixue Lu
%    IEEE Transactions on Signal Processing
%    Vol. 40, No. 6, June, 1992
%    pgs. 1452-1459

%  Joe Henning - Jan 2013

if nargin < 2
   fprintf('??? Bad wl input to zwin ==> at least one dip must be specified\n');
   w = [];
   return
end

wl = wl*pi;

L = length(wl);

i = find(wl < 2*pi*L/N | wl > pi);
if ~isempty(i)
   fprintf('??? Bad wl input to zwin ==> pi >= wl >= 2*pi*L/N\n');
   w = [];
   %return
end

% calculate xk
for k = 1:L
   p1 = 1;
   for i = 1:L
      t1 = cot(wl(i)/2.0);
      t2 = tan(pi*k/N);
      p1 = p1*(1 - t1*t1*t2*t2);
   end
   p2 = 1;
   for i = 1:k-1
      t1 = cot(pi*i/N);
      t2 = tan(pi*k/N);
      p2 = p2*(t1*t1*t2*t2 - 1);
   end
   p3 = 1;
   for i = k+1:L
      t1 = cot(pi*i/N);
      t2 = tan(pi*k/N);
      p3 = p3*(1 - t1*t1*t2*t2);
   end
   xk(k) = cos(pi*k/N)*p1/(2*p2*p3);
end

%for k = 2:L
%   if (xk(k) >= xk(k-1))
%      fprintf('??? Error in xk ==> x1 > x2 > ... > xL\n');
%      w = [];
%      return
%   end
%end
%
%if (xk(length(xk)) <= 0)
%   fprintf('??? Error in xk ==> xL > 0\n');
%   w = [];
%   return
%end
%
%t1 = factorial(L)*factorial(L);
%for k = 1:L
%   t2 = t1/factorial(L+k)/factorial(L+k);
%   if (xk(k) >= 1)
%      fprintf('??? Error in xk ==> xk < 1\n');
%      w = [];
%      return
%   end
%end

% calculate window coefficients
t1 = 0;
for k = 1:L
   t1 = t1 + xk(k);
end
for n = 0:N-1
   t2 = 0;
   for k = 1:L
      t2 = t2 + (-1)^(k)*xk(k)*cos((2*n+1)*pi*k/N);
   end
   w(n+1) = 1/(0.5+t1)*(0.5 + t2);
end

if nargin < 3
   normwin = 0;
end

if (normwin)
   % normalize
   w = w(:)/max(w);
else
   w = w(:);
end
