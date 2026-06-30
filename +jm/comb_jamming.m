%--------------------------------------------------------------------------
%   梳状谱干扰
%--------------------------------------------------------------------------
%   功能:
%   产生梳状谱干扰，在fc上对称生成
%--------------------------------------------------------------------------
%   输入:
%           T				持续时间
%           delta_f			间隔频率
%           N				干扰数量
%			fs				采样率
%   输出:
%           sig				干扰信号
%--------------------------------------------------------------------------
function sig = comb_jamming(T,delta_f,N,fs)

if N/2 - floor(N/2) == 0
    %   偶数
    f_axis = (1:N)-round(N/2)-0.5;
else
    %   奇数
    f_axis = (1:N)-round(N/2);
end
f_axis = f_axis .*delta_f;                                                  %频率轴

t_axis = 0:1/fs:T-1/fs;t_axis = t_axis(:);
sig = zeros(size(t_axis));
if range(f_axis) > fs
    disp('超出频率范围')
    sig = nan;
    return
else
    for idx = 1:N
        sig = sig + exp(1j.*2*pi*f_axis(idx).*t_axis);
    end
end


