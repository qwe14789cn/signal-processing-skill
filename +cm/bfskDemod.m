function data = bfskDemod(signal, codeWidth, carrFreq, sampleRate, fftNum)
% 函数功能：实现2fsk调制。
% 输入参数：
%   signal                二进制数据，N*1数组
%   codeWidth           码元宽度，标量，s
%   carrFreq             载波频率，标量，Hz
%   sampleRate           采样频率，标量，Hz
%   fftNum               fft点数，标量，正整数

% 输出参数：
%   data                   2fsk解调信号，L*1复数数组

% 参考文献
%  《Link-4A与Link-11信号仿真研究》，计算机工程与应用，2008（33S），P149

numC = round(codeWidth * sampleRate);    % 码元长度

% 解调
signal     =  reshape(signal, numC, []);
signalFreq =  fftshift(fft(signal, fftNum, 1),1);
[~,pos]    =  max(abs(signalFreq), [], 1);
freq       =  (-fftNum/2:1:fftNum/2-1)*(sampleRate/fftNum);
maxFreq    =  freq(pos);

data(maxFreq > carrFreq) =  1;
data(maxFreq < carrFreq) =  0;
data = data.';
end