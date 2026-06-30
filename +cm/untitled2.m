clear;clc;

Fs = 2000;                  % 采样频率
Ts = 1 / Fs;
L = 2000;                   % 取2000采样点，1s
t = (0 : L - 1) * Ts;

kf = 45;                    % 调频灵敏度
fm = 4;                     % 基带信号频率
fc = 50;                    % 载波频率
mt = cos(2 * pi * fm * t);  % 基带信号

cm.fm_mod(mt,fc,Fs,kf);
