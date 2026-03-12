# 安裝與部署指南 (INSTALL) - Godot Snake Game

## 1. 系統需求

### 1.1 最低配置

| 組件 | 最低配置 | 推薦配置 |
|------|---------|--------|
| **CPU** | Intel Core i5 / Ryzen 5 | Intel Core i7 / Ryzen 7 |
| **內存 (RAM)** | 4 GB | 8 GB+ |
| **硬盤空間** | 2 GB (Godot) + 100 MB (遊戲) | 5 GB+ |
| **顯卡** | 集成顯卡 (Intel UHD / AMD Radeon) | 專業顯卡 (NVIDIA/AMD) |
| **屏幕** | 1280×720 (最小) | 1920×1080+ |
| **網絡** | 無需（本地遊戲） | - |

### 1.2 操作系統支持

| 操作系統 | 版本 | 支持狀態 |
|---------|------|--------|
| **Windows** | 10, 11 | ✓ 完全支持 |
| **macOS** | 10.15+ | ✓ 完全支持 |
| **Linux** | Ubuntu 20.04+ | ✓ 完全支持 |

### 1.3 Godot 引擎版本

| 版本 | 支持狀態 | 備註 |
|------|--------|------|
| Godot 4.1.x | ✓ 完全支持 | 推薦版本 |
| Godot 4.2.x | ✓ 完全支持 | 推薦版本 |
| Godot 4.3.x | ✓ 完全支持 | 推薦版本 |
| Godot 3.x | ✗ 不支持 | 使用 GDScript 2.0 |

### 1.4 依賴項

此項目為**純 Godot** 遊戲，**無外部依賴**。

- ❌ 無需 Python
- ❌ 無需 Node.js
- ❌ 無需 C++ 編譯環境
- ✓ 僅需 Godot Engine 4.1+

---

## 2. 安裝步驟

### 2.1 前置準備

#### 2.1.1 安裝 Godot Engine

##### Windows

1. 訪問 [Godot 官方網站](https://godotengine.org/download)
2. 下載 **Godot 4.1+**（Standard 版本）
3. 解壓到自選目錄（例如 `C:\Program Files\Godot`)
4. 運行 `Godot.exe`（無需安裝）

##### macOS

