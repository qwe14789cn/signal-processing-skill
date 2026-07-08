function [k, f_mid, R_frac, nco_tuning_word] = ...
    calc_generic_asrc_params(fs_in, fs_out, N_base)
% CALC_GENERIC_ASRCPARAMS 通用任意采样率转换（ASRC）参数计算函数
%
% 功能：
%   将任意输入采样率 fs_in 转换为目标输出采样率 fs_out，
%   采用“前端 Farrow 分数插值 + 后端整数倍升采样”架构。
%   Farrow 负责处理 [1, N_base) 倍的分数部分，
%   后续使用 k 级 N_base 倍升采样（如 ×2 半带滤波器）达到最终速率。
%
% 输入参数:
%   fs_in     - 输入采样率（单位：Hz），必须 > 0
%   fs_out    - 目标输出采样率（单位：Hz），必须 > fs_in
%   N_base    - 基础整数升采样因子（默认为 2，可选 2、4、5、10 等整数 ≥2）
%
% 输出参数:
%   k                - 整数升采样级数（共 k 级，每级 ×N_base）
%   f_mid            - Farrow 模块的输出中间采样率（Hz）
%   R_frac           - Farrow 插值倍数 = f_mid / fs_in，应满足 1 ≤ R_frac < N_base
%   nco_tuning_word  - NCO（数控振荡器）调谐字（48 位整数），用于 FPGA 配置
%   N_base           - 实际使用的升采样基础因子
%
% 使用示例:
%   calc_generic_asrc_params(48e3, 320e6, 2);      % 通信系统：48kHz → 320MHz
%   calc_generic_asrc_params(44.1e3, 192e3, 2);    % 音频重采样：44.1kHz → 192kHz
%   calc_generic_asrc_params(10e6, 125e6, 5);      % 自定义 ×5 升采样

    if nargin < 3
        N_base = 2;  % 默认使用 ×2 升采样（半带滤波器）
    end

    % 输入合法性检查
    if fs_in <= 0
        error('输入采样率 fs_in 必须大于 0！');
    end
    if fs_out <= fs_in
        error('目标输出采样率 fs_out 必须大于输入采样率 fs_in！');
    end
    if N_base < 2 || floor(N_base) ~= N_base
        error('基础升采样因子 N_base 必须是大于等于 2 的整数！');
    end

    % 计算最大整数 k，使得 f_mid = fs_out / (N_base^k) >= fs_in
    k_real = log(fs_out / fs_in) / log(N_base);
    k = floor(k_real);
    k = max(0, k);  % 防止负数

    % 计算中间采样率
    f_mid = fs_out / (N_base^k);

    % 安全处理：若因浮点误差导致 f_mid < fs_in，则减少 k
    while f_mid < fs_in && k > 0
        k = k - 1;
        f_mid = fs_out / (N_base^k);
    end

    % 计算 Farrow 插值倍数
    R_frac = f_mid / fs_in;

    % 检查 R_frac 是否在合理范围 [1, N_base)
    if R_frac < 1 - 1e-6
        error('Farrow 插值倍数 R_frac 小于 1，逻辑异常！');
    elseif R_frac >= N_base
        warning('警告：Farrow 插值倍数 R_frac = %.6f 超出推荐范围 [1, %d)。', R_frac, N_base);
        % 尝试增加 k（如果数学上允许）
        if k + 1 <= k_real
            k = k + 1;
            f_mid = fs_out / (N_base^k);
            R_frac = f_mid / fs_in;
            fprintf('已自动调整 k，新 R_frac = %.6f\n', R_frac);
        end
    end

    % 计算 NCO 调谐字（48 位）
    % NCO 步长 = 输入速率 / 中间速率 = fs_in / f_mid
    ratio = fs_in / f_mid;
    nco_tuning_word = round(ratio * (2^48));
    nco_tuning_word = min(nco_tuning_word, 2^48 - 1);  % 防止溢出

    % 打印结果（中文）
    fprintf('\n=== 任意采样率转换（ASRC）参数计算结果 ===\n');
    fprintf('  输入采样率 (fs_in) \t\t: %.6g Hz (%.3f kHz)\n', fs_in, fs_in/1e3);
    fprintf('  目标输出采样率     \t\t: %.6g Hz (%.3f MHz)\n', fs_out, fs_out/1e6);
    fprintf('  基础升采样因子 N   \t\t: %d\n', N_base);
    fprintf('  → 整数升采样级数 k \t\t: %d\n', k);
    fprintf('  → Farrow 输出速率 \t\t: %.6g Hz (%.3f kHz)\n', f_mid, f_mid/1e3);
    fprintf('  → Farrow 插值倍数  \t: %.6f （应在 [1, %d) 区间内）\n', R_frac, N_base);
    fprintf('  → NCO 调谐字 (48位)\t: 0x%012X\n', nco_tuning_word);
    fprintf('  → 最终输出验证     \t\t: %.6g Hz （应等于 %.6g Hz）\n', f_mid * (N_base^k), fs_out);
    fprintf('=============================================\n\n');
end