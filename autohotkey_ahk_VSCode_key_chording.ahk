#Requires AutoHotkey v1.1+
#NoEnv
SendMode Input
#SingleInstance, prompt
SetWorkingDir %A_ScriptDir%

*escape::
    KeyWait, escape
    IF A_ThisHotkey = *escape
            Send, {escape}
Return

; Initialize press counters and states
yPressCount := 0
mPressCount := 0
nPressCount := 0
yPressed := false
mPressed := false
nPressed := false

; Function to reset 'm' press counter and state
ResetmPressCount:
    mPressCount := 0
    mPressed := false
Return

; Function to reset 'n' press counter and state
ResetnPressCount:
    nPressCount := 0
    nPressed := false
Return

; Function to reset 'y' press counter and state
ResetyPressCount:
    yPressCount := 0
    yPressed := false
Return

; Handling 'm' key when Escape is held down
#If GetKeyState("escape", "P")
m::
    mPressCount++
    SetTimer, ResetmPressCount, -400

    if (mPressCount > 1) { ; escape + mm will open or focus VS Code
        HandleVSCode()
    }
    else if (nPressed) { ; escape + nm will open or focus PotPlayer
        HandlePotPlayer()
        nPressed := false
    }
    else if (yPressed) { ; escape + ym will open Notepad
        RunNotepad()
        yPressed := false
    }
    else {
        mPressed := true
    }
Return

; Handling 'n' key when Escape is held down
n::
    nPressCount++
    SetTimer, ResetnPressCount, -400

    if (nPressCount > 1) { ; escape + nn to left-click
        Click, left
    }
    else if (mPressed) { ; escape + mn will open or focus Brave
        HandleBrave()
        mPressed := false
    }
    else if (yPressed) { ; escape + yn will open or focus Chrome
        HandleChrome()
        yPressed := false
    }
    else {
        nPressed := true
    }
Return

; Handling 'y' key when Escape is held down
y::
    yPressCount++
    SetTimer, ResetyPressCount, -400

    if (yPressCount > 1) { ; escape + yy to copy
        Send, ^c
        MsgBox, Item has been copied.
    }
    else if (mPressed) { ; escape + ym will open Notepad
        RunNotepad()
        mPressed := false
    }
    else {
        yPressed := true
    }
Return
#If

; Function to handle VS Code activation or launching
HandleVSCode() {
    SetTitleMatchMode, 2
    GroupAdd, VSCodeGroup, ahk_exe code.exe
    if WinExist("ahk_group VSCodeGroup") {
        if !WinActive("ahk_group VSCodeGroup")
            GroupActivate, VSCodeGroup, R
        else
            GroupActivate, VSCodeGroup
    } else {
        Run, Notepad
    }
}

; Function to handle PotPlayer activation or message box
HandlePotPlayer() {
    SetTitleMatchMode, 2
    GroupAdd, potplayerGroup, ahk_exe PotPlayerMini64.exe
    if WinExist("ahk_group potplayerGroup") {
        if !WinActive("ahk_group potplayerGroup")
            GroupActivate, potplayerGroup, R
        else
            GroupActivate, potplayerGroup
    } else {
        MsgBox, No video playing atm
    }
}

; Function to handle Brave activation or launching
HandleBrave() {
    SetTitleMatchMode, 2
    GroupAdd, BraveGroup, ahk_exe brave.exe
    if WinExist("ahk_group BraveGroup") {
        if !WinActive("ahk_group BraveGroup")
            GroupActivate, BraveGroup, R
        else
            GroupActivate, BraveGroup
    } else {
        Run, brave.exe
    }
}

; Function to handle Chrome activation or launching
HandleChrome() {
    SetTitleMatchMode, 2
    GroupAdd, chromeGroup, ahk_exe chrome.exe
    if WinExist("ahk_group chromeGroup") {
        if !WinActive("ahk_group chromeGroup")
            GroupActivate, chromeGroup, R
        else
            GroupActivate, chromeGroup
    } else {
        Run, chrome.exe
    }
}

; Function to run Notepad
RunNotepad() {
    Run, notepad.exe
}

; Exit script with notification
#^+!a::
    MsgBox, VSCode-Like chording has been exited.
    ExitApp
Return