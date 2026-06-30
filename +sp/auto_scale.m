%--------------------------------------------------------------------------
%   [output,output_ideal] = auto_scale(sig,AD_len,dBFS)
%--------------------------------------------------------------------------
%   功能:
%   将输入数据的最大值按照ADC的位宽进行量化(常用于FPGA数据测试中)
%--------------------------------------------------------------------------
%   输入:
%           sig                 需要被量化的信号信号                 
%           AD_len              ADC位宽
%           dBFS                幅度相对于数字系统所能表示的最大电平的比值
%                               0   dBFS 对应数字系统的最大可表示电平(默认)
%                               -6  dBFS 表示信号幅度为最大电平的50%
%                               -20 dBFS 表示信号幅度为最大电平的10% 
%   输出:
%           output              四舍五入按照位宽量化
%           output_ideal        不做四舍五入,理想信号
%--------------------------------------------------------------------------
function [output,output_ideal] = auto_scale(sig,AD_len,dBFS)
if nargin == 2
    dBFS = 0;
end
if(dBFS > 0)
    error('dBFS ≤ 0')
end

A = db2mag(dBFS)*(2^(AD_len-1)-1);
sig = sig./max(abs(sig));
output_ideal = sig .* A;
output = round(output_ideal);
end