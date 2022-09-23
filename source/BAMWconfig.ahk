;
; AutoHotkey Version: 1.1.16.05
; Language:       English
; Platform:       Optimized for Windows 7
; Author:         Sam.
;

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn All, StdOut  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#SingleInstance Force  ; Skips the dialog box and replaces the old instance automatically, which is similar in effect to the Reload command.
#NoTrayIcon

;;;;; Auto-Execute Section ;;;;;
Global PS_EXE, PS_BaseFilename, PS_Version
	PS_EXE:=A_ScriptDir "\BAMWorkshop.exe"
	PS_BaseFilename:=(A_IsCompiled ? FileGetVersionInfo_AW(A_ScriptFullPath).InternalName : "BAMWconfig*")
	PS_Version:=(A_IsCompiled ? SubStr(FileGetVersionInfo_AW(A_ScriptFullPath).FileVersion,1,4) : "vALPHA")

Loop, %0%
	{
	If (%A_Index% = "-about")	;Current Param is "-about"
		{
		AboutID:=About()
		WinWaitClose, ahk_id %AboutID%
		ExitApp
		}
	}

GenerateGUI()
GenerateHotkeys()
ReadColors(PS_EXE)
Return



GenerateGUI(){
	Global
	Local Gui_Width:=240, Gui_Height:=300, Gui_XMargin:=10, Gui_YMargin:=10, Gui_TextWidth:=50, Gui_SButtonWidth:=20, Gui_LWidth:=105
		,Gui_2XMargin:=(2*Gui_XMargin), Gui_2YMargin:=(2*Gui_YMargin)
		,Gui_1W:=(Gui_Width-2*Gui_XMargin), Gui_2W:=(Gui_Width-4*Gui_XMargin)
	Gui,1:Default
	Gui,1:+HwndhGui1
	Gui,1:Font, S8 cBlack, Verdana
	Gui,1:Margin, %Gui_XMargin%, %Gui_YMargin%
	
		Local X1:=(Gui_2XMargin+Gui_TextWidth+Gui_XMargin), X2:=(X1+Gui_SButtonWidth+Gui_XMargin), X3:=(Gui_Width/2-Gui_LWidth/2)
	
	Gui,1:Add, GroupBox, xm ym w%Gui_1W% r2.4 cBlack vControl_1 HwndhControl_1, .gif export shadow color
	Gui,1:Add, Text, x%Gui_2XMargin% yp+20 w%Gui_TextWidth% r1 vControl_2 HwndhControl_2, Current:
	Gui,1:Add, Edit, x%X1% yp w%Gui_SButtonWidth% r1 -TabStop Disabled vControl_3 HwndhControl_3
		CtlColors.Attach(hControl_3,"000000","")
	Gui,1:Add, Edit, x%X2% yp w%Gui_LWidth% r1 +Center -TabStop Disabled vControl_4 HwndhControl_4, 000000
	Gui,1:Add, Text, x%Gui_2XMargin% y+5 w%Gui_TextWidth% r1 vControl_5 HwndhControl_5, Set To:
	Gui,1:Add, Edit, x%X1% yp w%Gui_SButtonWidth% r1 -TabStop Disabled vControl_6 HwndhControl_6
		CtlColors.Attach(hControl_6,"000000","")
	Gui,1:Add, Edit, x%X2% yp w%Gui_LWidth% r1 +Center vControl_7 HwndhControl_7 gGoHandler, 000000
	
	Gui,1:Add, GroupBox, xm w%Gui_1W% r2.4 cBlack vControl_8 HwndhControl_8, quick color selector 1 (transparent)
	Gui,1:Add, Text, x%Gui_2XMargin% yp+20 w%Gui_TextWidth% r1 vControl_9 HwndhControl_9, Current:
	Gui,1:Add, Edit, x%X1% yp w%Gui_SButtonWidth% r1 -TabStop Disabled vControl_10 HwndhControl_10
		CtlColors.Attach(hControl_10,"000000","")
	Gui,1:Add, Edit, x%X2% yp w%Gui_LWidth% r1 +Center -TabStop Disabled vControl_11 HwndhControl_11, 000000
	Gui,1:Add, Text, x%Gui_2XMargin% y+5 w%Gui_TextWidth% r1 vControl_12 HwndhControl_12, Set To:
	Gui,1:Add, Edit, x%X1% yp w%Gui_SButtonWidth% r1 -TabStop Disabled vControl_13 HwndhControl_13
		CtlColors.Attach(hControl_13,"000000","")
	Gui,1:Add, Edit, x%X2% yp w%Gui_LWidth% r1 +Center vControl_14 HwndhControl_14 gGoHandler, 000000
	
	Gui,1:Add, GroupBox, xm w%Gui_1W% r2.4 cBlack vControl_15 HwndhControl_15, quick color selector 2 (shadow)
	Gui,1:Add, Text, x%Gui_2XMargin% yp+20 w%Gui_TextWidth% r1 vControl_16 HwndhControl_16, Current:
	Gui,1:Add, Edit, x%X1% yp w%Gui_SButtonWidth% r1 -TabStop Disabled vControl_17 HwndhControl_17
		CtlColors.Attach(hControl_17,"000000","")
	Gui,1:Add, Edit, x%X2% yp w%Gui_LWidth% r1 +Center -TabStop Disabled vControl_18 HwndhControl_18, 000000
	Gui,1:Add, Text, x%Gui_2XMargin% y+5 w%Gui_TextWidth% r1 vControl_19 HwndhControl_19, Set To:
	Gui,1:Add, Edit, x%X1% yp w%Gui_SButtonWidth% r1 -TabStop Disabled vControl_20 HwndhControl_20
		CtlColors.Attach(hControl_20,"000000","")
	Gui,1:Add, Edit, x%X2% yp w%Gui_LWidth% r1 +Center vControl_21 HwndhControl_21 gGoHandler, 000000
	
	Gui,1:Add, Button, x%X3% y+20 w%Gui_LWidth% r1 +Center vControl_22 HwndhControl_22 gGoHandler, Change
	
	Gui,1:Show, w%Gui_Width% h%Gui_Height%, BAMWorkshop Config
	WinSet, ReDraw
}

