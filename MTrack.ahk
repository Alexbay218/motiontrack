#Include %A_ScriptDir%\MTMath.ahk
#Include %A_ScriptDir%\LineDraw.ahk

;init and gui
SetWorkingDir, %A_ScriptDir%
videoName = %A_WorkingDir%\video\video.mov
trackerName = %A_WorkingDir%\track\track.png
disableClick := 0
recordedX := -100
recordedY := -100
Gui, Main:New,,Motion Tracker
Gui, Add, Button,gVideoSelect,Select Video
Gui, Add, Button,gViewVideo,View Video
Gui, Add, Button,gTrackerSelect,Select Tracker
Gui, Add, Slider,vCV AltSubmit Line1 gUp Range0-255,
CUP := "Color Variation: " . CV
Gui, Add, Text,vSCV,%CUP%%CUP%
GuiControl, Text,SCV,%CUP%0
Gui, Add, Button,gProcess,Log Raw
Gui, Add, Button,gScaleVideo,Scale Processing
Gui, Show
Return

Up:
CUP := "Color Variation: " . CV
GuiControl, Text,SCV,%CUP%
Return

VideoSelect:
FileSelectFile, tmp
videoName := tmp
Return

ViewVideo:
Run, %A_WorkingDir%\player\vlc.exe %videoName%
StringGetPos, LastSlashPos, videoName,\,R
videoNameFO := SubStr(videoName,LastSlashPos+2)
WinWaitActive, %videoNameFO% - VLC media player
while(WinActive(videoNameFO . " - VLC media player"))
{
	WinGetPos, WinX, WinY, WinWidth, WinHeight
	upB := 52
	downB := WinHeight-57
	MouseGetPos, OutputVarX, OutputVarY
	ROutputVarY := WinHeight-57-OutputVarY
	ToolTip, %OutputVarX% x %ROutputVarY%, OutputVarX+30, OutputVarY+30
}
ToolTip,
WinClose, VLC media player
Return

ScaleVideo:
Run, %A_WorkingDir%\player\vlc.exe %videoName%
StringGetPos, LastSlashPos, videoName,\,R
videoNameFO := SubStr(videoName,LastSlashPos+2)
WinWaitActive, %videoNameFO% - VLC media player
Sleep, 1000
Send {Space}
WinGetPos, WinX, WinY, WinWidth, WinHeight
Gui, 1:+LastFound +AlwaysOnTop +ToolWindow
Gui, 1:-Caption
Gui, 1:Color, 008080
WinSet, TransColor, 008080
GuiHwnd := WinExist()
Gui, 1:Show, X%WinX% Y%WinY% W%WinWidth% H%WinHeight%
disableClick := 1
currentPointCount := 0
cRecordedX := recordedX
cRecordedY := recordedY
p := Object()
while(currentPointCount < 4)
{
	WinGetPos, WinX, WinY, WinWidth, WinHeight
	MouseGetPos, OutputVarX, OutputVarY
	ROutputVarY := WinHeight-57-OutputVarY
	if((cRecordedX != recordedX) && (cRecordedY != recordedY) && currentPointCount < 4)
	{
		p[currentPointCount*2] := recordedX
		p[currentPointCount*2+1] := WinHeight-57-recordedY
		cRecordedX := recordedX
		cRecordedY := recordedY
		currentPointCount := currentPointCount+1
	}
	if(currentPointCount == 1) {
		WinSet, Redraw,, ahk_id %GuiHwnd%
		Canvas_DrawLine(GuiHwnd, p[0], WinHeight-57-p[1], OutputVarX, OutputVarY, 3, Red)
	}
	if(currentPointCount == 2) {
		WinSet, Redraw,, ahk_id %GuiHwnd%
		Canvas_DrawLine(GuiHwnd, p[0], WinHeight-57-p[1], p[2], WinHeight-57-p[3], 3, Red)
	}
	if(currentPointCount == 3) {
		WinSet, Redraw,, ahk_id %GuiHwnd%
		Canvas_DrawLine(GuiHwnd, p[0], WinHeight-57-p[1], p[2], WinHeight-57-p[3], 3, Red)
		Canvas_DrawLine(GuiHwnd, p[4], WinHeight-57-p[5], OutputVarX, OutputVarY, 3, Blue)
	}
	ToolTip, %OutputVarX% x %ROutputVarY% Point:%currentPointCount%, OutputVarX+30, OutputVarY+30
}
Canvas_DrawLine(GuiHwnd, p[0], WinHeight-57-p[1], p[2], WinHeight-57-p[3], 3, Red)
Canvas_DrawLine(GuiHwnd, p[4], WinHeight-57-p[5], p[6], WinHeight-57-p[7], 3, Blue)
Gui, Input:New,,Input
Gui, 1:-AlwaysOnTop
Gui, Input:-Caption +AlwaysOnTop
Gui, Add, Text, cRed, X-Axis Length
Gui, Add, Edit, vXL
Gui, Add, Text, cBlue, Y-Axis Length
Gui, Add, Edit, vYL
Gui, Add, Button,gScaleProcess, Process
Gui, Show
disableClick := 0
ToolTip,
Return

