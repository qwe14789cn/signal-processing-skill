%--------------------------------------------------------------------------
%   ad_analyzer(rawsig,fs,N_bits)
%--------------------------------------------------------------------------
%   功能：
%   ADC性能分析工具
%--------------------------------------------------------------------------
%   输入:
%           rawsig              输入信号
%           fs                  采样速率
%           N_bits              ADC位宽  
%--------------------------------------------------------------------------
%   例子:
%   ad_analyzer(rawsig,fs,N_bits)
%--------------------------------------------------------------------------
function ad_analyzer(rawsig,fs,N_bits)
sig = rawsig/2^(N_bits-1);                                                  %归一化后
len = length(sig);
T = 1/fs;
t_axis = (0:(len-1)).*T;
[T_axis, fscale, xunits] =engunits(t_axis);

[value,~,unit] = signalwavelet.internal.convenienceplot.getFrequencyEngUnits(fs);
%   单边谱分析
Nfft = numel(rawsig);
f_axis = value/Nfft*(0:Nfft/2);
A = fft(rawsig,Nfft)./Nfft;
A = A(1:Nfft/2+1);
A(2:end-1) = A(2:end-1).*sqrt(2);                                               %单边谱 功率x2



% rmsSig = rms(sig);
% rmsSigDBFS = mag2db(rmsSig);
p2pSig = (max(sig)-min(sig))/2;                                             %峰峰值占比
p2pSigdBFS = mag2db(p2pSig);                                                %转换为dBFS


[SNR,Noisepow] = snr(rawsig,fs);
[SFDR,spurpow,spurfreq] = sfdr(rawsig,fs);
[THD,harmpow,harmfreq] = thd(rawsig,fs);thdPercent = db2pow(THD)*100;
[SINAD,totdistpow] = sinad(rawsig,fs);
ENOB = (SINAD-1.76 - p2pSigdBFS) / 6.02;                                    %非满量程修正项 p2pSigdBFS
DR = 6.02*N_bits + 1.76;
f = figure(1);
f.Position = get(0,'ScreenSize');
subplot(321);
plot(T_axis,rawsig);grid on;xlabel(['时间/' xunits 's']);ylabel('幅度')
ylim([min(rawsig)-eps max(rawsig)+eps].*1.2)
title(['采样速率' num2str(value)  unit '时域波形'])

subplot(322);
plot(f_axis,mag2db(abs(A)));xlim([0 value/2]);grid on
xlabel(['频率' unit]);ylabel('幅度 dB');
title(['采样速率' num2str(value)  unit '频域响应'])

subplot(323);snr(sig,fs);
subplot(324);sfdr(sig,fs);
subplot(325);thd(sig,fs);
subplot(326);sinad(sig,fs);

disp('--------------------------------------------------------------------')
fprintf(['\tADC位数\t\t\tNOB\t\t\t= ' num2str(N_bits) '\t\tBits\n']);
fprintf(['\t理论动态范围\t\tDR\t\t\t= ' num2str(DR) '\tdB\n\n']);
fprintf(['\t满量程\t\t\tMaxScale\t= ' num2str(2^(N_bits-1)-1) '\n']);
fprintf(['\t\t\t\t\tMinScale\t= ' num2str(-2^(N_bits-1)) '\n\n']);
fprintf(['\t信号峰峰值\t\tMaxPeak\t\t= ' num2str(max(rawsig)) '\n']);
fprintf(['\t\t\t\t\tMinPeak\t\t= ' num2str(min(rawsig)) '\n']);
fprintf(['\t峰峰值占比\t\tPP Scale\t= ' num2str(p2pSig*100) '%%\t\t\t' num2str(p2pSigdBFS) '\tdBFS\n\n']);
fprintf(['\t信号频率\t\t\tSig freq\t= ' num2str(harmfreq(1)) '\tHz\n']);
disp('--------------------------------------------------------------------')
fprintf(['\t信噪比\t\t\tSNR \t\t= ' num2str(SNR) '\tdB\n']);
fprintf(['\t无杂散动态范围\t\tSFDR\t\t= ' num2str(SFDR) '\tdB\n']);

fprintf(['\t总谐波失真\t\tTHD\t\t\t= ' num2str(THD) '\tdBc\t\t' num2str(thdPercent) '%%\n']);
fprintf(['\t信噪比和失真\t\tSINAD\t\t= ' num2str(SINAD) '\tdBc\n']);
fprintf(['\t有效位数\t\t\tENOB\t\t= ' num2str(ENOB) '\tBits\n']);
disp('--------------------------------------------------------------------')
fprintf(['\t噪声功率\t\t\tNoisePower\t= ' num2str(Noisepow) '\tdB\n\n']);

fprintf(['\t最大杂散功率\t\tSpurPower\t= ' num2str(spurpow) '\tdB\n']);
fprintf(['\t最大杂散频率\t\tSpurFreq\t= ' num2str(spurfreq) '\tHz\n\n']);

T = table((2:length(harmfreq))',harmfreq(2:end),harmpow(2:end));
T.Properties.VariableNames = {'序号','谐波频率(Hz)','谐波功率(dB)'};
disp(T)

fprintf(['\t噪声+谐波总功率\tNoise+harm\t= ' num2str(totdistpow') '\tdB\n']);
disp('--------------------------------------------------------------------')


