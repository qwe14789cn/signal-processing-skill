function [delay_int, delay_frac, phi] = delaytime2point(delay, fs, fc)
%DELAYTIME2POINT 将时间延迟分解为整数采样点、分数采样点和载频相位因子
%
%   [INT, FRAC, PHI] = DELAYTIME2POINT(DELAY, FS, FC) 将连续时间延迟
%   分解为三部分，适用于宽带信号处理中的延迟建模与补偿。
%
%   输入:
%       delay - 时间延迟（秒），标量或数组
%       fs    - 采样率（Hz），正实数标量
%       fc    - 载频（Hz），非负实数标量
%
%   输出:
%       delay_int   - 整数延迟点数（向下取整），与 delay 同尺寸
%       delay_frac  - 分数延迟部分 ∈ [0, 1)，与 delay 同尺寸
%       phi         - 载频相位旋转因子 = exp(-1j*2*pi*fc*delay)
%
%   说明:
%       - 总延迟可表示为: delay = (delay_int + delay_frac) / fs
%       - 相位因子 phi 用于补偿由该延迟引起的载频相移
%       - 即使 delay 为负，delay_frac 仍保持在 [0,1) 区间
%
%   示例:
%       delay = 3.7e-9;     % 3.7 ns
%       fs = 1e9;           % 1 GSPS
%       fc = 2.4e9;         % 2.4 GHz
%       [n, frac, phi] = delaytime2point(delay, fs, fc)
%       % 返回: n=3, frac=0.7, phi=exp(-1j*2*pi*2.4e9*3.7e-9)

    % ---------- 输入校验 ----------
    if nargin ~= 3
        error('需要 exactly 3 个输入参数: delay, fs, fc');
    end

    validateattributes(delay, {'numeric'}, {'real'});
    validateattributes(fs, {'numeric'}, {'scalar', 'positive', 'real'});
    validateattributes(fc, {'numeric'}, {'scalar', 'nonnegative', 'real'});

    % ---------- 计算延迟点 ----------
    T = 1 / fs;
    delay_point = delay / T;  % = delay * fs

    % 处理负延迟：确保 delay_frac ∈ [0, 1)
    delay_int = floor(delay_point);
    delay_frac = delay_point - delay_int;

    % 数值误差修正（防止 1.0 因浮点误差变成 0.999...）
    idx = (delay_frac >= 1 - eps);
    if any(idx(:))
        delay_frac(idx) = 0;
        delay_int(idx) = delay_int(idx) + 1;
    end

    % ---------- 计算载频相位 ----------
    % phi = exp(-j * 2π * fc * delay)
    phi = exp(-1j * 2 * pi * fc .* delay);

    % 确保输出与输入 delay 尺寸一致
    delay_int = reshape(delay_int, size(delay));
    delay_frac = reshape(delay_frac, size(delay));
    phi = reshape(phi, size(delay));
end