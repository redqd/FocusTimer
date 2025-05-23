#SingleInstance Force
#Persistent
SetWorkingDir %A_ScriptDir%

; 初始化参数
RegPath := "HKEY_CURRENT_USER\Software\FocusTimer"
LogFile := A_ScriptDir . "\FocusTimerLog.txt"
FocusDuration := 90 * 60 * 1000  ; 90分钟，单位为毫秒
BreakDuration := 20 * 60 * 1000  ; 20分钟，单位为毫秒
MinInterval := 3 * 60 * 1000     ; 3分钟，提示音最小间隔
MaxInterval := 5 * 60 * 1000     ; 5分钟，提示音最大间隔
RestDuration := 10 * 1000        ; 10秒，闭眼休息时间
Transparency := 100              ; 默认透明度100
SoundPath := "C:\Windows\Media\"
SoundFile := ""
SelectedSound := "notify.wav"    ; 默认提示音
EnableLogging := 0               ; 默认不生成日志
IsRunning := false
IsPaused := false
CycleCount := 0                  ; 专注周期计数
ProgressStart := 0
RemainingTime := ""
CurrentProgressColor := "00FF00" ; 当前进度条颜色
PausedElapsedTime := 0  ; 保存暂停时的已用时间

; 加载保存的设置
LoadSettings()

; 遍历 C:\Windows\Media 下的 .wav 文件
SoundOptions := []
Loop, Files, %SoundPath%*.wav
{
    SoundOptions.Push(A_LoopFileName)
}

; 检查是否找到 .wav 文件
if (SoundOptions.Length() = 0) {
    MsgBox,, 错误, 未在 %SoundPath% 找到任何 .wav 文件！
    ExitApp
}

; 创建系统托盘菜单
Menu, Tray, Tip, 专注助手 (暂停: Ctrl+Shift+P; 恢复: Ctrl+Shift+R)
Menu, Tray, Add, 设置, ShowSettings
Menu, Tray, Add, 暂停, PauseFocus
Menu, Tray, Add, 恢复, ResumeFocus
Menu, Tray, Add, 查看日志, ViewLog
Menu, Tray, Add, 关闭, ExitApp
Menu, Tray, Default, 设置
Menu, Tray, NoStandard
Menu, Tray, Disable, 恢复  ; 初始禁用恢复选项

; 首次启动显示设置界面
ShowSettings:
Gui, Settings:New, +AlwaysOnTop, 专注助手 - 设置
Gui, Settings:Font, s10, Microsoft YaHei
; 时间设置分组
Gui, Settings:Add, GroupBox, x10 y10 w400 h220, 时间设置
Gui, Settings:Add, Text, x20 y40 w250, 专注时长（分钟，整数）：
Gui, Settings:Add, Edit, x270 y40 w100 Number vFocusMinutes, % Round(FocusDuration / 60000)
Gui, Settings:Add, Text, x20 y70 w250, 休息时长（分钟，整数）：
Gui, Settings:Add, Edit, x270 y70 w100 Number vBreakMinutes, % Round(BreakDuration / 60000)
Gui, Settings:Add, Text, x20 y100 w250, 提示音最小间隔（分钟，整数）：
Gui, Settings:Add, Edit, x270 y100 w100 Number vMinIntervalMinutes, % Round(MinInterval / 60000)
Gui, Settings:Add, Text, x20 y130 w250, 提示音最大间隔（分钟，整数）：
Gui, Settings:Add, Edit, x270 y130 w100 Number vMaxIntervalMinutes, % Round(MaxInterval / 60000)
Gui, Settings:Add, Text, x20 y160 w250, 闭眼休息时长（秒，整数）：
Gui, Settings:Add, Edit, x270 y160 w100 Number vRestSeconds, % Round(RestDuration / 1000)
Gui, Settings:Add, CheckBox, x20 y190 w150 vEnableLogging, 生成日志
GuiControl, Settings:, EnableLogging, %EnableLogging%
; 提示音设置分组
Gui, Settings:Add, GroupBox, x10 y240 w400 h80, 提示音设置
Gui, Settings:Add, Text, x20 y270 w150, 提示音：
Gui, Settings:Add, DropDownList, x100 y270 w200 vSelectedSound, % StrJoin("|", SoundOptions)
GuiControl, Settings:Choose, SelectedSound, %SelectedSound%
Gui, Settings:Add, Button, gTestSound x320 y270 w50, 测试
; 界面设置分组
Gui, Settings:Add, GroupBox, x10 y330 w400 h100, 界面设置
Gui, Settings:Add, Text, x20 y360 w250, 进度条透明度（0-255）：
Gui, Settings:Add, Slider, x170 y360 w200 vTransparency Range0-255, %Transparency%

