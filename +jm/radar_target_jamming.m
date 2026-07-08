%--------------------------------------------------------------------------
%   wave = radar_target_jamming(sig,fc,PRT,N_prt,RV_target,fs)
%--------------------------------------------------------------------------
%   功能：
%   雷达假目标干扰
%--------------------------------------------------------------------------
%   输入：
%           sig                 雷达回波
%           fc                  载频
%           PRT                 雷达PRT
%           N_prt               PRT数量  N_prt*PRT=总时间
%           RV_target           假目标列表|R1 R2 R3 R4 R5 ...|
%                                        |V1 V2 V3 V4 V5 ...|
%           fs                  表达频率
%   
%   输出：
%           echo                雷达回波
%--------------------------------------------------------------------------
function echo = radar_target_jamming(sig,fc,PRT,N_prt,RV_target,fs)
c = 3e8;
T = 1/fs;
lambda = c/fc;
N = round(PRT/T);
R_max = time2range(PRT,c);                                                  %计算距离最大输入值
sig_len = length(sig);
sig_T = T*sig_len;                                                          %信号持续时间
sig_range = time2range(sig_T,c);
PRF = 1/PRT;
vmax = PRF*lambda/2/2;
vmin = -vmax; 

%--------------------------------------------------------------------------
%   变量判决区域
%--------------------------------------------------------------------------
if PRT/T - round(PRT/T) ~= 0 
    disp('PRT和fs采样率不是整数 PRT*fs应为整数')
    echo = nan;
    return
end

if length(sig)*T > PRT
    disp('信号长度＞PRT时间,采集信号不合理')
    echo = nan;
    return
end

if max(RV_target(1,:)) > (R_max-sig_range)
    disp('距离超出PRT范围')
    echo = nan;
    return
end

if max(RV_target(2,:)) > vmax || min(RV_target(2,:)) < vmin
    disp('速度超出雷达测速范围')
    echo = nan;
    return
end

disp(['距离输入范围:' num2str([0 R_max-sig_range])])
disp(['速度输入范围:' num2str([vmin vmax])])

%--------------------------------------------------------------------------
%   构造回波信号
%--------------------------------------------------------------------------
sig_prt = zeros(N,1);
sig_prt(1:sig_len) = sig;

%--------------------------------------------------------------------------
%   信号缓冲区
%--------------------------------------------------------------------------
echo = zeros(N,N_prt);

%--------------------------------------------------------------------------
%   计算距离 速度多普勒
%--------------------------------------------------------------------------
delay_N = round(range2time(RV_target(1,:),c)/T);
fd = 2 * RV_target(2,:) / lambda;  

%--------------------------------------------------------------------------
%   添加距离-速度信息
%--------------------------------------------------------------------------
slow_time = (0:N_prt-1)*PRT;
for idx = 1:size(RV_target,2)
    phi = exp(1j.*2*pi*fd(idx).*slow_time);
    echo = echo + repmat(circshift(sig_prt,delay_N(idx)),1,N_prt).*phi;
end
end
