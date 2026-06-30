# Coding Conventions & Simulation Patterns

## Script Structure Template

Every simulation script follows this flow:

```matlab
%--------------------------------------------------------------------------
%   标题 / 算法名称
%   author@email
%   YYYYMMDD
%--------------------------------------------------------------------------
clear;clc;

%--------------------------------------------------------------------------
%   参数设置
%--------------------------------------------------------------------------
fc = 10e9;                      %射频
fs = 100e6;                     %采样率
c = 3e8;                        %光速
lambda = c/fc;                  %波长
M = 64;                         %阵元数量

%--------------------------------------------------------------------------
%   信号生成 / 数据读取
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%   核心算法 / 处理
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%   可视化
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
%   数据保存
%--------------------------------------------------------------------------
save P01_output.mat var1 var2
```

## Section Separator

Universal: `%--------------------------------------------------------------------------` (74 dashes). Sub-sections: `%----------------------------------------------------------------------` (70 dashes).

## Comment Style

- **Chinese inline** for parameters: `fc = 10e9; %射频`
- **Chinese section headers**: `参数设置`, `信号生成`, `可视化`, `数据保存`
- **Chinese function docs**: `功能：`, `输入:`, `输出:`, `例子:`
- **ASCII art** for structural diagrams (CFAR windows, array layouts)
- Match Chinese when editing existing files

## Parameter Conventions

- Physical constants at top: `c = 3e8;` or `c = 299792458;`
- All frequencies/times in scientific notation: `10e9`, `100e6`, `1e-6`
- `_d` suffix = degrees: `angle_d`, `beam_angle_d`
- `_r`/`_i` suffix = real/imaginary parts
- Aligned inline comments within parameter groups

## Signal Conventions

- Column vectors preferred. Normalize with `sig = sig(:);` at function entry.
- Complex signals: `1j` for imaginary unit
- Power signals for CFAR: `abs(sig).^2`

## Plot Patterns

```matlab
figure(1)
subplot(321)                    % compact form, NOT subplot(3,2,1)
plot(real(sig)); grid on;
xlabel('点数'); ylabel('实部');

% 3D IQ visualization (custom toolbox function)
sp.p3(sig)                      % I/Q/time trajectory
sp.p3(sig,'o-')                 % with marker

% dB conversion
mag2db(abs(x))                  % amplitude → dB
pow2db(abs(x).^2)              % power → dB

% Spectrogram
spectrogram(sig,128,127,128,fs,'yaxis')

% BER/SER curves
semilogy(snr,ser,'o-'); grid on
xlabel('Eb/N0 (dB)'); ylabel('SER')
```

## Multi-Script Pipeline

Complex simulations split into numbered scripts with `.mat` handoff:

```
P01_waveform.m   →  save P01_waveform.mat sig fs bw
P02_radar_sim.m  →  load P01_waveform.mat → process → save P02_result.mat
P03_detection.m  →  load P02_result.mat → detect → plot
```

## Progress Reporting

```matlab
disp('初始化...')
fprintf('按照采样率 %d MHz 生成的连续信号\n', fs/1e6)
disp(['仿真角度 -> ' num2str(angle_d(idx)) '°'])
disp(['脉冲发射 -> ' num2str(m) '/1024 当前进度 -> ' num2str(round(m/N*100,2)) ' %'])
```

## Result Verification

```matlab
% Visual comparison
subplot(211); sp.p3(sig_out1); hold on; sp.p3(sig_out2); hold off

% Error/residual plot
plot(abs(sig_out1 - sig_out2).^2); grid on

% Expected vs actual overlay
plot(t,yn,'b',t,dn,'g--',t,dn-yn,'r'); grid on
legend('自适应滤波器输出','预期输出','误差')

% Constraint check
if fix(down_n) ~= down_n
    disp('原始信号与采样速率不为整数倍关系,程序中断')
    return
end
```

## Toolbox vs MATLAB Built-in

- Use `sp.lfm_wave()` instead of manual chirp generation
- Use `sp.cfar()` instead of writing CFAR from scratch
- Use `sp.p3()` for IQ visualization instead of manual `plot3`
- Use `sp.sig_delay_frac()` for target delay instead of manual interpolation
- Use `sp.complex_randn()` for complex noise instead of `randn + 1j*randn`
- Use MATLAB `phased.*` toolbox for FMCW, platform, target modeling
- Use `awgn()` for adding noise, `mag2db()`/`pow2db()` for dB conversion

## Variable Naming

- `camelCase` or `snake_case` — match existing file style
- `idx` for loop index (universal)
- `Nsweep`, `Upsample` — capitalized for emphasis on important counts
- Avoid single-letter variables except `i`, `j`, `N`, `M`, `K`

## Performance

- `parfor` for heavy simulation loops (parallel computing)
- `tic` / `toc` for timing
- `warning off` to suppress non-critical warnings
