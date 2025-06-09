clc; clear;

% Parameters
mu = 10;
lambda = 0;

% Define functions
penalty_obj = @(z) z(1) + sqrt(3)*z(2) + (mu/2)*(z(1)^2 + z(2)^2 - 1)^2;
alm_obj      = @(z) z(1) + sqrt(3)*z(2) + lambda*(z(1)^2 + z(2)^2 - 1) + (mu/2)*(z(1)^2 + z(2)^2 - 1)^2;

% Initial guess
z0 = [-0.8; -0.8];

% Minimize penalty function
penalty_sol = fminunc(penalty_obj, z0, optimoptions('fminunc','Display','off'));
alm_sol     = fminunc(alm_obj, z0, optimoptions('fminunc','Display','off'));

% Grid for plotting
[x, y] = meshgrid(linspace(-1.5, 1.5, 400), linspace(-1.5, 1.5, 400));
f = x + sqrt(3) * y;
c = x.^2 + y.^2 - 1;
phi_penalty = f + (mu/2) * (c.^2);
phi_alm = f + lambda * c + (mu/2) * (c.^2);

% Constraint circle
theta = linspace(0, 2*pi, 500);
cx = cos(theta);
cy = sin(theta);

% True optimal point
x_opt = -0.5;
y_opt = -sqrt(3)/2;
fprintf('Quadratic error: %2.4f\n', norm([x_opt;y_opt]-penalty_sol))
fprintf('ALM error: %2.4f\n', norm([x_opt;y_opt]-alm_sol))

% Plot: Augmented Lagrangian Contour
figure;
contour(x, y, phi_alm, 50, 'LineWidth', 1.2); hold on;
plot(cx, cy, 'r', 'LineWidth', 2);                        % Constraint circle
plot(x_opt, y_opt, 'ko', 'MarkerSize', 8, ...
     'MarkerFaceColor', 'k');                            % True optimal
plot(alm_sol(1), alm_sol(2), 'mo', 'MarkerSize', 8, ...
     'MarkerFaceColor', 'm');                            % ALM optimum
xlabel('x'); ylabel('y');
title('Augmented Lagrangian Function 等高线图');
legend('\mathcal{L}_\mu contours', ...
       'Constraint: x^2 + y^2 = 1', ...
       'True constrained optimum', ...
       'ALM problem optimum');
axis equal; grid on;

%% Plot: Penalty Function Contour
figure;
contour(x, y, phi_penalty, 50, 'LineWidth', 1.2); hold on;
plot(cx, cy, 'r', 'LineWidth', 2);                        % Constraint circle
plot(x_opt, y_opt, 'ko', 'MarkerSize', 8, ...
     'MarkerFaceColor', 'k');                            % True optimal
plot(penalty_sol(1), penalty_sol(2), 'mo', 'MarkerSize', 8, ...
     'MarkerFaceColor', 'm');                            % Penalized optimum
xlabel('x'); ylabel('y');
title('Quadratic Penalty Function 等高线图');
legend('\phi_\mu contours', ...
       'Constraint: x^2 + y^2 = 1', ...
       'True constrained optimum', ...
       'Penalty problem optimum');
axis equal; grid on;

 % [EOF]
