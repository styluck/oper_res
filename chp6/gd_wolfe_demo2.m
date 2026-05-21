% Gradient Descent Visualization in 3D
clear; clc; close all;

% Sigmoid-based objective
sigmoid = @(x) 1 ./ (1 + exp(-x));
f = @(x, y) sigmoid(x) + sigmoid(y);

% Gradient of the sigmoid sum
grad = @(x, y) [sigmoid(x) * (1 - sigmoid(x));
                sigmoid(y) * (1 - sigmoid(y))];

% Set parameters
alpha_init = 1;       % initial step size
beta = 0.5;           % step size shrink factor
gamma = 2;          % step size expansion factor
c1 = 1e-4;            % Wolfe condition constant for sufficient decrease
c2 = 0.9;             % Wolfe condition constant for curvature
max_iter = 500;
tol = 1e-6;
x0 = [3; 3];          % Starting point

% Create grid for plotting the surface
[xg, yg] = meshgrid(-50:0.2:5, -50:0.2:5);
zg = f(xg, yg);

% Initialize position
x = x0;
history = zeros(2, max_iter + 1);
history(:, 1) = x;
history_len = 1;
iter_count = 0;

tic;
for i = 1:max_iter
    g = grad(x(1), x(2));
    if norm(g) < tol
        disp(['Converged at iteration ', num2str(i - 1)]);
        break;
    end

    d = -g;
    alpha = wolfe_line_search(f, grad, x, d, alpha_init, beta, gamma, c1, c2);
    x = x + alpha * d;
    history_len = history_len + 1;
    history(:, history_len) = x;
    iter_count = i;
end
elapsed_time = toc;

history = history(:, 1:history_len);
fprintf('final obj val: %2.6e\n', f(history(1,end), history(2,end)));
fprintf('elapsed time: %2.6f s\n', elapsed_time);
fprintf('total iterations: %d\n', iter_count);

% Plotting and movie setup
figure;
axis tight manual
set(gca,'nextplot','replacechildren');
% v = VideoWriter('gradient_descent_demo.avi');
% open(v);

for k = 1:size(history, 2)
    surf(xg, yg, zg, 'EdgeColor', 'none');
    hold on;
    plot3(history(1,1:k), history(2,1:k), f(history(1,1:k), history(2,1:k)), 'r.-', 'LineWidth', 2, 'MarkerSize', 10);
    plot3(-100, -100, f(-100, -100), 'go', 'MarkerSize', 10, 'LineWidth', 2); % True minimum
    title(['Gradient Descent Iteration: ', num2str(k)]);
    xlabel('x'); ylabel('y'); zlabel('f(x,y)');
    view(25, 30);
    drawnow;

    % Write frame to video
    frame = getframe(gcf);
%     writeVideo(v, frame);

    hold off;
end

% close(v);

function alpha = wolfe_line_search(f, grad, x, d, alpha_init, beta, gamma, c1, c2)
phi0 = f(x(1), x(2));
dphi0 = grad(x(1), x(2))' * d;

alpha = alpha_init;
max_ls_iter = 20;

for j = 1:max_ls_iter
    x_trial = x + alpha * d;
    phi = f(x_trial(1), x_trial(2));
    dphi = grad(x_trial(1), x_trial(2))' * d;

    if phi <= phi0 + c1 * alpha * dphi0 && dphi >= c2 * dphi0
        return;
    end

    if phi > phi0 + c1 * alpha * dphi0
        alpha = beta * alpha;
    else
        alpha = gamma * alpha;
    end
end
end
