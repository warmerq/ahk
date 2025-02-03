#Requires AutoHotkey v2.0

; 屏蔽按键重复触发



; 初始化变量，用于记录按键按下的时间
lastKeyTime := Map()
keysToWatch := ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", 
  "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", 
  "1", "2", "3", "4", "5", "6", "7", "8", "9", "0",
  "Enter", "Space", ; "Backspace",
  "Delete", "Insert", "Home", "End", "PgUp", "PgDn",
  ",", ".", "/", ";", "'", "[", "]", "\", 
  "-", "=", "``"]

; 为每个按键绑定热键
for key in keysToWatch {
    Hotkey("*$" key, HandleKey)  ; Use ~ to allow modifiers through
}

; 单独处理 Tab, 只影响单独按 Tab， 不影响 AltTab
Hotkey("$Tab", HandleKey)
Hotkey("+$Tab", HandleKey)

; 处理按键事件的函数
HandleKey(thisHotkey, *) {
    global lastKeyTime
    pos := InStr(thisHotkey, "$")
    currentKey := SubStr(thisHotkey, pos+1)
    
    currentTime := A_TickCount
    timeDiff := currentTime - (lastKeyTime.Has(currentKey) ? lastKeyTime[currentKey] : 0)
    
    ; 检测所有修饰键状态
    isShift := GetKeyState("Shift", "P")
    isCtrl := GetKeyState("Ctrl")
    isAlt := GetKeyState("Alt", "P")
    isWin := GetKeyState("LWin", "P") || GetKeyState("RWin", "P")
    
    ; Debug tooltip
    ; ToolTip("Key: " currentKey 
    ;         "`nTime diff: " timeDiff "ms"
    ;         "`nShift: " isShift 
    ;         "`nCtrl: " isCtrl 
    ;         "`nAlt: " isAlt 
    ;         "`nWin: " isWin)
    SetTimer () => ToolTip(), -1000
    
    if (timeDiff < 100) {
        lastKeyTime[currentKey] := currentTime
        return
    }
    
    lastKeyTime[currentKey] := currentTime
    
    ; 构建发送字符串
    modifiers := ""
    modifiers .= isCtrl ? "^" : ""
    modifiers .= isAlt ? "!" : ""
    modifiers .= isShift ? "+" : ""
    modifiers .= isWin ? "#" : ""

    key := StrLen(currentKey) > 1 ? "{" . currentKey . "}" : currentKey 

    Send(modifiers . key)
}