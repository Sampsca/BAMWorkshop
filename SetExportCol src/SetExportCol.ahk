; <COMPILER: v1.0.48.5>
#SingleInstance, Force
#NoTrayIcon

filename = %A_WorkingDir%\BAMWorkshop.exe

AllOver:

AutoTrim, Off

BinRead(filename, rgb, 3, 0x17f22)




TextBackgroundColor := 0xFFFFFF
TextBackgroundBrush := DllCall("CreateSolidBrush", UInt, TextBackgroundColor)

Gui, Add, Button, x46 y72 w110 h30 gchangeme, Change
Gui, Add, Edit, x56 y12 w110 h20 vrgb Center ReadOnly, %rgb%
Gui, Add, Edit, x56 y42 w110 h20 Center vnewrgb gblue, %rgb%
Gui, Add, Edit, x20 y42 w20 h20 HwndMyTextHwnd,
Gui, Add, Text, x6 y12 w40 h20 , Current:
Gui +LastFound
GuiHwnd := WinExist()

   WindowProcNew := RegisterCallback("WindowProc", ""
       , 4, MyTextHwnd)
   WindowProcOld := DllCall("SetWindowLong", UInt, GuiHwnd, Int, -4
       , Int, WindowProcNew, UInt)

Gui, Show, xCenter yCenter h112 w205, .gif export shadow

GuiControlGet, pppp, , newrgb
SwapOrder(pppp)
pppp = 0x%pppp%
SetBgColor( 1 )


Return

GuiClose:
ExitApp

changeme:
Gui, Submit
Gui, Destroy






   BinWrite(filename, newrgb, 3, 0x17f22)






Goto Allover
ExitApp




blue:
GuiControlGet, pppp, , newrgb
SwapOrder(pppp)
pppp = 0x%pppp%
SetBgColor( 1 )
return

SetBgColor( bg )
{
   Global
   TextBackgroundColor := pppp
   TextBackgroundBrush := DllCall("CreateSolidBrush", UInt, TextBackgroundColor)
   Winset, Redraw
}

WindowProc(hwnd, uMsg, wParam, lParam)
{
    Critical
    global TextBackgroundColor, TextBackgroundBrush, WindowProcOld
    if (uMsg = 0x133 && lParam = A_EventInfo)
    {
        DllCall("SetBkColor", UInt, wParam, UInt, TextBackgroundColor)
        return TextBackgroundBrush
    }

    return DllCall("CallWindowProcA", UInt, WindowProcOld, UInt, hwnd, UInt, uMsg, UInt, wParam, UInt, lParam)
}





for(ByRef LoopVariable, start, stop, ByRef step)
{
    if (!step)
        step := (start <= stop ? 1 : -1)

    LoopVariable := start

    return floor((stop - start) / step) + 1
}


DecToHex(ByRef value)
{
      SetFormat, IntegerFast, hex
      value += 0
      value .= ""
      SetFormat, IntegerFast, d
}

HexToDec(ByRef value)
{
value = 0x%value%
      SetFormat, IntegerFast, d
      value += 0
      value .= ""
      SetFormat, IntegerFast, d
}

PrepareOffset(ByRef position)
{
 IfLess, position, 0
 {
 position := position + 0x10000
 }
DecToHex(position)
SwapOrder(position)
StringTrimRight, position, position, 2
StringLen, lingth, position
IfEqual, lingth, 2
position = %position%00
}



SwapOrder(ByRef string)
{
StringLen, lingth, string
IfEqual, lingth, 1
{
StringTrimLeft, string, string, 2
string = 0x0%string%
lingth++
}
IfEqual, lingth, 3
{
StringTrimLeft, string, string, 2
string = 0x0%string%
lingth++
}
fetch := lingth - 1
lingth := lingth / 2
compile=
Loop %lingth%
{
StringMid, fetchbyte, string, %fetch%, 2
compile = %compile%%fetchbyte%
fetch := fetch - 2
}
string = %compile%
}




BinWrite(file, data, n=0, offset=0)
{

   h := DllCall("CreateFile","str",file,"Uint",0x40000000,"Uint",0,"UInt",0,"UInt",4,"Uint",0,"UInt",0)
   IfEqual h,-1, SetEnv, ErrorLevel, -1
   IfNotEqual ErrorLevel,0,Return,0

   m = 0
   IfLess offset,0, SetEnv,m,2
   r := DllCall("SetFilePointerEx","Uint",h,"Int64",offset,"UInt *",p,"Int",m)
   IfEqual r,0, SetEnv, ErrorLevel, -3
   IfNotEqual ErrorLevel,0, {
      t = %ErrorLevel%
      DllCall("CloseHandle", "Uint", h)
      ErrorLevel = %t%
      Return 0
   }

   TotalWritten = 0
   m := Ceil(StrLen(data)/2)
   If (n <= 0 or n > m)
       n := m
   Loop %n%
   {
      StringLeft c, data, 2
      StringTrimLeft data, data, 2
      c = 0x%c%
      result := DllCall("WriteFile","UInt",h,"UChar *",c,"UInt",1,"UInt *",Written,"UInt",0)
      TotalWritten += Written
      if (!result or Written < 1 or ErrorLevel)
         break
   }

   IfNotEqual ErrorLevel,0, SetEnv,t,%ErrorLevel%

   h := DllCall("CloseHandle", "Uint", h)
   IfEqual h,-1, SetEnv, ErrorLevel, -2
   IfNotEqual t,,SetEnv, ErrorLevel, %t%

   Return TotalWritten
}


BinRead(file, ByRef data, n=0, offset=0)
{
   h := DllCall("CreateFile","Str",file,"Uint",0x80000000,"Uint",3,"UInt",0,"UInt",3,"Uint",0,"UInt",0)
   IfEqual h,-1, SetEnv, ErrorLevel, -1
   IfNotEqual ErrorLevel,0,Return,0

   m = 0
   IfLess offset,0, SetEnv,m,2
   r := DllCall("SetFilePointerEx","Uint",h,"Int64",offset,"UInt *",p,"Int",m)
   IfEqual r,0, SetEnv, ErrorLevel, -3
   IfNotEqual ErrorLevel,0, {
      t = %ErrorLevel%
      DllCall("CloseHandle", "Uint", h)
      ErrorLevel = %t%
      Return 0
   }

   TotalRead = 0
   data =
   IfEqual n,0, SetEnv n,0xffffffff

   format = %A_FormatInteger%
   SetFormat Integer, Hex

   Loop %n%
   {
      result := DllCall("ReadFile","UInt",h,"UChar *",c,"UInt",1,"UInt *",Read,"UInt",0)
      if (!result or Read < 1 or ErrorLevel)
         break
      TotalRead += Read
      c += 0
      StringTrimLeft c, c, 2
      c = 0%c%
      StringRight c, c, 2
      data = %data%%c%
   }

   IfNotEqual ErrorLevel,0, SetEnv,t,%ErrorLevel%

   h := DllCall("CloseHandle", "Uint", h)
   IfEqual h,-1, SetEnv, ErrorLevel, -2
   IfNotEqual t,,SetEnv, ErrorLevel, %t%

   SetFormat Integer, %format%
   Totalread += 0
   Return TotalRead
}