; 剩余时间
Gui, Settings:Font, s14 bold, Microsoft YaHei
Gui, Settings:Add, Text, vRemainingTime x10 y450 w200, 剩余时间: --:--
Gui, Settings:Font  ; 重置字体
; 暂停按钮
Gui, Settings:Add, Button, gPauseButton x190 y450 w100, % IsRunning ? (IsPaused ? "恢复" : "暂停") : "暂停"
if(IsRunning){
    GuiControl, Settings:Enable, Button6  ; 激活
}else{
    GuiControl, Settings:Disable, Button6  ; 默认禁用暂停按钮
}

; 开始按钮
Gui, Settings:Add, Button, Default gSaveSettings x310 y450 w100, % IsRunning ? "重新开始" : "开始"
Gui, Settings:Show
return

; 测试提示音
TestSound:
Gui, Settings:Submit, NoHide
SoundFile := SoundPath . SelectedSound
if FileExist(SoundFile) {
    SoundPlay, %SoundFile%
} else {
    MsgBox,, 错误, 提示音文件 %SoundFile% 不存在！
}
return

; 保存设置并开始专注
SaveSettings:
Gui, Settings:Submit

FocusDuration := Round(Abs(FocusMinutes)) * 60 * 1000
BreakDuration := Round(Abs(BreakMinutes)) * 60 * 1000
MinInterval := Round(Abs(MinIntervalMinutes)) * 60 * 1000
MaxInterval := Round(Abs(MaxIntervalMinutes)) * 60 * 1000
RestDuration := Round(Abs(RestSeconds)) * 1000
SoundFile := SoundPath . SelectedSound
Transparency := Round(Abs(Transparency))
EnableLogging := EnableLogging

; 验证输入
if (FocusDuration <= 0 || BreakDuration <= 0 || MinInterval <= 0 || MaxInterval <= 0 || RestDuration <= 0) {
    MsgBox,, 错误, 所有时间参数必须大于0！
    Gui, Settings:Show
    return
}
if (MinInterval > MaxInterval) {
    MsgBox,, 错误, 最小间隔不能大于最大间隔！
    Gui, Settings:Show
    return
}
if !FileExist(SoundFile) {
    MsgBox,, 错误, 提示音文件 %SoundFile% 不存在！
    Gui, Settings:Show
    return
}

