function signal2 = ssbDemod(signal, startTime, sampleRate, carrFreq, demodType)
% 函数功能：实现单边带解调。
% 输入参数：
%   signal          调制信号，N*1复数数组
%   startTime           时间戳，标量，s
%   sampleRate          采样频率，标量，Hz
%   carrFreq            载波斜率，标量，Hz
%   demodType           解调类型，标量，正整数
%                           1: 上边带解调
%                           2: 下边带解调

% 输出参数：
%   signal2            单边带调制信号，N*1实数数组

num   = numel(signal);
ts    = 1 / sampleRate;
time  = (startTime : ts : (num - 1) * ts + startTime).';

switch demodType
    case 1      % 上边带
        if carrFreq > 0
            signal2 = signal .* exp(- 1j * 2 * pi * carrFreq * time);
        else
            signal2 = signal;
        end
        
    case 2      % 下边带
        if carrFreq > 0
            signal2 = signal .* exp( 1j * 2 * pi * carrFreq * time);
        else
            signal2 = signal;
        end
    otherwise
        error('Unsupported.');
end


% 解调
% if carrFreq > 0
%     % 计算基本参数
%     num   = length(signal);
%     ts    = 1 / sampleRate;
%     time  = (startTime : ts : (num - 1) * ts + startTime).';
%     
%     % 相干解调
%     signalDemod =  real(signal) .* (2 * cos(2 * pi * carrFreq * time));
%     % 低通滤波器
%     pTaps = mexIppsIIRGenLowpass_64f(carrFreq / sampleRate, 0, 5, 1);
%     b = pTaps(1,1:6);
%     a = pTaps(1,7:12);
%     signal2 = bf.filter.filter(b.',a.',signalDemod);
% else
%     signal2 = real(signal);
% end
end