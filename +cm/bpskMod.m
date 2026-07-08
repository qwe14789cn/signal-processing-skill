function signal = bpskMod(data, startTime, codeWidth, carrFreq, sampleRate)
% 函数功能：实现bpsk调制。
% 输入参数：
%   data                                           % 二进制数据，N*1数组
%   startTime                                      % 时间戳，标量，s
%   codeWidth                                      % 码元宽度，标量，s
%   carrFreq                                       % 载波频率，标量，Hz
%   sampleRate                                     % 采样频率，标量，Hz
% 输出参数：
%   siganl                                         % bpsk调制信号，L*1复数数组

numC = round(codeWidth * sampleRate);   % 码元长度
numD = numel(data);                     % 二进制数据长度
numS = numC * numD;                     % 输出信号长度

% 计算相移
phase = zeros(1,numD);
phase(data ~= 0) = pi;

% 生成调制信号
if carrFreq > 0
    ts      =   1 / sampleRate;
    t       =   (startTime : ts : (numS - 1) * ts).';
    t       =   reshape(t,numC,numD);
    signal  =   exp(1j * ( 2 * pi * carrFreq .* t +  phase));
else
    signal  =   repmat(exp(1j * phase), numC, 1);
end

signal = reshape(signal,[],1);
end