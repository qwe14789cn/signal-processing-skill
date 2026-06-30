function data = pi4_dqpskDemod(signal, codeWidth, estiFreq, sampleRate)
% 函数功能：实现pi/4-DQPSK解调。
% 输入参数：
%   signal               pi/4-DQPSK信号(含相位参考)，N*1复数数组
%   codeWidth             码元宽度，标量，s   
%   estiFreq            估计频率，标量，Hz
%   sampleRate           采样频率，标量，Hz
% 输出参数：
%   data                    二进制数据，M*1数组
% 参考文献
%  《Link-11数据链信号分析与实现》，西安电子科技大学，2019，P41~P42

% 计算相位
numC = round(codeWidth * sampleRate); % 单个码元长度
numD = numel(signal) / numC - 1;     % 码元个数

signal = reshape(signal,numC,numD + 1);

if estiFreq > 0
    nn = (0 : 1 : numC -1).';
    signal = signal .* exp(- 1j * 2 * pi * (estiFreq / sampleRate)* nn);
end
signal = sum(signal,1);
phase = angle(signal);

% 计算线性相位差
deltaPhase  = (2 * pi * estiFreq * numC) / sampleRate;
diffPhase   = diff(phase);
changePhase = diffPhase - deltaPhase;

% 解调
a = fix(changePhase /( 2 * pi));
b = changePhase /( 2 * pi);
c = b - a;
d = c * 2 * pi ;

flag1 = d > pi;
flag2 = d <= -pi;
d(flag1)= d(flag1) - 2 * pi;
d(flag2)= d(flag2) + 2 * pi;

flag1 = (d > -pi)       & (d <= - 0.5 * pi);
flag2 = (d > -0.5 * pi) & (d <= 0);
flag3 = (d > 0)         & (d <= 0.5 * pi);

% 实现的效果：
%   data(:,flag1)  = [1;0]
%   data(:,flag2)  = [1;1]
%   data(:,flag3)  = [0;1]
%   data(:,others) = [0;0]
data = zeros(2 ,numD);
data(1,flag1) = 1;
data(1,flag2) = 1;
data(2,flag2) = 1;
data(2,flag3) = 1;

data = reshape(data,[],1);
end