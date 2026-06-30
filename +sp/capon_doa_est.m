function capon_doa_est(array_sig,array_pos,fc)
%--------------------------------------------------------------------------
%   矢量来向+相位角度
%--------------------------------------------------------------------------
phi_theta_Deg2vector = @(phiDeg,thetaDeg)([sind(thetaDeg)*cosd(phiDeg),sind(thetaDeg)*sind(phiDeg),cosd(thetaDeg)]');
ArraySigPhase = @(elePos,ePos,fc)(exp(-1j.*2*pi*(fc./3e8)*(elePos*ePos)).');

%--------------------------------------------------------------------------
Rxx=array_sig'*array_sig;                                                   %构造协方差矩阵
Rxx_inv = Rxx^-1;                                                           %求逆

%   角度扫描范围
phi_deg_axis = -90:0.1:90;
theta_deg_aixs = 0:0.1:90;

for phi_step = 1:length(phi_deg_axis)
    for theta_step = 1:length(theta_deg_aixs)
        checkVector = phi_theta_Deg2vector(phi_deg_axis(phi_step),theta_deg_aixs(theta_step));%信号来向矢量
        a = ArraySigPhase(array_pos,checkVector,fc)';                       %导向矢量计算
        SP_capon(phi_step,theta_step) = 1 ./ (a'*Rxx_inv*a);
    end
end

%   绘制功率谱
SP_capon_abs=abs(SP_capon);
SPA_capon_dB=mag2db(SP_capon_abs/max(SP_capon_abs(:)));
[x_index,y_index] = find(SPA_capon_dB == max(SPA_capon_dB(:)));

if nargout == 0
    subplot(121)
    plot3(array_pos(:,1),array_pos(:,2),array_pos(:,3),'o');grid on
    title('阵列布局');
    xlabel('X');ylabel('Y');zlabel('Z')
    subplot(122)
    mesh(theta_deg_aixs,phi_deg_axis,SPA_capon_dB);
    xlabel('X:theta');ylabel('X:phi')
    title(['最大值: phiDeg = ' num2str(phi_deg_axis(x_index)) '° thetaDeg = ' num2str(theta_deg_aixs(y_index)) '°'])
end
end