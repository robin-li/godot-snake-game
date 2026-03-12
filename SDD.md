# 系統設計文件 (SDD) - Godot Snake Game

## 1. 架構概述

### 1.1 系統架構圖

```
┌──────────────────────────────────────────────┐
│           主場景 (Main.tscn)                  │
│                                              │
│ ┌───────────────────────────────────────┐   │
│ │      Game Manager (game_manager.gd)   │   │
│ │  • 統管遊戲狀態                       │   │
│ │  • 管理分數                           │   │
│ │  • 協調 Snake 和 Food                 │   │
│ └───────────────────────────────────────┘   │
│         ↑                    ↑               │
│         │                    │               │
│ ┌───────┴──────┐  ┌────────┴──────┐        │
│ │ Snake Node   │  │  Food Node    │        │
│ │ (snake.gd)   │  │  (food.gd)    │        │
│ │ • 蛇邏輯     │  │ • 食物邏輯    │        │
│ │ • 碰撞檢測   │  │ • 隨機生成    │        │
│ │ • 移動管理   │  │               │        │
│ └──────────────┘  └───────────────┘        │
│                                              │
│ ┌───────────────────────────────────────┐   │
│ │           UI (CanvasLayer)            │   │
│ │ • ScoreLabel (分數標籤)              │   │
│ │ • GameOverLabel (結束提示)           │   │
│ └───────────────────────────────────────┘   │
│                                              │
│ ┌───────────────────────────────────────┐   │
│ │        Game Area (ColorRect)          │   │
│ │     • 遊戲區域背景視覺化              │   │
│ └───────────────────────────────────────┘   │
└──────────────────────────────────────────────┘
```

### 1.2 系統交互流程

```
[Input Handler]
      ↓
[Snake.handle_input()]
      ↓
[Update next_direction]
      ↓
[Snake._physics_process()]
      ↓
[Snake.move_snake()]
      ├─→ [檢查邊界碰撞]
      │   └─→ [遊戲結束]
      ├─→ [檢查自身碰撞]
      │   └─→ [遊戲結束]
      ├─→ [檢查食物碰撞]
      │   ├─→ [Food.respawn()]
      │   └─→ [GameManager.update_score()]
      └─→ [queue_redraw()]
```

---

## 2. 核心組件設計

### 2.1 Game Manager (game_manager.gd)

#### 2.1.1 職責

遊戲狀態管理和全局控制。

#### 2.1.2 屬性 (Properties)

```gdscript
# 遊戲狀態變量
var score: int = 0                    # 當前分數

# 節點引用
var snake: Node2D                     # Snake 節點
var food: Node2D                      # Food 節點
var game_over_label: Label            # 遊戲結束標籤
var score_label: Label                # 分數標籤
```

#### 2.1.3 方法 (Methods)

| 方法名 | 參數 | 返回值 | 說明 |
|--------|------|--------|------|
| `_ready()` | 無 | void | 初始化遊戲，獲取節點引用，設置窗口大小 |
| `_process(_delta)` | delta: float | void | 每幀調用，檢查重啟輸入 |
| `update_score()` | 無 | void | 分數加 10，更新分數標籤 |
| `update_score_label()` | 無 | void | 刷新分數標籤文字 |
| `show_game_over()` | 無 | void | 顯示遊戲結束提示 |
| `reset_game()` | 無 | void | 重置遊戲狀態 |

#### 2.1.4 初始化流程

```gdscript
func _ready():
    # 1. 獲取子節點引用
    snake = $Snake
    food = $Food
    game_over_label = $UI/GameOverLabel
    score_label = $UI/ScoreLabel
    
    # 2. 設置窗口大小 (800x600)
    get_window().size = Vector2i(800, 600)
    
    # 3. 初始化分數顯示
    update_score_label()
```

#### 2.1.5 遊戲循環

```gdscript
func _process(_delta):
    # 當遊戲結束且玩家按下 SPACE 時重啟
    if game_over_label.visible and Input.is_action_pressed("ui_select"):
        reset_game()
```

### 2.2 Snake (snake.gd)

#### 2.2.1 職責

管理蛇的移動、碰撞檢測、繪製和狀態。

#### 2.2.2 屬性 (Properties)

```gdscript
# 遊戲常量
const GRID_SIZE = 20                      # 格子大小 (像素)
const BODY_COLOR = Color.LIGHT_GREEN      # 蛇身顏色
const HEAD_COLOR = Color.GREEN            # 蛇頭顏色

# 遊戲狀態
var body_segments = []                    # Vector2i 數組，蛇身位置
var direction = Vector2i(1, 0)            # 當前方向 (初始向右)
var next_direction = Vector2i(1, 0)       # 下一個方向 (輸入緩沖)
var game_over = false                     # 遊戲是否結束
```

