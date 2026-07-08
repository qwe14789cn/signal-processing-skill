function w = rifevwin(N, M, class, normwin, R)

% RIFEVWIN Symmetric Rife-Vincent window
%    RIFEVWIN(N,M,CLASS,NORMWIN,R) returns a symmetric N point Rife-Vincent
%    window of class CLASS and order M.  CLASS can be:
%       1 - Provides the best possible reduction in frequency
%           magnitude as frequency increases and the minimum 
%           high-order sidelobe amplitude for a given M
%       2 - Uses a Taylor approximation to give minimum mainlobe
%           width at the expense of higher sidelobe amplitude
%       3 - Combines properties of both classes 1 and 2.
%    R specifies the relative sidelobe attenuation (in decibels) of a class
%    2 window.  If omitted, R is set to 60 decibels.
%
%    When true (default), NORMWIN normalizes the window such that the
%    maximum amplitude is 1.
%
%    The Rife-Vincent window is equivalent to or can approximate other
%    windows:
%       Class   M   Window shape
%       -----   -   ------------
%         1,3   1   Hanning
%           3   2   Blackman
%
%    Ref:
%    Use of the Discrete Fourier Transform in the Measurement of Frequencies and Levels of Tones
%    D. C. Rife and G. A. Vincent
%    Bell System Technical Journal, Vol. 49 (2), February, 1970
%    pgs. 197-228

%  Joe Henning - Jan 2013

if nargin < 2
   fprintf('??? Bad M input to rifevwin ==> M must be specified\n');
   w = [];
   return
end

if nargin < 3
   class = 1;
end

if nargin < 4
   normwin = 1;
end

if nargin < 5
   R = 60;
end

if (N == 1)
   w = 1;
   return
end

if (class == 3 && M == 1)
   class = 1;
end

switch class
   case 1
      D = 0;
      for n = 1:M
         prodk = 1;
         for k = 1:n
            prodk = prodk*(M-k+1)/(M+k);
         end
         D(n) = 2*(-1)^(n)*prodk;
      end
      
      for k = 0:N-1
         sumn = 0;
         for n = 1:M
            sumn = sumn + D(n)*cos(2*pi*n*k/(N-1));
         end
         w(k+1) = 1 + sumn;
      end
   case 2
      rho = 10^(R/20);
      lambda = (1/pi)*log(rho + sqrt(rho*rho-1));   % acosh(rho)/pi
      sig2 = (M+1)*(M+1)/(lambda*lambda + (M+0.5)*(M+0.5));
      D = 0;
      for n = 1:M
         dprod = 1;
         for k = 1:M
            if (k ~= n)
               dprod = dprod*(1 - n*n/k/k);
            end
         end
         nprod = 1;
         for k = 1:M
            nprod = nprod*(1 - n*n/sig2/(lambda*lambda + (k-0.5)*(k-0.5)));
         end
         D(n) = -nprod/dprod;
      end
      
      for k = 0:N-1
         sumn = 0;
         for n = 1:M
            sumn = sumn + D(n)*cos(2*pi*n*k/(N-1));
         end
         w(k+1) = 1 + sumn;
      end
   case 3
      D3 = [-1.19685 0.19685];   % tabled in paper
      
      for k = 0:N-1
         sumn = 0;
         for n = 1:2
            sumn = sumn + D3(n)*cos(2*pi*n*k/(N-1));
         end
         g2(k+1) = 1 + sumn;
      end
      
      if (M == 2)
         w = g2;
      else
         Mp = M - 2;
         
         for n = 1:Mp
            prodk = 1;
            for k = 1:n
               prodk = prodk*(Mp-k+1)/(Mp+k);
            end
            D(n) = 2*(-1)^(n)*prodk;
         end
         
         for k = 0:N-1
            sumn = 0;
            for n = 1:Mp
               sumn = sumn + D(n)*cos(2*pi*n*k/(N-1));
            end
            h(k+1) = 1 + sumn;
         end
         
         d0 = 1;
         for k = 1:1
            d0 = d0*(Mp-k+1)/(Mp+k);
         end
         d0 = 2*(-1)^(1)*d0;
        
         d1 = 1;
         for k = 1:2
            d1 = d1*(Mp-k+1)/(Mp+k);
         end
         d1 = 2*(-1)^(2)*d1;
         
         w = h.*g2/(1 + 0.5*D3(1)*d0 + 0.5*D3(2)*d1);
      end
   otherwise
      error('Unknown CLASS input to rifevwin');
end

if (normwin)
   % normalize
   w = w(:)/max(w);
else
   w = w(:);
end
