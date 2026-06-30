%--------------------------------------------------------------------------
%   least_squares_triangulation_3d(radar_pos,azimuth_deg,elevation_deg)
%--------------------------------------------------------------------------
%   功能：
%   三维多站定位(三角测量最小二乘法)
%   根据多站雷达的xyz坐标以及方位角，俯仰角，用最小二乘估计最优目标位置
%   (侧向矢量不考虑前后位置,输入数据不合理,会在背后出现目标)
%--------------------------------------------------------------------------
%   输入：
%           radar_pos           雷达站的xy坐标，列向量行排列
%                               [x1 x2 x3 ...
%                                y1 y2 y3 ...
%                                z1 z2 z3 ...]
%           azimuth_deg         方位角
%           elevation_deg       俯仰角
%   输出:
%           est_pos             估计目标位置[x y z]'
%           v                   射线矢量
%--------------------------------------------------------------------------
function [est_pos,v] = least_squares_triangulation_3d(radar_pos,azimuth_deg,elevation_deg)
% 角度转换为行向量
azimuth_deg = azimuth_deg(:)';
elevation_deg = elevation_deg(:)';

% 计算单位方向向量 v_i = [cosβ cosα, cosβ sinα, sinβ]
v = [cosd(elevation_deg) .* cosd(azimuth_deg); 
     cosd(elevation_deg) .* sind(azimuth_deg); 
     sind(elevation_deg)];

% 构造 A 和 b
A = zeros(3);
b = zeros(3, 1);

for idx = 1:size(radar_pos, 2)
    v_i = v(:, idx);
    r_i = radar_pos(:, idx);
    
    % 投影矩阵 P = I - v_i * v_i^T
    P = eye(3) - v_i * v_i';
    
    % 更新 A 和 b
    A = A + P;
    b = b + P * r_i;
end

%   解线性方程组 Ax = b 三种写法都可以
est_pos = A \ b;
% est_pos = (A'*A)^-1*A'*b;
% est_pos = pinv(A) * b;
end