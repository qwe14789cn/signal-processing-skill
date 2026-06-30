%--------------------------------------------------------------------------
%   [dataout] = l_steering_vector(d,N,fc,theta_d,window_handle)
%--------------------------------------------------------------------------
%   功能:
%   线阵导向矢量快速计算工具
%--------------------------------------------------------------------------
%   输入:
%           d                       阵列间距
%           N                       阵元数
%           fc                      载频
%           theta_d                 指向角
%           window_handle           窗函数句柄
%   输出:
%           A                       导向矢量
%--------------------------------------------------------------------------
%   例子：
%   l_steering_vector(0.5,20,3e8,0,@taylorwin)
%--------------------------------------------------------------------------
function w = l_steering_vector(d,N,fc,theta_d,window_handle)
lambda = 3e8/fc;
if nargin <= 4
    window_handle = @rectwin;
end
d_axis = (0:N-1).*d;
w = exp(-1j.*2*pi*d_axis.'*sind(theta_d)./lambda).*window_handle(N);
end