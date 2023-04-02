Function FecharSistema
	Local llRetorno
	llRetorno = .F.
	llRetorno = Messagebox("Deseja realmente sair?", 32 + 4 ,"Atenção!") == 6
	Return llRetorno
Endfunc

Procedure Sair
	*On Shutdown
	Clear Events
	Close All
	Quit
Endproc





Procedure ExecutarSemRestricoes
	Lparameter lcComando, lcAcao, lcParams

	lcAcao = Iif(Empty(lcAcao), "Open", lcAcao)
	lcParams = Iif(Empty(lcParams), "", lcParams)

	Declare Integer ShellExecute ;
		IN SHELL32.Dll ;
		INTEGER nWinHandle, ;
		STRING cOperation, ;
		STRING cFileName, ;
		STRING cParameters, ;
		STRING cDirectory, ;
		INTEGER nShowWindow

	Declare Integer FindWindow ;
		IN WIN32API ;
		STRING cNull,String cWinName

	Return ShellExecute(FindWindow(0, _Screen.Caption), ;
		lcAcao, lcComando, ;
		lcParams, Sys(2023), 1)
Endproc

Function GerarCaracteresAleatorios
	Lparameters lnQTDChar

	lnQTDChar = Iif(Upper(Alltrim(Vartype(lnQTDChar))) == 'N' and lnQTDChar > 0, lnQTDChar, 1)

	Local m.lcString, m.lnPassLength
	m.lcString 		= ""
	m.lnPassLength 	= lnQTDChar

	For i = 1 To lnPassLength
		m.lnRandom = Rand() * 94 + 33
		m.lcString = m.lcString + Chr(m.lnRandom)
	Endfor

	Return lcString
Endfunc
