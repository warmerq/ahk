#Requires AutoHotkey v2.0

;InstallKeybdHook

; Global key remapping

; 将 Caps Lock 映射为 Ctrl 键
Capslock::Ctrl
; 将 Right Ctrl 映射为 Caps Lock 键
RCtrl::Capslock

; space
Space::return
Space Up::{
  if (A_PriorKey = "Space") {
    Send '{Space}'
  }
  return
}

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

!1::^1
!2::^2
!3::^3
!4::^4
!5::^5
!6::^6
!7::^7
!8::^8
!9::^9
!0::^0


<!k:: kill_line()

<!w::^w
<!`::^`


; right alt, meta

>!d:: kill_word()
>!b::^Left
>!f::^Right

; Space
    
Space & p::Up
Space & b::Left
Space & n::Down
Space & f::Right  
Space & a::Send '{Home}'
Space & e::Send '{End}'

; 基本编辑
Space & d::Del
Space & h::Backspace

; 一些和mac类似的快捷键
Space & z::^z ; Undo
Space & s::^s ; Save
Space & v::^v ; Paste
Space & c::^c ; Copy
Space & x::^x ; Cut

; 放大缩小字体
Space & =::^=
Space & -::^-

Space & 1::^1
Space & 2::^2
Space & 3::^3
Space & 4::^4
Space & 5::^5
Space & 6::^6
Space & 7::^7
Space & 8::^8
Space & 9::^9
Space & 0::^0

Space & k:: kill_line()

Space & w::^w
Space & `::^`



#HotIf


GroupAdd "browser", "ahk_exe vivaldi.exe"
GroupAdd "browser", "ahk_exe brave.exe"
GroupAdd "browser", "ahk_exe msedge.exe"
; for vivaldi browser
#HotIf WinActive("ahk_group browser")
<!t::^t
<!w::^w
<!LButton::^LButton
Space & t::^t
Space & w::^w
Space & LButton::^LButton
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