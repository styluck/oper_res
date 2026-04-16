clc; clear; close all;
%% 第一题
clc; clear; close all;

% 1. 作图范围
x1 = linspace(0, 6, 400);

% 2. 各约束边界
x2_1 = 5 - x1;      %  x1 + x2 = 5
x2_2 = x1 + 1;      %  x1 - x2 = -1  => x2 = x1 + 1
x2_3 = 8 - 2*x1;    % 2x1 + x2 = 8

figure;
hold on; grid on; box on;

% 3. 绘制约束边界
plot(x1, x2_1, 'r', 'LineWidth', 1.5);
plot(x1, x2_2, 'b', 'LineWidth', 1.5);
plot(x1, x2_3, 'g', 'LineWidth', 1.5);
xline(1, 'm', 'LineWidth', 1.5);   % x1 = 1
yline(0, 'k', 'LineWidth', 1.5);   % x2 = 0

% 4. 求可行域顶点
% 顶点由边界交点得到
A = [1, 0];
B = [1, 2];
C = [2, 3];
D = [3, 2];
E = [4, 0];

V = [A; B; C; D; E];

% 5. 填充可行域
fill(V(:,1), V(:,2), [0.85 0.92 1], ...
    'FaceAlpha', 0.5, 'EdgeColor', 'none');

% 画出过原点的目标函数：z = 3x1 + 2x2
% 取 z = 0，则 3x1 + 2x2 = 0 -> x2 = -3/2 x1
z0 = 0;
x2_obj0 = (z0 - 3*x1)/2;
plot(x1, x2_obj0, 'c--', 'LineWidth', 1.5);

% 画出到达最优解时的目标函数
% 计算各顶点目标函数值找最优解
z = 3*V(:,1) + 2*V(:,2);
[zmax, idx] = max(z);
x1_opt = V(idx,1);
x2_opt = V(idx,2);
 
% 最优目标函数直线：3x1 + 2x2 = zmax
x2_obj_opt = (zmax - 3*x1)/2;
plot(x1, x2_obj_opt, 'k--', 'LineWidth', 2);
% 标出最优解
plot(x1_opt, x2_opt, 'rp', 'MarkerSize', 12, 'MarkerFaceColor', 'r');
text(x1_opt+0.08, x2_opt+0.1, ...
    sprintf('最优解 (%.0f,%.0f)', x1_opt, x2_opt), ...
    'Color', 'r', 'FontSize', 11);

% 输出结果
disp('各顶点及目标函数值：');
for i = 1:size(V,1)
    fprintf('(%.1f, %.1f), z = %.1f\n', V(i,1), V(i,2), z(i));
end
fprintf('\n最优解：x_1 = %.1f, x_2 = %.1f\n', x1_opt, x2_opt);
fprintf('最大值：z = %.1f\n', zmax);



% 标出顶点
plot(V(:,1), V(:,2), 'ko', 'MarkerFaceColor', 'k');
text(A(1)+0.05, A(2)+0.05, 'A(1,0)');
text(B(1)+0.05, B(2)+0.05, 'B(1,2)');
text(C(1)+0.05, C(2)+0.05, 'C(2,3)');
text(D(1)+0.05, D(2)+0.05, 'D(3,2)');
text(E(1)+0.05, E(2)+0.05, 'E(4,0)');

% 图形设置
legend('x_1+x_2=5', 'x_1-x_2=-1', '2x_1+x_2=8', 'x_1=1', 'x_2=0', ...
       '可行域', '过原点的目标函数', '最优目标函数', ...
       'Location', 'northeast');
xlabel('x');
ylabel('y');
title('线性规划图解法');
axis([0 6 -2 4]);
hold off;


%% 第二题

% 1. 作图范围
x1 = linspace(0, 8, 400);

% 2. 各约束边界
x2_1 = 6 - x1;          %  x1 +  x2 = 6
x2_2 = 4 - x1;          %  x1 +  x2 = 4
x2_3 = (15 - 3*x1)/2;   % 3x1 + 2x2 = 15

