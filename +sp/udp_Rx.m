%--------------------------------------------------------------------------
%   Received = udp_Rx(port,package_size,data_type,byte_order)
%--------------------------------------------------------------------------
%   功能：
%   udp数据接收函数，支持大小端字节序
%--------------------------------------------------------------------------
%   输入：
%           port                端口号
%           package_size        数据包大小格式
%           data_type           数据形式
%           byte_order          字节序: 'b'=大端, 'l'=小端(默认)
%--------------------------------------------------------------------------
%   例子：
%   R = udp_Rx(1234,[10,5],'uint8')
%   R = udp_Rx(1234,[10,1],'int16','b')
%--------------------------------------------------------------------------
function Received = udp_Rx(port, package_size, data_type, byte_order)
if nargin < 4
    byte_order = 'l';
end

udpRx = dsp.UDPReceiver('MessageDataType', data_type);
udpRx.LocalIPPort = port;
udpRx.ReceiveBufferSize = 65536;
udpRx.MaximumMessageLength = package_size(1);
TOTAL = package_size(2);
Received = zeros(package_size(1), package_size(2));
eval(['Received = ' data_type '(Received);']);
while TOTAL
    Rx = udpRx();
    if ~isempty(Rx)
        Received(:, package_size(2)-TOTAL+1) = Rx;
        TOTAL = TOTAL - 1;
    end
end
release(udpRx);

% 大端字节交换
if strcmp(byte_order, 'b')
    raw_uint8 = typecast(Received(:), 'uint8');
    raw_uint8 = reshape(raw_uint8, 2, []);
    raw_uint8 = flipud(raw_uint8);
    Received = reshape(typecast(raw_uint8(:)', data_type), size(Received));
end
end
