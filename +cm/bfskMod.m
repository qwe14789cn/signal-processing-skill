function signal = bfskMod(data, startTime, codeWidth, carrFreq, sampleRate, deltaFreq)
% 函数功能：实现2fsk调制。
% 输入参数：
%   data                二进制数据，N*1数组
%   startTime            时间戳，标量，s
%   codeWidth           码元宽度，标量，s
%   carrFreq             载波频率，标量，Hz
%   sampleRate           采样频率，标量，Hz
%   deltaFreq               频率变化量，标量，Hz

% 输出参数：
%   siganl               2fsk调制信号，L*1复数数组
% 参考文献
%  《Link-4A与Link-11信号仿真研究》，计算机工程与应用，2008（33S），P149

numC = round(codeWidth * sampleRate);    % 码元长度
numD = length(data) ;                    % 二进制数据长度
numS =  numC * numD;                     % 输出信号长度

data(data == 0) = -1;
freq = data * deltaFreq + carrFreq;      % 每个码元对应的频率
freq = freq.';

% 生成2fsk调制信号,假设初始相位为0。
ts      =   1 / sampleRate;
t       =   (startTime : ts : startTime + (numS - 1) * ts).';
t       =   reshape(t, numC, numD);
signal  =   exp(1j * 2 * pi * t .* freq);
signal  =   reshape(signal,[],1);
end