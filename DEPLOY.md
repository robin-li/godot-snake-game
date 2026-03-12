# 🚀 Godot Snake Game — 部署計畫詳細版

**從開發環境到用戶手中的完整指南。**

---

## 部署前檢查清單

**開發環境驗證：**
- [ ] Godot 版本確認（需要 4.0+）
- [ ] 所有文件已 Commit（無未保存更改）
- [ ] 本地測試通過（所有里程碑驗收標準滿足）
- [ ] Git 分支正確（在 main/master 分支）

**代碼檢查：**
- [ ] 無 DEBUG print 語句遺留
- [ ] 無註釋掉的死代碼
- [ ] 版本號已更新（project.godot, 代碼中）
- [ ] README.md 內容最新

**資源檢查：**
- [ ] 所有圖片/音頻資源已包含
- [ ] 沒有未使用的大文件
- [ ] 文件路徑使用相對路徑（跨平台兼容）

**依賴檢查：**
- [ ] C# 項目確認沒有外部 NuGet 依賴
- [ ] GDScript 無外部插件依賴
- [ ] 導出模板已安裝

---

## 多平台發佈步驟

### 前置準備

```bash
# 確保在項目根目錄
cd ~/workspace/godot-snake-github

# 確認 Git 狀態
git status
git log --oneline -5  # 確認最新提交

# 建立發佈分支（可選）
git checkout -b release/v1.0.0
```

### Windows 發佈

**Step 1: 導出**
```bash
# 導出 Release 版本（已優化）
godot --export-release "Windows Desktop" build/windows/snake-v1.0.0.exe

# 檢查輸出
ls -lh build/windows/
# 預期：snake-v1.0.0.exe ~50-100MB
```

**Step 2: 本地驗證**
```bash
# 在 Windows 機器上運行
.\build\windows\snake-v1.0.0.exe

# 測試清單：
# [ ] 遊戲啟動無報錯
# [ ] 菜單界面正常
# [ ] 選擇難度能進入遊戲
# [ ] 玩 2-3 輪，驗證功能完整
# [ ] 退出無卡頓
```

**Step 3: 打包分發**
```bash
# Windows 標準格式：ZIP
cd build/windows
zip -r snake-v1.0.0-windows.zip snake-v1.0.0.exe
cd ../../

# 可選：建立安裝程序（NSIS）
# makensis snake-installer.nsi  # 需額外配置
```

---

### macOS 發佈

**Step 1: 導出**
```bash
# 導出為 .app bundle（Godot 4.0+）
godot --export-release "macOS" build/macos/Godot_Snake.app

# 驗證結構
ls -la build/macos/Godot_Snake.app/Contents/MacOS/
```

**Step 2: 代碼簽名（可選但推薦）**
```bash
# 如果有 Apple Developer 帳號
codesign -s - build/macos/Godot_Snake.app

# 或者標記為本地信任
xattr -d com.apple.quarantine build/macos/Godot_Snake.app
```

**Step 3: 本地驗證**
```bash
# 在 macOS 運行
open build/macos/Godot_Snake.app

# 測試清單（同 Windows）
# [ ] 遊戲啟動無報錯
# [ ] 菜單界面正常
# [ ] 功能完整
```

**Step 4: 打包分發**
```bash
# macOS 標準格式：DMG
cd build/macos

# 建立 DMG（簡單版本）
hdiutil create -volname "Godot Snake" \
  -srcfolder Godot_Snake.app \
  -ov -format UDZO \
  snake-v1.0.0-macos.dmg

cd ../../
```

---

### Linux 發佈

**Step 1: 導出**
```bash
# 導出為 x64 可執行檔
godot --export-release "Linux/X11" build/linux/snake-v1.0.0

# 設置執行權限
chmod +x build/linux/snake-v1.0.0
```

**Step 2: 本地驗證**
```bash
# 在 Linux 機器上運行
./build/linux/snake-v1.0.0

# 測試清單
# [ ] 遊戲啟動無報錯
# [ ] 功能完整
# [ ] 驗證依賴（ldd snake-v1.0.0）
```

**Step 3: 打包分發**
```bash
cd build/linux

# TAR.GZ 格式（標準）
tar -czf snake-v1.0.0-linux-x64.tar.gz snake-v1.0.0

cd ../../
```

**可選：AppImage 格式（更好用戶體驗）**
```bash
# 需要 appimagetool
# appimagetool build/linux/AppDir snake-v1.0.0-x86_64.AppImage
```

---

## GitHub Release 流程

### Step 1: 準備 Release Notes

**建立 RELEASE_NOTES.md：**
```markdown
# 🐍 Godot Snake v1.0.0

## 🎉 亮點
- ✨ 完整的蛇遊戲體驗
- 🎯 3 個難度等級
- 💾 最高分記錄

## 📋 變更日誌
### 新功能
- 核心遊戲機制實現
- Easy/Normal/Hard 難度選擇
- 最高分本地存儲

### 修復
- 碰撞檢測精準化
- 邊界判定優化

### 已知限制
- 暫無聲音音效
- 暫無網絡高分榜

## 📥 下載
- **Windows:** snake-v1.0.0-windows.zip
- **macOS:** snake-v1.0.0-macos.dmg
- **Linux:** snake-v1.0.0-linux-x64.tar.gz

## 🚀 如何開始
1. 下載對應系統的文件
2. 解壓並執行
3. 開始遊戲！

## ❤️ 反饋
有問題或建議？提交 Issue 或 Discussion！
```

