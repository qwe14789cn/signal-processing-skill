%--------------------------------------------------------------------------
%   complex2vector(points,model)
%--------------------------------------------------------------------------
%   功能：
%   复数矢量可视化工具
%--------------------------------------------------------------------------
%   输入：
%           points          复数，按照行放置
%           model           不输入 或者输入 '3d' 选择绘制模式
%--------------------------------------------------------------------------
%	例子:
%   complex2vector(randn(1,5) + 1j.*randn(1,5))                          %二维画图
%	complex2vector(randn(1,5) + 1j.*randn(1,5),'3d')                     %三维画图
%--------------------------------------------------------------------------
function complex2vector(points, model)
if nargin == 1
    model = '2D';
end
if upper(model) == "2D"
    for idx = 1:numel(points)
        quiver(0, 0, real(points(idx)), imag(points(idx)));
        if abs(points(idx)) > 0.7
            ang = angle(points(idx)) * 180 / pi;
            text(real(points(idx)), imag(points(idx)), ...
                sprintf('%d  %.1f°', idx, ang), 'HorizontalAlignment', 'center');
        end
        hold on
    end
elseif upper(model) == "3D"
    for idx = 1:numel(points)
        quiver3(idx, 0, 0, 0, real(points(idx)), imag(points(idx)));
        ang = angle(points(idx)) * 180 / pi;
        text(idx, real(points(idx)), imag(points(idx)), ...
            sprintf('%d  %.1f°', idx, ang));
        hold on
    end
    plot3(1:numel(points), zeros(1,numel(points)), zeros(1,numel(points)), 'k', 'LineWidth', 1)
    plot3(1:numel(points), zeros(1,numel(points)), zeros(1,numel(points)), 'ro', 'LineWidth', 1)
end
hold off; grid on;
axis equal
end
