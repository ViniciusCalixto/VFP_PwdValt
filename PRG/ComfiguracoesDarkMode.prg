Procedure setarVariaveisDarkMode
	Public xDarkMode, xBackColor, xBorderColor, ;
		xForeColor, xMouseEnterBackColor, xBackColorForm, ;
		xBorderColorLine, xBackColorScreen, ;
		xDisabledForeColor, xDisabledBackColor, xBorderColorLineText



	*
	xDarkMode = File(Addbs(Sys(2003)) + 'DarkMode.txt')

	xBackColorScreen		= Iif(xDarkMode, '128,128,128', '237,157,157')
	xBackColor 	 			= Iif(xDarkMode, '50,50,50', '223,95,95')
	xBorderColor 			= Iif(xDarkMode, '50,50,50', '223,95,95')
	xForeColor	 			= Iif(xDarkMode, '255,255,255', '0,0,0')

	xDisabledBackColor 		= Iif(xDarkMode, '100,100,100', '235,152,152') &&'192,192,192'
	xDisabledForeColor	 	= Iif(xDarkMode, '192,192,192', '128,128,128')

	xMouseEnterBackColor 	= Iif(xDarkMode, '192,192,192','235,152,152')

	xBackColorForm 			= Iif(xDarkMode, '80,80,80', '255,255,255')
	xBorderColorLine		= Iif(xDarkMode,  '192,192,192','235,152,152')
	xBorderColorLineText	= Iif(xDarkMode,  '192,192,192','235,152,152')
Endproc