ScaleProcess:
Gui, 1:Destroy
Gui, Input:Submit
WinClose, VLC media player
inLogT := Object()
inLogX := Object()
inLogY := Object()
ArrayCount := -1                        
Loop, Read, %A_ScriptDir%\log\logRaw.csv
{
	str := A_LoopReadLine
	StringGetPos, comma1, str, `,
	StringGetPos, comma2, str, `,,R
	inLogT[ArrayCount] := SubStr(str, 1, comma1)
	inLogX[ArrayCount] := SubStr(str, comma1+2,comma2-comma1-1)
	inLogY[ArrayCount] := SubStr(str, comma2+2)
	ArrayCount += 1
}
out := inLogT[0] . "|" . inLogX[0] . "|" . inLogY[0]
MsgBox, %out%
Return

TrackerSelect:
FileSelectFile, tmp
trackerName := tmp
Return

Process:
;opening videoName
Run, %A_WorkingDir%\player\vlc.exe %videoName%
FileDelete, %A_WorkingDir%\log\logRaw.csv
FileAppend, Time`,DataX`,DataY`n,%A_WorkingDir%\log\logRaw.csv

;start logging
StringGetPos, LastSlashPos, videoName,\,R
videoNameFO := SubStr(videoName,LastSlashPos+2)
WinWaitActive, %videoNameFO% - VLC media player
StartTime := A_TickCount
Data := Object()
while(WinActive(videoNameFO . " - VLC media player"))
{
	WinGetPos, WinX, WinY, WinWidth, WinHeight
	downB := WinHeight-57
	ImageSearch, OutputVarX, OutputVarY, 5, 52,%WinWidth%,%downB%,*%CV% %trackerName%
	ROutputVarY := WinHeight-57-OutputVarY
	if ErrorLevel = 2
		ToolTip, Error!,0,0
	else if ErrorLevel = 1
		ToolTip, Tracker Not Found,0,0
	else
	{
		currentTime := round((A_TickCount - StartTime)/1000,3)
		ToolTip, %currentTime%:%OutputVarX% x %ROutputVarY%, OutputVarX+30, OutputVarY+30
		in = %currentTime%: %OutputVarX%`, %ROutputVarY%`n
		inCSV =%currentTime%`,%OutputVarX%`,%ROutputVarY%`n
		Data.Insert(inCSV)
	}
}
;post gathering
ToolTip,
WinClose, VLC media player
for index, element in Data
{
	percent := ceil(((index+1)/Data.length())*100)
	Progress, %percent%, Processing...
	FileAppend, %element%,%A_WorkingDir%\log\logRaw.csv
}
Progress, Off
Return

#if disableClick = 1
LButton::
MouseGetPos, recordedX, recordedY
Return
#if

Esc::
GuiClose:
WinClose, VLC media player
WinClose, %videoNameFO% - VLC media player
ExitApp
Return