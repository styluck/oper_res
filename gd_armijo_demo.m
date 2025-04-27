% Gradient Descent with Armijo Step Size
clear; clc; close all;

% Function and gradient
f = @(x, y) (x - 1).^2 + (y - 2).^2;
grad = @(x, y) [2*(x - 1); 2*(y - 2)];

% Armijo parameters
alpha_init = 1;       % initial step size
beta = 0.5;           % step size shrink factor
c = 1e-4;             % Armijo condition constant
max_iter = 50;
tol = 1e-6;
x0 = [-3; 4];

% Grid for surface plot
[xg, yg] = meshgrid(-4:0.1:4, -1:0.1:7);
zg = f(xg, yg);

% Gradient descent with Armijo
x = x0;
history = x;

for i = 1:max_iter
    g = grad(x(1), x(2));
    d = -g;  % Descent direction
    alpha = alpha_init;
    
    % Backtracking line search (Armijo rule)
    while f(x(1) + alpha*d(1), x(2) + alpha*d(2)) > f(x(1), x(2)) + c*alpha*(g'*d)
        alpha = beta * alpha;
    end
    
    x = x + alpha * d;
    history(:, end+1) = x;
    if norm(g) < tol
    disp(['Converged at iteration ', num2str(i)]);
    break;
    end
end

% Plot and video
figure;
axis tight manual
set(gca,'nextplot','replacechildren');
v = VideoWriter('gradient_descent_armijo.avi'); 
open(v);

for k = 1:size(history, 2)
    surf(xg, yg, zg, 'EdgeColor', 'none');
    hold on;
    plot3(history(1,1:k), history(2,1:k), f(history(1,1:k), history(2,1:k)), 'r.-', 'LineWidth', 2, 'MarkerSize', 10);
    plot3(1, 2, f(1, 2), 'go', 'MarkerSize', 10, 'LineWidth', 2); % True minimum
    title(['GD with Armijo, Iter: ', num2str(k)]);
    xlabel('x'); ylabel('y'); zlabel('f(x,y)');
    view(25, 30);
    drawnow;

    % Save frame
    frame = getframe(gcf);
%     writeVideo(v, frame);
    hold off;
end

% close(v);
% [EOF]