; 调试输入值（若启用日志）
if (EnableLogging) {
    FormatTime, CurrentTime,, yyyy-MM-dd HH:mm:ss
    FileAppend, [调试] %CurrentTime% 输入: Focus=%FocusMinutes%, Break=%BreakMinutes%, MinInterval=%MinIntervalMinutes%, MaxInterval=%MaxIntervalMinutes%, Rest=%RestSeconds%, Transparency=%Transparency%`n, %LogFile%
}

; 保存设置到注册表
RegWrite, REG_SZ, %RegPath%, FocusMinutes, %FocusMinutes%
RegWrite, REG_SZ, %RegPath%, BreakMinutes, %BreakMinutes%
RegWrite, REG_SZ, %RegPath%, MinIntervalMinutes, %MinIntervalMinutes%
RegWrite, REG_SZ, %RegPath%, MaxIntervalMinutes, %MaxIntervalMinutes%
RegWrite, REG_SZ, %RegPath%, RestSeconds, %RestSeconds%
RegWrite, REG_SZ, %RegPath%, SelectedSound, %SelectedSound%
RegWrite, REG_SZ, %RegPath%, Transparency, %Transparency%
RegWrite, REG_SZ, %RegPath%, EnableLogging, %EnableLogging%

; 重置进度条
ProgressStart := A_TickCount
; 创建进度条 GUI
ScreenWidth := GetScreenWidth()
ProgressHeight := GetProgressHeight()
ScreenBottom := GetScreenBottom()
InitialColor := GetGradientColor(0)
Gui, Progress:New, -Caption +AlwaysOnTop +ToolWindow -Border +E0x80000
Gui, Progress:Margin, 0, 0
Gui, Progress:Color, % GetSystemColor()
Gui, Progress:Add, Progress, vProgressBar w%ScreenWidth% h%ProgressHeight% -Smooth Range0-%FocusDuration% c%InitialColor% -Theme, 0
GuiControl, Progress:, ProgressBar, 0  ; 显式重置为0
Gui, Progress:Show, x0 y%ScreenBottom%
Gui, Progress:+E0x20
WinSet, Transparent, %Transparency%, ahk_class AutoHotkeyGUI
WinSet, ExStyle, +0x20, ahk_class AutoHotkeyGUI
SetTimer, KeepProgressOnTop, 500  ; 缩短间隔
SetTimer, UpdateProgress, 1000
Sleep, 100  ; 延迟确保初始化完成
StartFocusCycle()

return

; 保持进度条置顶
KeepProgressOnTop:
if (IsRunning && !IsPaused) {
    WinSet, AlwaysOnTop, On, ahk_class AutoHotkeyGUI
    if (EnableLogging) {
        FormatTime, CurrentTime,, yyyy-MM-dd HH:mm:ss
        FileAppend, 置顶尝试于 %CurrentTime%`n, %LogFile%
    }
}
return

; 更新进度条和剩余时间
UpdateProgress:
if (IsRunning && !IsPaused) {
    ElapsedTime := A_TickCount - ProgressStart
    if (ElapsedTime <= FocusDuration) {
        ProgressPercent := (ElapsedTime / FocusDuration) * 100
        GuiControl, Progress:, ProgressBar, %ElapsedTime%
        CurrentProgressColor := GetGradientColor(ProgressPercent)
        GuiControl, Progress:+c%CurrentProgressColor%, ProgressBar
        
        ; 更新剩余时间
        RemainingMs := FocusDuration - ElapsedTime
        Minutes := Floor(RemainingMs / 60000)
        Seconds := Floor(Mod(RemainingMs, 60000) / 1000)
        RemainingTime := Format("{:02d}:{:02d}", Minutes, Seconds)
        GuiControl, Settings:, RemainingTime, 剩余时间: %RemainingTime%
    }
} else {
    ;GuiControl, Settings:, RemainingTime, 剩余时间: --:--
}
return

