% Gradient Descent Visualization in 3D
clear; clc; close all;

% Sigmoid-based objective
sigmoid = @(x) 1 ./ (1 + exp(-x));
f = @(x, y) sigmoid(x) + sigmoid(y);

% Gradient of the sigmoid sum
grad = @(x, y) [sigmoid(x) * (1 - sigmoid(x));
                sigmoid(y) * (1 - sigmoid(y))];

% Set parameters
alpha = 0.5;           % Step size. try alpha = 0.1;1.01
max_iter = 400;         % Number of iterations
x0 = [3; 3];          % Starting point
tol = 1e-6;            % tolerance of the gradient

% Create grid for plotting the surface
[xg, yg] = meshgrid(-10:0.2:5, -10:0.2:5);
zg = f(xg, yg);

% Initialize position
x = x0;
history = x;

% Run gradient descent
for i = 1:max_iter
    g = grad(x(1), x(2));
    x = x - alpha * g;
    history(:, end+1) = x;
    if norm(g) < tol
    disp(['Converged at iteration ', num2str(i)]);
    break;
    end
end

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
    plot3(-10, -10, f(-10, -10), 'go', 'MarkerSize', 10, 'LineWidth', 2); % True minimum
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

% [EOF]
