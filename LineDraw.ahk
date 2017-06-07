;Credit to AHKLerner on the AHK forums
Blank = 008080
Black    = 000000
Green    = 008000
Silver    = C0C0C0
Lime       = 00FF00
Gray       = 808080
Olive       = 808000
White    = FFFFFF
Yellow    = FFFF00
Maroon    = 800000
Navy    = 000080
Red       = FF0000
Blue       = 0000FF
Purple    = 800080
Teal       = 008080
Fuchsia    = FF00FF
Aqua    = 00FFFF

Canvas_DrawLine(hWnd, p_x1, p_y1, p_x2, p_y2, p_w, p_color) ; r,angle,width,color)
   {
   p_x1 -= 1, p_y1 -= 1, p_x2 -= 1, p_y2 -= 1
   hDC := DllCall("GetDC", UInt, hWnd)
   hCurrPen := DllCall("CreatePen", UInt, 0, UInt, p_w, UInt, Convert_BGR(p_color))
   DllCall("SelectObject", UInt,hdc, UInt,hCurrPen)
   DllCall("gdi32.dll\MoveToEx", UInt, hdc, Uint,p_x1, Uint, p_y1, Uint, 0 )
   DllCall("gdi32.dll\LineTo", UInt, hdc, Uint, p_x2, Uint, p_y2 )
   DllCall("ReleaseDC", UInt, 0, UInt, hDC)  ; Clean-up.
   DllCall("DeleteObject", UInt,hCurrPen)
   }

   
Convert_BGR(RGB)
   {
   StringLeft, r, RGB, 2
   StringMid, g, RGB, 3, 2
   StringRight, b, RGB, 2
   Return, "0x" . b . g . r
   }