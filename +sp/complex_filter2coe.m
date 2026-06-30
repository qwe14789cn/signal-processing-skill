function [r2r, i2r, r2i, i2i] = complex_filter2coe(w)
%COMPLEX_FILTER2COE 将复数FIR滤波器分解为4个实系数滤波器
%
%   [r2r, i2r, r2i, i2i] = COMPLEX_FILTER2COE(w)
%
%   输入:
%       w : 复数列向量，FIR滤波器系数（长度 L）
%
%   输出（均为实数列向量，长度 L）:
%       r2r : 实部输入 → 实部输出 的滤波器 (h_rr = Re{w})
%       i2r : 虚部输入 → 实部输出 的滤波器 (h_ir = -Im{w})
%       r2i : 实部输入 → 虚部输出 的滤波器 (h_ri = Im{w})
%       i2i : 虚部输入 → 虚部输出 的滤波器 (h_ii = Re{w})
%
%   使用方式:
%       y_r = conv(x_r, r2r) + conv(x_i, i2r);
%       y_i = conv(x_r, r2i) + conv(x_i, i2i);
%       y   = y_r + 1j * y_i;

    % 输入校验
    if ~isvector(w) || ~isnumeric(w)
        error('Input w must be a numeric vector.');
    end

    w = w(:);  % 确保列向量

    r2r =  real(w);
    i2r = -imag(w);
    r2i =  imag(w);
    i2i =  real(w);
end