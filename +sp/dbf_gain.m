%--------------------------------------------------------------------------
%   [snr_gain,sig_gain,noise_gain] = dbf_gain(win_coe)
%--------------------------------------------------------------------------
%   功能：
%   计算DBF的相干积累的合成增益
%--------------------------------------------------------------------------
%   输入：
%           win_coe         窗函数加权系数
%   输出:
%           snr_gain        信噪比增益
%           sig_gain        信号增益
%           noise_gain      噪声增益
%--------------------------------------------------------------------------
function [snr_gain,sig_gain,noise_gain] = dbf_gain(win_coe)
win_coe = abs(win_coe(:));                                                  %强制转为列向量,支持复增益

sig_gain = mag2db(sum(win_coe));                                            %信号增益 幅度→dB
noise_gain = pow2db(sum(win_coe.^2));                                       %噪声增益 功率→dB
snr_gain = sig_gain - noise_gain;

% 若无输出，打印结果
if nargout == 0
    fprintf('信噪比增益:\t%f dB\n信号增益:\t\t%f dB\n噪声增益:\t\t%f dB\n',...
            [snr_gain,sig_gain,noise_gain]);
end
end