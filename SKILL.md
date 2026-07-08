---
name: signal-processing-skill
description: MATLAB signal processing toolbox for radar, communications, electronic warfare, and geodesy simulation. Use when the user asks to: (1) generate radar waveforms (LFM, NLFM, CW, M-sequence), (2) perform CFAR detection or target detection simulation, (3) do DOA estimation, beamforming, or array processing, (4) modulate/demodulate signals (BPSK, FSK, PSK, AM, FM, SSB), (5) simulate jamming/ECM scenarios, (6) perform coordinate transforms (ECEF/LLA/polar), (7) do TDOA localization, (8) generate channel models (Rayleigh/Rician Jakes), (9) read/write binary waveform data, (10) analyze ADC performance, or any MATLAB signal processing simulation task. Toolbox contains +sp, +cm, +jm, +geo, +wu, +sl, +tm packages.
---

# Signal Processing Toolbox Skill

## Installation (agent must do this first)

When the user provides this skill at any path, agent must copy it to its own skills directory before use.

**Step 1 — Find skill source.** The skill root is the directory containing `+sp/` and this SKILL.md. Search:

```matlab
% 当前目录就是 skill 根
if exist('+sp', 'dir')
    src_path = pwd;
end
```

If not found, ask the user: "signal-processing-skill 文件夹在哪个路径？"

**Step 2 — Copy to agent skills directory.**

PowerShell:
```powershell
Copy-Item -Recurse -Force "<用户给的路径>\signal-processing-skill" "C:\Users\<username>\.agents\skills\signal-processing-skill"
```

Bash:
```bash
cp -r "<用户给的路径>/signal-processing-skill" ~/.agents/skills/signal-processing-skill
```

**Step 3 — Add to MATLAB path.**

```matlab
addpath(fullfile(getenv('USERPROFILE'), '.agents', 'skills', 'signal-processing-skill'));
```

After this, `+sp`, `+cm`, etc. are available as packages.

## How it works

```
signal-processing-skill/        ← agent 复制整个目录到 skills 下
├── SKILL.md
├── references/
├── +sp/                        ← MATLAB 识别为 package "sp"
├── +cm/                        ← package "cm"
├── +jm/                        ← package "jm"
├── +geo/                       ← package "geo"
├── +wu/                        ← package "wu"
├── +sl/                        ← package "sl"
└── +tm/                        ← package "tm"
```

`addpath` 指向 skill 根目录，MATLAB 自动找到所有 `+` 包。

## Package prefix rule

| Prefix | Domain |
|--------|--------|
| `sp.` | Core signal processing — filters, FFT, CFAR, DOA, waveforms, I/O, coordinate transforms, FPGA utilities |
| `cm.` | Communications modulation/demodulation and channel models |
| `jm.` | Jamming / ECM signal generation |
| `geo.` | Geodetic coordinate transforms and TDOA localization |
| `wu.` | Window functions (third-party, 50+ types) |
| `sl.` | Visualization (radar chart) |
| `tm.` | Date/time utilities |

## ⚠️ Mandatory rules for AI-generated MATLAB scripts

**Rule 1: Every script MUST start with addpath**
```matlab
addpath(fullfile(getenv('USERPROFILE'), '.agents', 'skills', 'signal-processing-skill'));
```
Without this, `sp.xxx`, `jm.xxx` etc. will fail with "Undefined function" errors.

**Rule 2: Use package prefix to call functions**
- `sp.fft2(x)` not `fft2(x)`
- `jm.smart_noise(sig, len)` not `smart_noise(sig, len)`
- `cm.bpskMod(data, ...)` not `bpskMod(data, ...)`
- `geo.ecef2lla(pos)` not `ecef2lla(pos)`

Each function belongs to its package. Always prefix with `sp.`, `cm.`, `jm.`, `geo.`, `wu.`, `sl.`, or `tm.`

## Simulation workflow

```matlab
addpath(fullfile(getenv('USERPROFILE'), '.agents', 'skills', 'signal-processing-skill'));

% 1. Parameters
fs = 100e6; T = 10e-6; B = 20e6; fc = 10e9;

% 2. Generate waveform
sig = sp.lfm_wave(T, B, fs);

% 3. Add targets / delay
[sig_delay, ~] = sp.sig_delay_frac(sig, 1000, fc, fs);

% 4. Add noise
noise = sp.complex_randn(size(sig_delay)) * 0.1;
rx = sig_delay + noise;

% 5. Pulse compression
[pc_sig, ~] = sp.pc_factor(sig, B, fs, length(rx), @blackman);

% 6. Detection
[detected, th] = sp.cfar(abs(pc_sig).^2, 0.5, 0, [8 3 1 3 8], 'ca');

% 7. Plot
figure; plot(abs(pc_sig)); hold on; plot(th, 'r');
```

## Key conventions

- **Column vectors**: Functions return N×1. Use `sig(:)` to normalize input.
- **CFAR input = power**: Pass `abs(sig).^2`, not amplitude.
- **Units**: Hz, seconds, degrees (not radians). Geodetic uses `sind`/`cosd`.
- **Auto-plot**: Functions plot when `nargout == 0`. Assign outputs to suppress.
- **Chinese comments**: Docstrings in 中文. Match the language when editing.

## Common simulation recipes

### Radar range-Doppler map
```matlab
addpath(fullfile(getenv('USERPROFILE'), '.agents', 'skills', 'signal-processing-skill'));
fs = 100e6; fc = 10e9; PRT = 100e-6; N_prt = 64;
sig = sp.lfm_wave(10e-6, 20e6, fs);
% Build CPI matrix, then 2D FFT for range-Doppler
```

### TDOA localization
```matlab
addpath(fullfile(getenv('USERPROFILE'), '.agents', 'skills', 'signal-processing-skill'));
ecef = [4510731; 4510731; 0; ...];   % station ECEF positions
toa = [1.2e-3; 1.5e-3; ...];        % arrival times
[pos, ~] = geo.tdoa_localization_chan(ecef, toa);
lla = geo.ecef2lla(pos);
```

### Communications link
```matlab
addpath(fullfile(getenv('USERPROFILE'), '.agents', 'skills', 'signal-processing-skill'));
data = randi([0 1], 1000, 1);
sig = cm.bpskMod(data, 0, 1e-6, 10e6, 100e6);
[ch, ~] = cm.rayleigh_channel_jakes(1, 100, 100e6, 1);
rx = conv(sig, ch);
```

### Jamming scenario
```matlab
addpath(fullfile(getenv('USERPROFILE'), '.agents', 'skills', 'signal-processing-skill'));
target = sp.lfm_wave(10e-6, 20e6, 100e6);
jam = jm.smart_noise(target, length(target));
rx = target + jam;
```

## Window functions

- `wu.kaiserwin(N, beta)` — Kaiser
- `wu.taylwin(N, nbar)` — Taylor
- `wu.tukey(N, alpha)` — Tukey

Pass window handle: `sp.sinc_fractional_delay_filter(L, @wu.kaiserwin, delay)`

## References

- [references/function-catalog.md](references/function-catalog.md) — full function catalog
- [references/coding-conventions.md](references/coding-conventions.md) — script structure, comment style, plot patterns
