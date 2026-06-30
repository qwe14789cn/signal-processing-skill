%--------------------------------------------------------------------------
%   parabolic_antenna_radiation_pattern(angle_axis,lambda,a)
%--------------------------------------------------------------------------
%   功能:
%   一维抛物面天线方向图
%--------------------------------------------------------------------------
%   输入:
%           angle_axis              角度轴
%           lambda                  波长
%           a                       天线半径
%           eta                     天线效率
%   输出:
%           L                       能量天线方向图
%           L_P                     功率天线方向图
%           L_dB                    dB天线方向图
%--------------------------------------------------------------------------
%   例子:
%   plot(parabolic_antenna_radiation_pattern(-90:90,0.3,1))
%--------------------------------------------------------------------------
function [L,L_P,L_dB] = parabolic_antenna_radiation_pattern(angle_axis,lambda,a,eta)
if nargin<=3
    eta = 0.55;                                                             %快速计算效率
end
G_a = sqrt(eta*(pi*2*a/lambda).^2);                                         %幅度增益


angle_axis = deg2rad(angle_axis);                                           %转换成弧度
k = 2*pi/lambda;                                                            % 波数
L = besselj(1, k*a*sin(angle_axis)) ./ (k*a*sin(angle_axis)); 
L(angle_axis == 0) = 0.5;                                                   % 中心点归一化
L = L.*2.*G_a;                                                              %0.5缩放到1 加上天线增益
L_P = L.^2;
L_dB = pow2db(L_P);
end