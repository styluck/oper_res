%% 练习一：范数计算
% 编写代码，计算随机生成向量的l1-范数、l2-范数和无穷范数，以及
% 给定随机生成的l1-范数、l2-范数、frobenius范数和无穷范数。

% 向量
v = randn(10,1);
% 向量1-范数
norm_1 = norm(v, 1);
% 向量2-范数
norm_2 = norm(v, 2);
% 向量无穷范数
norm_inf = norm(v, inf);

fprintf('向量v的l1-范数: %f\n', norm_1);
fprintf('向量v的l2-范数: %f\n', norm_2);
fprintf('向量v的无穷范数: %f\n', norm_inf);

% 矩阵
A = randn(10,10);
% 矩阵1-范数
matrix_norm_1 = norm(A, 1);
% 矩阵2-范数
matrix_norm_2 = norm(A, 2);
% 矩阵fro范数
matrix_norm_fro = norm(A, 'fro');
% 矩阵无穷范数
matrix_norm_inf = norm(A, inf);

fprintf('矩阵A的l1-范数: %f\n', matrix_norm_1);
fprintf('矩阵A的l2-范数: %f\n', matrix_norm_2);
fprintf('矩阵A的fro范数: %f\n', matrix_norm_fro);
fprintf('矩阵A的无穷范数: %f\n', matrix_norm_inf);


%% 练习二：导数计算
% 对于函数$f(x) = x^3 + 2x^2 + 3x + 1$，编写代码计算其在某点$x_0$的一阶导数和二阶导数。

syms x;
f = x^3 + 2*x^2 + 3*x + 1;
% 一阶导数
df = diff(f, x);
% 二阶导数
d2f = diff(f, x, 2);

x0 = 2;
% 计算在x0处的一阶导数值
df_value = subs(df, x, x0);
% 计算在x0处的二阶导数值
d2f_value = subs(d2f, x, x0);

fprintf('函数f(x)在x = %d处的一阶导数: %f\n', x0, df_value);
fprintf('函数f(x)在x = %d处的二阶导数: %f\n', x0, d2f_value);


%% 练习三：凸集判断
% 判断由不等式$x_1 + 2x_2 \leq 5$，$x_1 \geq 0$，$x_2 \geq 0$定义的集合是否为凸集，编写代码进行验证。
% 随机生成集合内两点
% 生成满足约束条件的随机点 x1 和 x2
while true
    % 随机生成 0 到 5 之间的数作为 x1 的第一个分量
    candidate_x1_1 = rand() * 5; 
    % 随机生成 0 到 (5 - candidate_x1_1)/2 之间的数作为 x1 的第二个分量
    candidate_x1_2 = rand() * (5 - candidate_x1_1) / 2; 
    x1 = [candidate_x1_1, candidate_x1_2];
    % 检查生成的点是否满足约束条件
    if x1(2) >= 0
        break;
    end
end

while true
    % 随机生成 0 到 5 之间的数作为 x2 的第一个分量
    candidate_x2_1 = rand() * 5; 
    % 随机生成 0 到 (5 - candidate_x2_1)/2 之间的数作为 x2 的第二个分量
    candidate_x2_2 = rand() * (5 - candidate_x2_1) / 2; 
    x2 = [candidate_x2_1, candidate_x2_2];
    % 检查生成的点是否满足约束条件 x2(1) + 2 * x2(2) <= 5 && x2(1) >= 0 && x2(2) >= 0
    if x2(2) >= 0
        break;
    end
end

% 生成一组在(0, 1)之间的lambda值
num_lambdas = 100; % 可根据需要调整测试的lambda数量
lambdas = linspace(0, 1, num_lambdas);

is_convex = true; % 先假设集合是凸集

for i = 1:num_lambdas
    lambda = lambdas(i);
    % 计算两点的凸组合
    x_lambda = lambda * x1 + (1 - lambda) * x2;
    % 判断凸组合是否满足不等式约束
    condition1 = x_lambda(1) + 2 * x_lambda(2) <= 5;
    condition2 = x_lambda(1) >= 0;
    condition3 = x_lambda(2) >= 0;
    
    if ~(condition1 && condition2 && condition3)
        is_convex = false;
        break;
    end
end

if is_convex
    fprintf('该集合是凸集\n');
else
    fprintf('该集合不是凸集\n');
end


%% 练习四：凸函数验证
% 对于函数$f(x) = x(1)^2+x(2)^2$，编写代码验证其是否为凸函数。 

% 定义函数 f(x) = x(1)^2 + x(2)^2
f = @(x) x(1)^2 + x(2)^2;

% 随机生成两个二维向量 x1 和 x2，元素范围在 0 - 100 之间
x1 = 100 * rand(2, 1);
x2 = 100 * rand(2, 1);

% 生成一组在(0, 1)之间的 lambda 值
num_lambdas = 100; % 可根据需要调整测试的 lambda 数量
lambdas = linspace(0, 1, num_lambdas);

is_convex = true; % 先假设函数是凸函数

for i = 1:num_lambdas
    lambda = lambdas(i);
    % 计算函数在 x1 和 x2 处的值
    f_x1 = f(x1);
    f_x2 = f(x2);
    % 计算凸组合的自变量值
    x_lambda = lambda * x1 + (1 - lambda) * x2;
    % 计算函数在凸组合自变量值处的值
    f_x_lambda = f(x_lambda);
    % 验证凸函数定义
    condition = f_x_lambda <= lambda * f_x1 + (1 - lambda) * f_x2;
    if ~condition
        is_convex = false;
        break;
    end
end

if is_convex
    fprintf('函数 f(x) = x(1)^2 + x(2)^2 是凸函数\n');
else
    fprintf('函数 f(x) = x(1)^2 + x(2)^2 不是凸函数\n');
end
