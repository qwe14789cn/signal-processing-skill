%--------------------------------------------------------------------------
%   out = sig_delay_int(sig,R,fc,fs)
%--------------------------------------------------------------------------
%   功能：
%   信号延迟函数(四舍五入整数延迟)
%--------------------------------------------------------------------------
%   输入:
%           sig         发射复信号，完整的PRT
%           R           传输距离
%           fc          载频波长
%           fs          仿真采样速率
%   输出:
%           out         延迟信号
%--------------------------------------------------------------------------
%   例子:
%   out = sig_delay_int(sig,R,fc,fs)

%--------------------------------------------------------------------------
function out = sig_delay_int(sig,R,fc,fs)
%   计算时间延迟
c = 3e8;
lambda = c/fc;
delay_time = R/c;                                                           %计算延迟时间
T = 1/fs;                                                                   %采样间隔
delay_N = round(delay_time/T);                                      		%信号延迟计算整数点
%   计算相位延迟
phi = exp(-1j.*R/lambda*2*pi);                                               %传播过程中载频产生的相位旋转

max_delay_N =  max(delay_N);                                                %拿到最大延迟点
out = zeros(numel(sig)+max_delay_N,numel(R));                               %信号缓冲区

sig_len = length(sig);
%   延迟不同的信号 矩阵对齐
for idx = 1:numel(delay_N)
    out(delay_N(idx)+1:delay_N(idx)+sig_len,idx) = sig.*phi(idx);
end
end