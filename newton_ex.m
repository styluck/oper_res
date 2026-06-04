clear; clc; close all;

dims = [10, 100, 300, 600];     % Dimensions to test
max_iter = 1000;                % Max iterations
tol = 1e-6;                     % Gradient norm tolerance

loss_gd = cell(size(dims));
loss_cg = cell(size(dims));
loss_newton = cell(size(dims));

time_gd = cell(size(dims));
time_cg = cell(size(dims));
time_newton = cell(size(dims));

for i = 1:length(dims)
    n = dims(i);

    % Generate positive definite A and vector b
    R = randn(n); A = R'*R + eye(n);  % A symmetric positive definite
    b = randn(n,1);
    x0 = zeros(n,1);                  % Initial point

    f = @(x) 0.5 * x' * A * x - b' * x + 10;
    grad = @(x) A * x - b;

    %% Gradient Descent
    x = x0;
    g = grad(x);
    losses = f(x); times = 0;

    alpha = 1 / max(eig(A)); % optimal for quadratic
    tic;
    for k = 1:max_iter
        if norm(g) < tol, break; end
        x = x - alpha * g;
        g = grad(x);
        losses(k+1) = f(x);
        times(k+1) = toc;
    end
    loss_gd{i} = losses;
    time_gd{i} = times;

    %% Conjugate Gradient
    x = x0;
    r = b - A * x; d = r;
    losses = f(x); times = 0;
    tic;
    for k = 1:max_iter
        Ad = A * d;
        alpha_cg = (r' * r) / (d' * Ad);
        x = x + alpha_cg * d;
        r_new = r - alpha_cg * Ad;
        losses(k+1) = f(x);
        times(k+1) = toc;
        if norm(r_new) < tol, break; end
        beta = (r_new' * r_new) / (r' * r);
        d = r_new + beta * d;
        r = r_new;
    end
    loss_cg{i} = losses;
    time_cg{i} = times;

    %% %%%%%%%%%%%%% 补全： Newton's Method %%%%%%%%%%%%%


    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    loss_newton{i} = losses;
    time_newton{i} = times;
end

%% Plot Loss vs Time
figure;
for i = 1:length(dims)
    subplot(2, 2, i); hold on;
    semilogy(time_gd{i}, loss_gd{i}, 'r', 'LineWidth', 1.5);
    semilogy(time_cg{i}, loss_cg{i}, 'go', 'LineWidth', 1.5);
    semilogy(time_newton{i}, loss_newton{i}, 'b', 'LineWidth', 1.5);
    title(['n = ', num2str(dims(i))]);
    xlabel('Time (s)');
    ylabel('Loss');
    legend('GD', 'CG', 'Newton');
    grid on;
end
sgtitle('Loss vs Time Comparison');

%% Optional: Plot Loss vs Iteration
figure;
for i = 1:length(dims)
    subplot(2, 2, i); hold on;
    semilogy(0:length(loss_gd{i})-1, loss_gd{i}, 'r', 'LineWidth', 1.5);
    semilogy(0:length(loss_cg{i})-1, loss_cg{i}, 'g', 'LineWidth', 1.5);
    semilogy(0:length(loss_newton{i})-1, loss_newton{i}, 'b', 'LineWidth', 1.5);
    title(['n = ', num2str(dims(i))]);
    xlabel('Iteration');
    ylabel('Loss');
    legend('GD', 'CG', 'Newton');
    grid on;
end
sgtitle('Loss vs Iteration Comparison');

%  [EOF]