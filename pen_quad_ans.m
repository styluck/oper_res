clc; clear; close all;

% 二次罚方法练习
% 问题:
%   min  f(x,y) = x + sqrt(3) y
%   s.t. h(x,y) = x^2 + y^2 - 1 = 0
%
% 1. 写出二次罚函数 phi_mu(x,y) = f(x,y) + (mu/2) * h(x,y)^2
% 2. 取一组递增的 mu, 依次用梯度下降法求解无约束子问题
% 3. 记录每次子问题解的目标值和约束违反量
% 4. 观察 mu 增大时, 解如何逼近可行集和最优点

% 原目标函数与约束函数
f = @(z) z(1) + sqrt(3) * z(2);
h = @(z) z(1)^2 + z(2)^2 - 1;

% 解析解, 仅用于课后核对
z_star = [-1/2; -sqrt(3)/2];
f_star = f(z_star);

% 罚参数序列
mu_list = [1, 5, 20, 100, 500];

% 初始点与梯度下降参数
z = [0; 0];
alpha_init = 1;
beta = 0.5;
c1 = 1e-4;
tol = 1e-8;
max_inner_iter = 5000;

% 历史记录
n_mu = numel(mu_list);
sol_hist = zeros(2, n_mu);
obj_hist = zeros(n_mu, 1);
feas_hist = zeros(n_mu, 1);
dist_hist = zeros(n_mu, 1);
iter_hist = zeros(n_mu, 1);

fprintf('Quadratic penalty method\n');
fprintf('---------------------------------------------------------------\n');
fprintf('%8s %12s %12s %12s %12s %12s %8s\n', ...
    'mu', 'x', 'y', 'f(x,y)', '|h(x,y)|', 'dist', 'iter');

for k = 1:n_mu
    mu = mu_list(k);
    phi_mu = @(zz) f(zz) + 0.5 * mu * h(zz)^2;
    grad_phi_mu = @(zz) [1 + 2 * mu * h(zz) * zz(1); ...
                         sqrt(3) + 2 * mu * h(zz) * zz(2)];

    % warm start: 用上一个子问题的解作为当前初值
    [z, iter_hist(k)] = solve_subproblem_gd(phi_mu, grad_phi_mu, z, ...
        alpha_init, beta, c1, tol, max_inner_iter);

    sol_hist(:, k) = z;
    obj_hist(k) = f(z);
    feas_hist(k) = abs(h(z));
    dist_hist(k) = norm(z - z_star);

    fprintf('%8.1f %12.6f %12.6f %12.6f %12.3e %12.3e %8d\n', ...
        mu, z(1), z(2), obj_hist(k), feas_hist(k), dist_hist(k), iter_hist(k));
end

fprintf('---------------------------------------------------------------\n');
fprintf('True solution: x = %.6f, y = %.6f, f* = %.6f\n', ...
    z_star(1), z_star(2), f_star);

% 绘制约束圆与罚方法迭代点
theta = linspace(0, 2*pi, 400);
cx = cos(theta);
cy = sin(theta);

[xg, yg] = meshgrid(linspace(-1.6, 1.6, 400), linspace(-1.6, 1.6, 400));
fg = xg + sqrt(3) * yg;

figure;
contour(xg, yg, fg, 25, 'LineWidth', 1.0);
hold on;
plot(cx, cy, 'r', 'LineWidth', 2);
plot(sol_hist(1, :), sol_hist(2, :), 'bo-', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
plot(z_star(1), z_star(2), 'kp', 'MarkerSize', 12, 'MarkerFaceColor', 'y');

for k = 1:n_mu
    text(sol_hist(1, k) + 0.03, sol_hist(2, k), sprintf('\\mu=%g', mu_list(k)));
end

xlabel('x');
ylabel('y');
title('Quadratic Penalty Method for x^2 + y^2 = 1');
legend('Objective contours', 'Constraint circle', 'Penalty iterates', 'True solution', ...
    'Location', 'best');
axis equal;
grid on;
hold off;

% 可选思考:
% 1. 若把 mu_list 改得增长更慢, 收敛现象有什么变化?
% 2. 若初值改成 [1; 1] 或 [-1; 0], 子问题解的轨迹是否改变?
% 3. 若不用 warm start, 每次都从同一个初值出发, 结果如何?

function [z, iter] = solve_subproblem_gd(phi, grad_phi, z0, alpha_init, beta, c1, tol, max_iter)
z = z0;

for iter = 1:max_iter
    g = grad_phi(z);
    if norm(g) < tol
        iter = iter - 1;
        return;
    end

    d = -g;
    alpha = alpha_init;
    phi_z = phi(z);

    % Armijo 回溯线搜索
    while phi(z + alpha * d) > phi_z + c1 * alpha * (g' * d)
        alpha = beta * alpha;
        if alpha < 1e-12
            return;
        end
    end

    z = z + alpha * d;
end
end
