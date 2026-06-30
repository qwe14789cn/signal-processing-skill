function h = lagrange_farrow_matrix(L)
%LAGRANGE_FARROW_MATRIX 生成Lagrange插值型Farrow结构的系数矩阵
%
%   H = LAGRANGE_FARROW_MATRIX(L) 返回一个 L×L 的系数矩阵 H，
%   用于实现基于 Lagrange 多项式的 Farrow 分数延迟滤波器。
%
%   输入参数：
%       L - FIR滤波器抽头数（正整数），对应插值多项式阶数为 L-1。
%           支持奇数或偶数长度。
%
%   输出参数：
%       h - L×L 矩阵，其中：
%           * 每一列对应一个 Lagrange 基函数的系数（按时间索引）
%           * 每一行对应一个幂次项的系数：
%               h(1, :)  -> x^(L-1) 的系数（最高次项）
%               h(2, :)  -> x^(L-2) 的系数
%               ...
%               h(L, :)  -> x^0     的系数（常数项）
%           使用时，延迟 d ∈ [0,1) 的滤波器为：
%               coeffs = h * [d^(L-1); d^(L-2); ... ; 1];
%
%   注意：
%       - 适用于实信号插值。复信号需额外处理载波相位。
%       - 本实现基于标准 Lagrange 插值公式，数值稳定，适合小 L（推荐 L ≤ 32）。
%
%   示例：
%       h = lagrange_farrow_matrix(4);  % 3阶插值
%       d = 0.3;
%       poly_powers = flip(d .^ (0:3))';  % [d^3; d^2; d^1; d^0]
%       filter_coeffs = h * poly_powers;  % 4抽头FIR系数

    % ------------------ 输入校验 ------------------
    if ~isscalar(L) || L < 1 || L ~= floor(L)
        error('Input L must be a positive integer.');
    end

    if L == 1
        h = 1;
        return;
    end

    N = L - 1;
    M = N / 2;
    N1 = floor(M);
    N2 = ceil(M);          % 确保总点数为 L: 从 -N1 到 N2（含）
    k_list = -N1 : N2;     % 插值节点位置（对称或近似对称）

    % 预分配基函数系数矩阵（每行一个基函数，降幂存储）
    P_basis = zeros(L, L);

    % 构建每个 Lagrange 基函数
    for i = 1:L
        k = k_list(i);
        num = 1;  % 初始化为常数多项式 1（避免标量问题）
        den = 1;
        for m = k_list
            if m ~= k
                num = conv(num, [1, -m]);   % 乘以 (x - m)
                den = den * (k - m);         % 分母累积
            end
        end
        % 归一化并确保长度为 L（理论上已满足）
        P_basis(i, :) = num / den;
    end

    % 转置：使行对应幂次（高次在前），列对应基函数
    h = P_basis.';
end