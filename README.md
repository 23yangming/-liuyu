# 🎂 刘雨生日快乐 — 代码说明

本仓库包含一个互动式生日祝福网页，专为 **刘雨** 制作。以下是对代码的详细解释。

## 文件结构

| 文件 | 说明 |
|------|------|
| `index.html` | 主页面，包含完整的 HTML + CSS + JavaScript |
| `25b.html` | 与 `index.html` 内容完全一致的副本 |

## 页面整体流程

1. **3D 立方体开场动画**：页面加载后，屏幕中央会显示一个旋转的 3D 立方体，六个面分别展示 🎂🎉🎈🎁⭐💝 表情。
2. **3 秒后过渡**：立方体淡出，主内容（生日祝福页）淡入。
3. **生日祝福页**：显示「生日快乐」标题、姓名「刘雨」、祝福语，以及一个带蜡烛和火焰的 CSS 蛋糕。
4. **点击「点击继续」按钮**：切换到寄语页面，展示一段友情寄语，署名「马阳明」。

## CSS 部分详解

### 背景动画 (`gentleRainbow`)
```css
background: linear-gradient(135deg, #ff9a9e, #fecfef, #a8e6cf, #88d8c0, #78c2ad);
animation: gentleRainbow 8s ease infinite;
```
使用多色渐变背景，通过 `background-position` 和 `hue-rotate` 滤镜实现柔和的彩虹色循环动画。

### 3D 立方体 (`.cube-container` / `.cube-face`)
通过 CSS 3D 变换 (`transform-style: preserve-3d`、`perspective`、`translateZ`、`rotateX/Y`) 创建一个真实的 3D 立方体，并以 `rotateCube` 动画让它持续旋转。

### 生日标题动画 (`.birthday-title` / `.name-highlight`)
- 标题使用 `titleGlow` 动画实现发光缩放效果。
- 姓名使用 `rainbowText` 动画实现渐变色文字流动效果（通过 `-webkit-background-clip: text`）。

### CSS 蛋糕 (`.cake-3d`)
纯 CSS 绘制的蛋糕，包含：
- **蛋糕底座** (`.cake-base`)：渐变色圆角矩形。
- **蛋糕层** (`.cake-layer`)：叠加在底座上方。
- **蜡烛** (`.candle`)：三根金色小蜡烛。
- **火焰** (`.flame`)：使用径向渐变和 `flicker` 动画模拟烛火闪烁。
- 蛋糕整体有 `cakeBounce` 弹跳动画。

### 寄语容器 (`.message-container`)
半透明毛玻璃效果（`backdrop-filter: blur`），带有旋转的 `shimmer` 光芒动画和滑入过渡效果。

### 粒子效果 (`.particle`)
8 种柔和颜色的圆形粒子，使用 `particleFloat` 动画从屏幕底部飘升到顶部。

### 响应式设计 (`@media`)
在屏幕宽度 ≤768px 时缩小字体和立方体尺寸，适配移动端。

## JavaScript 部分详解

### `createParticles()`
动态创建 60 个彩色粒子 `<div>`，随机分布在页面上，每个粒子 10 秒后自动移除。页面加载后每 10 秒循环调用一次。

### `showMessagePage()`
点击「点击继续」按钮时调用：隐藏生日页面，显示寄语页面，并触发一波粒子动画。

### `setupCakeInteraction()`
为蛋糕添加点击交互——点击蛋糕时会产生 20 个粒子呈圆形向外爆炸扩散，蛋糕本身播放抖动动画。

### 页面加载逻辑 (`window.onload`)
页面加载 → 等待 3 秒 → 淡出 3D 立方体 → 淡入主内容 → 启动粒子 → 设置蛋糕交互

### 点击烟花效果
在页面任意位置点击，都会产生 8 个彩色圆点以 `fireworkBurst` 动画向外扩散消失，模拟烟花效果。

### 动态样式注入
通过 JavaScript 创建 `<style>` 元素，注入 `fireworkBurst`、`cakeShake`、`cakeExplosion` 三个交互动画的关键帧定义。

## 技术栈

- **纯 HTML/CSS/JavaScript**，无任何外部依赖
- **CSS 3D 变换**：立方体旋转效果
- **CSS 动画 (`@keyframes`)**：渐变背景、粒子飘浮、火焰闪烁等
- **CSS 毛玻璃效果** (`backdrop-filter: blur`)
- **JavaScript DOM 操作**：动态创建粒子、处理点击交互
