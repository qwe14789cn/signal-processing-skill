function signal2 = fmDemod(signal, startTime, sampleRate, freqDev, carrFreq)
% 函数功能：实现FM解调。
% 输入参数：
%   signal                        FM信号，N*1复数数组
%   startTime                     时间戳，标量，s
%   sampleRate                    采样频率，标量，Hz
%   freqDev                       调频斜率，标量，Hz
%   carrFreq                      载波斜率，标量，Hz
% 输出参数：
%   signal2                       解调信号，N*1复数数组

% 解调
if carrFreq > 0
    num   = length(signal);
    ts    = 1 / sampleRate;
    time  = (startTime : ts : (num - 1) * ts + startTime).';
    
    signal = signal .* exp(-1j * 2 * pi * carrFreq * time);
end

signal2 = (1/(2*pi*freqDev))*[zeros(1,size(signal,2)); diff(unwrap(angle(signal)))*sampleRate];
signal2 = hilbert(signal2);
end