clear; clc; close all;

% Objective function
A = [3, 1; 1, 2];  % SPD matrix
b = [1; 1];
f = @(x) 0.5 * x' * A * x - b' * x;
grad = @(x) A * x - b;

% Starting point
x0 = [-2; 2];
max_iter = 100;
alpha_gd = 0.1;
tol = 1e-6;

% Gradient Descent
x_gd = x0;
path_gd = x_gd;

for k = 1:max_iter
    g = grad(x_gd);
    if norm(g) < tol, break; end
    x_gd = x_gd - alpha_gd * g;
    path_gd(:, end+1) = x_gd;
end

% Conjugate Gradient
x_cg = x0;
r = b - A * x_cg;   % residual
p = r;              % search direction
path_cg = x_cg;

for k = 1:max_iter
    Ap = A * p;
    alpha = (r' * r) / (p' * Ap);
    x_cg = x_cg + alpha * p;
    r_new = r - alpha * Ap; 


    beta = (r_new' * r_new) / (r' * r);
    p = r_new + beta * p;
    r = r_new;

    path_cg = [path_cg,x_cg];

    if norm(r_new) < tol
        break;
    end
end

% Meshgrid for surface
[xg, yg] = meshgrid(-3:0.1:3, -1:0.1:4);
zg = arrayfun(@(x, y) f([x; y]), xg, yg);

% Animate
figure;
surf(xg, yg, zg, 'EdgeColor', 'none'); hold on;
colormap parula
xlabel('x'); ylabel('y'); zlabel('f(x)');
title('Gradient Descent vs Conjugate Gradient');
view(45, 30); grid on;

gd_line = plot3(NaN, NaN, NaN, 'r.-', 'LineWidth', 2, 'DisplayName', 'Gradient Descent');
cg_line = plot3(NaN, NaN, NaN, 'g.-', 'LineWidth', 2, 'DisplayName', 'Conjugate Gradient');
legend;

for k = 1:max(length(path_gd), length(path_cg))
    if k <= size(path_gd, 2)
        gd_line.XData = path_gd(1, 1:k);
        gd_line.YData = path_gd(2, 1:k);
        gd_line.ZData = arrayfun(@(i) f(path_gd(:, i)), 1:k);
    end
    if k <= size(path_cg, 2)
        cg_line.XData = path_cg(1, 1:k);
        cg_line.YData = path_cg(2, 1:k);
        cg_line.ZData = arrayfun(@(i) f(path_cg(:, i)), 1:k);
    end
    pause(0.3);
end
