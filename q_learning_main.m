function q_learning_main()
%% Q-Learning迷宫导航算法 - MATLAB版本
% 原始Python版本作者主页: https://blog.csdn.net/HYY_2000
% 转换为MATLAB版本

clear all;
close all;
clc;

%% 参数设置
episodes = 500;       % 迭代次数
epsilon = 0.1;        % 随机探索率
learning_rate = 0.1;  % 学习率
discount_factor = 0.9; % 折扣因子

%% 迷宫设置
% 15 x 15 迷宫 (1表示墙壁，0表示可通行)
maze = [
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1;
    1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1;
    1, 0, 1, 0, 1, 0, 1, 1, 1, 0, 0, 0, 1, 0, 1;
    1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1;
    1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 1, 0, 0, 0, 1;
    1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1;
    1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1;
    1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1;
    1, 0, 1, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 0, 1;
    1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1;
    1, 1, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 0, 1, 1;
    1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1;
    1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1;
    1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1;
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
];

% 迷宫尺寸
[maze_height, maze_width] = size(maze);

% 起始和结束位置
init_position = [2, 2];
end_position = [maze_height-1, maze_width-1];

%% Agent初始化
agent.state = init_position;
agent.actions = [1, 2, 3, 4]; % 1:上, 2:下, 3:左, 4:右

%% 初始化Q值表
Q_table = zeros(maze_height, maze_width, 4);

%% 主程序
fprintf('   Q-Learning 静态迷宫导航算法\n');

% 显示初始迷宫
visualize_maze(init_position, '初始状态', maze, end_position);

%% ==================== Q-Learning训练 ====================
fprintf('开始Q-Learning训练...\n');

% 记录训练过程
steps_history = zeros(episodes, 1);

for episode = 1:episodes
    agent.state = init_position;
    steps = 0;
    
    while ~isequal(agent.state, end_position)
        % 选择动作 (ε-贪婪策略)
        if rand() < epsilon
            action = randi(4);  % 随机探索
        else
            [~, action] = max(Q_table(agent.state(1), agent.state(2), :));  % 利用
        end
        
        % 计算新位置
        new_state = get_next_position(agent.state, action, maze_height, maze_width);
        
        % 计算奖励
        if maze(new_state(1), new_state(2)) == 1
            reward = -10; % 撞墙惩罚
            new_state = agent.state; % 撞墙后保持原位
        elseif isequal(new_state, end_position)
            reward = 100; % 到达终点奖励
        else
            reward = -1; % 正常移动
        end 
       % Q值更新 (Bellman方程)
       % 获取当前位置执行该动作的旧Q值
        current_q = Q_table(agent.state(1), agent.state(2), action);
        % 未来能获得的最大受益
        max_future_q = max(Q_table(new_state(1), new_state(2), :));
        % 计算新的Q值，基于前面的Q值
        new_q = current_q + learning_rate * (reward + discount_factor * max_future_q - current_q);
        % 更新Q表
        Q_table(agent.state(1), agent.state(2), action) = new_q;
        % 更新状态
        agent.state = new_state;
        steps = steps + 1;
        % 防止无限循环
        if steps > 1000
            break;
        end
    end
    
    steps_history(episode) = steps;
    
    % 输出训练进度
    if mod(episode, 100) == 0
        avg_steps = mean(steps_history(max(1,episode-99):episode));
        fprintf('Episode %d: 步数=%d, 最近100轮平均=%.1f\n', episode, steps, avg_steps);
    end
end

% 显示训练曲线
figure(2);
plot(steps_history);
xlabel('Episode');
ylabel('步数');
title('Q-Learning训练过程');
grid on;

fprintf('\n训练完成!\n');

%% ==================== 运行最优路径 ====================
run_optimal_path(agent, Q_table, init_position, end_position, maze, maze_height, maze_width);

%% ==================== 显示路径上的Q值 ====================
show_path_q_values(Q_table, init_position, end_position, maze, maze_height, maze_width);

fprintf('\n程序结束。\n');

end

%% ==================== 运行最优路径 ====================
function run_optimal_path(agent, Q_table, init_position, end_position, maze, maze_height, maze_width)
    fprintf('\n开始运行最优路径...\n');
    
    agent.state = init_position;
    step_count = 0;
    path = {};
    max_steps = 200;
    
    % 记录访问过的位置（避免循环）
    visited = zeros(maze_height, maze_width);
    
    while ~isequal(agent.state, end_position) && step_count < max_steps
        visited(agent.state(1), agent.state(2)) = visited(agent.state(1), agent.state(2)) + 1;
        
        % 根据Q值选择最优动作
        action = choose_best_action(agent.state, Q_table, maze, maze_height, maze_width, visited);
        
        % 更新位置
        new_state = get_next_position(agent.state, action, maze_height, maze_width);
        
        % 检查是否撞墙
        if maze(new_state(1), new_state(2)) == 1
            new_state = agent.state;
        end
        
        % 记录路径
        path{end+1} = get_direction_name(action);
        step_count = step_count + 1;
        
        % 可视化
        title_str = sprintf('步骤 %d: 向%s移动', step_count, get_direction_name(action));
        visualize_maze(new_state, title_str, maze, end_position);
        pause(0.3);
        
        agent.state = new_state;
    end
    
    % 显示结果
    if isequal(agent.state, end_position)
        visualize_maze(agent.state, sprintf('到达目标! 总步数: %d', step_count), maze, end_position);
        fprintf('最优路径 (%d 步): ', step_count);
    else
        visualize_maze(agent.state, sprintf('未到达目标! 步数: %d', step_count), maze, end_position);
        fprintf('路径 (%d 步，未到达终点): ', step_count);
    end
    
    for i = 1:length(path)
        fprintf('%s ', path{i});
    end
    fprintf('\n');
