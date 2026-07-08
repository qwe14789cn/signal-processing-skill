function [h,h_fix_1_16_15] = sinc_fractional_delay_filter(L, win_handle, delay)
%--------------------------------------------------------------------------
%   h = sinc_fractional_delay_filter(L, win_handle, delay)
%--------------------------------------------------------------------------
%   功能:
%       生成基于 sinc 插值与窗函数的分数延迟 FIR 滤波器
%
%   输入：
%       L           - 滤波器长度（正整数，建议奇数）
%       win_handle  - 窗函数句柄，如 @hamming, @hann, @blackman
%       delay       - 总延迟量（单位：采样点），可为任意实数（如 2.4）
%
%   输出：
%       h           - 长度为 L 的列向量，滤波器系数
%
%   说明：
%       理想延迟响应为 h[n] = sinc(n - delay)，n ∈ [0, L-1]
%       实际实现中，时间轴以滤波器中心对齐：n = -(L-1)/2 : (L-1)/2
%       使用窗函数抑制 sinc 截断引起的吉布斯现象。
%--------------------------------------------------------------------------

    % 输入检查
    if ~isscalar(L) || L <= 0 || L ~= floor(L)
        error('参数 L 必须是一个正整数标量。');
    end
    if ~isa(win_handle, 'function_handle')
        error('参数 win_handle 必须是一个窗函数的函数句柄，例如 @hamming、@hann 或 @blackman。');
    end
    if ~isscalar(delay)
        error('参数 delay 必须是一个标量（表示总延迟量，单位为采样点）。');
    end

    % 构造时间索引（以滤波器中心为0）
    n = (0:L-1)' - (L-1)/2;   % 列向量，例如 L=5 → [-2; -1; 0; 1; 2]

    % 理想 sinc 响应：MATLAB 的 sinc(x) = sin(pi*x)/(pi*x)
    h_ideal = sinc(n - delay);

    % 生成窗函数（确保是列向量）
    w = win_handle(L);
    if size(w, 2) > 1
        w = w(:);  % 转为列向量
    end

    % 加窗
    h = h_ideal .* w;

    h_fix_1_16_15 = fi(h,1,16,15);
    % 可选：归一化（使直流增益为1）
    % h = h / sum(h);
end