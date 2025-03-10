
clear all
% addpath('cvx')
% cvx_setup
n = 256;
m = 128;

A = randn(m,n);
u = sprandn(n,1,0.1);
% u = rand(n,1);
b = A*u;

figure(1);
subplot(3,1,1); plot(1:n, u);
title('exact solu');

cvx_solver sdpt3   %mosek
cvx_begin 
    variable x(n)
    %minimize( max(norm(x, inf), norm(x,1)/sqrt(n)) )
    %minimize ( max(abs(x)))
    minimize (norm(x))
    subject to
        A*x == b
cvx_end
xl2 = x;

subplot(3,1,2); plot(1:n, xl2);
title('l2 solu');



cvx_begin
    variable x(n)
    minimize( norm(x,1) )
    subject to
        A*x == b
cvx_end
xl1 = x;

subplot(3,1,3); plot(1:n, xl1);
title('l1 solu');

fprintf('\n\nl2 error: %3.2e, l1 error: %3.2e\n', norm(u-xl2), norm(u-xl1));
