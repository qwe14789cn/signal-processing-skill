function [steering_vector, time_delays, delay_points] = calc_array_delay_phase(azDeg, elDeg, elePos, fc, fs)
%CALC_ARRAY_DELAY_PHASE 计算阵列接收信号的相位、物理时延及数字域延迟点数
%
%   [SV, TAU, PTS] = CALC_ARRAY_PHASE(AZ, EL, POS, FC, FS) 计算给定来波方向
%   下的窄带导向矢量、物理传播时延和对应的采样点延迟。
%
%   输入:
%       azDeg   - 方位角（度），标量
%       elDeg   - 俯仰角（度），标量  
%       elePos  - N×3 阵元位置矩阵 [x y z]（单位：米）
%       fc      - 载频（Hz），正标量
%       fs      - (可选) 采样率（Hz），正标量
%
%   输出:
%       steering_vector - N×1 复导向矢量（窄带模型）
%       time_delays     - N×1 物理时延（秒），相对于原点
%       delay_points    - N×1 采样点延迟（若提供 fs），通常为小数
%
%   无输出调用时自动绘图并打印详细参数表。
%
%   示例:
%       [sv, tau] = calc_array_phase(30, 10, pos, 2e9);
%       [~, ~, pts] = calc_array_phase(0, 0, pos, 1e9, 100e6);

    % ---------- 输入检查 ----------
    nargin_count = nargin;
    if nargin_count < 4 || nargin_count > 5
        error('需要4个或5个输入参数：azDeg, elDeg, elePos, fc, (可选)fs');
    end

    validateattributes(azDeg, {'numeric'}, {'scalar', 'real'});
    validateattributes(elDeg, {'numeric'}, {'scalar', 'real'});
    validateattributes(elePos, {'numeric'}, {'2d', 'ncols', 3});
    validateattributes(fc, {'numeric'}, {'scalar', 'positive', 'real'});

    has_fs = (nargin_count == 5);
    if has_fs
        validateattributes(fs, {'numeric'}, {'scalar', 'positive', 'real'});
    end

    N = size(elePos, 1);
    
    % ---------- 来波方向矢量（DOA） ----------
    % 注意：此向量天然为单位向量，无需归一化
    u = [cosd(elDeg) * cosd(azDeg); ...
         cosd(elDeg) * sind(azDeg); ...
         sind(elDeg)];

    % ---------- 物理计算 ----------
    c = physconst('LightSpeed');      % 使用标准物理常量
    lambda = c / fc;
    k = 2 * pi / lambda;

    proj = elePos * u;                % 波程差（米）
    time_delays = proj / c;           % 时延（秒）
    steering_vector = exp(-1j * k * proj);

    % 确保列向量
    time_delays = time_delays(:);
    steering_vector = steering_vector(:);

    % ---------- 延迟点数 ----------
    if has_fs
        delay_points = time_delays * fs;
    else
        delay_points = [];
    end

    % ---------- 无输出时：可视化 + 打印 ----------
    if nargout == 0
        % 绘图
        figure('Name', 'Array Geometry and Signal Direction', ...
               'NumberTitle', 'off', 'Color', 'w');
        plot3(elePos(:,1), elePos(:,2), elePos(:,3), 'ro', ...
              'MarkerSize', 8, 'MarkerFaceColor', 'r');
        hold on;

        % 标注阵元
        for i = 1:N
            text(elePos(i,1), elePos(i,2), elePos(i,3), ...
                 sprintf(' %d', i), 'FontSize', 9, ...
                 'VerticalAlignment', 'bottom');
        end

        % 来波方向箭头（确保可见）
        max_range = max([vecnorm(elePos,2,2); 1]); % 至少为1米
        L = max_range * 1.2;
        quiver3(u(1)*L, u(2)*L, u(3)*L, ...
                -u(1)*L, -u(2)*L, -u(3)*L, ...
                'b', 'LineWidth', 2, 'MaxHeadSize', 0.5);

        text(u(1)*L*1.05, u(2)*L*1.05, u(3)*L*1.05, ...
             sprintf('AOA: az=%.1f°, el=%.1f°', azDeg, elDeg), ...
             'FontSize', 10, 'Color', 'b', 'FontWeight', 'bold');

        xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
        title('Array Geometry with Signal Direction of Arrival (DOA)');
        grid on; axis equal; view(3); hold off;

        % 打印表格
        phase_deg = rad2deg(angle(steering_vector));
        time_ns = time_delays * 1e9;

        fprintf('各阵元参数（相对于原点）:\n');
        fprintf('载频: %.2f MHz', fc/1e6);
        if has_fs
            fprintf(', 采样率: %.2f MHz\n', fs/1e6);
        else
            fprintf('\n');
        end

        if has_fs
            T = array2table([ (1:N)', phase_deg, time_ns, delay_points ], ...
                'VariableNames', {'Element','Phase_deg','Delay_ns','Delay_Points'});
            % 保留足够精度（尤其对高fs）
            T.Delay_Points = round(T.Delay_Points, 6);
        else
            T = array2table([ (1:N)', phase_deg, time_ns ], ...
                'VariableNames', {'Element','Phase_deg','Delay_ns'});
        end
        T.Delay_ns = round(T.Delay_ns, 4);
        disp(T);

        if has_fs
            fprintf('注：Delay_Points 为浮点数，表示采样点延迟（需分数延时滤波器实现）。\n');
        else
            fprintf('注：未提供采样率 fs，故未计算延迟点数。\n');
        end
    end
end