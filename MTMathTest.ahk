#Include %A_ScriptDir%\MTMath.ahk

;d is array with {xx1,yx1,xx2,yx2,xy1,yy1,xy2,yy2}
;				   0   1   2   3   4   5   6   7
test := Object()
test[0] := -5
test[1] := -5
test[2] := 5
test[3] := 5
test[4] := -5
test[5] := 5
test[6] := 5
test[7] := -5
o := origin(test)
d := Object()
d[0] := 1
d[1] := 0
d[2] := 1
d[3] := 1.4142
r := compute(test,o,d)
MsgBox % "(" . r[0] . "," r[1] . ")" . " Err:" . r[2]