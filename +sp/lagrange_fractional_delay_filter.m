%--------------------------------------------------------------------------
%   h = lagrange_fractional_delay_filter(L, x)
%--------------------------------------------------------------------------
%   功能:
%       生成拉格朗日插值型分数延迟滤波器（FIR）
%       适用于实信号；复信号需额外补偿载波相位
%
%   输入：
%       L   - 滤波器长度（抽头数），正整数（建议奇数，如 3,5,7...）
%       x   - 分数延迟量（单位：采样点），通常 x ∈ [0, 1)
%
%   输出：
%       h   - 长度为 L 的列向量，滤波器系数
%
%   说明：
%       滤波器的总群延迟为 (L-1)/2 + x 个采样点。
%       插值点 D = x + (L-1)/2，符合标准拉格朗日插值定义。
%--------------------------------------------------------------------------
function h = lagrange_fractional_delay_filter(L, x)

    if ~isscalar(L) || L <= 0 || L ~= floor(L)
        error('L must be a positive integer scalar.');
    end
    if ~isscalar(x)
        error('x must be a scalar (fractional delay in samples).');
    end

    D = x + (L - 1) / 2;        % 插值目标位置（标准做法）

    n = (0:L-1)';               % 列向量：[0; 1; ...; L-1]
    h = ones(L, 1);             % 初始化

    for i = 1:L
        k = [0:i-2, i:L-1];     % 所有 k ≠ n(i)
        if ~isempty(k)
            h(i) = prod( (D - k) ./ (n(i) - k) );
        else
            % 当 L=1 时，k 为空，h(1) = 1（恒等）
            h(i) = 1;
        end
    end
end