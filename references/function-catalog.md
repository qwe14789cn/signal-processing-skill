# Function Catalog

## +sp — Core Signal Processing (141 functions)

### CFAR / Detection
- `cfar(sig,a,D,shape,option)` — 1D CFAR detector (CA/SO/GO modes)
- `cfar_alpha(pfa,N)` — Compute CFAR threshold factor from PFA and cell count
- `left_cfar(sig,shape,k,d)` — Left-side CFAR for laser echoes
- `pow2cfar(datain,pfa,guard_N,train_N)` — CFAR using MATLAB built-in method
- `delay_detect(sig,delay_N,th)` — Signal amplitude detection for non-cooperative signals
- `cfd2frac(sig,index,width)` — Constant fraction discriminator for precise echo timing
- `wp2frac(sig,index,width)` — Centroid (weighted pulse) algorithm for precise timing
- `auto_fusion(input_data,conn)` — Connected component centroid extraction (target fusion)

### FFT / Spectrum / Frequency Estimation
- `spec(sig,fs,Nfft,select)` — Spectrum analyzer (amplitude, phase, magnitude-phase)
- `matrix_ml(nfft,sig_len)` — DFT matrix for least-squares spectral analysis
- `ifm(sig,fs,window_len)` — Instantaneous frequency measurement
- `quinn_freq_est(signal,Fs)` — Quinn algorithm for precise frequency estimation
- `LinsiFFT(Dout,fclk)` — ADC performance analysis via FFT (ENOB, SINAD, SFDR, SNR)

### Filters
- `alpha_beta_filter(input,alpha)` — Alpha-beta low-pass filter
- `filter_w(sig,w)` — Multi-channel vector FIR convolution
- `kalmus_filter(order,N,N_all)` — Kalman-style filter for stationary target removal in MTD
- `polyphase_filter(h,M)` — Polyphase decimation filter decomposition
- `shaping_filter(bt,span,sps,type)` — Pulse shaping filter (raised-cosine or Gaussian)
- `lms(xn,dn,M,mu)` — LMS adaptive filter
- `lms2(xn,dn,M,mu)` — LMS adaptive filter with channel delay compensation
- `complex_filter2coe(w)` — Decompose complex FIR into 4 real-coefficient sub-filters
- `multi_channel_equ(ref_sig,channel,filter_L)` — Multi-channel equalization calibration
- `pc_factor(temple_sig,bw_range,fs,Nfft,window_fun)` — Pulse compression frequency-domain factor

### Farrow / Fractional Delay / Interpolation
- `lagrange_farrow_interpolation(Sig_in,fs_in,fs_out,order)` — Farrow resampler (batch)
- `lagrange_farrow_interpolation2(x,Sig_in,new_x,order)` — Farrow resampler (streaming/block)
- `lagrange_farrow_matrix(L)` — Generate Lagrange Farrow coefficient matrix
- `farrow_matrix_general(L,P)` — General Farrow coefficient matrix (descending power)
- `lagrange_fractional_delay_filter(L,x)` — Lagrange interpolation fractional delay FIR
- `sinc_fractional_delay_filter(L,win_handle,delay)` — Sinc-interpolation fractional delay FIR
- `calc_generic_asrc_params(fs_in,fs_out,N_base)` — Generic ASRC parameter calculation

### DOA / Array Processing / Beamforming
- `capon_doa_est(array_sig,array_pos,fc)` — Capon (MVDR) 2D DOA estimation
- `iam(sig,fc,L_long)` — Interferometric angle measurement (short/long baseline)
- `steering_vector(array_pos,sig_pos)` — Steering vector via spatial propagation model
- `l_steering_vector(d,N,fc,theta_d,window_handle)` — Linear array steering vector with windowing
- `ura_steering_vector_forward(lambda,dy,dz,Ny,Nz,fai,theta)` — URA steering vector (forward-looking)
- `ura_steering_vector_updown(lambda,dy,dz,Ny,Nz,fai,theta)` — URA steering vector (up/down-looking)
- `calc_array_delay_phase(azDeg,elDeg,elePos,fc,fs)` — Array physical delay and narrowband steering vector
- `array_pattern(array,lambda,w,sub_angle,sub_pat)` — Antenna pattern plotting (linear array)
- `l_norm_array_pattern(theta_d,N,angle_axis,window_handle)` — Quick linear array antenna pattern
- `l_steering_vector_array_pattern(w,delta,angle_axis)` — Antenna pattern from steering vector
- `parabolic_antenna_radiation_pattern(angle_axis,lambda,a,eta)` — Parabolic antenna radiation pattern
- `dbf_analyzer(angle_axis,E_dB)` — DBF performance analyzer (3dB BW, sidelobe, pointing)
- `dbf_gain(win_coe)` — DBF coherent integration SNR/signal/noise gain
- `get_S_from_Sigma_Delta(angle_axis,Sigma_weight,Delta_weight)` — Sum/difference beam S-curve
- `T_mailoux(beta,K,m,n)` — Mailloux null-widening matrix for anti-jamming
- `word(N,theta_tgt,window_N,lambda,position,theta_jam,beta)` — Orthogonal projection anti-jamming beamformer

