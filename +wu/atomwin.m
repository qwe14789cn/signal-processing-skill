function w = atomwin(N, wintype, arg1, arg2, normwin, options)

% ATOMWIN Symmetric window based on Atomic Functions
%    ATOMWIN(N,WINTYPE,ARG1,ARG2,NORMWIN,OPTIONS) returns a symmetric N
%    point window based on Atomic Functions.  WINTYPE specifies the type of
%    Atomic Function as described by Kravchenko.  It can be:
%       'theta' - theta_N function          (pg. 9)
%       'up'    - up function               (pg. 9)
%       'dup'   - derivative of up function (pg. 10)
%       'fup'   - fup_N function            (pg. 12)
%       'ha'    - h_a function              (pg. 20)
%       'xin'   - xi_n function             (pg. 21)
%       'gkh'   - g_k,h function            (pg. 22)
%       'upm'   - up_m function             (pg. 28)
%       'pim'   - pi_m function             (pg. 30)
%
%    ARG1 and ARG2 specify the arguments for a particular atomic function. 
%    ARG1 is applicable for the theta, fup, upm, ha, xin, gkh, and pim
%    windows.  ARG2 is applicable for the gkh window.  The defaults for
%    ARG1 and ARG2 are both 1.
%
%    When true (default), NORMWIN normalizes the window such that the
%    maximum amplitude is 1.
%
%    The OPTIONS structure defines parameters associated with integrating
%    the Atomic Functions.  The list of parameters and their defaults are:
%       umin  - integration lower limit (-350)
%       umax  - integration upper limit (350)
%       ustep - integration step size (0.25)
%       eps   - zero limit (eps)
%       pmax  - infinite product upper limit (30)
%
%    Ref:
%    Adaptive Digital Processing of Multidimensional Signals With Applications
%    Kravchenko, Victor F., Hector M. Perez-Meana, and Volodymyr I. Ponomaryov
%    Fizmalit, 2009

% Joe Henning - Jan 2014

if nargin < 2
   fprintf('??? Bad wintype input to atomwin ==> wintype must be specified\n');
   w = [];
   return
end

wintype_options = {'theta','up','dup','upm','ha','xin','gkh','pim','fup','dfup'};
indx = find(strcmpi(wintype,wintype_options));
if isempty(indx)
   fprintf('   Error ==> wintype must be a string as defined in the help section\n');
   w = [];
   return
end

if nargin < 3
   arg1 = 1;
   arg2 = 1;
   normwin = 1;
   has_options = 0;
elseif nargin < 4
   arg2 = 1;
   normwin = 1;
   has_options = 0;
elseif nargin < 5
   normwin = 1;
   has_options = 0;
elseif nargin < 6
   has_options = 0;
end

if ~has_options
   options = struct();
   options.umin = -350;
   options.umax = 350;
   options.ustep = 0.25;
   options.eps = eps;
   options.pmax = 30;
end

if (N == 1)
   w = 1;
   return
end

M = (N-1)/2;

u = options.umin:options.ustep:options.umax;

cnt = 1;

