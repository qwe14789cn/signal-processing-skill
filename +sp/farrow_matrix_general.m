function H = farrow_matrix_general(L, P)
%FARROW_MATRIX_GENERAL 生成广义Farrow结构的系数矩阵（降幂排列，按幂长度）
%
%   H = FARROW_MATRIX_GENERAL(L, P) 返回一个 P×L 的系数矩阵 H，
%   用于实现基于多项式拟合的 Farrow 分数延迟滤波器。
%
%   输入参数：
%       L - FIR滤波器抽头数（正整数），决定滤波器长度。
%       P - 幂的长度（正整数），即多项式包含 P 个幂次项：
%           d^(P-1), d^(P-2), ..., d^0
%           （等价于多项式阶数 O = P-1）
%
%   输出参数：
%       H - P×L 矩阵，降幂排列：
%           H(1, :)  -> d^(P-1) 的系数（最高次项）
%           H(2, :)  -> d^(P-2) 的系数
%           ...
%           H(P, :)  -> d^0     的系数（常数项）
%
%   使用示例：
%       H = farrow_matrix_general(16, 4);  % 16抽头，4个幂项（3阶多项式）
%       d = 0.4;
%       pows = flip(d .^ (0:3))';          % [d^3; d^2; d^1; d^0]，长度=4
%       coeffs = H * pows;                 % 16×1 FIR系数
%
%   设计方法：
%       最小二乘拟合在 d ∈ [0,1) 上的理想 sinc 分数延迟响应。

    % ------------------ 输入校验 ------------------
    if ~isscalar(L) || L < 1 || L ~= floor(L)
        error('L must be a positive integer (filter length).');
    end
    if ~isscalar(P) || P < 1 || P ~= floor(P)
        error('P must be a positive integer (number of power terms).');
    end

    % 特殊情况：P = 1（只有常数项，零阶保持）
    if P == 1
        H = ones(1, L);
        return;
    end

    % --- 构建理想响应 ---
    D = 0 : 0.01 : 1;                  % 延迟采样点
    M = length(D);
    n = (0:L-1)' - (L-1)/2;            % 时间索引，中心对齐
    Y = zeros(M, L);
    for i = 1:M
        d = D(i);
        Y(i, :) = sinc(n - d).';       % 理想分数延迟响应
    end

    % --- 构建范德蒙德矩阵 A (M × P)，降幂：[d^(P-1), d^(P-2), ..., d^0] ---
    A = zeros(M, P);
    for p = 1:P
        A(:, p) = D .^ (P - p);        % p=1 → d^(P-1); p=P → d^0
    end

    % --- 最小二乘求解：A * H' ≈ Y  =>  H = (A \ Y)' ---
    H = (A \ Y)';
end