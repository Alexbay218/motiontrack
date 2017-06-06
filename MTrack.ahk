#Include %A_ScriptDir%\MTMath.ahk

;init and gui
SetWorkingDir, %A_ScriptDir%
videoName = %A_WorkingDir%\video\video.mov
trackerName = %A_WorkingDir%\track\track.png
Data := Object()
Loop, Read, %A_ScriptDir%\log\log.csv
{
    Data.Insert(A_LoopReadLine)
}
Gui, New,,Motion Tracker
Gui, Add, Button,gVideoSelect,Select Video
Gui, Add, Button,gViewVideo,View Video
Gui, Add, Button,gTrackerSelect,Select Tracker
Gui, Add, Slider,vCV AltSubmit Line1 gUp Range0-255,
CUP := "Color Variation: " . CV
Gui, Add, Text,vSCV,%CUP%%CUP%
GuiControl, Text,SCV,%CUP%0
Gui, Add, Button,gProcess,Start
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
StartTime := A_TickCount
while(WinActive(videoNameFO . " - VLC media player"))
{
	WinGetPos, WinX, WinY, WinWidth, WinHeight
	upB := 52
	downB := WinHeight-57
	MouseGetPos, OutputVarX, OutputVarY
	ROutputVarY := WinHeight-57-OutputVarY
	ToolTip, %OutputVarX% x %ROutputVarY%, OutputVarX+30, OutputVarY+30
}
WinClose, VLC media player
Return

TrackerSelect:
FileSelectFile, tmp
trackerName := tmp
Return

Process:
;opening videoName
Run, %A_WorkingDir%\player\vlc.exe %videoName%
FileDelete, %A_WorkingDir%\log\log.txt
FileDelete, %A_WorkingDir%\log\log.csv
FileAppend, Time`,DataX`,DataY`n,%A_WorkingDir%\log\log.csv

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
	FileAppend, %element%,%A_WorkingDir%\log\log.csv
}
Progress, Off
Return

GuiClose:
ExitApp
Return