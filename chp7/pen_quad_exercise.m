clc; clear; close all;
 
% 问题:
%   min  f(x,y) = x + sqrt(3) y
%   s.t. h(x,y) = x^2 + y^2 - 1 = 0
%
% 要求:
% 1. 写出二次罚函数 phi_mu(x,y)
% 2. 对 mu = [1, 5, 20, 100, 500] 依次用梯度下降法求解无约束子问题
% 3. 每次记录 (x_k, y_k), f(x_k, y_k), |h(x_k, y_k)|
% 4. 在图上画出约束圆和各个罚子问题的解
%
% 使用 warm start, 即把上一个子问题的解作为下一个子问题的初值
% 使用 Armijo 回溯线搜索选步长
% 参考梯度公式:
% 若 h(z) = z(1)^2 + z(2)^2 - 1,
% 则 grad phi_mu(z) = [1; sqrt(3)] + mu * h(z) * [2*z(1); 2*z(2)]


f = @(z) z(1) + sqrt(3) * z(2);
h = @(z) z(1)^2 + z(2)^2 - 1;

mu_list = [1, 5, 20, 100, 500];
z = [0; 0];

% 梯度下降参数
alpha_init = 1;
beta = 0.5;
c1 = 1e-4;
tol = 1e-6;
max_inner_iter = 2000;

n_mu = numel(mu_list);
sol_hist = zeros(2, n_mu);
obj_hist = zeros(n_mu, 1);
feas_hist = zeros(n_mu, 1);

fprintf('%8s %12s %12s %12s %12s\n', 'mu', 'x', 'y', 'f(x,y)', '|h(x,y)|');

for k = 1:n_mu
    mu = mu_list(k);

    % ########  写出二次罚函数 phi_mu ###########
    % phi_mu = @(zz) ...

    % ########  用梯度下降法求解当前无约束子问题 ###########
    % 提示: 先写出梯度, 再做 Armijo 回溯线搜索
    % grad_phi_mu = @(zz) ...  

    sol_hist(:, k) = z;
    obj_hist(k) = f(z);
    feas_hist(k) = abs(h(z));

    fprintf('%8.1f %12.6f %12.6f %12.6f %12.3e\n', ...
        mu, z(1), z(2), obj_hist(k), feas_hist(k));
end

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

for k = 1:n_mu
    text(sol_hist(1, k) + 0.03, sol_hist(2, k), sprintf('\\mu=%g', mu_list(k)));
end

xlabel('x');
ylabel('y');
title('Quadratic Penalty Method');
legend('Objective contours', 'Constraint circle', 'Penalty iterates', 'Location', 'best');
axis equal;
grid on;
hold off;
