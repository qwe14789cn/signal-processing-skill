function signal2 = ssbMod(signal, startTime, sampleRate, modType, carrFreq)
% 函数功能：实现单边带调制。
% 输入参数：
%   signal          调制信号，N*1实数数组
%   startTime           时间戳，标量，s
%   sampleRate          采样频率，标量，Hz
%   modType           调制类型，标量，正整数
%                           1: 上边带调制
%                           2: 下边带调制
%   carrFreq            载波斜率，标量，Hz
% 输出参数：
%   signal2            单边带调制信号，N*1复数数组

num   = numel(signal);
ts    = 1 / sampleRate;
time  = (startTime : ts : (num - 1) * ts + startTime).';

% 选择调制方式为上边带调制还是下边带调制
switch modType
    case 1      % 上边带调制信号
        if carrFreq > 0           
            signal2 = signal .* exp(1j * 2 * pi * carrFreq * time);
        else
            signal2 = signal;
        end
        
    case 2      % 下边带调制信号
        if carrFreq > 0            
            signal2 = signal .* exp(- 1j * 2 * pi * carrFreq * time);
        else
            signal2 = signal;
        end
    otherwise
        error('Unsupported.');
end
end