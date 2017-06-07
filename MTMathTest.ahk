#Include %A_ScriptDir%\MTMath.ahk

;test is array with {xx1,yx1,xx2,yx2,xy1,yy1,xy2,yy2}
;				   0   1   2   3   4   5   6   7
test := Object()
test[0] := 0
test[1] := 0
test[2] := 1
test[3] := -1
test[4] := 0
test[5] := 0
test[6] := 1
test[7] := 2
o := origin(test)
d := Object()
d[0] := 2
d[1] := 2
d[2] := 1.41421356237
d[3] := 2.2360679775
r := compute(test,o,d)
MsgBox % "(" . r[0] . "," r[1] . ")" . " Err:" . r[2]
d[0] := -2
d[1] := -0
r := compute(test,o,d)
MsgBox % "(" . r[0] . "," r[1] . ")" . " Err:" . r[2]