GenerateHotkeys(){
	Global
	Hotkey, IfWinActive, ahk_id %hGui1%
	Hotkey, Esc, Reload
	Hotkey, LButton, CreateColorPicker
}

ReadColors(Filename){
	Global
	File0:=FileOpen(Filename,"rw")
	File0.Seek(0x17f22)
		RGB1:=DecToHex(File0.ReadUChar()) DecToHex(File0.ReadUChar()) DecToHex(File0.ReadUChar())
		GuiControl,1:, Control_4, %RGB1%
		CtlColors.Change(hControl_3,RGB1,"")
		GuiControl,1:, Control_7, %RGB1%
		CtlColors.Change(hControl_6,RGB1,"")
	
	File0.Seek(71994)
		RGB3:=DecToHex(File0.ReadUChar()) DecToHex(File0.ReadUChar()) DecToHex(File0.ReadUChar())
		GuiControl,1:, Control_11, %RGB3%
		CtlColors.Change(hControl_10,RGB3,"")
		GuiControl,1:, Control_14, %RGB3%
		CtlColors.Change(hControl_13,RGB3,"")
		
	File0.Seek(72023)
		RGB5:=DecToHex(File0.ReadUChar()) DecToHex(File0.ReadUChar()) DecToHex(File0.ReadUChar())
		GuiControl,1:, Control_18, %RGB5%
		CtlColors.Change(hControl_17,RGB5,"")
		GuiControl,1:, Control_21, %RGB5%
		CtlColors.Change(hControl_20,RGB5,"")
		
	File0.Close()
}

WriteColors(Filename){
	Global
	File0:=FileOpen(Filename,"rw")
	File0.Seek(0x17f22)
		GuiControlGet, RGB1, 1:, Control_4
		GuiControlGet, RGB2, 1:, Control_7
		If (RGB1<>RGB2) AND (StrLen(RGB2)=6)
			{
			File0.WriteUChar(HexToDec(SubStr(RGB2,1,2)))
			File0.WriteUChar(HexToDec(SubStr(RGB2,3,2)))
			File0.WriteUChar(HexToDec(SubStr(RGB2,5,2)))
			}
	File0.Seek(71994)
		GuiControlGet, RGB3, 1:, Control_11
		GuiControlGet, RGB4, 1:, Control_14
		If (RGB3<>RGB4) AND (StrLen(RGB4)=6)
			{
			File0.WriteUChar(HexToDec(SubStr(RGB4,1,2)))
			File0.WriteUChar(HexToDec(SubStr(RGB4,3,2)))
			File0.WriteUChar(HexToDec(SubStr(RGB4,5,2)))
			}
	File0.Seek(72023)
		GuiControlGet, RGB5, 1:, Control_18
		GuiControlGet, RGB6, 1:, Control_21
		If (RGB5<>RGB6) AND (StrLen(RGB6)=6)
			{
			File0.WriteUChar(HexToDec(SubStr(RGB6,1,2)))
			File0.WriteUChar(HexToDec(SubStr(RGB6,3,2)))
			File0.WriteUChar(HexToDec(SubStr(RGB6,5,2)))
			}
	File0.Close()
}

