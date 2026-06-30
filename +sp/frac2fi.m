%--------------------------------------------------------------------------
%   [number_type] = frac2fi(value, signed, word_length, fraction_length)
%--------------------------------------------------------------------------
%   功能:
%   matlab的fi函数
%--------------------------------------------------------------------------
%   输入:
%           value                   输入值
%           signed                  1表示有符号，0表示无符号
%           word_length             总字长
%           fraction_length         小数部分位数
%
%   输出:
%           custom_fi                     转换后的二进制数
%--------------------------------------------------------------------------
 function custom_fi = frac2fi(value, signed, word_length, fraction_length)
if nargin < 3
    error('需要4个输入参数: value, signed, word_length, fraction_length');
elseif nargin == 3
    fraction_length = 0;
end

% 计算整数部分位数
integer_length = word_length - fraction_length;

% 确定取值范围
if signed
    max_val = 2^(word_length-1) - 1;
    min_val = -2^(word_length-1);
else
    max_val = 2^word_length - 1;
    min_val = 0;
end

% 计算缩放因子
scaling_factor = 2^fraction_length;

% 量化值
quantized_value = round(value * scaling_factor);

% 检查是否溢出
if sum(quantized_value > max_val)
    warning('值超出最大值限制，将被截断');
    quantized_value(quantized_value > max_val) = max_val;
end
if sum(quantized_value < min_val)
    warning('值超出最小值限制，将被截断');
    quantized_value(quantized_value < min_val) = min_val;
end

% 计算实际表示的固定点值
fixed_value = quantized_value / scaling_factor;

% 转换为二进制字符串
if signed
    % 有符号数处理
    if quantized_value < 0
        binary_str = dec2bin(2^word_length + quantized_value, word_length);
    else
        binary_str = dec2bin(quantized_value, word_length);
    end
else
    % 无符号数处理
    binary_str = dec2bin(quantized_value, word_length);
end

% 转换为十六进制字符串
hex_str = dec2hex(quantized_value, ceil(word_length/4));

% 创建输出结构体
custom_fi = struct(...
    'Value', fixed_value, ...
    'int', quantized_value, ...
    'bin', binary_str, ...
    'hex', hex_str, ...
    'Signed', logical(signed), ...
    'WordLength', word_length, ...
    'FractionLength', fraction_length ...
);
end
