%--------------------------------------------------------------------------
%   [L,L_P,L_dB] = l_steering_vector_array_pattern(w,delta,angle_axis)
%--------------------------------------------------------------------------
%   功能：
%   从导向矢量直接得到天线方向图
%--------------------------------------------------------------------------
%   输入:
%           w                   导向矢量
%           delta = d/lambda    阵列间距和波长的比值
%           angle_axis          角度轴
%   输出:
%           L                   电磁辐射复数形式
%           L_P                 功率天线方向图
%           L_dB                dB天线方向图
%--------------------------------------------------------------------------
%   例子:
%--------------------------------------------------------------------------
function [L,L_P,L_dB] = l_steering_vector_array_pattern(w,delta,angle_axis)
w = w(:);
N = numel(w);
lambda = 1;
dd = delta*lambda;
d = 0:dd:(N-1)*dd;                                                          %构建阵列坐标
idx = 1;
for theta_step = angle_axis
    A = exp(1j.*2*pi*d.'*sind(theta_step)/lambda);                         %法线0°，左侧负，右侧正
    % L(idx) = w'*A;                                                        %近似选取上一步作为归一化中心
    L(idx,:) = sum(w.*A,1);
    idx = idx + 1;
end
L = L./max(abs(L));
L_P = abs(L).^2;
L_dB = mag2db(abs(L));

if nargout == 0
    plot(angle_axis,L_dB);grid on
end