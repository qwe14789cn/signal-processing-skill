%--------------------------------------------------------------------------
%   [azimuth_deg,elevation_deg] = geo2aer(lat_A,lon_A,alt_A,lat_B,lon_B,alt_B)
%--------------------------------------------------------------------------
%   功能：
%   从经纬高计算后者观测前者的方位角和俯仰角
%   matlab官方函数
%   geodetic2aer(lat_A,lon_A,alt_A,lat_B,lon_B,alt_B,wgs84Ellipsoid)
%--------------------------------------------------------------------------
%   输入:
%           lat_A           A点纬度
%           lon_A           A点经度
%           alt_A           A点高度
%           lat_B           B点纬度
%           lon_B           B点经度
%           alt_B           B点高度
%   输出:
%           azimuth_deg     B点观测A点的方位角
%           elevation_deg   B点观测A点的俯仰角
%			slantRange		斜距
%--------------------------------------------------------------------------
%   例子:
%   [a,e,r] = geo2aer(32,110,0,33,110,0)
%   [a,e,r] = geodetic2aer(32,110,0,33,110,0,wgs84Ellipsoid);
%--------------------------------------------------------------------------
function [azimuth_deg,elevation_deg,slantRange] = geo2aer(lat_A,lon_A,alt_A,lat_B,lon_B,alt_B)
% 将经纬高坐标转换为ECEF坐标
[x_A, y_A, z_A] = lla2ecef(lat_A, lon_A, alt_A);
[x_B, y_B, z_B] = lla2ecef(lat_B, lon_B, alt_B);
% 计算ECEF坐标差
dx = x_A - x_B;
dy = y_A - y_B;
dz = z_A - z_B;
slantRange = norm([dx dy dz]);
% 计算转换矩阵
sinLat = sind(lat_B);
cosLat = cosd(lat_B);
sinLon = sind(lon_B);
cosLon = cosd(lon_B);
T = [ -sinLon, cosLon, 0;
       -sinLat * cosLon, -sinLat * sinLon, cosLat;
       cosLat * cosLon, cosLat * sinLon, sinLat];

% 计算ENU坐标
ENU = T * [dx; dy; dz];
% 计算方位角和俯仰角
azimuth_deg = atan2d(ENU(1), ENU(2));
elevation_deg = atan2d(ENU(3), sqrt(ENU(1)^2 + ENU(2)^2));
% 确保方位角在0到360度之间
if azimuth_deg < 0
    azimuth_deg = azimuth_deg + 360;
end

end

%   纬经高转ECEF坐标系
function [x, y, z] = lla2ecef(lat, lon, alt)
WGS84_A = 6378137.0;
WGS84_f = 1/298.257223565;
WGS84_E2 = WGS84_f * (2 - WGS84_f);
N = WGS84_A / sqrt(1 - WGS84_E2 * sind(lat) * sind(lat));
x = (N + alt) * cosd(lat) * cosd(lon);
y = (N + alt) * cosd(lat) * sind(lon);
z = (N * (1 - WGS84_f) * (1 - WGS84_f) + alt) * sind(lat);
end