#### 2.2.3 方法 (Methods)

| 方法名 | 參數 | 返回值 | 說明 |
|--------|------|--------|------|
| `_ready()` | 無 | void | 初始化蛇的身體 |
| `_process(_delta)` | delta: float | void | 每幀處理玩家輸入 |
| `_physics_process(_delta)` | delta: float | void | 物理刻度，調用移動邏輯 |
| `handle_input()` | 無 | void | 讀取方向鍵輸入，更新 next_direction |
| `move_snake()` | 無 | void | 蛇移動一格，碰撞檢測 |
| `draw_snake()` | 無 | void | 繪製蛇身和蛇頭 |
| `_draw()` | 無 | void | Godot 繪製回調 |
| `trigger_game_over()` | 無 | void | 遊戲結束處理 |
| `reset()` | 無 | void | 重置蛇的狀態 |

#### 2.2.4 詳細方法實現

##### 2.2.4.1 初始化 (_ready)

```gdscript
func _ready():
    # 初始化蛇為 3 段，位置為 (10,10), (9,10), (8,10)
    body_segments = [
        Vector2i(10, 10),  # 蛇頭
        Vector2i(9, 10),   # 身體段 1
        Vector2i(8, 10)    # 身體段 2
    ]
```

初始蛇身佈局：
```
方向 → (向右)
(10,10) ← (9,10) ← (8,10)
  蛇頭    身體1    身體2
```

##### 2.2.4.2 輸入處理 (handle_input)

```gdscript
func handle_input():
    # 讀取方向鍵輸入
    # 防止 180 度反向（方向碰撞檢查）
    
    if Input.is_action_pressed("ui_right") and direction != Vector2i(-1, 0):
        next_direction = Vector2i(1, 0)   # 向右
    elif Input.is_action_pressed("ui_left") and direction != Vector2i(1, 0):
        next_direction = Vector2i(-1, 0)  # 向左
    elif Input.is_action_pressed("ui_down") and direction != Vector2i(0, -1):
        next_direction = Vector2i(0, 1)   # 向下
    elif Input.is_action_pressed("ui_up") and direction != Vector2i(0, 1):
        next_direction = Vector2i(0, -1)  # 向上
```

**反向邏輯**：
- 當 direction = (1, 0)（向右）時，防止 next_direction = (-1, 0)（向左）
- 這防止蛇在轉向時意外反向

##### 2.2.4.3 移動邏輯 (move_snake)

```gdscript
func move_snake():
    # 1. 應用方向輸入
    direction = next_direction
    
    # 2. 計算新蛇頭位置
    var new_head = body_segments[0] + direction
    
    # 3. 邊界碰撞檢查 (X: [0,39], Y: [0,29])
    if new_head.x < 0 or new_head.x >= 40 or new_head.y < 0 or new_head.y >= 30:
        trigger_game_over()
        return
    
    # 4. 自身碰撞檢查
    if new_head in body_segments:
        trigger_game_over()
        return
    
    # 5. 添加新蛇頭
    body_segments.insert(0, new_head)
    
    # 6. 檢查食物碰撞
    if get_parent().food.position_grid == new_head:
        # 吃到食物：蛇增長，食物重生，分數 +10
        get_parent().food.respawn()
        get_parent().update_score()
    else:
        # 未吃到食物：移除蛇尾
        body_segments.pop_back()
    
    # 7. 請求重繪
    queue_redraw()
```

**邊界檢查**：
- X 軸範圍：0 ～ 39（共 40 格）
- Y 軸範圍：0 ～ 29（共 30 格）

**碰撞優先級**：邊界優先於自身，若同時觸發邊界和自身，邊界先檢查

##### 2.2.4.4 渲染 (draw_snake & _draw)

```gdscript
func draw_snake():
    # 蛇頭（綠色，更亮）
    var head_pos = body_segments[0] * GRID_SIZE + Vector2(GRID_SIZE / 2, GRID_SIZE / 2)
    draw_circle(head_pos, GRID_SIZE / 2 - 1, HEAD_COLOR)
    
    # 蛇身（淺綠色）
    for i in range(1, body_segments.size()):
        var segment_pos = body_segments[i] * GRID_SIZE + Vector2(GRID_SIZE / 2, GRID_SIZE / 2)
        draw_circle(segment_pos, GRID_SIZE / 2 - 1, BODY_COLOR)

func _draw():
    draw_snake()
```

