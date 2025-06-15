% Gradient Descent Visualization in 3D
clear; clc; close all;

% Define the function and its gradient
f = @(x, y) x.^2 - y.^2;
grad = @(x, y) [2*x; -2*y];

% Set parameters
x0 = [0.8; 0];  % Start along x-axis (y=0)  [.8, -.01]
alpha = 0.1;
max_iter = 25; % 50
tol = 1e-6;

% Create grid for plotting the surface
[xg, yg] = meshgrid(-1:0.05:1, -1:0.05:1);
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
v = VideoWriter('gradient_descent_demo.avi'); 
open(v);

for k = 1:size(history, 2)
    surf(xg, yg, zg, 'EdgeColor', 'none');
    hold on;
    plot3(history(1,1:k), history(2,1:k), f(history(1,1:k), history(2,1:k)), 'r.-', 'LineWidth', 2, 'MarkerSize', 10);
    plot3(0, 0, f(0,0), 'go', 'MarkerSize', 10, 'LineWidth', 2); % True minimum
    title(['Gradient Descent Iteration: ', num2str(k)]);
    xlabel('x'); ylabel('y'); zlabel('f(x,y)');
    view(-25, 40);
    drawnow;
    
    % Write frame to video
    frame = getframe(gcf);
%     writeVideo(v, frame);
    
    hold off;
end

% close(v);

% [EOF]