tic
switch wintype
   case 'theta'
      for n = -M:M
         y = [];
         for m = 1:length(u)
            theta = 1;
            if (abs(u(m)) > options.eps)
               theta = sin(u(m)/2.0)/(u(m)/2.0);
            end
            y(m) = exp(j*u(m)*n/M)*theta^(arg1+1);
         end
         yi = simps(u,y);
         w(cnt) = real(yi/(2*pi));
         cnt = cnt + 1;
      end
   case {'up','dup'}
      for n = -M:M
         y = [];
         for m = 1:length(u)
            produ = 1;
            if (abs(u(m)) > options.eps)
               for k = 1:options.pmax
                  tp = u(m)*2^(-k);
                  produ = produ*sin(tp)/tp;
               end
            end
            y(m) = exp(j*u(m)*n/M)*produ;
         end
         yi = simps(u,y);
         w(cnt) = real(yi/(2*pi));
         cnt = cnt + 1;
      end

      if strcmpi(wintype,'dup')
         cnt = 1;
         for n = -M:M
            i1 = 2*n + 2*M + 1;
            i2 = 2*n + 1;
            t1 = 0;
            if (i1 >= 1 & i1 <= N)
               t1 = w(i1);
            end
            t2 = 0;
            if (i2 >= 1 & i2 <= N)
               t2 = w(i2);
            end
            wp(cnt) = 2*t1 - 2*t2;
            cnt = cnt + 1;
         end
         w = wp;
      end
   case 'fup'
      for n = -M:M
         y = [];
         for m = 1:length(u)
            produ = 1;
            theta = 1;
            if (abs(u(m)) > options.eps)
               for k = 1:options.pmax
                  tp = u(m)*2^(-k);
                  produ = produ*sin(tp)/tp;
               end
               theta = sin(u(m)/2.0)/(u(m)/2.0);
            end
            y(m) = exp(j*u(m)*n/M*(arg1+2)/2.0)*theta^(arg1)*produ;
         end
         yi = simps(u,y);
         w(cnt) = real(yi/(2*pi));
         cnt = cnt + 1;
      end
   case 'dfup'
      for n = -M:M
         y = [];
         for m = 1:length(u)
            produ = 1;
            theta = 1;
            if (abs(u(m)) > options.eps)
               for k = 1:options.pmax
                  tp = u(m)*2^(-k);
                  produ = produ*sin(tp)/tp;
               end
               theta = sin(u(m)/2.0)/(u(m)/2.0);
            end
            y(m) = exp(j*u(m)*n/M*(arg1+1)/2.0)*theta^(arg1-1)*produ;
         end
         yi = simps(u,y);
         w(cnt) = real(yi/(2*pi));
         cnt = cnt + 1;
      end

      cnt = 1;
      for n = -M:M
         k = n/M*(arg1+1)/2.0;
         i1 = k + 0.5;
         i2 = k - 0.5;
         t1 = 0;
         if (i1 >= 1 & i1 <= N)
            t1 = w(i1);
         end
         t2 = 0;
         if (i2 >= 1 & i2 <= N)
            t2 = w(i2);
         end
         wp(cnt) = t1 - t2;
         cnt = cnt + 1;
      end
      w = wp;
   case 'upm'
      for n = -M:M
         y = [];
         for m = 1:length(u)
            produ = 1;
            if (abs(u(m)) > options.eps & abs(arg1) > options.eps)
               for k = 1:options.pmax
                  tp = u(m)*(2*arg1)^(-k);
                  pn = sin(arg1*tp);
                  produ = produ*pn*pn/(arg1*tp*arg1*sin(tp));
               end
            end
            y(m) = exp(j*u(m)*n/M)*produ;
         end
         yi = simps(u,y);
         w(cnt) = real(yi/(2*pi));
         cnt = cnt + 1;
      end
   case 'ha'
      for n = -M:M
         y = [];
         for m = 1:length(u)
            produ = 1;
            if (abs(u(m)) > options.eps)
               for k = 1:options.pmax
                  tp = u(m)*arg1^(-k);
                  produ = produ*sin(tp)/tp;
               end
            end
            y(m) = exp(j*u(m)*n/M/(arg1-1))*produ;
         end
         yi = simps(u,y);
         w(cnt) = real(yi/(2*pi));
         cnt = cnt + 1;
      end
   case 'xin'
      for n = -M:M
         y = [];
         for m = 1:length(u)
            produ = 1;
            if (abs(u(m)) > options.eps)
               for k = 1:options.pmax
                  tp = u(m)*(arg1+1)^(-k);
                  produ = produ*(sin(tp)/tp)^(arg1);
               end
            end
            y(m) = exp(j*u(m)*n/M)*produ;
         end
         yi = simps(u,y);
         w(cnt) = real(yi/(2*pi));
         cnt = cnt + 1;
      end
   case 'gkh'
      b = cos(2*arg1*arg2/3.0);
      a = arg1*arg1/(1 - b);

      for n = -M:M
         y = [];
         for m = 1:length(u)
            produ = 1;
            for k = 1:options.pmax
               pd = arg1*arg1 - u(m)*u(m)*9^(1-k);
               if (abs(pd) <= options.eps)
                  produ = produ*a*(cos(2*u(m)*arg2*3^(-k)) - b)/(pd + 1E-14);
               else
                  produ = produ*a*(cos(2*u(m)*arg2*3^(-k)) - b)/pd;
               end
            end
            y(m) = exp(j*u(m)*n/M*arg2)*produ;
         end
         yi = simps(u,y);
         w(cnt) = real(yi/(2*pi));
         cnt = cnt + 1;
      end
   case 'pim'
      for n = -M:M
         y = [];
         for m = 1:length(u)
            produ = 1;
            for k = 1:arg1
               sum = 0;
               tp = (2*arg1)^k;
               for v = 2:arg1
                  sum = sum + (-1)^(v)*(sin(2*arg1 - 2*v + 1)*u(m))/tp;
               end
               pd = (3*arg1 - 2)*u(m);
               if (abs(pd) <= options.eps)
                  produ = produ*tp*(sin(2*arg1-1)*u(m)/tp + sum)/(pd + 1E-14);
               else
                  produ = produ*tp*(sin(2*arg1-1)*u(m)/tp + sum)/pd;
               end
            end
            y(m) = exp(j*u(m)*n/M)*produ;
         end
         yi = simps(u,y);
         w(cnt) = real(yi/(2*pi));
         cnt = cnt + 1;
      end
end
toc

if (normwin)
   % normalize
   w = w(:)/max(w);
else
   w = w(:);
end


function z = simps(x,y)
% SIMPS Simple Simpson's Method numerical integration
lx = length(x);
z = 0;

if mod(lx,2) ~= 1
   error('lx must be odd.\n');
end

for k  = 1:2:lx-2
   z = z + (x(k+2)-x(k))*(y(k)+4*y(k+1)+y(k+2))/6.0;
end