**位置計算**：
- 網格位置 × 格子大小 + 半個格子大小 = 視覺中心位置
- 例：grid (10,10) → pixel (200+10, 200+10) = (210, 210)

### 2.3 Food (food.gd)

#### 2.3.1 職責

食物生成、位置管理和繪製。

#### 2.3.2 屬性 (Properties)

```gdscript
# 常量
const GRID_SIZE = 20                  # 格子大小
const FOOD_COLOR = Color.RED          # 食物顏色

# 狀態
var position_grid = Vector2i(15, 10)  # 食物網格位置
var rng = RandomNumberGenerator.new() # 隨機數生成器
```

#### 2.3.3 方法 (Methods)

| 方法名 | 參數 | 返回值 | 說明 |
|--------|------|--------|------|
| `_ready()` | 無 | void | 初始化 RNG，生成初始食物 |
| `respawn()` | 無 | void | 隨機生成新食物位置 |
| `draw_food()` | 無 | void | 繪製食物圓形 |
| `_draw()` | 無 | void | Godot 繪製回調 |

#### 2.3.4 詳細實現

##### 2.3.4.1 初始化

```gdscript
func _ready():
    rng.randomize()    # 初始化隨機數生成器
    respawn()          # 首次生成食物
```

##### 2.3.4.2 隨機生成

```gdscript
func respawn():
    var snake_body = get_parent().snake.body_segments
    var valid_position = false
    
    while not valid_position:
        # 隨機生成 X (0-39) 和 Y (0-29)
        position_grid = Vector2i(
            rng.randi_range(0, 39),
            rng.randi_range(0, 29)
        )
        
        # 檢查是否被蛇佔據
        if position_grid not in snake_body:
            valid_position = true
    
    queue_redraw()
```

**算法複雜度**：
- 平均情況：O(1) （蛇身較小時）
- 最壞情況：O(n)（蛇身佔據大量空間時，n = 蛇身長度）

---

## 3. 數據結構設計

### 3.1 蛇身存儲

```gdscript
# 結構：數組 (Array)
var body_segments = []  # 由多個 Vector2i 組成

# 示例狀態
body_segments = [
    Vector2i(10, 10),  # index 0, 蛇頭
    Vector2i(9, 10),   # index 1
    Vector2i(8, 10)    # index 2, 蛇尾
]

# 操作
body_segments.insert(0, new_head)      # 添加新蛇頭
body_segments.pop_back()               # 移除蛇尾
```

### 3.2 方向向量

```gdscript
# 四個方向用 Vector2i 表示
direction = Vector2i(1, 0)   # 向右 (右 +1)
direction = Vector2i(-1, 0)  # 向左 (左 -1)
direction = Vector2i(0, 1)   # 向下 (下 +1)
direction = Vector2i(0, -1)  # 向上 (上 -1)
```

---

## 4. 場景結構 (Scene Hierarchy)

### 4.1 場景樹

```
Main (Node2D) [game_manager.gd]
├── GameArea (ColorRect)
│   ├── 背景顏色：RGB(0.1, 0.1, 0.15)
│   └── 邊距：20px
├── Snake (Node2D) [snake.gd]
├── Food (Node2D) [food.gd]
└── UI (CanvasLayer)
    ├── ScoreLabel (Label)
    │   ├── 位置：左上 (10,10)
    │   ├── 字號：32px
    │   └── 內容：「Score: XXX」
    └── GameOverLabel (Label)
        ├── 位置：中央 (25%-75%, 40%-60%)
        ├── 字號：48px
        └── 內容：「GAME OVER\nPress SPACE to restart」
```

### 4.2 節點參數

#### Main (Node2D)

```
位置 (Position): (0, 0)
旋轉 (Rotation): 0
縮放 (Scale): (1, 1)
```

#### GameArea (ColorRect)

```
Anchors: Full Rect (0,0 → 1,1)
Offsets: left=20, top=20, right=-20, bottom=-20
Color: RGB(0.1, 0.1, 0.15, 1)
```

#### Snake (Node2D)

```
位置 (Position): (0, 0)
旋轉 (Rotation): 0
縮放 (Scale): (1, 1)
[連接 snake.gd 腳本]
```

#### Food (Node2D)

```
位置 (Position): (0, 0)
旋轉 (Rotation): 0
縮放 (Scale): (1, 1)
[連接 food.gd 腳本]
```

#### UI (CanvasLayer)

```
層級 (Layer): 1 (在遊戲上方)
```

---

## 5. 系統流程

### 5.1 遊戲初始化流程