### Step 2: Git 標籤和提交

```bash
# 確認所有更改已提交
git add .
git commit -m "chore: prepare v1.0.0 release"

# 建立版本標籤
git tag -a v1.0.0 -m "Release: Godot Snake v1.0.0

- Core gameplay complete
- 3 difficulty levels
- Cross-platform support"

# 推送到遠程
git push origin main
git push origin v1.0.0
```

### Step 3: GitHub Web UI 發佈

1. **進入 GitHub Releases 頁面**
   ```
   https://github.com/YOUR_USERNAME/godot-snake-github/releases
   ```

2. **點擊 "Create a new release"**

3. **填寫發佈信息：**
   - Tag: `v1.0.0`
   - Release title: `🐍 Godot Snake v1.0.0`
   - Description: 貼上 RELEASE_NOTES.md 內容

4. **上傳可執行檔：**
   ```
   build/windows/snake-v1.0.0-windows.zip
   build/macos/snake-v1.0.0-macos.dmg
   build/linux/snake-v1.0.0-linux-x64.tar.gz
   ```

5. **選擇"Publish release"**

---

### Step 4: 自動化發佈（GitHub Actions）

**建立 .github/workflows/release.yml：**

```yaml
name: Release

on:
  push:
    tags:
      - 'v*'

jobs:
  build:
    runs-on: ${{ matrix.os }}
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]

    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Godot
        uses: chickensoft-games/setup-godot@v1
        with:
          version: 4.0
      
      - name: Export Game
        run: |
          mkdir -p build
          godot --export-release "Windows Desktop" build/snake-win64.exe
          godot --export-release "macOS" build/Godot_Snake.app
          godot --export-release "Linux/X11" build/snake-linux-x64

      - name: Upload Artifacts
        uses: softprops/action-gh-release@v1
        with:
          files: build/*
```

---

## 回滾方案

**如果發佈後發現重大問題：**

### 快速回滾

```bash
# 刪除發佈的標籤（本地）
git tag -d v1.0.0

# 刪除遠程標籤
git push --delete origin v1.0.0

# 刪除 GitHub Release（手動在 Web UI 進行）
```

### 發佈修復版本

```bash
# 修復代碼
git add .
git commit -m "fix: critical bug in collision detection"

# 發佈 hotfix 版本
git tag -a v1.0.1 -m "Hotfix: collision bug"
git push origin v1.0.1

# 按照上述流程重新發佈
```

---

## 上線驗證

### 發佈後檢查清單

**GitHub 驗證：**
- [ ] Release 頁面顯示正確
- [ ] 所有文件都成功上傳
- [ ] Release Notes 清晰易讀
- [ ] Tag 正確創建

**下載驗證：**
- [ ] 在不同網絡環境測試下載速度
- [ ] 確認下載文件完整性（文件大小符合）
- [ ] 驗證下載後的可執行檔能正常運行

**用戶反饋通道：**
- [ ] Issues 開放，用戶可報告 Bug
- [ ] Discussions 可討論功能建議
- [ ] 監控是否有崩潰報告（5 分鐘內）

**統計信息：**
記錄以下信息供後續參考：
```
Release Date: 2026-03-12
Version: v1.0.0
Total Downloads (24h): ___
Issues Reported: ___
Critical Bugs: ___
User Rating: ___
```

---

## 部署故障排查

### 常見問題

**Q: Windows 版本無法運行，提示 DLL 缺失？**
- A: 檢查 Godot 導出設置，確保 "Embed Pck" 打開
- 手動複製 vcredist 到發佈包中

**Q: macOS 提示"無法驗證開發者"？**
- A: 用戶打開「系統偏好 → 安全性與隱私」允許運行
- 或開發者簽署應用（需 Apple Developer 帳號）

**Q: Linux 提示"Permission Denied"？**
- A: 提醒用戶 `chmod +x snake-v1.0.0` 後再運行
- 或提供 .sh 啟動腳本

**Q: 遊戲在某平台卡頓或閃退？**
- A: 檢查分辨率/刷新率，提供 fallback 配置
- 查看日誌輸出：`--verbose` 標誌

---

## 發佈檢查最終清單

**發佈前 24 小時：**
- [ ] 代碼最終審查完成
- [ ] 所有測試 100% 通過
- [ ] Release Notes 已準備
- [ ] 可執行檔已打包驗證

**發佈時：**
- [ ] 建立 Git Tag
- [ ] 推送至遠程倉庫
- [ ] GitHub Release 上傳完成
- [ ] 發送公告（Twitter/社區）

**發佈後 24 小時：**
- [ ] 監控 Issue 報告
- [ ] 回應用戶反饋
- [ ] 監控下載數據
- [ ] 準備熱修復（如需要）

---

## 快速參考

| 操作 | 命令 |
|-----|------|
| 導出 Windows | `godot --export-release "Windows Desktop" build/snake.exe` |
| 導出 macOS | `godot --export-release "macOS" build/snake.app` |
| 導出 Linux | `godot --export-release "Linux/X11" build/snake` |
| 建立標籤 | `git tag -a v1.0.0 -m "message"` |
| 推送標籤 | `git push origin v1.0.0` |
| 刪除標籤 | `git tag -d v1.0.0 && git push --delete origin v1.0.0` |

---

_Last updated: 2026-03-12_
_Deployment guide for Godot Snake Game v1.0.0+_
