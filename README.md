# JACK'S MIGHTY QUEST - Source Code (Temporary)

Thank you for downloading the source code for Jack's Mighty Quest (JMQ)!

This repository contains the complete source files and assets for the 16-bit retro platformer/RPG developed by **Vortex Interactive**.

---

## 🎮 Game Overview

* **Engine:** GameMaker LTS 2026.0+ (GML Scripting)
* **Target Resolution:** 432x240 Widescreen (16:9 Aspect Ratio) @ 60 FPS
* **Target Platforms:** Windows PC (Original Release)

---

## 🛠️ Required Assets & Setup

Ensure all asset dependencies are present in your local project hierarchy before compiling.

### Project Assets Structure
Well, it's only visible in the project files, cause there's a lot of assets that I cannot list!

---

## 🕹️ Controls (Default Engine Inputs)

| Action | Keyboard | Gamepad |
| :--- | :--- | :--- |
| **Move Left / Right** | Arrow Keys / `A` / `D` | D-Pad Left / Right |
| **Jump** | `Space` / `Z` | Button South (`A` / `Cross`) |
| **Attack / Action** | `X` / `K` | Button West (`X` / `Square`) |
| **Pause Game** | `Enter` / `Escape` | Start Button |

---

## 🚀 How to Build & Run

1. Open **GameMaker LTS 2026.0+**.
2. Select **Open** and navigate to the project root directory.
3. Open `JMQ.yyp` (or your project configuration file).
4. Select the **Windows (VM or YYC)** target platform.
5. Set the output display resolution to **432x240** with standard integer scaling enabled.
6. Press `F5` or click the **Run** button to compile and execute.

---

## ⚠️ Notes for Developers

* **Pixel Grid Alignment:** The HUD and level complete interfaces rely on flat slanted primitives drawn relative to integer coordinates. Modify `fnt_bitmap` or UI scale variables with caution to maintain pixel-perfect rendering.
* **Direct Asset Reference:** All GML scripts strictly utilize direct asset handles. Avoid `asset_get_index()` calls in performance-critical draw cycles.
* **Memory Management:** Ensure dynamic surface cleanup and DS structure garbage collection are handled cleanly inside `Clean Up` events.

---

*© Vortex Interactive. All rights reserved.*
