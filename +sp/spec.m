%--------------------------------------------------------------------------
%   spec(sig,fs,Nfft,select)
%--------------------------------------------------------------------------
%   功能：
%   信号频谱分析工具，用于分析信号的幅频响应，相频响应，幅相响应
%--------------------------------------------------------------------------
%   输入：
%           sig             原始信号
%           fs              采样速率
%           Nfft            fft点数
%           select          选择点输出相位值       
%--------------------------------------------------------------------------
%   例子：
%   spec(sig)
%   spec(sig,fs)                    不指定fft点数
%   spec(sig,fs,nfft)               指定fft点数
%   spec(sig,fs,[],select)          输出指定点数相位值
%   spec(sig,fs,nfft,select)        输出指定点数相位值
%--------------------------------------------------------------------------
function spec(sig,fs,Nfft,select)
sig = double(sig);

if nargin == 1
    fs = 1;                                                                 %归一化频率
    Nfft = 2^nextpow2(length(sig));
elseif nargin == 2
    Nfft = 2^nextpow2(length(sig));
end
if isempty(Nfft)
    Nfft = 2^nextpow2(length(sig));
end

%   单位转换
[value,~,unit] = signalwavelet.internal.convenienceplot.getFrequencyEngUnits(fs);
disp('--------------------')
if isreal(sig)
    disp('实信号:')
else
    disp('复信号:')
end

disp([' length -> ' num2str(numel(sig))])
disp([' NFFT   -> ' num2str(Nfft)]);
disp('--------------------')

%--------------------------------------------------------------------------
%   如果是实信号
%--------------------------------------------------------------------------
if isreal(sig)
    f = value/Nfft*(0:Nfft/2);
    A = fft(sig,Nfft)./numel(sig);
    A = A(1:Nfft/2+1);
    A(2:end-1) = A(2:end-1).*sqrt(2);                                               %单边谱 功率x2
    %----------------------------------------------------------------------
    subplot(3,3,[1 2]);plot(f,mag2db(abs(A)));xlim([0 value/2]);grid on
    if nargin == 1
        xlabel('归一化频率');ylabel('幅度 dB');title('实信号幅频响应')
    else
        xlabel(['频率' unit]);ylabel('幅度 dB');
        title(['采样速率' num2str(value) ' ' unit '实信号幅频响应'])
    end
    %----------------------------------------------------------------------
    subplot(3,3,[4 5]);plot(f,rad2deg(angle(A)));xlim([0 value/2]);grid on
    if nargin == 1
        xlabel('归一化频率');ylabel('幅度 dB');title('实信号相频响应')
    else
        xlabel(['频率' unit]);ylabel('幅度 dB');
        title(['采样速率' num2str(value) ' ' unit '实信号相频响应'])
    end
    %----------------------------------------------------------------------
    subplot(3,3,[3 6]);
    plot3(1:length(A),real(A),imag(A));grid on
    xlabel('点数');ylabel('实部');zlabel('虚部')
    axis([0 length(A) -max(abs(A(:))) max(abs(A(:))) -max(abs(A(:))) max(abs(A(:)))])
    %----------------------------------------------------------------------
    if nargin <=3                                                           %如果不输入 自动寻找最大值
        [~,select] = max(abs(A));
        ang = rad2deg(angle(A(select)));
        title(['频率:' num2str(f(select)) unit ' 点数:' num2str(select) ' 相位为 ' num2str(ang) ' °']);
    end
    if nargin == 4                                                          %如果不输入 自动寻找最大值
        ang = rad2deg(angle(A(select)));
        title(['点 ' num2str(select) ' 相位为 ' num2str(ang) ' °']);
    end

%--------------------------------------------------------------------------
%   如果是复信号
%--------------------------------------------------------------------------
else                                                                        %复信号分析，单边功率谱
    f = value/Nfft*(0:Nfft-1)-value/2;
    A = fftshift(fft(sig,Nfft)./numel(sig));
    %----------------------------------------------------------------------
    subplot(3,3,[1 2]);plot(f,mag2db(abs(A)));xlim([-value/2 value/2]);grid on

    if nargin == 1
        xlabel('归一化频率');ylabel('幅度 dB');title('复信号幅频响应')
    else
        xlabel(['频率' unit]);ylabel('幅度 dB');
        title(['采样速率' num2str(value) ' ' unit '复信号幅频响应'])
    end
    %----------------------------------------------------------------------
    subplot(3,3,[4 5]);plot(f,rad2deg(angle(A)));
    if nargin == 1
        xlabel('归一化频率');ylabel('幅度 dB');grid on
        title('实信号相频响应')
    else
        xlabel(['频率' unit]);ylabel('相位 °');ylim([-190 190]);grid on
        title(['采样速率' num2str(value) ' ' unit '复信号相频响应'])
    end
    subplot(3,3,[3 6]);
    plot3(1:length(A),real(A),imag(A));grid on
    xlabel('点数');ylabel('实部');zlabel('虚部');
    axis([0 length(A) -max(abs(A(:))) max(abs(A(:))) -max(abs(A(:))) max(abs(A(:)))])
    %----------------------------------------------------------------------
    if nargin <=3                                                           %如果不输入 自动寻找最大值
        [~,select] = max(abs(A));
        ang = rad2deg(angle(A(select)));
        title(['频率:' num2str(f(select)) unit ' 点数:' num2str(select) ' 相位为 ' num2str(ang) ' °']);
    end

    if nargin == 4
        ang = rad2deg(angle(A(select)));
        title(['点 ' num2str(select) ' 相位为 ' num2str(ang) ' °']);
    end
end

if nargin <= 1
    for idx = 1:size(sig,2)
        subplot(337);pspectrum(sig(:,idx));hold on
    end
        subplot(338);pspectrum(sig(:,1),'spectrogram');
        subplot(339);pspectrum(sig(:,1),'persistence');
else
    for idx = 1:size(sig,2)
        subplot(337);pspectrum(sig(:,1),fs)
    end
    subplot(338);pspectrum(sig(:,1),fs,'spectrogram');
    subplot(339);pspectrum(sig(:,1),fs,'persistence');
end

set(gcf,'outerposition',get(0,'screensize'));
end