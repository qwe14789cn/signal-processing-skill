%--------------------------------------------------------------------------
%   location = tdoa_localization_ds(ecef_xyz,time_arrive)
%--------------------------------------------------------------------------
%   功能：
%   多站定位时差目标时差估计(double sphere双球曲面定位法)
%   注意事项:
%   1.二维定位至少需要3个基站
%   2.三维定位至少需要4个基站
%   3.高度不支持负数，因为方程求解有模糊性
%   4.算法假设目标在地球附近，利用地球半径约束解的选择
%--------------------------------------------------------------------------
%   输入:
%           ecef_xyz = [x1 x2 x3 ...
%                       y1 y2 y3 ...
%                       z1 z2 z3 ...]   3×N 矩阵，每列为基站ECEF坐标 [x;y;z] (单位:米)
%           time_arrive                 1×N 向量，目标抵达各站时间 (单位:秒)
%   输出:
%            location                   3×1 向量，目标ECEF坐标 [x;y;z]
%--------------------------------------------------------------------------
function location = tdoa_localization_ds(ecef_xyz, time_arrive)
% 参数初始化
c = 299792458;  % 精确光速 (m/s)
time_arrive = time_arrive(:)';  % 确保行向量
num_anchors = size(ecef_xyz,2);

% 双球面算法核心计算 ------------------------------------------------
% 计算时间差转换的距离差 (以第一个基站为参考)
dr = c * (time_arrive(2:end) - time_arrive(1));  % (N-1)×1

% 计算基站到原点的距离 (用于球面方程)
d = vecnorm(ecef_xyz, 2, 1);  % 1×N

% 构建线性方程组参数
l = (d(2:end).^2 - d(1).^2 - dr.^2) ./ 2;  % (N-1)×1
A = ecef_xyz(:, 2:end) - ecef_xyz(:, 1);   % 3×(N-1)

% 最小二乘求解 (正则化处理) chan算法直接最小二乘 双球用正则化求解
Dr = -dr';
D = l';
a = (A * A' + 1e-6 * eye(3)) \ (A * Dr);   % Tikhonov正则化
b = (A * A' + 1e-6 * eye(3)) \ (A * D);

% 求解二次方程 (选择物理可行解)
I = sum(a.^2) - 1;
J = (b - ecef_xyz(:, 1))' * a;
K = sum((b - ecef_xyz(:, 1)).^2);
discriminant = J^2 - I * K;

r1 = -(J + sqrt(discriminant)) / I;
r2 = -(J - sqrt(discriminant)) / I;
candidate1 = a * r1 + b;
candidate2 = a * r2 + b;

% 改进的高度解选择逻辑 --------------------------------------------
% 优先选择高度与地球表面一致的解 (假设目标在地球附近)
earth_radius = 6378137;  % WGS84椭球长半轴
alt_diff1 = abs(norm(candidate1) - earth_radius);
alt_diff2 = abs(norm(candidate2) - earth_radius);

if alt_diff1 < alt_diff2
    location = candidate1;
else
    location = candidate2;
end
end