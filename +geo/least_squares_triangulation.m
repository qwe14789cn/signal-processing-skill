%--------------------------------------------------------------------------
%   least_squares_triangulation(radar_pos,angles)
%--------------------------------------------------------------------------
%   功能：
%   二维多站定位(三角测量最小二乘法)
%   根据多站雷达的xy坐标以及测向角度，用最小二乘估计最优目标位置
%   (侧向矢量不考虑前后位置,输入数据不合理,会在背后出现目标)
%--------------------------------------------------------------------------
%   输入：
%           radar_pos           雷达站的xy坐标，列向量行排列
%                               [x1 x2 x3 ...
%                                y1 y2 y3 ...]
%           angles_deg          测量目标角度
%   输出:
%           est_pos             估计目标位置[x y]'
%--------------------------------------------------------------------------
function est_pos = least_squares_triangulation(radar_pos,angles_deg)
sin_theta_d = sind(angles_deg);
cos_theta_d = cosd(angles_deg);

% 构造矩阵 A 和向量 b  A*x=b
A = zeros(2);
b = zeros(2,1);

for idx = 1:size(radar_pos, 2)
    x_idx = radar_pos(1, idx);
    y_idx = radar_pos(2, idx);
    
    % 更新矩阵 A
    A = A + [sin_theta_d(idx)^2 -sin_theta_d(idx)*cos_theta_d(idx)
             -sin_theta_d(idx)*cos_theta_d(idx) cos_theta_d(idx)^2];
    % 更新矩阵 b
    b = b + [sin_theta_d(idx)^2*x_idx-sin_theta_d(idx)*cos_theta_d(idx)*y_idx
             - sin_theta_d(idx)*cos_theta_d(idx)*x_idx+cos_theta_d(idx)^2*y_idx];
end

%   解线性方程组 Ax = b
%   两种写法都可以
% target_pos = A \ b;
est_pos = (A'*A)^-1*A'*b;
end