```
1. Godot 引擎啟動
   ↓
2. 加載 Main.tscn 場景
   ↓
3. Main._ready() 執行
   - 窗口大小設為 800×600
   - 獲取 Snake, Food, UI 節點
   - 初始化分數顯示
   ↓
4. Snake._ready() 執行
   - 初始化蛇身為 [(10,10), (9,10), (8,10)]
   ↓
5. Food._ready() 執行
   - 隨機生成食物位置（例如 (15,10)）
   ↓
6. 遊戲進入主循環 [遊戲運行]
```

### 5.2 每幀循環

```
每幀 (_process):
  └─ Main._process()
     └─ 檢查重啟輸入

每物理幀 (_physics_process, 10 FPS):
  ├─ Snake._process()
  │  └─ handle_input() [讀取方向鍵]
  │
  ├─ Snake._physics_process()
  │  └─ move_snake()
  │     ├─ 計算新蛇頭
  │     ├─ 邊界檢查
  │     ├─ 自身碰撞檢查
  │     ├─ 食物碰撞檢查
  │     └─ queue_redraw()
  │
  └─ _draw() [渲染蛇和食物]
```

### 5.3 遊戲結束流程

```
move_snake() 檢測到碰撞
  ↓
trigger_game_over()
  ├─ game_over = true (蛇停止移動)
  ├─ get_parent().show_game_over()
  │  └─ game_over_label.visible = true
  └─ 遊戲暫停，等待玩家輸入
  
玩家按 SPACE
  ↓
Main._process() 檢測到輸入
  ↓
reset_game()
  ├─ score = 0
  ├─ game_over_label.visible = false
  ├─ snake.reset()
  │  ├─ body_segments = [(10,10), (9,10), (8,10)]
  │  ├─ direction = (1,0)
  │  └─ game_over = false
  ├─ food.respawn()
  └─ 返回 [遊戲運行]
```

---

## 6. 性能設計

### 6.1 計算複雜度

| 操作 | 複雜度 | 說明 |
|------|--------|------|
| move_snake() | O(n) | n = 蛇身長度，用於碰撞檢查 |
| food.respawn() | O(1) avg | 隨機生成，平均 O(1) |
| draw_snake() | O(n) | 繪製 n 個身體段 |
| draw_food() | O(1) | 繪製單個圓形 |

### 6.2 內存占用

| 組件 | 估算內存 |
|------|--------|
| body_segments (1200 段) | ~48 KB |
| 其他狀態變量 | <1 KB |
| **總計** | **<50 MB** |

### 6.3 優化建議

- 使用 `queue_redraw()` 代替 `update()` 以減少不必要的重繪
- 避免在物理循環中進行複雜計算
- 蛇身長度到達極限時考慮使用池化 (Object Pooling)

---

## 7. 擴展性設計

### 7.1 預留的擴展點

#### 難度系統

```gdscript
# 預留：在 GameManager 中添加
enum Difficulty { EASY, NORMAL, HARD }
var current_difficulty = Difficulty.NORMAL

var physics_tick_rates = {
    Difficulty.EASY: 5,     # 5 FPS
    Difficulty.NORMAL: 10,  # 10 FPS
    Difficulty.HARD: 15     # 15 FPS
}
```

#### 道具系統

```gdscript
# 預留：增加 PowerUp 節點
var active_powerups = []

func apply_powerup(type: String):
    match type:
        "SLOW": physics_tick_rates[current_difficulty] = 3
        "INVINCIBLE": snake.invincible = true
        "DOUBLE_SCORE": score_multiplier = 2
```

#### 高分榜

```gdscript
# 預留：本地存儲
var high_scores = []

func save_high_score(name: String, score: int):
    high_scores.append({"name": name, "score": score})
    high_scores.sort_custom(func(a, b): return a.score > b.score)
```

---

## 8. 錯誤處理

### 8.1 邊界情況

| 情況 | 處理方式 |
|------|---------|
| 蛇身長度 = 1200（滿格） | 遊戲繼續，蛇無法移動 |
| 輸入與當前方向衝突 | 忽略輸入 |
| 多個輸入同時按下 | 讀取最後一個輸入 |
| 食物生成失敗（蛇滿格） | 無限循環，需要手動重啟 |

### 8.2 日誌與調試

```gdscript
# 預留調試輸出
func debug_log(msg: String):
    if OS.is_debug_build():
        print("[Snake Game] ", msg)
```

---

## 9. 版本記錄

| 版本 | 日期 | 變更 |
|------|------|------|
| 1.0 | 2026-03-12 | 初版發佈 |

---

**文件版本**：1.0  
**最後更新**：2026-03-12  
**系統設計師**：Godot Snake Game Team
