%--------------------------------------------------------------------------
%   [y_interp,index] = lagrange_farrow_interpolation(Sig_in,fs_in,fs_out,order)
%--------------------------------------------------------------------------
%   功能：
%   farrow滤波器信号重采样(整体处理)
%--------------------------------------------------------------------------
%   输入:
%           Sig_in           输入信号
%           fs_in            对应输入信号采样率
%           fs_out           输出采样率
%           order            阶数
%   输出:
%           y_interp         对应插值时间轴的信号
%           index            插值整数 → 插值后的整数,小数
%--------------------------------------------------------------------------
function [Sig_out,index] = lagrange_farrow_interpolation(Sig_in,fs_in,fs_out,order)
Sig_in = Sig_in(:);
%初始化拉格朗日插值滤波器系数
h = sp.lagrange_farrow_matrix(order);

if mod(order, 2) ~= 1
    error('Lagrange Farrow 阶数必须为奇数！当前 order = %d', order);
end

delay_Point = floor(order/2);
delta = fs_in/fs_out;                                                       %计算步进整数差
%   必须提前算
N_out = round(numel(Sig_in) * fs_out / fs_in);
time_axis_out = (0:N_out-1) * (fs_in / fs_out);




%   插值后的计算整数和小数部分
Integer_Part = floor(time_axis_out);
Fractional_Part = time_axis_out - Integer_Part;

%   计算插值前后 转换表
if nargout == 2
    index = struct();
    for n = 0:max(Integer_Part)
        mask = (Integer_Part == n);
        index(n+1).input_index = n;
        index(n+1).output_indices = find(mask);
        index(n+1).mu_values = Fractional_Part(mask);
    end
end
Sig_out = zeros(numel(time_axis_out),1);

for idx = 1:numel(time_axis_out)

    % 补前导零
    if Integer_Part(idx) < delay_Point
        sig_seg = [zeros(delay_Point - Integer_Part(idx),1);Sig_in(1:Integer_Part(idx)+delay_Point+1)];
    % 补尾随零
    elseif Integer_Part(idx)>= length(Sig_in) - delay_Point    
        sig_seg = [Sig_in(Integer_Part(idx)-delay_Point+1:end);zeros(Integer_Part(idx)+delay_Point+1-length(Sig_in),1)];
    else
     % 正常取段
        sig_seg = Sig_in(Integer_Part(idx)-delay_Point+1:Integer_Part(idx)+delay_Point+1);
    end
    F_out = h * sig_seg;
    Sig_out(idx,:) = Fractional_Part(idx).^((order-1):-1:0) * F_out;
end