; 开始专注周期
StartFocusCycle() {
    global FocusDuration, BreakDuration, MinInterval, MaxInterval, RestSeconds, RestDuration, SoundFile, IsRunning, IsPaused, CycleCount, LogFile, Transparency, CurrentProgressColor, EnableLogging
    IsRunning := true
    ProgressStart := A_TickCount  ; 重置开始时间
    Loop {
        if (!IsRunning) {
            break
        }
        if (IsPaused) {
            Sleep, 100
            continue
        }
        ; 检查是否到达专注周期结束
        ElapsedTime := A_TickCount - ProgressStart
        if (ElapsedTime >= FocusDuration) {
            SoundPlay, %SoundFile%
            MsgBox,, 休息提醒, 专注周期结束！请休息 %BreakMinutes% 分钟。
            Gui, Progress:Hide
            IsPaused := true
            Menu, Tray, Enable, 恢复
            Menu, Tray, Disable, 暂停
            CycleCount++
            LogCycle()
            Sleep, %BreakDuration%
            IsPaused := false
            Menu, Tray, Disable, 恢复
            Menu, Tray, Enable, 暂停
            SoundPlay, %SoundFile%
            MsgBox, 4, 专注模式, 休息结束，是否开始下一个专注周期？
            IfMsgBox, No
            {
                IsRunning := false
                SetTimer, KeepProgressOnTop, Off
                SetTimer, UpdateProgress, Off
                Gui, Progress:Destroy
                Gui, Settings:Show
                return
            }
            ProgressStart := A_TickCount
            GuiControl, Progress:, ProgressBar, 0
            InitialColor := GetGradientColor(0)
            GuiControl, Progress:+c%InitialColor%, ProgressBar
            Gui, Progress:Show
        }
        
        ; 随机生成提示音间隔
        Random, RandomInterval, %MinInterval%, %MaxInterval%
        Sleep, %RandomInterval%
        
        if (!IsRunning || IsPaused) {
            continue
        }
        ; 播放提示音并显示屏幕中央提示文字
        SoundPlay, %SoundFile%
        SysGet, ScreenWidth, 78  ; SM_CXVIRTUALSCREEN
        SysGet, ScreenHeight, 79 ; SM_CYVIRTUALSCREEN
        TextX := (ScreenWidth - 800) // 2  ; 400为估计文字宽度
        TextY := (ScreenHeight - 50) // 2  ; 50为估计文字高度
        Gui, Reminder:New, -Caption -Border +AlwaysOnTop
        Gui, Reminder:Color, 0x000000
        Gui, Reminder:Font, s48, Microsoft YaHei  ; 48号字体
        ReminderText := Format("请闭上眼睛休息 {} 秒", RestSeconds)
        Gui, Reminder:Add, Text, c%CurrentProgressColor% x10 y10, %ReminderText%
        Gui, Reminder:Show, x%TextX% y%TextY% NA
        WinSet, TransColor, 0x000000 %Transparency%, ahk_class AutoHotkeyGUI
        Sleep, %RestDuration%
        Gui, Reminder:Destroy
    }
}

;暂停按钮功能
PauseButton:
if(!IsPaused){
    Gosub, PauseFocus
} else{
    Gosub, ResumeFocus
}
return

; 暂停专注 (Ctrl+Shift+P)
^+p::
PauseFocus:
PausedElapsedTime := A_TickCount - ProgressStart  ; 保存暂停时的已用时间
IsPaused := true
Menu, Tray, Enable, 恢复
Menu, Tray, Disable, 暂停
Gui, Progress:Hide
GuiControl, Settings:, Button6, 恢复
return

; 恢复专注 (Ctrl+Shift+R)
^+r::
ResumeFocus:
ProgressStart := A_TickCount - PausedElapsedTime  ; 恢复时调整开始时间
IsPaused := false
Menu, Tray, Disable, 恢复
Menu, Tray, Enable, 暂停
Gui, Progress:Show
GuiControl, Settings:, Button6, 暂停 
return

; 查看日志
ViewLog:
if (FileExist(LogFile)) {
    Run, notepad.exe %LogFile%
} else {
    MsgBox,, 提示, 日志文件未生成！请在设置中启用“生成日志”选项。
}
return

; 记录专注周期日志
LogCycle() {
    global CycleCount, FocusDuration, LogFile, EnableLogging
    if (EnableLogging) {
        FormatTime, CurrentTime,, yyyy-MM-dd HH:mm:ss
        LogEntry := "周期 " . CycleCount . " 完成于 " . CurrentTime . ", 时长: " . (FocusDuration / 60000) . " 分钟`n"
        FileAppend, %LogEntry%, %LogFile%
    }
}

