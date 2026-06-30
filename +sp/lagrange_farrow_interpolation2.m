%--------------------------------------------------------------------------
%   [Sig_out,index] = lagrange_farrow_interpolation2(x,Sig_in,new_x,order)
%--------------------------------------------------------------------------
%   功能：
%   farrow滤波器信号重采样(分块流式处理)
%--------------------------------------------------------------------------
%   输入:
%           x                时间轴
%           Sig_in           输入信号
%           new_x            新的时间轴
%           order            阶数
%   输出:
%           Sig_out          对应插值时间轴的信号
%           index            插值整数 → 插值后的整数,小数
%--------------------------------------------------------------------------
function Sig_out = lagrange_farrow_interpolation2(Sig_in,new_x,order)
Sig_in = Sig_in(:);
%初始化拉格朗日插值滤波器系数
h = lagrange_farrow_matrix(order);

if rem(order,2) == 1
    % disp('奇数阶数')
else
    disp('不允许输入偶数')
    return
end

delay_Point = floor(order/2);
time_axis_out = new_x;                                                      %时间轴归一化


time_axis_out = time_axis_out - floor(time_axis_out(1));                    %调整分数时间轴
%   插值后的计算整数和小数部分
Integer_Part = floor(time_axis_out);
Fractional_Part = time_axis_out - Integer_Part;

Sig_out = zeros(numel(time_axis_out),1);

for idx = 1:numel(time_axis_out)
    %   尾巴数据不够补0 
    if Integer_Part(idx)>= length(Sig_in) - delay_Point    
        sig_seg = [Sig_in(Integer_Part(idx)-delay_Point+1:end);zeros(Integer_Part(idx)+delay_Point+1-length(Sig_in),1)];
    
    %   开始数据不够补0    
    elseif Integer_Part(idx) < delay_Point
        sig_seg = [zeros(delay_Point - Integer_Part(idx),1);Sig_in(1:Integer_Part(idx)+delay_Point+1)];
    
    else
        sig_seg = Sig_in(Integer_Part(idx)-delay_Point+1:Integer_Part(idx)+delay_Point+1);
    end
    F_out = h * sig_seg; %奇数
    Sig_out(idx,:) = Fractional_Part(idx).^((order-1):-1:0) * F_out;
end



function h = lagrange_farrow_matrix(L)
N = L-1;                                                                    % 滤波器阶数
M = N/2;                                                                    % 中心值
%--------------------------------------------------------------------------
if (M-round(M))==0 
    N1 = M;
    N2 = M;
else
    N1 = round(M);
    N2 = round(M)-1;
end

P = [];
for k = -N1:N2
    poly_para = 1;
    poly_gain = 1;
    for m = -N1:N2
        if m ~= k
            poly_para = conv(poly_para,[-m -1]);
            poly_gain = poly_gain*(k-m);
        end
    end
    P = [P;poly_para./poly_gain];
end
h = rot90(P,2).';
end

end