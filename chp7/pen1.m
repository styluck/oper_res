% ==================== 参数设置 ====================
theta = linspace(0, 2*pi, 100);  % 圆柱角度参数
z_cyl = linspace(-5, 5, 50);     % 圆柱z轴范围（覆盖目标函数变化）
[Theta, Z] = meshgrid(theta, z_cyl);  % 生成圆柱参数网格

% ==================== 约束集：圆柱面 x²+y²=1 ====================
x_cyl = cos(Theta);
y_cyl = sin(Theta);
z_cyl_surf = Z;  % 圆柱面z坐标与参数Z一致（无限长圆柱）

% ==================== 目标函数：平面 z = x + √3 y ====================
[x_obj, y_obj] = meshgrid(linspace(-2, 2, 50), linspace(-2, 2, 50));  % 目标函数xy范围
z_obj = x_obj + sqrt(3)*y_obj;  % 目标函数值

% ==================== 绘制3D图像 ====================
figure('Position', [100, 100, 1000, 700]);  % 设置窗口大小

% 绘制约束圆柱面（半透明绿色）
surf(x_cyl, y_cyl, z_cyl_surf, 'FaceColor', [0.2, 0.8, 0.3], 'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on;

% 绘制目标函数平面（半透明红色）
surf(x_obj, y_obj, z_obj, 'FaceColor', [0.9, 0.3, 0.3], 'FaceAlpha', 0.6, 'EdgeColor', 'none');

% 绘制圆柱与目标函数的交线（约束下的目标函数轨迹）
z_intersect = cos(theta) + sqrt(3)*sin(theta);  % 圆柱面上各点的目标函数值
plot3(cos(theta), sin(theta), z_intersect, 'k--', 'LineWidth', 2);  % 交线（黑色虚线）

% 标注最小值点（拉格朗日法求解）
min_x = -1/2;    % 约束圆柱面上的x坐标
min_y = -sqrt(3)/2;  % 约束圆柱面上的y坐标
min_z = min_x + sqrt(3)*min_y;  % 目标函数在该点的值（z=-2）
plot3(min_x, min_y, min_z, 'bo', 'MarkerSize', 10, 'MarkerFaceColor', 'b');  % 最小值点（蓝色实心圆）

% ==================== 图像美化 ====================
xlabel('x'); ylabel('y'); zlabel('z');
title('3D View: Cylinder Constraint (x²+y²=1) & Objective Surface (z=x+√3y)');
axis tight; grid on;
view(35, 20);  % 调整观察角度
light('Position', [2, 2, 3], 'Style', 'infinite');  % 添加光照增强立体感
set(gca, 'ZLim', [-5, 5]);  % 限制z轴范围，聚焦关键区域
hold off;
