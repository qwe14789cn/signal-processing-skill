function signal = psk8Mod(data, startTime, codeWidth, carrFreq, sampleRate)
% 函数功能：实现8psk调制。
% 输入参数：
%   data                二进制数据，N*1数组
%   startTime            时间戳，标量，s
%   codeWidth           码元宽度，标量，s
%   carrFreq             载波频率，标量，Hz
%   sampleRate           采样频率，标量，Hz
% 输出参数：
%   siganl               8psk调制信号，L*1复数数组
% 参考文献
%  《Link-11数据链信号分析与实现》，西安电子科技大学，2019，P22

% 计算相位
numC = round(codeWidth * sampleRate) ;       % 单个码元长度
numD = length(data) / 3;                       % 码元个数
numS = numC * numD;                            % 输出信号长度
phase = zeros(1,numD);
data = reshape(data, 3, []);                 % 2*M数组

flag1 = all(data == [0;0;0], 1);
flag2 = all(data == [0;0;1], 1);
flag3 = all(data == [0;1;0], 1);
flag4 = all(data == [0;1;1], 1);
flag5 = all(data == [1;0;0], 1);
flag6 = all(data == [1;0;1], 1);
flag7 = all(data == [1;1;0], 1);
flag8 = all(data == [1;1;1], 1);

phase(flag1) = 0;
phase(flag2) = 0.25 * pi;
phase(flag3) = 0.5 * pi;
phase(flag4) = 0.75 * pi;
phase(flag5) = pi;
phase(flag6) = -0.75 * pi; 
phase(flag7) = -0.5 * pi;
phase(flag8) = -0.25 * pi;

% 生成8psk调制信号
if carrFreq > 0
    ts      =   1 / sampleRate;
    t       =   (startTime : ts : startTime + (numS - 1) * ts).';
    t       =   reshape(t, numC, numD);
    signal  =   exp(1j * ( 2 * pi * carrFreq .* t +  phase));
else
    signal  =   repmat(exp(1j * phase), numC, 1);
end

signal = reshape(signal,[],1);
end