% Gradient Descent Visualization in 3D
clear; clc; close all;

% Define the function and its gradient
f = @(x, y) .3*(x).^2 + 10*(y).^2;
grad = @(x, y) [.6*(x); 20*(y)];

% Set parameters
alpha = 0.085;           % Step size. try alpha = 0.1;1.01
max_iter = 500;         % Number of iterations
x0 = [10; 1];          % Starting point
tol = 1e-6;            % tolerance of the gradient

% Create grid for plotting the surface
[xg, yg] = meshgrid(-11:0.1:11, -2:0.1:2);
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
    plot3(0, 0, f(0, 0), 'go', 'MarkerSize', 10, 'LineWidth', 2); % True minimum
    title(['Gradient Descent Iteration: ', num2str(k)]);
    xlabel('x'); ylabel('y'); zlabel('f(x,y)');
    view(-20, 70);
    drawnow;
    
    % Write frame to video
    frame = getframe(gcf);
%     writeVideo(v, frame);
    
    hold off;
end

% close(v);

% [EOF]
