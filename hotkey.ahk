#Requires AutoHotkey v2.0

;InstallKeybdHook

; Global key remapping

; 将 Caps Lock 映射为 Ctrl 键
Capslock::Ctrl
; 将 Right Ctrl 映射为 Caps Lock 键
RCtrl::Capslock

; space
; Space::return
; Space Up::{
;   if (A_PriorKey = "Space") {
;     Send '{Space}'
;   }
;   return
; }

; 对类似 Emacs 的应用，
GroupAdd "EmacsLike", "ahk_class Emacs"
;GroupAdd "EmacsLike", "ahk_exe WindowsTerminal.exe"
GroupAdd "EmacsLike", "GNU Emacs at wm-laptop"
#HotIf WinActive("ahk_group EmacsLike")
LAlt::Ctrl
;#o::MsgBox "You pressed Win+o in Emacs or WindowsTerminal."
#HotIf

; 对其他普通 APP
#HotIf not WinActive("ahk_group EmacsLike")

; left alt + ... 基本光标移动
<!n::Down
<!p::Up
<!b::Left 
<!f::Right
<!a::Send '{Home}'
<!e::Send '{End}'

; 基本编辑
<!d::Del
<!h::Backspace

; 一些和mac类似的快捷键
<!z::^z ; Undo
<!s::^s ; Save
<!v::^v ; Paste
<!c::^c ; Copy
<!x::^x ; Cut

; 放大缩小字体
!=::^=
!-::^-

<!1::^1
<!2::^2
<!3::^3
<!4::^4
<!5::^5
<!6::^6
<!7::^7
<!8::^8
<!9::^9
<!0::^0


<!k:: kill_line()

<!w::^w
<!`::^`

<!o::^o


; right alt, meta

>!d:: kill_word()
>!b::^Left
>!f::^Right
>!<::move_to_start()
>!>::move_to_end()

; Space
    
; Space & p::Up
; Space & b::Left
; Space & n::Down
; Space & f::Right  
; Space & a::Send '{Home}'
; Space & e::Send '{End}'

; ; 基本编辑
; Space & d::Del
; Space & h::Backspace

; ; 一些和mac类似的快捷键
; Space & z::^z ; Undo
; Space & s::^s ; Save
; Space & v::^v ; Paste
; Space & c::^c ; Copy
; Space & x::^x ; Cut

; ; 放大缩小字体
; Space & =::^=
; Space & -::^-

; Space & 1::^1
; Space & 2::^2
; Space & 3::^3
; Space & 4::^4
; Space & 5::^5
; Space & 6::^6
; Space & 7::^7
; Space & 8::^8
; Space & 9::^9
; Space & 0::^0

; Space & k:: kill_line()

; Space & w::^w
; Space & `::^`

; Space & t::!t
; Space & [::![
; Space & ]::!]

; alt, space
<!q::!F4
; Space & q:: !F4

#HotIf


GroupAdd "browser", "ahk_exe vivaldi.exe"
GroupAdd "browser", "ahk_exe brave.exe"
GroupAdd "browser", "ahk_exe msedge.exe"
; for vivaldi browser
#HotIf WinActive("ahk_group browser")
<!t::^t
<!w::^w
<!LButton::^LButton
; Space & t::^t
; Space & w::^w
; Space & LButton::^LButton
#HotIf

kill_line()
{
  Send "{Shift down}{END}{Shift up}"
  ;Sleep 50 ;[ms] this value depends on your environment
  Send "^x"
  Return
}


kill_word()
{
    Send "{Shift down}^{Right}{Shift up}"
    ;Sleep 50 ;[ms]
    Send "^x"
    Return
}

move_to_start(){
  Send "^{Home}{Left}"
  return
}

move_to_end(){
  Send "^{End}{Right}"
  return
}


; 屏蔽按键重复触发

; 初始化变量，用于记录按键按下的时间
lastKeyTime := Map()
keysToWatch := ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", 
                "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", 
                "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

; 为每个按键绑定热键
for key in keysToWatch {
    Hotkey("*" key, HandleKey)  ; Use ~ to allow modifiers through
}

; 处理按键事件的函数
HandleKey(thisHotkey, *) {
    global lastKeyTime
    currentKey := StrReplace(thisHotkey, "*")
    currentTime := A_TickCount
    timeDiff := currentTime - (lastKeyTime.Has(currentKey) ? lastKeyTime[currentKey] : 0)
    
    ; 检测所有修饰键状态
    isShift := GetKeyState("Shift", "P")
    isCtrl := GetKeyState("Ctrl", "P")
    isAlt := GetKeyState("Alt", "P")
    isWin := GetKeyState("LWin", "P") || GetKeyState("RWin", "P")
    
    ; Debug tooltip
    ToolTip("Key: " currentKey 
            "`nTime diff: " timeDiff "ms"
            "`nShift: " isShift 
            "`nCtrl: " isCtrl 
            "`nAlt: " isAlt 
            "`nWin: " isWin)
    SetTimer () => ToolTip(), -1000
    
    if (timeDiff < 50) {
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
    
    Send(modifiers . currentKey)
}