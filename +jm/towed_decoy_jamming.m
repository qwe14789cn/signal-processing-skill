%--------------------------------------------------------------------------
%   towed_decoy_jamming(sig,array_N,range,PRT,V,R_tow,fc,fs)
%--------------------------------------------------------------------------
%   功能：
%   转发式拖曳干扰(角度干扰),模拟导弹采集的回波信号
%--------------------------------------------------------------------------
%   输入：
%           sig         采集信号
%           array_N     导弹接收阵列天线阵元数
%           range       导弹发现目标的跟踪距离 例如3000~8000m
%           V           导弹飞行速度  如680~1360 m/s (2~4马赫)
%           R_tow       拖曳距离(一般为90~150m)
%           k           转发能量增益  一般为1.5~3
%           fs          信号表达频率
%   输出：
%           wave        拖曳信号输出
%--------------------------------------------------------------------------
%   直飞拖曳干扰信号生成
%                                                   ↑
%                                                   o   ←飞机
%     o--→                                          .
%     ↑                                             .
%     导弹                                          x   ←拖曳干扰
%--------------------------------------------------------------------------
%   受制于数据量太大，约束仿真为1000个PRT
%--------------------------------------------------------------------------
%
%   例子：
%   echo = towed_decoy_jamming(sig,R_tow,k,fs)
%--------------------------------------------------------------------------
function echo = towed_decoy_jamming(sig,array_N,range,PRT,V,R_tow,k,fc,fs)
sig = sig(:);
pc = flipud(conj(sig));
sig_len = length(pc);
%--------------------------------------------------------------------------
%   默认参数
%--------------------------------------------------------------------------
c = 3e8;
lambda = 1;
fc = c/lambda;
d = lambda/2;
T = 1/fs;

if array_N/2 - floor(array_N/2) == 0
    %   偶数
    N_axis = (1:array_N)-round(array_N/2)-0.5;
else
    %   奇数
    N_axis = (1:array_N)-round(array_N/2);
end
dd = d * N_axis;

%--------------------------------------------------------------------------
%   信号来向角度
%--------------------------------------------------------------------------
idx = 1;
while range>0
    %   信号+干扰来向角计算
    theta_tgt =  atand(R_tow/2/range);
    theta_jam = -atand(R_tow/2/range);
    
    st_tgt = exp(1j.*2*pi/lambda.*dd*sind(theta_tgt));
    st_jam = exp(1j.*2*pi/lambda.*dd*sind(theta_jam));

    %   仿真距离延迟
    R_delay_tgt = norm([range R_tow/2]);
    R_delay_jam = 2*R_delay_tgt + R_tow + 300;                              %信号抵达目标 经过拖曳光缆 在回来 + 系统转换延迟300m

    delay_time_tgt = 2*R_delay_tgt/c;                                       %根据拖曳光缆计算延迟时间
    delay_time_jam = R_delay_jam/c;                                         %根据拖曳光缆计算延迟时间


    delay_N_tgt = round(delay_time_tgt/T);                                  %信号延迟点数
    delay_N_jam = round(delay_time_jam/T);                                  %信号延迟点数

    echo_tgt = [zeros(delay_N_tgt,1);sig];                                  %目标回波
    echo_jam = [zeros(delay_N_jam,1);sig].*k;                               %干扰回波x增益

    maxLength = max(length(echo_tgt), length(echo_jam));

    % 扩展两个向量到相同的长度
    echo_tgt = [echo_tgt; zeros(maxLength - length(echo_tgt),1)];
    echo_jam = [echo_jam; zeros(maxLength - length(echo_jam),1)];

    echo(1:size(echo_tgt,1),:,idx) = echo_tgt.*st_tgt + echo_jam.*st_jam;
    
    %----------------------------------------------------------------------
    %   验证
    %----------------------------------------------------------------------
    echo_pc = sp.filter_w(echo(:,:,idx),pc);
    echo_pc = echo_pc(sig_len:end,:);
    sp.p3(echo_pc);axis([0 inf -1e3 1e3 -1e3 1e3]);
    drawnow

    %----------------------------------------------------------------------
    %   更新位置
    %----------------------------------------------------------------------
    range = range - V*PRT;
    idx = idx + 1;

    if range < 0
        break
    end
end