compute(d,o,p)
{
	;d is array with {xx1,yx1,xx2,yx2,xy1,yy1,xy2,yy2}
	;				  0   1   2   3   4   5   6   7
	;if err is -1, unsolvable
	;o is array with (xo,yo,err)
	;				  0  1  2
	;p is array with {xt,yt,xsf,ysf}
	;				  0  1  2   3
	;return array with {xs,ys,err}
	;					0  1  2
	;if err is -1, unsolvable
	dl := d.length()
	Loop %dl%
	{
		d[A_Index] := -d[A_Index] ;Negating all values for some reason
	}
	r := Object()
	r[2] := 0
	mx := (d[3]-d[1])/(d[2]-d[0])
	my := (d[7]-d[5])/(d[6]-d[4])
	disto := Abs(Sqrt((o[0]-p[0])**2+(o[1]-p[1])**2))
	distx := Abs(Sqrt((d[0]-p[0])**2+(d[1]-p[1])**2))
	disox := Abs(Sqrt((d[0]-o[0])**2+(d[1]-o[1])**2))
	disty := Abs(Sqrt((d[4]-p[0])**2+(d[5]-p[1])**2))
	disoy := Abs(Sqrt((d[4]-o[0])**2+(d[5]-o[1])**2))
	thetax := Acos((disto**2+disox**2-distx**2)/(2*disto*disox))
	thetay := Acos((disto**2+disoy**2-disty**2)/(2*disto*disoy))
	r[0] := -Cos(thetax)*disto*p[2]
	r[1] := Cos(thetay)*disto*p[3]
	
	return r
}

origin(d)
{
	;d is array with {xx1,yx1,xx2,yx2,xy1,yy1,xy2,yy2}
	;				  0   1   2   3   4   5   6   7
	;return array with {xo,yo,err}
	;					0  1  2
	;if err is -1, unsolvable
	r := Object()
	r[2] := 0
	mx := (d[3]-d[1])/(d[2]-d[0])
	my := (d[7]-d[5])/(d[6]-d[4])
	if(mx == my)
	{
		r[0] := 0
		r[1] := 0
		r[2] := -1
		return r
	} else if(d[2]-d[0] == 0)
	{
		r[0] := d[0]
		if(d[7]-d[5] == 0)
		{
			r[1] := d[5]
		}
		else
		{
			r[1] := my*(r[0]-d[4])+d[5]
		}
		r[2] := 1
	} else if(d[3]-d[1] == 0)
	{
		r[1] := d[1]
		if(d[6]-d[4] == 0)
		{
			r[0] := d[4]
		}
		else
		{
			r[0] := ((r[1]-d[5])/my)+d[4]
		}
		r[2] := 2
	} else if(d[6]-d[4] == 0)
	{
		r[0] := d[4]
		if(d[3]-d[1] == 0) 
		{
			r[1] := d[1]
		}
		else
		{
			r[1] := ((r[1]-d[1])/mx)+d[0]
		}
		r[2] := 3
	} else if(d[7]-d[5] == 0)
	{
		r[1] := d[5]
		if(d[2]-d[0] == 0)
		{
			r[0] := d[0]
		}
		else
		{
			r[0] := mx*(r[0]-d[0])+d[1]
		}
		r[2] := 4
	} else 
	{
		r[0] := ((my*d[4])-(mx*d[0])+d[1]-d[5])/(my-mx)
		r[1] := mx*(r[0]-d[0])+d[1]
		r[2] := 5
	}
	return r
}