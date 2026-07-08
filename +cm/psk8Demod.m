function data = psk8Demod(signal, startTime, codeWidth, carrFreq, sampleRate)
% 函数功能：实现8psk调制。
% 输入参数：
%   signal                8psk信号，N*1复数数组
%   startTime            时间戳，标量，s
%   codeWidth           码元宽度，标量，s
%   carrFreq             载波频率，标量，Hz
%   sampleRate           采样频率，标量，Hz
% 输出参数：
%   data                   解调数据,M*1数组
% 参考文献
%  《Link-11数据链信号分析与实现》，西安电子科技大学，2019，P44

numC   = round(codeWidth * sampleRate);                 % 码元采样点数
numS   = length(signal);                            % 输出信号长度
ts     = 1 / sampleRate;
t      = (startTime : ts : startTime + (numS - 1) * ts).';

% 8psk解调
if carrFreq > 0
    phase  = signal .* exp(- 1j * 2 * pi * carrFreq * t);
else
    phase  = signal;
end
phase      = reshape(phase, numC, []);
phaseSum   = sum(phase, 1);
phaseAver  = phaseSum / numC;
normFactor = 8 / (2 * pi);
dataMed    = round((angle(phaseAver) .* normFactor));
dataMed(dataMed < 0) = 8 + dataMed(dataMed < 0);

% 8进制转化为2进制
dataStr = dec2bin(dataMed, 3);
dataA   = dataStr(:);
dataB   = str2num(dataA);
dataC   = reshape(dataB, [], 3);
dataD   = dataC.';
data    = dataD(:);
end