### Waveform Generation
- `lfm_wave(T,B,fs)` — LFM (chirp) signal generation
- `exp_wave(T,fp,fs,fai)` — Complex exponential (CW) signal generation
- `zeros_wave(T,fs)` — Zero-valued signal placeholder
- `m_seq(coef)` — M-sequence (pseudo-random) generator
- `iq_data(long)` — IQ test pattern [1 0 -1 0]

### Signal Delay
- `sig_delay_frac(sig,R,fc,fs)` — Fractional delay with carrier phase rotation
- `sig_delay_int(sig,R,fc,fs)` — Integer-sample delay (rounded)
- `delaytime2point(delay,fs,fc)` — Decompose time delay into integer, fractional, and phase

### Coordinate Transform / Geometry
- `radar2xyz(az,el,range)` — Radar spherical to XYZ Cartesian
- `cartesian2polar_coordinate(theta_dy,theta_dz)` — Cartesian to polar (turntable seeker)
- `polar2cartesian_coordinate(theta,fai)` — Polar to Cartesian (turntable seeker)
- `rotate_2d(thetad)` — 2D rotation matrix
- `rotate_xd(thetad)` / `rotate_yd(thetad)` / `rotate_zd(thetad)` — Rotation about X/Y/Z axis
- `rotate_ad(vector,thetad)` — Rotation about arbitrary axis
- `ray_plane_intersection(start,Vector,plane)` — Ray-plane intersection
- `picking(O,D,triangle)` — Ray-triangle intersection (Moller-Trumbore)
- `points2plane(points)` — Least-squares plane from point cloud
- `far_field_conditions(D,lambda)` — Far-field minimum distance
- `fov2vector(angle_shape,shape)` — FOV to ray vector grid
- `pixel2vector(fov,pixel_shape,location)` — Pixel to camera ray vector
- `vector_angle_d(vec1,vec2)` — Angle between two vectors (degrees)
- `arrayd2lambda(d,fc_in)` — Array spacing to wavelength
- `find_nearest_pos(LUT,data)` — Nearest value index in lookup table

### Data Type Conversion (FPGA)
- `b2d` / `d2b` / `d2h` / `d2d` / `h2d` — Binary/hex/decimal conversion
- `h2f` / `f2b` / `f2h` / `b2f` — IEEE 754 float conversion
- `b2array(str)` — Binary string to logical array
- `frac2fi(value,signed,WL,FL)` — Fixed-point (fi) conversion
- `auto_cut(signal,mode,cut_N)` — FPGA truncation/rounding simulation
- `auto_scale(sig,AD_len,dBFS)` — Signal quantization to ADC bit-width

### ADC / Dynamic Range
- `ad_analyzer(rawsig,fs,N_bits)` — ADC performance analyzer (SFDR, SNR, ENOB)
- `enob2dr(enob)` — ENOB to dynamic range (dB)
- `dr2enob(dr_dB)` — Dynamic range to ENOB

### Power / Unit Conversion
- `dbm_convert(dbm,R)` — dBm to Vpp/Vrms/W/mW with impedance
- `dbm2w(dbm)` / `w2dbm(w)` — dBm ↔ Watts
- `vpp2dbm(Vpp,R)` — Vpp to dBm

### Radar Utilities
- `radar_eq(pt,fc,G,rcs,bw,nf,L,range)` — Radar equation SNR calculation
- `prt2axis_v(prt,fc,N)` — PRT/carrier/FFT to Doppler velocity axis
- `bpsk_doppler_est(sig,fs)` — BPSK signal Doppler estimation
- `toa_est(sig1,sig2)` — Cross-correlation delay estimation
- `get_pulse_width(sig,index,width)` — Pulse half-maximum width
- `get_area_s(sig,index,width)` — Echo waveform area integration

### Data I/O
- `read_bin(file_name,file_type,mode_bl,N)` — Generic binary file reader
- `read_complex_bin(file_name,N)` — Read int16 complex binary
- `write_bin(data_name,file_name,file_type,mode_bl)` — Generic binary writer
- `waveform2bin(sig,filename)` — AWG-compatible bin file
- `waveform2E8267D_bin(sig,filename)` — E8267D bin waveform
- `udp_Rx(port,package_size,data_type)` — UDP receiver
- `udp_Tx(dataSend,IP,IPport,BufferSize)` — UDP transmitter

### Optimization / Misc
- `nm(func,st,iter)` — Nelder-Mead simplex optimizer
- `pso(func,Particle,limit,vlim,err)` — Particle swarm optimizer
- `complex_randn(varargin)` — Complex Gaussian noise
- `gaussian(x,pos,wid)` — Gaussian pulse waveform
- `data_reshape(datain,data_size,flag)` — Column-wise reshape with trim/pad
- `cl()` — Clear workspace + command window + close figures

---

## +cm — Communications/Modulation (17 functions)

