# Signal Processing Toolbox Skill

MATLAB信号处理工具箱，用于雷达、通信、电子战和大地测量仿真。

## 包含模块

| 前缀 | 功能 |
|------|------|
| `sp.` | 核心信号处理 — 滤波器、FFT、CFAR、DOA、波形、I/O、坐标变换、FPGA工具 |
| `cm.` | 通信调制解调和信道模型 |
| `jm.` | 干扰/ECM信号生成 |
| `geo.` | 大地坐标变换和TDOA定位 |
| `wu.` | 窗函数（50+种） |
| `sl.` | 可视化（雷达图） |
| `tm.` | 日期时间工具 |

## 安装

1. 克隆本仓库到 `.agents/skills/` 目录：
```bash
git clone https://github.com/qwe14789cn/signal-processing-skill.git ~/.agents/skills/signal-processing-skill
```

2. 在MATLAB脚本开头添加路径：
```matlab
addpath(fullfile(getenv('USERPROFILE'), '.agents', 'skills', 'signal-processing-skill'));
```

## 使用规则

**每个脚本必须以 `addpath` 开头**

**调用函数必须带包前缀：**
```matlab
sig = sp.lfm_wave(10e-6, 20e6, 100e6);    % ✓ 正确
sig = lfm_wave(10e-6, 20e6, 100e6);       % ✗ 错误
```

## 示例

### 雷达波形生成
```matlab
addpath(fullfile(getenv('USERPROFILE'), '.agents', 'skills', 'signal-processing-skill'));
fs = 100e6; fc = 10e9;
sig = sp.lfm_wave(10e-6, 20e6, fs);
figure; sp.p3(sig);
```

### CFAR检测
```matlab
addpath(fullfile(getenv('USERPROFILE'), '.agents', 'skills', 'signal-processing-skill'));
[detected, th] = sp.cfar(abs(sig).^2, 0.5, 0, [8 3 1 3 8], 'ca');
```

### UDP接收（支持大小端）
```matlab
addpath(fullfile(getenv('USERPROFILE'), '.agents', 'skills', 'signal-processing-skill'));
rx = sp.udp_Rx(9000, [8192, 1], 'int16', 'b');  % 大端接收
```

### 通信仿真
```matlab
addpath(fullfile(getenv('USERPROFILE'), '.agents', 'skills', 'signal-processing-skill'));
data = randi([0 1], 1000, 1);
sig = cm.bpskMod(data, 0, 1e-6, 10e6, 100e6);
```

### 干扰场景
```matlab
addpath(fullfile(getenv('USERPROFILE'), '.agents', 'skills', 'signal-processing-skill'));
target = sp.lfm_wave(10e-6, 20e6, 100e6);
jam = jm.smart_noise(target, length(target));
```

## 关键约定

- 函数返回列向量（N×1），输入用 `sig(:)` 标准化
- CFAR输入为功率谱：`abs(sig).^2`
- 单位：Hz、秒、度（非弧度）
- 不指定输出变量时自动画图

## 目录结构

```
signal-processing-skill/
├── SKILL.md           ← AI skill描述文件
├── +sp/               ← 核心信号处理包
├── +cm/               ← 通信包
├── +jm/               ← 干扰包
├── +geo/              ← 坐标变换包
├── +wu/               ← 窗函数包
├── +sl/               ← 可视化包
├── +tm/               ← 时间工具包
└── references/        ← 函数目录和编码规范
```

## License

MIT
