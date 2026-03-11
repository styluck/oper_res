%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%最优化理论 Matlab 课后练习题
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 一、基础操作与矩阵运算
%1. 变量与基本运算
% 定义两个标量变量 `x = 10` 和 `y = 3`，计算它们的和、差、积、商以及 `x` 的 `y` 
% 次幂，并将结果输出显示。
x = 10;
y = 3;

sum_result = x + y;
diff_result = x - y;
prod_result = x * y;
quot_result = x / y;
power_result = x ^ y;

fprintf('和: %f\n', sum_result);
fprintf('差: %f\n', diff_result);
fprintf('积: %f\n', prod_result);
fprintf('商: %f\n', quot_result);
fprintf('幂: %f\n', power_result);

%2. 向量与矩阵创建
% 创建一个包含 1 到 10 的整数的行向量 `v1`，以及一个 3 行 3 列的矩阵 `M1`，矩阵
% 元素依次为 1 到 9。查看 `v1` 的长度和 `M1` 的大小，并将结果输出。
v1 = 1:10;
M1 = [1 2 3; 4 5 6; 7 8 9];

v1_length = length(v1);
M1_size = size(M1);

fprintf('向量 v1 的长度: %d\n', v1_length);
fprintf('矩阵 M1 的大小: %d 行 %d 列\n', M1_size(1), M1_size(2));

%3. 矩阵基本运算
% 创建两个 2 行 2 列的矩阵 `A = [1 2; 3 4]` 和 `B = [5 6; 7 8]`，计算它们的和、
% 差、乘积以及 `A` 的转置矩阵，并输出结果。
A = [1 2; 3 4; 5 6];
B = [5 6; 7 8;9 0];

sum_matrix = A + B;
diff_matrix = A - B;
prod_matrix = A .^ B;
A_transpose = A';

fprintf('矩阵 A 和 B 的和:\n');
disp(sum_matrix);
fprintf('矩阵 A 和 B 的差:\n');
disp(diff_matrix);
fprintf('矩阵 A 和 B 的乘积:\n');
disp(prod_matrix);
fprintf('矩阵 A 的转置:\n');
disp(A_transpose);

%4. 矩阵的行列式、逆矩阵和特征值
% 对于矩阵 `C = [4 1; 1 4]`，计算其行列式、逆矩阵和特征值，并输出结果。判断矩阵是
% 否可逆，如果可逆则输出逆矩阵，否则输出提示信息。
C = [4 1; 1 4];
det_C = det(C);
eigenvalues = eig(C);

if det_C ~= 0
    inv_C = inv(C);
    fprintf('矩阵 C 的行列式: %f\n', det_C);
    fprintf('矩阵 C 的逆矩阵:\n');
    disp(inv_C);
    fprintf('矩阵 C 的特征值:\n');
    disp(eigenvalues);
else
    fprintf('矩阵 C 不可逆\n');
end

%% 二、函数定义与使用
%5. 自定义函数
% 定义一个函数 `square_sum`，该函数接受一个向量作为输入，返回向量中每个元素的平方
% 和。使用该函数计算向量 `v2 = [2, 4, 6, 8]` 的平方和，并输出结果。

square_sum = @(v, x) sum(v.^2)+x;
v2 = [2, 4, 6, 8];
sum_result = square_sum(v2);
fprintf('向量 v2 元素的平方和: %f\n', sum_result);

%6. 匿名函数
% 使用 `@` 定义一个匿名函数 `f`，该函数接受一个标量 `x` 作为输入，返回 
% `x^2 + 3*x + 2` 的值。使用该函数计算 `x = 5` 时的函数值，并输出结果。
f = @(x) x^2 + 3*x + 2;
x = 5;
result = f(x);
fprintf('当 x = %d 时，函数值为: %f\n', x, result);

%7. 函数嵌套调用
% 定义一个函数 `circle_area` 用于计算圆的面积，该函数接受圆的半径作为输入。再定义
% 一个函数 `total_area`，该函数接受一个包含多个圆半径的向量作为输入，调用
% `circle_area` 函数计算每个圆的面积并求和，最后返回总面积。使用 `total_area` 
% 函数计算半径向量 `r = [1, 2, 3]` 对应的圆的总面积，并输出结果。

r = [1, 2, 3];
total = total_area(r);
fprintf('半径向量 r 对应的圆的总面积: %f\n', total);

%% 三、绘图与可视化
%8. 简单函数绘图
% 绘制函数 $y = \sin(x)$ 在区间 $[0, 2\pi]$ 上的图像。设置 x 轴标签为 `x`，y 
% 轴标签为 `y = sin(x)`，标题为 `正弦函数图像`，并显示网格线。
x = linspace(0, 2*pi, 100);
y = sin(x);

plot(x, y);
xlabel('x');
ylabel('y = sin(x)');
title('正弦函数图像');
grid on;

%9. 多曲线绘图
% 在同一坐标系中绘制函数 $y_1 = \sin(x)$ 和 $y_2 = \cos(x)$ 在区间 $[0, 2\pi]$ 
% 上的图像。为两条曲线分别添加图例，显示为 `sin(x)` 和 `cos(x)`，并设置不同的颜色
% 和线型。
x = linspace(0, 2*pi, 100);
y1 = sin(x);
y2 = cos(x);

plot(x, y1, 'b-', x, y2, 'r--');
legend('sin(x)', 'cos(x)');
xlabel('x');
ylabel('y');
title('正弦和余弦函数图像');
grid on;

%% 四、优化相关应用（选做）
%10. 目标函数评估
% 定义一个匿名函数 `objective` 表示目标函数 $f(x,y)=(x - 2)^2+(y + 3)^2$。
% 创建一个初始点 `x0 = [0; 0]`，计算该点处的目标函数值，并输出结果。
objective = @(x) (x(1) - 2)^2 + (x(2) + 3)^2;
x0 = [0; 0];
result = objective(x0);
fprintf('初始点 [0, 0] 处的目标函数值: %f\n', result);

%11. 简单优化问题求解 
% 使用 Matlab 的 `fminsearch` 函数求解目标函数 $f(x)=(x - 5)^2$ 的最小值。设置
% 初始点为 `x0 = 0`，输出最优解和对应的最优值。
fun = @(x) (x - 5)^2;
x0 = 0;
[x_opt, fval] = fminsearch(fun, x0);
fprintf('最优解: %f\n', x_opt);
fprintf('最优值: %f\n', fval);

function area = circle_area(r)
    area = pi * r^2;
end

function total = total_area(r_vector)
    total = 0;
    for i = 1:length(r_vector)
        total = total + circle_area(r_vector(i));
    end
end
