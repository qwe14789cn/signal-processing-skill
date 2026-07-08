function enob = dr2enob(dr_dB)
%DR2ENOB 将动态范围（dB）转换为等效有效位数（ENOB）
%
%   ENOB = DR2ENOB(DR_DB) 根据公式：
%       ENOB = (DR_dB - 1.76) / 6.02
%   将动态范围（单位：dB）转换为等效的有效位数（ENOB）。
%
%   输入：
%       dr_dB - 动态范围（dB），标量、向量或矩阵，实数
%
%   输出：
%       enob  - 等效 ENOB，与输入 dr_dB 同尺寸
%
%   说明：
%       - 1.76 dB 和 6.02 dB 分别来自理想 N 位 ADC 的理论：
%           DR = 6.02·N + 1.76 dB
%       - 当 DR_dB < 1.76 时，ENOB < 0，表示系统噪声大于满量程信号，
%         此时结果在数学上成立，但物理意义有限。
%
%   示例：
%       enob = dr2enob(98.1)    % 返回约 16（对应 16 位理想 ADC）
%       enob = dr2enob([74, 86]) % 返回 [12, 14]

    % 输入校验
    if ~isnumeric(dr_dB)
        error('输入 dr_dB 必须为数值类型。');
    end
    
    if ~isreal(dr_dB)
        error('输入 dr_dB 必须为实数。');
    end
    
    % 保留原始尺寸
    originalSize = size(dr_dB);
    dr_dB = dr_dB(:);  % 转为列向量计算
    
    % 检查是否有过低的动态范围（可选警告）
    if any(dr_dB < 1.76, 'all')
        warning('部分动态范围值小于 1.76 dB，对应的 ENOB 为负数。');
    end
    
    % 主计算（保持 IEEE 浮点行为，包括 NaN/Inf）
    enob = (dr_dB - 1.76) / 6.02;
    
    % 恢复原始尺寸
    enob = reshape(enob, originalSize);
end