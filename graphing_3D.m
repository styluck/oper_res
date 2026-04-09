clc; clear; close all;

%% 线性规划模型
% maximize z = 3x1 + 2x2 + x3
% s.t.
%   x1 + x2 + x3 <= 4
%   2x1 + x2      <= 5
%   x1 + 2x2 + x3 <= 5
%   x1, x2, x3 >= 0

A = [1 1 1;
     2 1 0;
     1 2 1;
    -1 0 0;
     0 -1 0;
     0 0 -1];

b = [4; 5; 5; 0; 0; 0];

c = [3; 2; 1];   % 目标函数系数（最大化）

%% Step 1: 枚举约束平面的交点，寻找可行域顶点
m = size(A,1);
verts = [];

for i = 1:m-2
    for j = i+1:m-1
        for k = j+1:m
            M = [A(i,:); A(j,:); A(k,:)];
            rhs = [b(i); b(j); b(k)];

            if rank(M) == 3
                x = M \ rhs;

                % 判断是否满足全部约束
                if all(A*x <= b + 1e-9)
                    verts = [verts; x'];
                end
            end
        end
    end
end

% 去重
verts = unique(round(verts,10), 'rows');

%% Step 2: 计算目标函数值，找最优解
zvals = verts * c;
[zmax, idx] = max(zvals);
x_opt = verts(idx,:);

fprintf('可行域顶点如下：\n');
disp(verts);

fprintf('最优解为：\n');
fprintf('x1 = %.4f, x2 = %.4f, x3 = %.4f\n', x_opt(1), x_opt(2), x_opt(3));
fprintf('最优目标函数值 z = %.4f\n', zmax);

%% Step 3: 画三维可行域
figure;
hold on; grid on; axis equal;
xlabel('x_1'); ylabel('x_2'); zlabel('x_3');
title('3变量线性规划的可行域与最优解');

% 使用凸包构造多面体表面
if size(verts,1) >= 4
    K = convhull(verts(:,1), verts(:,2), verts(:,3));
    trisurf(K, verts(:,1), verts(:,2), verts(:,3), ...
        'FaceAlpha', 0.25, 'FaceColor', [0.4 0.7 0.9], 'EdgeColor', 'k');
end

% 画顶点
plot3(verts(:,1), verts(:,2), verts(:,3), 'bo', ...
    'MarkerFaceColor', 'b', 'MarkerSize', 6);

% 标记最优解
plot3(x_opt(1), x_opt(2), x_opt(3), 'rp', ...
    'MarkerFaceColor', 'r', 'MarkerSize', 14);

text(x_opt(1), x_opt(2), x_opt(3), ...
    sprintf('  Optimal(%.2f, %.2f, %.2f)', x_opt(1), x_opt(2), x_opt(3)), ...
    'Color', 'r', 'FontSize', 10);

%% Step 4: 画目标函数方向
% 从原点画一个方向向量 c
quiver3(0,0,0,c(1),c(2),c(3),0.5,'r','LineWidth',2,'MaxHeadSize',1);
text(c(1)*0.5, c(2)*0.5, c(3)*0.5, '  objective direction', ...
    'Color', 'r', 'FontSize', 10);

view(3);
hold off;

%% 用 linprog 验证
f = -c;   % linprog 默认求最小值，因此取负号
A_lp = [1 1 1;
        2 1 0;
        1 2 1];
b_lp = [4; 5; 5];
lb = [0; 0; 0];

[x_lp, fval_lp] = linprog(f, A_lp, b_lp, [], [], lb, []);

fprintf('\nlinprog 验证结果：\n');
fprintf('x1 = %.4f, x2 = %.4f, x3 = %.4f\n', x_lp(1), x_lp(2), x_lp(3));
fprintf('z = %.4f\n', -fval_lp);