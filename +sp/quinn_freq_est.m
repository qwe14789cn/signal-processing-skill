function [f_est, k_est, delta] = quinn_freq_est(signal, Fs)
% QUINN_FREQ_EST  基于 Quinn 算法的精确频率估计
%
% 调用方式：
%   quinn_freq_est(signal)                         - 归一化频率 + 画图
%   quinn_freq_est(signal, Fs)                     - 实际频率 (Hz) + 画图
%   f = quinn_freq_est(signal, Fs)                 - 只返回结果，不画图
%   [f, k, d] = quinn_freq_est(signal, Fs)         - 完整输出，不画图
%
% 规则：
%   有输出变量 → 只算不画图
%   无输出变量 → 算完自动画频谱图（上全频段，下放大）
%
% 输入：
%   signal  - 实数或复数向量
%   Fs      - 采样率 (Hz)，可选
%
% 输出：
%   f_est   - 频率估计
%   k_est   - 连续 bin 位置
%   delta   - 偏移量

    signal = signal(:).';
    N = length(signal);
    is_complex = ~isreal(signal);

    %% FFT
    X = fft(signal);
    f_axis = (0:N-1) / N;
    has_fs = (nargin >= 2 && ~isempty(Fs));
    if has_fs
        f_axis = f_axis * Fs;
    end

    %% 搜索范围
    if is_complex
        search_range = 1:N;
    else
        search_range = 1:floor(N/2)+1;
    end

    %% 找最大谱线
    [~, idx_max] = max(abs(X(search_range)));
    k_max = search_range(idx_max);

    %% 边界保护
    if k_max <= 1 || k_max >= N
        k_est = k_max - 1;
        delta = 0;
        if has_fs
            f_est = k_est / N * Fs;
        else
            f_est = k_est / N;
        end
        warning('quinn_freq_est:peakAtBoundary', ...
            '峰值在 bin %d（边界），返回粗估计', k_max);
        if nargout == 0, plot_spectrum(); end
        return;
    end

    %% Quinn 算法
    beta_1 = real(X(k_max - 1) / X(k_max));
    delta_1 = beta_1 / (1 - beta_1);

    beta_2 = real(X(k_max + 1) / X(k_max));
    delta_2 = beta_2 / (beta_2 - 1);

    if delta_1 > 0 && delta_2 > 0
        delta = delta_2;
    else
        delta = delta_1;
    end

    %% 输出
    k_est = (k_max - 1) + delta;
    if has_fs
        f_est = k_est / N * Fs;
        if is_complex && f_est > Fs/2
            f_est = f_est - Fs;
        end
    else
        f_est = k_est / N;
    end

    %% 无输出时画图
    if nargout == 0
        plot_spectrum();
    end

    %% ========== 频谱图 ==========
    function plot_spectrum()
        mag_db = 20 * log10(abs(X) + eps);

        % 频率轴单位自动缩放
        f_max = f_axis(end);
        if f_max >= 1e9
            f_scale = 1e9; f_unit = 'GHz';
        elseif f_max >= 1e6
            f_scale = 1e6; f_unit = 'MHz';
        elseif f_max >= 1e3
            f_scale = 1e3; f_unit = 'kHz';
        else
            f_scale = 1;   f_unit = 'Hz';
        end
        f_disp = f_axis / f_scale;

        % 缩放范围
        zl = max(1, k_max - 30);
        if is_complex
            zh = min(N, k_max + 30);
            full_idx = 1:N;
        else
            zh = min(floor(N/2)+1, k_max + 30);
            full_idx = 1:floor(N/2)+1;
        end
        zoom_idx = zl:zh;

        % 估计频率显示
        f_est_disp = f_est / f_scale;

        figure('Position', [100 100 960 600], 'Color', 'w');

        % 上图：全频段
        subplot(2,1,1);
        plot(f_disp(full_idx), mag_db(full_idx), 'LineWidth', 1);
        hold on;
        xline(f_est_disp, 'LineWidth', 1.5);
        title(sprintf('f = %.4f %s', f_est_disp, f_unit), 'FontSize', 14);
        xlabel(sprintf('频率 (%s)', f_unit));
        ylabel('幅度 (dB)');
        grid on;
        hold off;

        % 信息框（右上角，避开曲线）
        annotation('textbox', [0.78 0.82 0.18 0.08], ...
            'String', { ...
                sprintf('f_{est} = %.4f %s', f_est_disp, f_unit), ...
                sprintf('N = %d', N), ...
                sprintf('Fs = %.0f %s', Fs/f_scale, f_unit), ...
                sprintf('\\delta = %.4f', delta) ...
            }, ...
            'BackgroundColor', [0.95 0.95 1], ...
            'EdgeColor', [0.3 0.6 0.9], ...
            'FontSize', 9, ...
            'FitBoxToText', 'on');

        % 下图：放大
        subplot(2,1,2);
        plot(f_disp(zoom_idx), mag_db(zoom_idx), 'LineWidth', 1.5);
        hold on;
        xline(f_est_disp, 'LineWidth', 1.5);
        title('峰值附近放大', 'FontSize', 13);
        xlabel(sprintf('频率 (%s)', f_unit));
        ylabel('幅度 (dB)');
        grid on;
        hold off;
    end

end