; 加载设置
LoadSettings() {
    global RegPath, FocusDuration, BreakDuration, MinInterval, MaxInterval, RestDuration, SoundFile, Transparency, SelectedSound, EnableLogging
    RegRead, FocusMinutes, %RegPath%, FocusMinutes
    if (ErrorLevel || FocusMinutes = "") {
        FocusMinutes := 90
    }
    RegRead, BreakMinutes, %RegPath%, BreakMinutes
    if (ErrorLevel || BreakMinutes = "") {
        BreakMinutes := 20
    }
    RegRead, MinIntervalMinutes, %RegPath%, MinIntervalMinutes
    if (ErrorLevel || MinIntervalMinutes = "") {
        MinIntervalMinutes := 3
    }
    RegRead, MaxIntervalMinutes, %RegPath%, MaxIntervalMinutes
    if (ErrorLevel || MaxIntervalMinutes = "") {
        MaxIntervalMinutes := 5
    }
    RegRead, RestSeconds, %RegPath%, RestSeconds
    if (ErrorLevel || RestSeconds = "") {
        RestSeconds := 10
    }
    RegRead, SelectedSound, %RegPath%, SelectedSound
    if (ErrorLevel || SelectedSound = "") {
        SelectedSound := "notify.wav"
    }
    RegRead, Transparency, %RegPath%, Transparency
    if (ErrorLevel || Transparency = "") {
        Transparency := 100
    }
    RegRead, EnableLogging, %RegPath%, EnableLogging
    if (ErrorLevel || EnableLogging = "") {
        EnableLogging := 0
    }
    FocusDuration := Round(FocusMinutes) * 60 * 1000
    BreakDuration := Round(BreakMinutes) * 60 * 1000
    MinInterval := Round(MinIntervalMinutes) * 60 * 1000
    MaxInterval := Round(MaxIntervalMinutes) * 60 * 1000
    RestDuration := Round(RestSeconds) * 1000
    SoundFile := SoundPath . SelectedSound
}

; 获取系统配色
GetSystemColor() {
    RegRead, Color, HKCU\Software\Microsoft\Windows\DWM, AccentColor
    if (ErrorLevel) {
        return "00FF00"  ; 默认绿色
    }
    Color := Format("{:06X}", Color & 0xFFFFFF)
    return Color
}

; 获取渐变颜色
GetGradientColor(Percent) {
    if (Percent < 50) {
        ; 从绿色 (00FF00) 到黄色 (FFFF00)
        Green := 255
        Red := Round(Percent * 5.1)  ; 0 to 255 over 50%
        Blue := 0
    } else {
        ; 从黄色 (FFFF00) 到红色 (FF0000)
        Red := 255
        Green := Round(255 - ((Percent - 50) * 5.1))  ; 255 to 0 over 50%
        Blue := 0
    }
    return Format("{:02X}{:02X}{:02X}", Red, Green, Blue)
}

; 获取屏幕宽度
GetScreenWidth() {
    SysGet, ScreenWidth, 78  ; SM_CXVIRTUALSCREEN
    return ScreenWidth
}

; 获取屏幕底部位置
GetScreenBottom() {
    SysGet, ScreenHeight, 79  ; SM_CYVIRTUALSCREEN
    return ScreenHeight - GetProgressHeight()
}

; 获取进度条高度（适配 DPI）
GetProgressHeight() {
    SysGet, DPI, 32  ; MONITOR_DEFAULTTONEAREST
    return Round(5 * (A_ScreenDPI / 96))  ; 按 DPI 缩放高度
}

; 辅助函数：将数组转换为分隔符字符串
StrJoin(sep, arr) {
    result := ""
    for index, value in arr
        result .= value . (index < arr.Length() ? sep : "")
    return result
}

; 快捷键：Ctrl+Shift+Q 退出
^+q::
    IsRunning := false
    MsgBox, 专注模式已退出。
    SetTimer, KeepProgressOnTop, Off
    SetTimer, UpdateProgress, Off
    Gui, Progress:Destroy
    ExitApp
return

; 关闭设置窗口
SettingsGuiClose:
    if (!IsRunning) {
        ExitApp
    }
    Gui, Settings:Hide
return

; 关闭程序
ExitApp:
    IsRunning := false
    SetTimer, KeepProgressOnTop, Off
    SetTimer, UpdateProgress, Off
    Gui, Progress:Destroy
    ExitApp
return