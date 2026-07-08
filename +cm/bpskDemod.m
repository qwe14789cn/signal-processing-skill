function data = bpskDemod(signal, startTime, codeWidth, carrFreq, sampleRate)
% 函数功能：实现BPSK调制。
% 输入参数：
%   signal                BPSK调制信号，N*1复数数组
%   startTime           时间戳，标量，s
%   codeWidth             码元宽度，标量，s
%   carrFreq               载波频率，标量，Hz
%   sampleRate           采样频率，标量，Hz
% 输出参数：
%   data                 解调数据,M*1数组

% 码元采样点数
numC = round(codeWidth * sampleRate);

% 当载频解调信号
if carrFreq > 0
    numS = numel(signal);
    ts   = 1 / sampleRate;
    time = (startTime : ts : (numS - 1) * ts).';
    signal = signal.* exp(-1j * 2 * pi * carrFreq * time);
end

% 抽样判决（信号小于0量化为1，大于0量化为0）
bb = signal(1:numC:end);
data = double(bb < 0);
end