end

%% ==================== 显示路径上Q值 ====================
function show_path_q_values(Q_table, init_position, end_position, maze, maze_height, maze_width)
    fprintf('\n╔══════════════════════════════════════════════════════════════════════════════╗\n');
    fprintf('║                    最优路径上每一步的Q值详情                                  ║\n');
    fprintf('╚══════════════════════════════════════════════════════════════════════════════╝\n\n');
    
    state = init_position;
    step = 0;
    visited = zeros(maze_height, maze_width);
    action_names = {'上', '下', '左', '右'};
    
    fprintf('步骤  当前位置   Q(上)      Q(下)      Q(左)      Q(右)     选择动作   下一位置\n');
    fprintf('─────────────────────────────────────────────────────────────────────────────────\n');
    
    while ~isequal(state, end_position) && step < 50
        visited(state(1), state(2)) = visited(state(1), state(2)) + 1;
        
        % 获取Q值
        q_vals = squeeze(Q_table(state(1), state(2), :));
        
        % 选择最优动作
        action = choose_best_action(state, Q_table, maze, maze_height, maze_width, visited);
        
        % 计算下一位置
        new_state = get_next_position(state, action, maze_height, maze_width);
        if maze(new_state(1), new_state(2)) == 1
            new_state = state;
        end
        
        step = step + 1;
        
        % 标记被选中的Q值
        q_strs = cell(1, 4);
        for a = 1:4
            if a == action
                q_strs{a} = sprintf('[%6.2f]', q_vals(a));  % 方括号标记选中的
            else
                q_strs{a} = sprintf(' %6.2f ', q_vals(a));
            end
        end
        
        fprintf(' %2d    (%2d,%2d)  %s  %s  %s  %s   → %s    (%2d,%2d)\n', ...
            step, state(1), state(2), ...
            q_strs{1}, q_strs{2}, q_strs{3}, q_strs{4}, ...
            action_names{action}, new_state(1), new_state(2));
        
        state = new_state;
    end
    
    fprintf('─────────────────────────────────────────────────────────────────────────────────\n');
    fprintf('\n★ 方括号 [ ] 表示被选中的动作（Q值最大的方向）\n');
    fprintf('★ Q值越大 = AI越认为这个方向好\n');
    fprintf('★ 每一步都选Q值最大的方向 → 形成最优路径\n');
end

%% ==================== 选择最优动作（避免循环） ====================
function action = choose_best_action(state, Q_table, maze, maze_height, maze_width, visited)
    q_values = squeeze(Q_table(state(1), state(2), :));
    
    % 对访问过的位置进行惩罚
    directions = [-1,0; 1,0; 0,-1; 0,1];
    adjusted_q = q_values;
    
    for a = 1:4
        next_pos = state + directions(a,:);
        next_pos = max(min(next_pos, [maze_height, maze_width]), [1, 1]);
        
        if maze(next_pos(1), next_pos(2)) == 0
            % 访问次数越多，惩罚越大
            adjusted_q(a) = adjusted_q(a) - visited(next_pos(1), next_pos(2)) * 10;
        else
            adjusted_q(a) = -inf;  % 墙壁
        end
    end
    
    [~, action] = max(adjusted_q);
end

%% ==================== 辅助函数 ====================
function new_state = get_next_position(current_state, action, maze_height, maze_width)
    row = current_state(1);
    col = current_state(2);
    
    switch action
        case 1, row = max(row - 1, 1);           % 上
        case 2, row = min(row + 1, maze_height); % 下
        case 3, col = max(col - 1, 1);           % 左
        case 4, col = min(col + 1, maze_width);  % 右
    end
    
    new_state = [row, col];
end

function direction = get_direction_name(action)
    directions = {'上', '下', '左', '右'};
    direction = directions{action};
end

%% ==================== 可视化迷宫 ====================
function visualize_maze(agent_pos, title_str, maze, end_position)
    figure(1);
    clf;
    
    [m, n] = size(maze);
    img = ones(m, n, 3);
    
    for i = 1:m
        for j = 1:n
            if maze(i,j) == 1
                img(i,j,:) = [0, 0, 0];  % 墙壁 = 黑色
            else
                img(i,j,:) = [1, 1, 1];  % 通道 = 白色
            end
        end
    end
    
    img(end_position(1), end_position(2), :) = [1, 0, 0];  % 目标 = 红色
    img(agent_pos(1), agent_pos(2), :) = [0, 1, 0];        % 智能体 = 绿色
    
    imshow(img, 'InitialMagnification', 'fit');
    axis equal tight;
    title(title_str, 'FontSize', 12);
    
    % 添加网格
    hold on;
    for i = 0.5:1:m+0.5
        plot([0.5, n+0.5], [i, i], 'k-', 'LineWidth', 0.5);
    end
    for j = 0.5:1:n+0.5
        plot([j, j], [0.5, m+0.5], 'k-', 'LineWidth', 0.5);
    end
    hold off;
    
    drawnow;
end