### Modulation
- `bpskMod(data,startTime,codeWidth,carrFreq,sampleRate)` — BPSK modulation
- `bfskMod(data,startTime,codeWidth,carrFreq,sampleRate,deltaFreq)` — Binary FSK modulation
- `psk8Mod(data,startTime,codeWidth,carrFreq,sampleRate)` — 8-PSK modulation
- `pi4_dqpskMod(data,startTime,codeWidth,carrFreq,sampleRate)` — π/4-DQPSK modulation (Link-11)
- `ssbMod(signal,startTime,sampleRate,modType,carrFreq)` — SSB modulation (upper/lower)
- `am_mod(sig_in,fc,fs)` — AM modulation of analog signal
- `fm_mod(sig_in,fc,fs,freqdev)` — FM modulation of analog signal
- `bpsk_diff(code)` — Differential encoding for BPSK/MSK

### Demodulation
- `bpskDemod(signal,startTime,codeWidth,carrFreq,sampleRate)` — BPSK demodulation
- `bfskDemod(signal,codeWidth,carrFreq,sampleRate,fftNum)` — 2FSK demodulation via FFT
- `psk8Demod(signal,startTime,codeWidth,carrFreq,sampleRate)` — 8-PSK demodulation
- `pi4_dqpskDemod(signal,codeWidth,estiFreq,sampleRate)` — π/4-DQPSK demodulation
- `ssbDemod(signal,startTime,sampleRate,carrFreq,demodType)` — SSB demodulation
- `fmDemod(signal,startTime,sampleRate,freqDev,carrFreq)` — FM demodulation

### Channel Models
- `rayleigh_channel_jakes(T,fd,fs,E0)` — Rayleigh fading channel (Jakes model)
- `rician_channel_jakes(T,fd,fs,K,phi_los,E0)` — Rician fading channel (Jakes model)

---

## +geo — Geodesy / Localization (8 functions)

### Coordinate Conversion
- `ecef2lla(ECEF_XYZ)` — ECEF → LLA (lat, lon, alt)
- `lla2ecef(lla)` — LLA → ECEF
- `polar2xyz(az,el,range)` — Polar → Cartesian XYZ
- `geo2aer(lat_A,lon_A,alt_A,lat_B,lon_B,alt_B)` — Geodetic → azimuth/elevation/slant-range

### Localization
- `tdoa_localization_chan(ecef_xyz,time_arrive)` — TDOA via Chan algorithm (ECEF)
- `tdoa_localization_ds(ecef_xyz,time_arrive)` — TDOA via double-sphere method (ECEF)
- `least_squares_triangulation(radar_pos,angles_deg)` — 2D multi-station triangulation
- `least_squares_triangulation_3d(radar_pos,az,el)` — 3D multi-station triangulation

---

## +jm — Jamming / ECM (20 functions)

### NLFM Waveforms
- `nlfm_sine_wave(T,Am,fm,fs)` — Sine-modulated NLFM
- `nlfm_saw_wave(T,T_cycle,B,fs)` — Sawtooth NLFM
- `nlfm_triang_wave(T_u,T_d,B,fs)` — Triangle sweep NLFM
- `nlfm_step_wave(T,B,N,fs)` — Stepped frequency sweep
- `nlfm_square_law_wave(T,B,fs)` — Square-law NLFM
- `nlfm_cube_law_wave(T,B,fs)` — Cubic-law NLFM
- `nlfm_wave(T,bw,fs,window)` — NLFM pulse compression template with windowing

### Jamming Signals
- `lfm_jamming(T,B,fs)` — LFM jamming
- `cosine_jamming(T,A,B,fm,fs)` — Cosine phase-modulated repeater jamming
- `sar_cosine_jamming(T,A,B,fm,fs)` — SAR cosine jamming
- `comb_jamming(T,delta_f,N,fs)` — Comb-spectrum (multi-tone) jamming
- `aimed_jamming(N,k)` — Narrowband noise jamming
- `blocking_jamming(N)` — Wideband noise jamming
- `smart_noise(sig,N)` — Smart noise (convolve echo with noise)
- `intermittent_sampling(sig,N_sample)` — Intermittent sampling repeater jamming

### Advanced Jamming
- `doppler_flicker(T,T_cycle,rate,fd1,fd2,fs)` — Doppler flicker jamming
- `doppler_noise(T,fd,delta,fs)` — Doppler noise jamming
- `radar_target_jamming(sig,fc,PRT,N_prt,RV_target,fs)` — False target generation
- `range_velocity_gate_pull_off(sig,fc,PRT,N_prt,R_range,V_range,fs)` — Range-velocity gate pull-off
- `towed_decoy_jamming(sig,array_N,range,PRT,V,R_tow,k,fc,fs)` — Towed decoy angular jamming

---

## +wu — Window Functions (50+ functions)

Commonly used: `kaiserwin`, `taylwin`, `tukey`, `blackman`, `hamming`, `hanning`, `chebwin`, `nutwin`, `flatwin`. Call as `wu.kaiserwin(N, beta)`.

---

## +sl — Visualization
- `radarChart` — Radar/spider chart class (by slandarer)

## +tm — Date/Time
- `Tomohiko_Sakamoto(y,m,d)` — Day-of-week from date
