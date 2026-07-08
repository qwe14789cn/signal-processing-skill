function [gain, enbw, sloss, sll, oc, bw3, bw6, nbw, mbw, srr, wpl, msr, cr] = winprop(w, M, plotflag)

% WINPROP Window properties
%    [GAIN,ENBW,SLOSS,SLL,OC,BW3,BW6,NBW,MBW,SRR,WPL,MSR,CR] = WINPROP(W,M)
%    returns window parameters associated with window W.  M specifies the
%    FFT size, which defaults to 2^16.
%
%    Output parameters are:
%    GAIN  - coherent gain (scaling factor): zero frequency gain (DC gain)
%            of the window
%    ENBW  - equivalent noise bandwidth (in bins): width of an equivalent
%            rectangular spectral response that will pass the same noise
%            power as the window
%    SLOSS - scallop loss (in dB): maximum reduction in processing gain
%            due to signal frequency and represented by coherent gain for
%            a tone located half a bin from a DFT sample point divided by
%            the coherent gain for a tone located at a DFT sample point
%    SLL   - maximum sidelobe level (in dB)
%    OC    - vector of overlap correlation percents [25%, 50%, 75%]
%    BW3   - 3-dB mainlobe width (in bins)
%    BW6   - 6-dB mainlobe width (in bins)
%    NBW   - null-to-null mainlobe width (in bins)
%    MBW   - mainlobe width (in bins)
%    SRR   - sidelobe roll-off rate (in dB/octave)
%    WPL   - worst case processing loss (in dB)
%    MSR   - ratio of mainlobe energy to sidelobe energy (in dB)
%    CR    - contrast ratio (in dB)
%
%    The reductions in variance for K overlapped transforms are:
%       50% overlap reduction =
%           (1/K)*(1 + 2*OC(2)^2) - 2/(K*K)*(OC(2)^2)
%       75% overlap reduction =
%           (1/K)*(1 + 2*OC(3)^2 + 2*OC(2)^2 + 2*OC(1)^2)
%               - 2/(K*K)*(OC(3)^2 + 2*OC(2)^2 + 3*OC(1)^2)
%    For good windows, transforms taken with 50% overlap are essentially
%    independent.
%
%    [] = WINPROP(W,M,'plot') plots a figure which helps depict
%    calculated window parameters.

% Joe Henning - Jan 2014

if nargin < 2
   M = 65536;
end

w = w(:);

N = length(w);

if M < N
   M = 65536;
end

% Compute peak signal gain
sw = sum(w);

% Compute noise power
sw2 = sum(w.*w);

% Coherent gain
gain = sw/N;

% ENBW = noise power/peak power gain
enbw = N*sw2/(sw*sw);

ie = enbw/N*M*pi/2/pi+1;

% Overlap correlation
oc25 = ocorrelation(w,0.25);
oc50 = ocorrelation(w,0.5);
oc75 = ocorrelation(w,0.75);

oc = [oc25; oc50; oc75];

% Scallop loss in dB
sloss = 0;
for k = 1:N
   sloss = sloss + w(k)*exp(-j*pi/N*k);
end
sloss = -20*log10(abs(sloss)/sw);

% Worst case processing loss in dB
wpl = 10*log10(enbw) + sloss;

% Examine the window for mainlobe and sidelobe information
W = fft(w,M);
warning off
Z = 20*log10(abs(W));
warning on

Zmax = Z(1);   % this should be the case ...
for i = 2:M/2
   if (Zmax - Z(i) >= 3)
      i1 = i;
      break
   end
end

i1int = interp1([Zmax-Z(i1-1) Zmax-Z(i1)],[i1-1 i1],3.0,'linear');

bw3 = 2*pi*(i1int-1)/pi/M*N;

for i = i1:M/2
   if (Zmax - Z(i) >= 6)
      i2 = i;
      break
   end
end

i2int = interp1([Zmax-Z(i2-1) Zmax-Z(i2)],[i2-1 i2],6.0,'linear');

bw6 = 2*pi*(i2int-1)/pi/M*N;

for i = i2:M/2
   if (Z(i) > Z(i-1))
      i3 = i-1;
      break
   end
end

nbw = 2*pi*(i3-1)/pi/M*N;

found_null = 1;
lobes = [];
for i = i3+1:M/2
   if found_null
      if (Z(i) > Z(i-1))
         found_null = 0;
      end
   else
      if (Z(i) > Z(i-1))
         continue
      else
         lobes = [lobes i-1];
         found_null = 1;
      end
   end
end
lobes = lobes(:);

[maxz,indz] = max(Z(lobes));
sll = maxz - Zmax;
S = length(lobes);
ro = maxz - Z(lobes(S));
if 0
   pfit = polyfit(lobes,Z(lobes),1);
   pz1 = pfit(1)*lobes(1) + pfit(2);
   pz2 = pfit(1)*lobes(S) + pfit(2);
   ro = pz1 - pz2;
end
%oct = log((lobes(S)-1)/(lobes(indz)-1))/log(2);
oct = log((lobes(S)-1)/(lobes(1)-1))/log(2);
srr = -ro/oct;

for i = i3:-1:2
   if (Z(i) <= maxz && Z(i-1) > maxz)
      i4 = i-1;
      break
   end
end

i4int = interp1([Z(i4) Z(i4+1)],[i4 i4+1],maxz,'linear');

mbw = 2*pi*(i4-1)/pi/M*N;

Y = W.*conj(W);

em = sum(Y(1:i4));

es = sum(Y(i4+1:M/2));

msr = 10*log10(em/es);

cr = 10*log10((es+em)/es);

if nargin == 3
   figure;
   subplot(2,1,1);
   plot(1:N,w,'c.-');
   grid;
   axis([1 N min([0 min(w)]) 1]);
   xlabel('Samples');
   ylabel('Amplitude');
   title('Time Domain');
   subplot(2,1,2);
   plot(2*(0:M-1)/M,Z,'c.-');
   grid;
   hold on;
   plot(2*(lobes-1)/M,Z(lobes),'bo');
   zi = find(~isinf(Z));
   minz = min(Z(zi));
   maxz = max(Z(zi));
   zi = find(isinf(Z));
   Z(zi) = minz;
   plot([2*(ie-1)/M 2*(ie-1)/M 0 0 2*(ie-1)/M],[minz maxz maxz minz minz],'g-.');
   plot(2*(i1-1)/M,Z(i1),'r*');
   plot(2*(i2-1)/M,Z(i2),'m*');
   plot(2*(i3-1)/M,Z(i3),'k*');
   plot(2*(i4-1)/M,Z(i4),'b*');
   xlabel('Normalized Frequency (x\pi rad/sample)');
   ylabel('Magnitude (dB)');
   title('Frequency Domain');
   legend('','sl','enbw','3db','6db','nbw','mbw','Location','NorthEastOutside');
end
