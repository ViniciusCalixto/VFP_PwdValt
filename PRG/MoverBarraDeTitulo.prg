
Function MoverBarraDeTitulo
	Lparameters oform, nButton, nShift, nXCoord, nYCoord
	#Define WM_SYSCOMMAND 0x112
	#Define WM_LBUTTONUP 0x202
	#Define MOUSE_MOVE 0xf012


	Declare Long ReleaseCapture In WIN32API
	Declare Long SendMessage In WIN32API ;
		Long HWnd, Long wMsg, Long wParam, Long Lparam


	If nButton = 1 		&& LMB
		= ReleaseCapture()
		* Complete left click by sending 'left button up' message
		= SendMessage(oform.HWnd, WM_LBUTTONUP, 0x0, 0x0)
		* Initiate Window Move
		= SendMessage(oform.HWnd, WM_SYSCOMMAND, MOUSE_MOVE, 0x0)
	Endif
Endfunc
