function [solution, z] = simplex_method(A, b, c)
% 使用MATLAB table格式输出的单纯形法
% 输入参数：
%   A - 包含松弛变量的约束矩阵
%   b - 右侧常数项
%   c - 目标函数系数

%% 初始化参数
[m, n] = size(A);  %m约束条件个数, n决策变量数
v=nchoosek(1:n,m);  %创建一个矩阵，该矩阵的行由每次从1:n中的n个元素取出k个取值的所有可能组合构成。矩阵 C 包含 m!/((n–m)! m!) 行和 m列
basic_vars=[];
%% 提取可行解所在列
for i=1:size(v,1)  %size(v,1)为在n中取m个的种类
    if A(:,v(i,:))==eye(m)   %在中心部位A中取v的第i种取法取出m列判断是否存在m*m大小的单位矩阵
        basic_vars=v(i,:);  %把%存在单位矩阵的取法保存在列表index_Basis中
    end
end 

table = [0 c' ; b A];          % 初始单纯形表

%% 打印初始表
disp('初始单纯形表:');
print_table(table, basic_vars, n);

%% 单纯形法迭代
iter = 0;
while true 
    % 检验最优性
    if all(table(1,2:end) <= 1e-6) 
            break;  
    end
    
    % 选择入基变量
    if iter == 0
    z = c(basic_vars)'*table(2:end,2:end); 
    sigma = table(1,2:end)-z;  
    else
    sigma = table(1,2:end);  
    end
    enter = find(sigma == max(sigma));
    enter = enter(1); % 下标最小的换入变量

    % 计算theta并选择出基变量
    theta = table(2:m+1,1) ./ table(2:m+1,enter+1);
    theta(theta < 0) = inf;
    exit = find(theta == min(theta));

    if length(exit) > 1
       [~, exit_] = min(basic_vars(exit));
       exit = exit(exit_);
    end 
    % 更新基变量
    basic_vars(exit) = enter;
    
    % 枢轴运算
    pivot = table(exit+1,enter+1);
    table(exit+1,:) = table(exit+1,:) / pivot;
    
    for i = 1:m+1
        if i ~= exit+1
            table(i,:) = table(i,:) - table(i,enter+1)*table(exit+1,:);
        end
    end
    
    % 显示迭代表
    iter = iter + 1;
    if iter > 10
        fprintf('\n迭代 %d 步后未达到最优解\n', iter);
        break;

    end
 
    fprintf('\n迭代步 %d:\n', iter);
    print_table(table, basic_vars, n);
end

%% 输出结果
solution = zeros(n,1);
solution(basic_vars) = table(2:m+1,1);
z = -table(1,1);

end
%% 嵌套表格打印函数
function print_table(t, basic_vars, n_vars)

    % 转换为分数格式
    str_data = strings(size(t));
    for i = 1:size(t,1)
        for j = 1:size(t,2)
            str_data(i,j) = rats(t(i,j)); 
        end
    end

    % 生成列名
    col_names = ["b", strcat('x', string(1:n_vars))];
    
    % 提取数据并四舍五入 
    constraint_data = str_data(2:end,:);
    z_row = str_data(1,:);
    
    % 构建约束行table
    const_tbl = array2table(constraint_data,...
        'VariableNames', col_names,...
        'RowNames', strcat('x', string(basic_vars)));
    
    % 构建z行table
    z_tbl = array2table(z_row,...
        'VariableNames', col_names,...
        'RowNames', {'z'});
    
    % 合并显示
    disp([z_tbl;const_tbl]); 
end

% [EOF]