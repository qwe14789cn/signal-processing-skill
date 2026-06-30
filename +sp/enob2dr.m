function dr_dB = enob2dr(enob)
%ENOB2DR 将 ADC 有效位数（ENOB）转换为理论动态范围（dB）
%
%   DR_DB = ENOB2DR(ENOB) 根据理想 ADC 理论公式：
%       DR (dB) = 6.02 × ENOB + 1.76
%   将有效位数（ENOB）转换为对应的动态范围（单位：dB）。
%
%   输入:
%       enob - 有效位数（Effective Number of Bits），标量、向量或矩阵，
%              必须为非负实数（支持小数，如 12.3、13.4）
%
%   输出:
%       dr_dB - 理论动态范围（dB），与输入 enob 同尺寸
%
%   公式来源:
%       对于理想 N 位 ADC，满量程正弦信号的 SNR ≈ 6.02N + 1.76 dB，
%       动态范围（DR）在此等同于 SNR。
%
%   示例:
%       dr = enob2dr(12)        % 返回 74.0000
%       dr = enob2dr(13.4)      % 返回 82.4280
%       dr = enob2dr([10 12.5]) % 返回 [61.9600 77.0100]

    % 输入校验
    if ~isnumeric(enob)
        error('输入 "enob" 必须为数值类型。');
    end
    
    if ~isreal(enob)
        error('输入 "enob" 必须为实数（不能为复数）。');
    end
    
    if any(enob(:) < 0, 'all')
        error('输入 "enob" 必须为非负数（≥ 0）。');
    end
    
    % 主计算（自动保持 NaN/Inf 行为和输入尺寸）
    dr_dB = 6.02 * enob + 1.76;
    
    % 可选：对极大值给出警告（通常不需要，但可考虑）
    % if any(dr_dB(:) > 200, 'all')
    %     warning('计算结果超过 200 dB，可能超出实际 ADC 范围。');
    % end
end