CreateColorPicker(hwnd){
	Global
	Click
	MouseGetPos,,, OutputVarWin, OutputVarControl
	If (OutputVarWin=hwnd)
		{
		If (OutputVarControl="Edit3")
			{
			GuiControlGet, RGB2, 1:, Control_7
			SetFormat IntegerFast, Hex
			Colors:=[0x00FF00, 0x009797, "0x" RGB2, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0xFF6597]
			RGB2:=ChooseColor("0x" RGB2, hwnd, , , Colors*)
			StringTrimLeft, RGB2, RGB2, 2
			RGB2:=SubStr("000000" RGB2,-5)
			SetFormat, IntegerFast, d
			GuiControl,1:, Control_7, %RGB2%
			CtlColors.Change(hControl_6,RGB2,"")
			}
		Else If (OutputVarControl="Edit7")
			{
			GuiControlGet, RGB4, 1:, Control_14
			SetFormat IntegerFast, Hex
			Colors:=[0x00FF00, 0x009797, "0x" RGB4, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0xFF6597]
			RGB4:=ChooseColor("0x" RGB4, hwnd, , , Colors*)
			StringTrimLeft, RGB4, RGB4, 2
			RGB4:=SubStr("000000" RGB4,-5)
			SetFormat, IntegerFast, d
			GuiControl,1:, Control_14, %RGB4%
			CtlColors.Change(hControl_13,RGB4,"")
			}
		Else If (OutputVarControl="Edit11")
			{
			GuiControlGet, RGB6, 1:, Control_21
			SetFormat IntegerFast, Hex
			Colors:=[0x00FF00, 0x009797, "0x" RGB6, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0x000000, 0xFF6597]
			RGB6:=ChooseColor("0x" RGB6, hwnd, , , Colors*)
			StringTrimLeft, RGB6, RGB6, 2
			RGB6:=SubStr("000000" RGB6,-5)
			SetFormat, IntegerFast, d
			GuiControl,1:, Control_21, %RGB6%
			CtlColors.Change(hControl_20,RGB6,"")
			}
		}
}

DecToHex(value){
	SetFormat, IntegerFast, Hex
	value+=0
	value.=""
	SetFormat, IntegerFast, d
	StringTrimLeft, value, value, 2
	value:=SubStr("00" value,-1)
	Return value
}

HexToDec(value){
	value:="0x" value
	SetFormat, IntegerFast, d
	value+=0
	value.=""
	Return value
}

GoHandler(ControlID){
	Global
	If(ControlID="Control_7")
		{
		GuiControlGet, RGB2, 1:, Control_7
		If (StrLen(RGB2)=6)
			CtlColors.Change(hControl_6,RGB2,"")
		Return
		}
	Else If(ControlID="Control_14")
		{
		GuiControlGet, RGB4, 1:, Control_14
		If (StrLen(RGB4)=6)
			CtlColors.Change(hControl_13,RGB4,"")
		Return
		}
	Else If(ControlID="Control_21")
		{
		GuiControlGet, RGB6, 1:, Control_21
		If (StrLen(RGB6)=6)
			CtlColors.Change(hControl_20,RGB6,"")
		Return
		}
	Else If(ControlID="Control_22")
		{
		WriteColors(PS_EXE)
		GoSub, Reload
		Return
		}
}

About(){
	Global
	Gui,2:Default
	Gui,2:+HwndhGui2
	Gui,2:-SysMenu
	Gui,2:Font, S15 w700, Verdana
	Gui,2:Add, Text, x0 y20 w480 h30 +Center cWhite, %PS_BaseFilename% %PS_Version%
	Gui,2:Font, S10 w700, Verdana
	Gui,2:Add, Text, x7 y50 w460 h40 +Center cWhite, BAMWorkshop Configuration Utility
	Gui,2:Add, Text, x97 y90 w280 h20 +Center cWhite, Copyright © 2014 Sam Schmitz
	IcoPath:=(A_IsCompiled ? A_ScriptFullPath : PS_EXE)
	Gui,2:Add, Picture, x36 y50, %IcoPath%
	Gui,2:Font, S8, Verdana
	Gui,2:Add, Edit, x10 y120 w460 h300 +Center cWhite -TabStop ReadOnly, This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.`n`nThis program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License at <http://www.gnu.org/licenses/> for more details.`n`nYou may contact Sam Schmitz at <sampsca@yahoo.com> or by sending a PM to Sam. at <http://www.shsforums.net/index.php?showuser=10485>.`n`nCtlColors v1.0.02.00, Copyright © just me`n`nColorPickerPlus v7-2-2013, Copyright © rbrtryn`n`nFileGetVersionInfo, Copyright © SKAN
	Gui,2:Add, Button, x188 y430 w100 h30 +Default gControl_B1, OK
	Gui,2:Color, 000000
	Gui,2:Show, w480 h470, About
	
	Return hGui2
}

;;;;; Subroutines ;;;;;
OnExit:
GuiClose:
	CtlColors.Free()
	ExitApp
Return

GuiSize:
   If (A_EventInfo != 1) {
      Gui, %A_Gui%:+LastFound
      WinSet, ReDraw
   }
Return

Reload:
	Reload
Return

CreateColorPicker:
	CreateColorPicker(hGui1)
Return

GoHandler:
	GoHandler(A_GuiControl)
Return

2GuiClose:
Control_B1:
	Gui,2:Destroy
Return

#Include Class_CtlColors.ahk
#Include ColorPickerPlus.ahk
#Include FileGetVersionInfo.ahk