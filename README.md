# FocusTimer

[English](#english) | [中文](#chinese)

---

## English

### Overview

FocusTimer is an AutoHotkey-based productivity tool designed to help users maintain focus and incorporate regular breaks using the "Random Reminder Sound" method. It provides a customizable focus and break cycle with audio reminders to encourage brief eye-rest periods, helping to reduce fatigue and improve productivity.

### Features

- **Customizable Focus and Break Durations**: Set focus periods (default: 90 minutes) and break periods (default: 20 minutes) to suit your workflow.
- **Random Reminder Sounds**: Configurable random intervals (default: 3–5 minutes) for audio cues prompting a short eye-rest break (default: 10 seconds).
- **Progress Bar**: Displays a full-screen progress bar with a gradient color transition (green to yellow to red) to visualize focus time.
- **System Tray Integration**: Control the timer (pause, resume, settings, view log, exit) via the system tray menu.
- **Customizable Audio Cues**: Choose from any `.wav` file in the `C:\Windows\Media\` directory for reminder sounds.
- **Transparency Settings**: Adjust the progress bar’s transparency (0–255) for minimal distraction.
- **Logging**: Optionally log focus cycles and debug information to a text file for tracking productivity.
- **Hotkeys**:
  - `Ctrl+Shift+P`: Pause the focus timer.
  - `Ctrl+Shift+R`: Resume the focus timer.
  - `Ctrl+Shift+Q`: Exit the application.
- **Settings Persistence**: Saves user preferences (durations, sound, transparency, logging) to the Windows Registry.
- **On-Screen Reminders**: Displays a centered message during eye-rest periods with the current progress bar color.

### Installation

1. **Prerequisites**:
   - Windows operating system.
   - AutoHotkey v1.1+ installed (download from [autohotkey.com](https://www.autohotkey.com/)).
   - `.wav` files available in `C:\Windows\Media\` for sound selection (default: `notify.wav`).

2. **Setup**:
   - Download the `FocusTimer.ahk` script.
   - Place it in a directory of your choice.
   - Double-click the script to run it, or compile it into an `.exe` using AutoHotkey’s compiler for standalone use.

3. **Optional**:
   - Ensure `.wav` files are present in `C:\Windows\Media\`. If none are found, the script will display an error and exit.

### Usage

The "Random Reminder Sound" method is inspired by the technique described in [“The Principle of Random Reminder Sounds”](https://www.yuque.com/u43692620/yyl2g7/fup4ss9g56olg3gy). Follow these steps to use FocusTimer:

1. **Launch the Application**:
   - Run the `FocusTimer.ahk` script. The settings window will appear automatically on first launch.

2. **Configure Settings**:
   - **Time Settings**:
     - **Focus Duration**: Set the length of each focus session (default: 90 minutes).
     - **Break Duration**: Set the length of breaks after each focus session (default: 20 minutes).
     - **Reminder Sound Minimum/Maximum Interval**: Set the range for random reminder sound intervals (default: 3–5 minutes).
     - **Eye-Rest Duration**: Set the duration for eye-rest breaks when a reminder sound plays (default: 10 seconds).
     - **Enable Logging**: Check to enable logging of focus cycles and debug information to `FocusTimerLog.txt` in the script directory.
   - **Sound Settings**:
     - Select a `.wav` file from the dropdown menu for reminder sounds.
     - Click **Test** to preview the selected sound.
   - **Interface Settings**:
     - Adjust the **Progress Bar Transparency** (0 = fully transparent, 255 = fully opaque, default: 100).
   - Click **Start** (or **Restart** if already running) to save settings and begin the focus cycle.

3. **Focus Cycle**:
   - A progress bar appears at the bottom of the screen, updating every second with a color gradient (green → yellow → red) to indicate progress.
   - At random intervals (within the set minimum and maximum), a reminder sound plays, and a centered message prompts you to close your eyes for the specified eye-rest duration (e.g., 10 seconds).
   - After completing the focus duration (e.g., 90 minutes), a sound plays, the progress bar hides, and a message prompts you to take a break (e.g., 20 minutes).
   - Post-break, a message asks if you want to start another focus cycle. Choose **Yes** to continue or **No** to return to the settings window.

4. **Control Options**:
   - **System Tray Menu**:
     - **Settings**: Reopen the settings window.
     - **Pause**: Pause the current focus session (also via `Ctrl+Shift+P`).
     - **Resume**: Resume a paused session (also via `Ctrl+Shift+R`).
     - **View Log**: Open the log file in Notepad (if logging is enabled).
     - **Exit**: Close the application (also via `Ctrl+Shift+Q`).
   - **Settings Window**:
     - The **Pause/Resume** button toggles the focus session state.
     - The **Remaining Time** display shows the time left in the current focus session.

5. **Pause and Resume**:
   - Pause the timer during a focus session using `Ctrl+Shift+P` or the **Pause** button. The progress bar hides, and the timer pauses.
   - Resume with `Ctrl+Shift+R` or the **Resume** button. The progress bar reappears, and the timer continues from where it left off.

6. **Exit the Application**:
   - Use `Ctrl+Shift+Q`, select **Exit** from the system tray, or close the settings window when no focus session is active.

### Notes

- **Input Validation**: All time settings must be positive integers, and the minimum reminder interval must not exceed the maximum. Invalid inputs will trigger an error message, and the settings window will reappear.
- **Log File**: If logging is enabled, `FocusTimerLog.txt` is created in the script directory, recording cycle completions and debug information (e.g., settings inputs, topmost attempts).
- **Transparency**: Lower transparency values make the progress bar less intrusive but may reduce visibility.
- **DPI Scaling**: The progress bar height adjusts based on your screen’s DPI for better visibility.
- **Sound Files**: Ensure `.wav` files are available in `C:\Windows\Media\`. If the selected sound file is missing, an error will prompt you to choose another.

### Troubleshooting

- **No Sound Plays**: Verify that the selected `.wav` file exists in `C:\Windows\Media\` and that your system audio is enabled.
- **Progress Bar Not Visible**: Check the transparency setting (0 is fully transparent) and ensure the script has permission to display on top of other windows.
- **Settings Not Saving**: Ensure you have write permissions for the Windows Registry under `HKEY_CURRENT_USER\Software\FocusTimer`.
- **Log File Not Found**: Enable logging in the settings window and verify that the script directory is writable.

### Acknowledgments

FocusTimer is based on the "Random Reminder Sound" method, which promotes sustained focus with periodic micro-breaks. For more details, see [“The Principle of Random Reminder Sound”](https://www.yuque.com/u43692620/yyl2g7/fup4ss9g56olg3gy).

### License

This project is distributed under the MIT License. See [LICENSE](LICENSE) for details.

---

## Chinese

### 概述

FocusTimer 是一款基于 AutoHotkey 的生产力工具，旨在通过“随机提示音”方法帮助用户保持专注并合理安排休息时间。它提供可定制的专注和休息周期，通过随机播放提示音提醒用户进行短暂的闭眼休息，从而减轻疲劳，提高生产力。

### 功能

- **可定制的专注与休息时长**：设置专注时段（默认：90 分钟）和休息时段（默认：20 分钟），以适应您的工作节奏。
- **随机提示音**：设置随机提示音间隔（默认：3-5 分钟），提醒用户进行短暂闭眼休息（默认：10 秒）。
- **进度条**：在屏幕底部显示全屏进度条，颜色从绿色渐变到黄色再到红色，直观展示专注进度。
- **系统托盘集成**：通过系统托盘菜单控制定时器（暂停、恢复、设置、查看日志、退出）。
- **可定制提示音**：从 `C:\Windows\Media\` 目录中选择任意 `.wav` 文件作为提示音（默认：`notify.wav`）。
- **透明度设置**：调整进度条透明度（0-255），减少干扰。
- **日志记录**：可选记录专注周期和调试信息到文本文件，便于跟踪生产力。
- **快捷键**：
  - `Ctrl+Shift+P`：暂停专注定时器。
  - `Ctrl+Shift+R`：恢复专注定时器。
  - `Ctrl+Shift+Q`：退出应用程序。
- **设置持久化**：将用户设置（时长、提示音、透明度、日志开关）保存到 Windows 注册表。
- **屏幕提示**：在闭眼休息期间，屏幕中央显示提示文字，使用当前进度条颜色。

### 安装

1. **前置条件**：
   - Windows 操作系统。
   - 安装 AutoHotkey v1.1+（可从 [autohotkey.com](https://www.autohotkey.com/) 下载）。
   - `C:\Windows\Media\` 目录中需有 `.wav` 文件供选择提示音（默认：`notify.wav`）。

2. **设置**：
   - 下载 `FocusTimer.ahk` 脚本。
   - 将其放置在任意目录。
   - 双击运行脚本，或使用 AutoHotkey 编译器将其编译为 `.exe` 文件以独立运行。

3. **可选**：
   - 确保 `C:\Windows\Media\` 中有 `.wav` 文件。如果未找到任何 `.wav` 文件，脚本将报错并退出。

### 使用方法

FocusTimer 基于“随机提示音”方法，详见[《随机提示音的原理》](https://www.yuque.com/u43692620/yyl2g7/fup4ss9g56olg3gy)。按照以下步骤使用：

1. **启动程序**：
   - 运行 `FocusTimer.ahk` 脚本，首次启动将自动显示设置窗口。

2. **配置设置**：
   - **时间设置**：
     - **专注时长**：设置每次专注的时长（默认：90 分钟）。
     - **休息时长**：设置专注后的休息时间（默认：20 分钟）。
     - **提示音最小/最大间隔**：设置提示音的随机间隔范围（默认：3-5 分钟）。
     - **闭眼休息时长**：设置每次提示音后的闭眼休息时间（默认：10 秒）。
     - **生成日志**：勾选以启用日志记录，日志将保存至脚本目录下的 `FocusTimerLog.txt`。
   - **提示音设置**：
     - 从下拉菜单中选择 `.wav` 文件作为提示音。
     - 点击 **测试** 按钮预览选中的提示音。
   - **界面设置**：
     - 调整 **进度条透明度**（0 = 完全透明，255 = 完全不透明，默认：100）。
   - 点击 **开始**（或运行中的 **重新开始**）保存设置并进入专注模式。

3. **专注周期**：
   - 屏幕底部显示进度条，每秒更新，颜色从绿色渐变到黄色再到红色，反映专注进度。
   - 在随机间隔（在设置的最小和最大间隔范围内），播放提示音，屏幕中央显示提示文字，提醒闭眼休息（例如 10 秒）。
   - 专注时长（例如 90 分钟）结束后，播放提示音，进度条隐藏，弹出消息提醒休息（例如 20 分钟）。
   - 休息结束后，弹出消息询问是否开始下一个专注周期。选择 **是** 继续，或 **否** 返回设置窗口。

4. **控制选项**：
   - **系统托盘菜单**：
     - **设置**：重新打开设置窗口。
     - **暂停**：暂停当前专注会话（或按 `Ctrl+Shift+P`）。
     - **恢复**：恢复暂停的会话（或按 `Ctrl+Shift+R`）。
     - **查看日志**：在记事本中打开日志文件（需启用日志功能）。
     - **关闭**：退出程序（或按 `Ctrl+Shift+Q`）。
   - **设置窗口**：
     - **暂停/恢复** 按钮切换专注会话状态。
     - **剩余时间** 显示当前专注会话的剩余时间。

5. **暂停与恢复**：
   - 使用 `Ctrl+Shift+P` 或 **暂停** 按钮暂停专注会话，进度条隐藏，定时器暂停。
   - 使用 `Ctrl+Shift+R` 或 **恢复** 按钮继续会话，进度条重新显示，定时器从暂停处继续。

6. **退出程序**：
   - 使用 `Ctrl+Shift+Q`，从系统托盘选择 **关闭**，或在未运行专注会话时关闭设置窗口。

### 注意事项

- **输入验证**：所有时间设置必须为正整数，且最小提示音间隔不得大于最大间隔。无效输入将触发错误提示，重新显示设置窗口。
- **日志文件**：启用日志后，`FocusTimerLog.txt` 将在脚本目录生成，记录专注周期和调试信息（如设置输入、置顶尝试）。
- **透明度**：较低的透明度使进度条更不显眼，但可能降低可见性。
- **DPI 适配**：进度条高度根据屏幕 DPI 自动调整，确保更好的显示效果。
- **提示音文件**：确保 `C:\Windows\Media\` 中有 `.wav` 文件。如果选中的提示音文件不存在，将提示重新选择。

### 故障排除

- **无提示音**：检查所选 `.wav` 文件是否存在于 `C:\Windows\Media\`，并确保系统音量已开启。
- **进度条不可见**：检查透明度设置（0 为完全透明），并确保脚本有权限显示在其他窗口之上。
- **设置未保存**：确保对 `HKEY_CURRENT_USER\Software\FocusTimer` 注册表路径有写权限。
- **日志文件未找到**：在设置窗口中启用日志功能，并确认脚本目录可写。

### 致谢

FocusTimer 基于“随机提示音”方法，通过周期性的微休息帮助用户保持专注。更多原理信息，请参考[《随机提示音的原理》](https://www.yuque.com/u43692620/yyl2g7/fup4ss9g56olg3gy)。

### 许可证

本项目采用 MIT 许可证发布。详情请见 [LICENSE](LICENSE) 文件。

---

[Back to Top](#focustimer)
