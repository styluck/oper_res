clc; clear; close all;

%% 练习9第2题参考答案
% 问题:
%   min  (1/2) * ||x - c||^2
%   s.t. A*x = b
%
% 其中
%   A = [1 1 1 1 1;
%        1 2 3 4 5]
%   b = [2; 4]
%   c = [1; -1; -1; -3; -4]
%
% 二次罚函数:
%   phi_mu(x) = (1/2) * ||x-c||^2 + (mu/2) * ||A*x-b||^2
%
% 梯度:
%   grad phi_mu(x) = (x-c) + mu * A' * (A*x-b)

%% 数据
A = [1 1 1 1 1;
     1 2 3 4 5];
b = [2; 4];
c = [1; -1; -1; -3; -4];

f = @(x) 0.5 * norm(x - c)^2;
h = @(x) A * x - b;

%% 解析解, 仅用于核对
% KKT条件: x - c + A' * lambda = 0,  A*x = b
% 该题的解析解为 x* = [1; 0; 1; 0; 0]
x_star = [1; 0; 1; 0; 0];
f_star = f(x_star);

%% 参数设置
mu_list = [1, 5, 20, 100, 500];
x = zeros(5, 1);

alpha_init = 1;
beta = 0.5;
c1 = 1e-4;
tol = 1e-8;
max_inner_iter = 5000;

%% 历史记录
n_mu = numel(mu_list);
sol_hist = zeros(5, n_mu);
obj_hist = zeros(n_mu, 1);
feas_hist = zeros(n_mu, 1);
dist_hist = zeros(n_mu, 1);
iter_hist = zeros(n_mu, 1);

fprintf('Quadratic penalty method for linear equality constraints\n');
fprintf('--------------------------------------------------------------------------------\n');
fprintf('%8s %12s %12s %12s %12s\n', 'mu', 'f(x)', '||Ax-b||', 'dist', 'iter');

for k = 1:n_mu
    mu = mu_list(k);
    phi_mu = @(xx) f(xx) + 0.5 * mu * norm(h(xx))^2;
    grad_phi_mu = @(xx) (xx - c) + mu * (A' * h(xx));

    [x, iter_hist(k)] = solve_subproblem_gd(phi_mu, grad_phi_mu, x, ...
        alpha_init, beta, c1, tol, max_inner_iter);

    sol_hist(:, k) = x;
    obj_hist(k) = f(x);
    feas_hist(k) = norm(h(x));
    dist_hist(k) = norm(x - x_star);

    fprintf('%8.1f %12.6f %12.3e %12.3e %12d\n', ...
        mu, obj_hist(k), feas_hist(k), dist_hist(k), iter_hist(k));
end

fprintf('--------------------------------------------------------------------------------\n');
fprintf('True solution x* = [');
fprintf(' %.6f', x_star);
fprintf(' ]^T\n');
fprintf('True objective value f* = %.6f\n', f_star);

%% 输出各个 mu 下的近似解
fprintf('\nSolutions for each mu:\n');
for k = 1:n_mu
    fprintf('mu = %-6g  x = [', mu_list(k));
    fprintf(' %.6f', sol_hist(:, k));
    fprintf(' ]^T\n');
end

%% 作图
figure('Position', [100, 100, 1100, 420]);

subplot(1, 3, 1);
plot(mu_list, obj_hist, 'bo-', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
hold on;
yline(f_star, 'r--', 'LineWidth', 1.5);
xlabel('\mu');
ylabel('f(x_\mu)');
title('目标函数值');
grid on;
hold off;

subplot(1, 3, 2);
semilogy(mu_list, feas_hist, 'ms-', 'LineWidth', 1.5, 'MarkerFaceColor', 'm');
xlabel('\mu');
ylabel('||Ax_\mu - b||');
title('约束违反量');
grid on;

subplot(1, 3, 3);
semilogy(mu_list, dist_hist, 'kd-', 'LineWidth', 1.5, 'MarkerFaceColor', 'k');
xlabel('\mu');
ylabel('||x_\mu - x^*||');
title('与解析解的距离');
grid on;

%% 每个分量随 mu 的变化
figure('Position', [100, 100, 900, 500]);
styles = {'o-', 's-', 'd-', '^-', 'v-'};
hold on;
for i = 1:5
    plot(mu_list, sol_hist(i, :), styles{i}, 'LineWidth', 1.5, ...
        'DisplayName', sprintf('x_%d', i));
end
xlabel('\mu');
ylabel('变量分量');
title('各分量随罚参数的变化');
legend('Location', 'best');
grid on;
hold off;

%% 简短结论
fprintf('\n结论:\n');
fprintf('1. 该问题的原目标函数强凸, 二次罚子问题对每个 mu 都有唯一极小点.\n');
fprintf('2. mu 增大时, ||Ax-b|| 应逐步减小, 数值解逐步逼近解析解 x*.\n');

function [x, iter] = solve_subproblem_gd(phi, grad_phi, x0, alpha_init, beta, c1, tol, max_iter)
x = x0;

for iter = 1:max_iter
    g = grad_phi(x);
    if norm(g) < tol
        iter = iter - 1;
        return;
    end

    d = -g;
    alpha = alpha_init;
    phi_x = phi(x);

    while phi(x + alpha * d) > phi_x + c1 * alpha * (g' * d)
        alpha = beta * alpha;
        if alpha < 1e-12
            return;
        end
    end

    x = x + alpha * d;
end
end