1. 訪問 [Godot 官方網站](https://godotengine.org/download)
2. 下載 **Godot 4.1+ (macOS)**
3. 打開 `.dmg` 文件
4. 將 `Godot.app` 拖至 `Applications` 文件夾
5. 從應用程序啟動 Godot

##### Linux (Ubuntu 20.04+)

```bash
# 方法 1：使用包管理器
sudo apt update
sudo apt install godot4

# 方法 2：手動下載
wget https://github.com/godotengine/godot-releases/releases/download/4.1.3-stable/Godot_v4.1.3-stable_linux.x86_64
chmod +x Godot_v4.1.3-stable_linux.x86_64
./Godot_v4.1.3-stable_linux.x86_64
```

#### 2.1.2 安裝 Git (可選但推薦)

如果需要克隆或提交代碼：

##### Windows

```bash
# 使用 Chocolatey
choco install git

# 或訪問 https://git-scm.com/download/win
```

##### macOS

```bash
# 使用 Homebrew
brew install git

# 或訪問 https://git-scm.com/download/mac
```

##### Linux

```bash
sudo apt install git
```

---

### 2.2 克隆或下載項目

#### 方法 A：使用 Git 克隆（推薦）

```bash
# 打開終端/命令提示符，進入目標目錄
cd ~/Documents

# 克隆項目
git clone https://github.com/yourusername/godot-snake-game.git

# 進入項目目錄
cd godot-snake-game
```

#### 方法 B：手動下載

1. 訪問 [GitHub 倉庫](https://github.com/yourusername/godot-snake-game)
2. 點擊 **Code → Download ZIP**
3. 解壓 ZIP 文件到選定目錄

---

### 2.3 在 Godot 中打開項目

#### 步驟 1：啟動 Godot Editor

- **Windows/Linux**：雙擊 `Godot.exe` 或執行 `./godot`
- **macOS**：打開 `Godot.app`

#### 步驟 2：打開項目

1. 在 Godot 啟動屏幕，點擊 **Open**
2. 導航到項目文件夾（包含 `project.godot` 的目錄）
3. 點擊 **Select Current Folder**
4. Godot 開始加載項目（首次加載可能需要 10-30 秒）

#### 步驟 3：驗證項目加載

- 左側文件面板應顯示：
  ```
  res://
  ├── project.godot
  ├── main.tscn
  ├── snake.gd
  ├── food.gd
  ├── game_manager.gd
  ├── PRD.md
  ├── GDD.md
  ├── SDD.md
  ├── TEST_PLAN.md
  └── INSTALL.md
  ```

---

## 3. 運行遊戲

### 3.1 在 Godot Editor 中運行

#### 步驟 1：打開主場景

在左側文件面板中，雙擊 `main.tscn` 打開主場景

#### 步驟 2：運行遊戲

- **快捷鍵**：按 `F5` 或 `Ctrl+F5`
- **菜單**：點擊 **Run → Play** 或 **Run → Play Scene**

#### 步驟 3：遊戲窗口

遊戲應在新窗口中啟動，顯示：
- 黑色背景遊戲區域
- 左上角：「Score: 0」
- 綠色蛇（3 段）
- 紅色食物

#### 步驟 4：控制遊戲

| 操作 | 按鍵 |
|------|------|
| 向上 | ↑ 或 W |
| 向下 | ↓ 或 S |
| 向左 | ← 或 A |
| 向右 | → 或 D |
| 重啟 | SPACE |
| 停止遊戲 | ESC |

#### 步驟 5：停止遊戲

- 按 **ESC** 或關閉遊戲窗口

### 3.2 構建獨立可執行文件

#### 步驟 1：設置導出預設

1. 點擊菜單 **Project → Export...**
2. 點擊 **Add Preset**
3. 選擇目標平台：
   - Windows Desktop
   - macOS (Intel) 或 macOS (Apple Silicon)
   - Linux/X11

#### 步驟 2：配置導出設置

選中平台預設，默認設置即可，也可自定義：
- **Preset Name**：例如「Windows」
- **Release**：勾選（發佈版本）
- 其他選項保持默認

#### 步驟 3：導出遊戲

1. 選中平台預設
2. 點擊 **Export Project...**
3. 選擇導出目錄（例如 `build/`)
4. 設置文件名（例如 `SnakeGame.exe`）
5. 點擊 **Save**

#### 步驟 4：運行可執行文件

導出完成後，在指定目錄找到可執行文件：

##### Windows

```bash
# 進入導出目錄
cd build/

# 運行遊戲
SnakeGame.exe
```

##### macOS

```bash
# 進入導出目錄
cd build/

# 運行遊戲
open SnakeGame.app
```

##### Linux

```bash
# 進入導出目錄
cd build/

# 給予執行權限
chmod +x SnakeGame

# 運行遊戲
./SnakeGame
```

---

## 4. 故障排除

### 4.1 常見問題

#### Q1：Godot 無法識別項目

**症狀**：打開項目後，編輯器顯示「Missing project.godot」

**解決方案**：
1. 確保項目目錄包含 `project.godot` 文件
2. 使用文件管理器檢查該文件是否存在
3. 如果不存在，運行以下命令重新初始化：
   ```bash
   cd 項目目錄
   godot --path . --editor
   ```

---

#### Q2：場景無法加載

**症狀**：雙擊 `main.tscn` 後顯示空白或錯誤

**解決方案**：
1. 檢查 `main.tscn` 是否損壞：
   ```bash
   # 使用文本編輯器打開檢查
   cat main.tscn  # macOS/Linux
   type main.tscn # Windows
   ```
2. 如果文件損壞，從 GitHub 重新下載
3. 確保所有依賴腳本文件存在：
   - `snake.gd`
   - `food.gd`
   - `game_manager.gd`

---

#### Q3：遊戲運行時崩潰

**症狀**：按 F5 後遊戲立即閉合，或顯示錯誤信息

**可能原因**：
1. **GDScript 語法錯誤**：檢查 Godot 底部 Debug 面板的錯誤信息
2. **節點引用丟失**：確保 `main.tscn` 中的節點名稱正確
3. **Godot 版本不兼容**：確保使用 Godot 4.1+

**調試步驟**：
1. 打開 Godot Debug 面板（**View → Panels → Debug**）
2. 運行遊戲（F5）
3. 查看錯誤信息和堆棧跟蹤
4. 根據錯誤信息修復代碼

---

#### Q4：蛇無法移動或無法控制

**症狀**：運行遊戲後，蛇不動或不響應輸入

**解決方案**：
1. 檢查物理刻度率設置：
   - 打開 **Project → Project Settings → Physics → Common**
   - 確保 `physics_ticks_per_second = 10`

2. 檢查輸入映射：
   - 打開 **Project → Project Settings → Input Map**
   - 確保存在以下輸入：`ui_up`, `ui_down`, `ui_left`, `ui_right`, `ui_select`

3. 檢查腳本是否啟用：
   - 選中 Snake 節點，確保 `snake.gd` 腳本已連接且啟用

---

#### Q5：分數不更新

**症狀**：吃到食物但分數不增加

**解決方案**：
1. 檢查 `game_manager.gd` 中的 `update_score()` 方法是否正確
2. 檢查分數標籤引用是否正確：
   ```gdscript
   score_label = $UI/ScoreLabel
   ```
3. 檢查 Snake 是否正確調用 `get_parent().update_score()`

---

#### Q6：遊戲窗口大小不正確

**症狀**：遊戲窗口顯示得太小或太大

**解決方案**：
1. 檢查 `game_manager.gd` 中的窗口設置：
   ```gdscript
   get_window().size = Vector2i(800, 600)
   ```
2. 修改此值以調整窗口大小

---

### 4.2 性能問題

#### 問題：遊戲卡頓或 FPS 低

**診斷步驟**：
1. 打開 Godot Profiler：**Debug → Monitor**
2. 查看 FPS、CPU 占用率、內存占用
3. 記錄蛇長度和性能指標的關係

**優化建議**：
1. 減少 `draw()` 調用頻率
2. 使用 `queue_redraw()` 代替 `update()`
3. 優化碰撞檢測算法（當蛇很長時）
4. 降低物理更新率（如果允許）

---

#### 問題：內存占用過高

**診斷步驟**：
1. 運行長時間遊戲（> 10 分鐘）
2. 觀察內存占用是否持續增長（內存洩漏）

**優化建議**：
1. 檢查是否存在無限迴圈創建對象
2. 確保 `body_segments` 數組不會無限增長
3. 使用 Godot Profiler 檢查內存分配

---

### 4.3 跨平台問題

#### Windows

**問題**：依賴項丟失（VCRUNTIME.dll）

**解決方案**：
1. 安裝 [Visual C++ Redistributable](https://support.microsoft.com/en-us/help/2977003/the-latest-supported-visual-c-downloads)
2. 重新構建遊戲

---

#### macOS

**問題**：「無法打開應用，因為它來自身份不明的開發者」

**解決方案**：
1. 打開 **System Preferences → Security & Privacy**
2. 點擊 **Open Anyway**
3. 或使用命令行：
   ```bash
   xattr -rd com.apple.quarantine SnakeGame.app
   ```

---

#### Linux

**問題**：共享庫缺失

**解決方案**：
1. 檢查依賴：
   ```bash
   ldd ./SnakeGame | grep "not found"
   ```
2. 安裝缺失的庫：
   ```bash
   sudo apt install [library-name]
   ```

---

## 5. 開發者指南

### 5.1 項目結構

```
godot-snake-game/
├── project.godot          # Godot 項目配置文件
├── main.tscn              # 主場景
├── snake.gd               # 蛇的邏輯
├── food.gd                # 食物的邏輯
├── game_manager.gd        # 遊戲管理器
├── .git/                  # Git 版本控制
├── PRD.md                 # 產品需求文件
├── GDD.md                 # 遊戲設計文件
├── SDD.md                 # 系統設計文件
├── TEST_PLAN.md           # 測試計劃
└── INSTALL.md             # 本文件
```

### 5.2 修改遊戲參數

#### 修改蛇的移動速度

編輯 `project.godot`：

```ini
[physics]

common/physics_ticks_per_second=10  # 改為 5 (更慢) 或 15 (更快)
```

#### 修改網格大小

編輯 `snake.gd` 和 `food.gd`：

```gdscript
const GRID_SIZE = 20  # 改為其他值，例如 32 或 16
```

同時修改 `game_manager.gd` 中的窗口大小和邊界檢查。

#### 修改蛇的初始長度

編輯 `snake.gd` 的 `_ready()` 方法：

```gdscript
body_segments = [
    Vector2i(10, 10),
    Vector2i(9, 10),
    Vector2i(8, 10),
    # 添加更多段以增加初始長度
    Vector2i(7, 10)
]
```

#### 修改分數規則

編輯 `game_manager.gd`：

```gdscript
func update_score():
    score += 10  # 改為其他值，例如 20 或 5
    update_score_label()
```

### 5.3 Git 工作流

#### 初始化 Git（如果尚未初始化）

```bash
cd 項目目錄
git init
git add .
git commit -m "Initial commit"
```

#### 提交修改

```bash
# 查看修改
git status

# 添加修改到暫存區
git add .

# 提交修改
git commit -m "描述修改內容"

# 推送到遠程倉庫
git push origin main
```

#### 查看提交歷史

```bash
git log --oneline
```

---

## 6. 常見命令參考

### 6.1 Godot 命令行

```bash
# 打開項目編輯器
godot --path ./project

# 在編輯器中打開特定場景
godot --path ./project main.tscn

# 運行遊戲（不開啟編輯器）
godot --path ./project --standalone

# 導出遊戲
godot --path ./project --export "Windows Desktop" build/SnakeGame.exe

# 打印調試信息
godot --path ./project --debug
```

### 6.2 Git 常見命令

```bash
# 克隆倉庫
git clone <repository-url>

# 檢查狀態
git status

# 查看修改
git diff

# 添加文件
git add <file>  # 添加單個文件
git add .       # 添加所有文件

# 提交修改
git commit -m "Commit message"

# 推送修改
git push origin <branch>

# 拉取更新
git pull origin <branch>

# 查看提交歷史
git log --oneline
git log --graph --all --decorate
```

---

## 7. 進階設置

### 7.1 導出設置自定義

導出時可自定義以下選項（Project → Export → 編輯預設）：

| 選項 | 說明 | 推薦值 |
|------|------|--------|
| **Application** | - | - |
| Name | 應用名稱 | Snake Game |
| Icon | 應用圖標 | (自選) |
| Version | 版本號 | 1.0.0 |
| **Window** | - | - |
| Width | 窗口寬度 | 800 |
| Height | 窗口高度 | 600 |
| Always on top | 窗口始終在頂部 | 否 |

### 7.2 性能優化

#### 啟用優化構建

導出時選擇 **Release** 構建（而非 Debug）：
- 更快的運行速度
- 更小的文件大小
- 沒有調試符號

#### 啟用 GDScript 編譯

在 Project Settings 中：
1. 搜索「gdscript」
2. 啟用 **Compiled** 選項（如果可用）
3. 提升性能 10-20%

---

## 8. 支持與反饋

### 8.1 報告 Bug

如發現問題，請在 GitHub 上提交 Issue：

1. 訪問 [GitHub Issues](https://github.com/yourusername/godot-snake-game/issues)
2. 點擊 **New Issue**
3. 填寫以下信息：
   - **標題**：簡明描述
   - **環境**：Godot 版本、OS、硬件配置
   - **重現步驟**：詳細的步驟
   - **預期行為**：應該發生什麼
   - **實際行為**：實際發生了什麼
   - **截圖/日誌**：附加相關信息

### 8.2 聯繫方式

- **GitHub Issues**：報告 Bug 和功能請求
- **GitHub Discussions**：討論和問答
- **Email**：[your-email@example.com]

---

## 9. 許可證

本項目採用 MIT 許可證。詳見 LICENSE 文件。

---

## 10. 更新日誌

| 版本 | 日期 | 主要內容 |
|------|------|--------|
| 1.0 | 2026-03-12 | 初版發佈 |

---

**最後更新**：2026-03-12  
**文件版本**：1.0  
**維護人**：Godot Snake Game Team

**祝你遊玩愉快！** 🐍🎮
