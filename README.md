# 项目代码详细解释

本仓库包含两个独立项目：一个**生日祝福网页**和一个**Q-Learning 迷宫导航算法**（MATLAB 实现）。以下对每个文件的代码进行详细解释。

---

## 目录

1. [index.html / 25b.html — 生日祝福网页](#indexhtml--25bhtml--生日祝福网页)
2. [q_learning_main.m — Q-Learning 迷宫导航算法](#q_learning_mainm--q-learning-迷宫导航算法)

---

## index.html / 25b.html — 生日祝福网页

> `index.html` 和 `25b.html` 内容完全相同，是一个为"刘雨"制作的生日祝福网页。

### 整体结构

```
页面加载 → 3D旋转立方体动画（3秒） → 淡出立方体，显示生日主页面
                                           ↓
                                    点击"点击继续" 按钮
                                           ↓
                                    显示祝福留言页面
```

### 1. HTML 结构

页面包含三个主要区域：

| 区域 | 元素 ID | 说明 |
|------|---------|------|
| 3D 立方体场景 | `scene3d` | 页面加载时的开场动画，展示一个旋转的 3D 立方体 |
| 生日主页面 | `birthdayPage` | 显示"生日快乐"标题、名字、蛋糕和继续按钮 |
| 祝福留言页面 | `messagePage` | 显示祝福文字和署名，初始隐藏 |

#### 3D 立方体（开场动画）
```html
<div class="scene-3d" id="scene3d">
    <div class="cube-container">
        <div class="cube-face front">🎂</div>  <!-- 前面：蛋糕 -->
        <div class="cube-face back">🎉</div>   <!-- 后面：庆祝 -->
        <div class="cube-face right">🎈</div>  <!-- 右面：气球 -->
        <div class="cube-face left">🎁</div>   <!-- 左面：礼物 -->
        <div class="cube-face top">⭐</div>    <!-- 顶面：星星 -->
        <div class="cube-face bottom">💝</div> <!-- 底面：爱心 -->
    </div>
</div>
```
- 使用 CSS `perspective` 和 `transform-style: preserve-3d` 实现 3D 效果
- `rotateCube` 动画使立方体持续旋转 360°
- 每个面用 `translateZ` / `rotateY` / `rotateX` 定位到立方体的六个面

#### 蛋糕组件
```html
<div class="cake-3d">
    <div class="cake-base">        <!-- 蛋糕底层 -->
        <div class="cake-layer">   <!-- 蛋糕上层 -->
        <div class="candles">      <!-- 蜡烛容器 -->
            <div class="candle"><div class="flame"></div></div>  <!-- 3根蜡烛+火焰 -->
        </div>
    </div>
</div>
```
- 蛋糕有两层，使用渐变色背景
- 3 根蜡烛在顶部，带有闪烁的火焰动画 (`flicker`)
- 点击蛋糕会触发粒子爆炸效果和抖动动画

### 2. CSS 动画详解

| 动画名称 | 作用 | 说明 |
|----------|------|------|
| `gentleRainbow` | 背景色彩变换 | 通过 `hue-rotate` 和 `background-position` 使背景颜色柔和变化 |
| `rotateCube` | 3D 立方体旋转 | 同时绕 X 和 Y 轴旋转 360° |
| `titleGlow` | 标题发光 | 文字阴影变大 + 微微上移放大 |
| `rainbowText` | 彩虹文字 | 渐变背景配合 `background-clip: text` 实现文字颜色流动 |
| `slideInUp` | 向上滑入 | 从下方 50px 滑入并淡入 |
| `fadeInUp` | 淡入上移 | 祝福文字的入场动画 |
| `fadeInScale` | 缩放淡入 | 蛋糕从 scale(0) 放大到 scale(1) |
| `cakeBounce` | 蛋糕弹跳 | 上下浮动 + 微小旋转 |
| `cakeRainbow` | 蛋糕颜色变化 | 渐变色背景位置循环移动 |
| `candleGlow` | 蜡烛发光 | 蜡烛的光晕效果交替变化 |
| `flicker` | 火焰闪烁 | 火焰微小旋转和缩放交替 |
| `particleFloat` | 粒子漂浮 | 粒子从底部浮到顶部并消失 |
| `shimmer` | 微光效果 | 消息容器上的旋转光效 |
| `fireworkBurst` | 烟花效果 | 点击时产生的圆形扩散动画 |
| `cakeShake` | 蛋糕抖动 | 点击蛋糕时左右抖动 |
| `cakeExplosion` | 蛋糕爆炸粒子 | 点击蛋糕时粒子向四周飞散 |

### 3. JavaScript 逻辑详解

#### `createParticles()` — 创建漂浮粒子
```javascript
function createParticles() {
    // 创建60个粒子，每个粒子间隔80ms依次出现
    // 每个粒子：随机水平位置、随机动画延迟、随机持续时间、随机颜色
    // 10秒后自动移除粒子DOM元素（防止内存泄漏）
}
```

#### `showMessagePage()` — 显示祝福页面
```javascript
function showMessagePage() {
    // 1. 隐藏生日主页面 (birthdayPage)
    // 2. 显示留言页面 (messagePage)
    // 3. 创建新一波粒子效果
}
```

#### `setupCakeInteraction()` — 蛋糕交互
```javascript
function setupCakeInteraction() {
    // 点击蛋糕时：
    // 1. 创建20个粒子，沿圆形方向飞散（角度=360°/20 * i）
    // 2. 每个粒子飞行距离100-150px
    // 3. 蛋糕先停止当前动画，然后播放抖动动画
    // 4. 粒子1秒后自动移除
}
```

#### 页面加载流程 (`window.onload`)
```
0秒：页面加载，显示3D旋转立方体
3秒：立方体淡出 (opacity → 0)，主内容淡入
3.5秒：设置蛋糕点击交互
同时：每10秒自动创建一波新粒子
```

#### 点击烟花效果
```javascript
document.addEventListener('click', function(e) {
    // 页面任意位置点击都会在鼠标位置产生8个彩色圆形
    // 圆形从小到大扩散并消失（fireworkBurst动画）
    // 每个圆形间隔40ms出现，0.8秒后移除
});
```

#### 触摸事件处理
```javascript
// touchstart: 记录触摸起始Y坐标
// touchmove: 阻止默认滚动行为（保持页面固定）
```

### 4. 响应式设计

在屏幕宽度 ≤ 768px（移动设备）时：
- 标题字号：3.5rem → 2.5rem
- 名字字号：4rem → 3rem
- 祝福文字：2rem → 1.5rem
- 消息文字：1.8rem → 1.4rem
- 立方体尺寸：200px → 150px

---

## q_learning_main.m — Q-Learning 迷宫导航算法

### 算法概述

Q-Learning 是一种**无模型**的强化学习算法。智能体（Agent）在迷宫中通过不断试错来学习每个位置-动作对的价值（Q 值），最终找到从起点到终点的最优路径。

### 核心公式

**Bellman 方程（Q 值更新）：**

```
Q(s, a) ← Q(s, a) + α × [R + γ × max Q(s', a') - Q(s, a)]
```

| 符号 | 含义 | 代码变量 |
|------|------|----------|
| Q(s, a) | 状态 s 下执行动作 a 的价值 | `Q_table(row, col, action)` |
| α | 学习率 (0.1) | `learning_rate` |
| R | 即时奖励 | `reward` |
| γ | 折扣因子 (0.9) | `discount_factor` |
| max Q(s', a') | 下一状态的最大 Q 值 | `max_future_q` |

### 代码结构

```
q_learning_main()           ← 主函数
├── 参数设置                  ← 超参数定义
├── 迷宫设置                  ← 15×15迷宫矩阵
├── Q-Learning训练循环         ← 500轮训练
├── run_optimal_path()        ← 运行并可视化最优路径
├── show_path_q_values()      ← 打印路径上每一步的Q值
├── choose_best_action()      ← 选择最优动作（避免循环）
├── get_next_position()       ← 计算下一位置
├── get_direction_name()      ← 动作编号转方向名
└── visualize_maze()          ← 可视化迷宫
```

### 详细代码解释

#### 1. 参数设置

```matlab
episodes = 500;        % 训练轮数：智能体完整走一次迷宫算一轮
epsilon = 0.1;         % 探索率：10%概率随机走（探索未知），90%概率选最优（利用已知）
learning_rate = 0.1;   % 学习率：新经验对Q值的影响权重
discount_factor = 0.9; % 折扣因子：未来奖励的衰减系数（越接近1越重视长远收益）
```

#### 2. 迷宫定义

```
15×15矩阵，1=墙壁，0=通道：
■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■
■ S · · ■ · · · · · ■ · · · ■    S = 起点 (2,2)
■ · ■ · ■ · ■ ■ ■ · · · ■ · ■    E = 终点 (14,14)
■ · ■ · · · · · · · ■ · ■ · ■
■ · ■ ■ ■ ■ · ■ ■ · ■ · · · ■
■ · · · · · · · · · · · ■ · ■
■ ■ ■ · ■ ■ ■ · ■ ■ ■ · ■ · ■
■ · · · · · · · · · · · · · ■
■ · ■ ■ · ■ ■ ■ · ■ · ■ ■ · ■
■ · · · · · · ■ · · · · · · ■
■ ■ · ■ ■ ■ · · · ■ ■ ■ · ■ ■
■ · · · · · · ■ · · · · · · ■
■ · ■ ■ · ■ · ■ ■ · ■ · ■ · ■
■ · · · · · · · · · · · · E ■
■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■ ■
```

#### 3. Q 值表

```matlab
Q_table = zeros(maze_height, maze_width, 4);
% 三维矩阵：15 × 15 × 4
% 第1维：行（y坐标）
% 第2维：列（x坐标）
% 第3维：4个动作（上=1, 下=2, 左=3, 右=4）
% Q_table(3, 5, 2) 表示"在位置(3,5)向下走的价值"
% 初始全为0，训练过程中逐步更新
```

#### 4. Q-Learning 训练循环

```matlab
for episode = 1:500           % 每一轮（episode）：
    agent.state = init_position;   % 重置到起点
    steps = 0;

    while ~isequal(agent.state, end_position)  % 直到到达终点

        % ===== ε-贪婪策略选择动作 =====
        if rand() < 0.1              % 10% 概率：随机选动作（探索）
            action = randi(4);       % 随机选1-4
        else                         % 90% 概率：选Q值最大的动作（利用）
            [~, action] = max(Q_table(row, col, :));
        end

        % ===== 执行动作，计算奖励 =====
        new_state = get_next_position(...);  % 根据动作计算新位置
        if 撞墙:       reward = -10;   new_state = 原位;  % 惩罚，不移动
        elseif 到终点:  reward = 100;                      % 大奖励
        else:           reward = -1;                        % 小惩罚（鼓励走短路）

        % ===== Q值更新（核心） =====
        current_q = Q_table(当前位置, 动作);           % 旧Q值
        max_future_q = max(Q_table(新位置, :));        % 新位置最大Q值
        new_q = current_q + 0.1 * (reward + 0.9 * max_future_q - current_q);
        Q_table(当前位置, 动作) = new_q;               % 写回Q表

        agent.state = new_state;   % 移动到新位置
        steps = steps + 1;
        if steps > 1000: break;    % 安全阀，防止死循环
    end
end
```

**训练过程直觉理解：**
- 初始时 Q 表全为 0，智能体随机乱走
- 当偶然到达终点（获得 +100 奖励），终点附近的 Q 值变大
- 下次经过终点附近时，会倾向于走向 Q 值大的方向
- 奖励信号像"水波"一样从终点向起点反向传播
- 经过 500 轮训练，Q 表形成了一个"梯度场"，沿 Q 值最大方向即为最优路径

#### 5. `run_optimal_path()` — 运行最优路径

```matlab
function run_optimal_path(...)
    % 训练完成后，用学到的Q表运行最优路径
    % 每一步选择 Q 值最大的动作（贪婪策略，不再随机探索）
    % 使用 visited 矩阵记录访问次数，避免陷入循环
    % 每步可视化迷宫，pause(0.3) 形成动画效果
    % 最终打印完整路径（如：下 下 右 右 下 右 ...）
end
```

#### 6. `choose_best_action()` — 避免循环的动作选择

```matlab
function action = choose_best_action(state, Q_table, maze, ..., visited)
    q_values = Q_table(当前位置, :);     % 4个方向的Q值
    adjusted_q = q_values;

    for 每个方向:
        next_pos = 计算下一位置;
        if 下一位置是通道:
            adjusted_q(方向) -= visited(下一位置) * 10;
            % 访问过的位置Q值减少，避免反复走同一条路
        else:
            adjusted_q(方向) = -inf;  % 墙壁方向永远不选
        end
    end

    action = argmax(adjusted_q);  % 选调整后Q值最大的方向
end
```

**为什么需要这个函数？**  
纯贪婪策略可能导致在两个位置间来回走（A→B→A→B...）。通过对已访问位置施加惩罚，强制智能体探索新路径。

#### 7. `show_path_q_values()` — 展示路径上的 Q 值

```
输出格式：
步骤  当前位置   Q(上)      Q(下)      Q(左)      Q(右)     选择动作   下一位置
─────────────────────────────────────────────────────────────────────────────────
  1    ( 2, 2)  -1.23   [ 5.67]   -0.89     3.45    → 下      ( 3, 2)
  2    ( 3, 2)  -2.10     4.56    -1.00   [ 6.78]   → 右      ( 3, 3)
  ...
```
- 方括号 `[ ]` 标记被选中的动作（Q 值最大）
- 帮助理解智能体在每一步的"思考过程"

#### 8. `get_next_position()` — 位置计算

```matlab
function new_state = get_next_position(current_state, action, maze_height, maze_width)
    % action=1(上): 行号-1，不小于1
    % action=2(下): 行号+1，不超过maze_height
    % action=3(左): 列号-1，不小于1
    % action=4(右): 列号+1，不超过maze_width
    % 使用 max/min 确保不越界
end
```

#### 9. `visualize_maze()` — 迷宫可视化

```matlab
function visualize_maze(agent_pos, title_str, maze, end_position)
    % 创建 15×15×3 的RGB图像：
    %   墙壁 (1) → 黑色 [0,0,0]
    %   通道 (0) → 白色 [1,1,1]
    %   终点    → 红色 [1,0,0]
    %   智能体  → 绿色 [0,1,0]
    %
    % 使用 imshow 显示图像
    % 绘制网格线帮助区分每个格子
end
```

### 奖励机制总结

| 情况 | 奖励值 | 目的 |
|------|--------|------|
| 撞墙 | -10 | 强烈惩罚，让智能体学会避开墙壁 |
| 到达终点 | +100 | 大奖励，引导智能体走向目标 |
| 正常移动 | -1 | 轻微惩罚，鼓励走最短路径（步数越少总惩罚越小） |

### 关键概念

- **ε-贪婪策略**：平衡"探索"（发现新路径）和"利用"（使用已知最优路径），ε=0.1 意味着 90% 的时间走最优路线，10% 的时间随机尝试
- **Q 值传播**：终点的高奖励通过 Bellman 方程逐步传播到前面的状态，形成一个从起点到终点的"价值梯度"
- **折扣因子 γ=0.9**：距离终点越远，累积折扣越大（如 10 步外的 100 分只值 100×0.9¹⁰≈34.9 分），促使智能体选择最短路径
