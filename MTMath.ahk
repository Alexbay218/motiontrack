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
	r := Object()
	r[2] := 0
	tmp := Object()
	rc := 0
	rm := d.length()
	while(rc <= rm)
	{
		tmp[rc] := d[rc]
		rc := rc+1
	}
	mx := (d[3]-d[1])/(d[2]-d[0])
	my := (d[7]-d[5])/(d[6]-d[4])
	if(d[7]-d[5] == 0)
	{
		tmp[0] := p[0]
		tmp[1] := p[1]
		tmp[2] := p[0]
		tmp[3] := p[1]+10
		r[2] := 1
	} else if(d[6]-d[4] == 0)
	{
		tmp[0] := p[0]
		tmp[1] := p[1]
		tmp[2] := p[0]+10
		tmp[3] := p[1]
		r[2] := 2
	} else
	{
		tmp[0] := p[0]
		tmp[1] := p[1]
		tmp[2] := p[0]+10
		tmp[3] := p[1]+(mx*10)
		r[2] := 3
	}
	px := origin(tmp)
	rc := 0
	rm := d.length()
	while(rc <= rm)
	{
		tmp[rc] := d[rc]
		rc := rc+1
	}
	if(d[3]-d[1] == 0)
	{
		tmp[4] := p[0]
		tmp[5] := p[1]
		tmp[6] := p[0]
		tmp[7] := p[1]+10
		r[2] := r[2] . "1"
	} else if(d[2]-d[0] == 0)
	{
		tmp[4] := p[0]
		tmp[5] := p[1]
		tmp[6] := p[0]+10
		tmp[7] := p[1]
		r[2] := r[2] . "2"
	} else
	{
		tmp[4] := p[0]
		tmp[5] := p[1]
		tmp[6] := p[0]+10
		tmp[7] := p[1]+(my*10)
		r[2] := r[2] . "3"
	}
	py := origin(tmp)
	r[1] := Sqrt((o[0]-px[0])**2+(o[1]-px[1])**2)*(p[3]/Sqrt((d[4]-d[6])**2+(d[5]-d[7])**2))
	r[0] := Sqrt((o[0]-py[0])**2+(o[1]-py[1])**2)*(p[2]/Sqrt((d[0]-d[2])**2+(d[1]-d[3])**2))
	rc := 0
	rm := d.length()
	while(rc <= rm)
	{
		tmp[rc] := d[rc]
		rc := rc+1
	}
	if(d[3]-d[1] == 0) 
	{
		if((o[0] < py[0] && d[2] < d[0]) || (o[0] > py[0] && d[2] > d[0]))
		{
			r[0] := -r[0]
		}
	} 
	else
	{
		if((o[1] < py[1] && d[3] < d[1]) || (o[1] > py[1] && d[3] > d[1]))
		{
			r[0] := -r[0]
		}
	}
	if(d[7]-d[5] == 0) 
	{
		if((o[0] < px[0] && d[6] < d[4]) || (o[0] > px[0] && d[6] > d[4]))
		{
			r[1] := -r[1]
		}
	} 
	else
	{
		if((o[1] < px[1] && d[7] < d[5]) || (o[1] > px[1] && d[7] > d[5]))
		{
			r[1] := -r[1]
		}
	}
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
			r[1] := mx*(r[0]-d[0])+d[1]
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
			r[0] := ((r[1]-d[1])/mx)+d[0]
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