figure;
hold on; grid on; box on;

% 3. 画出各个约束条件
plot(x1, x2_1, 'r', 'LineWidth', 1.5);
plot(x1, x2_2, 'b', 'LineWidth', 1.5);
plot(x1, x2_3, 'g', 'LineWidth', 1.5);
xline(2, 'm', 'LineWidth', 1.5);   % x1 = 2

% 4. 画出过原点的目标函数
% z = 2x1 + x2
% 取 z = 0 => x2 = -2x1
x2_obj0 = -2*x1;
plot(x1, x2_obj0, 'c--', 'LineWidth', 1.5);

% 5. 本题无可行域，因此不画可行域，也不存在最优目标函数
disp('该线性规划无可行域，因为 x1+x2>=6 与 x1+x2<=4 矛盾。');
disp('因此该问题无最优解。');

legend('x_1+x_2=6', 'x_1+x_2=4', '3x_1+2x_2=15', 'x_1=2', ...
       '过原点的目标函数', 'Location', 'northeast');
xlabel('x_1');
ylabel('x_2');
title('第1题：无可行域，因此无最优解');
axis([0 8 -4 8]);
hold off;

%% 第三题

% 1. 作图范围
x1 = linspace(-1, 8, 400);

% 2. 各约束边界
x2_1 = x1 - 2;        % x1 -  x2 =  2  -> x2 = x1 - 2
x2_2 = x1 + 2;        % x1 -  x2 = -2  -> x2 = x1 + 2
x2_3 = (4 - x1)/2;    % x1 + 2x2 =  4  -> x2 = (4-x1)/2

figure;
hold on; grid on; box on;

% 3. 画出各个约束条件
plot(x1, x2_1, 'r', 'LineWidth', 1.5);
plot(x1, x2_2, 'b', 'LineWidth', 1.5);
plot(x1, x2_3, 'g', 'LineWidth', 1.5);
yline(1, 'm', 'LineWidth', 1.5);   % x2 = 1

% 4. 画出可行域
% 由于可行域无界，这里取显示窗口内的一个多边形近似表示
A = [0, 2];
B = [2, 1];
C = [3, 1];
D = [8, 6];
E = [8, 10];

V = [A; B; C; D; E];
fill(V(:,1), V(:,2), [0.85 0.92 1], ...
    'FaceAlpha', 0.5, 'EdgeColor', 'none');


% 5. 画出过原点的目标函数
% z = x1 + x2
% 取 z = 0 => x2 = -x1
x2_obj0 = -x1;
plot(x1, x2_obj0, 'c--', 'LineWidth', 1.5);

% 6. 本题最大值不存在，因此不画“到达最优解时的目标函数”
% 可额外画一条示意性的目标函数平移线
z_demo = 8;
x2_obj_demo = z_demo - x1;
plot(x1, x2_obj_demo, 'k--', 'LineWidth', 2);

% 标出关键点
plot([A(1),B(1),C(1)], [A(2),B(2),C(2)], 'ko', 'MarkerFaceColor', 'k');
text(A(1)+0.05, A(2)+0.05, 'A(0,2)');
text(B(1)+0.05, B(2)+0.05, 'B(2,1)');
text(C(1)+0.05, C(2)+0.05, 'C(3,1)');

disp('该线性规划可行域无界。');
disp('目标函数 z = x1 + x2 可沿右上方向无限增大。');
disp('因此该问题无最大值，也无最优解点。');

legend('x_2=x_1-2', 'x_2=x_1+2', 'x_1+2x_2=4', 'x_2=1', ...
       '可行域',  '过原点的目标函数', '目标函数平移示意', ...
       'Location', 'northwest');
xlabel('x_1');
ylabel('x_2');
title('第2题：可行域无界，最大值不存在');
axis([-1 8 -1 10]);
hold off;
% [EOF]
