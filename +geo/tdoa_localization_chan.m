%--------------------------------------------------------------------------
%   location = tdoa_localization_chan(ecef_xyz,time_arrive)
%--------------------------------------------------------------------------
%   功能：
%   多站定位时差目标时差估计(Chan算法 不如ds效果好)
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
function location = tdoa_localization_chan(ecef_xyz,time_arrive)
time_arrive = time_arrive(:)';
c =  299792458;                                                             %精确光速
dr = c*(time_arrive(2:end) - time_arrive(1));                               %时间差

%   站点球心距离
d = vecnorm(ecef_xyz);
l = (d(2:end).^2 - d(1).^2 - dr.^2)./2;

Dr = -dr';
D = l';

A = ecef_xyz(:,2:end) - ecef_xyz(:,1);

a = (A*A')\A*Dr;
b = (A*A')\A*D;

I = sum(a.^2)-1;
J = (b-ecef_xyz(:,1))'*a;
K = sum((b - ecef_xyz(:,1)).^2);

r1 = - (J + sqrt(J^2 - I*K))/I;
r2 = - (J - sqrt(J^2 - I*K))/I;

location1 = a*r1 + b;
location2 = a*r2 + b;

% 选择Z值较大的解（即正高度）
if location1(3) > location2(3)
    location = location1;
else
    location = location2;
end

end