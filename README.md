# Signal Processing Skill

MATLAB 信号处理工具箱，专为雷达、通信、电子战、大地测量仿真设计。**为 AI Agent 打造** — 拿到即可用。

## 包含模块

| 包名 | 领域 | 说明 |
|------|------|------|
| `+sp` | 信号处理核心 | CFAR检测、FFT/频谱、DOA估计、波束形成、波形生成、滤波器、Farrow插值、坐标变换、FPGA工具、数据I/O |
| `+cm` | 通信调制解调 | BPSK/BFSK/8PSK/π4-DQPSK/AM/FM/SSB 调制解调，Rayleigh/Rician Jakes 信道模型 |
| `+jm` | 干扰/电子战 | LFM/NLFM干扰、噪声干扰、灵巧噪声、间歇采样、多普勒闪烁、拖曳诱饵、距离速度波门拖引 |
| `+geo` | 大地测量/定位 | ECEF↔LLA坐标转换、TDOA定位（Chan/DS法）、最小二乘三角定位 |
| `+wu` | 窗函数 | 50+ 种窗函数（第三方库，有独立 license） |
| `+sl` | 可视化 | 雷达图/蜘蛛图 |
| `+tm` | 日期工具 | 星期计算 |

## 快速开始

### 1. 安装到 OpenCode

把本文件夹复制到 OpenCode skills 目录：

```powershell
Copy-Item -Recurse -Force "本文件夹路径\signal-processing-skill" "C:\Users\<用户名>\.agents\skills\signal-processing-skill"
```

### 2. MATLAB 添加路径

在 MATLAB 脚本开头加一行：

```matlab
addpath('C:\Users\<用户名>\.agents\skills\signal-processing-skill');
```

永久生效可加到 `startup.m`。

### 3. 调用函数

```matlab
% 生成 LFM 信号
sig = sp.lfm_wave(10e-6, 20e6, 100e6);

% BPSK 调制
data = randi([0 1], 1000, 1);
signal = cm.bpskMod(data, 0, 1e-6, 10e6, 100e6);

% CFAR 检测
[detected, th] = sp.cfar(abs(sig).^2, 0.5, 0, [8 3 1 3 8], 'ca');

% TDOA 定位
[pos, ~] = geo.tdoa_localization_chan(ecef, toa);
lla = geo.ecef2lla(pos);
```

## 示例：复信号生成与可视化

```matlab
addpath('C:\Users\<用户名>\.agents\skills\signal-processing-skill');

fs = 100e6; T = 10e-6; B = 20e6; fc = 10e6;
sig_lfm = sp.lfm_wave(T, B, fs);        % LFM信号
sig_cw  = sp.exp_wave(T, fc, fs, 0);    % CW复指数
sig_noise = sp.complex_randn(round(T*fs), 1);  % 复高斯噪声

figure;
subplot(2,2,1); plot(real(sig_lfm)); title('LFM 实部');
subplot(2,2,2); plot(abs(fftshift(fft(sig_lfm)))); title('LFM 频谱');
subplot(2,2,3); plot(real(sig_cw), imag(sig_cw), '.'); title('CW 星座图');
subplot(2,2,4); sp.p3(sig_lfm + 0.3*sig_noise); title('含噪信号 3D轨迹');
```

输出效果：

![复信号可视化](复信号生成与可视化.png)

## 函数总览

完整函数目录见 [references/function-catalog.md](references/function-catalog.md)，按域分类，包含函数签名和用途说明。

## 编程规范

脚本结构、注释风格、绘图模式、验证方法等见 [references/coding-conventions.md](references/coding-conventions.md)。

## 项目结构

```
signal-processing-skill/
├── SKILL.md                  AI Agent 使用指南
├── references/
│   ├── function-catalog.md   完整函数目录
│   └── coding-conventions.md 编程规范
├── +sp/                      信号处理核心 (133 个函数)
├── +cm/                      通信调制解调 (17 个函数)
├── +jm/                      干扰/电子战 (20 个函数)
├── +geo/                     大地测量/定位 (8 个函数)
├── +wu/                      窗函数 (52 个函数)
├── +sl/                      可视化 (1 个函数)
└── +tm/                      日期工具 (1 个函数)
```

## 许可证

- `+sp`, `+cm`, `+jm`, `+geo`, `+sl`, `+tm` — 个人工具箱，仅供学习参考
- `+wu` — 第三方窗函数库，见 [+wu/license.txt](+wu/license.txt)
