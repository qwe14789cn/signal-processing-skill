function p3(signal, fs, mark)
%P3 复信号三维可视化工具
%
%   P3(SIGNAL) 绘制复信号的三维轨迹图，横轴为采样点数，纵轴为实部，
%   Z轴为虚部。
%
%   P3(SIGNAL, FS) 使用采样率 FS 绘制时间轴（秒）代替采样点数。
%
%   P3(SIGNAL, [], MARK) 绘制复信号轨迹，横轴为采样点数，使用指定
%   的线条标记样式。
%
%   P3(SIGNAL, FS, MARK) 使用采样率 FS 和指定线条标记样式绘制复信号
%   时间域轨迹。
%
%   输入参数：
%       signal - 复信号向量或矩阵（列为信号）
%       fs     - 采样率（Hz），标量（可选，默认为 []）
%       mark   - 绘图线型标记字符串，如 'r--', 'k-.' （可选）
%
%   输出参数：
%       无（直接绘制图形）
%
%   功能：
%       常用于查看时域复信号的轨迹、傅里叶变换后频域信号的幅度和相位
%       关系，或星座图分析等。
%
%   示例：
%       % 生成复信号
%       t = 0:0.001:1;
%       s = exp(1j*2*pi*5*t) + 0.5*exp(1j*2*pi*10*t);
%
%       % 绘制点数轴上的轨迹
%       p3(s);
%
%       % 绘制时间轴上的轨迹
%       p3(s, 1000);
%
%       % 使用红色虚线绘制
%       p3(s, 1000, 'r--');
%
%       % 仅指定标记样式（fs为空）
%       p3(s, [], 'bo-');

    % ------------------ 输入校验 ------------------
    if nargin < 1 || nargin > 3
        error('函数需要1至3个输入参数。');
    end
    
    if ~isnumeric(signal) || isempty(signal)
        error('signal 必须是非空数值数组。');
    end
    
    % 转换为列向量处理
    if size(signal, 1) == 1
        signal = signal(:);  % 行向量转列向量
    end
    
    % 检查 fs
    if nargin >= 2 && ~isempty(fs)
        if ~isscalar(fs) || fs <= 0
            error('fs 必须是正标量或空值。');
        end
    end
    
    % 检查 mark
    if nargin == 3 && ~isempty(mark) && ~ischar(mark) && ~isstring(mark)
        error('mark 必须是字符或字符串类型的线型标记。');
    end

    % ------------------ 核心绘图逻辑 ------------------
    n_points = size(signal, 1);
    indices = (1:n_points)';
    
    % 确定 X 轴（时间或点数）
    if nargin >= 2 && ~isempty(fs)
        x_axis = indices * (1/fs);  % 时间轴
        x_label = 'X: 时间 (s)';
    else
        x_axis = indices;  % 采样点数
        x_label = 'X: 点数';
    end
    
    % 确定绘图样式
    if nargin == 3 && ~isempty(mark)
        plot3(x_axis, real(signal), imag(signal), mark);
    else
        plot3(x_axis, real(signal), imag(signal));
    end
    
    % 设置坐标轴标签
    xlabel(x_label);
    ylabel('Y: 实部');
    zlabel('Z: 虚部');
    
    % 添加网格
    grid on;
    
    % 设置图形标题（可选）
    title('复信号三维轨迹图');
end